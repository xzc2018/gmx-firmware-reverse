#!/usr/bin/env node
// MAX+PLUS II .ttf (Tabular Text File: decimal bytes) -> raw .rbf bytes, the form stored in the GMX Flash.
//   node tools/ttf2rbf.js in.ttf [out.rbf]
'use strict';
const fs = require('fs');
const G = require('./lib/gmx');

const [inp, out] = process.argv.slice(2);
if (!inp) G.die('usage: node tools/ttf2rbf.js in.ttf [out.rbf]');
const bytes = G.readTtf(inp);
const dst = out || inp.replace(/\.ttf$/i, '') + '.rbf';
fs.writeFileSync(dst, bytes);
console.log(`${dst}: ${bytes.length} bytes`);
