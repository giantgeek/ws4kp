# Runtime-only image. Build on the host first (`make build` / `make docker-build`).
FROM nginx:1.31.7-alpine

LABEL maintainer="Scott Fredrickson <scott@giantgeek.com>"

COPY static-env-handler.sh /docker-entrypoint.d/01-static-env-handler.sh
RUN chmod +x /docker-entrypoint.d/01-static-env-handler.sh

COPY dist/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY ngx_pagespeed_csp_nonce.example.conf /usr/share/nginx/ngx_pagespeed_csp_nonce.example.conf
CMD ["nginx", "-g", "daemon off;"]

# Build time (UTC) for `docker ps`/`docker inspect`; set by the Makefile via BUILD_DATE.
# Kept last so a new timestamp does not invalidate any cached layers above.
ARG BUILD_DATE=unknown
LABEL org.opencontainers.image.created=$BUILD_DATE
