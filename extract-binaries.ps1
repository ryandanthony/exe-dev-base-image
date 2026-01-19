# Extract Binaries Script (PowerShell)
# Helper script to extract required binaries from official exeuntu image

$IMAGE = "ghcr.io/boldsoftware/exeuntu:latest"
$CONTAINER_NAME = "exeuntu-extract-$(Get-Random)"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Exeuntu Binary Extraction Script" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is available
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Error: Docker is not installed or not in PATH" -ForegroundColor Red
    exit 1
}

# Pull the image
Write-Host "📦 Pulling official exeuntu image..." -ForegroundColor Yellow
docker pull $IMAGE
Write-Host "✅ Image pulled successfully" -ForegroundColor Green
Write-Host ""

# Create temporary container
Write-Host "🔨 Creating temporary container..." -ForegroundColor Yellow
docker create --name $CONTAINER_NAME $IMAGE | Out-Null
Write-Host "✅ Container created: $CONTAINER_NAME" -ForegroundColor Green
Write-Host ""

# Extract shelley
Write-Host "📤 Extracting shelley binary..." -ForegroundColor Yellow
try {
    docker cp "${CONTAINER_NAME}:/usr/local/bin/shelley" ./shelley 2>$null
    $size = (Get-Item ./shelley).Length / 1MB
    Write-Host "✅ shelley extracted ($([math]::Round($size, 2)) MB)" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Warning: Could not extract shelley" -ForegroundColor Yellow
}
Write-Host ""

# Extract headless-shell
Write-Host "📤 Extracting headless-shell..." -ForegroundColor Yellow
try {
    docker cp "${CONTAINER_NAME}:/headless-shell" ./headless-shell 2>$null
    $size = (Get-ChildItem -Path ./headless-shell -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB
    Write-Host "✅ headless-shell extracted ($([math]::Round($size, 2)) MB)" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Warning: Could not extract headless-shell" -ForegroundColor Yellow
}
Write-Host ""

# Optional: Extract other interesting files
Write-Host "📤 Extracting additional files (optional)..." -ForegroundColor Yellow

try {
    docker cp "${CONTAINER_NAME}:/home/exedev/.config/shelley/AGENTS.md" ./AGENTS.md.official 2>$null
    Write-Host "✅ AGENTS.md.official extracted" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Could not extract AGENTS.md" -ForegroundColor Yellow
}

try {
    docker cp "${CONTAINER_NAME}:/etc/nginx/sites-available/default" ./nginx.conf.official 2>$null
    Write-Host "✅ nginx.conf.official extracted" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Could not extract nginx config" -ForegroundColor Yellow
}

try {
    docker cp "${CONTAINER_NAME}:/var/www/html/index.html" ./index.html.official 2>$null
    Write-Host "✅ index.html.official extracted" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Could not extract index.html" -ForegroundColor Yellow
}

Write-Host ""

# Cleanup
Write-Host "🧹 Cleaning up..." -ForegroundColor Yellow
docker rm $CONTAINER_NAME | Out-Null
Write-Host "✅ Temporary container removed" -ForegroundColor Green
Write-Host ""

# Summary
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Extraction Summary" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

if (Test-Path ./shelley) {
    Write-Host "✅ shelley: Present" -ForegroundColor Green
} else {
    Write-Host "❌ shelley: Missing" -ForegroundColor Red
}

if (Test-Path ./headless-shell/headless-shell) {
    Write-Host "✅ headless-shell: Present" -ForegroundColor Green
} else {
    Write-Host "❌ headless-shell: Missing" -ForegroundColor Red
}

Write-Host ""
Write-Host "📝 Next steps:" -ForegroundColor Cyan
Write-Host "  1. Verify extracted files"
Write-Host "  2. Compare .official files with templates if extracted"
Write-Host "  3. Run: docker build -t exeuntu:local ."
Write-Host ""
Write-Host "✅ Done!" -ForegroundColor Green
