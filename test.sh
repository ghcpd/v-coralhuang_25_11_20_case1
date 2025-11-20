#!/usr/bin/env bash
set -euo pipefail

# Setup if needed
if [ ! -d node_modules ]; then
  echo "Running setup..."
  ./setup.sh
fi

# Start server
./run.sh

# Run Playwright tests
npx playwright test --reporter=list
