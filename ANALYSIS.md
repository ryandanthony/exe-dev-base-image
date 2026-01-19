# Reverse Engineering Analysis Summary

## Image Details
- **Image:** ghcr.io/boldsoftware/exeuntu:latest
- **Digest:** sha256:6b3e8258e3a2022e779556ddb80bda4db68535677ce2ba7cede08ee5798466fc
- **Created:** 2026-01-16T06:12:36Z
- **Size:** 3,395,982,132 bytes (~3.4 GB)
- **Architecture:** amd64
- **OS:** Linux
- **Layers:** 28 layers

## Base Image
- Ubuntu 24.04 (Noble Numbat)
- Unminimized with full documentation

## Key Observations

### User Configuration
- Renamed from default `ubuntu` to `exedev`
- UID/GID inherited from Ubuntu base
- Added to: sudo, docker groups
- Passwordless sudo enabled
- systemd linger enabled

### Packages Installed (62+ packages)
Major categories:
1. **Development:** git, vim, neovim, build-essential, make
2. **Languages:** python3, golang-go
3. **Containers:** docker.io, docker-buildx, docker-compose-v2
4. **System:** systemd, openssh-server, nginx
5. **Monitoring:** atop, btop, iotop, ncdu
6. **Utilities:** ripgrep, jq, tree, rsync, curl, wget
7. **Media:** imagemagick, ffmpeg
8. **Fonts:** fonts-noto-color-emoji, fonts-symbola
9. **Network:** mitmproxy, socat, netcat-openbsd
10. **GitHub:** gh (GitHub CLI)

### Custom Software
1. **Shelley** (~42 MB)
   - Custom AI assistant
   - systemd socket on port 9999
   - Binary location: /usr/local/bin/shelley

2. **headless-shell** (~220 MB)
   - Chrome headless browser
   - Directory: /headless-shell
   - Used for browser automation

3. **Claude CLI** (~220 MB)
   - Anthropic's Claude assistant
   - Installed in: /home/exedev/.local/bin/claude
   - Symlinked to: /usr/local/bin/claude

4. **Codex** (~64 MB)
   - OpenAI's Codex CLI
   - Location: /usr/local/bin/codex

5. **uv** (~57 MB)
   - Fast Python package installer from Astral
   - Installed in: /usr/local/bin

### systemd Optimizations
**Masked Services (31 services):**
- All getty/console services
- plymouth (boot splash)
- snapd services
- update/upgrade timers
- systemd-resolved
- Various mount services
- Hardware detection services

**Disabled Services (25 services):**
- docker.service (manual start)
- nginx.service (manual start)
- atop, sysstat monitoring
- apport crash reporting
- snapd
- ufw firewall

**Enabled Services:**
- shelley.socket (AI assistant)
- multi-user.target (default)

### Network Configuration
- **Port 8000:** nginx web server
- **Port 9999:** shelley AI assistant socket
- nginx configured with custom config
- Default web page at /var/www/html/index.html

### File Structure
```
/home/exedev/
├── .bashrc (customized)
├── .profile (customized)
├── .hushlogin
├── .local/
│   └── bin/
│       └── claude*
├── .config/
│   └── shelley/
│       └── AGENTS.md
├── .claude/
│   └── CLAUDE.md
└── .codex/
    └── AGENTS.md

/usr/local/bin/
├── shelley*
├── claude -> /home/exedev/.local/bin/claude
├── codex*
├── init*
├── uv*
└── uvx*

/etc/systemd/system/
├── shelley.socket
├── shelley.service
└── system.conf.d/
    └── container-overrides.conf

/headless-shell/
└── headless-shell*
```

### Environment Variables
- `EXEUNTU=1` - Identifies as exeuntu image
- `PATH=/usr/local/bin:/headless-shell:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin`
- `XDG_RUNTIME_DIR=/run/user/$(id -u)` (in .bashrc)

### Labels
- `exe.dev/login-user=exedev`
- `org.opencontainers.image.created=2026-01-16T06:11:01.300Z`
- `org.opencontainers.image.description=EXE.DEV`
- `org.opencontainers.image.revision=fe4664ed77f5b72af5759fcd304e0ebc93f94de8`
- `org.opencontainers.image.source=https://github.com/boldsoftware/exe`
- `org.opencontainers.image.title=exe`
- `org.opencontainers.image.url=https://github.com/boldsoftware/exe`
- `org.opencontainers.image.version=main`

## Build Commands Analysis

The image was built using BuildKit with:
- Shell: `/bin/bash -euxo pipefail -c`
- Multi-stage operations
- Layer optimization (some commands combined)

## Layer Size Breakdown (Largest Layers)
1. **2.72 GB:** Main apt-get install with unminimize
2. **220 MB:** Claude CLI installation
3. **220 MB:** headless-shell copy
4. **64 MB:** Codex installation
5. **57 MB:** uv installation
6. **42 MB:** shelley binary copy

## Security Considerations
1. Running as root for init (systemd)
2. Passwordless sudo for exedev user
3. Docker group membership for exedev
4. No apparent secrets in environment
5. nginx running on non-privileged port (8000)

## Interesting Findings

1. **Unminimize Process:** The image specifically reverses Ubuntu's minimization, adding back man pages and documentation.

2. **Mirror Optimization:** Uses Ubuntu's mirror:// protocol for faster package downloads.

3. **Custom MOTD:** Removes all default MOTD scripts and adds custom one.

4. **Triple AI Setup:** Includes three different AI assistants (Shelley, Claude, Codex).

5. **systemd in Container:** Properly configured systemd as PID 1 with container optimizations.

6. **Terminal Support:** Includes Ghostty terminal emulator support via terminfo.

7. **Font Support:** Includes emoji and symbol fonts for rich terminal output.

## Recommendations for Reproduction

1. **Start with Ubuntu 24.04 base**
2. **Unminimize early** to get full system
3. **Install packages in one layer** to reduce size
4. **Optimize systemd** for containers
5. **Create exedev user** from ubuntu
6. **Add AI tools** if available
7. **Configure services** with systemd
8. **Test thoroughly** with `--privileged` flag

## Extraction Commands Used

```bash
# Pull image
docker pull ghcr.io/boldsoftware/exeuntu:latest

# Inspect
docker inspect ghcr.io/boldsoftware/exeuntu:latest

# History
docker history --no-trunc ghcr.io/boldsoftware/exeuntu:latest

# Extract files (if needed)
docker create --name temp ghcr.io/boldsoftware/exeuntu:latest
docker cp temp:/path/to/file ./file
docker rm temp
```

## Differences from Standard Ubuntu

| Aspect | Standard Ubuntu | exeuntu |
|--------|----------------|---------|
| Size | ~77 MB (minimal) | ~3.4 GB |
| Documentation | Stripped | Full (unminimized) |
| User | ubuntu | exedev |
| Init | minimal | full systemd |
| AI Tools | None | 3 assistants |
| Dev Tools | Minimal | Comprehensive |
| Docker | Not included | Pre-installed |
| Web Server | Not included | nginx |

## Conclusion

The exeuntu image is a comprehensive development environment built on Ubuntu 24.04 with:
- Full documentation and man pages
- Multiple AI coding assistants
- Docker and container tools
- Optimized systemd for fast startup
- Custom web interface
- Rich development tooling

It's designed specifically for exe.dev's rapid VM provisioning system where containers start with ~2 second spin-up time.
