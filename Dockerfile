
# Stage 1: Build the Angular application
FROM node:20-slim AS build

WORKDIR /app

# Update npm to a version containing the edgesOut fix
RUN npm install -g npm@11.6.0

# Copy package.json
COPY package.json ./

# Install dependencies
RUN npm install

# Copy application files
COPY . .

# Build Angular
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:1.25-alpine

COPY --from=build /app/dist/gemini-angular-app/browser /usr/share/nginx/html

COPY nginx.conf /etc/nginx/nginx.conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
