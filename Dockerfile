# Build Stage
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package.json yarn.lock ./

# Install all dependencies (including devDependencies)
RUN yarn install --frozen-lockfile

# Copy source code
COPY . .

# Build the application
RUN yarn build

# Production Stage
FROM node:18-alpine


WORKDIR /app

# Set ownership to node user
RUN chown -R node:node /app

# Switch to non-root user
USER node

# Copy package files
COPY --chown=node:node package.json yarn.lock ./

# Install only production dependencies
RUN yarn install --production --frozen-lockfile

# Copy built assets from builder stage
COPY --chown=node:node --from=builder /app/dist ./dist

# Expose the application port
EXPOSE 3000

# Start the application
CMD ["node", "dist/index.js"]
