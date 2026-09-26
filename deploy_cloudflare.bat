@echo off
setlocal enabledelayedexpansion

echo ============================================================
echo   ANEX - Cloudflare Deployment (Website)
echo ============================================================
echo.

cd /d "%~dp0"
set "PATH=C:\Program Files\nodejs;C:\Users\kalyan\AppData\Roaming\npm;C:\Windows\System32\WindowsPowerShell\v1.0;C:\Windows\System32;C:\Windows;%PATH%"

echo [1/2] Checking Cloudflare authentication...
call npx wrangler whoami >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo.
    echo ------------------------------------------------------------
    echo   You are not logged in to Cloudflare yet.
    echo   A browser tab will now open for a quick 1-click login.
    echo ------------------------------------------------------------
    echo.
    call npx wrangler login
    if %ERRORLEVEL% neq 0 (
        echo [ERROR] Cloudflare login failed or was cancelled.
        pause
        exit /b %ERRORLEVEL%
    )
)

echo.
echo [2/2] Deploying Website folder to Cloudflare (anex-website)...
call npx wrangler deploy
if %ERRORLEVEL% neq 0 (
    echo.
    echo Worker deploy failed. Trying Pages deployment...
    call npx wrangler pages deploy . --project-name anex-website --commit-dirty=true
)

echo.
echo ============================================================
echo   ANEX Website successfully deployed to Cloudflare!
echo ============================================================
pause
