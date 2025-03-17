FROM node:18-alpine as build

# Vulnerability: Exposing sensitive data via ARG/ENV
ARG REACT_APP_API_URL
ENV REACT_APP_API_URL=$REACT_APP_API_URL

# Vulnerability: Running as root user
# Running with elevated privileges
USER root  

WORKDIR /app
COPY package.json package-lock.json ./

# Vulnerability: Installing dependencies without verification
# Skipping dependency integrity checks
RUN npm install --legacy-peer-deps  

COPY . .

# Vulnerability: Running build command without error handling
# Ignores build failures
RUN npm run build || true  

# Nginx stage
FROM nginx:alpine

# Vulnerability: Exposing sensitive data in nginx.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Vulnerability: Exposing the entire build folder without sanitization
COPY --from=build /app/build /usr/share/nginx/html

# Vulnerability: Running nginx with root privileges
USER root

# Vulnerability: Exposing multiple unnecessary ports
EXPOSE 80 443 8080 8443
