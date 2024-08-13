# container2back

This project provides a Dockerized solution for backing up specified folders by compressing them into a compressed folder, encrypting them using PGP, and retaining a specified number of recent backups. The solution allows for configurable backup prefixes and scheduling different backup tasks using Docker Compose.

## Features

- Compresses specified folders using `tar` and `xz`.
- Encrypts the compressed archive using PGP.
- Retains a specified number of the most recent backups.
- Schedules backup tasks using environment variables and cron jobs.
- Optionally sends the backed up archives to a remote host.

If back-ups are sent to a remote host, they will not be kept on the sender host. Therefore, the retainment policies will be applied on the destination host.

## Prerequisites

- Docker
- Docker Compose
- PGP key available for encryption

## Installation and usage

The recommended approach to install and use this tool is to create the service(s) with the docker-compose.yml file available at the repository root. A detailed explanation on how it is used is provided below:

Suppose we want to schedule the backup process for two folders:
- `folder1` on a daily basis at 0:30 (12:30 a.m.) sent to a remote computer reachable at `myuser@example.org` using SSH through the port 22. The latest 10 backups will be kept.
- `folder2` and folder3 twice a month (on the 1st and the 15th), executed at 1:00 (a.m.) kept on the local host. Only the latest 2 backups will be kept.

The chosen timezone for this proposed exampled will be `America/Chicago`.
Both backups will be encrypted using a key available at the user's .gnupg folder in the local machine, with ID `1234567890`.

The resulting docker-compose.yml will look like:

```
services:
  backup_one:
    image: ghcr.io/amarqz/container2back:latest
    container_name: backup_one
    environment:
      - TZ=America/Chicago
      - KEY_ID=1234567890
      - BACKUP_PREFIX=backup_one
      - MAX_BACKUPS=10
      - CRON_SCHEDULE= 30 0 * * *
      - DESTINATION=myuser@example.org
      - REMOTE_PORT=22
      - REMOTE_LOCATION=backups/folder1
    restart: unless-stopped
    volumes:
      - /home/me/folder1:/srv/to_back_up
      - /srv/bk:/srv/bk
      - /home/me/.gnupg:/root/.gnupg
      - /home/me/.ssh:/root/.ssh
  backup_two:
    image: ghcr.io/amarqz/container2back:latest
    container_name: backup_two
    environment:
      - TZ=America/Chicago
      - KEY_ID=1234567890
      - BACKUP_PREFIX=backup_two
      - MAX_BACKUPS=2
      - CRON_SCHEDULE= 0 1 1,15 * *
    restart: unless-stopped
    volumes:
      - /home/me/folder2:/srv/to_back_up/folder2
      - /home/me/folder3:/srv/to_back_up/folder3
      - /srv/bk:/srv/bk
      - /home/me/.gnupg:/root/.gnupg
```

If you run it, you will see that two containers were created.
