@echo off
:: ============================================================================
::  Fix-Windows - Windows repair and maintenance toolkit
::  https://github.com/AnderCMD/Fix-Windows  -  MIT License
::
::  Pure batch: works with or without PowerShell. PowerShell is only used as an
::  optional helper (elevation, restore points, disk health) with fallbacks.
::
::  Usage:  FixWindows.bat [/yes] [action]
::  Run  FixWindows.bat /help  for the list of actions.
:: ============================================================================
setlocal EnableExtensions EnableDelayedExpansion

set "VERSION=2.0.0"
set "SELF=%~f0"
set "ROOT=%~dp0"
title Fix-Windows v%VERSION%
cd /d "%ROOT%" 2>nul

:: ---- Environment detection -------------------------------------------------
set "ISADMIN="
fltmc >nul 2>&1 && set "ISADMIN=1"
if not defined ISADMIN net session >nul 2>&1 && set "ISADMIN=1"

set "HAS_PS="
where powershell >nul 2>&1 && set "HAS_PS=1"

:: ---- Log file (falls back to %TEMP% when the folder is read-only) ----------
set "LOGFILE=%ROOT%logs\FixWindows.log"
if not exist "%ROOT%logs" md "%ROOT%logs" >nul 2>&1
(>>"%LOGFILE%" echo.) 2>nul || set "LOGFILE=%TEMP%\FixWindows.log"

:: ---- ANSI colors (Windows 10 1607+); silently disabled elsewhere ----------
set "ESC=" & set "C_R=" & set "C_G=" & set "C_Y=" & set "C_B=" & set "C_C=" & set "C_0="
ver | findstr /r /c:"Version 10\.0\." >nul 2>&1 && (
    for /f "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%b"
)
if defined ESC (
    set "C_R=%ESC%[91m" & set "C_G=%ESC%[92m" & set "C_Y=%ESC%[93m"
    set "C_B=%ESC%[94m" & set "C_C=%ESC%[96m" & set "C_0=%ESC%[0m"
)

:: ---- Argument parsing ------------------------------------------------------
set "YES=" & set "ACTION=" & set "RC=0"
for %%A in (%*) do (
    if /i "%%~A"=="/yes" (set "YES=1") else if not defined ACTION set "ACTION=%%~A"
)

call :log "Session started v%VERSION% admin=%ISADMIN% powershell=%HAS_PS% action=%ACTION%"

if defined ACTION goto :cli
goto :menu

:: ============================================================================
::  Non-interactive mode
:: ============================================================================
:cli
set "A=%ACTION%"
if /i "%A%"=="/help"    goto :usage
if /i "%A%"=="-h"       goto :usage
if /i "%A%"=="/?"       goto :usage
if /i "%A%"=="/version" (echo Fix-Windows v%VERSION% & exit /b 0)
if /i "%A%"=="/quick"   call :a_quick   & goto :cli_end
if /i "%A%"=="/full"    call :a_full    & goto :cli_end
if /i "%A%"=="/sfc"     call :a_sfc     & goto :cli_end
if /i "%A%"=="/dism"    call :a_dism    & goto :cli_end
if /i "%A%"=="/chkdsk"  call :a_chkdsk  & goto :cli_end
if /i "%A%"=="/temp"    call :a_temp    & goto :cli_end
if /i "%A%"=="/wu"      call :a_wu      & goto :cli_end
if /i "%A%"=="/net"     call :a_net     & goto :cli_end
if /i "%A%"=="/cleanup" call :a_cleanup & goto :cli_end
if /i "%A%"=="/icons"   call :a_icons   & goto :cli_end
if /i "%A%"=="/restore" call :a_restore & goto :cli_end
if /i "%A%"=="/info"    call :a_info    & goto :cli_end
if /i "%A%"=="/disk"    call :a_disk    & goto :cli_end
echo Unknown action: %A%
echo.
goto :usage

:cli_end
set "RC=%errorlevel%"
call :log "Session finished rc=%RC%"
endlocal & exit /b %RC%

