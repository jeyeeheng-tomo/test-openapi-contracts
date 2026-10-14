// Extracts the named `examples:` out of the bundled specs into mock fixtures
// the frontend can use without a backend. Run: npm run generate:fixtures
//
// Two outputs from one source:
//   generated/fixtures/<service>/<operationId>.<status>.<Name>.json
//       plain JSON for Flutter asset bundles, Postman, MSW, a mock server, tests
//   generated/dart/lib/<service>/fixtures.dart
//       typed getters that parse those payloads into the generated models
//
// The examples live in the contract (specs/<service>/examples/*.yaml), so
// `redocly lint` validates every one against its own response schema via the
// no-invalid-media-type-examples rule. A fixture cannot drift from the contract
// without failing CI — that is the whole point of generating them from here.
//
// Runs after generate:dart, which wipes generated/dart/ wholesale.
import { execFileSync } from 'node:child_process';
import { readdirSync, readFileSync, writeFileSync, mkdirSync, rmSync, existsSync } from 'node:fs';
import { join } from 'node:path';

const BUNDLED_DIR = join('dist', 'specs');
const FIXTURE_DIR = join('generated', 'fixtures');
const DART_LIB = join('generated', 'dart', 'lib');

const REDOCLY = join('node_modules', '.bin', 'redocly');

const specs = (() => {
  try {
    return readdirSync(BUNDLED_DIR).filter((f) => f.endsWith('.yaml')).sort();
  } catch {
    console.error(`No bundled specs in ${BUNDLED_DIR}. Run \`npm run bundle\` first.`);
    process.exit(1);
  }
})();

// Redocly is already a dependency and resolves $refs; reuse it to turn the
// bundled YAML into JSON rather than taking on a YAML parser of our own.
function specAsJson(file) {
  const out = join(BUNDLED_DIR, `.${file}.json`);
  execFileSync(REDOCLY, ['bundle', join(BUNDLED_DIR, file), '-o', out, '--ext', 'json'], { stdio: 'ignore' });
  const json = JSON.parse(readFileSync(out, 'utf8'));
  rmSync(out, { force: true });
  return json;
}

