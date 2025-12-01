# Testing TED API Integration

## Quick Test Guide

### Option 1: Test via Backend API Endpoints (Recommended)

#### Prerequisites
1. Make sure backend server is running:
   ```bash
   cd backend-example
   npm run dev
   ```

2. Backend should be running on `http://localhost:3002`

#### Test 1: Test Connection
```bash
curl http://localhost:3002/api/ted/test
```

Or use browser: http://localhost:3002/api/ted/test

**Expected Response:**
```json
{
  "success": true,
  "method": "API",
  "message": "TED API connection successful",
  "dataCount": 1,
  "authentication": "None required (anonymous access)"
}
```

#### Test 2: Search Tenders
```bash
curl -X POST http://localhost:3002/api/ted/notices/search \
  -H "Content-Type: application/json" \
  -d '{
    "scope": "TD",
    "status": "O",
    "country_code": "PL",
    "page_size": 5
  }'
```

**Expected Response:**
```json
{
  "success": true,
  "data": [...notices...],
  "total": 5,
  "page": 1,
  "pageSize": 5
}
```

#### Test 3: Search Contract Awards
```bash
curl -X POST http://localhost:3002/api/ted/awards/search \
  -H "Content-Type: application/json" \
  -d '{
    "country_code": "PL",
    "page_size": 5
  }'
```

### Option 2: Test via TypeScript Script

1. Navigate to backend directory:
   ```bash
   cd backend-example
   ```

2. Run test script:
   ```bash
   npx ts-node scripts/testTEDAPI.ts
   ```

### Option 3: Test via HTTP File (VS Code REST Client)

1. Open `backend-example/scripts/testTEDAPI.http` in VS Code
2. Install REST Client extension if needed
3. Click "Send Request" above each test

### Option 4: Test via Frontend

1. Start frontend:
   ```bash
   npm run dev
   ```

2. Navigate to Discovery page
3. Find TED Data Fetcher component
4. Click "Test Connection" button
5. Click "Fetch Tenders from TED" button

## What to Check

### ✅ Success Indicators

1. **Connection Test**
   - Returns `success: true`
   - Shows method as "API" or "RSS"
   - Returns data count > 0

2. **Search Tenders**
   - Returns array of notices
   - Each notice has: `noticeId`, `title`, `contractingAuthority`, `mainClassification`
   - No errors in console

3. **Search Awards**
   - Returns array of awards
   - Each award has: `noticeId`, `title`, `contractingParty` (winner), `awardValue`
   - No errors in console

4. **Data Quality**
   - CPV codes are valid format (8 digits + dash + 1 digit)
   - Dates are in ISO format (YYYY-MM-DD)
   - Currency codes are valid (EUR, PLN, etc.)
   - Country codes are valid (PL, FR, etc.)

### ❌ Common Issues

1. **Connection Failed**
   - Check if backend server is running
   - Check if TED API is accessible (might be blocked by firewall)
   - Check network connectivity

2. **404 Not Found**
   - Verify endpoint path is correct: `/api/ted/test`
   - Check if routes are properly registered

3. **Rate Limit Error (429)**
   - Wait 1 minute before retrying
   - Reduce request frequency

4. **RSS Fallback Used**
   - This is normal if API is unavailable
   - Check logs for API error details
   - RSS provides less structured data

## Debugging

### Check Backend Logs
Look for:
- `TED API search request` - Shows request being made
- `TED API returned X notices` - Shows successful response
- `Falling back to RSS feed` - Shows fallback being used
- `TED API error` - Shows errors

### Check Network
```bash
# Test if TED API is reachable
curl https://api.ted.europa.eu/v3/notices/search \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"page": 1, "pageSize": 1}'
```

### Check Database
After fetching, check if data is stored:
```sql
-- Check tenders
SELECT COUNT(*) FROM tenders WHERE source = 'TED';

-- Check results
SELECT COUNT(*) FROM tender_results WHERE source = 'TED';

-- View sample data
SELECT id, title, client, budget, currency, cpv_code 
FROM tenders 
WHERE source = 'TED' 
ORDER BY created_at DESC 
LIMIT 5;
```

## Expected Results

### Successful Test Output
```
🧪 Testing TED API Integration
============================================================

📡 Test 1: Testing TED API Connection
------------------------------------------------------------
✅ Connection Test Result:
   Success: true
   Method: API
   Message: TED API connection successful
   Data Count: 1

🔍 Test 2: Searching for Open Tenders
------------------------------------------------------------
✅ Found 5 notices
📋 Sample Notice:
   ID: 12345
   Title: IT Services Tender
   CPV: 72000000-5
   Authority: European Commission
   Budget: 500000 EUR

🏆 Test 3: Searching for Contract Awards
------------------------------------------------------------
✅ Found 5 contract awards
📋 Sample Award:
   ID: award-123
   Title: Contract Award - IT Services
   Winner: Winner Company Ltd
   Awarded Price: 450000 EUR
   Competitors: 5

✅ Testing Complete!
```

## Next Steps After Testing

1. If all tests pass: ✅ Integration is working!
2. If some tests fail: Check error messages and debug
3. If API fails but RSS works: This is acceptable fallback behavior
4. If both fail: Check network/firewall settings
