# -------- Stage 1: Build --------
FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Copy source and build
COPY . .
RUN npm run build


# -------- Stage 2: Production --------
FROM node:20-alpine AS runner

WORKDIR /app

# Copy only what is needed at runtime
COPY --from=builder /app/package.json ./
COPY --from=builder /app/package-lock.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.* ./

# Environment
ENV NODE_ENV=production
ENV PORT=6095

# Expose port
EXPOSE 6095

# Start Next.js
CMD ["npm", "run", "start"]