// Redocly hoists examples into components.examples and leaves a local $ref in
// the media type, so every example has to be dereferenced before use.
function deref(node, spec, seen = 0) {
  if (!node?.$ref || seen > 10) return node;
  const path = node.$ref.replace(/^#\//, '').split('/').map((p) => p.replace(/~1/g, '/').replace(/~0/g, '~'));
  const target = path.reduce((acc, key) => acc?.[key], spec);
  return deref(target, spec, seen + 1);
}

// Embeds a JSON payload as a Dart string literal. Raw triple-quoted is the
// readable form and needs no escaping of `$`, which JSON payloads are full of —
// but it breaks if the payload itself contains the closing delimiter, so fall
// back to the other delimiter, then to a fully escaped literal.
function dartStringLiteral(json) {
  if (!json.includes("'''")) return `r'''\n${json}'''`;
  if (!json.includes('"""')) return `r"""\n${json}"""`;
  return JSON.stringify(json).replace(/\$/g, '\\$');
}

const pascal = (s) => s.split(/[-_ ]/).filter(Boolean).map((w) => w[0].toUpperCase() + w.slice(1)).join('');
const camel = (s) => { const p = pascal(s); return p[0].toLowerCase() + p.slice(1); };

// `#/components/schemas/OfferPage` -> `OfferPage`; anything inline -> null,
// because there is no generated Dart class to parse an inline schema into.
const schemaName = (schema) => schema?.$ref?.match(/^#\/components\/schemas\/(.+)$/)?.[1] ?? null;

rmSync(FIXTURE_DIR, { recursive: true, force: true });

let totalFixtures = 0;
const services = [];

for (const file of specs) {
  const service = file.replace(/\.yaml$/, '');
  const spec = specAsJson(file);
  const entries = [];

  for (const [route, pathItem] of Object.entries(spec.paths ?? {})) {
    for (const [method, op] of Object.entries(pathItem)) {
      if (!op?.operationId) continue;
      for (const [status, response] of Object.entries(op.responses ?? {})) {
        const media = response?.content?.['application/json'];
        if (!media?.examples) continue;

        for (const [name, ref] of Object.entries(media.examples)) {
          const example = deref(ref, spec);
          // `value` holds the payload; `externalValue` is a URL we do not follow.
          if (!example || !('value' in example)) continue;
          entries.push({
            route,
            method: method.toUpperCase(),
            operationId: op.operationId,
            status,
            name,
            summary: example.summary ?? '',
            type: schemaName(media.schema),
            value: example.value,
          });
        }
      }
    }
  }

  if (entries.length === 0) {
    console.log(`${service}: no examples in the contract, nothing to extract`);
    continue;
  }

  // --- JSON, for anyone ------------------------------------------------------
  const outDir = join(FIXTURE_DIR, service);
  mkdirSync(outDir, { recursive: true });
  for (const e of entries) {
    e.file = `${e.operationId}.${e.status}.${e.name}.json`;
    writeFileSync(join(outDir, e.file), JSON.stringify(e.value, null, 2) + '\n');
  }

  // An index so a mock server or test harness can discover them without globbing.
  writeFileSync(
    join(outDir, 'index.json'),
    JSON.stringify(
      entries.map(({ route, method, operationId, status, name, summary, type, file }) =>
        ({ route, method, operationId, status, name, summary, type, file })),
      null, 2,
    ) + '\n',
  );

  // --- Dart, typed -----------------------------------------------------------
  // The payload is embedded as a string constant rather than loaded from an
  // asset: a git/path dependency cannot register assets in the consuming app's
  // pubspec, so an asset-based fixture would not load for consumers.
  // Guard on the service's own directory: generate:dart may not have run, or a
  // spec may have been added since it last did.
  if (existsSync(join(DART_LIB, service))) {
    const typed = entries.filter((e) => e.type);
    const imports = [...new Set(typed.map((e) => e.type))].sort()
      .map((t) => `import 'package:api_contracts/${service}/model/${t.replace(/([a-z0-9])([A-Z])/g, '$1_$2').toLowerCase()}.dart';`)
      .join('\n');

    const members = entries.map((e) => {
      const base = `${camel(e.operationId)}${e.status}${pascal(e.name)}`;
      const doc = `  /// `
        + `${e.method} ${e.route} -> ${e.status}${e.summary ? ` — ${e.summary}` : ''}\n`
        + `  /// Source: specs/${service}/examples/, extracted by scripts/generate-fixtures.mjs.`;
      const raw = `${doc}\n  static const String ${base}Json = ${dartStringLiteral(JSON.stringify(e.value, null, 2))};`;
      if (!e.type) return raw;
      const parsed = `\n\n${doc}\n  static ${e.type} get ${base} =>\n`
        + `      ${e.type}.fromJson(jsonDecode(${base}Json) as Map<String, dynamic>);`;
      return raw + parsed;
    }).join('\n\n');

    writeFileSync(
      join(DART_LIB, service, 'fixtures.dart'),
      `// Generated by scripts/generate-fixtures.mjs from the \`examples:\` in\n`
      + `// specs/${service}/. Do not edit: change the contract instead.\n`
      + `//\n`
      + `// Mock payloads for building UI without a backend. Every one is validated\n`
      + `// against its response schema by \`redocly lint\`, so these parse.\n`
      + `import 'dart:convert';\n\n${imports}\n\n`
      + `abstract final class ${pascal(service)}Fixtures {\n${members}\n}\n`,
    );

    // Export it from the service barrel so consumers get it with one import.
    const barrel = join(DART_LIB, `${service}.dart`);
    const line = `export 'package:api_contracts/${service}/fixtures.dart';`;
    const current = readFileSync(barrel, 'utf8');
    if (!current.includes(line)) writeFileSync(barrel, `${current.trimEnd()}\n\n${line}\n`);
  }

  totalFixtures += entries.length;
  services.push(`${service} (${entries.length})`);
  console.log(`${service}: ${entries.length} fixture(s) -> ${outDir}`);
}

if (existsSync(DART_LIB)) {
  execFileSync('dart', ['format', '.'], { cwd: join('generated', 'dart'), stdio: 'ignore' });
}

console.log(
  totalFixtures === 0
    ? '\nNo examples found. Add `examples:` to a response in specs/<service>/ to get fixtures.'
    : `\nwrote ${totalFixtures} fixture(s) to ${FIXTURE_DIR}: ${services.join(', ')}`,
);
