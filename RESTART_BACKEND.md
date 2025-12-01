# How to Restart Backend Server

## Quick Steps

1. **Go to your backend terminal** (where you ran `npm run dev`)

2. **Stop the server:**
   - Press `Ctrl + C` (or `Ctrl + Break` on some keyboards)
   - Wait for it to stop

3. **Restart the server:**
   ```bash
   npm run dev
   ```

4. **Wait for:**
   ```
   ✅ Environment variables validated
   Server running on port 3002
   ```
   (or similar message)

## Verify It's Running

### Option 1: Browser Test
Open: `http://localhost:3002/api/ted/test`

Should see:
```json
{
  "success": true,
  "method": "API",
  "message": "TED API connection successful"
}
```

### Option 2: PowerShell Test
```powershell
Invoke-WebRequest -Uri "http://localhost:3002/api/ted/test" -Method GET
```

### Option 3: Check Port
```powershell
Test-NetConnection -ComputerName localhost -Port 3002
```

## After Restart - Test Search

Once backend is running, test the search:

```powershell
$body = @{ page_size = 5 } | ConvertTo-Json
Invoke-WebRequest -Uri "http://localhost:3002/api/ted/notices/search" `
  -Method POST -ContentType "application/json" -Body $body
```

**Expected:**
- If API returns 0 results → RSS fallback will provide data
- You should see tenders from RSS feed

## Troubleshooting

### "Port already in use"
- Another process is using port 3002
- Find and stop it, or change port in `server.ts`

### "Cannot find module"
- Run: `npm install` in `backend-example` folder

### "TypeScript errors"
- Check terminal for specific errors
- Most should be fixed now

## What Changed

✅ **RSS Fallback Enhancement:**
- Now triggers when API returns 0 results (not just errors)
- Ensures you always get data

