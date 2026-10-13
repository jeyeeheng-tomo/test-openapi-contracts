// Regenerates the Dart API clients under generated/dart/ from the bundled specs,
// using OpenAPI Generator's `dart-dio` generator with json_serializable.
// Run: npm run generate:dart
//
// Output is committed, same as the Kotlin models, so a contract PR carries the
// Dart diff it causes. CI regenerates and fails if the committed output is stale.
//
// Two-stage pipeline, because openapi-generator emits `part '*.g.dart'` files but
// not their contents:
//   1. openapi-generator  -> models/APIs annotated with @JsonSerializable
//   2. dart run build_runner -> the matching *.g.dart (de)serializers
// The .g.dart output is committed too: consumers pull this package as a git
// dependency and will not run build_runner on it themselves.
import { execFileSync } from 'node:child_process';
import { readdirSync, readFileSync, writeFileSync, mkdirSync, rmSync, renameSync } from 'node:fs';
import { join } from 'node:path';

// Use the generator CLI installed in node_modules, not a fresh download.
const GENERATOR_CLI = join('node_modules', '.bin', 'openapi-generator-cli');

const BUNDLED_DIR = join('dist', 'specs');
const OUT_DIR = join('generated', 'dart');
const LIB_DIR = join(OUT_DIR, 'lib');
const WORK_DIR = join('.openapi-generator', 'work');

const cfg = JSON.parse(readFileSync('codegen.json', 'utf8')).dart;
const {
  openapiGeneratorVersion, generator, packageName, packageVersion, sdkConstraint,
  additionalProperties, dependencies, devDependencies, services: overrides,
} = cfg;

function run(cmd, args, opts = {}) {
  return execFileSync(cmd, args, { stdio: ['ignore', 'pipe', 'pipe'], ...opts });
}

// --- Preflight ---------------------------------------------------------------
// openapi-generator is a Java tool and build_runner needs the Dart SDK. Fail with
// a useful message rather than a stack trace from execFileSync.
for (const [bin, hint] of [['java', 'Java 17+'], ['dart', 'the Dart SDK']]) {
  try {
    run(bin, ['--version']);
  } catch {
    console.error(`\`${bin}\` not found on PATH. The Dart codegen needs ${hint}.`);
    process.exit(1);
  }
}

// openapi-generator-cli resolves its jar version from openapitools.json and only
// falls back to OPENAPI_GENERATOR_VERSION when that file is absent. Write it from
// codegen.json so the pin there is the single source of truth and cannot go stale.
writeFileSync(
  'openapitools.json',
  JSON.stringify({
    $schema: './node_modules/@openapitools/openapi-generator-cli/config.schema.json',
    spaces: 2,
    'generator-cli': { version: openapiGeneratorVersion },
  }, null, 2) + '\n',
);

const specs = (() => {
  try {
    return readdirSync(BUNDLED_DIR).filter((f) => f.endsWith('.yaml')).sort();
  } catch {
    console.error(`No bundled specs in ${BUNDLED_DIR}. Run \`npm run bundle\` first.`);
    process.exit(1);
  }
})();

// --- Generate one package per service, merged into one Dart package ----------
// openapi-generator lays each service out as a standalone package rooted at
// lib/src/. We relocate each into lib/<service>/ and rewrite the package: imports
// to match, so the whole repo ships as a single `api_contracts` package with one
// barrel file per service.
rmSync(OUT_DIR, { recursive: true, force: true });
rmSync(WORK_DIR, { recursive: true, force: true });
mkdirSync(LIB_DIR, { recursive: true });

const generated = [];

