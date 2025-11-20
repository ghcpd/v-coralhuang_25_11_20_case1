# UI Interaction Bug Demo - FIXED

This project demonstrates three common UI interaction bugs and their fixes, verified with automated Playwright tests.

## Bugs Fixed

### 1. Hover Region Too Small
**Problem:** The profile chip (`★ Hover profile`) looked like a single clickable pill, but the hover highlight only appeared when hovering over a tiny star icon area, not the whole pill.

**Fix:** Changed the CSS hover selector from `.nav-icon:hover` (which only targeted the star icon) to `.nav-button:hover` to make the entire button respond to hover interactions.

### 2. Disabled Button State Unclear
**Problem:** The disabled "Run primary action" button was visually almost identical to an enabled button, with pointer cursor and hover effects still active.

**Fix:** Updated disabled button styles:
- Reduced opacity to 0.4 (was 0.9)
- Changed cursor to `not-allowed` (was `pointer`)
- Applied muted background colors
- Removed hover transform and shadow effects
- Made the disabled state clearly distinguishable

### 3. Modal Closing Behavior Broken
**Problem:** 
- Clicking the backdrop did not close the modal
- Background scroll was not restored after closing

**Fix:**
- Fixed backdrop click handler to check `event.target === modalBackdrop` instead of checking for `.modal-content` class
- Added `document.body.style.overflow = ""` to restore scroll when modal closes
- Applied fix to both close button and backdrop click handlers

## Project Structure

```
.
├── index.html              # Fixed HTML with all bugs resolved
├── package.json            # Node dependencies (Playwright)
├── playwright.config.ts    # Playwright configuration
├── tests/
│   └── ui-interactions.spec.ts  # Automated UI tests
├── setup.sh               # Install dependencies (Linux/Mac)
├── run.sh                 # Start HTTP server (Linux/Mac)
├── test.sh                # Run tests (Linux/Mac)
├── setup.bat              # Install dependencies (Windows)
├── run.bat                # Start HTTP server (Windows)
├── test.bat               # Run tests (Windows)
├── Dockerfile             # Docker configuration for reproducible environment
├── .gitignore             # Git ignore file
├── README.md              # This file
└── CHANGELOG.md           # Summary of changes
```

## Requirements

- Node.js (v14 or higher)
- npm
- Python 3 (for HTTP server)
- Bash shell (for Linux/Mac scripts) or Windows Command Prompt (for .bat scripts)

## Setup and Usage

### Local Development

#### On Linux/Mac:

1. **Install dependencies:**
   ```bash
   bash setup.sh
   ```

2. **Start the server:**
   ```bash
   bash run.sh
   ```
   The server will start on http://localhost:3000

3. **Run tests:**
   ```bash
   bash test.sh
   ```

#### On Windows:

1. **Install dependencies:**
   ```cmd
   setup.bat
   ```

2. **Start the server:**
   ```cmd
   run.bat
   ```
   The server will start on http://localhost:3000

3. **Run tests:**
   ```cmd
   test.bat
   ```

The test script will automatically:
- Run setup if dependencies are missing
- Start the server if not already running
- Verify the server returns HTTP 200
- Execute all Playwright tests

### Using Docker

Build and run the entire environment in Docker:

```bash
# Build the Docker image
docker build -t ui-bug-demo .

# Run tests in Docker
docker run --rm ui-bug-demo
```

## Automated Tests

The Playwright test suite verifies all three bug fixes:

1. **Full Pill Hover Region Test** - Verifies hover styles apply to the entire button, not just the icon
2. **Disabled Button State Test** - Checks opacity, cursor style, and that clicks don't fire events
3. **Modal Backdrop Click Test** - Ensures clicking the backdrop closes the modal
4. **Modal Close Button Scroll Restore Test** - Verifies scroll is restored when closing via button
5. **Modal Backdrop Scroll Restore Test** - Verifies scroll is restored when closing via backdrop

### Running Tests in Different Modes

```bash
# Run tests in headless mode (default)
npm test

# Run tests in headed mode (see browser)
npm run test:headed

# Open Playwright UI for debugging
npm run test:ui

# View test report
npm run test:report
```

## Tech Stack

- **Pure HTML/CSS/JavaScript** - No build step required
- **Playwright** - For automated UI testing
- **Python 3** - For static HTTP server
- **Docker** - For reproducible environment

## Verification

To manually verify the fixes:

1. Open http://localhost:3000 in a browser
2. **Hover test:** Move your mouse over the entire "Hover profile" button - it should highlight across the full width
3. **Disabled button test:** The "Run primary action" button should look clearly disabled (low opacity, muted colors) and show "not-allowed" cursor on hover
4. **Modal test:** 
   - Click "Open settings modal"
   - Try scrolling (should be locked)
   - Click the dark backdrop area (modal should close)
   - Verify scrolling is restored
   - Open modal again and close with the "Close" button
   - Verify scrolling is restored

## Notes

- The `input/` folder contains the original buggy version (read-only)
- All fixes are applied in the root `index.html`
- Scripts are idempotent and can be run multiple times safely
- The server runs on port 3000 (configurable in scripts if needed)
