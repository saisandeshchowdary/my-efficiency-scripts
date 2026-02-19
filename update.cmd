@echo off
setlocal enabledelayedexpansion

echo.
echo  ####################################################
echo  #                                                  #
echo  #            ::: REPO UPDATER :::                  #
echo  #                                                  #
echo  ####################################################
echo.

:: Check we're in a git repo
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo  [XX] ERROR: Not inside a git repository.
    goto :end
)

:: Pull latest
echo  [..] Pulling latest changes from remote...
git pull
if errorlevel 1 (
    echo  [XX] ERROR: git pull failed. Resolve conflicts and try again.
    goto :end
)
echo  [OK] Pull successful.
echo.

:: Stage all changes
echo  [..] Staging all changes...
git add -A
echo  [OK] All changes staged.
echo.

:: Check if there is anything to commit
git diff --cached --quiet
if not errorlevel 1 (
    echo  [--] Nothing to commit. Repository is already up to date.
    goto :end
)

:: Bump patch version in scripts-manifest.json using PowerShell via env var
set "MANIFEST=%~dp0scripts-manifest.json"
echo  [..] Bumping version in scripts-manifest.json...

for /f "delims=" %%v in ('powershell -NoProfile -Command "& { $p=$Env:MANIFEST; $j=Get-Content $p | ConvertFrom-Json; $v=$j.version -split '\.'; $v[2]=[int]$v[2]+1; $j.version=$v -join '.'; [IO.File]::WriteAllText($p, ($j | ConvertTo-Json -Depth 10)); $j.version }"') do (
    set "NEW_VERSION=%%v"
)

if "!NEW_VERSION!"=="" (
    echo  [XX] ERROR: Could not bump version. Check scripts-manifest.json.
    goto :end
)

echo  [OK] Version bumped to v!NEW_VERSION!
echo.

:: Stage the updated manifest
git add scripts-manifest.json

:: Commit
echo  [..] Committing as v!NEW_VERSION!...
git commit -m "v!NEW_VERSION!"
if errorlevel 1 (
    echo  [XX] ERROR: git commit failed.
    goto :end
)
echo  [OK] Committed.
echo.

:: Push
echo  [..] Pushing to origin...
git push
if errorlevel 1 (
    echo  [XX] ERROR: git push failed.
    goto :end
)
echo  [OK] Pushed successfully.
echo.

echo  ####################################################
echo  #                                                  #
echo  #   [OK] DONE - Repo updated to v!NEW_VERSION!
echo  #                                                  #
echo  ####################################################

:end
echo.
pause
endlocal