:usage
echo.
echo Fix-Windows v%VERSION% - Windows repair and maintenance toolkit
echo.
echo Usage: FixWindows.bat [/yes] [action]
echo.
echo   no action   Open the interactive menu
echo   /quick      SFC scan + DISM CheckHealth
echo   /full       DISM Check, Scan, Restore + SFC
echo   /sfc        System File Checker only
echo   /dism       DISM RestoreHealth only
echo   /chkdsk     Online disk scan of the system drive
echo   /temp       Delete temporary files
echo   /wu         Reset the Windows Update download cache
echo   /net        Flush DNS and reset the network stack
echo   /cleanup    Component store cleanup
echo   /icons      Rebuild the icon and thumbnail cache
echo   /restore    Create a system restore point
echo   /disk       Show disk health
echo   /info       Show system information
echo   /version    Print the version
echo.
echo   /yes        Skip confirmation prompts
echo.
echo Most actions need an elevated prompt. Run as administrator.
exit /b 0

:: ============================================================================
::  Interactive menu
:: ============================================================================
:menu
cls
call :banner
echo   %C_C%Repair%C_0%
echo     1  Quick repair            SFC + DISM CheckHealth
echo     2  Full repair             DISM Check/Scan/Restore + SFC
echo     3  System File Checker     sfc /scannow
echo     4  DISM RestoreHealth      repair the Windows image
echo     5  Check disk              online chkdsk scan
echo.
echo   %C_C%Cleanup%C_0%
echo     6  Delete temporary files
echo     7  Reset Windows Update cache
echo     8  Component store cleanup
echo     9  Disk Cleanup tool       cleanmgr
echo.
echo   %C_C%Tools%C_0%
echo     A  Reset network           flush DNS, Winsock, TCP/IP
echo     B  Rebuild icon cache
echo     C  Create restore point
echo     D  Disk health
echo     E  System information
echo     F  Export SFC details to Desktop
echo     L  Open log file
echo     R  Restart as administrator
echo     Q  Quit
echo.
set "SEL="
set /p "SEL=  Select an option: "
if not defined SEL goto :menu
set "SEL=%SEL:"=%"

if /i "%SEL%"=="1" call :a_quick   & goto :after
if /i "%SEL%"=="2" call :a_full    & goto :after
if /i "%SEL%"=="3" call :a_sfc     & goto :after
if /i "%SEL%"=="4" call :a_dism    & goto :after
if /i "%SEL%"=="5" call :a_chkdsk  & goto :after
if /i "%SEL%"=="6" call :a_temp    & goto :after
if /i "%SEL%"=="7" call :a_wu      & goto :after
if /i "%SEL%"=="8" call :a_cleanup & goto :after
if /i "%SEL%"=="9" call :a_cleanmgr & goto :after
if /i "%SEL%"=="A" call :a_net     & goto :after
if /i "%SEL%"=="B" call :a_icons   & goto :after
if /i "%SEL%"=="C" call :a_restore & goto :after
if /i "%SEL%"=="D" call :a_disk    & goto :after
if /i "%SEL%"=="E" call :a_info    & goto :after
if /i "%SEL%"=="F" call :a_sfcdetails & goto :after
if /i "%SEL%"=="L" call :a_log     & goto :menu
if /i "%SEL%"=="R" call :a_elevate & goto :after
if /i "%SEL%"=="Q" goto :quit
if /i "%SEL%"=="0" goto :quit
call :warn "Invalid option: %SEL%"
timeout /t 2 >nul 2>&1
goto :menu

:after
echo.
pause
goto :menu

:quit
call :log "Session finished"
endlocal
exit /b 0

:: ============================================================================
::  Actions
:: ============================================================================
:a_quick
call :req_admin || exit /b 1
call :head "Quick repair"
call :exec sfc /scannow
call :exec DISM /Online /Cleanup-Image /CheckHealth
call :ok "Quick repair finished"
exit /b 0

