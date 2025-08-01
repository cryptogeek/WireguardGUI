cd /d "%~dp0"

schtasks /create /tn autoconnectvpn /sc ONSTART /RL HIGHEST /ru "SYSTEM" /tr "\"%~dp0start.bat\"" /F
powershell.exe -ExecutionPolicy Bypass -Command "$Stset = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries;Set-ScheduledTask \"autoconnectvpn\" -Settings $STSet;"

start "" autoconnectvpn.exe createShortcut.ahk

schtasks /run /tn autoconnectvpn

timeout /t 5 /nobreak >nul

exit