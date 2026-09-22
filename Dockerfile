# Runtime-only image. Build on the host first (`make build` / `make docker-build`).
FROM nginx:1.31.5-alpine

LABEL maintainer="Scott Fredrickson <scott@giantgeek.com>"

COPY static-env-handler.sh /docker-entrypoint.d/01-static-env-handler.sh
RUN chmod +x /docker-entrypoint.d/01-static-env-handler.sh

COPY dist/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY ngx_pagespeed_csp_nonce.example.conf /usr/share/nginx/ngx_pagespeed_csp_nonce.example.conf
CMD ["nginx", "-g", "daemon off;"]
