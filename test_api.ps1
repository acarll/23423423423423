# Test script for Biznes-Polska scraper API

Write-Host "`n🧪 Testing Biznes-Polska Scraper API`n" -ForegroundColor Cyan

# Test 1: Health Check
Write-Host "1. Testing Health Endpoint..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:3002/api/health" -Method Get
    Write-Host "   ✅ Health check: $($response.status)" -ForegroundColor Green
    Write-Host "   Database: $($response.database)" -ForegroundColor $(if ($response.database -eq 'connected') { 'Green' } else { 'Red' })
} catch {
    Write-Host "   ❌ Health check failed: $_" -ForegroundColor Red
}

# Test 2: Scraper Health Check
Write-Host "`n2. Testing Scraper Health Endpoint..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:3002/api/health/scraper" -Method Get
    Write-Host "   ✅ Scraper health: $($response.status)" -ForegroundColor Green
    Write-Host "   Python scraper: $($response.python_scraper)" -ForegroundColor $(if ($response.python_scraper -eq 'available') { 'Green' } else { 'Yellow' })
    Write-Host "   Database: $($response.database)" -ForegroundColor $(if ($response.database -eq 'connected') { 'Green' } else { 'Red' })
} catch {
    Write-Host "   ❌ Scraper health check failed: $_" -ForegroundColor Red
}

# Test 3: API Request Validation
Write-Host "`n3. Testing API Request Validation..." -ForegroundColor Yellow
try {
    # Test invalid page number
    $body = @{
        page = -1
        pageSize = 50
    } | ConvertTo-Json
    
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:3002/api/data-sources/biznes-polska/fetch" -Method Post -Body $body -ContentType "application/json"
        Write-Host "   ❌ Should have rejected invalid page number" -ForegroundColor Red
    } catch {
        $errorResponse = $_.ErrorDetails.Message | ConvertFrom-Json
        if ($errorResponse.error -like "*Invalid page*") {
            Write-Host "   ✅ Invalid page number correctly rejected" -ForegroundColor Green
        } else {
            Write-Host "   ⚠️  Unexpected error: $($errorResponse.error)" -ForegroundColor Yellow
        }
    }
} catch {
    Write-Host "   ⚠️  Validation test error: $_" -ForegroundColor Yellow
}

# Test 4: Small Scrape Test (if user wants)
Write-Host "`n4. Ready to test actual scraping..." -ForegroundColor Yellow
Write-Host "   To test scraping, run:" -ForegroundColor Cyan
Write-Host "   POST http://localhost:3002/api/data-sources/biznes-polska/fetch" -ForegroundColor White
Write-Host "   Body: { `"page`": 1, `"pageSize`": 2 }" -ForegroundColor White
Write-Host "`n   ⚠️  This will actually scrape data from biznes-polska.pl" -ForegroundColor Yellow

Write-Host "`n✅ API Tests Complete!`n" -ForegroundColor Green

