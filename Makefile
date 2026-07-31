-include .env
export

# Verifies code quality — check-only, no fixes (same command as CI)
.PHONY: lint
lint:
	@poetry run ruff check --no-fix .
	@poetry run ruff format --check .
	@poetry run basedpyright
	@poetry run docformatter --check --recursive .

# Applies all auto-fixes (ruff + docformatter)
.PHONY: format
format:
	@poetry run ruff format .
	@poetry run ruff check --fix .
	@poetry run docformatter --in-place --recursive .

# Activates the project configuration and logs in to gcloud
.PHONY: login
login:
	@gcloud config configurations activate $(PROJECT_ID)
	@gcloud auth application-default login

# Builds the Docker image
.PHONY: build
build:
	@docker compose build cumplo-spotter --build-arg CUMPLO_PYPI_BASE64_KEY=`base64 -i cumplo-pypi-credentials.json`

# Starts the Docker container
.PHONY: start
start:
	@docker compose up -d cumplo-spotter

# Stops the Docker container
.PHONY: down
down:
	@docker compose down

# Updates the common library
.PHONY: update-common
update-common:
	@rm -rf .venv
	@poetry cache clear --no-interaction --all cumplo-pypi
	@poetry update
