@echo off
setlocal enabledelayedexpansion

echo.
echo  ####################################################
echo  #                                                  #
echo  #       ::: GITHUB ISSUE VIEWER :::                #
echo  #                                                  #
echo  ####################################################
echo.

:: ---- Load Configuration ----
call "%~dp0load-config.cmd"
if errorlevel 1 (
    echo.
    echo  [XX] ERROR: Failed to load configuration. Check .env file.
    echo.
    goto :end
)

set "GH_TOKEN=%GH_TOKEN_INR%"

:: ---- INPUT: GitHub Issue URL ----
set /p "ISSUE_URL=Paste GitHub issue URL: "

if "%ISSUE_URL%"=="" (
    echo.
    echo  [XX] ERROR: URL cannot be empty.
    echo.
    goto :end
)

:: ---- Extract owner/repo and issue number from URL ----
for /f "tokens=*" %%r in ('powershell -NoLogo -NoProfile -Command "$u='%ISSUE_URL%'; if ($u -match 'github\.com/([^/]+/[^/]+)/issues/(\d+)') { Write-Output $Matches[1] } else { Write-Output 'INVALID' }"') do set "REPO=%%r"

if "%REPO%"=="INVALID" (
    echo.
    echo  [XX] ERROR: Invalid GitHub issue URL.
    echo  [!!] Expected format: https://github.com/owner/repo/issues/123
    echo.
    goto :end
)

for /f "tokens=*" %%n in ('powershell -NoLogo -NoProfile -Command "$u='%ISSUE_URL%'; if ($u -match '/issues/(\d+)') { Write-Output $Matches[1] }"') do set "ISSUE_NUM=%%n"

echo.
echo  [OK] Repository : %REPO%
echo  [OK] Issue      : #%ISSUE_NUM%
echo.

:: ---- INPUT 2: What to display ----
echo.
echo  What would you like to view?
echo  1) Description only
echo  2) Conversation history (comments only)
echo  3) Everything (full issue + all comments)
echo.
set /p "DISPLAY_OPTION=Enter your choice (1-3): "

if "%DISPLAY_OPTION%"=="" set "DISPLAY_OPTION=3"

if not "%DISPLAY_OPTION%"=="1" if not "%DISPLAY_OPTION%"=="2" if not "%DISPLAY_OPTION%"=="3" (
    echo.
    echo  [XX] ERROR: Invalid option. Choose 1, 2, or 3.
    echo.
    goto :end
)

echo.
echo  [..] Fetching issue data...
echo.

:: ---- Fetch issue to temp file ----
curl -s -H "Authorization: token %GH_TOKEN%" "https://api.github.com/repos/%REPO%/issues/%ISSUE_NUM%" -o "%TEMP%\gh_issue.json"

:: ---- Fetch comments if needed (option 2 or 3) ----
if "%DISPLAY_OPTION%"=="2" (
    curl -s -H "Authorization: token %GH_TOKEN%" "https://api.github.com/repos/%REPO%/issues/%ISSUE_NUM%/comments" -o "%TEMP%\gh_comments.json"
) else if "%DISPLAY_OPTION%"=="3" (
    curl -s -H "Authorization: token %GH_TOKEN%" "https://api.github.com/repos/%REPO%/issues/%ISSUE_NUM%/comments" -o "%TEMP%\gh_comments.json"
)

:: ---- Display issue using companion PowerShell script ----
powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0issue-read-display.ps1" -JsonPath "%TEMP%\gh_issue.json" -CommentsPath "%TEMP%\gh_comments.json" -DisplayOption %DISPLAY_OPTION%

:: Clean up temp files
del "%TEMP%\gh_issue.json" >nul 2>&1
del "%TEMP%\gh_comments.json" >nul 2>&1

echo.

:end
endlocal
