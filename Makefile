.PHONY: help install clean build lint lint-fix format start start-prod start-traefik stop-traefik-dev stop test docker-build docker-run compose-up compose-up-build compose-down compose-logs compose-restart compose-status update

# Re-run npm ci only when package manifests change (avoids missing node_modules / stale deps).
NPM_STAMP := node_modules/.make-deps-stamp

help: ## Show available targets and descriptions
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

$(NPM_STAMP): package.json package-lock.json
	npm ci
	@touch $(NPM_STAMP)

install: $(NPM_STAMP) ## Install Node deps (npm ci when package.json or lockfile change)

clean: ## Remove build artifacts and node_modules directory
	rm -rf dist node_modules

build: $(NPM_STAMP) ## Build the production assets using gulp
	npm run build

lint: $(NPM_STAMP) ## Run the primary ESLint rule set
	npm run lint

lint-fix: $(NPM_STAMP) ## Run ESLint with automatic fixes
	npm run lint:fix

format: lint-fix ## Alias to lint:fix for compatibility

start: $(NPM_STAMP) ## Dev server on host :8080 (Traefik in Docker cannot reach this; use start-traefik)
	npm start

# Dev server inside traefik-network so Traefik can route to it (http://ws4kp-dev.localhost — use HTTP :80, not HTTPS).
start-traefik: ## Run dev stack for Traefik; waits until the app is healthy (first boot can take minutes during npm ci)
	COMPOSE_PROFILES=dev docker compose up -d --build --wait --wait-timeout 300 ws4kp-dev

stop-traefik-dev: ## Stop the Traefik dev container (ws4kp-dev)
	docker compose --profile dev stop ws4kp-dev

start-prod: build ## Serve pre-built dist/ (same as DIST=1 npm start)
	DIST=1 npm start

stop: ## Stop the local application process
	npm run stop

test: $(NPM_STAMP) ## Run lint-all as a stand-in test suite
	npm run lintall

docker-build: ## Build the Docker image using docker compose
	docker compose build --no-cache

docker-run: docker-build ## Build and run the Docker containers
	docker compose up -d

compose-up: ## Start the services without rebuilding
	docker compose up -d

compose-up-build: ## Start services; rebuild image when Dockerfile or app files changed
	docker compose up -d --build

compose-down: ## Stop and remove the services
	docker compose down

compose-logs: ## Tail the docker compose logs
	docker compose logs -f

compose-restart: ## Restart the docker compose services
	docker compose restart

compose-status: ## Show the status of docker compose services
	docker compose ps

update: ## Pull latest changes from main and rebuild
	git checkout main
	git pull origin main
	$(MAKE) build
