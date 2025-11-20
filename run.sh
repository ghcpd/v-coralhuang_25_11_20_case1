#!/usr/bin/env bash
set -euo pipefail

PORT=3000
LOG=/tmp/html.log

# If server already responding on port, do not start a new one
if curl -s -I "http://localhost:$PORT" | head -n 1 | grep -q "200"; then
  echo "Server already running on http://localhost:$PORT"
  echo 0 > .server_pid
  exit 0
fi

# Start the static server using the exact command requested. If nohup not available, fall back.
if command -v nohup >/dev/null 2>&1; then
  echo "Starting server with nohup"
  nohup python3 -m http.server "$PORT" > "$LOG" 2>&1 &
  PID=$!
else
  echo "nohup not found; starting server in background"
  python3 -m http.server "$PORT" > "$LOG" 2>&1 &
  PID=$!
fi

echo "Server started (pid: $PID). Waiting for HTTP 200 on http://localhost:$PORT ..."

# Wait for server to respond
MAX_WAIT=15
for i in $(seq 1 $MAX_WAIT); do
  if curl -s -I "http://localhost:$PORT" | head -n 1 | grep -q "200"; then
      echo "Server is up"
      # if we started a server in this run, PID will be non-empty and valid; if server already existed and we didn't start, PID might be empty
      if [ -n "$PID" ]; then
        echo $PID > .server_pid
      else
        # use 0 to indicate we did not start the server
        echo 0 > .server_pid
      fi
    exit 0
  fi
  sleep 1
done

echo "Server did not respond within $MAX_WAIT seconds"
exit 1
