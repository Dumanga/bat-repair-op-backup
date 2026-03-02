FROM node:20-bookworm-slim AS deps
RUN apt-get update -y && apt-get install -y openssl
WORKDIR /app
COPY package*.json ./
RUN npm ci

FROM node:20-bookworm-slim AS build
RUN apt-get update -y && apt-get install -y openssl
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npx prisma generate
RUN npm run build

FROM node:20-bookworm-slim AS run
RUN apt-get update -y && apt-get install -y openssl
WORKDIR /app
ENV NODE_ENV=production
COPY --from=build /app ./
EXPOSE 3000
CMD ["npm","run","start"]
