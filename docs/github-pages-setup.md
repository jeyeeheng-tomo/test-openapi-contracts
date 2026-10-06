# One-time GitHub Pages setup

The `Publish Swagger UI` workflow deploys via the Pages API, so there is no
`gh-pages` branch to manage.

1. Push this repo to GitHub.
2. **Settings → Pages → Build and deployment → Source**: select **GitHub Actions**.
3. Push to `main` (or run the workflow manually from the Actions tab).
4. The docs land at `https://<org>.github.io/<repo>/`. Update the link in the README.

If the repo is private, Pages requires GitHub Enterprise Cloud, or you can make
the repo public and keep the specs non-sensitive.

## Recommended branch protection

**Settings → Branches → Add rule** for `main`:

- Require a pull request before merging, with at least 1 approval
- Require review from Code Owners
- Require status checks to pass: `validate`, `breaking-changes`
