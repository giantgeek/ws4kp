# Runtime-only image. Build on the host first (`make build` / `make docker-build`).
FROM nginx:1.31.10-alpine

LABEL maintainer="Scott Fredrickson <scott@giantgeek.com>"

COPY static-env-handler.sh /docker-entrypoint.d/01-static-env-handler.sh
RUN chmod +x /docker-entrypoint.d/01-static-env-handler.sh

COPY dist/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf
CMD ["nginx", "-g", "daemon off;"]

# nginx serving the static build on 8080 (nginx.conf)
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget -S -O /dev/null -T 4 http://127.0.0.1:8080/ 2>&1 | grep -m1 -E '^ *HTTP/' | grep -qE '^ *HTTP/1[.][01] 200 ' || exit 1

# Build time (UTC) for `docker ps`/`docker inspect`; set by the Makefile via BUILD_DATE.
# Kept last so a new timestamp does not invalidate any cached layers above.
ARG BUILD_DATE=unknown
LABEL org.opencontainers.image.created=$BUILD_DATE
