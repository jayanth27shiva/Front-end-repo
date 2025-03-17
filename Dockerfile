# FROM node:18-alpine 

# # Create root user if not exists and set it as the user
# RUN adduser -D root && \
#     echo "root:root" | chpasswd

# # Vulnerability: Exposing sensitive data via ARG/ENV
# ARG REACT_APP_API_URL
# ENV REACT_APP_API_URL=$REACT_APP_API_URL

# # Vulnerability: Running as root user
# # Running with elevated privileges
# USER root  

# WORKDIR /app
# COPY package.json package-lock.json ./

# # Vulnerability: Installing dependencies without verification
# # Skipping dependency integrity checks
# RUN npm install --legacy-peer-deps  

# COPY . .

# CMD ["npm", "start"]

# # Vulnerability: Running build command without error handling
# # Ignores build failures
# RUN npm run build || true  

# # Nginx stage
# FROM nginx:alpine

# # Vulnerability: Exposing sensitive data in nginx.conf
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# # Vulnerability: Exposing the entire build folder without sanitization
# COPY --from=build /app/build /usr/share/nginx/html

# # Vulnerability: Running nginx with root privileges
# USER root

# # Vulnerability: Exposing multiple unnecessary ports
# EXPOSE 80 443 8080 8443


# Use a Node.js image
FROM node:18-alpine

# Install necessary packages (if you need to add any user management tools)
RUN apk add --no-cache shadow

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install --legacy-peer-deps

# Copy the rest of the application files
COPY . .

# Expose the port the app will run on
EXPOSE 3000

# Run the application
CMD ["npm", "start"]


