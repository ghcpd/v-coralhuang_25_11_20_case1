#!/usr/bin/env bash
set -euo pipefail

echo "Installing npm packages and Playwright browsers..."
# Install packages
npm install
# Install Playwright browsers
npx playwright install --with-deps

echo "Setup completed."