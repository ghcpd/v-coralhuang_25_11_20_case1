# UI Interaction Bug Demo (Fixed)

This project rebuilds the static UI from `input/` and fixes the three interaction bugs described in `input/README.md`:

1. **Hover region too small** 每 the entire profile pill now responds to hover/focus instead of only the icon.
2. **Disabled button state unclear** 每 the primary action shows a muted visual, uses a not-allowed cursor, and has hover effects disabled.
3. **Modal closing behavior broken** 每 the modal backdrop closes the modal, Escape works, and scroll locking/restoration is reliable.

## Project layout

- `index.html` 每 patched UI with updated CSS/JS.
- `tests/ui.spec.js` 每 Playwright coverage for hover, disabled button state, and modal closing behavior.
- `setup.sh` 每 installs npm dependencies and Playwright browsers.
- `run.sh` 每 serves the site on port 3000 using the required `nohup python3 -m http.server 3000` command and validates readiness.
- `test.sh` 每 idempotent runner that calls setup if needed, starts the server, waits for HTTP 200, then executes the Playwright suite.
- `Dockerfile` 每 reproducible container that executes the full setup + test workflow.
- `Changelog` 每 summary of created files and fixes.

## Prerequisites

- Node.js 18+
- npm
- Python 3
- Bash-compatible shell

## Setup

```bash
./setup.sh
```

This installs Node dependencies and Playwright browsers. Re-running is safe.

## Run locally

```bash
./run.sh
```

The script starts `nohup python3 -m http.server 3000` in the project root, waits until `http://localhost:3000` responds with HTTP 200, then keeps the server attached to the terminal.

## Test

```bash
./test.sh
```

This script ensures dependencies exist, launches the required Python static server, verifies readiness, and executes real Playwright UI tests that cover all three fixed behaviors.

## Docker usage

Build and run the verification workflow in a container:

```bash
docker build -t ui-interaction-demo .
docker run --rm ui-interaction-demo
```

The container executes `./test.sh`, so the build fails if any dependency installation or test run fails.
