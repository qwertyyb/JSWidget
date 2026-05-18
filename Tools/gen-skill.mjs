#!/usr/bin/env node
/**
 * 1. Copies documentation sources into docs/jswidget-script-gen/references/
 *    so the Cursor agent skill can reference them locally.
 * 2. Packs the entire docs/jswidget-script-gen/ directory into
 *    docs/public/jswidget-script-gen.zip for download from the docs site.
 */
import { copyFileSync, mkdirSync, readdirSync, statSync, createWriteStream, readFileSync } from "node:fs";
import { dirname, join, relative } from "node:path";
import { fileURLToPath } from "node:url";
import { createDeflateRaw } from "node:zlib";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const docsDir = join(root, "docs");
const skillDir = join(docsDir, "jswidget-script-gen");
const refsDir = join(skillDir, "references");
const publicDir = join(docsDir, "public");
const zipPath = join(publicDir, "jswidget-script-gen.zip");

// --- Step 1: Copy reference docs ---

mkdirSync(refsDir, { recursive: true });

const filesToCopy = [
  "components/index.md",
  "api/index.md",
];

for (const rel of filesToCopy) {
  const srcPath = join(docsDir, rel);
  const destPath = join(refsDir, rel);
  mkdirSync(dirname(destPath), { recursive: true });
  copyFileSync(srcPath, destPath);
  console.log(`Copied: docs/${rel} → jswidget-script-gen/references/${rel}`);
}

// --- Step 2: Pack into zip ---

function collectFiles(dir, base) {
  const results = [];
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry);
    const rel = relative(base, full);
    if (statSync(full).isDirectory()) {
      results.push(...collectFiles(full, base));
    } else {
      results.push(rel);
    }
  }
  return results;
}

function crc32(buf) {
  let crc = 0xffffffff;
  for (let i = 0; i < buf.length; i++) {
    crc ^= buf[i];
    for (let j = 0; j < 8; j++) {
      crc = (crc >>> 1) ^ (crc & 1 ? 0xedb88320 : 0);
    }
  }
  return (crc ^ 0xffffffff) >>> 0;
}

function deflateSync(buf) {
  return new Promise((resolve, reject) => {
    const chunks = [];
    const deflater = createDeflateRaw();
    deflater.on("data", (c) => chunks.push(c));
    deflater.on("end", () => resolve(Buffer.concat(chunks)));
    deflater.on("error", reject);
    deflater.end(buf);
  });
}

async function createZip(sourceDir, outPath) {
  const files = collectFiles(sourceDir, sourceDir);
  const entries = [];

  for (const rel of files) {
    const content = readFileSync(join(sourceDir, rel));
    const compressed = await deflateSync(content);
    entries.push({
      name: Buffer.from(rel),
      content,
      compressed,
      crc: crc32(content),
    });
  }

  const parts = [];
  const centralHeaders = [];
  let offset = 0;

  for (const e of entries) {
    const localHeader = Buffer.alloc(30);
    localHeader.writeUInt32LE(0x04034b50, 0);    // local file header signature
    localHeader.writeUInt16LE(20, 4);             // version needed
    localHeader.writeUInt16LE(0, 6);              // flags
    localHeader.writeUInt16LE(8, 8);              // compression: deflate
    localHeader.writeUInt16LE(0, 10);             // mod time
    localHeader.writeUInt16LE(0, 12);             // mod date
    localHeader.writeUInt32LE(e.crc, 14);
    localHeader.writeUInt32LE(e.compressed.length, 18);
    localHeader.writeUInt32LE(e.content.length, 22);
    localHeader.writeUInt16LE(e.name.length, 26);
    localHeader.writeUInt16LE(0, 28);             // extra field length

    parts.push(localHeader, e.name, e.compressed);

    const centralHeader = Buffer.alloc(46);
    centralHeader.writeUInt32LE(0x02014b50, 0);   // central directory header
    centralHeader.writeUInt16LE(20, 4);            // version made by
    centralHeader.writeUInt16LE(20, 6);            // version needed
    centralHeader.writeUInt16LE(0, 8);             // flags
    centralHeader.writeUInt16LE(8, 10);            // compression: deflate
    centralHeader.writeUInt16LE(0, 12);            // mod time
    centralHeader.writeUInt16LE(0, 14);            // mod date
    centralHeader.writeUInt32LE(e.crc, 16);
    centralHeader.writeUInt32LE(e.compressed.length, 20);
    centralHeader.writeUInt32LE(e.content.length, 24);
    centralHeader.writeUInt16LE(e.name.length, 28);
    centralHeader.writeUInt16LE(0, 30);            // extra field length
    centralHeader.writeUInt16LE(0, 32);            // file comment length
    centralHeader.writeUInt16LE(0, 34);            // disk number start
    centralHeader.writeUInt16LE(0, 36);            // internal file attributes
    centralHeader.writeUInt32LE(0, 38);            // external file attributes
    centralHeader.writeUInt32LE(offset, 42);       // relative offset of local header
    centralHeaders.push(centralHeader, e.name);

    offset += localHeader.length + e.name.length + e.compressed.length;
  }

  const centralDirOffset = offset;
  let centralDirSize = 0;
  for (const buf of centralHeaders) centralDirSize += buf.length;

  const eocd = Buffer.alloc(22);
  eocd.writeUInt32LE(0x06054b50, 0);              // end of central directory
  eocd.writeUInt16LE(0, 4);                       // disk number
  eocd.writeUInt16LE(0, 6);                       // disk with central dir
  eocd.writeUInt16LE(entries.length, 8);           // entries on this disk
  eocd.writeUInt16LE(entries.length, 10);          // total entries
  eocd.writeUInt32LE(centralDirSize, 12);
  eocd.writeUInt32LE(centralDirOffset, 16);
  eocd.writeUInt16LE(0, 20);                      // comment length

  mkdirSync(dirname(outPath), { recursive: true });
  const ws = createWriteStream(outPath);
  for (const buf of [...parts, ...centralHeaders, eocd]) {
    ws.write(buf);
  }
  await new Promise((resolve) => ws.end(resolve));
}

await createZip(skillDir, zipPath);
console.log(`Packed: jswidget-script-gen.zip → docs/public/jswidget-script-gen.zip`);
