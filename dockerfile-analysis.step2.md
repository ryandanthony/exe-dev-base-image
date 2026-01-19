# Dockerfile Analysis: Stack-Agnostic Base Image (Step 2)

This document provides a comprehensive analysis of the streamlined, stack-agnostic Dockerfile with separated package layers.

---

## Overview

| Property | Value |
|----------|-------|
| **Base Image** | `ubuntu:24.04` |
| **Image Purpose** | Minimal stack-agnostic development base environment |
| **Primary User** | `exedev` |
| **Key Ports** | 8000 (general purpose) |
| **Docker Layers** | 2 separate apt install layers for better caching |

---

## Changes from Step 1

This version:
- ✅ Splits package installation into 2 RUN commands for better layer caching
- ✅ Adds proper cleanup (`rm -rf /var/lib/apt/lists/*`) after each install
- ❌ Removes sqlite3 (database)
- ❌ Removes fonts (fonts-noto-color-emoji, fonts-symbola)
- ❌ Removes nginx and all related configuration

---

## 1. Build Configuration

### Build Arguments

| Argument | Purpose |
|----------|---------|
| `RELEASE` | Versioning or release tagging |
| `LAUNCHPAD_BUILD_ARCH` | Ubuntu Launchpad build architecture specification |

### Shell Configuration

```dockerfile
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]
```

**Purpose:** Strict shell mode for reliable, debuggable builds.

---

## 2. Installed Software

### Layer 1: Base System Packages (RUN 1)

This layer contains foundational system components that rarely change.

#### System Services

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `systemd` | Init system | Service management in container |
| `systemd-sysv` | SysV compatibility | Legacy init script support |
| `dbus-user-session` | D-Bus user session | IPC for user services |

#### Ubuntu Metapackages

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `ubuntu-server` | Server essentials | Standard server packages |
| `ubuntu-standard` | Standard utilities | Common Ubuntu tools |

#### Monitoring & Diagnostics

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `lsof` | List open files | Debug file/port usage |
| `atop` | System monitor | Advanced performance monitoring |
| `btop` | Resource monitor | Beautiful TUI system monitoring |
| `iotop` | I/O monitor | Disk I/O analysis |
| `ncdu` | Disk usage analyzer | Interactive disk space viewer |

#### Core System Utilities

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `ca-certificates` | SSL/TLS certificates | HTTPS connections |
| `curl` | Data transfer | API calls, downloads |
| `wget` | File downloader | Alternative downloader |
| `unzip` | Archive extraction | Extract ZIP files |
| `file` | File type detection | Identify file formats |
| `less` | Pager | View files/output |
| `tree` | Directory viewer | Visualize directory structure |
| `util-linux` | Core utilities | System management commands |
| `bsdmainutils` | BSD utilities | `column`, `hexdump`, etc. |
| `psmisc` | Process utilities | `killall`, `pstree`, `fuser` |
| `sudo` | Privilege escalation | Admin tasks without root |
| `libcap2-bin` | Linux capabilities | Fine-grained privileges |
| `rsync` | File synchronization | Efficient file copying |

#### Networking

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `openssh-server` | SSH daemon | Remote access to container |
| `openssh-client` | SSH client | Connect to remote servers |
| `iproute2` | Network config | `ip` command |
| `net-tools` | Legacy network tools | `ifconfig`, `netstat` |
| `iputils-ping` | Ping utility | Network testing |
| `socat` | Socket relay | Port forwarding |
| `netcat-openbsd` | Network utility | Raw TCP/UDP |
| `mitmproxy` | HTTP proxy | Debug HTTP traffic |

#### Containers

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `docker.io` | Container runtime | Docker-in-Docker capability |
| `docker-buildx` | Build extension | Multi-platform builds |
| `docker-compose-v2` | Orchestration | Multi-container apps |

---

### Layer 2: Development Tools (RUN 2)

This layer contains tools more likely to be updated or customized.

#### Build Tools

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `build-essential` | C/C++ toolchain | Compile native code |
| `make` | Build automation | Run Makefiles |

#### Version Control & GitHub

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `git` | Version control | Source code management |
| `gh` | GitHub CLI | GitHub operations |

#### Media Processing

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `imagemagick` | Image manipulation | Convert, resize images |
| `ffmpeg` | Video/audio processing | Media conversion |

#### Search & Text Processing

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `ripgrep` | Fast search | Code/file searching |
| `jq` | JSON processor | Parse/manipulate JSON |

#### Editors

| Package | Purpose | Why Installed |
|---------|---------|---------------|
| `vim` | Text editor | Quick file editing |
| `neovim` | Modern Vim | Enhanced editing |

---

## 3. Removed Software

| Package | Why Removed |
|---------|-------------|
| `pollinate` | Cloud entropy service - unnecessary |
| `ubuntu-fan` | Network overlay - not needed |

---

## 4. Copied Files

| Source | Destination | Purpose |
|--------|-------------|---------|
| `motd-snippet.bash` | `/tmp/motd-snippet.bash` → `.bashrc` | Custom login message |
| `init-wrapper.sh` | `/usr/local/bin/init` | Container init script |
| `xterm-ghostty.terminfo` | `/tmp/` → compiled | Ghostty terminal support |

