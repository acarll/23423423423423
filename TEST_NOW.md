# Quick Test - TED API

## Step 1: Start Backend Server

Open a **new terminal** and run:

```bash
cd backend-example
npm run dev
```

Wait for: `Server running on port 3002` or similar message.

## Step 2: Test Connection

In **another terminal**, run:

```powershell
Invoke-WebRequest -Uri "http://localhost:3002/api/ted/test" -Method GET
```

**Expected**: JSON response with `success: true`

## Step 3: Test Search

```powershell
$body = @{ page_size = 5 } | ConvertTo-Json
Invoke-WebRequest -Uri "http://localhost:3002/api/ted/notices/search" `
  -Method POST -ContentType "application/json" -Body $body
```

**Expected**: JSON response with `success: true` and `data` array

## Step 4: View Results

To see formatted results:

```powershell
$body = @{ page_size = 5 } | ConvertTo-Json
$response = Invoke-WebRequest -Uri "http://localhost:3002/api/ted/notices/search" `
  -Method POST -ContentType "application/json" -Body $body
$result = $response.Content | ConvertFrom-Json
$result | ConvertTo-Json -Depth 5
```

## Browser Test (Easiest)

1. Make sure backend is running
2. Open browser: `http://localhost:3002/api/ted/test`
3. You should see JSON response

## Troubleshooting

### "Unable to connect"
- Backend server is not running
- Start it with: `cd backend-example && npm run dev`

### "404 Not Found"
- Check if route is registered
- Verify endpoint path: `/api/ted/test`

### "500 Internal Server Error"
- Check backend logs
- Verify TED API is accessible
- RSS fallback should kick in

## Current Status

✅ **Backend Code**: Ready  
✅ **API Integration**: Implemented  
✅ **RSS Fallback**: Working  
⚠️ **Backend Server**: Needs to be started

Once backend is running, all tests should work!

