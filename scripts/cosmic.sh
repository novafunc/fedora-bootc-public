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
)

# rpms to remove
PACKAGES_REMOVE=(
    "ark"
    "cosmic-edit"
    "cosmic-player"
    "cosmic-store"
    "gnome-system-monitor"
)

# services to enable
SERVICES_ENABLE=(
)

###############################################################################
##### Functions #####
#####################

install_cosmic_git() {
    dnf5 copr enable -y ryanabx/cosmic-epoch
    dnf5 upgrade -y
    dnf5 copr remove -y ryanabx/cosmic-epoch
}

###############################################################################
##### Runtime #####
###################

# install things
dnf_install PACKAGES_INSTALL

# remove things
dnf_remove PACKAGES_REMOVE

# manage services
systemctl_enable SERVICES_ENABLE