---

## 5. Removed/Deleted Files

| File/Directory | Why Removed |
|----------------|-------------|
| `/etc/update-motd.d/*` | Remove default MOTD |
| `/etc/motd` | Remove default message |
| `/tmp/motd-snippet.bash` | Cleanup after use |
| `/tmp/xterm-ghostty.terminfo` | Cleanup after compile |
| `/var/lib/apt/lists/*` | Reduce image size |

---

## 6. Disabled/Masked Systemd Services

### Removed Service Links

| Service | Why Removed |
|---------|-------------|
| `console-setup.service` | No console in container |
| `ModemManager.service` | No modems |
| `snapd.*` | Snap disabled |
| `unattended-upgrades.*` | Manual updates only |
| `ubuntu-advantage.service` | Ubuntu Pro not needed |

### Masked Services (Completely Disabled)

| Category | Services |
|----------|----------|
| **TTY/Console** | `getty.target`, `console-getty.service` |
| **Hardware** | `systemd-udevd.*`, `systemd-hwdb-update.service`, `modprobe@.service` |
| **Filesystem** | `systemd-remount-fs.service`, `etc-*.mount`, `-.mount` |
| **Boot** | `systemd-random-seed.service`, `systemd-firstboot.service` |
| **Plymouth** | `plymouth*.service` (all variants) |
| **Storage** | `iscsid.socket`, `dm-event.socket` |
| **Timers** | `man-db.timer`, `atop-rotate.timer`, `dpkg-db-backup.timer`, `apt-daily*.timer` |
| **Networking** | `systemd-resolved.service`, `ubuntu-fan.service` |

### Disabled Services

| Category | Services |
|----------|----------|
| **Containers** | `docker.service`, `containerd.service` |
| **Monitoring** | `atop.service`, `atopacct.service`, `sysstat.service` |
| **Crash Reporting** | `apport.*` |
| **Storage** | `udisks2.service`, `lvm2-lvmpolld.socket` |
| **Firewall** | `ufw.service` |
| **Snap** | `snapd.socket`, `snapd.snap-repair.*` |

---

## 7. User Configuration

### User Setup

| Action | Purpose |
|--------|---------|
| Rename `ubuntu` → `exedev` | Brand the environment |
| Add to `sudo` group | Admin privileges |
| Add to `docker` group | Docker without sudo |
| NOPASSWD sudo | Frictionless admin |
| Enable lingering | User services persist |
| Create `.hushlogin` | Suppress login messages |

### Directories Created

| Directory | Purpose |
|-----------|---------|
| `/home/exedev` | Home directory |
| `/home/exedev/.config` | User configuration |

### Environment Configuration

| Configuration | Purpose |
|---------------|---------|
| `PATH="$HOME/.local/bin:$PATH"` | User binaries in PATH |
| `XDG_RUNTIME_DIR="/run/user/$(id -u)"` | Runtime directory |
| `git init.defaultBranch main` | Modern git defaults |
| Custom MOTD in `.bashrc` | Login information |

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
| 8000 | TCP | General purpose web server |

### Capabilities

| Setting | Purpose |
|---------|---------|
| `cap_net_raw=+ep` on `/usr/bin/ping` | Allow ping without root |

---

## 10. Systemd Configuration

```ini
[Manager]
LogLevel=info
LogTarget=console
SystemCallArchitectures=native
```

**Default target:** `multi-user.target`

---

## 11. Labels

| Label | Value | Purpose |
|-------|-------|---------|
| `exe.dev/login-user` | `exedev` | Default login user |

---

## 12. Entrypoint

```dockerfile
CMD ["/usr/local/bin/init"]
```

---

## Layer Caching Strategy

```
Layer 1 (Base System)     → Rarely changes, cached long-term
    ↓
Layer 2 (Dev Tools)       → May change for tool updates
    ↓
Systemd Configuration     → Static, rarely modified
    ↓
User Setup               → Static configuration
    ↓
File Copies              → Custom files, may change
```

**Benefits:**
- Base system layer cached across builds
- Dev tools can be updated without rebuilding base
- Faster iteration on customizations

---

## Summary

This minimal, stack-agnostic base image provides:

| Category | Included |
|----------|----------|
| **Init System** | systemd with container optimizations |
| **Remote Access** | SSH server/client |
| **Container Support** | Docker-in-Docker |
| **Build Infrastructure** | C/C++ toolchain, make |
| **Version Control** | Git + GitHub CLI |
| **Monitoring** | btop, atop, iotop, ncdu, lsof |
| **Networking** | mitmproxy, socat, netcat |
| **Media** | imagemagick, ffmpeg |
| **Editors** | vim, neovim |
| **Search** | ripgrep, jq |

**Explicitly NOT included:**
- ❌ Programming language runtimes
- ❌ AI coding assistants
- ❌ Browser automation
- ❌ Web servers (nginx removed)
- ❌ Databases (sqlite3 removed)
- ❌ Fonts
- ❌ Documentation/man pages

This provides a clean foundation for teams to layer their specific development stack.
