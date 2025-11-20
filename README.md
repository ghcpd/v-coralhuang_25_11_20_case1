# UI Interaction Bug Demo - Fixed

This project fixes three UI interaction bugs in the original demo and adds Playwright tests:

Bugs fixed:
1. Hover region too small: the profile pill now highlights when hovering anywhere on the pill.
2. Disabled button state unclear: the primary button has a clear disabled appearance (lower opacity, not-allowed cursor, no hover) and is non-interactive.
3. Modal closing behavior broken: clicking the dark backdrop reliably closes the modal and restores page scroll.

How to run locally

1. Install dependencies and Playwright browsers:

   ./setup.sh

2. Start the static server (non-blocking):

   ./run.sh

3. Run the tests:

   ./test.sh

Docker

Build and run full test in Docker:

   docker build -t ui-fix .
   docker run --rm ui-fix

Files created/modified

- index.html            (fixed UI)
- package.json
- setup.sh
- run.sh
- test.sh
- tests/ui.spec.ts      (Playwright tests)
- Dockerfile
- README.md
- CHANGELOG.md
