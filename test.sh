#!/usr/bin/env bash
set -euo pipefail

echo "Running setup (if necessary) and starting server"
bash setup.sh

# Start server if not already running
bash run.sh || true

echo "Waiting for http://localhost:3000 to become available..."
for i in {1..30}; do
  status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 || true)
  if [ "$status" = "200" ]; then
    echo "Server ready"
    break
  fi
  sleep 1
done

if [ "$status" != "200" ]; then
  echo "Server did not start (http code: $status)"
  exit 1
fi

echo "Running Playwright tests"
npx playwright test --reporter=list
