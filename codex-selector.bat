@echo off
setlocal

set SCRIPT=%USERPROFILE%\codex-selector.ps1
set REPO_SCRIPT=%USERPROFILE%\codex-custom-api-settings\codex-selector.ps1

if not exist "%SCRIPT%" (
    if exist "%REPO_SCRIPT%" (
        copy /y "%REPO_SCRIPT%" "%SCRIPT%" >nul
    ) else (
        echo codex-selector.ps1 was not found.
        echo Copy it from the repository to %USERPROFILE%, then run this command again.
        exit /b 1
    )
)

if "%~1"=="" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT%" status
) else (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT%" %*
)

endlocal