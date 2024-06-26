FROM alpine:latest

# Install necessary tools
RUN apk update && \
    apk add --no-cache tar xz gnupg bash tzdata openssh rsync

# Add the backup script
ADD back-up.sh /usr/local/bin/back-up.sh
RUN chmod +x /usr/local/bin/back-up.sh

# Add entrypoint script
ADD entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Define default command
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]