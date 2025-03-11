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
ARG NODE_ENV
ENV NODE_ENV=${NODE_ENV}
ARG PORT
ENV PORT=${PORT}
ARG HOSTNAME
ENV HOSTNAME=${HOSTNAME}
ARG CRYPTO_KEY
ENV CRYPTO_KEY=${CRYPTO_KEY}
ARG GITHUB_APP_ID
ENV GITHUB_APP_ID=${GITHUB_APP_ID}
ARG GITHUB_APP_CLIENT_ID
ENV GITHUB_APP_CLIENT_ID=${GITHUB_APP_CLIENT_ID}
ARG GITHUB_APP_CLIENT_SECRET
ENV GITHUB_APP_CLIENT_SECRET=${GITHUB_APP_CLIENT_SECRET}
ARG GITHUB_APP_PRIVATE_KEY
ENV GITHUB_APP_PRIVATE_KEY=${GITHUB_APP_PRIVATE_KEY}
ARG GITHUB_APP_WEBHOOK_SECRET
ENV GITHUB_APP_WEBHOOK_SECRET=${GITHUB_APP_WEBHOOK_SECRET}
ARG SQLITE_AUTH_TOKEN
ENV SQLITE_AUTH_TOKEN=${SQLITE_AUTH_TOKEN}
ARG RESEND_API_KEY
ENV RESEND_API_KEY=${RESEND_API_KEY}

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