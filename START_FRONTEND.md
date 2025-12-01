# 🚀 Starting the Frontend Server

## Quick Start

1. **Open a terminal in the project root** (`C:\Users\MY\Desktop\sdasdas`)

2. **Run the dev server:**
   ```bash
   npm run dev
   ```

3. **Wait for this message:**
   ```
   VITE v6.x.x  ready in xxx ms

   ➜  Local:   http://localhost:5173/
   ➜  Network: use --host to expose
   ```

4. **Open your browser** and go to: `http://localhost:5173`

---

## Troubleshooting

### Server won't start?

1. **Check if port 5173 is already in use:**
   ```powershell
   netstat -ano | findstr :5173
   ```

2. **Kill any process using port 5173:**
   ```powershell
   # Find the PID from step 1, then:
   taskkill /PID <PID> /F
   ```

3. **Make sure you're in the right directory:**
   ```powershell
   cd C:\Users\MY\Desktop\sdasdas
   ```

4. **Install dependencies if needed:**
   ```bash
   npm install
   ```

### Still not working?

- Check the terminal for error messages
- Make sure Node.js is installed: `node --version`
- Make sure npm is installed: `npm --version`
- Try clearing node_modules and reinstalling:
  ```bash
  rm -rf node_modules
  npm install
  ```

---

## What Should Happen

When you run `npm run dev`, you should see:

```
  VITE v6.2.0  ready in 500 ms

  ➜  Local:   http://localhost:5173/
  ➜  Network: use --host to expose
  ➜  press h + enter to show help
```

Then open `http://localhost:5173` in your browser!

---

## Both Servers Running

Make sure you have **TWO terminals**:

1. **Backend** (port 3002):
   ```bash
   cd backend-example
   npm run dev
   ```

2. **Frontend** (port 5173):
   ```bash
   cd ..  # (back to project root)
   npm run dev
   ```

Both should be running for the app to work fully!



