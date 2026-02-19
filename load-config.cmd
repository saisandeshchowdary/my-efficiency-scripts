@echo off
:: load-config.cmd - Helper script to load .env configuration file
:: This script reads the .env file and sets environment variables
:: Usage: call load-config.cmd

setlocal enabledelayedexpansion

set "CONFIG_FILE=%~dp0.env"

if not exist "%CONFIG_FILE%" (
    echo [XX] ERROR: .env configuration file not found at %CONFIG_FILE%
    echo [!!] Please create a .env file with your secrets
    exit /b 1
)

:: Read and parse .env file
for /f "usebackq tokens=1* delims==" %%a in ("%CONFIG_FILE%") do (
    set "LINE=%%a"
    
    :: Skip empty lines and comments
    if not "!LINE!"=="" (
        if not "!LINE:~0,1!"=="#" (
            set "KEY=!LINE!"
            set "VALUE=%%b"
            
            :: Trim whitespace from key
            set "KEY=!KEY: =!"
            
            :: Set the environment variable
            set "!KEY!=!VALUE!"
        )
    )
)

endlocal & set "GH_TOKEN_AAO=%GH_TOKEN_AAO%" & set "GH_TOKEN_INR=%GH_TOKEN_INR%" & set "EH_BEARER_TOKEN=%EH_BEARER_TOKEN%" & set "EH_API_HOST=%EH_API_HOST%"

exit /b 0
