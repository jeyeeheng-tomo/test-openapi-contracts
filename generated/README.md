# Generated code — do not edit

Everything under this directory is produced by `npm run generate` from the
specs in `specs/`. Hand edits are overwritten, and CI fails if what is
committed here does not match what the specs produce.

| Directory | Generator | Consumers |
| --- | --- | --- |
| `kotlin/` | [Fabrikt](https://github.com/cjbooms/fabrikt) | Backend — Jackson data classes, `jakarta.validation` |
| `dart/` | [OpenAPI Generator](https://openapi-generator.tech/) (`dart-dio`) + `build_runner` | Frontend — Dio client + `json_serializable` models, one per service |

The Dart side is a two-stage pipeline: openapi-generator emits classes annotated
with `@JsonSerializable` and a `part '*.g.dart'` directive, then `build_runner`
fills in those `.g.dart` serializers. Both stages run inside `npm run generate:dart`,
and **both outputs are committed** — consumers pull this package as a git dependency
and will not run `build_runner` on it themselves.

To change the output, change the contract in `specs/`, or the generator
settings in `codegen.json`, and regenerate.
