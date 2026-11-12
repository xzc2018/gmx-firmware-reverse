#!/usr/bin/env node
// Self-test of the assembly chain: build banks and the image from roms/ with the ORIGINAL bitstreams
// (fpga/<design>/<design>_original.rbf) and check that the result is byte-identical to the original
// gmx12501.rom (sha256 stored in roms/layout.json). Works without MAX+PLUS II.
//   node tools/verify.js
'use strict';
const fs = require('fs');
const path = require('path');
const { execFileSync } = require('child_process');
const G = require('./lib/gmx');

const wd = path.join(G.ROOT, 'build', 'verify');
fs.rmSync(wd, { recursive: true, force: true });
const bs = path.join(wd, 'bitstream');
fs.mkdirSync(bs, { recursive: true });
for (const d of ['scorpion', 'pentagon']) {
  fs.copyFileSync(path.join(G.ROOT, 'fpga', d, `${d}_original.rbf`), path.join(bs, `${d}.rbf`));
}
fs.copyFileSync(path.join(G.ROOT, 'cpld', 'gmx_cpld_original.pof'), path.join(bs, 'gmx_cpld.pof'));
const node = process.execPath;
const run = (script, ...args) => execFileSync(node, [path.join(__dirname, script), ...args], { stdio: 'inherit' });
run('make_banks.js', '--bitstream', bs, '--out', path.join(wd, 'banks'));
run('make_rom.js', '--banks', path.join(wd, 'banks'), '--out', path.join(wd, 'gmx.rom'),
  '--pof', path.join(bs, 'gmx_cpld.pof'), '--pof-out', path.join(wd, 'gmx_cpld.pof'));
const ref = G.readJson(path.join(G.ROOT, 'roms', 'layout.json')).image.reference_sha256;
const got = G.sha256(fs.readFileSync(path.join(wd, 'gmx.rom')));
if (got !== ref) G.die(`image differs from the original: ${got} != ${ref}`);
console.log('VERIFY OK: roms/ + original bitstreams reproduce gmx12501.rom byte for byte');
