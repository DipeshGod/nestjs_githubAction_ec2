# Use Node.js 20-alpine image as base
FROM node:20-alpine as build

WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install Node.js dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

# Build the application
RUN npm run build

# Use NGINX image for the production build
FROM nginx:latest

# Copy the built files from the Node.js image to NGINX image
COPY --from=build /app/dist /usr/share/nginx/html

# Remove default NGINX configuration
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom NGINX configuration
COPY nginx.conf /etc/nginx/conf.d

# Expose port 80 (default for HTTP)
EXPOSE 80

# Start NGINX server
CMD ["nginx", "-g", "daemon off;"]
