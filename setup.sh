#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"

echo "Installing Node dependencies..."
npm install

echo "Installing Playwright browsers..."
npx playwright install --with-deps chromium
