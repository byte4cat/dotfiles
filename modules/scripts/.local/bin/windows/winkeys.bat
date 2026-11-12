@echo off
rem ==========================================================================
rem Double-click helper for the Windows key scripts (run it in the Windows VM).
rem Keep this file in the same folder as disable_left_winkey*.ps1 and
rem disable_all_winkeys.ps1. It asks for Administrator rights by itself and
rem bypasses the PowerShell execution policy for this run only.
rem The change is permanent (registry); reboot the guest once to apply.
rem Keep this file ASCII-only.
rem ==========================================================================
setlocal

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting Administrator rights...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

echo.
echo   [1] Disable LEFT Win key only
echo   [2] Disable BOTH Win keys
echo   [3] Restore (re-enable Win keys)
echo   [Q] Quit
echo.
choice /c 123Q /n /m "Select: "
set "sel=%errorlevel%"
if "%sel%"=="4" exit /b
if "%sel%"=="3" goto restore
if "%sel%"=="2" goto both
goto left

:left
call :run "disable_left_winkey*.ps1" ""
goto done

:both
call :run "disable_all_winkeys.ps1" ""
goto done

:restore
call :run "disable_all_winkeys.ps1" "-Restore"
goto done

:run
set "found="
for %%F in ("%~dp0%~1") do (
    set "found=%%~fF"
)
if not defined found (
    echo ERROR: %~1 not found next to this .bat file.
    exit /b 1
)
powershell -NoProfile -ExecutionPolicy Bypass -File "%found%" %~2
exit /b %errorlevel%

:done
echo.
echo Reboot the guest to apply the change.
pause
