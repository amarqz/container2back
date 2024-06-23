FROM alpine:latest

# Install necessary tools
RUN apk update && \
    apk add --no-cache tar xz gnupg bash tzdata

# Add the backup script
ADD back-up.sh /usr/local/bin/back-up.sh
RUN chmod +x /usr/local/bin/back-up.sh

# Add entrypoint script
ADD entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Ensure correct .gnupg directory ownership
RUN chown -R root:root /root/.gnupg && \
    chmod 700 /root/.gnupg && \
    chmod 600 /root/.gnupg/*

# Define default command
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]