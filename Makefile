.PHONY: help install clean build lint lint-fix format start stop test docker-build docker-run compose-up compose-down compose-logs compose-restart compose-status update

help: ## Show available targets and descriptions
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

install: ## Install Node.js dependencies using npm ci
	npm ci

clean: ## Remove build artifacts and node_modules directory
	rm -rf dist node_modules

build: install ## Build the production assets using gulp
	npm run build

lint: install ## Run the primary ESLint rule set
	npm run lint

lint-fix: install ## Run ESLint with automatic fixes
	npm run lint:fix

format: lint-fix ## Alias to lint:fix for compatibility

start: install ## Start the application locally using npm start
	npm start

stop: ## Stop the local application process
	npm run stop

test: install ## Run lint-all as a stand-in test suite
	npm run lintall

docker-build: ## Build the Docker image using docker compose
	docker compose build --no-cache

docker-run: docker-build ## Build and run the Docker containers
	docker compose up -d

compose-up: ## Start the services without rebuilding
	docker compose up -d

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
