#!/bin/bash
# Generic entrypoint script for Java Spring Boot applications
# Usage: entrypoint.sh <jar-path> [additional-java-args...]
# Example: entrypoint.sh /home/spring/app.jar
# Example: entrypoint.sh bin/app.jar

set -e

JAR_PATH="${1:-/home/spring/app.jar}"
shift || true

exec java -Xlog:async -XX:AsyncLogBufferSize=100M -jar "${JAR_PATH}" "$@"

