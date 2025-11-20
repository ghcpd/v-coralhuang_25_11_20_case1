# UI Interaction Bug Demo — Fixed

This repository reconstructs and fixes the three UI interaction bugs from the provided static demo.

Original bugs summary (from input/README.md):

1. Hover region too small
2. Disabled button state unclear
3. Modal backdrop clicks do not close modal and scroll is not restored

What I changed

- Hover pill: fixed CSS so entire .nav-button (the pill) responds to :hover and :focus, not only the small icon.
- Disabled button style: made `.primary-btn:disabled` visually distinct (lower opacity), `cursor: not-allowed`, and `pointer-events: none` so it's not clickable.
- Modal behavior: clicking the backdrop now closes the modal, `aria-hidden` toggles, and `document.body.style.overflow` is restored after close. Also ESC closes modal.

How to run

Pre-requisites: Node.js and Python 3 installed.

Install and run locally:

```bash
./setup.sh
./run.sh
# open http://localhost:3000 to verify
```

Tests

```bash
./test.sh
```

Docker

Build and run in Docker (Linux host recommended):

```bash
docker build -t ui-bug-demo .
docker run --rm ui-bug-demo
```

This will run the setup and Playwright tests in a headless browser inside the container.

Notes

The dev server is started using the command specified in the assignment; `nohup python3 -m http.server 3000 > /tmp/html.log 2>&1 &` is used where `nohup` exists.

The static demo page includes enough vertical content to allow meaningful scroll tests.
