FROM node:20-alpine AS base

ENV TINI_VERSION="0.19.0"
ENV USER="node"
ENV PNPM_HOME=/app/.pnpm
ENV PATH=$PATH:$PNPM_HOME
ADD https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini /tini
RUN apk update && \
  apk add --no-cache libc6-compat curl openssl pnpm && \
  pnpm install --frozen-lockfile --prod \
  addgroup --system --gid 1001 $USER \
  adduser --system --uid 1001 $USER \ 
  chmod +x /tini && chown $USER:$USER /tini
USER $USER
COPY --chown=$USER:$USER /app /app
WORKDIR /app
ENTRYPOINT ["/tini", "--"]
CMD ["node", "bin/serve.js"]

