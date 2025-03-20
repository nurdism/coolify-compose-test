FROM node:20-alpine
ENV TINI_VERSION="0.19.0"
ENV USER="app"
ENV PNPM_HOME=/app/.pnpm
ENV PATH=$PATH:$PNPM_HOME
ADD https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini /tini
COPY --chown=$USER:$USER . /app
RUN apk update && \
  apk add --no-cache libc6-compat curl openssl pnpm && \
  pnpm install --frozen-lockfile --prod && \
  addgroup --system --gid 1001 $USER && \
  adduser --system --uid 1001 $USER && \ 
  chmod +x /tini && chown $USER:$USER /tini
USER $USER
WORKDIR /app
ENTRYPOINT ["/tini", "--"]
CMD ["node", "bin/serve.js"]

