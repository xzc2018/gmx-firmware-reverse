#!/usr/bin/env node
// Compare two simulator runs of the same scenario (e.g. original vs rebuilt firmware).
//   node vlsim/compare.js <runA> <runB>
// Compared: the pixels of every PNG present in both runs, the sequence of bus events in io.log (port
// writes/reads, interrupt acknowledge; the time shift is reported separately because the Flash images
// differ in the FLEX scheme blocks and the loader's CRC loops take data-dependent time), and the FLEX
// configuration events of sim.log. Exit code 0 = runs equivalent.
'use strict';
const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

function pngPixels(file) {
  const d = fs.readFileSync(file);
  let pos = 8, w = 0, h = 0;
  const idat = [];
  while (pos < d.length) {
    const n = d.readUInt32BE(pos), t = d.toString('latin1', pos + 4, pos + 8);
    if (t === 'IHDR') { w = d.readUInt32BE(pos + 8); h = d.readUInt32BE(pos + 12); }
    if (t === 'IDAT') idat.push(d.subarray(pos + 8, pos + 8 + n));
    pos += 12 + n;
  }
  return { w, h, raw: zlib.inflateSync(Buffer.concat(idat)) };
}

function lines(file, keep = () => true) {
  if (!fs.existsSync(file)) return [];
  return fs.readFileSync(file, 'latin1').split(/\r?\n/).filter((l) => l.trim() && keep(l));
}

function compare(a, b, log = console.log) {
  let ok = true;
  const pa = new Set(fs.readdirSync(a).filter((f) => f.endsWith('.png')));
  const pb = new Set(fs.readdirSync(b).filter((f) => f.endsWith('.png')));
  for (const f of [...new Set([...pa, ...pb])].sort()) {
    if (!pa.has(f) || !pb.has(f)) { log(`PNG ${f}: only in ${pa.has(f) ? 'A' : 'B'}`); ok = false; continue; }
    const x = pngPixels(path.join(a, f)), y = pngPixels(path.join(b, f));
    if (x.w !== y.w || x.h !== y.h) { log(`PNG ${f}: size ${x.w}x${x.h} vs ${y.w}x${y.h}`); ok = false; }
    else if (!x.raw.equals(y.raw)) {
      let n = 0;
      for (let i = 0; i < x.raw.length; i++) if (x.raw[i] !== y.raw[i]) n++;
      log(`PNG ${f}: ${n} bytes differ`); ok = false;
    } else log(`PNG ${f}: identical`);
  }
  const ia = lines(path.join(a, 'io.log')), ib = lines(path.join(b, 'io.log'));
  const ev = (l) => l.split(' ms ').slice(1).join(' ms ');
  const n = Math.min(ia.length, ib.length);
  let first = -1, dt = 0;
  for (let i = 0; i < n; i++) {
    if (ev(ia[i]) !== ev(ib[i])) { first = i; break; }
    dt = Math.max(dt, Math.abs(parseFloat(ia[i]) - parseFloat(ib[i])));
  }
  if (first < 0) {
    const tail = ia.length === ib.length ? '' : `, run lengths ${ia.length}/${ib.length} (common part compared)`;
    log(`io.log: same event sequence (${n} events), max time shift ${(dt * 1000).toFixed(1)} us${tail}`);
  } else {
    ok = false;
    log(`io.log: event sequences differ at event ${first}`);
    log(`   A: ${ia[first]}`);
    log(`   B: ${ib[first]}`);
  }
  const fa = lines(path.join(a, 'sim.log'), (l) => l.includes('FLEX:'));
  const fb = lines(path.join(b, 'sim.log'), (l) => l.includes('FLEX:'));
  const same = fa.length === fb.length && fa.every((l, i) => l === fb[i]);
  log(`FLEX events: ${same ? 'identical' : 'differ'}`);
  if (!same) ok = false;
  log(`RESULT: ${ok ? 'runs are equivalent' : 'runs differ'}`);
  return ok;
}

if (require.main === module) {
  const [a, b] = process.argv.slice(2);
  if (!a || !b) { console.error('usage: node vlsim/compare.js <runA> <runB>'); process.exit(2); }
  process.exit(compare(a, b) ? 0 : 1);
}
module.exports = { compare };
