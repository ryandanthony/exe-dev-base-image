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

# Install all necessary packages and unminimize Ubuntu
RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|http://mirror://mirrors.ubuntu.com/mirrors.txt|' /etc/apt/sources.list && \
    rm -f /etc/dpkg/dpkg.cfg.d/excludes /etc/dpkg/dpkg.cfg.d/01_nodoc && \
    apt-get update && \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    echo 'pbuilder pbuilder/mirrorsite string http://archive.ubuntu.com/ubuntu' | debconf-set-selections && \
    echo 'y' | DEBIAN_FRONTEND=noninteractive unminimize && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y man-db && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --reinstall $(dpkg-query -f '${binary:Package} ' -W) && \
    mandb -c && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      ca-certificates wget ripgrep \
      git jq sqlite3 curl vim neovim lsof iproute2 less nginx \
      make python3-pip python-is-python3 tree net-tools file build-essential \
      pipx psmisc bsdmainutils sudo socat \
      openssh-server openssh-client \
      iputils-ping socat netcat-openbsd \
      libcap2-bin \
      unzip util-linux rsync \
      ubuntu-server ubuntu-dev-tools ubuntu-standard \
      man-db manpages manpages-dev \
      mitmproxy \
      systemd systemd-sysv \
      atop btop iotop ncdu \
      golang-go git \
      libglib2.0-0 libnss3 libx11-6 libxcomposite1 libxdamage1 \
      libxext6 libxi6 libxrandr2 libgbm1 libgtk-3-0 \
      fonts-noto-color-emoji fonts-symbola \
      docker.io docker-buildx docker-compose-v2 \
      imagemagick ffmpeg \
      gh \
      dbus-user-session && \
    apt-get remove -y pollinate ubuntu-fan && \
    setcap cap_net_raw=+ep /usr/bin/ping && \
    fc-cache -f -v && \
    apt-get clean

# Install uv (fast Python package installer)
RUN curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR=/usr/local/bin sh

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

# Copy shelley binary (AI assistant/agent)
# NOTE: This binary needs to be built separately or obtained from the exe.dev project
COPY shelley /usr/local/bin/shelley

# Make shelley executable and verify it works
RUN chmod +x /usr/local/bin/shelley && /usr/local/bin/shelley -help

# Copy headless-shell (headless Chrome for automation)
# NOTE: This is Chrome's headless shell binary
COPY /headless-shell /headless-shell

# Update PATH to include headless-shell
ENV PATH=/usr/local/bin:/headless-shell:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Create necessary directories for exedev user
RUN mkdir -p /home/exedev /home/exedev/.config/shelley && \
    chown exedev:exedev /home/exedev /home/exedev/.config /home/exedev/.config/shelley

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

# Copy systemd service files for shelley
COPY shelley.socket /etc/systemd/system/shelley.socket
COPY shelley.service /etc/systemd/system/shelley.service

# Enable shelley systemd socket
RUN chmod 644 /etc/systemd/system/shelley.socket /etc/systemd/system/shelley.service && \
    systemctl enable shelley.socket

# Copy init wrapper script
COPY init-wrapper.sh /usr/local/bin/init

# Install codex (OpenAI's CLI tool)
# NOTE: This checks for the latest codex release and downloads it
RUN ARCH=$(uname -m) && \
    case ${ARCH} in \
        x86_64) CODEX_ARCH="x86_64-unknown-linux-musl" ;; \
        aarch64|arm64) CODEX_ARCH="aarch64-unknown-linux-musl" ;; \
        *) echo "Unsupported architecture: ${ARCH}" && exit 1 ;; \
    esac && \
    CODEX_VERSION=$(curl -fsSL https://api.github.com/repos/openai/codex/releases/latest | jq -r '.tag_name') && \
    curl -fsSL "https://github.com/openai/codex/releases/download/${CODEX_VERSION}/codex-${CODEX_ARCH}.tar.gz" | \
    tar -xzC /usr/local/bin && \
    mv "/usr/local/bin/codex-${CODEX_ARCH}" /usr/local/bin/codex && \
    chmod +x /usr/local/bin/codex

# Create directories for AI assistants
RUN mkdir -p /home/exedev/.claude /home/exedev/.codex && \
    chown -R exedev:exedev /home/exedev/.claude /home/exedev/.codex

# Copy AGENTS.md documentation
COPY AGENTS.md /home/exedev/.config/shelley/AGENTS.md

# Copy AGENTS.md to multiple locations for different AI tools
RUN cp /home/exedev/.config/shelley/AGENTS.md /home/exedev/.claude/CLAUDE.md && \
    cp /home/exedev/.config/shelley/AGENTS.md /home/exedev/.codex/AGENTS.md && \
    chown exedev:exedev /home/exedev/.claude/CLAUDE.md /home/exedev/.codex/AGENTS.md /home/exedev/.config/shelley/AGENTS.md

# Install Claude CLI
RUN mkdir -p /home/exedev/.local/bin && \
    ARCH=$(uname -m | sed 's/x86_64/x64/;s/aarch64/arm64/') && \
    PLATFORM="linux-${ARCH}" && \
    STABLE_VERSION=$(curl -fsSL https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/stable) && \
    EXPECTED_HASH=$(curl -fsSL "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/${STABLE_VERSION}/manifest.json" | jq -r ".platforms[\"${PLATFORM}\"].checksum") && \
    curl -fsSL "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/${STABLE_VERSION}/${PLATFORM}/claude" -o /home/exedev/.local/bin/claude && \
    echo "${EXPECTED_HASH}  /home/exedev/.local/bin/claude" | sha256sum -c - && \
    chmod +x /home/exedev/.local/bin/claude && \
    chown -R exedev:exedev /home/exedev/.local && \
    ln -s /home/exedev/.local/bin/claude /usr/local/bin/claude

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
# 9999: Shelley AI assistant port
EXPOSE 8000/tcp 9999/tcp

# Label for exe.dev login user
LABEL exe.dev/login-user="exedev"

# Set command to run init wrapper
CMD ["/usr/local/bin/init"]
