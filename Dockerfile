# Reverse engineered Dockerfile for exe.dev base image (exeuntu)
# Based on image analysis of ghcr.io/boldsoftware/exeuntu:latest
# Image digest: sha256:6b3e8258e3a2022e779556ddb80bda4db68535677ce2ba7cede08ee5798466fc
# Created: 2026-01-16T06:12:36Z

# Base image: Ubuntu 24.04
FROM ubuntu:24.04

# Build arguments
ARG RELEASE
ARG LAUNCHPAD_BUILD_ARCH

# Set shell for all RUN commands
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

# Install all necessary packages
RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|http://mirror://mirrors.ubuntu.com/mirrors.txt|' /etc/apt/sources.list && \
    apt-get update && \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    echo 'pbuilder pbuilder/mirrorsite string http://archive.ubuntu.com/ubuntu' | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      ca-certificates wget ripgrep \
      git jq sqlite3 curl vim neovim lsof iproute2 less nginx \
      make tree net-tools file build-essential \
      psmisc bsdmainutils sudo socat \
      openssh-server openssh-client \
      iputils-ping socat netcat-openbsd \
      libcap2-bin \
      unzip util-linux rsync \
      ubuntu-server ubuntu-standard \
      mitmproxy \
      systemd systemd-sysv \
      atop btop iotop ncdu \
      fonts-noto-color-emoji fonts-symbola \
      docker.io docker-buildx docker-compose-v2 \
      imagemagick ffmpeg \
      gh \
      dbus-user-session && \
    apt-get remove -y pollinate ubuntu-fan && \
    setcap cap_net_raw=+ep /usr/bin/ping && \
    fc-cache -f -v && \
    apt-get clean

# Disable and mask unnecessary systemd services to optimize for container environment
RUN rm /etc/systemd/system/multi-user.target.wants/console-setup.service \
      /etc/systemd/system/multi-user.target.wants/ModemManager.service \
      /etc/systemd/system/multi-user.target.wants/snapd.* \
      /etc/systemd/system/multi-user.target.wants/unattended-upgrades.* \
      /etc/systemd/system/multi-user.target.wants/ubuntu-advantage.service && \
    systemctl mask -- \
      getty.target \
      systemd-random-seed.service \
      iscsid.socket \
      dm-event.socket \
      man-db.timer \
      update-notifier-download.timer \
      update-notifier-motd.timer \
      atop-rotate.timer \
      dpkg-db-backup.timer \
      e2scrub_all.timer \
      etc-resolv.conf.mount \
      etc-hosts.mount \
      etc-hostname.mount \
      -.mount \
      systemd-resolved.service \
      systemd-remount-fs.service \
      systemd-sysusers.service \
      systemd-update-done.service \
      systemd-update-utmp.service \
      systemd-journal-catalog-update.service \
      modprobe@.service \
      systemd-modules-load.service \
      systemd-journal-flush.service \
      systemd-udevd.service \
      systemd-udevd-control.service \
      systemd-udevd-kernel.service \
      systemd-udev-trigger.service \
      systemd-udev-settle.service \
      systemd-hwdb-update.service \
      ubuntu-fan.service \
      ldconfig.service \
      unattended-upgrades.service \
      lxd-installer.socket \
      console-getty.service \
      keyboard-setup.service \
      systemd-ask-password-console.path \
      systemd-ask-password-wall.path \
      ssh.socket \
      plymouth.service \
      plymouth-start.service \
      plymouth-quit.service \
      plymouth-quit-wait.service \
      plymouth-read-write.service \
      plymouth-switch-root.service \
      plymouth-switch-root-initramfs.service \
      plymouth-halt.service \
      plymouth-reboot.service \
      plymouth-poweroff.service \
      plymouth-kexec.service \
      apt-daily-upgrade.timer \
      apt-daily.timer \
      plymouth-log.service && \
    systemctl disable \
      docker.service containerd.service getty.target systemd-logind.service \
      nginx.service \
      console-getty.service \
      atop.service \
      getty@.service \
      snapd.socket \
      motd-news.timer motd-news.service \
      apport.service apport-autoreport.timer apport-autoreport.path apport-forward.socket \
      snapd.snap-repair.timer snapd.snap-repair.service \
      udisks2.service \
      ufw.service \
      lvm2-lvmpolld.socket \
      systemd-ask-password-wall.service \
      systemd-ask-password-console.service \
      systemd-machine-id-commit.service \
      systemd-modules-load.service \
      systemd-sysctl.service \
      systemd-firstboot.service \
      systemd-udevd.service \
      systemd-udev-trigger.service \
      systemd-udev-settle.service \
      e2scrub_reap.service \
      systemd-update-utmp.service \
      atopacct.service \
      sysstat.service \
      systemd-hwdb-update.service \
      multipathd.service && \
    mkdir -p /etc/systemd/system.conf.d && \
    echo '[Manager]' > /etc/systemd/system.conf.d/container-overrides.conf && \
    echo 'LogLevel=info' >> /etc/systemd/system.conf.d/container-overrides.conf && \
    echo 'LogTarget=console' >> /etc/systemd/system.conf.d/container-overrides.conf && \
    echo 'SystemCallArchitectures=native' >> /etc/systemd/system.conf.d/container-overrides.conf && \
    systemctl set-default multi-user.target

