# Stage 1: Build
FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies 
COPY package.json package-lock.json ./
RUN npm ci

# Copy source code and build
COPY . .
RUN npm run build

# Stage 2: Production
FROM node:20-alpine

WORKDIR /app

# Copy build artifacts and node_modules from builder

COPY --from=builder /app ./

# Set environment variables
ENV NODE_ENV=production
ENV PORT=6095

# Expose the desired port
EXPOSE 6095

# Start the Next.js server
CMD ["npm", "run", "start"]
