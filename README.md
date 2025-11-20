# UI Interaction Bug Demo (Fixed)

This project is a fixed version of the static HTML UI in `input/`, with automated
Playwright tests verifying the interaction bugs are resolved.

## Interaction bugs & fixes
1. **Hover region too small**
	- **Problem:** Hover styling applied only to the star icon, not the whole pill.
	- **Fix:** Apply hover/focus styles on `.nav-button` so the entire pill highlights.

2. **Disabled button state unclear**
	- **Problem:** Disabled primary button looked enabled (pointer cursor, hover lift).
	- **Fix:** Distinct disabled styling (muted gradient, opacity, `cursor: not-allowed`, no hover transform/shadow).

3. **Modal closing & scroll restore**
	- **Problem:** Backdrop clicks didn’t close modal; scroll lock not restored.
	- **Fix:** Backdrop/root click closes modal; `body.modal-open` locks scroll and is removed on close; Escape closes too.

## Project structure
```
index.html           # Fixed UI
tests/ui.spec.ts     # Playwright tests
playwright.config.ts # Test config (baseURL http://localhost:3000)
setup.sh             # Install deps + Playwright browsers
run.sh               # Start static server (required command)
test.sh              # Start server, run tests, clean up
Dockerfile           # Reproducible environment (runs test.sh)
Changelog            # Summary of changes
```

## Prerequisites
- Node.js (>=18) with `npm`
- Python 3 (`python3` on PATH)
- `bash` and `curl`
- (Optional) Docker

## Setup
```bash
./setup.sh
```

## Run server (port 3000)
```bash
./run.sh
```
This uses the required command:
```
nohup python3 -m http.server 3000 > /tmp/html.log 2>&1 &
```

## Run tests
```bash
./test.sh
```
`test.sh` starts the server, waits for readiness, runs Playwright tests (headless Chromium), and cleans up.

## Docker
```bash
docker build -t ui-bugs .
docker run --rm ui-bugs
```
The container installs dependencies, Playwright browsers, and runs `./test.sh`.

## Notes
- Do **not** modify `input/`; `index.html` in the repo is the fixed copy.
- Tests validate: full pill hover, disabled button visual/behavior, backdrop closes modal and scroll is restored.
