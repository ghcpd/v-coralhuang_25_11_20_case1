#!/usr/bin/env bash
set -euo pipefail

echo "Starting static file server on port 3000 using the required command"

# Start only if not already listening on port 3000
if lsof -i:3000 >/dev/null 2>&1; then
  echo "Port 3000 already in use - assuming server is running"
  exit 0
fi

nohup python3 -m http.server 3000 > /tmp/html.log 2>&1 &
sleep 0.6
echo "Server started (background)"
