@echo off
rem ==========================================================================
rem Double-click helper for slim_windows.ps1 (run it in the Windows VM).
rem Keep this file in the same folder as slim_windows.ps1. It asks for
rem Administrator rights by itself and bypasses the PowerShell execution policy
rem for this run only. Reboot the guest after applying or restoring.
rem Keep this file ASCII-only.
rem ==========================================================================
setlocal

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting Administrator rights...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

if not exist "%~dp0slim_windows.ps1" (
    echo ERROR: slim_windows.ps1 not found next to this .bat file.
    pause
    exit /b 1
)

echo.
echo   [1] Preview only (dry run, changes nothing)
echo   [2] Apply everything
echo   [3] Apply, but keep apps and OneDrive (these two cannot be restored)
echo   [4] Restore the original settings
echo   [5] List the steps
echo   [Q] Quit
echo.
choice /c 12345Q /n /m "Select: "
set "sel=%errorlevel%"
if "%sel%"=="6" exit /b
if "%sel%"=="5" set "args=-List"
if "%sel%"=="4" set "args=-Restore"
if "%sel%"=="3" set "args=-Skip apps,onedrive"
if "%sel%"=="2" set "args="
if "%sel%"=="1" set "args=-DryRun"

if "%sel%"=="2" (
    echo.
    echo This removes preinstalled apps and uninstalls OneDrive. Take a VM
    echo snapshot first. Continue?
    choice /c YN /n /m "[Y/N]: "
    if errorlevel 2 exit /b
)

echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0slim_windows.ps1" %args%
set "rc=%errorlevel%"
echo.
if not "%rc%"=="0" (
    echo FAILED, see the error above. Nothing was reported as done.
    pause
    exit /b %rc%
)
if "%sel%"=="2" echo Reboot the guest to apply the change.
if "%sel%"=="3" echo Reboot the guest to apply the change.
if "%sel%"=="4" echo Reboot the guest to apply the change.
pause
