@echo off

:menu
echo Windows Cleaner
echo 1. Delete files in temporary folders
echo 2. Disable Windows Telemetry(tested in Windows 11 only)
echo 3. Optimize C: Disk
echo 4. Exit

set /p choice=Choose an option: 

if %choice%==1 goto option1
if %choice%==2 goto option2
if %choice%==3 goto option3
if %choice%==4 goto option4

goto menu

:option1
cls
echo Deleting files in Temp folders...
del /q /s /f %temp%\*.*
del /q /s /f %tmp%\*.*
del /q /s /f %systemdrive%\*.tmp
del /q /s /f %systemdrive%\*._mp
del /q /s /f %AppData%\temp\*.*
del /q /s /f %HomePath%\AppData\LocalLow\Temp\*.*
echo Files deleted!
pause
goto menu

:option2
echo Disabling Windows Telemetry...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
echo Telemetry disabled! Disabling more telemetry...

:: Error handling for taskkill
taskkill /im diagtrack.exe /f >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Unable to terminate diagtrack.exe process.
    pause
) else (
    echo diagtrack.exe process terminated successfully.
)

echo " " > C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl
icacls C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl /D SYSTEM

sc stop DiagTrack
sc config DiagTrack start= disabled

sc stop WbioSrvc
sc config WbioSrvc start= disabled

sc stop lfsvc
sc config lfsvc start= disabled
pause
goto menu

:option3
cls
defrag C: /O /W /V /U
echo "Optimization completed"
pause
goto menu

:option4
Exit