:a_full
call :req_admin || exit /b 1
call :head "Full repair"
call :confirm "This can take 15-60 minutes. Continue?" || exit /b 0
call :exec DISM /Online /Cleanup-Image /CheckHealth
call :exec DISM /Online /Cleanup-Image /ScanHealth
call :exec DISM /Online /Cleanup-Image /RestoreHealth
call :exec sfc /scannow
call :ok "Full repair finished. Restart Windows if repairs were made."
exit /b 0

:a_sfc
call :req_admin || exit /b 1
call :head "System File Checker"
call :exec sfc /scannow
call :ok "SFC finished"
exit /b 0

:a_dism
call :req_admin || exit /b 1
call :head "DISM RestoreHealth"
call :exec DISM /Online /Cleanup-Image /RestoreHealth
call :ok "DISM finished"
exit /b 0

:a_chkdsk
call :req_admin || exit /b 1
call :head "Check disk on %SystemDrive%"
call :exec chkdsk %SystemDrive% /scan
call :confirm "Schedule a full repair scan chkdsk /f at next restart?" || exit /b 0
echo Y| chkdsk %SystemDrive% /f >nul 2>&1
call :log "chkdsk /f scheduled"
call :ok "Disk check scheduled for the next restart"
exit /b 0

:a_temp
call :head "Delete temporary files"
call :confirm "Delete temporary files? Files in use are skipped." || exit /b 0
call :cleandir "%TEMP%"
call :cleandir "%LOCALAPPDATA%\Temp"
call :cleandir "%LOCALAPPDATA%\Microsoft\Windows\INetCache"
call :cleandir "%LOCALAPPDATA%\CrashDumps"
call :cleandir "%LOCALAPPDATA%\Microsoft\Windows\WER"
del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
if defined ISADMIN (
    call :cleandir "%SystemRoot%\Temp"
    call :cleandir "%ProgramData%\Microsoft\Windows\WER\ReportQueue"
    call :cleandir "%SystemRoot%\Minidump"
    del /f /q "%SystemRoot%\MEMORY.DMP" >nul 2>&1
    call :confirm "Also empty the Recycle Bin on %SystemDrive%?" && (
        rd /s /q "%SystemDrive%\$Recycle.Bin" >nul 2>&1
        call :log "Recycle bin emptied"
    )
) else (
    call :warn "Not elevated: system temp folders were skipped."
)
call :ok "Temporary files deleted"
exit /b 0

:a_wu
call :req_admin || exit /b 1
call :head "Reset Windows Update cache"
call :confirm "Stop update services and clear the download cache?" || exit /b 0
call :exec net stop wuauserv
call :exec net stop bits
call :cleandir "%SystemRoot%\SoftwareDistribution\Download"
call :exec net start bits
call :exec net start wuauserv
call :ok "Windows Update cache reset"
exit /b 0

:a_net
call :req_admin || exit /b 1
call :head "Reset network stack"
call :confirm "Flush DNS and reset Winsock and TCP/IP? A restart is needed." || exit /b 0
call :exec ipconfig /flushdns
call :exec netsh winsock reset
call :exec netsh int ip reset
call :ok "Network reset. Restart Windows to finish."
exit /b 0

:a_cleanup
call :req_admin || exit /b 1
call :head "Component store cleanup"
call :exec DISM /Online /Cleanup-Image /StartComponentCleanup
call :ok "Component store cleaned"
exit /b 0

:a_cleanmgr
call :head "Disk Cleanup"
where cleanmgr >nul 2>&1 || (call :err "cleanmgr is not available on this system" & exit /b 1)
start "" cleanmgr /d %SystemDrive%
call :ok "Disk Cleanup opened"
exit /b 0

:a_icons
call :head "Rebuild icon cache"
call :confirm "Explorer will restart briefly. Continue?" || exit /b 0
taskkill /f /im explorer.exe >nul 2>&1
del /f /q "%LOCALAPPDATA%\IconCache.db" >nul 2>&1
del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\iconcache_*.db" >nul 2>&1
del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
start "" explorer.exe
call :log "Icon cache rebuilt"
call :ok "Icon cache rebuilt"
exit /b 0

