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

deletetunnel:
;FileDelete, VPNDisablescquery.log
RunWait, %comspec% /c sc query WireGuardTunnel$ac > VPNDisablescquery.log, , Hide 
Sleep, 500
FileRead, FileContent, VPNDisablescquery.log
;FileDelete, VPNDisablescquery.log
;msgbox, FileContent is:`n%FileContent%
If FileContent contains TYPE
{
	;msgbox, remove vpn
	run,"c:\Program Files\WireGuard\wireguard.exe" /uninstalltunnelservice ac
	sleep 5000
	;Goto, deletetunnel
}
Else
{

}
If FileContent contains EnumQueryServicesStatus
{

}
Else
{
	sleep 5000
	;Goto, deletetunnel
}