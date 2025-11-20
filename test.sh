#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"

if [[ ! -d node_modules ]]; then
  echo "Dependencies missing. Running setup..."
  ./setup.sh
fi

echo "Starting static server for tests..."
nohup python3 -m http.server 3000 > /tmp/html.log 2>&1 &
SERVER_PID=$!
trap 'kill $SERVER_PID 2>/dev/null || true' EXIT

echo "Waiting for server readiness..."
READY=false
for attempt in {1..30}; do
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 || true)
  if [[ "$STATUS" == "200" ]]; then
    READY=true
    break
  fi
  sleep 1
done

if [[ "$READY" != "true" ]]; then
  echo "Server failed to become ready; see /tmp/html.log for diagnostics." >&2
  exit 1
fi

echo "Running Playwright tests..."
npx playwright test
