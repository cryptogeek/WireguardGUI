cd "%~dp0"
schtasks /delete /tn autoconnectgui /f
powershell.exe -ExecutionPolicy Bypass -Command "Register-ScheduledTask -Xml (Get-Content \"autoconnectgui.xml\" | Out-String) -TaskName \"autoconnectgui\""
schtasks /run /tn autoconnectgui
exit

