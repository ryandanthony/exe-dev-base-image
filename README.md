# Reverse Engineered exe.dev Base Image

This repository contains a reverse-engineered Dockerfile for the exe.dev base image (exeuntu).

## Overview

The **exeuntu** image is a development-focused Ubuntu 24.04 container that serves as the default base image for exe.dev VMs. It includes a comprehensive set of development tools, AI assistants, and optimizations for rapid VM startup.

**Source Image:** `ghcr.io/boldsoftware/exeuntu:latest`  
**Image Digest:** `sha256:6b3e8258e3a2022e779556ddb80bda4db68535677ce2ba7cede08ee5798466fc`  
**Created:** 2026-01-16T06:12:36Z  
**Size:** ~3.4 GB

## Key Features

### Core Components
- **Base OS:** Ubuntu 24.04 (unminimized with full man pages and documentation)
- **User:** `exedev` (passwordless sudo access)
- **Init System:** systemd (optimized for containers)
- **Shell:** bash with custom MOTD

### Installed Tools

#### Development Tools
- **Languages:** Python 3, Go
- **Version Control:** Git, GitHub CLI (gh)
- **Editors:** vim, neovim
- **Build Tools:** make, build-essential

#### Container & DevOps
- Docker (docker.io, docker-buildx, docker-compose-v2)
- systemd (optimized for container environment)

#### AI Assistants
- **Shelley:** Custom AI assistant (runs as systemd service on port 9999)
- **Claude CLI:** Anthropic's Claude code assistant
- **Codex:** OpenAI's Codex CLI tool

#### Web & Networking
- nginx (configured with custom index.html)
- curl, wget, socat, netcat-openbsd
- mitmproxy (for debugging HTTP/HTTPS traffic)
- OpenSSH server and client

#### Python Tools
- **uv:** Fast Python package installer from Astral
- pipx for isolated Python apps
- python3-pip

#### System Utilities
- **Monitoring:** atop, btop, iotop, ncdu
- **File Tools:** ripgrep, tree, rsync, jq, sqlite3
- **Process Tools:** lsof, psmisc
- **Media:** imagemagick, ffmpeg

#### Browser Automation
- headless-shell (Chrome's headless browser)

#### Fonts
- fonts-noto-color-emoji
- fonts-symbola

## Required Files

To build this Dockerfile, you need to provide the following files:

### 1. **shelley** (binary)
AI assistant executable. This is a proprietary binary from the exe.dev/boldsoftware project.
- Location: `/usr/local/bin/shelley`
- Runs as systemd service on port 9999

### 2. **headless-shell/** (directory)
Chrome's headless shell for browser automation.
- Get from: Chrome for Testing downloads or Chromium project
- Should contain the headless-shell binary

### 3. **init-wrapper.sh**
Init script that wraps systemd initialization.
```bash
#!/bin/bash
# Wrapper script for container initialization
exec /lib/systemd/systemd
```

### 4. **shelley.socket**
Systemd socket unit for Shelley service.
```ini
[Unit]
Description=Shelley Socket

[Socket]
ListenStream=9999

[Install]
WantedBy=sockets.target
```

### 5. **shelley.service**
Systemd service unit for Shelley.
```ini
[Unit]
Description=Shelley AI Assistant
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/shelley
Restart=always
User=exedev

[Install]
WantedBy=multi-user.target
```

### 6. **AGENTS.md**
Documentation for AI agents/assistants available in the image.

### 7. **motd-snippet.bash**
Custom message of the day shown on login.

### 8. **nginx.conf**
Nginx server configuration for port 8000.
```nginx
server {
    listen 8000;
    server_name _;
    root /var/www/html;
    index index.html;
}
```

### 9. **index.html**
Default web page served by nginx.

### 10. **xterm-ghostty.terminfo**
Terminal info file for Ghostty terminal emulator support.

## Architecture

### User Configuration
- Default user: `exedev` (UID from Ubuntu's default)
- Home directory: `/home/exedev`
- Groups: sudo, docker
- Passwordless sudo enabled

### Network Ports
- **8000/tcp:** nginx web server
- **9999/tcp:** Shelley AI assistant

### systemd Optimizations
The image disables many unnecessary systemd services to optimize for container environments:
- No getty/console services
- No snapd
- No ModemManager
- No unnecessary timers (updates, MOTD, etc.)
- Docker and containerd disabled by default (can be enabled when needed)

### Environment Variables
- `EXEUNTU=1` - Identifies this as an exeuntu image
- `PATH` includes `/headless-shell` and `/usr/local/bin`

## Building the Image

1. Obtain all required files (listed above)
2. Place them in the same directory as the Dockerfile
3. Build:
```bash
docker build -t exeuntu:local .
```

## Usage

Run the container with systemd:
```bash
docker run -d --privileged --name exeuntu exeuntu:local
```

Execute commands as exedev user:
```bash
docker exec -it exeuntu su - exedev
```

## Notes

- This is a reverse-engineered Dockerfile based on image inspection
- Some binaries (shelley, headless-shell) are not publicly available and need to be sourced separately
- The image is designed to work with exe.dev's infrastructure
- systemd requires `--privileged` or specific capabilities to run properly in containers

## Related Projects

- [exe.dev](https://exe.dev) - Fast VM provisioning platform
- [boldsoftware/exeuntu](https://github.com/boldsoftware/exeuntu) - Official repository
- Image available at: `ghcr.io/boldsoftware/exeuntu`

## License

See LICENSE file. Note that this is a reverse-engineered version for educational and development purposes.
