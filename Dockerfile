# syntax=docker.io/docker/dockerfile:1

FROM node:18-bullseye AS base

# Install dependencies only when needed
FROM base AS deps
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
# RUN apk add --no-cache libc6-compat
WORKDIR /app

# Install dependencies based on the preferred package manager
COPY package.json yarn.lock ./
RUN yarn;

# Rebuild the source code only when needed
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Next.js collects completely anonymous telemetry data about general usage.
# Learn more here: https://nextjs.org/telemetry
# Uncomment the following line in case you want to disable telemetry during the build.
# ENV NEXT_TELEMETRY_DISABLED=1

RUN yarn build;

# Production image, copy all the files and run next
FROM base AS runner
WORKDIR /app

ENV NODE_ENV=production
# Uncomment the following line in case you want to disable telemetry during runtime.
# ENV NEXT_TELEMETRY_DISABLED=1

# Use build secrets
RUN --mount=type=secret,id=NODE_ENV echo "NODE_ENV=$(cat /tmp/secrets/NODE_ENV)" >> /app/.env
RUN --mount=type=secret,id=PORT echo "PORT=$(cat /tmp/secrets/PORT)" >> /app/.env
RUN --mount=type=secret,id=HOSTNAME echo "HOSTNAME=$(cat /tmp/secrets/HOSTNAME)" >> /app/.env
RUN --mount=type=secret,id=CRYPTO_KEY echo "CRYPTO_KEY=$(cat /tmp/secrets/CRYPTO_KEY)" >> /app/.env
RUN --mount=type=secret,id=GITHUB_APP_ID echo "GITHUB_APP_ID=$(cat /tmp/secrets/GITHUB_APP_ID)" >> /app/.env
RUN --mount=type=secret,id=GITHUB_APP_CLIENT_ID echo "GITHUB_APP_CLIENT_ID=$(cat /tmp/secrets/GITHUB_APP_CLIENT_ID)" >> /app/.env
RUN --mount=type=secret,id=GITHUB_APP_CLIENT_SECRET echo "GITHUB_APP_CLIENT_SECRET=$(cat /tmp/secrets/GITHUB_APP_CLIENT_SECRET)" >> /app/.env
RUN --mount=type=secret,id=GITHUB_APP_PRIVATE_KEY echo "GITHUB_APP_PRIVATE_KEY=$(cat /tmp/secrets/GITHUB_APP_PRIVATE_KEY)" >> /app/.env
RUN --mount=type=secret,id=GITHUB_APP_WEBHOOK_SECRET echo "GITHUB_APP_WEBHOOK_SECRET=$(cat /tmp/secrets/GITHUB_APP_WEBHOOK_SECRET)" >> /app/.env
RUN --mount=type=secret,id=SQLITE_AUTH_TOKEN echo "SQLITE_AUTH_TOKEN=$(cat /tmp/secrets/SQLITE_AUTH_TOKEN)" >> /app/.env
RUN --mount=type=secret,id=SQLITE_URL echo "SQLITE_URL=$(cat /tmp/secrets/SQLITE_URL)" >> /app/.env
RUN --mount=type=secret,id=RESEND_API_KEY echo "RESEND_API_KEY=$(cat /tmp/secrets/RESEND_API_KEY)" >> /app/.env

RUN echo "DEBUG: Inside Dockerfile - SQLITE_URL=${SQLITE_URL}"

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public

# Automatically leverage output traces to reduce image size
# https://nextjs.org/docs/advanced-features/output-file-tracing
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT=3000

# server.js is created by next build from the standalone output
# https://nextjs.org/docs/pages/api-reference/config/next-config-js/output
ENV HOSTNAME="0.0.0.0"
CMD ["node", "server.js"]