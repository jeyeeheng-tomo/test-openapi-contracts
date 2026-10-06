// Bundles every spec under specs/<service>/openapi.yaml into dist/specs/,
// then writes a Swagger UI page with a service picker. Run: npm run bundle
import { execFileSync } from 'node:child_process';
import { readdirSync, readFileSync, mkdirSync, writeFileSync, rmSync, statSync } from 'node:fs';
import { join } from 'node:path';

// Use the redocly installed in node_modules, not a fresh download.
const REDOCLY = join('node_modules', '.bin', 'redocly');

const SPECS_DIR = 'specs';
const OUT_DIR = 'dist';

const services = readdirSync(SPECS_DIR)
  .filter((name) => {
    const root = join(SPECS_DIR, name, 'openapi.yaml');
    try { return statSync(root).isFile(); } catch { return false; }
  })
  .sort();

if (services.length === 0) {
  console.error(`No specs found under ${SPECS_DIR}/<service>/openapi.yaml`);
  process.exit(1);
}

rmSync(OUT_DIR, { recursive: true, force: true });
mkdirSync(join(OUT_DIR, 'specs'), { recursive: true });

const entries = services.map((name) => {
  const root = join(SPECS_DIR, name, 'openapi.yaml');
  const out = join(OUT_DIR, 'specs', `${name}.yaml`);
  console.log(`bundling ${root} -> ${out}`);
  execFileSync(REDOCLY, ['bundle', root, '-o', out], { stdio: 'inherit' });

  // Pull the display name straight out of the bundled spec.
  const bundled = readFileSync(out, 'utf8');
  const title = bundled.match(/^\s{2}title:\s*(.+)$/m)?.[1].trim().replace(/^['"]|['"]$/g, '') ?? name;
  const version = bundled.match(/^\s{2}version:\s*(.+)$/m)?.[1].trim().replace(/^['"]|['"]$/g, '') ?? '';
  return { name, title, version, url: `specs/${name}.yaml` };
});

const urls = entries.map((e) => ({ name: `${e.title}${e.version ? ` (v${e.version})` : ''}`, url: e.url }));

const html = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>API Contracts</title>
  <link rel="icon" href="data:," />
  <link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist@5.17.14/swagger-ui.css" />
  <style>
    body { margin: 0; background: #fafafa; }
    .topbar { background: #1b1b1f; color: #fff; padding: 12px 20px; font: 600 15px/1.4 system-ui, sans-serif; }
    .topbar span { font-weight: 400; opacity: .7; margin-left: 10px; font-size: 13px; }
  </style>
</head>
<body>
  <div class="topbar">API Contracts<span>generated from specs/ on every push to main</span></div>
  <div id="swagger-ui"></div>
  <script src="https://unpkg.com/swagger-ui-dist@5.17.14/swagger-ui-bundle.js" crossorigin></script>
  <script src="https://unpkg.com/swagger-ui-dist@5.17.14/swagger-ui-standalone-preset.js" crossorigin></script>
  <script>
    window.ui = SwaggerUIBundle({
      urls: ${JSON.stringify(urls, null, 6)},
      dom_id: '#swagger-ui',
      deepLinking: true,
      docExpansion: 'list',
      defaultModelsExpandDepth: 1,
      presets: [SwaggerUIBundle.presets.apis, SwaggerUIStandalonePreset],
      layout: 'StandaloneLayout',
    });
  </script>
</body>
</html>
`;

writeFileSync(join(OUT_DIR, 'index.html'), html);
// Tell GitHub Pages not to run the output through Jekyll.
writeFileSync(join(OUT_DIR, '.nojekyll'), '');
console.log(`\nwrote ${OUT_DIR}/index.html with ${entries.length} spec(s): ${entries.map((e) => e.name).join(', ')}`);
