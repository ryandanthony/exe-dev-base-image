# Dockerfile Analysis: Stack-Agnostic Base Image (Step 1)

This document provides a comprehensive analysis of the simplified, stack-agnostic Dockerfile.

---

## Overview

| Property | Value |
|----------|-------|
| **Base Image** | `ubuntu:24.04` |
| **Image Purpose** | Stack-agnostic development base environment |
| **Primary User** | `exedev` |
| **Key Ports** | 8000 (web server) |

---

## Changes from Original

This version removes:
- ❌ Language-specific tools (Python, Go)
- ❌ AI coding assistants (Shelley, Claude, Codex)
- ❌ Headless Chrome and its dependencies
- ❌ Documentation/man pages (unminimize step)
- ❌ uv Python package manager

---

## 1. Build Configuration

### Build Arguments

| Argument | Purpose |
|----------|---------|
| `RELEASE` | Likely used for versioning or release tagging |
| `LAUNCHPAD_BUILD_ARCH` | Ubuntu Launchpad build architecture specification |

### Shell Configuration

```dockerfile
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]
```

**Purpose:** Sets strict shell mode for all RUN commands:
- `-e`: Exit immediately on error
- `-u`: Treat unset variables as errors
- `-x`: Print commands before execution (debugging)
- `-o pipefail`: Fail if any command in a pipeline fails

**Why:** Ensures reliable, debuggable builds with fail-fast behavior.

---

## 2. Installed Software

### System Preparation

| Action | Purpose |
|--------|---------|
| Configure mirror list for apt | Faster package downloads using geographic mirrors |
| Set debconf to noninteractive | Prevent interactive prompts during package installation |

---

### Software by Category

#### 🔧 Core System Utilities

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `ca-certificates` | SSL/TLS certificate authorities | HTTPS connections, secure downloads |
| `wget` | File downloader | Downloading files from URLs |
| `curl` | Data transfer tool | API calls, file downloads |
| `util-linux` | Core Linux utilities | System management commands |
| `sudo` | Privilege escalation | Allow non-root admin tasks |
| `file` | File type detection | Identify file formats |
| `rsync` | File synchronization | Efficient file copying/backup |
| `unzip` | Archive extraction | Extract ZIP files |
| `bsdmainutils` | BSD utilities | `column`, `hexdump`, etc. |
| `psmisc` | Process utilities | `killall`, `pstree`, `fuser` |
| `less` | Pager | View files page by page |
| `tree` | Directory viewer | Visualize directory structure |

#### 💻 Build Tools

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `build-essential` | C/C++ compiler toolchain | Compile native code/extensions |
| `make` | Build automation | Run Makefiles |

#### 🔍 Search & Text Processing

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `ripgrep` | Fast code search | Search files quickly |
| `jq` | JSON processor | Parse/manipulate JSON data |

#### 📝 Editors

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `vim` | Traditional text editor | Quick file editing |
| `neovim` | Modern Vim | Enhanced editing experience |

#### 🔄 Version Control

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `git` | Version control | Source code management |

#### 🌐 Networking

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `nginx` | Web server | Serve web applications |
| `openssh-server` | SSH daemon | Remote access |
| `openssh-client` | SSH client | Connect to remote servers |
| `iproute2` | Network configuration | `ip` command for networking |
| `net-tools` | Legacy network tools | `ifconfig`, `netstat` |
| `iputils-ping` | Ping utility | Network connectivity testing |
| `socat` | Socket relay | Port forwarding, socket manipulation |
| `netcat-openbsd` | Network utility | Raw TCP/UDP connections |
| `mitmproxy` | HTTP proxy | Debug/intercept HTTP traffic |

#### 📊 Monitoring & Diagnostics

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `lsof` | List open files | Debug file/port usage |
| `atop` | System monitor | Advanced performance monitoring |
| `btop` | Resource monitor | Beautiful system monitoring |
| `iotop` | I/O monitor | Disk I/O analysis |
| `ncdu` | Disk usage analyzer | Find what's using disk space |

