# PowerShell script to start Gemini CLI container with current folder as project name
# Place this script in your gemini_container directory
# Run from any project directory

# Get the current directory (will be used as workspace)
$currentPath = Get-Location
$projectName = Split-Path $currentPath -Leaf

# Get the script directory (where docker-compose.yml is located)
$scriptDir = Split-Path $MyInvocation.MyCommand.Path -Parent
$dockerComposePath = Join-Path $scriptDir "docker-compose.yml"
$envPath = Join-Path $scriptDir ".env"

# Set environment variable for current directory to override the volume mapping
$env:WORKSPACE_DIR = $currentPath

Write-Host "🚀 Starting Gemini CLI for project: $projectName" -ForegroundColor Green
Write-Host "📁 Workspace: $currentPath" -ForegroundColor Cyan
Write-Host "🐳 Using compose file: $dockerComposePath" -ForegroundColor Yellow

# Check if docker-compose.yml exists
if (-not (Test-Path $dockerComposePath)) {
    Write-Host "❌ Error: docker-compose.yml not found at $dockerComposePath" -ForegroundColor Red
    exit 1
}

# Load environment variables from .env file if it exists
if (Test-Path $envPath) {
    Get-Content $envPath | ForEach-Object {
        if ($_ -match "^([^#][^=]+)=(.*)$") {
            [System.Environment]::SetEnvironmentVariable($matches[1], $matches[2], "Process")
        }
    }
}

# Check if container is already running
$runningContainers = podman ps --format "{{.Names}}" | Where-Object { $_ -like "*$projectName-gemini-dev*" }

if ($runningContainers) {
    Write-Host "✅ Container already running: $runningContainers" -ForegroundColor Green
    Write-Host "🔗 Connecting to existing container..." -ForegroundColor Cyan
} else {
    Write-Host "🔄 Starting new container..." -ForegroundColor Yellow
    
    # Start the container
    podman compose -p $projectName -f $dockerComposePath up -d
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to start container" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "✅ Container started successfully!" -ForegroundColor Green
}

# Execute bash in the container
Write-Host "🖥️  Opening bash prompt..." -ForegroundColor Cyan
Write-Host "📝 To exit, type 'exit' in the container" -ForegroundColor Gray
Write-Host "🤖 To start Gemini CLI, run: gemini" -ForegroundColor Gray
Write-Host "💡 Gemini CLI features:" -ForegroundColor Gray
Write-Host "   - Interactive chat mode" -ForegroundColor Cyan
Write-Host "   - Code understanding and generation" -ForegroundColor Cyan
Write-Host "   - Project-aware assistance" -ForegroundColor Cyan
Write-Host "   - Built-in tools and web search" -ForegroundColor Cyan
Write-Host "   - Free tier: 60 requests/min, 1000/day" -ForegroundColor Cyan
Write-Host "───────────────────────────────────────────" -ForegroundColor Gray

podman compose -p $projectName -f $dockerComposePath exec gemini-dev bash

# After exiting bash
Write-Host "───────────────────────────────────────────" -ForegroundColor Gray
Write-Host "👋 Exited Gemini container" -ForegroundColor Yellow
Write-Host "💡 Container is still running in background" -ForegroundColor Gray
Write-Host "💡 To stop container, run:" -ForegroundColor Gray
Write-Host "   $scriptDir\stop-gemini.ps1" -ForegroundColor Cyan