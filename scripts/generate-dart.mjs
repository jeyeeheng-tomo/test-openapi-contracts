// Regenerates the Dart API clients under generated/dart/ from the bundled specs,
// using Kiota. Run: npm run generate:dart
//
// Output is committed, same as the Kotlin models, so a contract PR carries the
// Dart diff it causes. CI regenerates and fails if the committed output is stale.
import { execFileSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import { readdirSync, readFileSync, writeFileSync, mkdirSync, rmSync, statSync, chmodSync } from 'node:fs';
import { join } from 'node:path';
import { arch, platform } from 'node:os';

const BUNDLED_DIR = join('dist', 'specs');
const OUT_DIR = join('generated', 'dart');
const LIB_DIR = join(OUT_DIR, 'lib');
const CACHE_DIR = '.kiota';

const cfg = JSON.parse(readFileSync('codegen.json', 'utf8')).dart;
const { kiotaVersion, kiotaChecksums, packageName, packageVersion, sdkConstraint, dependencies } = cfg;

// --- Resolve the right release asset for this machine -----------------------
const PLATFORMS = { darwin: 'osx', linux: 'linux', win32: 'win' };
const ARCHES = { arm64: 'arm64', x64: 'x64' };
const osKey = PLATFORMS[platform()];
const archKey = ARCHES[arch()];
if (!osKey || !archKey) {
  console.error(`Unsupported platform for Kiota: ${platform()}/${arch()}`);
  process.exit(1);
}
const asset = `${osKey}-${archKey}`;
const checksumKey = `${platform()}-${archKey}`;
const expected = kiotaChecksums[checksumKey];
if (!expected) {
  console.error(
    `No pinned Kiota checksum for ${checksumKey}.\n` +
    `GitHub publishes no checksums for these assets, so each platform is pinned in codegen.json.\n` +
    `Add one with:  ./scripts/pin-kiota-checksums.sh ${kiotaVersion}`,
  );
  process.exit(1);
}

const binDir = join(CACHE_DIR, `kiota-${kiotaVersion}-${asset}`);
const bin = join(binDir, 'kiota');
const zipPath = join(CACHE_DIR, `kiota-${kiotaVersion}-${asset}.zip`);
const url = `https://github.com/microsoft/kiota/releases/download/v${kiotaVersion}/${asset}.zip`;

function sha256(path) {
  return createHash('sha256').update(readFileSync(path)).digest('hex');
}

async function ensureKiota() {
  try {
    if (statSync(bin).isFile()) {
      console.log(`kiota ${kiotaVersion} (${asset}): cached`);
      return;
    }
  } catch { /* not cached */ }

  mkdirSync(CACHE_DIR, { recursive: true });
  console.log(`kiota ${kiotaVersion} (${asset}): downloading`);
  const res = await fetch(url);
  if (!res.ok) throw new Error(`GET ${url} -> ${res.status} ${res.statusText}`);
  writeFileSync(zipPath, Buffer.from(await res.arrayBuffer()));

  const actual = sha256(zipPath);
  if (actual !== expected) {
    rmSync(zipPath, { force: true });
    throw new Error(
      `Checksum mismatch for Kiota ${kiotaVersion} ${asset}.\n` +
      `  expected ${expected}\n  actual   ${actual}\n` +
      `Refusing to run an unverified binary.`,
    );
  }

  rmSync(binDir, { recursive: true, force: true });
  mkdirSync(binDir, { recursive: true });
  execFileSync('unzip', ['-q', zipPath, '-d', binDir]);
  chmodSync(bin, 0o755);
  rmSync(zipPath, { force: true });
  console.log(`kiota ${kiotaVersion} (${asset}): verified`);
}

// --- Generate ----------------------------------------------------------------
const specs = (() => {
  try {
    return readdirSync(BUNDLED_DIR).filter((f) => f.endsWith('.yaml')).sort();
  } catch {
    console.error(`No bundled specs in ${BUNDLED_DIR}. Run \`npm run bundle\` first.`);
    process.exit(1);
  }
})();

await ensureKiota();

rmSync(OUT_DIR, { recursive: true, force: true });
mkdirSync(LIB_DIR, { recursive: true });

const pascal = (s) => s.split(/[-_]/).map((w) => w[0].toUpperCase() + w.slice(1)).join('');

for (const file of specs) {
  const service = file.replace(/\.yaml$/, '');
  const opts = cfg.services?.[service] ?? {};
  const clientName = opts.clientClassName ?? `${pascal(service)}ApiClient`;
  const outDir = join(LIB_DIR, service);

  console.log(`generating ${service} -> ${clientName}`);
  try {
    execFileSync(
      bin,
      [
        'generate',
        '--language', 'Dart',
        // Relative path on purpose: Kiota records the description location in
        // kiota-lock.json, and an absolute one would differ between machines.
        '--openapi', join(BUNDLED_DIR, file),
        '--output', outDir,
        '--class-name', clientName,
        '--namespace-name', `${packageName}.${service}`,
        '--clean-output',
      ],
      { stdio: ['ignore', 'ignore', 'pipe'] },
    );
  } catch (err) {
    console.error(`\nKiota failed on ${file}:\n${err.stderr?.toString() ?? err.message}`);
    process.exit(1);
  }

  // kiota-lock.json pins an absolute description path and .kiota.log is noise;
  // both would make the committed output machine-dependent.
  rmSync(join(outDir, 'kiota-lock.json'), { force: true });
  rmSync(join(outDir, '.kiota.log'), { force: true });
}

// --- Package metadata --------------------------------------------------------
const deps = Object.entries(dependencies).map(([k, v]) => `  ${k}: ${v}`).join('\n');
writeFileSync(
  join(OUT_DIR, 'pubspec.yaml'),
  `# Generated by scripts/generate-dart.mjs — do not edit.
name: ${packageName}
description: API clients generated from the OpenAPI contracts in this repo.
version: ${packageVersion}
publish_to: none

environment:
  sdk: '${sdkConstraint}'

dependencies:
${deps}
`,
);

// Generated code is not ours to lint.
writeFileSync(join(OUT_DIR, 'analysis_options.yaml'), 'analyzer:\n  errors:\n    todo: ignore\n');

const count = execFileSync('find', [LIB_DIR, '-name', '*.dart', '-type', 'f']).toString().trim().split('\n').filter(Boolean).length;
console.log(`\nwrote ${count} Dart file(s) to ${LIB_DIR}`);
