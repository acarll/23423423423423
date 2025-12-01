# 🔍 Biznes-Polska Scraper Status

## ✅ What We Have

### 1. **Scraper Service** (`backend-example/src/services/biznesPolskaService.ts`)
- ✅ Complete scraper implementation
- ✅ Functions for:
  - `scrapeBiznesPolska()` - Open tenders
  - `scrapeBiznesPolskaResults()` - Results/awards
  - `parseResultPage()` - Individual result details
  - `parseTenderPage()` - Individual tender details
  - `login()` - Authentication support
- ✅ Polish text parsing support
- ✅ Rate limiting and error handling

### 2. **API Endpoints** (`backend-example/src/routes/dataSources.ts`)
- ✅ `POST /api/data-sources/biznes-polska/fetch` - Fetch open tenders
- ✅ `POST /api/data-sources/biznes-polska/fetch-results` - Fetch results/awards

### 3. **Scheduled Jobs** (`backend-example/src/jobs/fetchBiznesPolskaJob.ts`)
- ✅ Daily job to fetch tenders
- ✅ Daily job to fetch results

### 4. **Frontend Component** (`components/BiznesPolskaFetcher.tsx`)
- ✅ New component created
- ✅ Added to Discovery.tsx
- ✅ Button to trigger fetching

---

## ⚠️ Current Issue

**The scraper may return 0 items** because:

1. **HTML Selectors Need Updating**
   - The scraper uses generic selectors (`.tender-item`, `.przetarg-item`)
   - The actual website structure may be different
   - Selectors need to be updated based on current HTML structure

2. **Website Structure Changed**
   - biznes-polska.pl may have updated their HTML
   - Need to inspect the actual page structure

3. **Authentication Required**
   - Some pages may require login
   - Credentials need to be set in `.env`:
     ```
     BIZNES_POLSKA_LOGIN=your_login
     BIZNES_POLSKA_PASSWORD=your_password
     ```

---

## 🔧 How to Fix

### Step 1: Inspect the Website

1. Open `https://biznes-polska.pl/przetargi` in browser
2. Open Developer Tools (F12)
3. Inspect the HTML structure
4. Find the actual CSS selectors for:
   - Tender items/list
   - Title
   - Client/authority
   - Budget
   - Deadline
   - CPV code

### Step 2: Update Selectors

Update `backend-example/src/services/biznesPolskaService.ts`:

```typescript
// Line 214 - Update these selectors:
$('.tender-item, .przetarg-item, [class*="tender"], [class*="przetarg"]').each((index, element) => {
  // Replace with actual selectors from the website
});
```

### Step 3: Test

1. Start backend: `cd backend-example && npm run dev`
2. Test endpoint:
   ```powershell
   $body = @{ pageSize = 5 } | ConvertTo-Json
   Invoke-WebRequest -Method POST -Uri "http://localhost:3002/api/data-sources/biznes-polska/fetch" -Body $body -ContentType "application/json"
   ```
3. Check response - should return tenders

---

## 🎯 How to Use

### From Frontend:

1. Go to **Discovery** page
2. Click **"Fetch Biznes-Polska Tenders"** button
3. The scraper will:
   - Fetch tenders from biznes-polska.pl
   - Store them in database
   - Display them in the app

### From Backend API:

```bash
# Fetch open tenders
POST http://localhost:3002/api/data-sources/biznes-polska/fetch
Body: {
  "pageSize": 50,
  "cpv": "48000000",
  "region": "Mazowieckie",
  "q": "komputer"
}

# Fetch results/awards
POST http://localhost:3002/api/data-sources/biznes-polska/fetch-results
Body: {
  "pageSize": 50,
  "cpv": "48000000"
}
```

---

## 📝 Next Steps

1. **Inspect biznes-polska.pl** to get correct selectors
2. **Update selectors** in `biznesPolskaService.ts`
3. **Test the scraper** with real website
4. **Add authentication** if needed (set credentials in `.env`)
5. **Verify data** appears in database and frontend

---

## 🔍 Debugging

Check backend logs:
```bash
cd backend-example
# Logs are in: logs/combined.log and logs/error.log
```

Or check console output when running `npm run dev`

Look for:
- `Scraping biznes-polska.pl: ...`
- `Scraped X tenders from biznes-polska.pl`
- Any error messages about selectors or HTML parsing

---

**Status: Scraper exists but may need selector updates** ⚠️



