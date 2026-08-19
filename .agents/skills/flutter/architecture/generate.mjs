#!/usr/bin/env node
// Headless generator for the GSE base architecture. No VSCode required.
// Copies the editable base_app/ template into a target project, replacing the
// package name and Android namespace — same transform the retired extension did.
//
// Usage:
//   node generate.mjs <targetDir> [packageName] [androidNamespace]
//
//   targetDir         where to write the project (created if missing)
//   packageName       Dart package name (default: sanitized basename of targetDir)
//   androidNamespace  Android namespace  (default: com.example.<packageName>)
//
// After it runs:  cd <targetDir> && flutter pub get && dart run tools/setup_flavors.dart
import * as fs from 'node:fs';
import * as path from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';

const HERE = path.dirname(fileURLToPath(import.meta.url));
const SRC = path.join(HERE, 'base_app');
const FLUTTER_SKILLS = path.join(HERE, '..'); // .agents/skills/flutter

const SOURCE_PACKAGE = 'gse_base_app';
const SOURCE_NAMESPACE = 'com.example.gse_base_app';

// Feature-generation skills distributed into each project's .claude/skills/ (single source =
// the hub). They cross-reference each other via .claude/skills/<name>.md, so ship them together.
const PROJECT_SKILLS = ['check-arch', 'clean-code', 'new-bloc', 'new-model', 'new-module', 'new-repository', 'new-screen'];

const BINARY_EXT = new Set(['.ttf', '.png', '.jpg', '.jpeg', '.gif', '.ico', '.otf', '.woff', '.woff2']);

function fail(msg) { console.error(`Error: ${msg}`); process.exit(1); }

const [, , targetArg, pkgArg, nsArg] = process.argv;
if (!targetArg) fail('missing <targetDir>. Usage: node generate.mjs <targetDir> [packageName] [androidNamespace]');
if (!fs.existsSync(SRC)) fail(`base_app template not found at ${SRC}`);

const targetDir = path.resolve(targetArg);
const packageName = (pkgArg || path.basename(targetDir))
  .toLowerCase().replace(/[^a-z0-9_]/g, '_').replace(/^_+|_+$/g, '') || 'app';
const androidNamespace = nsArg || `com.example.${packageName}`;

function transform(content) {
  return content
    .replaceAll(`package:${SOURCE_PACKAGE}/`, `package:${packageName}/`)
    .replaceAll(SOURCE_NAMESPACE, androidNamespace);
}

let text = 0, bin = 0;
function walk(dir) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const from = path.join(dir, entry.name);
    const rel = path.relative(SRC, from);
    const to = path.join(targetDir, rel);
    if (entry.isDirectory()) { fs.mkdirSync(to, { recursive: true }); walk(from); continue; }
    fs.mkdirSync(path.dirname(to), { recursive: true });
    if (BINARY_EXT.has(path.extname(entry.name).toLowerCase())) {
      fs.copyFileSync(from, to); bin++;
    } else {
      let content = transform(fs.readFileSync(from, 'utf-8'));
      if (rel === 'pubspec.yaml') content = content.replace(/^name:\s*\S+/m, `name: ${packageName}`);
      fs.writeFileSync(to, content, 'utf-8'); text++;
    }
  }
}

fs.mkdirSync(targetDir, { recursive: true });
walk(SRC);

// Distribute the feature-generation skills into the project's .claude/skills/.
let skills = 0;
const skillsDir = path.join(targetDir, '.claude', 'skills');
fs.mkdirSync(skillsDir, { recursive: true });
for (const name of PROJECT_SKILLS) {
  const from = path.join(FLUTTER_SKILLS, name, 'SKILL.md');
  if (!fs.existsSync(from)) { console.warn(`  ! skill not found, skipped: ${name}`); continue; }
  fs.writeFileSync(path.join(skillsDir, `${name}.md`), fs.readFileSync(from, 'utf-8')); skills++;
}

console.log(`Generated "${packageName}" (namespace ${androidNamespace})`);
console.log(`  ${text} source files + ${bin} assets + ${skills} skills → ${targetDir}`);

// Bootstrap: resolve deps and normalize imports for the new package name.
// `directives_ordering` sorts package: imports alphabetically, so renaming the
// package shifts the app's own imports — `dart fix` re-sorts them. These run
// SYNCHRONOUSLY and in order: `dart fix` needs the package_config that
// `pub get` writes, so it must not start until pub get has finished.
const bootstrapped = bootstrap(targetDir);

console.log('\nNext:');
console.log(`  cd "${targetDir}"`);
if (!bootstrapped) {
  console.log('  flutter pub get');
  console.log('  dart fix --apply                          # sort imports for the new package name');
}
console.log('  dart run tools/setup_flavors.dart          # generates dev/stg/prod flavors');
console.log('  dart run build_runner build --delete-conflicting-outputs');

/**
 * Runs `pub get` then `dart fix --apply` in the generated project, in order.
 * Uses FVM when the project pins a version (.fvmrc) and fvm is available;
 * otherwise falls back to flutter/dart on PATH. Non-fatal: if the toolchain
 * isn't found the manual steps are printed instead.
 */
function bootstrap(dir) {
  const useFvm = fs.existsSync(path.join(dir, '.fvmrc')) && cmdExists('fvm');
  const flutter = useFvm ? { bin: 'fvm', pre: ['flutter'] } : { bin: 'flutter', pre: [] };
  const dart = useFvm ? { bin: 'fvm', pre: ['dart'] } : { bin: 'dart', pre: [] };
  const steps = [
    ['flutter pub get', flutter.bin, [...flutter.pre, 'pub', 'get']],
    ['dart fix --apply', dart.bin, [...dart.pre, 'fix', '--apply']],
  ];
  for (const [label, cmd, cmdArgs] of steps) {
    console.log(`\n> ${label}${useFvm ? ' (fvm)' : ''}`);
    const r = spawnSync(cmd, cmdArgs, { cwd: dir, stdio: 'inherit' }); // sync: waits for completion
    if (r.error || r.status !== 0) {
      const why = r.error ? r.error.code : `exit ${r.status}`;
      console.warn(`  ! could not run "${label}" automatically (${why}) — run it manually (see Next).`);
      return false;
    }
  }
  return true;
}

function cmdExists(cmd) {
  return !spawnSync(cmd, ['--version'], { stdio: 'ignore' }).error;
}
