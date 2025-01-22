FROM alpine:3.21.2

# Install git
RUN apk update \
    && apk add --no-cache git\
    && rm -rf /var/cache/apk/*

# Copy script into the container
COPY generate_changelog_gh.sh /generate_changelog_gh.sh

# Make script executable
RUN chmod +x /generate_changelog_gh.sh

# Set the entrypoint to the shell and default command to your script
ENTRYPOINT ["/bin/sh", "-c"]
CMD ["/generate_changelog_gh.sh"]