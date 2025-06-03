cd /d "%~dp0"

start "" autoconnectvpn.exe togglevpnservice.ahk
start "" autoconnectvpn.exe vpnStatusService.ahk
start "" cmd.exe /c installautoconnectguischeduledtask.bat

exit