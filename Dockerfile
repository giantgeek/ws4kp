FROM node:24-alpine AS node-builder
WORKDIR /app

# Install deps only when manifests change (better layer cache).
COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN npm run build
RUN rm -f dist/playlist.json

FROM nginx:1.31.3-alpine

LABEL maintainer="Scott Fredrickson <scott@giantgeek.com>"

COPY static-env-handler.sh /docker-entrypoint.d/01-static-env-handler.sh
RUN chmod +x /docker-entrypoint.d/01-static-env-handler.sh

COPY --from=node-builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY ngx_pagespeed_csp_nonce.example.conf /usr/share/nginx/ngx_pagespeed_csp_nonce.example.conf
CMD ["nginx", "-g", "daemon off;"]
