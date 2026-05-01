# Use Nginx as the base image for serving static content
FROM nginx:latest

# Set the working directory
WORKDIR /usr/share/nginx/html

# Remove default Nginx content
RUN rm -rf *

# Copy the entire project into the Nginx root directory
COPY . .

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
