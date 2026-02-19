@echo off
setlocal enabledelayedexpansion

echo.
echo  ####################################################
echo  #                                                  #
echo  #       ::: MY EFFICIENCY SCRIPTS :::              #
echo  #                                                  #
echo  ####################################################
echo.
echo  Available Scripts:
echo  --------------------------------------------------
echo.

:: List all .cmd files in the scripts directory
set "SCRIPT_DIR=%~dp0"

for %%f in ("%SCRIPT_DIR%*.cmd") do (
    set "FILENAME=%%~nxf"
    
    :: Skip help.cmd itself in the listing
    if /i not "!FILENAME!"=="help.cmd" (
        echo   * !FILENAME!
        
        :: Add description for known scripts
        if /i "!FILENAME!"=="create-pr.cmd" (
            echo     - Creates a GitHub Pull Request from current repo
        )
        if /i "!FILENAME!"=="create-branch.cmd" (
            echo     - Creates and pushes a new Git branch from current repo
        )
        echo.
    )
)

echo  --------------------------------------------------
echo.
echo  Usage: Just type the script name from any directory
echo  Example: create-pr.cmd
echo.
echo  Location: %SCRIPT_DIR%
echo.
echo  ####################################################
echo.

pause
endlocal
