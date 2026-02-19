@echo off
setlocal enabledelayedexpansion

echo.
echo  ####################################################
echo  #                                                  #
echo  #          ::: GIT BRANCH CREATOR :::              #
echo  #                                                  #
echo  ####################################################
echo.

:: Check we're in a git repo
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo.
    echo  [XX] ERROR: Not a git repository or git is not installed.
    echo.
    goto :end
)

:: ---- INPUT 1: Source branch ----
set /p "USE_DEV=Create branch from 'dev'? (y/n): "

if /i "%USE_DEV%"=="y" (
    set "SOURCE_BRANCH=dev"
) else (
    set /p "SOURCE_BRANCH=Enter source branch name: "
)

if "%SOURCE_BRANCH%"=="" (
    echo.
    echo  [XX] ERROR: Source branch cannot be empty.
    echo.
    goto :end
)

:: Verify source branch exists on remote
echo.
echo  [..] Fetching latest from origin...
git fetch origin >nul 2>&1

git rev-parse --verify "origin/%SOURCE_BRANCH%" >nul 2>&1
if errorlevel 1 (
    git rev-parse --verify "%SOURCE_BRANCH%" >nul 2>&1
    if errorlevel 1 (
        echo.
        echo  [XX] ERROR: Branch '%SOURCE_BRANCH%' does not exist locally or on remote.
        echo.
        goto :end
    )
)

echo  [OK] Source branch '%SOURCE_BRANCH%' verified.
echo.

:: ---- INPUT 2: New branch name (with validation loop) ----
:ask_branch_name
set "NEW_BRANCH="
set /p "NEW_BRANCH=Enter new branch name: "

if "%NEW_BRANCH%"=="" (
    echo.
    echo  [XX] ERROR: Branch name cannot be empty.
    echo.
    goto :ask_branch_name
)

:: --- Validation ---
set "VALID=1"
set "ERR_MSG="

:: Check for spaces
set "SPACE_CHECK=!NEW_BRANCH: =!"
if not "!SPACE_CHECK!"=="!NEW_BRANCH!" (
    set "VALID=0"
    set "ERR_MSG=Branch name must not contain spaces."
    goto :show_error
)

:: Check for invalid characters: ~ ^ : ? * [ \ @{
for %%c in ("~" "^" ":" "?" "*" "[" "\\" "@{") do (
    echo(!NEW_BRANCH!| findstr /C:%%c >nul 2>&1
    if not errorlevel 1 (
        set "VALID=0"
        set "ERR_MSG=Branch name contains invalid character: %%~c"
        goto :show_error
    )
)

:: Check for double dots ..
echo(%NEW_BRANCH%| findstr /C:".." >nul 2>&1
if not errorlevel 1 (
    set "VALID=0"
    set "ERR_MSG=Branch name must not contain '..'."
    goto :show_error
)

:: Check it doesn't start with - or .
set "FIRST_CHAR=%NEW_BRANCH:~0,1%"
if "%FIRST_CHAR%"=="-" (
    set "VALID=0"
    set "ERR_MSG=Branch name must not start with '-'."
    goto :show_error
)
if "%FIRST_CHAR%"=="." (
    set "VALID=0"
    set "ERR_MSG=Branch name must not start with '.'."
    goto :show_error
)

:: Check it doesn't end with . or /
set "LAST_CHAR=%NEW_BRANCH:~-1%"
if "%LAST_CHAR%"=="." (
    set "VALID=0"
    set "ERR_MSG=Branch name must not end with '.'."
    goto :show_error
)
if "%LAST_CHAR%"=="/" (
    set "VALID=0"
    set "ERR_MSG=Branch name must not end with '/'."
    goto :show_error
)

:: Check it doesn't end with .lock
set "LOCK_CHECK=%NEW_BRANCH:~-5%"
if /i "%LOCK_CHECK%"==".lock" (
    set "VALID=0"
    set "ERR_MSG=Branch name must not end with '.lock'."
    goto :show_error
)

:: Check branch doesn't already exist
git rev-parse --verify "%NEW_BRANCH%" >nul 2>&1
if not errorlevel 1 (
    set "VALID=0"
    set "ERR_MSG=Branch '%NEW_BRANCH%' already exists locally."
    goto :show_error
)

git rev-parse --verify "origin/%NEW_BRANCH%" >nul 2>&1
if not errorlevel 1 (
    set "VALID=0"
    set "ERR_MSG=Branch '%NEW_BRANCH%' already exists on remote."
    goto :show_error
)

goto :branch_valid

:show_error
echo.
echo  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo    [!!] WARNING: %ERR_MSG%
echo    Allowed: lowercase/uppercase letters, numbers, - _ / .
echo    Example: feature/my-new-feature, bugfix/fix-login-issue
echo  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
goto :ask_branch_name

:branch_valid
:: ---- Confirm ----
echo.
echo  +------------------------------------------+
echo  :  Source branch : %SOURCE_BRANCH%
echo  :  New branch    : %NEW_BRANCH%
echo  +------------------------------------------+
echo.
set /p "CONFIRM=Proceed? (y/n): "

if /i not "%CONFIRM%"=="y" (
    echo.
    echo  [--] Branch creation cancelled.
    echo.
    goto :end
)

:: ---- Create the branch from source ----
echo.
echo  [..] Creating branch '%NEW_BRANCH%' from 'origin/%SOURCE_BRANCH%'...

git checkout -b "%NEW_BRANCH%" "origin/%SOURCE_BRANCH%" 2>&1
if errorlevel 1 (
    echo.
    echo  [..] Trying from local '%SOURCE_BRANCH%'...
    git checkout -b "%NEW_BRANCH%" "%SOURCE_BRANCH%" 2>&1
    if errorlevel 1 (
        echo.
        echo  [XX] ERROR: Failed to create branch.
        echo.
        goto :end
    )
)

echo  [OK] Branch created locally.

:: ---- Push new branch to remote (no code changes, just the branch) ----
echo.
echo  [..] Pushing new branch '%NEW_BRANCH%' to origin...
git push -u origin "%NEW_BRANCH%" 2>&1

if errorlevel 1 (
    echo.
    echo  [XX] ERROR: Failed to push branch to remote.
    echo.
    goto :end
)

echo.
echo  ####################################################
echo  #                                                  #
echo  #   [OK] SUCCESS!                                  #
echo  #                                                  #
echo  #   Branch '%NEW_BRANCH%' created and pushed!
echo  #   You are now on branch '%NEW_BRANCH%'.
echo  #                                                  #
echo  ####################################################

:end
echo.
pause
endlocal
