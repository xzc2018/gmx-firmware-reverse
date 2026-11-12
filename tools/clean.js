#!/usr/bin/env node
// Remove build outputs and MAX+PLUS II artifacts, leaving only the sources.
//   node tools/clean.js [--dry]      (--dry: only list what would be removed)
// Removed:
//   build/, banks/*.bin, bitstream/* (except README.md), gmx_flash_physical.bin;
//   vlsim/out/ (simulator builds, runs, saved states, the original image out/orig.rom);
//   in fpga/scorpion, fpga/pentagon, cpld (compiled in place): compiler files *.cnf *.fit *.hex *.hif *.log
//   *.mmf *.mtf *.ndb *.pin *.rpt *.snf *.sof *.ttf *.jam *.jbc *.vo *.vho *.sdo and <top>.pof.
// Kept: the AHDL sources, .acf, published EDIF (*.edo), *_original.rbf/.pof, gmx_cpld_rebuilt.pof, READMEs,
// and the released firmware gmx.rom, gmx_keepboot.rom, gmx_cbr.rom, gmx_cbr_keepboot.rom, gmx_cpld.pof in the root.
'use strict';
const fs = require('fs');
const path = require('path');
const G = require('./lib/gmx');

const dry = !!G.args().dry;
const R = G.ROOT;
const ART = /\.(cnf|fit|hex|hif|log|mmf|mtf|ndb|pin|rpt|snf|sof|ttf|jam|jbc|vo|vho|sdo)$/i;
const SRC = { 'fpga/scorpion': 'scorpion', 'fpga/pentagon': 'pentagon', cpld: 'gmx_cpld' };
let n = 0;

function rm(p) {
  if (!fs.existsSync(p)) return;
  console.log((dry ? 'would remove ' : 'removed ') + G.rel(p) + (fs.statSync(p).isDirectory() ? '/' : ''));
  if (!dry) fs.rmSync(p, { recursive: true, force: true });
  n++;
}

rm(path.join(R, 'build'));
rm(path.join(R, 'gmx_flash_physical.bin'));
rm(path.join(R, 'vlsim', 'out'));
const banks = path.join(R, 'banks');
if (fs.existsSync(banks)) for (const f of fs.readdirSync(banks)) if (f.endsWith('.bin')) rm(path.join(banks, f));
const bs = path.join(R, 'bitstream');
if (fs.existsSync(bs)) for (const f of fs.readdirSync(bs)) if (f.toLowerCase() !== 'readme.md') rm(path.join(bs, f));
for (const [dir, top] of Object.entries(SRC)) {
  const d = path.join(R, dir);
  if (!fs.existsSync(d)) continue;
  for (const f of fs.readdirSync(d)) {
    if (ART.test(f) || f.toLowerCase() === top + '.pof') rm(path.join(d, f));
  }
}
console.log(n ? `${dry ? 'would remove' : 'removed'} ${n} item(s)` : 'nothing to clean');
