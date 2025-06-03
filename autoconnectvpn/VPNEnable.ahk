#NoTrayIcon
#SingleInstance, Off

full_command_line := DllCall("GetCommandLine", "str")
if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try
    {
        if A_IsCompiled
            Run *RunAs "%A_ScriptFullPath%" /restart
        else
            Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
    }
    ExitApp
}

SetWorkingDir %A_ScriptDir%

FileRead, entrepriseInternalTestIP, entrepriseInternalTestIP.txt
FileRead, VPNServerCentralIP, VPNServerCentralIP.txt

;runwait,autoconnectvpn.exe VPNDisable.ahk

opentunnel:
;FileDelete, VPNEnablescquery2.log
RunWait, %comspec% /c sc query WireGuardTunnel$ac > VPNEnablescquery2.log, , Hide 
Sleep, 500
FileRead, FileContent, VPNEnablescquery2.log
;FileDelete, VPNEnablescquery2.log
;msgbox, FileContent is:`n%FileContent%
If FileContent contains TYPE
{
	
}
Else
{
	;msgbox, install

	run,"c:\Program Files\WireGuard\wireguard.exe" /installtunnelservice "%PUBLIC%\ac.conf"
	Sleep, 5000
	;Goto, opentunnel
}

exitapp