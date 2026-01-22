#  Build the application
FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Copy source code and build
COPY . .

RUN npm run build

#  Production Server
FROM node:20-alpine

WORKDIR /app


COPY --from=builder /app ./

# Set Environment Variables
ENV NODE_ENV=production
ENV PORT=8085

# Expose the port to Docker
EXPOSE 8085


CMD ["npx", "next", "start", "-p", "8085"]
