#!/usr/bin/env node
// GMX board simulator: build, single runs, testbenches.
//   node vlsim/run.js build <orig|rebuilt>
//   node vlsim/run.js sim <orig|rebuilt> <scenario.txt> --ms N [--load file] [--save ms file] [--out dir]
//   node vlsim/run.js tb [orig] [rebuilt]       full testbench for the variants (default both), then compare
//   node vlsim/run.js compare <runA> <runB>
// Variants (testbenches):
//   orig     models\orig, Flash image = original gmx12501.rom (rebuilt from roms\ + original bitstreams)
//   rebuilt  models\rebuilt, Flash image = gmx.rom of this repository
// The simulator runs at below-normal priority; results go to vlsim\out\<variant>\<scenario>\.
'use strict';
const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawn, execFileSync } = require('child_process');
const { compare } = require('./compare');

const VL = __dirname;
const PUB = path.resolve(VL, '..');
const OUT = path.join(VL, 'out');

// testbench: boot with DELETE held to the GMX Loader menu (state saved at 3700 ms), then one branch per
// configuration started from that state
const TB = [
  { name: 'boot', script: 'boot.txt', ms: 3702, save: [3700, 'menu.sav'] },
  { name: 'pentagon', script: 'pentagon.txt', ms: 10600, load: 'menu.sav' },
  { name: 'komposit', script: 'komposit.txt', ms: 8600, load: 'menu.sav' },
  { name: 'boardtest', script: 'boardtest.txt', ms: 8100, load: 'menu.sav' },
  { name: 'scorpion', script: 'scorpion.txt', ms: 30100, load: 'menu.sav' },
];

function die(m) { console.error('ERROR: ' + m); process.exit(1); }

function romFor(variant) {
  if (variant === 'rebuilt') return path.join(PUB, 'gmx.rom');
  const rom = path.join(OUT, 'orig.rom');
  if (!fs.existsSync(rom)) {
    // the original image: roms\ + original bitstreams, checked against the reference SHA-256
    execFileSync(process.execPath, [path.join(PUB, 'tools', 'verify.js')], { stdio: 'inherit' });
    fs.mkdirSync(OUT, { recursive: true });
    fs.copyFileSync(path.join(PUB, 'build', 'verify', 'gmx.rom'), rom);
  }
  return rom;
}

function build(variant) {
  execFileSync('cmd', ['/c', path.join(VL, 'build.cmd'), variant], { stdio: 'inherit' });
}

function sim(variant, script, ms, opt = {}) {
  const exe = path.join(VL, 'out', `build_${variant}`, 'gmxsim.exe');
  if (!fs.existsSync(exe)) build(variant);
  const out = opt.out || path.join(OUT, variant, path.basename(script, '.txt'));
  fs.mkdirSync(out, { recursive: true });
  const m = path.join(VL, 'models', variant);
  const args = ['--rom', romFor(variant), '--scorpion', path.join(m, 'scorpion.rbf'), '--pentagon',
    path.join(m, 'pentagon.rbf'), '--script', script, '--out', out, '--ms', String(ms), '--progress', '10000'];
  if (opt.load) args.push('--load', opt.load);
  if (opt.save) args.push('--save', String(opt.save[0]), opt.save[1]);
  return new Promise((resolve, reject) => {
    const log = fs.openSync(path.join(out, 'sim.log'), 'w');
    const p = spawn(exe, args, { stdio: ['ignore', log, log] });
    try { os.setPriority(p.pid, os.constants.priority.PRIORITY_BELOW_NORMAL); } catch (e) { /* not critical */ }
    p.on('exit', (code) => { fs.closeSync(log); code === 0 ? resolve(out) : reject(new Error(`${exe} exit ${code}`)); });
  });
}

async function testbench(variants) {
  for (const v of variants) {
    if (!fs.existsSync(path.join(VL, 'out', `build_${v}`, 'gmxsim.exe'))) build(v);
    romFor(v);
  }
  for (const s of TB) {
    console.log(`== ${s.name} (${variants.join(', ')})`);
    await Promise.all(variants.map((v) => {
      const dir = path.join(OUT, v);
      fs.mkdirSync(dir, { recursive: true });
      return sim(v, path.join(VL, 'testbench', s.script), s.ms, {
        out: path.join(dir, s.name),
        load: s.load ? path.join(dir, s.load) : undefined,
        save: s.save ? [s.save[0], path.join(dir, s.save[1])] : undefined,
      });
    }));
    if (variants.length === 2) compare(path.join(OUT, variants[0], s.name), path.join(OUT, variants[1], s.name));
  }
}

async function main() {
  const [cmd, ...a] = process.argv.slice(2);
  const opt = (k) => { const i = a.indexOf(k); return i >= 0 ? a[i + 1] : undefined; };
  if (cmd === 'build') build(a[0] || 'orig');
  else if (cmd === 'sim') {
    if (a.length < 2) die('usage: node vlsim/run.js sim <variant> <scenario.txt> --ms N');
    const save = opt('--save') ? [Number(opt('--save')), a[a.indexOf('--save') + 2]] : undefined;
    const out = await sim(a[0], path.resolve(a[1]), Number(opt('--ms') || 5000),
      { load: opt('--load'), save, out: opt('--out') });
    console.log(fs.readFileSync(path.join(out, 'sim.log'), 'latin1').split(/\r?\n/).slice(-6).join('\n'));
  } else if (cmd === 'tb') await testbench(a.length ? a : ['orig', 'rebuilt']);
  else if (cmd === 'compare') process.exit(compare(a[0], a[1]) ? 0 : 1);
  else die('usage: node vlsim/run.js build|sim|tb|compare ...');
}

main().catch((e) => die(e.message));
