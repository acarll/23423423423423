# Quick Test Guide - TED API Integration

## Step 1: Start Backend Server

Open a terminal and run:

```bash
cd backend-example
npm run dev
```

Wait for: `Server running on port 3002` or similar message.

## Step 2: Test Connection (Choose One Method)

### Method A: Browser Test (Easiest)

1. Open browser
2. Go to: `http://localhost:3002/api/ted/test`
3. You should see JSON response like:
   ```json
   {
     "success": true,
     "method": "API",
     "message": "TED API connection successful",
     "dataCount": 1
   }
   ```

### Method B: PowerShell Test

```powershell
# Test connection
Invoke-WebRequest -Uri "http://localhost:3002/api/ted/test" -Method GET | Select-Object -ExpandProperty Content
```

### Method C: curl Test (if available)

```bash
curl http://localhost:3002/api/ted/test
```

## Step 3: Test Search Tenders

### Browser Test:
Open: `http://localhost:3002/api/ted/notices/search`
(Note: This is POST, so use Method B or C below)

### PowerShell Test:
```powershell
$body = @{
    scope = "TD"
    status = "O"
    country_code = "PL"
    page_size = 5
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://localhost:3002/api/ted/notices/search" `
    -Method POST `
    -ContentType "application/json" `
    -Body $body | Select-Object -ExpandProperty Content
```

## Step 4: Test Frontend

1. Start frontend (in another terminal):
   ```bash
   npm run dev
   ```

2. Open browser to frontend URL (usually `http://localhost:5173`)

3. Navigate to Discovery page

4. Find "TED Data Fetcher" component

5. Click "Test Connection" button

6. Click "Fetch Tenders from TED" button

## Expected Results

### ✅ Success Indicators:

1. **Connection Test**
   - Returns `success: true`
   - Method shows "API" or "RSS"
   - Data count > 0

2. **Search Tenders**
   - Returns array of notices
   - Each notice has title, authority, CPV code
   - No errors

3. **Frontend**
   - Shows "Connected" status
   - Displays fetched tenders
   - No error messages

### ❌ If You See Errors:

1. **"Unable to connect"**
   - Backend server not running
   - Solution: Start backend with `npm run dev` in `backend-example` folder

2. **"400 Bad Request"**
   - TED API request format issue
   - Solution: Check logs, RSS fallback should work

3. **"RSS Fallback Used"**
   - This is OK! API might be temporarily unavailable
   - RSS provides data, just less structured

4. **"429 Too Many Requests"**
   - Rate limit exceeded
   - Solution: Wait 1 minute and try again

## Quick Status Check

Run this PowerShell command to check if backend is running:

```powershell
$port = 3002
$connection = Test-NetConnection -ComputerName localhost -Port $port -InformationLevel Quiet
if ($connection) {
    Write-Host "✅ Backend is running on port $port"
} else {
    Write-Host "❌ Backend is NOT running on port $port"
    Write-Host "Start it with: cd backend-example && npm run dev"
}
```

## Test Results Interpretation

### Scenario 1: API Works ✅
```json
{
  "success": true,
  "method": "API",
  "message": "TED API connection successful",
  "dataCount": 1
}
```
**Status**: ✅ Perfect! API integration working.

### Scenario 2: RSS Fallback Works ✅
```json
{
  "success": true,
  "method": "RSS",
  "message": "TED RSS feed connection successful (API unavailable)",
  "dataCount": 1
}
```
**Status**: ✅ Good! Fallback working. API might be temporarily down.

### Scenario 3: Both Failed ❌
```json
{
  "success": false,
  "method": "RSS",
  "message": "Both API and RSS failed: ..."
}
```
**Status**: ❌ Check network connection and backend logs.

## Next Steps After Testing

1. ✅ If tests pass: Integration is working!
2. ⚠️ If RSS works but API doesn't: Check API endpoint format
3. ❌ If both fail: Check network/firewall settings

## Need Help?

Check these files:
- `docs/TED_API_INTEGRATION.md` - Full API documentation
- `docs/TED_DATA_MAPPING.md` - Data structure details
- `backend-example/scripts/testTEDAPI.http` - HTTP test file

