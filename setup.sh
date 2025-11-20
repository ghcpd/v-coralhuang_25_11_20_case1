#!/usr/bin/env bash
set -euo pipefail

# Install dependencies and Playwright browsers (idempotent)
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$ROOT_DIR"

if ! command -v npm >/dev/null 2>&1; then
  echo "npm is required but not found. Please install Node.js." >&2
  exit 1
fi

npm install

# Install Playwright browsers
npx playwright install --with-deps || npx playwright install

echo "Setup complete."
