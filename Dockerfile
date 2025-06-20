FROM node:22-slim AS base
#FROM python:3.10.5-slim-buster AS python

#From python as python-deps
#Run pip3 install setuptools

# Install Python 3, pip, and setuptools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-setuptools \
    build-essential \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set default python and pip to Python 3
#RUN ln -s /usr/bin/python3 /usr/bin/python && \
#    ln -s /usr/bin/pip3 /usr/bin/pip

# Install dependencies only when needed
FROM base AS deps
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
#RUN apk add --no-cache libc6-compat
WORKDIR /app

# Install dependencies based on the preferred package manager
COPY package.json ./

RUN npm cache clean --force

RUN npm install --verbose 
#&& npm cache clean --force

# Rebuild the source code only when needed
#FROM base AS BUILDER
#WORKDIR /app
#COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Next.js collects completely anonymous telemetry data about general usage.
# Learn more here: https://nextjs.org/telemetry
# Uncomment the following line in case you want to disable telemetry during the build.
# ENV NEXT_TELEMETRY_DISABLED 1

RUN npm run build

# Production image, copy all the files and run next
# FROM base AS RUNNER
# WORKDIR /app

ENV NODE_ENV production
# Uncomment<F20>OA the following line in case you want to disable telemetry during runtime.
# ENV NEXT_TELEMETRY_DISABLED 1

# RUN addgroup --system --gid 1001 nodejs
# RUN adduser --system --uid 1001 jsUser

# COPY --from=BUILDER --chown=jsUser:nodeJs /app/public ./public

# Set the correct permission for prerender cache
#RUN mkdir .next
#RUN chown nextjs:nodejs .next

# Automatically leverage output traces to reduce image size
# https://nextjs.org/docs/advanced-features/output-file-tracing
#COPY --from=BUILDER --chown=nextjs:nodejs /app/.next/standalone ./
#COPY --from=BUILDER --chown=nextjs:nodejs /app/.next/static ./.next/static

#USER nextjs

EXPOSE 5556

ENV PORT 5556
# set hostname to localhost
ENV HOSTNAME "0.0.0.0"

CMD ["npm", "run", "prod"]
