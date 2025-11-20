#!/usr/bin/env bash
set -euo pipefail

cleanup() {
  if [ -f /tmp/server.pid ]; then
    local pid
    pid=$(cat /tmp/server.pid || true)
    if [ -n "${pid:-}" ] && kill -0 "$pid" >/dev/null 2>&1; then
      kill "$pid" >/dev/null 2>&1 || true
    fi
    rm -f /tmp/server.pid
  fi
}

trap cleanup EXIT

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
export PATH="$ROOT_DIR:$PATH"
cd "$ROOT_DIR"

if [ ! -d node_modules ]; then
  echo "node_modules not found. Running setup.sh..."
  ./setup.sh
fi

# Clean any stale server pid
cleanup

# Clear previous log
rm -f /tmp/html.log

# Resolve python3 explicitly to avoid ambiguous wrappers
PYTHON_CMD=$(command -v python3 || true)
# Avoid local wrappers; prefer system python
if [ -n "$PYTHON_CMD" ] && [[ "$PYTHON_CMD" == "$ROOT_DIR"/python3* ]]; then
  if [ -x /usr/bin/python3 ]; then
    PYTHON_CMD=/usr/bin/python3
  fi
fi
if [ -z "$PYTHON_CMD" ]; then
  PYTHON_CMD=$(command -v python || true)
fi
if [ -z "$PYTHON_CMD" ]; then
  echo "python3/python not found" >&2
  exit 1
fi

# Start server
nohup "$PYTHON_CMD" -m http.server 3000 > /tmp/html.log 2>&1 &
SERVER_PID=$!
echo $SERVER_PID > /tmp/server.pid

echo "Waiting for server to be ready..."
for i in {1..30}; do
  if curl -sSf http://localhost:3000 >/dev/null 2>&1; then
    echo "Server is up (PID $SERVER_PID)."
    break
  fi
  sleep 1
done

if ! kill -0 "$SERVER_PID" >/dev/null 2>&1; then
  echo "Server failed to start." >&2
  exit 1
fi

# Run Playwright tests
npx playwright test
TEST_EXIT_CODE=$?

# Cleanup
exit $TEST_EXIT_CODE
