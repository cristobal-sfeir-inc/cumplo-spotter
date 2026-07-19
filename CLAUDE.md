# cumplo-spotter

## Overview
FastAPI service that spots secure and high-return Cumplo investment opportunities. Queries
Cumplo's Global and GraphQL APIs, filters funding requests against per-user configurations,
and publishes matching requests via Pub/Sub.

## Build & Run
- Install deps: `poetry install`
- Start locally: `make start` (Docker Compose)
- Stop: `make down`
- Build image: `make build`

Python 3.13, Poetry 2.4.x. Requires environment variables — copy `.env.example` to `.env`.

## Code Quality
- Auto-fix lint + format: `make format`
- Verify code quality (CI gate): `make lint`

`.github/workflows/lint.yml` runs `make lint` on every PR (ruff check + ruff format --check +
basedpyright + docformatter --check). Fails on any violation.

## Git Workflow
- Branch prefixes: `feat/`, `fix/`, `chore/`, `ci/`. Conventional-commit subjects.
- `master` is protected: every change needs a **PR + code-owner review** (`@cnsfeir-reviewer`).
  **Never push to `master` directly** — it is rejected. Open a PR.

## Gotchas
- `cumplo-common` is the shared domain library consumed by this service. Update it with
  `make update-common` (clears the Poetry cache and re-resolves). Any breaking change in
  `cumplo-common` needs a consumer bump here.
- The `retry` package has no type stubs — `reportMissingModuleSource = false` is set in
  `[tool.pyright]` to suppress the false-positive noise.
- `cumplo_spotter/models/cumplo/borrower.py` previously carried a `# mypy:` suppression
  comment that was removed when mypy was replaced with basedpyright.
- Funding request data from Cumplo's API uses Spanish field names (aliases on Pydantic models).
  The `CumploFundingRequest` model validates and translates to the common domain model via `.export()`.

## Before Committing
- [ ] Run `make format`, then `make lint` and ensure it passes.
- [ ] No hardcoded secrets or credential files committed.
