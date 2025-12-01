# TED API Integration Test Script
# Run this after starting the backend server

$baseUrl = "http://localhost:3002"

Write-Host "🧪 TED API Integration Test" -ForegroundColor Cyan
Write-Host "=" * 60
Write-Host ""

# Check if backend is running
Write-Host "📡 Checking if backend is running..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/api/ted/test" -Method GET -TimeoutSec 5 -ErrorAction Stop
    Write-Host "✅ Backend is running!" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "❌ Backend is NOT running!" -ForegroundColor Red
    Write-Host "   Please start it with: cd backend-example; npm run dev" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

# Test 1: Connection Test
Write-Host "Test 1: Testing TED API Connection" -ForegroundColor Cyan
Write-Host "-" * 60
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/api/ted/test" -Method GET
    $result = $response.Content | ConvertFrom-Json
    
    Write-Host "✅ Success: $($result.success)" -ForegroundColor $(if ($result.success) { "Green" } else { "Red" })
    Write-Host "   Method: $($result.method)" -ForegroundColor White
    Write-Host "   Message: $($result.message)" -ForegroundColor White
    if ($result.dataCount) {
        Write-Host "   Data Count: $($result.dataCount)" -ForegroundColor White
    }
    if ($result.error) {
        Write-Host "   Error: $($result.error)" -ForegroundColor Yellow
    }
    Write-Host ""
} catch {
    Write-Host "❌ Connection test failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
}

# Test 2: Search Tenders
Write-Host "Test 2: Searching for Open Tenders (Poland)" -ForegroundColor Cyan
Write-Host "-" * 60
try {
    $body = @{
        scope = "TD"
        status = "O"
        country_code = "PL"
        page_size = 3
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Uri "$baseUrl/api/ted/notices/search" `
        -Method POST `
        -ContentType "application/json" `
        -Body $body
    
    $result = $response.Content | ConvertFrom-Json
    
    if ($result.success) {
        Write-Host "✅ Found $($result.data.Count) tenders" -ForegroundColor Green
        if ($result.data.Count -gt 0) {
            Write-Host ""
            Write-Host "Sample Tender:" -ForegroundColor Yellow
            $sample = $result.data[0]
            Write-Host "   Title: $($sample.title)" -ForegroundColor White
            Write-Host "   ID: $($sample.noticeId)" -ForegroundColor White
            if ($sample.contractingAuthority) {
                Write-Host "   Authority: $($sample.contractingAuthority.name)" -ForegroundColor White
            }
        }
    } else {
        Write-Host "❌ Search failed: $($result.message)" -ForegroundColor Red
    }
    Write-Host ""
} catch {
    Write-Host "❌ Search test failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
}

# Test 3: Search Awards
Write-Host "Test 3: Searching for Contract Awards (Poland)" -ForegroundColor Cyan
Write-Host "-" * 60
try {
    $body = @{
        country_code = "PL"
        page_size = 3
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Uri "$baseUrl/api/ted/awards/search" `
        -Method POST `
        -ContentType "application/json" `
        -Body $body
    
    $result = $response.Content | ConvertFrom-Json
    
    if ($result.success) {
        Write-Host "✅ Found $($result.data.Count) awards" -ForegroundColor Green
        if ($result.data.Count -gt 0) {
            Write-Host ""
            Write-Host "Sample Award:" -ForegroundColor Yellow
            $sample = $result.data[0]
            Write-Host "   Title: $($sample.title)" -ForegroundColor White
            Write-Host "   ID: $($sample.noticeId)" -ForegroundColor White
            if ($sample.contractingParty) {
                Write-Host "   Winner: $($sample.contractingParty.name)" -ForegroundColor White
            }
        }
    } else {
        Write-Host "❌ Search failed: $($result.message)" -ForegroundColor Red
    }
    Write-Host ""
} catch {
    Write-Host "❌ Awards search test failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
}

Write-Host "=" * 60
Write-Host "✅ Testing Complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  - Check backend logs for detailed information" -ForegroundColor White
Write-Host "  - Test frontend: npm run dev (in root directory)" -ForegroundColor White
Write-Host '  - Review QUICK_TEST_GUIDE.md for more tests' -ForegroundColor White

