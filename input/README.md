# UI Interaction Bug Demo

This is a minimal static HTML project designed to test an agent's ability to debug
frontend interaction issues.

The page intentionally contains **three interaction bugs**:

1. **Hover region too small**

   - The profile chip in the header (`Interaction Lab` -> pill with `★ Hover profile`) looks like a single clickable pill.
   - However, the hover highlight only appears when hovering a tiny star icon area, not the whole pill.
   - Expected: the visual interactive area and the hover/active region should match the entire pill.

2. **Disabled button state unclear**

   - The primary action button ("Run primary action") is rendered in a disabled state.
   - Its visual style is almost identical to an enabled button (pointer cursor, hover-like feedback).
   - Expected: disabled state should be clearly distinguishable (e.g. lower contrast, no hover lift, not-allowed cursor).

3. **Modal closing behavior broken**

   - Clicking the "Open settings modal" button opens a modal and locks background scroll.
   - Issues:
     - Clicking on the dark backdrop does **not** close the modal.
     - After closing via the "Close" button, background scroll is **not** properly restored.
   - Expected:
     - Clicking the backdrop should close the modal.
     - Closing the modal should always restore the page scroll behavior.

## Tech Stack

- Pure static HTML/CSS/JS.
- No build step and no external dependencies.

## How to run

You can use any static file server. One simple option with Python:

```bash
python3 -m http.server 3000
