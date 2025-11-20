#!/usr/bin/env bash
set -euo pipefail

echo "Installing Node dev dependencies and Playwright browsers (idempotent)"
if [ ! -f package.json ]; then
  echo "Missing package.json"
  exit 1
fi

if [ -f package-lock.json ]; then
  npm ci --no-audit --progress=false
else
  npm install --no-audit --progress=false
fi

echo "Installing Playwright browsers (this is idempotent)"
# install browsers needed for tests
npx playwright install --with-deps || npx playwright install

echo "Setup complete"
