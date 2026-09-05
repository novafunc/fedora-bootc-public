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
    # gnome apps
        "gnome-software"
        "gnome-system-monitor"
        "gnome-tour"
        "ptyxis"
        "yelp"
    # gnome backgrounds
        "f44-backgrounds-gnome"
        "gnome-backgrounds"
    # gnome extensions
        "gnome-classic-session"
        "gnome-shell-extension-common"
        "gnome-shell-extension-apps-menu"
        "gnome-shell-extension-launch-new-instance"
        "gnome-shell-extension-places-menu"
        "gnome-shell-extension-window-list"
        "gnome-shell-extension-background-logo"
)

# services to enable
SERVICES_ENABLE=(
    #"gdm.service"
)

###############################################################################
##### Functions #####
#####################

install_nautilus_open_any_terminal() {
    local _packages=("nautilus-open-any-terminal")

    dnf5 copr enable -y monkeygold/nautilus-open-any-terminal
    dnf_install _packages
    dnf5 copr remove -y monkeygold/nautilus-open-any-terminal
}

###############################################################################
##### Runtime #####
###################

# install things
dnf_install PACKAGES_INSTALL
install_nautilus_open_any_terminal

# remove things
dnf_remove PACKAGES_REMOVE

# manage services
systemctl_enable SERVICES_ENABLE
