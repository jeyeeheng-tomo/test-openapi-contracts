# GitHub Pages setup

**Already done for this repo** — the site is live at
<https://jeyeeheng-tomo.github.io/test-openapi-contracts/>. This page is kept for
anyone standing the setup up again from scratch.

The `Publish Swagger UI` workflow deploys via the Pages API, so there is no
`gh-pages` branch to manage.

1. Push the repo to GitHub.
2. **Settings → Pages → Build and deployment → Source**: select **GitHub Actions**.
   (Equivalent API call: `gh api -X POST repos/<org>/<repo>/pages -f build_type=workflow`.)
3. Push to `main`, or run the workflow manually from the Actions tab.
4. The docs land at `https://<org>.github.io/<repo>/`. Update the link in the README.

**Pages does not work on a private repo on the Free or Pro plan** — enabling it
returns `Your current plan does not support GitHub Pages for this repository`. Either
make the repo public, as this one is, or move it to an Enterprise Cloud org. Going
public exposes the full commit history, so check it for secrets first.

## Recommended branch protection

**Settings → Branches → Add rule** for `main`:

- Require a pull request before merging, with at least 1 approval
- Require review from Code Owners
- Require status checks to pass: `validate`, `breaking-changes`
