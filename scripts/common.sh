#!/usr/bin/env bash
set -euox pipefail

###############################################################################
##### Libraries #####
#####################

. /tmp/scripts/library

###############################################################################
##### Configuration #####
#########################

# rpms to install (that require no additional setup)
PACKAGES_INSTALL=(
)

# rpms to remove
PACKAGES_REMOVE=(
    "firefox"
    "toolbox"
)

# services to enable (that require no additional setup)
SERVICES_ENABLE=(
)

###############################################################################
##### Functions #####
#####################

install_ghostty() {
    local _packages=("ghostty")

    dnf5 copr enable -y scottames/ghostty
    dnf_install _packages
    dnf5 copr remove -y scottames/ghostty
}

install_homebrew_dependencies() {
    local _groups=("development-tools")
    local _packages=("procps-ng" "curl" "file")

    dnf5 group install -y "${_groups[@]}"
    dnf_install _packages
}

install_kmscon() {
    local _packages=("kmscon" "kmscon-freetype")

    dnf_install _packages
    sudo ln -s /usr/lib/systemd/system/kmsconvt@.service /etc/systemd/system/autovt@.service
}

install_ssh() {
    local _services=("sshd.service")
    local _src_dir="/tmp/resources/ssh"

    # create directories if needed
    install -d -m 0700 /etc/ssh/sshd_config.d

    # copy the hardening configuration
    install -m 0600 "${_src_dir}/99-hardening.conf" /etc/ssh/sshd_config.d/99-hardening.conf

    # enable service
    systemctl_enable _services
}

install_tailscale() {
    local _packages=("tailscale")
    local _services=("tailscaled.service")

    dnf5 config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo
    dnf_install _packages
    rm -f /etc/yum.repos.d/tailscale*.repo
    systemctl_enable _services
}

enable_flatpak_updater_service() {
    local _services=("flatpak-updater.timer")
    local _src_dir="/tmp/resources/systemd/flatpak-updater"

    # create directories if needed
    install -d -m 0755 /usr/libexec /usr/lib/systemd/system /usr/lib/systemd/user

    # install script to libexec
    install -m 0755 "${_src_dir}/flatpak-updater" /usr/libexec/flatpak-updater

    # install systemd system .service and .timer
    install -m 0644 "${_src_dir}/flatpak-updater-system.service" /usr/lib/systemd/system/flatpak-updater.service
    install -m 0644 "${_src_dir}/flatpak-updater.timer" /usr/lib/systemd/system/flatpak-updater.timer

    # install systemd user .service and .timer
    install -m 0644 "${_src_dir}/flatpak-updater-user.service" /usr/lib/systemd/user/flatpak-updater.service
    install -m 0644 "${_src_dir}/flatpak-updater.timer" /usr/lib/systemd/user/flatpak-updater.timer

    # enable timers
    systemctl_enable _services
    systemctl_enable _services --global
}

enable_custom_os_build_timer() {
    local _services=("custom-os-build.timer")
    local _src_dir="/tmp/resources/systemd/custom-os"

    # create directories if needed
    install -d -m 0755 /usr/share/containers/systemd /usr/lib/systemd/system

    # install systemd .build and .timer
    install -m 0644 "${_src_dir}/custom-os.build" /usr/share/containers/systemd/custom-os.build
    install -m 0644 "${_src_dir}/custom-os-build.timer" /usr/lib/systemd/system/custom-os-build.timer

    # enable timers
    systemctl_enable _services
}

remove_wallpapers() {
    rpm -e --nodeps $(rpm -qa "f*-backgrounds-base") fedora-workstation-backgrounds
}

###############################################################################
##### Runtime #####
###################

# install things
dnf_install PACKAGES_INSTALL
install_ghostty
install_homebrew_dependencies
install_kmscon
install_ssh
install_tailscale

# remove things
dnf_remove PACKAGES_REMOVE
remove_wallpapers

# manage services
systemctl_enable SERVICES_ENABLE
enable_flatpak_updater_service
enable_custom_os_build_timer
