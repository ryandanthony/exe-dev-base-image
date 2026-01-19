# Quick Reference Guide

## 🚀 Quick Start (5 minutes)

### Windows
```powershell
# Extract binaries from official image
.\extract-binaries.ps1

# Build
docker build -t exeuntu:local .

# Run
docker run -d --privileged --name exeuntu exeuntu:local

# Access
docker exec -it exeuntu su - exedev
```

### Linux/Mac
```bash
# Extract binaries from official image
chmod +x extract-binaries.sh
./extract-binaries.sh

# Build
docker build -t exeuntu:local .

# Run
docker run -d --privileged --name exeuntu exeuntu:local

# Access
docker exec -it exeuntu su - exedev
```

## 📂 Essential Files

| File | Purpose | Required |
|------|---------|----------|
| Dockerfile | Main build definition | ✅ Yes |
| shelley | AI assistant binary | ⚠️ Extract |
| headless-shell/ | Chrome headless | ⚠️ Extract |
| init-wrapper.sh | Init script | ✅ Yes |
| shelley.socket | Service config | ✅ Yes |
| shelley.service | Service config | ✅ Yes |
| nginx.conf | Web server config | ✅ Yes |

## 🔧 Common Commands

### Build Variants
```bash
# Full build
docker build -t exeuntu:local .

# With BuildKit (faster)
DOCKER_BUILDKIT=1 docker build -t exeuntu:local .

# Specific platform
docker build --platform linux/amd64 -t exeuntu:local .
```

### Run Options
```bash
# Basic
docker run -d --privileged --name exeuntu exeuntu:local

# With volume mount
docker run -d --privileged -v $(pwd):/workspace --name exeuntu exeuntu:local

# With port mapping
docker run -d --privileged -p 8000:8000 -p 9999:9999 --name exeuntu exeuntu:local
```

### Maintenance
```bash
# View logs
docker logs exeuntu

# Execute command
docker exec -it exeuntu su - exedev -c "python --version"

# Check services
docker exec -it exeuntu systemctl status shelley

# Stop/Start
docker stop exeuntu
docker start exeuntu

# Remove
docker rm -f exeuntu
```

## 🧰 Inside the Container

### Check AI Tools
```bash
# Test Shelley
shelley -help

# Test Claude
claude --version

# Test Codex
codex --version
```

### Development Tools
```bash
# Check Python
python --version
uv --version

# Check Go
go version

# Check Docker
docker --version

# Check web server
curl localhost:8000
```

### System Info
```bash
# User info
whoami  # Should be: exedev
groups  # Should include: exedev sudo docker

# Services
systemctl status shelley
systemctl list-units

# Environment
env | grep EXEUNTU  # Should show: EXEUNTU=1
```

## 📊 Image Stats

- **Base:** Ubuntu 24.04
- **Size:** ~3.4 GB
- **Layers:** 28
- **Packages:** 62+
- **AI Tools:** 3 (Shelley, Claude, Codex)
- **Ports:** 8000 (nginx), 9999 (shelley)
- **User:** exedev (sudo, docker)

## 🐛 Troubleshooting

### Build Fails
```bash
# Check Docker is running
docker info

# Check disk space
df -h

# Clean Docker cache
docker system prune -a
```

### Container Won't Start
```bash
# Check logs
docker logs exeuntu

# Try without systemd
docker run -it exeuntu:local /bin/bash

# Verify --privileged flag
docker inspect exeuntu | grep Privileged
```

### Missing Binaries
```bash
# Re-run extraction
./extract-binaries.sh

# Verify files exist
ls -lh shelley
ls -lh headless-shell/
```

### Service Issues
```bash
# Inside container
systemctl status shelley
journalctl -u shelley -n 50
systemctl restart shelley
```

## 📚 Documentation Files

| File | Description |
|------|-------------|
| [README.md](README.md) | Overview and features |
| [BUILD.md](BUILD.md) | Detailed build guide |
| [ANALYSIS.md](ANALYSIS.md) | Technical analysis |
| [MISSING_BINARIES.md](MISSING_BINARIES.md) | Binary sourcing |
| [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) | Complete summary |

## 🔗 Useful Links

- **Official Image:** https://ghcr.io/boldsoftware/exeuntu
- **Source Repo:** https://github.com/boldsoftware/exeuntu
- **exe.dev:** https://exe.dev
- **Docker Docs:** https://docs.docker.com

## 💡 Tips

1. **Always use --privileged** for systemd to work
2. **Extract binaries first** before building
3. **Check docker-history.txt** for raw layer info
4. **Use BuildKit** for faster builds
5. **Mount volumes** for persistent storage

## ⚡ One-Liners

```bash
# Build and run in one go
docker build -t exeuntu:local . && docker run -d --privileged --name exeuntu exeuntu:local

# Quick test
docker run --rm -it --privileged exeuntu:local su - exedev -c "python --version && go version"

# Extract, build, run
./extract-binaries.sh && docker build -t exeuntu:local . && docker run -d --privileged --name exeuntu exeuntu:local

# Clean rebuild
docker rm -f exeuntu 2>/dev/null; docker rmi exeuntu:local 2>/dev/null; docker build -t exeuntu:local . && docker run -d --privileged --name exeuntu exeuntu:local
```

## 🎯 Common Use Cases

### Development Environment
```bash
docker run -d --privileged \
  -v $(pwd):/workspace \
  -p 8000:8000 \
  --name dev-env \
  exeuntu:local
```

### Testing AI Tools
```bash
docker run --rm -it --privileged exeuntu:local \
  su - exedev -c "shelley -help && claude --version"
```

### Web Server
```bash
docker run -d --privileged \
  -p 8000:8000 \
  -v $(pwd)/www:/var/www/html \
  --name web-server \
  exeuntu:local
```

## 📝 Quick Facts

- ✅ Complete reverse engineering
- ✅ All layers documented  
- ✅ Ready to build
- ⚠️ Requires binary extraction
- 🐧 Ubuntu 24.04 based
- 🤖 3 AI assistants included
- 🐳 Docker pre-installed
- 🌐 nginx on port 8000
