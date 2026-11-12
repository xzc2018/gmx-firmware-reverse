#!/usr/bin/env node
// Join banks/ into the 512 KB GMX Flash image and put the CPLD POF next to it.
//   node tools/make_rom.js [--banks banks] [--out gmx.rom] [--pof bitstream/gmx_cpld.pof] [--pof-out gmx_cpld.pof]
//                          [--physical gmx_flash_physical.bin]
// gmx.rom has the same format/order as the original gmx12501.rom (logical page order, for the GMX loader).
// --physical additionally writes the chip-order image for a programmer: in every bank pages 1 and 3 are swapped
// (CPLD drives Flash A14 = page0, A15 = page1 xor page0; see docs/CPLD_EPM7064S.md, 2.8).
'use strict';
const fs = require('fs');
const path = require('path');
const G = require('./lib/gmx');

function main() {
  const a = G.args();
  const banks = path.resolve(a.banks || path.join(G.ROOT, 'banks'));
  const out = path.resolve(a.out || path.join(G.ROOT, 'gmx.rom'));
  const files = fs.readdirSync(banks).filter((f) => /^\d_.*\.bin$/.test(f)).sort();
  if (files.length !== 8) G.die(`${G.rel(banks)}: expected 8 bank files, found ${files.length} (run tools/make_banks.js)`);
  const img = Buffer.concat(files.map((f) => {
    const b = fs.readFileSync(path.join(banks, f));
    if (b.length !== G.BANK) G.die(`${f}: ${b.length} bytes, expected 64 KB`);
    return b;
  }));
  G.writeFile(out, img);
  console.log(`${G.rel(out)}  ${img.length} bytes  sha256 ${G.sha256(img)}`);
  if (a.physical) {
    const phys = Buffer.from(img);
    for (let b = 0; b < 8; b++) {
      const p1 = b * G.BANK + G.PAGE, p3 = b * G.BANK + 3 * G.PAGE;
      img.copy(phys, p1, p3, p3 + G.PAGE);
      img.copy(phys, p3, p1, p1 + G.PAGE);
    }
    const pf = path.resolve(a.physical === true ? path.join(G.ROOT, 'gmx_flash_physical.bin') : a.physical);
    G.writeFile(pf, phys);
    console.log(`${G.rel(pf)}  chip order (pages 1<->3 swapped in every bank)`);
  }
  const pof = path.resolve(a.pof || path.join(G.ROOT, 'bitstream', 'gmx_cpld.pof'));
  if (a.pof !== 'none') {
    if (!fs.existsSync(pof)) G.die(`${G.rel(pof)} not found (run tools/compile.js cpld)`);
    const po = path.resolve(a['pof-out'] || path.join(G.ROOT, 'gmx_cpld.pof'));
    fs.copyFileSync(pof, po);
    console.log(`${G.rel(po)}  CPLD EPM7064SLC44 (from ${G.rel(pof)})`);
  }
}

main();
