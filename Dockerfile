# Production multi-stage build for a Create React App (react-scripts)
# Stage 1: build
FROM node:18-alpine AS builder
WORKDIR /app
ENV PATH=/app/node_modules/.bin:$PATH
ENV NODE_OPTIONS=--openssl-legacy-provider

# Install dependencies (includes devDependencies so cross-env is available if needed during build)
COPY package*.json ./
RUN npm ci

# Copy source and build
COPY . .
RUN npm run build
RUN npm start

# Stage 2: serve build with nginx
FROM nginx:stable-alpine
# Optional: add custom nginx.conf if you need SPA routing (try_files)
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]