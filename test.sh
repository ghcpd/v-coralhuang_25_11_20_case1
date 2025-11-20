#!/usr/bin/env bash
set -euo pipefail

# non-interactive English-only script to install, start server, run tests, and clean up
ROOT_DIR=$(cd "$(dirname "$0")" && pwd)
cd "$ROOT_DIR"

echo "Starting test sequence..."

# Setup
./setup.sh

# Start server
./run.sh

# Run tests
echo "Running Playwright tests..."

# We ensure we attempt to run tests, and then we will kill the server
if npm test; then
  TEST_RESULT=0
else
  TEST_RESULT=1
fi

if [ -f .server_pid ]; then
  PID=$(cat .server_pid)
  if [ "$PID" != "0" ]; then
    echo "Stopping server (pid $PID)"
    kill "$PID" || true
  else
    echo "Server was already running prior to this run; not stopping it."
  fi
  rm -f .server_pid
fi

exit $TEST_RESULT
