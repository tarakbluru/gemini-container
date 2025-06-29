# PowerShell script to stop Gemini CLI container for current project
# Place this script in your gemini_container directory
# Run from any project directory to stop the corresponding Gemini CLI container

# Get the current directory name (project name)
$currentPath = Get-Location
$projectName = Split-Path $currentPath -Leaf

# Get the script directory (where docker-compose.yml is located)
$scriptDir = Split-Path $MyInvocation.MyCommand.Path -Parent
$dockerComposePath = Join-Path $scriptDir "docker-compose.yml"

Write-Host "🛑 Stopping Gemini CLI for project: $projectName" -ForegroundColor Yellow
Write-Host "📁 Project directory: $currentPath" -ForegroundColor Cyan

# Check if docker-compose.yml exists
if (-not (Test-Path $dockerComposePath)) {
    Write-Host "❌ Error: docker-compose.yml not found at $dockerComposePath" -ForegroundColor Red
    exit 1
}

# Check if container is running
$runningContainers = podman ps --format "{{.Names}}" | Where-Object { $_ -like "*$projectName-gemini-dev*" }

if (-not $runningContainers) {
    Write-Host "ℹ️  No Gemini CLI container running for project '$projectName'" -ForegroundColor Gray
    Write-Host "✅ Nothing to stop" -ForegroundColor Green
    exit 0
}

Write-Host "🔍 Found running container: $runningContainers" -ForegroundColor Cyan

# Stop and remove the container
Write-Host "🔄 Stopping container..." -ForegroundColor Yellow
podman compose -p $projectName -f $dockerComposePath down

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Container stopped successfully!" -ForegroundColor Green
    Write-Host "🧹 Container removed (config volume preserved)" -ForegroundColor Gray
} else {
    Write-Host "❌ Failed to stop container" -ForegroundColor Red
    exit 1
}

# Show remaining Gemini CLI containers (if any)
$remainingContainers = podman ps --format "{{.Names}}" | Where-Object { $_ -like "*gemini-dev*" }
if ($remainingContainers) {
    Write-Host "ℹ️  Other Gemini CLI containers still running:" -ForegroundColor Gray
    $remainingContainers | ForEach-Object { Write-Host "   - $_" -ForegroundColor Gray }
} else {
    Write-Host "✨ No Gemini CLI containers running" -ForegroundColor Green
}