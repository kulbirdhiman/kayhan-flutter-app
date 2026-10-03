# syntax=docker/dockerfile:1.7
#
# Kayhan Audio — Flutter web build served by unprivileged nginx.
#
#   docker build -t kayhan-app .
#   docker run --rm -p 8080:8080 kayhan-app
#
# The web app calls same-origin /api and /cdn; nginx proxies them to the
# upstreams below (the backend's CORS policy only allows its own domain).
# Point at another backend at runtime, no rebuild needed:
#   docker run -p 8080:8080 -e API_UPSTREAM=https://staging-api.example.com kayhan-app

ARG FLUTTER_IMAGE=ghcr.io/cirruslabs/flutter:stable

# ---------------------------------------------------------------------------
# 1. Build the web bundle
# ---------------------------------------------------------------------------
FROM ${FLUTTER_IMAGE} AS build

WORKDIR /app

# Resolve dependencies first so this layer is cached until pubspec changes.
COPY pubspec.yaml pubspec.lock ./
RUN --mount=type=cache,target=/root/.pub-cache \
    flutter pub get

COPY . .

ARG API_BASE_URL=/api
ARG CDN_BASE_URL=/cdn

RUN --mount=type=cache,target=/root/.pub-cache \
    flutter build web --release \
      --dart-define=API_BASE_URL=${API_BASE_URL} \
      --dart-define=CDN_BASE_URL=${CDN_BASE_URL}

# ---------------------------------------------------------------------------
# 2. Serve static files (runs as non-root on port 8080)
# ---------------------------------------------------------------------------
FROM nginxinc/nginx-unprivileged:1.27-alpine AS runtime

ENV API_UPSTREAM=https://api.kayhanaudio.com.au \
    CDN_UPSTREAM=https://d198m4c88a0fux.cloudfront.net

COPY docker/default.conf.template /etc/nginx/templates/default.conf.template
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://127.0.0.1:8080/healthz || exit 1