#### 🐳 Containers

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `docker.io` | Container runtime | Run Docker containers |
| `docker-buildx` | Docker build extension | Multi-platform builds |
| `docker-compose-v2` | Container orchestration | Multi-container applications |

#### 🖼️ Media Processing

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `imagemagick` | Image manipulation | Convert, resize, process images |
| `ffmpeg` | Video/audio processing | Media format conversion |

#### 🔤 Fonts

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `fonts-noto-color-emoji` | Color emoji font | Display emoji properly |
| `fonts-symbola` | Symbol font | Unicode symbols |

#### 🗄️ Database

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `sqlite3` | Embedded database | Local data storage |

#### 🔒 Security

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `libcap2-bin` | Linux capabilities | Fine-grained privilege control |

#### 🛠️ System Services

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `systemd` | Init system | Service management |
| `systemd-sysv` | SysV compatibility | Legacy init scripts |
| `dbus-user-session` | D-Bus user session | IPC for user services |

#### 📦 Ubuntu Metapackages

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `ubuntu-server` | Server essentials | Standard server packages |
| `ubuntu-standard` | Standard utilities | Common Ubuntu tools |

#### 🔧 GitHub Integration

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `gh` | GitHub CLI | GitHub operations from terminal |

---

## 3. Removed Software

| Package | Why Removed |
|---------|-------------|
| `pollinate` | Cloud entropy service - unnecessary in container |
| `ubuntu-fan` | Network overlay - not needed for container networking |

---

## 4. Copied Files

| Source | Destination | Purpose |
|--------|-------------|---------|
| `motd-snippet.bash` | `/tmp/motd-snippet.bash` | Custom login message |
| `init-wrapper.sh` | `/usr/local/bin/init` | Container init script |
| `nginx.conf` | `/etc/nginx/sites-available/default` | Web server configuration |
| `index.html` | `/var/www/html/index.html` | Default web page |
| `xterm-ghostty.terminfo` | `/tmp/xterm-ghostty.terminfo` | Ghostty terminal compatibility |

---

## 5. Removed/Deleted Files

| File/Directory | Why Removed |
|----------------|-------------|
| `/etc/update-motd.d/*` | Remove default MOTD scripts |
| `/etc/motd` | Remove default message of the day |
| `/tmp/motd-snippet.bash` | Cleanup after appending to bashrc |
| `/tmp/xterm-ghostty.terminfo` | Cleanup after compiling terminfo |

---

## 6. Disabled/Masked Systemd Services

### Removed Service Links

| Service | Why Removed |
|---------|-------------|
| `console-setup.service` | Console setup not needed in container |
| `ModemManager.service` | Modem management not needed |
| `snapd.*` | Snap packages disabled |
| `unattended-upgrades.*` | Auto-updates disabled for reproducibility |
| `ubuntu-advantage.service` | Ubuntu Pro not needed |

### Masked Services (Completely Disabled)

| Category | Services | Why Masked |
|----------|----------|------------|
| **TTY/Console** | `getty.target`, `console-getty.service` | No physical console |
| **Hardware** | `systemd-udevd.*`, `systemd-hwdb-update.service`, `modprobe@.service` | No hardware in container |
| **Filesystem** | `systemd-remount-fs.service`, `etc-*.mount`, `-.mount` | Container filesystem is different |
| **Boot** | `systemd-random-seed.service`, `systemd-firstboot.service`, `systemd-update-done.service` | Not applicable to containers |
| **Plymouth** | `plymouth*.service` | No boot splash in containers |
| **Storage** | `iscsid.socket`, `dm-event.socket` | No direct storage access |
| **Timers** | `man-db.timer`, `update-notifier-*.timer`, `atop-rotate.timer`, `dpkg-db-backup.timer`, `e2scrub_all.timer`, `apt-daily*.timer` | Reduce background activity |
| **Networking** | `systemd-resolved.service`, `ubuntu-fan.service` | Container uses host networking |

