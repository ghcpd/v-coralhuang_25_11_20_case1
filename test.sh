#!/bin/bash
set -e

echo "=== Running UI Interaction Tests ==="

# Run setup if needed
if [ ! -d "node_modules" ]; then
    echo "Dependencies not found. Running setup..."
    bash setup.sh
fi

# Check if server is already running
if ! curl -s http://localhost:3000 > /dev/null 2>&1; then
    echo "Server not running. Starting server..."
    
    # Check if Python 3 is installed
    if ! command -v python3 &> /dev/null; then
        echo "Error: Python 3 is not installed. Please install Python 3 first."
        exit 1
    fi
    
    # Kill any existing process on port 3000
    if command -v lsof &> /dev/null; then
        if lsof -Pi :3000 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
            echo "Killing existing process on port 3000..."
            kill $(lsof -t -i:3000) 2>/dev/null || true
            sleep 1
        fi
    fi
    
    # Start the server
    nohup python3 -m http.server 3000 > /tmp/html.log 2>&1 &
    SERVER_PID=$!
    echo "Server started with PID: $SERVER_PID"
    
    # Wait for server to be ready
    echo "Waiting for server to be ready..."
    for i in {1..30}; do
        if curl -s http://localhost:3000 > /dev/null 2>&1; then
            echo "Server is ready!"
            break
        fi
        sleep 1
    done
    
    if ! curl -s http://localhost:3000 > /dev/null 2>&1; then
        echo "Error: Server failed to start"
        exit 1
    fi
else
    echo "Server is already running on port 3000"
fi

# Verify server is responding with HTTP 200
echo "Verifying server response..."
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000)
if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "Server is responding with HTTP 200 OK"
else
    echo "Error: Server returned HTTP $HTTP_STATUS"
    exit 1
fi

# Run Playwright tests
echo "Running Playwright tests..."
npx playwright test

echo "=== All tests completed ==="
