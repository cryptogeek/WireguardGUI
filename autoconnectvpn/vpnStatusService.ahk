SetWorkingDir %A_ScriptDir%

loop:
Run, %comspec% /c sc query WireGuardTunnel$ac > VPNDisablescquery.log, , Hide 
Sleep, 5000
Goto, loop