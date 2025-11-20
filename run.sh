#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"

echo "Starting static server on port 3000..."
nohup python3 -m http.server 3000 > /tmp/html.log 2>&1 &
SERVER_PID=$!
echo "$SERVER_PID" > /tmp/html_server.pid

echo "Waiting for server to become ready..."
READY=false
for attempt in {1..30}; do
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 || true)
  if [[ "$STATUS" == "200" ]]; then
    READY=true
    break
  fi
  sleep 1
done

if [[ "$READY" == "true" ]]; then
  echo "Server is running at http://localhost:3000 (pid $SERVER_PID). Logs: /tmp/html.log"
else
  echo "Server did not become ready in time. Check /tmp/html.log for details." >&2
  kill "$SERVER_PID" || true
  exit 1
fi

wait "$SERVER_PID"
