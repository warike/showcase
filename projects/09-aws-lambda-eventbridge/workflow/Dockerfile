# ---- Build Stage ----
FROM node:22-alpine AS builder

WORKDIR /usr/src/app
RUN corepack enable

COPY package.json pnpm-lock.yaml* ./

RUN pnpm install --frozen-lockfile

COPY . .

RUN pnpm run build

# ---- Runtime Stage ----
FROM public.ecr.aws/lambda/nodejs:22

WORKDIR ${LAMBDA_TASK_ROOT}

COPY --from=builder /usr/src/app/dist ./
COPY --from=builder /usr/src/app/node_modules ./node_modules

CMD [ "index.handler" ]