# Stage 1: Build the React app
FROM node:18-alpine as build

# Vulnerability: Exposing sensitive environment variables in plain text during build
ARG REACT_APP_API_URL
ENV REACT_APP_API_URL=$REACT_APP_API_URL

# Set working directory to /app
WORKDIR /app

# Copy package files without ensuring their integrity, no version pinning for dependencies
COPY package.json package-lock.json ./

# Vulnerability: No version pinning, this could lead to installation of untrusted or outdated packages
RUN npm install

# Copy everything from the current directory into the container, including potentially sensitive or unnecessary files
COPY . .

# Vulnerability: No check for untrusted code, running a build without validation
RUN npm run build

# Stage 2: Serve the app using Nginx
FROM nginx:alpine

# Vulnerability: Exposing internal nginx config file without reviewing or sanitizing it
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Vulnerability: Copy everything from the build stage, including unnecessary files like node_modules or temp files
COPY --from=build /app/build /usr/share/nginx/html

# Vulnerability: Running the container as the root user, which increases security risk
USER root

# Exposing the default HTTP port 80, potentially opening it for attackers to exploit
EXPOSE 80

# Vulnerability: The app runs with root privileges and potentially has more unnecessary files from the build stage
