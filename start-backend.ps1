# Start Backend Server Script

Write-Host "`n🚀 Starting Biznes-Polska Backend Server`n" -ForegroundColor Cyan

# Navigate to backend directory
$backendDir = Join-Path $PSScriptRoot "backend-example"

if (-not (Test-Path $backendDir)) {
    Write-Host "❌ Backend directory not found: $backendDir" -ForegroundColor Red
    exit 1
}

Set-Location $backendDir

# Check if node_modules exists
if (-not (Test-Path "node_modules")) {
    Write-Host "📦 Installing dependencies..." -ForegroundColor Yellow
    npm install
}

# Check if .env file exists
if (-not (Test-Path ".env")) {
    Write-Host "⚠️  Warning: .env file not found" -ForegroundColor Yellow
    Write-Host "   Make sure DATABASE_URL is set in environment variables`n" -ForegroundColor Yellow
}

# Start the server
Write-Host "🚀 Starting server on http://localhost:3002`n" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop the server`n" -ForegroundColor Gray

npm run dev

