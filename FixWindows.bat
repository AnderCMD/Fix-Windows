@echo off
chcp 65001 > nul
color 0b
cls

:: Title and description of the script
powershell -command "Write-Host '               ████████╗ ██████╗  ██████╗ ██╗      ███████╗'"
powershell -command "Write-Host '               ╚══██╔══╝██╔═══██╗██╔═══██╗██║      ██╔════╝'"
powershell -command "Write-Host '                  ██║   ██║   ██║██║   ██║██║      ███████╗'"
powershell -command "Write-Host '                  ██║   ██║   ██║██║   ██║██║      ╚════██║'"
powershell -command "Write-Host '                  ██║   ╚██████╔╝╚██████╔╝███████╗ ███████║'"
powershell -command "Write-Host '                  ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝ ╚══════╝'"
powershell -command "Write-Host '   ════════════════════════════════════════════════════════════════════'"
powershell -command "Write-Host '                   [+] Windows System Repair Tool v1.0 [+]'"
powershell -command "Write-Host '   ════════════════════════════════════════════════════════════════════'"

echo.

:: Confirmation to start
echo [*] Starting repair process...
set /p confirm="[?] Press Enter to continue..."

:: Check if the script is running as administrator
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo [X] Error: Please run as administrator
    pause
    exit /b
)

:: Run system repair commands
echo [*] Running SFC...
sfc /scannow
echo [*] Running DISM CheckHealth...
DISM /Online /Cleanup-Image /CheckHealth
echo [*] Running DISM ScanHealth...
DISM /Online /Cleanup-Image /ScanHealth
echo [*] Running DISM RestoreHealth...
DISM /Online /Cleanup-Image /RestoreHealth

echo.
echo [+] Process completed
pause
