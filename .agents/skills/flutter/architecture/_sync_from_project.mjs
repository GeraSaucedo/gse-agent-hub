#!/usr/bin/env node
// Sync fixes made in a generated project back into base_app (the template source).
// Reverse of generate.mjs: copies only the tracked overlay paths and rewrites the
// project's package/namespace back to the template's gse_base_app placeholders.
// Add/update only — never deletes files from the template.
//
//   node _sync_from_project.mjs <projectDir> <projectPackage> <projectNamespace>
import * as fs from 'node:fs';
import * as path from 'node:path';
import { fileURLToPath } from 'node:url';

const HERE = path.dirname(fileURLToPath(import.meta.url));
const DEST = path.join(HERE, 'base_app');

const TPL_PACKAGE = 'gse_base_app';
const TPL_NAMESPACE = 'com.example.gse_base_app';
const BINARY_EXT = new Set(['.ttf', '.png', '.jpg', '.jpeg', '.gif', '.ico', '.otf', '.woff', '.woff2']);

// The overlay paths base_app tracks (mirrors the original template include list).
const TRACKED = [
  'lib', 'assets', 'fonts/Poppins', 'tools', '.vscode',
  'packages/design_system', 'packages/gse_localization',
  'analysis_options.yaml', 'flutter_launcher_icons.yaml', 'flutter_native_splash.yaml', 'pubspec.yaml',
  'android/app/build.gradle.kts', 'android/app/flavor_config.gradle.kts', 'android/app/src/main/AndroidManifest.xml',
];

const [, , projArg, pkgArg, nsArg] = process.argv;
if (!projArg || !pkgArg || !nsArg) {
  console.error('Usage: node _sync_from_project.mjs <projectDir> <projectPackage> <projectNamespace>');
  process.exit(1);
}
const proj = path.resolve(projArg);

function reverse(content, rel) {
  let out = content
    .replaceAll(`package:${pkgArg}/`, `package:${TPL_PACKAGE}/`)
    .replaceAll(nsArg, TPL_NAMESPACE)
    .replace(/android:label="[^"]*"/, `android:label="${TPL_PACKAGE}"`);
  if (rel === 'pubspec.yaml') out = out.replace(/^name:\s*\S+/m, `name: ${TPL_PACKAGE}`);
  return out;
}

let text = 0, bin = 0;
function copyFile(from, rel) {
  const to = path.join(DEST, rel);
  fs.mkdirSync(path.dirname(to), { recursive: true });
  if (BINARY_EXT.has(path.extname(from).toLowerCase())) { fs.copyFileSync(from, to); bin++; }
  else { fs.writeFileSync(to, reverse(fs.readFileSync(from, 'utf-8'), rel), 'utf-8'); text++; }
}
function walk(absDir, relDir) {
  for (const e of fs.readdirSync(absDir, { withFileTypes: true })) {
    const from = path.join(absDir, e.name);
    const rel = path.join(relDir, e.name);
    if (e.isDirectory()) walk(from, rel); else copyFile(from, rel);
  }
}

for (const t of TRACKED) {
  const src = path.join(proj, t);
  if (!fs.existsSync(src)) { console.warn(`  ! not in project, skipped: ${t}`); continue; }
  fs.statSync(src).isDirectory() ? walk(src, t) : copyFile(src, t);
}
console.log(`Synced into base_app: ${text} text + ${bin} binary files (from ${proj})`);
