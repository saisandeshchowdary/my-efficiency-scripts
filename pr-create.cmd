@echo off
setlocal enabledelayedexpansion

:: ---- Load Configuration ----
call "%~dp0load-config.cmd"
if errorlevel 1 (
    echo.
    echo  [XX] ERROR: Failed to load configuration. Check .env file.
    echo.
    goto :end
)

set "GH_TOKEN=%GH_TOKEN_AAO%"

echo.
echo  ####################################################
echo  #                                                  #
echo  #       ::: GITHUB PULL REQUEST CREATOR :::        #
echo  #                                                  #
echo  ####################################################
echo.

:: Get current branch name
for /f "tokens=*" %%b in ('git rev-parse --abbrev-ref HEAD 2^>nul') do set "CURRENT_BRANCH=%%b"

if "%CURRENT_BRANCH%"=="" (
    echo.
    echo  [XX] ERROR: Not a git repository or git is not installed.
    echo.
    goto :end
)

echo Current branch: %CURRENT_BRANCH%
echo.

:: ---- INPUT 1: Source branch ----
set /p "USE_CURRENT=Create PR from current branch '%CURRENT_BRANCH%'? (y/n): "

if /i "%USE_CURRENT%"=="y" (
    set "SOURCE_BRANCH=%CURRENT_BRANCH%"
) else (
    set /p "SOURCE_BRANCH=Enter source branch name: "
)

if "%SOURCE_BRANCH%"=="" (
    echo.
    echo  [XX] ERROR: Source branch cannot be empty.
    echo.
    goto :end
)

:: ---- INPUT 2: Destination branch ----
set /p "USE_DEV=Create PR to 'dev'? (y/n): "

if /i "%USE_DEV%"=="y" (
    set "DEST_BRANCH=dev"
) else (
    set /p "DEST_BRANCH=Enter destination branch name: "
)

if "%DEST_BRANCH%"=="" (
    echo.
    echo  [XX] ERROR: Destination branch cannot be empty.
    echo.
    goto :end
)

:: ---- INPUT 3: PR Title (with option to use recent commit) ----
echo.
echo  [..] Fetching most recent commit message...
for /f "usebackq tokens=*" %%c in (`git log -1 --pretty=format:%%s 2^>nul`) do set "LATEST_COMMIT=%%c"

if defined LATEST_COMMIT (
    echo.
    echo  Recent commit: !LATEST_COMMIT!
    echo.
    set /p "USE_COMMIT=Use recent commit message as PR title? (y/n): "
    if /i "!USE_COMMIT!"=="y" (
        set "PR_TITLE=!LATEST_COMMIT!"
    ) else (
        set /p "PR_TITLE=Enter PR title: "
    )
) else (
    echo.
    echo  [XX] Could not fetch recent commit message.
    set /p "PR_TITLE=Enter PR title: "
)

if "%PR_TITLE%"=="" (
    echo.
    echo  [XX] ERROR: PR title cannot be empty.
    echo.
    goto :end
)

:: ---- Confirm ----
echo.
echo  +------------------------------------------+
echo  :  Source : %SOURCE_BRANCH%
echo  :  Target : %DEST_BRANCH%
echo  :  Title  : %PR_TITLE%
echo  +------------------------------------------+
echo.
set /p "CONFIRM=Proceed with PR creation? (y/n): "

if /i not "%CONFIRM%"=="y" (
    echo.
    echo  [--] PR creation cancelled.
    echo.
    goto :end
)

:: ---- Push source branch to remote first ----
echo.
echo  [..] Pushing '%SOURCE_BRANCH%' to origin...
git push origin %SOURCE_BRANCH% 2>&1

if errorlevel 1 (
    echo  [!!] WARNING: Push failed or branch already up to date. Continuing...
)

:: ---- Check gh CLI auth ----
echo.
echo  [..] Checking GitHub CLI authentication...
gh auth status >nul 2>&1
if errorlevel 1 (
    echo.
    echo  ####################################################
    echo  #                                                  #
    echo  #   [XX] FAILED! GitHub CLI not authenticated.     #
    echo  #                                                  #
    echo  #   Run 'gh auth login' first to authenticate.     #
    echo  #                                                  #
    echo  ####################################################
    goto :end
)
echo  [OK] GitHub CLI authenticated.

:: ---- Create PR using GitHub CLI ----
echo.
echo  [..] Creating Pull Request...

:: Write output to a temp file so we can check both exit code and content
set "TMPFILE=%TEMP%\gh_pr_output_%RANDOM%.txt"

gh pr create --base "%DEST_BRANCH%" --head "%SOURCE_BRANCH%" --title "%PR_TITLE%" --body "" >"%TMPFILE%" 2>&1
set "GH_EXIT=!errorlevel!"

:: Read the output
set "PR_URL="
set "GH_OUTPUT="
for /f "usebackq tokens=*" %%u in ("%TMPFILE%") do (
    set "GH_OUTPUT=%%u"
)
del "%TMPFILE%" >nul 2>&1

:: Check if the output looks like a valid PR URL (contains github.com and /pull/)
set "IS_URL=0"
if defined GH_OUTPUT (
    echo(!GH_OUTPUT!| findstr /C:"github.com" /C:"/pull/" >nul 2>&1
    if not errorlevel 1 set "IS_URL=1"
)

:: Determine success: exit code 0 AND output contains a valid PR URL
if "!GH_EXIT!"=="0" if "!IS_URL!"=="1" (
    set "PR_URL=!GH_OUTPUT!"
    echo.
    echo  ####################################################
    echo  #                                                  #
    echo  #   [OK] SUCCESS! Pull Request Created!            #
    echo  #                                                  #
    echo  #   PR Link:                                       #
    echo  #   !PR_URL!
    echo  #                                                  #
    echo  ####################################################
    goto :end
)

:: If we're here, something went wrong
echo.
echo  ####################################################
echo  #                                                  #
echo  #   [XX] FAILED! Could not create Pull Request.    #
echo  #                                                  #
echo  ####################################################
echo.
echo  Error details:
if defined GH_OUTPUT (
    echo  !GH_OUTPUT!
) else (
    echo  No output from gh CLI. Check your network or auth.
)
echo.
echo  Troubleshooting:
echo    - Run 'gh auth status' to verify authentication
echo    - Ensure branch '%SOURCE_BRANCH%' exists on remote
echo    - Ensure branch '%DEST_BRANCH%' exists on remote
echo    - Check if a PR already exists for this branch

:end
echo.
pause
endlocal
