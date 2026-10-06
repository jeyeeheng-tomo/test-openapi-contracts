# Contributing

## The workflow

1. Branch off `main`: `git checkout -b contract/orders-add-refunds`
2. Edit the spec(s) under `specs/`.
3. `npm run check` — this lints, bundles, **and regenerates the Kotlin models**.
   Commit the `generated/` changes along with the spec change; CI fails if they
   drift apart.
4. Open a PR using the template. Say who consumes the change.
5. CODEOWNERS pulls in the owning team and the API reviewers. Needs one approval
   from each.
6. On merge, the Swagger UI on GitHub Pages rebuilds automatically.

Frontend and backend engineers are equal contributors here. A frontend engineer
proposing the shape they need is a normal, expected PR — it just needs the owning
backend team's approval before merge.

## What reviewers look for

- **Is it consistent?** Naming, pagination, error shape, money representation
  match the conventions in the README.
- **Is it backwards compatible?** If not, is the version bump and migration
  plan spelled out?
- **Are the examples real?** `"ada@example.com"`, not `"string"`.
- **Are the errors documented?** Which 4xx can a client actually receive, and
  with which `code`?
- **Is it reusing `specs/shared/components.yaml`?** A redefined `Error` schema
  is a review comment.

## Schema rules the generator imposes

Fabrikt is stricter than the OpenAPI spec. The one that bites:

> `'User' schema contains an invalid combination of properties and
> `oneOf | anyOf | allOf`. Do not use properties and a combiner at the same level.`

Valid OpenAPI, rejected by Fabrikt. Put everything inside the `allOf`:

```yaml
# Won't generate
User:
  type: object
  properties: { id: { type: string } }
  allOf:
    - $ref: '../shared/components.yaml#/components/schemas/Timestamps'

# Will generate
User:
  allOf:
    - $ref: '../shared/components.yaml#/components/schemas/Timestamps'
    - type: object
      properties: { id: { type: string } }
```

`npm run generate:kotlin` prints this hint when it hits the case. Redocly lint
will *not* catch it — only the codegen step does.

## Breaking changes

CI runs `oasdiff breaking` against the base branch and fails the PR if it finds
one. That failure is a prompt to talk, not a wall: if the change is agreed, bump
the path version (`/v1` → `/v2`) or, for a genuinely coordinated break, get
explicit sign-off from every consumer in the PR thread and note it in the
description.

## Don't

- Don't commit anything under `dist/` — it is generated.
- Don't edit a spec to match an implementation that already shipped and diverged.
  Fix the implementation, or PR the contract change on its own and explain why.