:a_restore
call :req_admin || exit /b 1
call :head "Create restore point"
if defined HAS_PS (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Checkpoint-Computer -Description 'Fix-Windows' -RestorePointType MODIFY_SETTINGS -ErrorAction Stop; exit 0 } catch { Write-Host $_.Exception.Message; exit 1 }"
    if not errorlevel 1 (call :ok "Restore point created" & exit /b 0)
)
where wmic >nul 2>&1 && (
    wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Fix-Windows", 100, 7 >nul 2>&1
    if not errorlevel 1 (call :ok "Restore point created" & exit /b 0)
)
call :err "Could not create a restore point. Is System Protection enabled?"
exit /b 1

:a_disk
call :head "Disk health"
if defined HAS_PS (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-PhysicalDisk | Select-Object FriendlyName,MediaType,HealthStatus,OperationalStatus,@{n='SizeGB';e={[math]::Round($_.Size/1GB)}} | Format-Table -AutoSize" 2>nul
    if not errorlevel 1 exit /b 0
)
where wmic >nul 2>&1 && (wmic diskdrive get model,status,size & exit /b 0)
call :err "No tool available to read disk health"
exit /b 1

:a_info
call :head "System information"
ver
echo Computer      : %COMPUTERNAME%
echo User          : %USERNAME%
echo Architecture  : %PROCESSOR_ARCHITECTURE%
echo Processors    : %NUMBER_OF_PROCESSORS%
set "_free="
for /f "tokens=*" %%L in ('dir %SystemDrive%\ 2^>nul ^| findstr /r "[0-9]"') do set "_free=%%L"
echo Drive %SystemDrive%      : !_free!
echo Administrator : %ISADMIN%
echo PowerShell    : %HAS_PS%
echo Log file      : %LOGFILE%
echo.
call :confirm "Show detailed systeminfo? It takes a few seconds." && systeminfo
exit /b 0

:a_sfcdetails & goto :after
if /i "%SEL%"=="L" call :a_log     & goto :menu
if /i "%SEL%"=="R" call :a_elevate & goto :after
if /i "%SEL%"=="Q" goto :quit
if /i "%SEL%"=="0" goto :quit
call :warn "Invalid option: %SEL%"
timeout /t 2 >nul 2>&1
goto :menu

:after
echo.
pause
goto :menu

:quit
call :log "Session finished"
endlocal
exit /b 0

:: ============================================================================
::  Actions
:: ============================================================================
:a_quick
call :req_admin || exit /b 1
call :head "Quick repair"
call :exec sfc /scannow
call :exec DISM /Online /Cleanup-Image /CheckHealth
call :ok "Quick repair finished"
exit /b 0

:a_full
call :req_admin || exit /b 1
call :head "Full repair"
call :confirm "This can take 15-60 minutes. Continue?" || exit /b 0
call :exec DISM /Online /Cleanup-Image /CheckHealth
call :exec DISM /Online /Cleanup-Image /ScanHealth
call :exec DISM /Online /Cleanup-Image /RestoreHealth
call :exec sfc /scannow
call :ok "Full repair finished. Restart Windows if repairs were made."
exit /b 0

:a_sfc
call :req_admin || exit /b 1
call :head "System File Checker"
call :exec sfc /scannow
call :ok "SFC finished"
exit /b 0

:a_dism
call :req_admin || exit /b 1
call :head "DISM RestoreHealth"
call :exec DISM /Online /Cleanup-Image /RestoreHealth
call :ok "DISM finished"
exit /b 0

:a_chkdsk
call :req_admin || exit /b 1
call :head "Check disk on %SystemDrive%"
call :exec chkdsk %SystemDrive% /scan
call :confirm "Schedule a full repair scan chkdsk /f at next restart?" || exit /b 0
echo Y| chkdsk %SystemDrive% /f >nul 2>&1
call :log "chkdsk /f scheduled"
call :ok "Disk check scheduled for the next restart"
exit /b 0

