#!/usr/bin/env bash
set -euox pipefail

###############################################################################
##### Runtime #####
###################

# configure dnf to cache rpm files
dnf5 config-manager setopt keepcache=1
