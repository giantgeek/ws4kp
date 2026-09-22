# AGENTS.md — ws4kp

## What this is
WeatherStar 4000+ — nostalgic Weather Channel-style forecast using NOAA API (US locations only).

## Tech stack
Node.js, Gulp/Webpack, SASS, Luxon; static nginx (runtime-only image) or Node proxy; Traefik.


## Key files
- `docker-compose.yml`, `Dockerfile`, `Dockerfile.dev`, `Dockerfile.server`
- `package.json`, `src/`, `Makefile`

## Services
- `ws4kp` — static nginx; `ws4kp-dev` — dev profile with Node server

## Commands
- Host assets: `make build` → `npm run build` (writes `dist/`)
- Static Docker: `make docker-run` → host build + nginx image → `http://ws4kp.localhost`
- Rebuild without cache: `make docker-rebuild`
- Dev+Traefik: `make start-traefik` → `http://ws4kp-dev.localhost` (uses `Dockerfile.dev`; first boot may run `npm ci`)
- Local: `make install && make start`


## Environment
- `WS4KP_PORT`, `NO_PROXY`; permalink args as `WSQS_*` env vars

## Rules for agents
- When changing Dockerfile / Makefile / docker-compose.yml / .dockerignore, update all related files together
- 502 during `npm ci` on first dev boot is normal — wait for install to finish
- Traefik needs `NO_PROXY` for Docker backends
- NOAA API is US-only — do not assume international location support
- Run `npm install` before suggesting local dev commands

## Docker conventions (local Desktop)

Docker Desktop’s VM has limited RAM (~3.8 GiB). Heavy toolchains inside the image can OOM the engine.

- **Host-build, runtime-only image**: `make docker-build` / `make docker-run` must run the project build on the **host**, then `COPY` artifacts into a slim runtime Dockerfile (PHP/Apache, nginx, or JRE only).
- **Do not** add `FROM gradle` / `FROM maven` / Node build stages, or `npm ci` / `gradle` / `mvn package` in the production `Dockerfile`, for routine local builds.
- **Makefile**: keep `docker-build` dependent on the host build target; default `docker compose build` **without** `--no-cache`; expose `docker-rebuild` for `--no-cache`.
- **`.dockerignore`**: allow-list only what the runtime image needs (e.g. `src/main/webapp/`, host `build/…` or `target/…` or `dist/`, plus Apache/nginx config files). When you change `COPY` paths in the Dockerfile, update `.dockerignore` in the same change.
- **`docker-compose.yml`**: keep a modest `mem_limit`; route via Traefik labels; avoid binding host `:8080` when Traefik already owns it.
- Keep `Dockerfile`, `Makefile`, `docker-compose.yml`, and `.dockerignore` consistent whenever the image layout or build output path changes.

## Docs
- `README.md`, `tests/README.md`, `Makefile`