:a_temp
call :head "Delete temporary files"
call :confirm "Delete temporary files? Files in use are skipped." || exit /b 0
call :cleandir "%TEMP%"
call :cleandir "%LOCALAPPDATA%\Temp"
call :cleandir "%LOCALAPPDATA%\Microsoft\Windows\INetCache"
call :cleandir "%LOCALAPPDATA%\CrashDumps"
call :cleandir "%LOCALAPPDATA%\Microsoft\Windows\WER"
del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
if defined ISADMIN (
    call :cleandir "%SystemRoot%\Temp"
    call :cleandir "%ProgramData%\Microsoft\Windows\WER\ReportQueue"
    call :cleandir "%SystemRoot%\Minidump"
    del /f /q "%SystemRoot%\MEMORY.DMP" >nul 2>&1
    call :confirm "Also empty the Recycle Bin on %SystemDrive%?" && (
        rd /s /q "%SystemDrive%\$Recycle.Bin" >nul 2>&1
        call :log "Recycle bin emptied"
    )
) else (
    call :warn "Not elevated: system temp folders were skipped."
)
call :ok "Temporary files deleted"
exit /b 0

:a_wu
call :req_admin || exit /b 1
call :head "Reset Windows Update cache"
call :confirm "Stop update services and clear the download cache?" || exit /b 0
call :exec net stop wuauserv
call :exec net stop bits
call :cleandir "%SystemRoot%\SoftwareDistribution\Download"
call :exec net start bits
call :exec net start wuauserv
call :ok "Windows Update cache reset"
exit /b 0

:a_net
call :req_admin || exit /b 1
call :head "Reset network stack"
call :confirm "Flush DNS and reset Winsock and TCP/IP? A restart is needed." || exit /b 0
call :exec ipconfig /flushdns
call :exec netsh winsock reset
call :exec netsh int ip reset
call :ok "Network reset. Restart Windows to finish."
exit /b 0

:a_cleanup
call :req_admin || exit /b 1
call :head "Component store cleanup"
call :exec DISM /Online /Cleanup-Image /StartComponentCleanup
call :ok "Component store cleaned"
exit /b 0

:a_cleanmgr
call :head "Disk Cleanup"
where cleanmgr >nul 2>&1 || (call :err "cleanmgr is not available on this system" & exit /b 1)
start "" cleanmgr /d %SystemDrive%
call :ok "Disk Cleanup opened"
exit /b 0

:a_icons
call :head "Rebuild icon cache"
call :confirm "Explorer will restart briefly. Continue?" || exit /b 0
taskkill /f /im explorer.exe >nul 2>&1
del /f /q "%LOCALAPPDATA%\IconCache.db" >nul 2>&1
del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\iconcache_*.db" >nul 2>&1
del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
start "" explorer.exe
call :log "Icon cache rebuilt"
call :ok "Icon cache rebuilt"
exit /b 0

:a_restore
call :req_admin || exit /b 1
call :head "Create restore point"
if defined HAS_PS (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Checkpoint-Computer -Description 'Fix-Windows' -RestorePointType MODIFY_SETTINGS -ErrorAction Stop; exit 0 } catch { Write-Host $_.Exception.Message; exit 1 }"
    if not errorlevel 1 (call :ok "Restore point created" & exit /b 0)
)
where wmic >nul 2>&1 && (
    wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Fix-Windows", 100, 7 >nul 2>&1
    if not errorlevel 1 (call :ok "Restore point created" & exit /b 0)
)
call :err "Could not create a restore point. Is System Protection enabled?"
exit /b 1

:a_disk
call :head "Disk health"
if defined HAS_PS (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-PhysicalDisk | Select-Object FriendlyName,MediaType,HealthStatus,OperationalStatus,@{n='SizeGB';e={[math]::Round($_.Size/1GB)}} | Format-Table -AutoSize" 2>nul
    if not errorlevel 1 exit /b 0
)
where wmic >nul 2>&1 && (wmic diskdrive get model,status,size & exit /b 0)
call :err "No tool available to read disk health"
exit /b 1

