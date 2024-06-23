#!/bin/sh

# Set the timezone
if [ -n "$TZ" ]; then
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
  echo $TZ > /etc/timezone
  echo "Timezone set to $TZ"
fi

# Ensure /root/.gnupg folder has the right ownership
chown -R root:root /root/.gnupg
chmod 700 /root/.gnupg
chmod 600 /root/.gnupg/*

# Set default schedule if not provided
CRON_SCHEDULE=${CRON_SCHEDULE:-"0 0 * * 1"}

# Create the cron job
echo "$CRON_SCHEDULE /usr/local/bin/back-up.sh" > /etc/crontabs/root

# Start cron daemon
crond -f