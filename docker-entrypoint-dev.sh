#!/bin/sh
set -e
if [ ! -d node_modules/dotenv ]; then
	echo "ws4kp-dev: installing npm dependencies..."
	npm ci
fi
exec "$@"