for (const file of specs) {
  const service = file.replace(/\.yaml$/, '');
  const props = { ...additionalProperties, ...(overrides?.[service]?.additionalProperties ?? {}) };
  const stage = join(WORK_DIR, service);

  const propArg = Object.entries({ ...props, pubName: packageName })
    .map(([k, v]) => `${k}=${v}`)
    .join(',');

  console.log(`generating ${service} -> lib/${service}/`);
  try {
    run(
      GENERATOR_CLI,
      [
        'generate',
        '-i', join(BUNDLED_DIR, file),
        '-g', generator,
        '-o', stage,
        '--additional-properties', propArg,
      ],
    );
  } catch (err) {
    console.error(`\nopenapi-generator failed on ${file}:\n${err.stderr?.toString() ?? err.message}`);
    process.exit(1);
  }

  // lib/src/** -> lib/<service>/**, and the barrel lib/<pubName>.dart -> lib/<service>.dart
  renameSync(join(stage, 'lib', 'src'), join(LIB_DIR, service));
  renameSync(join(stage, 'lib', `${packageName}.dart`), join(LIB_DIR, `${service}.dart`));
  generated.push(service);
}

// Two rewrites per service tree:
//   1. `package:<pkg>/src/...` -> `package:<pkg>/<service>/...`, to match the move above.
//   2. the entrypoint class `ApiContracts` -> `<Service>ApiClient`. openapi-generator
//      names it after pubName, which is the same for every service, so without this
//      two services collide for anyone importing both barrels.
const pascal = (s) => s.split(/[-_]/).map((w) => w[0].toUpperCase() + w.slice(1)).join('');
const entrypointClass = pascal(packageName);

for (const service of generated) {
  const clientName = overrides?.[service]?.clientClassName ?? `${pascal(service)}ApiClient`;
  const files = run('find', [join(LIB_DIR, service), join(LIB_DIR, `${service}.dart`), '-name', '*.dart', '-type', 'f'])
    .toString().trim().split('\n').filter(Boolean);
  for (const f of files) {
    const before = readFileSync(f, 'utf8');
    const after = before
      .replaceAll(`package:${packageName}/src/`, `package:${packageName}/${service}/`)
      .replaceAll(new RegExp(`\\b${entrypointClass}\\b`, 'g'), clientName);
    if (after !== before) writeFileSync(f, after);
  }
}

rmSync(WORK_DIR, { recursive: true, force: true });

// --- Package metadata --------------------------------------------------------
const block = (o) => Object.entries(o).map(([k, v]) => `  ${k}: ${v}`).join('\n');
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
${block(dependencies)}

dev_dependencies:
${block(devDependencies)}
`,
);

// Generated code is not ours to lint. `dart analyze` exits non-zero on warnings,
// so anything the generator emits that we cannot fix from the spec is demoted
// here rather than left to fail CI.
writeFileSync(
  join(OUT_DIR, 'analysis_options.yaml'),
  `# Generated by scripts/generate-dart.mjs — do not edit.
analyzer:
  errors:
    todo: ignore
    unused_import: ignore
    unused_element: ignore
  exclude:
    - "**/*.g.dart"
`,
);

// --- Stage 2: build_runner fills in the *.g.dart serializers -----------------
console.log('\nresolving Dart dependencies');
try {
  run('dart', ['pub', 'get'], { cwd: OUT_DIR });
} catch (err) {
  console.error(`\n\`dart pub get\` failed:\n${err.stderr?.toString() ?? err.message}`);
  process.exit(1);
}

console.log('running build_runner (generates *.g.dart)');
try {
  run('dart', ['run', 'build_runner', 'build', '--delete-conflicting-outputs'], { cwd: OUT_DIR });
} catch (err) {
  console.error(`\nbuild_runner failed:\n${err.stdout?.toString() ?? ''}${err.stderr?.toString() ?? err.message}`);
  process.exit(1);
}

// Formatting is part of the output contract: unformatted generator output would
// otherwise churn the committed diff on every regeneration.
console.log('formatting');
run('dart', ['format', '.'], { cwd: OUT_DIR });

const all = run('find', [LIB_DIR, '-name', '*.dart', '-type', 'f']).toString().trim().split('\n').filter(Boolean);
const serializers = all.filter((f) => f.endsWith('.g.dart')).length;
console.log(
  `\nwrote ${all.length} Dart file(s) to ${LIB_DIR} ` +
  `(${all.length - serializers} generated + ${serializers} build_runner), ` +
  `services: ${generated.join(', ')}`,
);
