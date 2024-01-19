FROM alpine:3.19.0

# Install git
RUN apk update \
    && apk add --no-cache git\
    && rm -rf /var/cache/apk/*

# Copy script into the container
COPY generate_changelog.sh /script.sh

# Make script executable
RUN chmod +x /script.sh

# Set the entrypoint to your script
ENTRYPOINT ["/script.sh"]
