@echo off
setlocal enabledelayedexpansion

echo === Starting HTTP server on port 3000 ===

REM Check if Python is installed
where python >nul 2>&1
if errorlevel 1 (
    echo Error: Python is not installed. Please install Python first.
    exit /b 1
)

REM Check if port 3000 is already in use and kill the process
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :3000 ^| findstr LISTENING') do (
    echo Warning: Port 3000 is already in use. Killing process %%a...
    taskkill /F /PID %%a >nul 2>&1
    timeout /t 1 /nobreak >nul
)

REM Start the server in background
echo Starting server...
start /B python -m http.server 3000 >nul 2>&1

REM Wait for server to be ready
echo Waiting for server to be ready...
set /a count=0
:check_server
set /a count+=1
if !count! gtr 30 (
    echo Error: Server failed to start within 30 seconds
    exit /b 1
)

powershell -Command "try { Invoke-WebRequest -Uri http://localhost:3000 -UseBasicParsing -TimeoutSec 1 | Out-Null; exit 0 } catch { exit 1 }" >nul 2>&1
if errorlevel 1 (
    timeout /t 1 /nobreak >nul
    goto check_server
)

echo Server is ready!
echo Server running at http://localhost:3000
