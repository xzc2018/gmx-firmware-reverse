#!/usr/bin/env node
// Compile one design with MAX+PLUS II 10.x and put the result into bitstream/.
//   node tools/compile.js scorpion|pentagon|cpld [--cbr] [--maxplus C:\maxplus2\maxplus2.exe] [--out bitstream]
// The sources are copied to build/<design>/ and compiled there (maxplus2 -c <top>).
//   FLEX (scorpion, pentagon): bitstream/<design>.ttf + <design>.rbf (raw bytes, as stored in the Flash)
//   CPLD:                      bitstream/gmx_cpld.pof
// --cbr (FLEX only): parameter CBR = 1 (DRAM refresh by CAS-before-RAS cycles, see memctl.tdf), set in the
//   GLOBAL_PARAMETERS section of the .acf; for "scorpion" the logic cell assignments act as LAB assignments
//   (the added cells do not fit with fixed cells). Result: build/<design>_cbr/, bitstream/<design>_cbr.rbf.
'use strict';
const fs = require('fs');
const path = require('path');
const { spawnSync } = require('child_process');
const G = require('./lib/gmx');

const DESIGNS = {
  scorpion: { src: 'fpga/scorpion', top: 'scorpion', kind: 'flex', cbrDemote: true },
  pentagon: { src: 'fpga/pentagon', top: 'pentagon', kind: 'flex', cbrDemote: false },
  cpld: { src: 'cpld', top: 'gmx_cpld', kind: 'cpld' },
};

function main() {
  const a = G.args();
  const name = a._[0];
  const d = DESIGNS[name];
  if (!d) G.die('usage: node tools/compile.js ' + Object.keys(DESIGNS).join('|'));
  const exe = a.maxplus || process.env.MAXPLUS2 || 'C:\\maxplus2\\maxplus2.exe';
  if (!fs.existsSync(exe)) G.die(`MAX+PLUS II not found: ${exe} (set MAXPLUS2 or --maxplus)`);
  const out = path.resolve(a.out || path.join(G.ROOT, 'bitstream'));
  if (a.cbr && d.kind !== 'flex') G.die('--cbr applies to the FLEX designs only');
  const tag = a.cbr ? name + '_cbr' : name;
  const wd = path.join(G.ROOT, 'build', tag);
  fs.rmSync(wd, { recursive: true, force: true });
  fs.mkdirSync(wd, { recursive: true });
  const src = path.join(G.ROOT, d.src);
  for (const f of fs.readdirSync(src)) if (/\.(tdf|inc|acf)$/i.test(f)) fs.copyFileSync(path.join(src, f), path.join(wd, f));
  if (a.cbr) {
    const acf = path.join(wd, d.top + '.acf');
    let t = fs.readFileSync(acf, 'latin1').replace(/ASK_BEFORE_ADDING_EXTRA_DEVICES = OFF/, 'ASK_BEFORE_ADDING_EXTRA_DEVICES = ON');
    if (d.cbrDemote) {
      t = t.replace(/DEMOTE_SPECIFIC_LCELL_ASSIGNMENTS_TO_LAB_ASSIGNMENTS = OFF/,
        'DEMOTE_SPECIFIC_LCELL_ASSIGNMENTS_TO_LAB_ASSIGNMENTS = ON');
    }
    fs.writeFileSync(acf, t + '\nGLOBAL_PARAMETERS\nBEGIN\n\tCBR = 1;\nEND;\n', 'latin1');
  }
  console.log(`compiling ${d.top} in ${G.rel(wd)} ...`);
  const r = spawnSync(exe, ['-c', d.top], { cwd: wd, encoding: 'latin1', timeout: 30 * 60 * 1000 });
  const log = (r.stdout || '') + (r.stderr || '');
  fs.writeFileSync(path.join(wd, 'compile.log'), log);
  const lines = log.split(/\r?\n/);
  for (const l of lines) if (/^(Error|Project)/.test(l)) console.log('  ' + l);
  const nw = lines.filter((l) => /^Warning/.test(l) && !/copyright/i.test(l)).length;
  if (nw) console.log(`  ${nw} warnings (unused vector bits etc.), see ${G.rel(wd)}/compile.log`);
  if (!/compilation was successful/i.test(log)) G.die(`${d.top}: compilation failed, see ${G.rel(wd)}/compile.log`);
  fs.mkdirSync(out, { recursive: true });
  if (d.kind === 'flex') {
    const ttf = path.join(wd, d.top + '.ttf');
    const bytes = G.readTtf(ttf);
    fs.copyFileSync(ttf, path.join(out, tag + '.ttf'));
    fs.writeFileSync(path.join(out, tag + '.rbf'), bytes);
    console.log(`  -> ${G.rel(path.join(out, tag + '.rbf'))} (${bytes.length} bytes)`);
  } else {
    fs.copyFileSync(path.join(wd, d.top + '.pof'), path.join(out, d.top + '.pof'));
    console.log(`  -> ${G.rel(path.join(out, d.top + '.pof'))}`);
  }
}

main();
