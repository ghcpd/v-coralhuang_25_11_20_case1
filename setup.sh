#!/usr/bin/env bash
set -euo pipefail

echo "Installing Node.js dependencies..."

if [ ! -f package.json ]; then
  echo "No package.json found, aborting"
  exit 1
fi

npm install

# Install Playwright browsers if not present
if [ ! -d "node_modules/playwright/.local-browsers" ]; then
  echo "Installing Playwright browsers..."
  npx playwright install --with-deps
else
  echo "Playwright browsers already installed"
fi

echo "Setup completed successfully."