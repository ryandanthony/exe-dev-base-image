# Missing Binaries

The following binary files are required but not included in this repository as they are proprietary or require separate sourcing:

## 1. shelley (Required)
**Purpose:** Primary AI assistant for exe.dev

**Size:** ~42 MB (based on image analysis)

**Source:** This is a proprietary binary from boldsoftware/exe. You have several options:
- Extract from the official image:
  ```bash
  docker run --rm ghcr.io/boldsoftware/exeuntu:latest cat /usr/local/bin/shelley > shelley
  chmod +x shelley
  ```
- Contact exe.dev/boldsoftware for access
- Build from source if available

**Verification:**
```bash
./shelley -help
```

## 2. headless-shell/ (Required)
**Purpose:** Chrome's headless browser for automation

**Size:** ~220 MB (based on image analysis)

**Source:** Chrome for Testing or Chromium project
- Download from: https://developer.chrome.com/blog/chrome-for-testing/
- Or extract from the official image:
  ```bash
  docker create --name temp ghcr.io/boldsoftware/exeuntu:latest
  docker cp temp:/headless-shell ./headless-shell
  docker rm temp
  ```

**Note:** Should be a directory containing the headless-shell binary and supporting files.

## 3. Extracting All Binaries from Official Image

If you have access to the official image, you can extract all required files:

```bash
# Pull the official image
docker pull ghcr.io/boldsoftware/exeuntu:latest

# Create a temporary container
docker create --name exeuntu-extract ghcr.io/boldsoftware/exeuntu:latest

# Extract shelley
docker cp exeuntu-extract:/usr/local/bin/shelley ./shelley

# Extract headless-shell directory
docker cp exeuntu-extract:/headless-shell ./headless-shell

# Cleanup
docker rm exeuntu-extract
```

## Building Without Binaries

If you want to build a minimal version without the proprietary components:

1. Comment out or remove the following sections from the Dockerfile:
   - COPY and RUN commands related to `shelley`
   - COPY command for `headless-shell`
   - systemd service setup for shelley
   - Claude CLI installation (if desired)
   - Codex installation (if desired)

2. Remove or adjust the EXPOSE directive for port 9999 (shelley)

3. Build with:
   ```bash
   docker build -t exeuntu-minimal:local .
   ```

This will give you a base Ubuntu development environment without the AI assistants.

## Legal Note

Please respect the licensing and terms of service for any proprietary software. The binaries should only be extracted and used in accordance with exe.dev's terms of service.
