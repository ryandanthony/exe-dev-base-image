# Dockerfile Analysis: exe.dev Base Image (exeuntu)

This document provides a comprehensive analysis of each action in the Dockerfile for the exe.dev base image.

---

## Overview

| Property | Value |
|----------|-------|
| **Base Image** | `ubuntu:24.04` |
| **Image Purpose** | Development environment with AI coding assistants |
| **Primary User** | `exedev` |
| **Key Ports** | 8000 (web server), 9999 (Shelley AI) |

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
| Remove `/etc/dpkg/dpkg.cfg.d/excludes` | Allow installation of docs/man pages (normally excluded in minimal images) |
| Remove `/etc/dpkg/dpkg.cfg.d/01_nodoc` | Same as above - enable documentation |
| Run `unminimize` | Restore full Ubuntu system from minimal container image |
| Reinstall all packages | Restore man pages and documentation stripped from minimal image |
| Run `mandb -c` | Rebuild man page database |

**Why:** Transforms minimal container image into a full development environment with documentation.

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

#### 💻 Development Tools

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `build-essential` | C/C++ compiler toolchain | Compile native code |
| `make` | Build automation | Run Makefiles |
| `git` | Version control | Source code management |
| `golang-go` | Go programming language | Go development |
| `python3-pip` | Python package manager | Install Python packages |
| `python-is-python3` | Python symlink | `python` command points to Python 3 |
| `pipx` | Isolated Python app installer | Install Python CLI tools safely |
| `ubuntu-dev-tools` | Ubuntu development utilities | Package building, `pull-lp-source`, etc. |

#### 🔍 Search & Text Processing

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `ripgrep` | Fast code search | Search code quickly (used by AI tools) |
| `jq` | JSON processor | Parse/manipulate JSON data |

#### 📝 Editors

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `vim` | Traditional text editor | Quick file editing |
| `neovim` | Modern Vim | Enhanced editing experience |

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

#### 🔤 Fonts & Display

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `fonts-noto-color-emoji` | Color emoji font | Display emoji properly |
| `fonts-symbola` | Symbol font | Unicode symbols |

#### 📚 Documentation

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `man-db` | Man page system | View manual pages |
| `manpages` | Linux man pages | Core documentation |
| `manpages-dev` | Development man pages | Programming documentation |
| `less` | Pager | View files/man pages |
| `tree` | Directory viewer | Visualize directory structure |

#### 🗄️ Database

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `sqlite3` | Embedded database | Local data storage |

#### 🔒 Security

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `libcap2-bin` | Linux capabilities | Fine-grained privilege control |

#### 🖥️ Headless Chrome Dependencies

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `libglib2.0-0` | GLib library | Chrome dependency |
| `libnss3` | Network Security Services | Chrome dependency |
| `libx11-6` | X11 library | Chrome dependency |
| `libxcomposite1` | X Composite extension | Chrome dependency |
| `libxdamage1` | X Damage extension | Chrome dependency |
| `libxext6` | X extensions | Chrome dependency |
| `libxi6` | X Input extension | Chrome dependency |
| `libxrandr2` | X Resize extension | Chrome dependency |
| `libgbm1` | Graphics buffer manager | Chrome dependency |
| `libgtk-3-0` | GTK 3 library | Chrome dependency |

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

### Externally Installed Software (Not from apt)

| Software | Source | Purpose | Why Installed |
|----------|--------|---------|---------------|
| `uv` | astral.sh | Fast Python package installer | Modern Python tooling, faster than pip |
| `codex` | GitHub (openai/codex) | OpenAI's CLI coding assistant | AI-powered coding help |
| `claude` | Google Cloud Storage | Anthropic's CLI coding assistant | AI-powered coding help |
| `shelley` | Local COPY | exe.dev's AI assistant | Primary AI coding assistant |
| `headless-shell` | Local COPY | Headless Chrome | Browser automation, screenshots |

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
| `shelley` | `/usr/local/bin/shelley` | AI assistant binary |
| `/headless-shell` | `/headless-shell` | Headless Chrome browser |
| `motd-snippet.bash` | `/tmp/motd-snippet.bash` | Custom login message |
| `shelley.socket` | `/etc/systemd/system/shelley.socket` | Systemd socket activation for shelley |
| `shelley.service` | `/etc/systemd/system/shelley.service` | Systemd service for shelley |
| `init-wrapper.sh` | `/usr/local/bin/init` | Container init script |
| `AGENTS.md` | `/home/exedev/.config/shelley/AGENTS.md` | AI agent documentation |
| `nginx.conf` | `/etc/nginx/sites-available/default` | Web server configuration |
| `index.html` | `/var/www/html/index.html` | Default web page |
| `xterm-ghostty.terminfo` | `/tmp/xterm-ghostty.terminfo` | Ghostty terminal compatibility |

---

## 5. Removed/Deleted Files

| File/Directory | Why Removed |
|----------------|-------------|
| `/etc/dpkg/dpkg.cfg.d/excludes` | Allow man page installation |
| `/etc/dpkg/dpkg.cfg.d/01_nodoc` | Allow documentation installation |
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
| `/home/exedev/.config/shelley` | Shelley configuration |
| `/home/exedev/.claude` | Claude CLI configuration |
| `/home/exedev/.codex` | Codex CLI configuration |
| `/home/exedev/.local/bin` | User-local binaries |

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
| `PATH` | `/usr/local/bin:/headless-shell:...` | Include headless-shell in PATH |

---

## 9. Network Configuration

### Exposed Ports

| Port | Protocol | Purpose |
|------|----------|---------|
| 8000 | TCP | Default web server |
| 9999 | TCP | Shelley AI assistant |

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

This Dockerfile creates a **fully-featured development environment** with:

1. **AI Coding Assistants**: Shelley (primary), Claude CLI, and Codex
2. **Full Ubuntu Experience**: Unminimized with man pages and documentation
3. **Container Optimizations**: Disabled unnecessary services for faster startup
4. **Developer Tools**: Git, Go, Python, Docker, build tools
5. **Browser Automation**: Headless Chrome for screenshots/scraping
6. **Monitoring Tools**: btop, atop, iotop for system analysis
7. **Networking Tools**: mitmproxy, socat, netcat for debugging

The image is designed to be a **cloud-based development VM** that provides a complete Linux environment with AI assistance for coding tasks.
