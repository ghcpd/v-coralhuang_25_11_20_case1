#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

PORT=${PORT:-3000}

# Start simple static server
python3 -m http.server "$PORT" > /tmp/html_server.log 2>&1 &
SERVER_PID=$!

# Ensure the background process is cleaned up
cleanup() {
  if ps -p "$SERVER_PID" > /dev/null 2>&1; then
    kill "$SERVER_PID" || true
  fi
}
trap cleanup EXIT

# Allow server to start
sleep 2

# Health check: return code 0 only if HTTP 200
echo "Checking http://localhost:$PORT ..."
curl -fsS "http://localhost:$PORT" > /dev/null

echo "Smoke test passed on http://localhost:$PORT"
