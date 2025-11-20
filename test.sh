#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

PORT="${PORT:-3000}"
LOG_FILE="${LOG_FILE:-/tmp/html_server.log}"

cleanup() {
  if [[ -n "${SERVER_PID:-}" ]] && ps -p "$SERVER_PID" > /dev/null 2>&1; then
    kill "$SERVER_PID" || true
  fi
}

start_server() {
  local py_cmd=""
  if command -v python3 >/dev/null 2>&1; then
    py_cmd="python3"
  elif command -v python >/dev/null 2>&1; then
    py_cmd="python"
  else
    echo "Python is required but not found."
    exit 1
  fi

  "$py_cmd" -m http.server "$PORT" > "$LOG_FILE" 2>&1 &
  echo $!
}

SERVER_PID="$(start_server)"
trap cleanup EXIT

# Allow server to start
sleep 2

echo "Checking http://localhost:$PORT ..."
if ! curl -fsS "http://localhost:$PORT" > /dev/null; then
  echo "Health check failed. Log tail:" >&2
  if [[ -f "$LOG_FILE" ]]; then
    tail -n 50 "$LOG_FILE" >&2
  fi
  exit 1
fi

echo "Smoke test passed on http://localhost:$PORT"
