# Build Instructions for exeuntu Base Image

This guide provides detailed steps to build the exeuntu Docker image.

## Prerequisites

- Docker installed (version 20.10 or higher recommended)
- At least 10GB free disk space
- Fast internet connection (image is ~3.4GB)

## Quick Start

### Option 1: Use Official Image (Recommended)

The easiest way is to use the official pre-built image:

```bash
docker pull ghcr.io/boldsoftware/exeuntu:latest
```

### Option 2: Build from Scratch

If you want to build your own version:

## Step 1: Obtain Required Binaries

The build requires several proprietary binaries. See [MISSING_BINARIES.md](MISSING_BINARIES.md) for details.

### Extract from Official Image:

```bash
# Pull official image
docker pull ghcr.io/boldsoftware/exeuntu:latest

# Extract binaries
docker create --name temp ghcr.io/boldsoftware/exeuntu:latest
docker cp temp:/usr/local/bin/shelley ./shelley
docker cp temp:/headless-shell ./headless-shell
docker rm temp

# Make executable
chmod +x shelley
chmod +x headless-shell/headless-shell
```

## Step 2: Verify Files

Ensure all required files are present:

```bash
ls -la
```

You should see:
- ✅ Dockerfile
- ✅ shelley (binary, ~42MB)
- ✅ headless-shell/ (directory, ~220MB)
- ✅ init-wrapper.sh
- ✅ shelley.socket
- ✅ shelley.service
- ✅ AGENTS.md
- ✅ motd-snippet.bash
- ✅ nginx.conf
- ✅ index.html
- ✅ xterm-ghostty.terminfo

## Step 3: Build the Image

### Full Build:

```bash
docker build -t exeuntu:local .
```

This will take 15-30 minutes depending on your internet speed and CPU.

### Build with BuildKit (Faster):

```bash
DOCKER_BUILDKIT=1 docker build -t exeuntu:local .
```

### Build for Specific Architecture:

```bash
# For amd64
docker build --platform linux/amd64 -t exeuntu:local-amd64 .

# For arm64
docker build --platform linux/arm64 -t exeuntu:local-arm64 .
```

## Step 4: Verify the Build

Check the image:

```bash
docker images exeuntu:local
```

Inspect the image:

```bash
docker inspect exeuntu:local
```

## Step 5: Test the Image

Run a test container:

```bash
docker run -d --privileged --name exeuntu-test exeuntu:local
```

Check if it's running:

```bash
docker ps | grep exeuntu-test
```

Execute a shell:

```bash
docker exec -it exeuntu-test su - exedev
```

Inside the container, test:

```bash
# Check user
whoami  # Should output: exedev

# Check AI tools
which shelley claude codex

# Check development tools
python --version
go version
docker --version

# Check web server
curl localhost:8000
```

## Troubleshooting

### Build Fails at Package Installation

**Issue:** apt-get fails or times out

**Solution:** 
- Check internet connection
- Try a different mirror by modifying the sed command in Dockerfile
- Increase Docker memory if on Windows/Mac (Settings > Resources)

### Build Fails at Binary Copy

**Issue:** `COPY shelley: no such file or directory`

**Solution:**
- Ensure binaries are extracted (Step 1)
- Check file permissions: `ls -la shelley`
- Verify file names match exactly (case-sensitive)

### Container Won't Start

**Issue:** Container exits immediately

**Solution:**
- Check logs: `docker logs exeuntu-test`
- Ensure you're using `--privileged` flag (required for systemd)
- Try without systemd: `docker run -it exeuntu:local /bin/bash`

### Shelley Service Not Running

**Issue:** Shelley service fails to start

**Solution:**
```bash
docker exec -it exeuntu-test systemctl status shelley
docker exec -it exeuntu-test journalctl -u shelley -n 50
```

## Minimal Build (Without Proprietary Binaries)

If you don't have access to the binaries, build a minimal version:

1. Edit Dockerfile and comment out:
   - Lines with `COPY shelley`
   - Lines with `COPY /headless-shell`
   - Lines with `COPY shelley.socket` and `shelley.service`
   - Lines installing Claude and Codex
   - Lines 242-247 (shelley systemd setup)

2. Build:
```bash
docker build -t exeuntu-minimal:local .
```

This gives you Ubuntu 24.04 with all development tools but no AI assistants.

## Advanced: Multi-Stage Build

For a more optimized build, consider creating a multi-stage Dockerfile:

```dockerfile
# Stage 1: Base with packages
FROM ubuntu:24.04 AS base
# ... package installation ...

# Stage 2: Add binaries
FROM base AS final
# ... copy binaries and configs ...
```

## Build Options

### Customize the Image

Edit the Dockerfile to:
- Add more packages to the apt-get install command
- Change the default user name
- Modify exposed ports
- Add your own services

### Tag for Different Purposes

```bash
# Development version
docker build -t exeuntu:dev .

# Production version
docker build -t exeuntu:prod .

# Versioned
docker build -t exeuntu:v1.0.0 .
```

## Next Steps

After building:

1. Push to your registry:
   ```bash
   docker tag exeuntu:local your-registry/exeuntu:latest
   docker push your-registry/exeuntu:latest
   ```

2. Use in development:
   ```bash
   docker run -d --privileged -v $(pwd):/workspace exeuntu:local
   ```

3. Create a docker-compose.yml for easier management

## Resources

- [Official exeuntu repo](https://github.com/boldsoftware/exeuntu)
- [exe.dev documentation](https://exe.dev/docs)
- [Docker best practices](https://docs.docker.com/develop/dev-best-practices/)
