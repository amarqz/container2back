#!/bin/sh

# Set default schedule if not provided
CRON_SCHEDULE=${CRON_SCHEDULE:-"0 0 * * 1"}

# Create the cron job
echo "$CRON_SCHEDULE /usr/local/bin/back-up.sh" > /etc/crontabs/root

# Start cron daemon
crond -f