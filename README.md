# API Contracts

The source of truth for our HTTP API contracts. Backend and frontend engineers
agree on the contract **here, in a PR**, before either side writes code.

📖 **Docs:** https://YOUR-ORG.github.io/YOUR-REPO/ (Swagger UI, rebuilt on every push to `main`)

## Layout

```
specs/
  shared/components.yaml   # errors, pagination params, auth scheme — reused by every service
  users/openapi.yaml       # Users API
  orders/openapi.yaml      # Orders API
generated/kotlin/          # Fabrikt-generated Kotlin models (committed, DO NOT EDIT)
scripts/build-site.mjs     # bundles specs + generates the Swagger UI page
scripts/generate-kotlin.mjs # runs Fabrikt over the bundled specs
codegen.json               # Fabrikt version + generation settings
redocly.yaml               # lint rules
```

Specs are auto-discovered: anything at `specs/<service>/openapi.yaml` is linted,
bundled, and shows up in the Swagger UI service picker. There is no registry to update.

## Working locally

```bash
npm install
npm run lint      # validate specs against the lint rules
npm run bundle    # resolve $refs into dist/specs/*.yaml and build dist/index.html
npm run generate:kotlin  # regenerate the Kotlin models from the bundled specs
npm run preview   # build, then serve the docs at http://localhost:8080
npm run check     # lint + bundle + generate — what CI runs
```

Codegen needs a JDK (17+) on your PATH. The Fabrikt jar is downloaded on first
use into `.fabrikt/`, checksum-verified against Maven Central, and cached.

## Generated Kotlin models

`generated/kotlin/` holds Jackson data classes with `jakarta.validation`
annotations, produced by [Fabrikt](https://github.com/cjbooms/fabrikt) from the
bundled specs. One package per service: `com.example.contracts.<service>.models`.

**The output is committed on purpose.** A contract PR then shows the exact Kotlin
diff it causes, which is the thing backend reviewers actually care about:

```diff
  specs/orders/openapi.yaml
+   refund_reason: { type: string }

  generated/kotlin/.../Order.kt
+   @get:JsonProperty("refund_reason")
+   public val refundReason: String? = null
```

CI regenerates on every PR and **fails if the committed models are stale**. If the
`kotlin-models` check is red, run `npm run check` and commit the result.

Never hand-edit anything under `generated/`. Change the contract, or the settings
in `codegen.json` (Fabrikt version, base package, targets, validation library).

## Adding a service

1. `mkdir specs/payments && $EDITOR specs/payments/openapi.yaml`
2. Reuse the shared pieces rather than redefining them:
   ```yaml
   responses:
     '404':
       $ref: '../shared/components.yaml#/components/responses/NotFound'
   ```
3. `npm run check`, open a PR.
4. Add the team to `.github/CODEOWNERS`.

## Conventions

- `snake_case` for JSON properties, `camelCase` for `operationId` and path params.
- Plural, lowercase resource paths: `/orders/{orderId}/cancel`.
- Money is always `{ amount_minor: int64, currency: "SGD" }` — never a float.
- Cursor pagination: `page_size` + `page_token` in, `next_page_token` out.
- Every error response uses the shared `Error` schema with a stable `code`.
- Every operation needs an `operationId`, a `summary`, and at least one 4xx response.
  CI fails without them.

## Versioning

The version lives in the path (`/users/v1`) and in `info.version`.

- **Additive** changes (new endpoint, new optional field) ship in place.
- **Breaking** changes (removing/renaming a field, making a field required,
  narrowing a type, changing a status code) need a new major path version and a
  migration plan. CI flags them against the base branch.

## See also

- [CONTRIBUTING.md](CONTRIBUTING.md) — PR workflow and review expectations
- [docs/github-pages-setup.md](docs/github-pages-setup.md) — one-time Pages setup
