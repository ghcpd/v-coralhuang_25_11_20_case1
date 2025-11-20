#!/bin/bash
set -e

echo "=== Starting HTTP server on port 3000 ==="

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is not installed. Please install Python 3 first."
    exit 1
fi

# Check if port 3000 is already in use
if lsof -Pi :3000 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
    echo "Warning: Port 3000 is already in use. Killing existing process..."
    kill $(lsof -t -i:3000) 2>/dev/null || true
    sleep 1
fi

# Start the server in background
echo "Starting server..."
nohup python3 -m http.server 3000 > /tmp/html.log 2>&1 &
SERVER_PID=$!

echo "Server started with PID: $SERVER_PID"

# Wait for server to be ready
echo "Waiting for server to be ready..."
for i in {1..30}; do
    if curl -s http://localhost:3000 > /dev/null 2>&1; then
        echo "Server is ready!"
        exit 0
    fi
    sleep 1
done

echo "Error: Server failed to start within 30 seconds"
exit 1
