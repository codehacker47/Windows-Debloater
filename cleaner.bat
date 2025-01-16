@echo off

:menu
echo Windows Cleaner
echo 1. Delete files in temporary folders
echo 2. Disable Windows Telemetry(tested in Windows 11 only)
echo 3. Optimize C: Disk
echo 4. Clear browser cache(Edge, Chrome and Firefox only)
echo 5. Exit

set /p choice=Choose an option: 

if %choice%==1 goto option1
if %choice%==2 goto option2
if %choice%==3 goto option3
if %choice%==4 goto option4
if %choice%==5 goto option5

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
cls
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
cls 
goto menu

:option3
cls
defrag C: /O /W /V /U
echo "Optimization completed"
pause
cls
goto menu

:option4
cls
echo 1. Google Chrome
echo 2. Microsoft Edge
echo 3. Mozilla Firefox
set /p browser_choice=Choose your browser
if %browser_choice%==1 goto chrome_cache
if %browser_choice%==2 goto edge_cache
if %browser_choice%==3 goto firefox_cache

:chrome_cache
echo Clearing Google Chrome cache...
del /q /s /f "%LocalAppData%\Google\Chrome\User Data\Default\Cache\*.*"
del /q /s /f "%LocalAppData%\Google\Chrome\User Data\Default\Code Cache\*.*"
del /q /s /f "%LocalAppData%\Google\Chrome\User Data\Default\Media Cache\*.*"
echo Google Chrome cache cleared!
pause
cls
goto menu

:edge_cache
echo Clearing Microsoft Edge cache...
del /q /s /f "%LocalAppData%\Microsoft\Edge\User Data\Default\Cache\*.*"
del /q /s /f "%LocalAppData%\Microsoft\Edge\User Data\Default\Code Cache\*.*"
del /q /s /f "%LocalAppData%\Microsoft\Edge\User Data\Default\Media Cache\*.*"
echo Microsoft Edge cache cleared!
pause
cls
goto menu

:firefox_cache
echo Clearing Mozilla Firefox cache...
del /q /s /f "%AppData%\Mozilla\Firefox\Profiles\*\cache2\*.*"
echo Mozilla Firefox cache cleared!
pause
cls
goto menu

:option5
Exit