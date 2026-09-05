#!/usr/bin/env bash
set -euox pipefail

###############################################################################
##### Libraries #####
#####################

. /tmp/scripts/library

###############################################################################
##### Configuration #####
#########################

# rpms to install
PACKAGES_INSTALL=(
    "gnome-disk-utility"
)

# rpms to remove
PACKAGES_REMOVE=(
)

# services to enable
SERVICES_ENABLE=(
)

###############################################################################
##### Runtime #####
###################

# install things
dnf_install PACKAGES_INSTALL

# remove things
dnf_remove PACKAGES_REMOVE

# manage services
systemctl_enable SERVICES_ENABLE
