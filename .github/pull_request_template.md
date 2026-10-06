## What changes in the contract?

<!-- One or two lines. Which service, which operations. -->

## Type of change

- [ ] Additive (new endpoint, new optional field) — backwards compatible
- [ ] Breaking (removed/renamed field, new required field, narrowed type, changed status code)
- [ ] Docs / description only

## Checklist

- [ ] `npm run check` passes locally
- [ ] Regenerated `generated/` (Kotlin **and** Dart) is committed alongside the spec change
- [ ] Every new operation has an `operationId`, a `summary`, and at least one 4xx response
- [ ] Examples are realistic (no `string` / `foo`)
- [ ] Breaking changes: version bumped and consumers notified

## Who is affected?

<!-- Which frontend/backend teams consume this? Link the ticket. -->
