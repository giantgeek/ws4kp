# AGENTS.md — ws4kp

## What this is
WeatherStar 4000+ — nostalgic Weather Channel-style forecast using NOAA API (US locations only).

## Tech stack
Node.js, Gulp/Webpack, SASS, Luxon; static (nginx) or server (Node proxy) modes.

## Key files
- `docker-compose.yml`, `Dockerfile`, `Dockerfile.dev`, `Dockerfile.server`
- `package.json`, `src/`, `Makefile`

## Services
- `ws4kp` — static nginx; `ws4kp-dev` — dev profile with Node server

## Commands
- Static: `docker compose up -d` → `http://ws4kp.localhost`
- Dev+Traefik: `make start-traefik` → `http://ws4kp-dev.localhost`
- Local: `npm install && npm start`

## Environment
- `WS4KP_PORT`, `NO_PROXY`; permalink args as `WSQS_*` env vars

## Rules for agents
- 502 during `npm ci` on first dev boot is normal — wait for install to finish
- Traefik needs `NO_PROXY` for Docker backends
- NOAA API is US-only — do not assume international location support
- Run `npm install` before suggesting local dev commands

## Docs
- `README.md`, `tests/README.md`, `Makefile`
