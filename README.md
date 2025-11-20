# UI Interaction Bug Demo — fixed

This repository contains a repaired static HTML demo and automated Playwright tests.

Original problem (from input/README.md):

1. Hover region too small
   - The profile chip in the header looked like a single clickable pill, but the hover highlight only appeared when hovering the tiny star icon area.
   - Fix: Make the entire pill respond to :hover via `.nav-button:hover` styles.

2. Disabled button state unclear
   - The primary action button was disabled, but visually looked the same as enabled and still used pointer cursor.
   - Fix: Adjust disabled visual style (lower opacity, no hover effect) and use `cursor: not-allowed` and `pointer-events: none` so it's clearly non-interactive.

3. Modal closing behavior broken
   - Clicking the dark backdrop did not reliably close the modal; and when closed the page scroll lock was not properly restored.
   - Fix: Backdrop clicks now close the modal (only when clicking the backdrop itself), Escape key closes modal, and close restores body scroll by clearing inline overflow.

What is included
- index.html — fixed demo
- tests/ui.spec.js — Playwright tests verifying the three behaviors
- package.json — includes Playwright dependency
- setup.sh — installs node modules & Playwright browsers
- run.sh — starts static server on port 3000 using the required command
- test.sh — runs setup, starts server, waits for readiness and runs Playwright tests
- Dockerfile — reproducible test environment
- CHANGELOG.md — summarizes created files

How to run locally
1. Install Node.js and Python 3.
2. Install dependencies and Playwright browsers: bash setup.sh
3. Start the static server: bash run.sh
4. Run the tests: bash test.sh

Everything is non-interactive and designed to work in CI and Docker.
