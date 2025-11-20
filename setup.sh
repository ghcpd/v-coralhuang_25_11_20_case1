#!/bin/bash
set -e

echo "=== Setting up UI Interaction Bug Demo ==="

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Error: Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "Error: npm is not installed. Please install npm first."
    exit 1
fi

echo "Node version: $(node --version)"
echo "npm version: $(npm --version)"

# Install Node dependencies
echo "Installing Node dependencies..."
npm install

# Install Playwright browsers
echo "Installing Playwright browsers..."
npx playwright install chromium

echo "=== Setup completed successfully ==="