# Set up exedev user (renamed from ubuntu default user)
RUN usermod -l exedev -c "exe.dev user" ubuntu && \
    groupmod -n exedev ubuntu && \
    mv /home/ubuntu /home/exedev && \
    usermod -d /home/exedev exedev && \
    usermod -aG sudo exedev && \
    usermod -aG docker exedev && \
    sed -i 's/^ubuntu:/exedev:/' /etc/subuid /etc/subgid && \
    echo 'exedev ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    mkdir -p /var/lib/systemd/linger && \
    touch /var/lib/systemd/linger/exedev

# Set environment variable to identify this as an exeuntu image
ENV EXEUNTU=1

# Create necessary directories for exedev user
RUN mkdir -p /home/exedev /home/exedev/.config && \
    chown exedev:exedev /home/exedev /home/exedev/.config

# Switch to exedev user
USER exedev

# Set working directory
WORKDIR /home/exedev

# Configure bash environment for exedev user
RUN echo 'export PATH="$HOME/.local/bin:$PATH"' >> /home/exedev/.bashrc && \
    echo 'export XDG_RUNTIME_DIR="/run/user/$(id -u)"' >> /home/exedev/.bashrc && \
    echo 'export XDG_RUNTIME_DIR="/run/user/$(id -u)"' >> /home/exedev/.profile

# Configure git defaults
RUN git config --global init.defaultBranch main

# Switch back to root for remaining setup
USER root

# Disable MOTD (message of the day) default messages
RUN rm -rf /etc/update-motd.d/* /etc/motd && \
    touch /home/exedev/.hushlogin && \
    chown exedev:exedev /home/exedev/.hushlogin

# Copy custom MOTD snippet
COPY motd-snippet.bash /tmp/motd-snippet.bash

# Add custom MOTD to bashrc
RUN cat /tmp/motd-snippet.bash >> /home/exedev/.bashrc && rm /tmp/motd-snippet.bash

# Copy init wrapper script
COPY init-wrapper.sh /usr/local/bin/init

# Copy nginx configuration
COPY nginx.conf /etc/nginx/sites-available/default

# Copy default index.html for nginx
COPY index.html /var/www/html/index.html

# Set permissions on nginx files
RUN chmod 644 /var/www/html/index.html

# Copy and install Ghostty terminal info
COPY xterm-ghostty.terminfo /tmp/xterm-ghostty.terminfo

RUN tic -x - < /tmp/xterm-ghostty.terminfo && rm /tmp/xterm-ghostty.terminfo

# Expose ports
# 8000: Default web server port
EXPOSE 8000/tcp

# Label for exe.dev login user
LABEL exe.dev/login-user="exedev"

# Set command to run init wrapper
CMD ["/usr/local/bin/init"]
