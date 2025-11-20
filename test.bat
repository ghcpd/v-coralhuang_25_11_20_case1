@echo off
setlocal enabledelayedexpansion

echo === Running UI Interaction Tests ===

REM Run setup if needed
if not exist "node_modules" (
    echo Dependencies not found. Running setup...
    call setup.bat
    if errorlevel 1 (
        echo Error: Setup failed
        exit /b 1
    )
)

REM Check if server is already running
powershell -Command "try { Invoke-WebRequest -Uri http://localhost:3000 -UseBasicParsing -TimeoutSec 1 | Out-Null; exit 0 } catch { exit 1 }" >nul 2>&1
if errorlevel 1 (
    echo Server not running. Starting server...
    
    REM Check if Python is installed
    where python >nul 2>&1
    if errorlevel 1 (
        echo Error: Python is not installed. Please install Python first.
        exit /b 1
    )
    
    REM Kill any existing process on port 3000
    for /f "tokens=5" %%a in ('netstat -aon ^| findstr :3000 ^| findstr LISTENING') do (
        echo Killing existing process %%a on port 3000...
        taskkill /F /PID %%a >nul 2>&1
        timeout /t 1 /nobreak >nul
    )
    
    REM Start the server
    echo Starting server...
    start /B python -m http.server 3000 >nul 2>&1
    
    REM Wait for server to be ready
    echo Waiting for server to be ready...
    set /a count=0
    :check_server
    set /a count+=1
    if !count! gtr 30 (
        echo Error: Server failed to start
        exit /b 1
    )
    
    powershell -Command "try { Invoke-WebRequest -Uri http://localhost:3000 -UseBasicParsing -TimeoutSec 1 | Out-Null; exit 0 } catch { exit 1 }" >nul 2>&1
    if errorlevel 1 (
        timeout /t 1 /nobreak >nul
        goto check_server
    )
    
    echo Server is ready!
) else (
    echo Server is already running on port 3000
)

REM Verify server is responding with HTTP 200
echo Verifying server response...
powershell -Command "$response = Invoke-WebRequest -Uri http://localhost:3000 -UseBasicParsing; if ($response.StatusCode -eq 200) { Write-Host 'Server is responding with HTTP 200 OK'; exit 0 } else { Write-Host 'Error: Server returned HTTP' $response.StatusCode; exit 1 }"
if errorlevel 1 (
    exit /b 1
)

REM Run Playwright tests
echo Running Playwright tests...
call npx playwright test
if errorlevel 1 (
    echo Error: Tests failed
    exit /b 1
)

echo === All tests completed ===
