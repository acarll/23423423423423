# How to Search TED Tenders

## Quick Search Methods

### Method 1: Browser Test (Easiest)

**Test Connection:**
```
http://localhost:3002/api/ted/test
```

**Search Tenders:**
Open browser and go to:
```
http://localhost:3002/api/ted/notices/search
```
(Note: This is a POST endpoint, so use Method 2 or 3 for actual search)

### Method 2: PowerShell Search

**Basic Search (5 tenders):**
```powershell
$body = @{ page_size = 5 } | ConvertTo-Json
Invoke-WebRequest -Uri "http://localhost:3002/api/ted/notices/search" `
  -Method POST -ContentType "application/json" -Body $body
```

**Search with Keyword:**
```powershell
$body = @{ 
  q = "software"
  page_size = 10
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://localhost:3002/api/ted/notices/search" `
  -Method POST -ContentType "application/json" -Body $body
```

**Search by Country:**
```powershell
$body = @{ 
  country_code = "PL"
  page_size = 10
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://localhost:3002/api/ted/notices/search" `
  -Method POST -ContentType "application/json" -Body $body
```

**Search by CPV Code:**
```powershell
$body = @{ 
  cpv_code = "72000000-5"
  page_size = 10
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://localhost:3002/api/ted/notices/search" `
  -Method POST -ContentType "application/json" -Body $body
```

**Advanced Search (Multiple Filters):**
```powershell
$body = @{ 
  q = "IT services"
  country_code = "PL"
  scope = "TD"
  status = "O"
  page_size = 20
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://localhost:3002/api/ted/notices/search" `
  -Method POST -ContentType "application/json" -Body $body
```

### Method 3: Using curl (if available)

```bash
curl -X POST http://localhost:3002/api/ted/notices/search \
  -H "Content-Type: application/json" \
  -d '{"page_size": 5}'
```

### Method 4: Frontend Component

Use the `TEDDataFetcher` component in your React app:
- Go to Discovery page
- Find "TED Data Fetcher" component
- Click "Fetch Tenders" or "Test Connection"

## Search Parameters

### Available Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `q` | string | Keyword search | `"software"` |
| `scope` | string | Notice type: `TD` (Tender), `CA` (Contract Award), `CN` (Contract Notice) | `"TD"` |
| `status` | string | Status: `O` (Open), `C` (Closed), `A` (Awarded) | `"O"` |
| `country_code` | string | Two-letter country code | `"PL"`, `"FR"`, `"DE"` |
| `cpv_code` | string | CPV classification code | `"72000000-5"` |
| `date_from` | string | Start date (YYYY-MM-DD) | `"2024-01-01"` |
| `date_to` | string | End date (YYYY-MM-DD) | `"2024-12-31"` |
| `page` | number | Page number (starts at 1) | `1` |
| `page_size` | number | Results per page (max 100) | `50` |
| `include_child_cpvs` | boolean | Include child CPV codes | `true` |

## Search Examples

### Example 1: Find All Open Tenders in Poland
```powershell
$body = @{ 
  country_code = "PL"
  status = "O"
  scope = "TD"
  page_size = 20
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://localhost:3002/api/ted/notices/search" `
  -Method POST -ContentType "application/json" -Body $body
```

### Example 2: Search IT Services in EU
```powershell
$body = @{ 
  q = "IT services"
  cpv_code = "72000000-5"
  page_size = 15
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://localhost:3002/api/ted/notices/search" `
  -Method POST -ContentType "application/json" -Body $body
```

### Example 3: Find Contract Awards
```powershell
$body = @{ 
  scope = "CA"
  status = "A"
  country_code = "PL"
  page_size = 10
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://localhost:3002/api/ted/awards/search" `
  -Method POST -ContentType "application/json" -Body $body
```

### Example 4: Recent Tenders (Last Month)
```powershell
$dateFrom = (Get-Date).AddMonths(-1).ToString("yyyy-MM-dd")
$dateTo = (Get-Date).ToString("yyyy-MM-dd")

$body = @{ 
  date_from = $dateFrom
  date_to = $dateTo
  page_size = 30
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://localhost:3002/api/ted/notices/search" `
  -Method POST -ContentType "application/json" -Body $body
```

## Response Format

```json
{
  "success": true,
  "data": [
    {
      "noticeId": "...",
      "title": "...",
      "description": "...",
      "publicationDate": "...",
      "deadlineDate": "...",
      "contractingAuthority": {
        "name": "..."
      },
      "mainClassification": {
        "cpvCode": "..."
      },
      "estimatedValue": {
        "amount": 100000,
        "currency": "EUR"
      },
      "link": "..."
    }
  ],
  "total": 100,
  "page": 1,
  "pageSize": 20
}
```

## Tips

1. **Start Simple**: Begin with just `page_size` to see if it works
2. **Add Filters Gradually**: Add one filter at a time to see results
3. **Use RSS Fallback**: If API returns 0 results, RSS fallback will provide data
4. **Check Backend Logs**: See what query is being sent and what response is received
5. **Rate Limiting**: Max 700 requests/minute (you're unlikely to hit this)

## Troubleshooting

### No Results?
- Try without filters first
- Check if backend is running
- Check backend logs for errors
- RSS fallback should provide data

### Connection Error?
- Make sure backend is running: `cd backend-example && npm run dev`
- Check port 3002 is available
- Verify URL is correct

### Wrong Results?
- Check parameter names (use exact names from table above)
- Verify date format (YYYY-MM-DD)
- Check country codes (two letters: PL, FR, DE, etc.)

## Quick Test Script

Save this as `test-search.ps1`:

```powershell
# Test TED Search
$body = @{ 
  page_size = 5
} | ConvertTo-Json

Write-Host "Searching TED tenders..." -ForegroundColor Cyan
$response = Invoke-WebRequest -Uri "http://localhost:3002/api/ted/notices/search" `
  -Method POST -ContentType "application/json" -Body $body

$result = $response.Content | ConvertFrom-Json

Write-Host "Found: $($result.data.Count) tenders" -ForegroundColor Green
$result | ConvertTo-Json -Depth 5
```

Run it:
```powershell
.\test-search.ps1
```

