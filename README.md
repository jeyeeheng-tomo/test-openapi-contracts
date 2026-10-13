# API Contracts

The source of truth for our HTTP API contracts. Backend and frontend engineers
agree on the contract **here, in a PR**, before either side writes code.

📖 **Docs:** <https://jeyeeheng-tomo.github.io/test-openapi-contracts/> — Swagger UI, rebuilt on
every push to `main`. Pages serves from the `Publish Swagger UI` workflow, not a `gh-pages`
branch. **This repo is public** so that Pages works on a Free plan; keep the specs free of
anything that cannot be published.

## Layout

```
specs/
  shared/components.yaml   # errors, pagination params, auth scheme — reused by every service
  offers/
    openapi.yaml           # Offers API — metadata + $refs into paths/ and components/
    paths/                 # one file per path item
    components/            # offers-specific schemas and parameters
generated/kotlin/          # Fabrikt-generated Kotlin models (committed, DO NOT EDIT)
generated/dart/            # OpenAPI Generator Dart clients (committed, DO NOT EDIT)
scripts/build-site.mjs     # bundles specs + generates the Swagger UI page
scripts/generate-kotlin.mjs # runs Fabrikt over the bundled specs
scripts/generate-dart.mjs   # runs openapi-generator + build_runner over the bundled specs
codegen.json               # generator versions + settings
redocly.yaml               # lint rules
```

| Pinned in `codegen.json` | Version |
| --- | --- |
| Fabrikt (Kotlin models) | 23.0.0 |
| OpenAPI Generator (`dart-dio`) | 7.26.0 |
| Dart SDK used by CI | 3.11.5 |

Specs are auto-discovered: anything at `specs/<service>/openapi.yaml` is linted,
bundled, and shows up in the Swagger UI service picker. There is no registry to update.

`openapi.yaml` is the only file a service *needs* — refs are inlined at bundle time, so how
you split the rest is up to you. See [CONTRIBUTING.md](CONTRIBUTING.md#how-a-service-spec-is-laid-out)
for the layout and the ref rules that go with it.

## Working locally

```bash
npm install
npm run lint      # validate specs against the lint rules
npm run bundle    # resolve $refs into dist/specs/*.yaml and build dist/index.html
npm run generate  # regenerate both the Kotlin models and the Dart clients
npm run preview   # build, then serve the docs at http://localhost:8080
npm run check     # lint + bundle + generate — what CI runs
```

`generate:kotlin` and `generate:dart` run one generator each.

**You only need `npm run lint` before opening a PR.** CI owns `generated/` — see
[Generated Kotlin models](#generated-kotlin-models). Running `npm run generate`
locally is for previewing the code your contract change will produce.

Codegen needs **JDK 17+** (both generators are Java tools) and **Dart 3.8+**
(`build_runner` produces the `.g.dart` serializers, and `dart analyze` checks the
result) on your PATH. Fabrikt is downloaded on first use into `.fabrikt/` and
SHA-1 verified; the OpenAPI Generator jar is pinned in `codegen.json` and installed
via `npm ci`. You only need the toolchain for the language you are changing — CI
checks both regardless.

## Generated Kotlin models

`generated/kotlin/` holds Jackson data classes with `jakarta.validation`
annotations, produced by [Fabrikt](https://github.com/cjbooms/fabrikt) from the
bundled specs. One package per service: `com.example.contracts.<service>.models`.

**CI generates and commits this for you.** You do not need to run the generators
before opening a PR — the `codegen` job regenerates everything on every push to
`main` and commits the result back as `Regenerate contract code`.

Never hand-edit anything under `generated/`; the next push to `main` overwrites it.
Change the contract, or the settings in `codegen.json` (Fabrikt version, base
package, targets, validation library).

## Generated Dart clients

`generated/dart/` is a single Dart package, `api_contracts`, holding a
[Dio](https://pub.dev/packages/dio) client per service plus
[`json_serializable`](https://pub.dev/packages/json_serializable) models, produced by
[OpenAPI Generator](https://openapi-generator.tech/)'s `dart-dio` generator. One
barrel file per service: `package:api_contracts/<service>.dart`.

```dart
import 'package:api_contracts/offers.dart';

final client = OffersApiClient();                            // or: basePathOverride: stagingUrl
final api    = OffersApi(client.dio);

final page   = (await api.listOffers(pageSize: 20)).data;    // OfferPage
for (final offer in page!.data) print(offer.title);          // Offer

final offer  = (await api.getOffer(offerId: '018f…')).data;  // Offer
```

Models come out as plain immutable classes — `final` fields, `required` named
constructor params, `@JsonKey(name:)` for the wire name, and `fromJson`/`toJson`:

```dart
@JsonSerializable(checked: true, createToJson: true, explicitToJson: true)
class Offer {
  Offer({required this.id, required this.title, required this.description});

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final String id;
  ...
  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);
}
```

Fields that the contract marks `required` are non-nullable; everything else is
nullable. Enums get a `unknownDefaultOpenApi` member and
`@JsonKey(unknownEnumValue:)`, so a value added by the server does not break an
older client at parse time.

Requires **Dart 3.8+** — `json_serializable` emits null-aware elements.

Consume it from a Flutter app as a git dependency:

```yaml
dependencies:
  api_contracts:
    git:
      url: https://github.com/jeyeeheng-tomo/test-openapi-contracts.git
      path: generated/dart
```

Same as Kotlin: the `codegen` job produces this. On a PR it only proves the
generators still run cleanly and that `dart analyze` passes; on a push to `main`
it commits the result.

**Caveats worth knowing before you build on this:**

- The `json_serializable` mode of the `dart-dio` generator is marked **BETA**
  upstream. The generator version is pinned in `codegen.json` for that reason —
  bump it deliberately and read the Dart diff.
- The entrypoint class is named after `pubName`, which is the same for every
  service, so `generate-dart.mjs` renames it per service to `<Service>ApiClient`.
  Without that, two services would both export `ApiContracts` and collide.
- Only the **first** `servers:` entry becomes `basePath`. Pass `basePathOverride`
  to `<Service>ApiClient` to point at staging.
- `format: email` (and other unsupported formats) degrade to plain `String`.
- Generator output is run through `dart format`, so the committed diff stays
  stable. The CI job pins an exact Dart SDK for the same reason — a formatter
  change between SDK releases would otherwise look like stale output.

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
- Plural, lowercase resource paths: `/offers/{offerId}/redeem`.
- Money is always `{ amount_minor: int64, currency: "SGD" }` — never a float.
- Cursor pagination: `page_size` + `page_token` in, `next_page_token` out.
- Every error response uses the shared `Error` schema with a stable `code`.
- Every operation needs an `operationId`, a `summary`, and at least one 4xx response.
  CI fails without them.

## Versioning

The version lives in the path (`/offers/v1`) and in `info.version`.

- **Additive** changes (new endpoint, new optional field) ship in place.
- **Breaking** changes (removing/renaming a field, making a field required,
  narrowing a type, changing a status code) need a new major path version and a
  migration plan. CI flags them against the base branch.

## See also

- [CONTRIBUTING.md](CONTRIBUTING.md) — PR workflow and review expectations
- [docs/github-pages-setup.md](docs/github-pages-setup.md) — Pages and branch-protection setup
