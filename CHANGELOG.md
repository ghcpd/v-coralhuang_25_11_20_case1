# Changelog

## 2025-11-20
- Recreated the demo page at `index.html` in the repo root (copied & fixed from `input/index.html`).
- Fixed hover target by switching to `.nav-button:hover/ :focus` instead of `.nav-icon:hover`.
- Improved `.primary-btn:disabled` visuals and behavior (opacity, cursor, pointer-events none).
- Fixed modal backdrop click to close modal and restore scroll (`document.body.style.overflow` properly reset). Added ESC key to close, and `aria-hidden` toggling.
- Added Playwright tests in `tests/ui.spec.js` covering all three issues.
- Added `package.json`, `playwright.config.js`, `setup.sh`, `run.sh`, `test.sh`, and `Dockerfile` to automate setup & CI.
- Added `README.md` with usage & test instructions.
