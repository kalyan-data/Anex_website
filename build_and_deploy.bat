@echo off
setlocal enabledelayedexpansion

echo ============================================================
echo   ANEX - Build Flutter Web and Deploy to Cloudflare
echo ============================================================
echo.

set "PATH=C:\Windows\System32\WindowsPowerShell\v1.0;C:\Windows\System32;C:\Windows;C:\Users\kalyan\AppData\Local\GitHubDesktop\app-3.4.20\resources\app\git\cmd;C:\Program Files\Java\jdk-21\bin;C:\Users\kalyan\flutter\bin;%PATH%"
cd /d "%~dp0\.."

echo [1/3] Building Flutter Web bundle...
call flutter.bat build web --release --base-href "/"
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Flutter web build failed.
    pause
    exit /b %ERRORLEVEL%
)

echo [2/3] Syncing built files to Website folder...
powershell -Command "Copy-Item -Path 'build\web\*' -Destination 'Website' -Recurse -Force"

cd /d "%~dp0"

echo.
echo [3/3] Deploying to Cloudflare...
call deploy_cloudflare.bat
