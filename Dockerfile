# Use Alpine as the base image
FROM alpine:latest

# Install ssmtp
RUN apk add --no-cache ssmtp

# Copy the entrypoint script into the container
COPY entrypoint.sh /entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Set the entrypoint script as the entrypoint for the container
ENTRYPOINT ["/entrypoint.sh"]
