#!/usr/bin/env bash
set -euox pipefail

###############################################################################
##### Runtime #####
###################

# purge rpm files older than 30 days from cache
# note: may need to clean up other files
find /var/cache/libdnf5 -name "*.rpm" -mtime +30 -delete

# clean /run excluding active runtime mounts (/run/secrets, /run/systemd)
find /run -mindepth 1 -maxdepth 1 ! -name "secrets" ! -name "systemd" -exec rm -rf {} + 2>/dev/null || true

# clean /tmp excluding active bind mounts
find /tmp -mindepth 1 -maxdepth 1 ! -name "resources" ! -name "scripts" -exec rm -rf {} + || true

# clean /var/cache excluding the active DNF cache mount
find /var/cache -mindepth 1 -maxdepth 1 ! -name "libdnf5" -exec rm -rf {} +

# clean /var/tmp
rm -rf /var/tmp/*
