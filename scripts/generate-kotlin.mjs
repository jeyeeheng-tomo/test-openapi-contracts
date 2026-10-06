// Regenerates the Kotlin models under generated/kotlin/ from the bundled specs,
// using Fabrikt. Run: npm run generate:kotlin
//
// Output is committed to the repo so that a contract PR shows the exact Kotlin
// diff it causes. CI regenerates and fails if the committed output is stale.
import { execFileSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import { readdirSync, readFileSync, writeFileSync, mkdirSync, rmSync, statSync } from 'node:fs';
import { join } from 'node:path';

const BUNDLED_DIR = join('dist', 'specs');
const OUT_DIR = join('generated', 'kotlin');
const CACHE_DIR = '.fabrikt';

const config = JSON.parse(readFileSync('codegen.json', 'utf8')).kotlin;
const { fabriktVersion, defaults, services: overrides } = config;

// --- Fetch and cache the Fabrikt jar, verifying its published checksum -------
const jarPath = join(CACHE_DIR, `fabrikt-${fabriktVersion}.jar`);
const baseUrl = `https://repo1.maven.org/maven2/com/cjbooms/fabrikt/${fabriktVersion}`;

function sha1(path) {
  return createHash('sha1').update(readFileSync(path)).digest('hex');
}

async function download(url, dest) {
  const res = await fetch(url);
  if (!res.ok) throw new Error(`GET ${url} -> ${res.status} ${res.statusText}`);
  writeFileSync(dest, Buffer.from(await res.arrayBuffer()));
}

async function ensureJar() {
  mkdirSync(CACHE_DIR, { recursive: true });
  const expected = (await (await fetch(`${baseUrl}/fabrikt-${fabriktVersion}.jar.sha1`)).text()).trim().split(/\s+/)[0];

  try {
    if (statSync(jarPath).isFile() && sha1(jarPath) === expected) {
      console.log(`fabrikt ${fabriktVersion}: cached`);
      return;
    }
  } catch { /* not cached yet */ }

  console.log(`fabrikt ${fabriktVersion}: downloading`);
  await download(`${baseUrl}/fabrikt-${fabriktVersion}.jar`, jarPath);

  const actual = sha1(jarPath);
  if (actual !== expected) {
    rmSync(jarPath, { force: true });
    throw new Error(`Checksum mismatch for fabrikt-${fabriktVersion}.jar: expected ${expected}, got ${actual}`);
  }
  console.log(`fabrikt ${fabriktVersion}: verified`);
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

await ensureJar();

rmSync(OUT_DIR, { recursive: true, force: true });
mkdirSync(OUT_DIR, { recursive: true });

for (const file of specs) {
  const service = file.replace(/\.yaml$/, '');
  const opts = { ...defaults, ...(overrides?.[service] ?? {}) };
  const basePackage = opts.basePackage ?? `${opts.basePackagePrefix}.${service}`;

  const args = [
    '-jar', jarPath,
    '--api-file', join(BUNDLED_DIR, file),
    '--base-package', basePackage,
    '--output-directory', OUT_DIR,
    '--targets', ...opts.targets,
    '--validation-library', opts.validationLibrary,
    '--serialization-library', opts.serializationLibrary,
  ];
  if (opts.typeOverrides?.length) args.push('--type-overrides', ...opts.typeOverrides);
  if (opts.modelOptions?.length) args.push('--http-model-opts', ...opts.modelOptions);

  console.log(`generating ${service} -> ${basePackage}`);
  try {
    execFileSync('java', args, { stdio: ['ignore', 'ignore', 'pipe'] });
  } catch (err) {
    const stderr = err.stderr?.toString() ?? '';
    console.error(`\nFabrikt failed on ${file}:\n${stderr}`);
    if (stderr.includes('invalid combination of properties')) {
      console.error(
        'Hint: Fabrikt rejects a schema that has `properties` and `allOf`/`oneOf`/`anyOf`\n' +
        '      at the same level. Move the properties into the allOf list. See CONTRIBUTING.md.',
      );
    }
    process.exit(1);
  }
}

const count = execFileSync('find', [OUT_DIR, '-name', '*.kt', '-type', 'f']).toString().trim().split('\n').filter(Boolean).length;
console.log(`\nwrote ${count} Kotlin file(s) to ${OUT_DIR}`);