:a_info
call :head "System information"
ver
systeminfo 2>nul | findstr /b /c:"Host Name" /c:"OS Name" /c:"OS Version" /c:"System Type" /c:"System Boot Time" /c:"Total Physical Memory" /c:"Available Physical Memory"
echo.
dir %SystemDrive%\ 2>nul | findstr /c:"bytes free"
echo.
echo Administrator : %ISADMIN%
echo PowerShell    : %HAS_PS%
echo Log file      : %LOGFILE%
exit /b 0

:a_sfcdetails
call :req_admin || exit /b 1
call :head "Export SFC details"
set "OUT=%USERPROFILE%\Desktop\sfcdetails.txt"
if not exist "%SystemRoot%\Logs\CBS\CBS.log" (call :err "CBS.log not found. Run SFC first." & exit /b 1)
findstr /c:"[SR]" "%SystemRoot%\Logs\CBS\CBS.log" > "%OUT%" 2>nul
call :ok "Saved to %OUT%"
exit /b 0

:a_log
if exist "%LOGFILE%" (start "" notepad "%LOGFILE%") else call :warn "No log file yet"
exit /b 0

:a_elevate
if defined ISADMIN (call :ok "Already running as administrator" & exit /b 0)
call :log "Elevation requested"
if defined HAS_PS (
    powershell -NoProfile -Command "Start-Process -FilePath $env:SELF -Verb RunAs" 2>nul
    if not errorlevel 1 exit
)
:: Fallback without PowerShell: VBScript + Shell.Application
set "VBS=%TEMP%\fixwindows_elevate.vbs"
> "%VBS%" echo Set sh = CreateObject("Shell.Application")
>> "%VBS%" echo sh.ShellExecute "cmd.exe", "/c """"%SELF%""""", "", "runas", 1
cscript //nologo "%VBS%" >nul 2>&1
del /f /q "%VBS%" >nul 2>&1
if errorlevel 1 (call :err "Could not elevate. Right-click the file and choose Run as administrator." & exit /b 1)
exit

:: ============================================================================
::  Helpers
:: ============================================================================
:banner
echo.
echo   %C_B%==================================================================%C_0%
echo   %C_C%  F I X - W I N D O W S%C_0%    Repair and maintenance toolkit  v%VERSION%
echo   %C_B%==================================================================%C_0%
if defined ISADMIN (
    echo   Admin: %C_G%yes%C_0%    PowerShell: !HAS_PS!
) else (
    echo   Admin: %C_R%no%C_0%  - some options need elevation, press R
)
echo.
exit /b 0

:head
echo.
echo %C_B%--- %~1 ---%C_0%
call :log "ACTION %~1"
exit /b 0

:exec
call :log "RUN %*"
%*
set "_rc=!errorlevel!"
call :log "EXIT !_rc! : %*"
exit /b !_rc!

:cleandir
:: Deletes the contents of a folder, never the folder itself.
if not exist "%~1\" exit /b 0
del /f /s /q "%~1\*" >nul 2>&1
for /d %%D in ("%~1\*") do rd /s /q "%%D" >nul 2>&1
call :log "Cleaned %~1"
echo %C_G%[+]%C_0% Cleaned %~1
exit /b 0

:confirm
if defined YES exit /b 0
choice /c YN /n /m "%~1 [Y/N] "
if errorlevel 2 (call :log "Declined: %~1" & exit /b 1)
exit /b 0

:req_admin
if defined ISADMIN exit /b 0
call :err "Administrator rights required. Press R in the menu or run as administrator."
exit /b 1

:log
>>"%LOGFILE%" echo [%date% %time%] %~1
exit /b 0

:ok
echo %C_G%[+]%C_0% %~1
call :log "OK %~1"
exit /b 0

:warn
setlocal DisableDelayedExpansion
echo %C_Y%[!]%C_0% %~1
endlocal
call :log "WARN %~1"
exit /b 0

:err
echo %C_R%[X]%C_0% %~1
call :log "ERROR %~1"
exit /b 1
