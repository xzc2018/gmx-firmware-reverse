#!/usr/bin/env node
// Split a GMX 512 KB Flash image into roms/ (source pages) + roms/layout.json (how banks are assembled).
//   node tools/split_rom.js <image.rom> [--roms roms] [--bitstreams fpga]
// Bank 0 is split into the boot block, the service library and the 6 FPGA scheme slots (trailer values go to
// layout.json, the bitstreams are referenced by name). Banks 1..7 are split into 16 KB pages; identical pages
// are stored once and referenced several times.
'use strict';
const fs = require('fs');
const path = require('path');
const G = require('./lib/gmx');

const SLOTS = [0x2000, 0x4000, 0x6000, 0x8000, 0xA000, 0xC000];   // scheme blocks in bank 0
const SLOT_NUM = { 0x2000: 1, 0x4000: 6, 0x6000: 7, 0x8000: 4, 0xA000: 5, 0xC000: 2 };  // scheme number (CONF)
const BANK_NAMES = ['bank0_loader_fpga', 'bank1_pentagon_128_trdos', 'bank2_diag_test', 'bank3_diag_test_copy',
  'bank4_scorpion_zs256', 'bank5_ext_pages_A', 'bank6_ext_pages_B', 'bank7_empty_pages'];
const PAGE_NAMES = {
  1: ['128_basic_sinclair', '48_basic_sinclair', 'trdos_503', 'trdos_503_dup'],
  2: ['diag_0', 'diag_1', 'diag_2', 'diag_3'],
  3: ['diag_copy_0', 'diag_copy_1', 'diag_copy_2', 'diag_copy_3'],
  4: ['128_basic_scorpion', '48_basic_scorpion', 'shadow_service_monitor', 'trdos_503_scorpion'],
  5: ['ext_A_0', 'ext_A_1', 'ext_A_2', 'ext_A_3'],
  6: ['ext_B_0', 'ext_B_1', 'ext_B_2', 'ext_B_3'],
  7: ['template_0', 'template_1', 'template_2', 'template_3'],
};

function main() {
  const a = G.args();
  if (!a._[0]) G.die('usage: node tools/split_rom.js <image.rom> [--roms roms] [--bitstreams fpga]');
  const img = fs.readFileSync(a._[0]);
  if (img.length !== G.IMAGE) G.die(`expected ${G.IMAGE} bytes, got ${img.length}`);
  const roms = path.resolve(a.roms || path.join(G.ROOT, 'roms'));
  // known bitstreams (name -> sha256 of the padded 0x1FE6 area), from fpga/<name>/<name>_original.rbf
  const known = {};
  const bdir = path.resolve(a.bitstreams || path.join(G.ROOT, 'fpga'));
  if (fs.existsSync(bdir)) {
    for (const d of fs.readdirSync(bdir)) {
      const f = path.join(bdir, d, `${d}_original.rbf`);
      if (fs.existsSync(f)) known[G.sha256(pad(fs.readFileSync(f)))] = d;
    }
  }
  fs.rmSync(roms, { recursive: true, force: true });
  const layout = { image: { size: G.IMAGE, reference_sha256: G.sha256(img),
    note: 'pages are in logical order (as seen by the Z80 / written by the GMX loader)' }, banks: [] };
  const seen = {};   // sha -> file
  const put = (file, data) => {
    const h = G.sha256(data);
    if (seen[h]) return seen[h];
    G.writeFile(path.join(roms, file), data);
    seen[h] = file;
    return file;
  };
  // ---- bank 0
  const b0 = img.subarray(0, G.BANK);
  const parts = [{ at: G.hex(0x0000), file: put('bank0/boot_0000.bin', b0.subarray(0, 0x2000)),
    note: 'loader boot block; page-0 CRC at 0x000E is recomputed' }];
  for (const at of SLOTS) {
    const blk = b0.subarray(at, at + G.SCHEME_BLOCK);
    const bs = blk.subarray(0, G.BITSTREAM_MAX);
    const name = known[G.sha256(bs)];
    let bitstream;
    if (name) bitstream = `${name}.rbf`;
    else { bitstream = `scheme${SLOT_NUM[at]}.rbf`; put(`bank0/${bitstream}`, trim(bs)); }
    parts.push({ at: G.hex(at), scheme: {
      number: SLOT_NUM[at], name: blk.subarray(0x1FF0, 0x1FFA).toString('latin1').trimEnd(),
      date: blk.subarray(0x1FE6, 0x1FEE).toString('latin1'),
      port_xx00: G.hex(blk[0x1FEE], 2), port_7EFD: G.hex(blk[0x1FEF], 2), bitstream,
      tail: blk.subarray(0x1FFC, 0x2000).toString('hex'),
      original_crc: G.hex(blk.readUInt16LE(0x1FFA)) } });
  }
  parts.push({ at: G.hex(0xE000), file: put('bank0/service_lib_E000.bin', b0.subarray(0xE000, 0x10000)),
    note: 'service library (org 0x2000); CRC of 0xE002..0xFFFF in its first 2 bytes, recomputed' });
  layout.banks.push({ bank: 0, name: BANK_NAMES[0], parts });
  // ---- banks 1..7
  for (let b = 1; b < 8; b++) {
    const pages = [];
    for (let p = 0; p < 4; p++) {
      const off = b * G.BANK + p * G.PAGE;
      pages.push(put(`bank${b}/${p}_${PAGE_NAMES[b][p]}.bin`, img.subarray(off, off + G.PAGE)));
    }
    layout.banks.push({ bank: b, name: BANK_NAMES[b], pages });
  }
  G.writeFile(path.join(roms, 'layout.json'), JSON.stringify(layout, null, 2) + '\n');
  console.log(`${G.rel(roms)}: ${Object.keys(seen).length} files + layout.json`);
}

function pad(buf) {
  if (buf.length > G.BITSTREAM_MAX) throw new Error('bitstream longer than 0x1FE6');
  return Buffer.concat([buf, Buffer.alloc(G.BITSTREAM_MAX - buf.length, 0xFF)]);
}
function trim(buf) { let n = buf.length; while (n > 0 && buf[n - 1] === 0xFF) n--; return buf.subarray(0, n); }

if (require.main === module) main();
module.exports = { pad };
