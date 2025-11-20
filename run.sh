#!/usr/bin/env bash
set -euo pipefail

# Start static server on port 3000. Non-blocking for CI.
nohup python3 -m http.server 3000 > /tmp/html.log 2>&1 &

# Wait for server to respond
for i in {1..20}; do
  if curl -sSf http://localhost:3000 > /dev/null; then
    echo "Server is up"
    exit 0
  fi
  sleep 1
done

echo "Server did not start in time" >&2
exit 1
