@echo off
setlocal enabledelayedexpansion

echo === Setting up UI Interaction Bug Demo ===

REM Check if Node.js is installed
where node >nul 2>&1
if errorlevel 1 (
    echo Error: Node.js is not installed. Please install Node.js first.
    exit /b 1
)

REM Check if npm is installed
where npm >nul 2>&1
if errorlevel 1 (
    echo Error: npm is not installed. Please install npm first.
    exit /b 1
)

echo Node version:
node --version
echo npm version:
npm --version

REM Install Node dependencies
echo Installing Node dependencies...
call npm install
if errorlevel 1 (
    echo Error: Failed to install Node dependencies
    exit /b 1
)

REM Install Playwright browsers
echo Installing Playwright browsers...
call npx playwright install chromium
if errorlevel 1 (
    echo Error: Failed to install Playwright browsers
    exit /b 1
)

echo === Setup completed successfully ===