### Disabled Services

| Category | Services | Why Disabled |
|----------|----------|--------------|
| **Containers** | `docker.service`, `containerd.service` | Started on-demand, not at boot |
| **Web** | `nginx.service` | Started manually when needed |
| **Monitoring** | `atop.service`, `atopacct.service`, `sysstat.service` | Run manually if needed |
| **Crash Reporting** | `apport.*` | Not needed in dev environment |
| **Storage** | `udisks2.service`, `lvm2-lvmpolld.socket` | No physical disks |
| **Firewall** | `ufw.service` | Container networking handles this |
| **Snap** | `snapd.socket`, `snapd.snap-repair.*` | Snap disabled |

**Why:** Optimizes container startup time, reduces resource usage, and eliminates unnecessary services for a container environment.

---

## 7. User Configuration

### User Setup

| Action | Details | Purpose |
|--------|---------|---------|
| Rename `ubuntu` → `exedev` | User and group | Brand the environment |
| Move home directory | `/home/ubuntu` → `/home/exedev` | Follow user rename |
| Add to `sudo` group | `usermod -aG sudo` | Admin privileges |
| Add to `docker` group | `usermod -aG docker` | Run Docker without sudo |
| Configure NOPASSWD sudo | `/etc/sudoers` entry | Frictionless admin commands |
| Enable user lingering | `/var/lib/systemd/linger/exedev` | User services run without login |
| Create `.hushlogin` | Empty file | Suppress default login messages |

### User Directories Created

| Directory | Purpose |
|-----------|---------|
| `/home/exedev` | Home directory |
| `/home/exedev/.config` | User configuration directory |

### Environment Configuration

| File | Configuration | Purpose |
|------|---------------|---------|
| `.bashrc` | `PATH="$HOME/.local/bin:$PATH"` | User binaries in PATH |
| `.bashrc` | `XDG_RUNTIME_DIR="/run/user/$(id -u)"` | Runtime directory for services |
| `.bashrc` | Custom MOTD snippet | Show info on login |
| `.profile` | `XDG_RUNTIME_DIR` | Same as bashrc for non-interactive |
| Git config | `init.defaultBranch main` | Modern git defaults |

---

## 8. Environment Variables

| Variable | Value | Purpose |
|----------|-------|---------|
| `EXEUNTU=1` | Flag | Identify as exeuntu image |

---

## 9. Network Configuration

### Exposed Ports

| Port | Protocol | Purpose |
|------|----------|---------|
| 8000 | TCP | Default web server |

### Capability Configuration

| Command | Purpose |
|---------|---------|
| `setcap cap_net_raw=+ep /usr/bin/ping` | Allow ping without root |

---

## 10. Labels

| Label | Value | Purpose |
|-------|-------|---------|
| `exe.dev/login-user` | `exedev` | Identify default login user |

---

## 11. Entrypoint

| Command | Purpose |
|---------|---------|
| `CMD ["/usr/local/bin/init"]` | Run init wrapper script |

**Why:** The init wrapper likely starts systemd or manages container lifecycle.

---

## Summary

This stack-agnostic base image provides:

1. **Core Infrastructure**: systemd, networking, SSH, nginx
2. **Container Support**: Docker-in-Docker capability
3. **Build Tools**: C/C++ toolchain for compiling native extensions
4. **Developer Utilities**: Git, ripgrep, jq, vim/neovim
5. **Monitoring Tools**: btop, atop, iotop for system analysis
6. **Networking Tools**: mitmproxy, socat, netcat for debugging
7. **Media Tools**: imagemagick, ffmpeg for processing

**What's NOT included (by design):**
- ❌ Programming language runtimes (Python, Go, Node, etc.)
- ❌ AI coding assistants
- ❌ Browser automation tools
- ❌ Man pages and documentation

This allows teams to layer their specific development stack on top of this base image.
