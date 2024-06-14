# container2back

This project provides a Dockerized solution for backing up specified folders by compressing them into a compressed folder, encrypting them using PGP, and retaining a specified number of recent backups. The solution allows for configurable backup prefixes and scheduling different backup tasks using Docker Compose.

## Features

- Compresses specified folders using `tar` and `xz`.
- Encrypts the compressed archive using PGP.
- Retains a specified number of the most recent backups.
- Schedules backup tasks using environment variables and cron jobs.

## Prerequisites

- Docker
- Docker Compose
- PGP key available for encryption

[WIP] To be continued...
