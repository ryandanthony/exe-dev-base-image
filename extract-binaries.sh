#!/bin/bash
# extract-binaries.sh
# Helper script to extract required binaries from official exeuntu image

set -e

IMAGE="ghcr.io/boldsoftware/exeuntu:latest"
CONTAINER_NAME="exeuntu-extract-$$"

echo "========================================="
echo "Exeuntu Binary Extraction Script"
echo "========================================="
echo ""

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "❌ Error: Docker is not installed or not in PATH"
    exit 1
fi

# Pull the image
echo "📦 Pulling official exeuntu image..."
docker pull "$IMAGE"
echo "✅ Image pulled successfully"
echo ""

# Create temporary container
echo "🔨 Creating temporary container..."
docker create --name "$CONTAINER_NAME" "$IMAGE" > /dev/null
echo "✅ Container created: $CONTAINER_NAME"
echo ""

# Extract shelley
echo "📤 Extracting shelley binary..."
if docker cp "$CONTAINER_NAME:/usr/local/bin/shelley" ./shelley 2>/dev/null; then
    chmod +x shelley
    echo "✅ shelley extracted ($(du -h shelley | cut -f1))"
else
    echo "⚠️  Warning: Could not extract shelley"
fi
echo ""

# Extract headless-shell
echo "📤 Extracting headless-shell..."
if docker cp "$CONTAINER_NAME:/headless-shell" ./headless-shell 2>/dev/null; then
    chmod +x headless-shell/headless-shell 2>/dev/null || true
    echo "✅ headless-shell extracted ($(du -sh headless-shell | cut -f1))"
else
    echo "⚠️  Warning: Could not extract headless-shell"
fi
echo ""

# Optional: Extract other interesting files
echo "📤 Extracting additional files (optional)..."

# AGENTS.md (if different from our template)
docker cp "$CONTAINER_NAME:/home/exedev/.config/shelley/AGENTS.md" ./AGENTS.md.official 2>/dev/null && \
    echo "✅ AGENTS.md.official extracted" || \
    echo "⚠️  Could not extract AGENTS.md"

# nginx config (if different)
docker cp "$CONTAINER_NAME:/etc/nginx/sites-available/default" ./nginx.conf.official 2>/dev/null && \
    echo "✅ nginx.conf.official extracted" || \
    echo "⚠️  Could not extract nginx config"

# index.html (if different)
docker cp "$CONTAINER_NAME:/var/www/html/index.html" ./index.html.official 2>/dev/null && \
    echo "✅ index.html.official extracted" || \
    echo "⚠️  Could not extract index.html"

# terminfo
docker cp "$CONTAINER_NAME:/tmp/xterm-ghostty.terminfo" ./xterm-ghostty.terminfo.official 2>/dev/null && \
    echo "✅ xterm-ghostty.terminfo.official extracted" || \
    echo "⚠️  Could not extract terminfo (may not exist)"

echo ""

# Cleanup
echo "🧹 Cleaning up..."
docker rm "$CONTAINER_NAME" > /dev/null
echo "✅ Temporary container removed"
echo ""

# Summary
echo "========================================="
echo "Extraction Summary"
echo "========================================="
ls -lh shelley 2>/dev/null && echo "✅ shelley: Present" || echo "❌ shelley: Missing"
ls -lh headless-shell/headless-shell 2>/dev/null && echo "✅ headless-shell: Present" || echo "❌ headless-shell: Missing"
echo ""

echo "📝 Next steps:"
echo "  1. Verify extracted files:"
echo "     ./shelley -help"
echo "  2. Compare .official files with templates if extracted"
echo "  3. Run: docker build -t exeuntu:local ."
echo ""
echo "✅ Done!"
