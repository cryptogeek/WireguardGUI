SetWorkingDir %A_ScriptDir%

run,autoconnectvpn.exe autoconnectvpn.ahk

loop:

file=%PUBLIC%\togglevpnoff
if (FileExist(file)){
	runwait,autoconnectvpn.exe VPNDisable.ahk
	filedelete, %file%
}

file=%PUBLIC%\togglevpnon
if (FileExist(file)){
	runwait,autoconnectvpn.exe VPNEnable.ahk
	filedelete, %file%
}

;compat fix for old clients
file=%PUBLIC%\wireguardautoconnect.conf
if (FileExist(file)){
	FileMove, %file%, %PUBLIC%\ac.conf
}

sleep 1000

Goto, loop