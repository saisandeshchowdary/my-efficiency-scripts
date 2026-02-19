@echo off
setlocal enabledelayedexpansion

:: ---- Load Configuration ----
call "%~dp0load-config.cmd"
if errorlevel 1 (
    echo.
    echo [XX] ERROR: Failed to load configuration. Check .env file.
    echo.
    exit /b 1
)

echo.
echo Select Environment:
echo 1) dev
echo 2) uat
echo 3) staging
echo 4) prod2
echo.
set /p env_choice=Enter your choice (1-4): 

if "%env_choice%"=="1" (
    set environment=dev
) else if "%env_choice%"=="2" (
    set environment=uat
) else if "%env_choice%"=="3" (
    set environment=staging
) else if "%env_choice%"=="4" (
    set environment=prod2
) else (
    echo Invalid choice. Exiting.
    exit /b 1
)

echo.
echo Select Cache:
echo 1) programs
echo 2) diff
echo 3) changes
echo 4) programs-ogs
echo 5) programs-metron
echo.
set /p cache_choice=Enter your choice (1-5): 

if "%cache_choice%"=="1" (
    set cachename=programs
) else if "%cache_choice%"=="2" (
    set cachename=diff
) else if "%cache_choice%"=="3" (
    set cachename=changes
) else if "%cache_choice%"=="4" (
    set cachename=programs-ogs
) else if "%cache_choice%"=="5" (
    set cachename=programs-metron
) else (
    echo Invalid choice. Exiting.
    exit /b 1
)

echo.
echo Fetching cache statistics for %environment% - %cachename%...
echo.

curl -s -H "Authorization: Bearer %EH_BEARER_TOKEN%" "https://%EH_API_HOST%.%environment%.proxy.qfcompass.com/api/v1/admin/cache/statistics" | powershell -NoLogo -NoProfile -Command "$input | ConvertFrom-Json | ForEach-Object { $_.caches | Where-Object { $_.cacheName -eq '%cachename%' } | Format-List }"

endlocal