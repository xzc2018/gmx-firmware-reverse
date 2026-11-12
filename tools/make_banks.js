#!/usr/bin/env node
// Assemble the 8 Flash banks from roms/ (layout.json + pages) and the FPGA bitstreams.
//   node tools/make_banks.js [--roms roms] [--bitstream bitstream] [--out banks] [--keepboot] [--variant cbr]
// Bank 0: boot block + 6 scheme blocks (bitstream padded with 0xFF to 0x1FE6, date, port values, name, CRC16)
// + service library; the scheme CRCs, the library CRC and the page-0 CRC (0x000E) are recomputed.
// Bitstreams are looked up as <bitstream dir>/<name>.rbf, else <name>.ttf (MAX+PLUS II output).
// --keepboot: scheme blocks of page 0 (0x0000-0x3FFF, the Flash boot block: loader and Start Sch) take the
// original bitstream fpga/<design>/<design>_original.rbf, so page 0 and its CRC are identical to gmx12501.rom.
// --variant cbr: bitstreams <design>_cbr.rbf (compile.js --cbr) instead of <design>.rbf.
'use strict';
const fs = require('fs');
const path = require('path');
const G = require('./lib/gmx');

function loadBitstream(dir, name) {
  const base = path.join(dir, name.replace(/\.rbf$/i, ''));
  let buf;
  if (fs.existsSync(base + '.rbf')) buf = fs.readFileSync(base + '.rbf');
  else if (fs.existsSync(base + '.ttf')) buf = G.readTtf(base + '.ttf');
  else G.die(`bitstream ${name}: neither ${G.rel(base)}.rbf nor .ttf found (run tools/compile.js first)`);
  if (buf.length > G.BITSTREAM_MAX) G.die(`${name}: ${buf.length} bytes, more than 0x1FE6`);
  if (buf.subarray(0, 4).toString('hex') !== 'ffff6f34') G.die(`${name}: not an EPF8452A bitstream`);
  return buf;
}

function schemeBlock(sc, bs) {
  const blk = Buffer.alloc(G.SCHEME_BLOCK, 0xFF);
  bs.copy(blk, 0);
  const field = (at, len, s) => {
    const b = Buffer.from(s, 'latin1');
    if (b.length > len) G.die(`scheme ${sc.number}: "${s}" longer than ${len}`);
    blk.fill(0x20, at, at + len); b.copy(blk, at);
  };
  field(0x1FE6, 8, sc.date);
  blk[0x1FEE] = G.num(sc.port_xx00);
  blk[0x1FEF] = G.num(sc.port_7EFD);
  field(0x1FF0, 10, sc.name);
  blk.writeUInt16LE(G.crc16(blk.subarray(0, 0x1FFA)), 0x1FFA);
  Buffer.from(sc.tail || '00000000', 'hex').copy(blk, 0x1FFC);
  return blk;
}

function main() {
  const a = G.args();
  const roms = path.resolve(a.roms || path.join(G.ROOT, 'roms'));
  const bsdir = path.resolve(a.bitstream || path.join(G.ROOT, 'bitstream'));
  const out = path.resolve(a.out || path.join(G.ROOT, 'banks'));
  const layout = G.readJson(path.join(roms, 'layout.json'));
  fs.mkdirSync(out, { recursive: true });
  for (const f of fs.readdirSync(out)) if (f.endsWith('.bin')) fs.rmSync(path.join(out, f));
  for (const b of layout.banks) {
    const bank = Buffer.alloc(G.BANK, 0xFF);
    if (b.parts) {
      for (const p of b.parts) {
        const at = G.num(p.at);
        let data;
        if (p.file) data = fs.readFileSync(path.join(roms, p.file));
        else {
          const keep = a.keepboot && b.bank === 0 && at < G.PAGE;
          const design = p.scheme.bitstream.replace(/\.rbf$/i, '');
          const src = keep ? path.join(G.ROOT, 'fpga', design, `${design}_original.rbf`) : null;
          const bsname = a.variant ? `${design}_${a.variant}.rbf` : p.scheme.bitstream;
          const bs = keep ? loadBitstream(path.dirname(src), path.basename(src)) : loadBitstream(bsdir, bsname);
          data = schemeBlock(p.scheme, bs);
          console.log(`  scheme ${p.scheme.number} ${p.scheme.name.padEnd(10)} @${p.at} <- ` +
            `${keep ? G.rel(src) : bsname}  CRC ${G.hex(data.readUInt16LE(0x1FFA))}`);
        }
        data.copy(bank, at);
      }
      if (b.bank === 0) {
        bank.writeUInt16LE(G.crc16(bank.subarray(0xE002, 0x10000)), 0xE000);                    // service library
        bank.writeUInt16LE(G.crc16(Buffer.concat([bank.subarray(0, 0x0E), bank.subarray(0x10, 0x4000)])), 0x0E);  // page 0
        console.log(`  page 0 CRC ${G.hex(bank.readUInt16LE(0x0E))}, service library CRC ${G.hex(bank.readUInt16LE(0xE000))}`);
      }
    } else {
      b.pages.forEach((f, i) => {
        const data = fs.readFileSync(path.join(roms, f));
        if (data.length !== G.PAGE) G.die(`${f}: ${data.length} bytes, expected 16 KB`);
        data.copy(bank, i * G.PAGE);
      });
    }
    const file = path.join(out, `${b.bank}_${b.name}.bin`);
    fs.writeFileSync(file, bank);
    console.log(`${G.rel(file)}  sha256 ${G.sha256(bank).slice(0, 16)}`);
  }
}

main();
