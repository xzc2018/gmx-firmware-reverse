// Common helpers for the GMX firmware build tools (Node.js only, no dependencies).
'use strict';
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

const ROOT = path.resolve(__dirname, '..', '..');   // publish/
const PAGE = 0x4000;
const BANK = 0x10000;
const IMAGE = 0x80000;
const SCHEME_BLOCK = 0x2000;
const BITSTREAM_MAX = 0x1FE6;                         // bitstream area of a scheme block

// CRC-16/CCITT-FALSE (poly 0x1021, init 0xFFFF) - the checksum used by the GMX loader
function crc16(buf, crc = 0xFFFF) {
  for (const b of buf) {
    crc ^= b << 8;
    for (let i = 0; i < 8; i++) crc = (crc & 0x8000) ? ((crc << 1) ^ 0x1021) & 0xFFFF : (crc << 1) & 0xFFFF;
  }
  return crc;
}

const sha256 = (buf) => crypto.createHash('sha256').update(buf).digest('hex');
const hex = (n, w = 4) => '0x' + n.toString(16).toUpperCase().padStart(w, '0');
const num = (v) => (typeof v === 'number' ? v : parseInt(v, 16));
const rel = (p) => path.relative(ROOT, p).replace(/\\/g, '/');

// MAX+PLUS II .ttf (comma separated decimal bytes) -> Buffer
function readTtf(file) {
  const txt = fs.readFileSync(file, 'latin1');
  return Buffer.from(txt.split(/[\s,]+/).filter((s) => s.length).map((s) => {
    const v = parseInt(s, 10);
    if (!(v >= 0 && v <= 255)) throw new Error(`${file}: bad byte "${s}"`);
    return v;
  }));
}

function readJson(file) { return JSON.parse(fs.readFileSync(file, 'utf8')); }
function writeFile(file, data) { fs.mkdirSync(path.dirname(file), { recursive: true }); fs.writeFileSync(file, data); }

// tiny argv parser: --key value / --flag
function args(argv = process.argv.slice(2)) {
  const out = { _: [] };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a.startsWith('--')) {
      const k = a.slice(2);
      if (i + 1 < argv.length && !argv[i + 1].startsWith('--')) out[k] = argv[++i]; else out[k] = true;
    } else out._.push(a);
  }
  return out;
}

function die(msg) { console.error('ERROR: ' + msg); process.exit(1); }

module.exports = { ROOT, PAGE, BANK, IMAGE, SCHEME_BLOCK, BITSTREAM_MAX, crc16, sha256, hex, num, rel,
  readTtf, readJson, writeFile, args, die };
