# UI Interaction Demo (Fixed)

A minimal static HTML/CSS/JS page demonstrating common interaction pitfalls and their fixes:

- **Hover target alignment** — header pill now responds on the whole button (hover + focus).
- **Disabled state clarity** — primary action visually distinct, non-interactive cursor, optional toggle to enable.
- **Modal behavior** — backdrop/Escape close, scroll locking restored, focus managed, accessible ARIA attributes.
- **Feedback** — toast notification on primary action, live status updates.

## Project Type
Pure static HTML. No build step, no external dependencies.

## Setup
1. Ensure Python is available (`python3` or `python`).
2. Clone or download this folder.

## Run Dev Server
From the project root:

```bash
python3 -m http.server 3000
```

### Windows PowerShell example
```powershell
python -m http.server 3000
```

Then open http://localhost:3000 in your browser.

## One-click Test
A portable smoke test lives in `test.sh` and will start a local static server, then hit the page with `curl`.

```bash
chmod +x test.sh
./test.sh
```

- Uses `$PORT` if set (default 3000).
- Logs written to `/tmp/html_server.log` (override with `LOG_FILE`).
- Exits non-zero on failure and prints log tail.

## Notes
- Accessibility: focus-visible outlines, `aria-*` attributes, `prefers-reduced-motion` support.
- Scroll lock: applied via `body.modal-open`; original body overflow restored on close.
- Tested with Python 3. If using alternatives, adjust commands accordingly.

## Changelog
- Added `index.html` with fixed interactions and enhanced UX.
- Added idempotent `test.sh` smoke test.
- Regenerated this `README.md` with setup and testing instructions.
