# Generated code — do not edit

Everything under this directory is produced by `npm run generate` from the
specs in `specs/`. Hand edits are overwritten, and CI fails if what is
committed here does not match what the specs produce.

| Directory | Generator | Consumers |
| --- | --- | --- |
| `kotlin/` | [Fabrikt](https://github.com/cjbooms/fabrikt) | Backend — Jackson data classes, `jakarta.validation` |
| `dart/` | [Kiota](https://github.com/microsoft/kiota) | Frontend — full API client, one per service |

To change the output, change the contract in `specs/`, or the generator
settings in `codegen.json`, and regenerate.
