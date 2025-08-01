#SingleInstance Ignore

Menu,Tray,Icon,wireguard.ico

SetWorkingDir %A_ScriptDir%

FileRead, entrepriseInternalTestIP, entrepriseInternalTestIP.txt
FileRead, VPNServerCentralIP, VPNServerCentralIP.txt

OnMessage(0x404, "AHK_NOTIFYICON")

vpnserverstatus:=0
entrepriseInternalTestIPstatus:=0

doopenautoconnect2faurl:=1

vpnstatustray:


file=2faURL.txt
if (FileExist(file)){
	file=%PUBLIC%\openautoconnect2faurl
	if (FileExist(file)){
		FileRead, vpnpopuptitle, vpnpopuptitle.txt
		FileRead, vpnpopuptxt, vpnpopuptxt.txt
		MsgBox , 4, %vpnpopuptitle%, %vpnpopuptxt%
		IfMsgBox Yes
		{
			FileDelete, %PUBLIC%\openautoconnect2faurl
			FileRead, 2faURL, 2faURL.txt
			run, %2faURL%
		}
		else
		{
			filedelete, %PUBLIC%\vpnalwayson
			FileAppend,,  %PUBLIC%\togglevpnoff
			FileDelete, %PUBLIC%\openautoconnect2faurl
		}
	}
}


checkVPNService:
FileRead, FileContent, VPNDisablescquery.log
If FileContent contains TYPE
{
	vpnserviceON:=1
}
Else
{
	If FileContent contains EnumQueryServicesStatus
	{
		vpnserviceON:=0
	}
	Else
	{
		sleep 5000
		Goto, checkVPNService
	}
}

if (vpnserviceON){
	Server=%VPNServerCentralIP%
	FileDelete, %A_Temp%\vpnenabledPingTray.log
	Target = %Server% -n 1 -w 3000 
	RunWait, %comspec% /c ping %Target% > %A_Temp%\vpnenabledPingTray.log, , Hide 
	Sleep, 500
	FileRead, FileContent, %A_Temp%\vpnenabledPingTray.log
	If FileContent contains TTL
	{
		If FileContent contains Reply from
		{ 
			;;msgbox, %Server% is up
			vpnserverstatus:=1
		} 
		else if FileContent contains ponse de
		{ 
			;;msgbox, %Server% est up
			vpnserverstatus:=1
		} 
		Else 
		{ 
			;;msgbox, %Server% is down
			vpnserverstatus:=0
		} 
	}
	Else
	{
		;;msgbox, %Server% not found in PingTray.log
		vpnserverstatus:=0
	}
	
	Server=%entrepriseInternalTestIP%
	FileDelete, %A_Temp%\entrepriseInternalTestIPPingTray.log
	Target = %Server% -n 1 -w 3000 
	RunWait, %comspec% /c ping %Target% > %A_Temp%\entrepriseInternalTestIPPingTray.log, , Hide 
	Sleep, 500
	FileRead, FileContent, %A_Temp%\entrepriseInternalTestIPPingTray.log
	If FileContent contains TTL
	{
		If FileContent contains Reply from
		{ 
			;;msgbox, %Server% is up
			entrepriseInternalTestIPstatus:=1
		} 
		else if FileContent contains ponse de
		{ 
			;;msgbox, %Server% est up
			entrepriseInternalTestIPstatus:=1
		} 
		Else 
		{ 
			;;msgbox, %Server% is down
			entrepriseInternalTestIPstatus:=0
		} 
	}
	Else
	{
		;;msgbox, %Server% not found in PingTray.log
		entrepriseInternalTestIPstatus:=0
	}
	
	if(vpnserverstatus && entrepriseInternalTestIPstatus){
		Menu, Tray, Icon
		Menu,Tray,Icon,wireguardON.ico
	}else{
		Menu, Tray, Icon
		Menu,Tray,Icon,wireguardTRYING.ico
	}
}else{
	;Menu,Tray,Icon,wireguard.ico
	
	Menu, Tray, NoIcon
}
Menu, Tray, Nostandard
sleep 1000
Goto, vpnstatustray

AHK_NOTIFYICON(wParam, lParam)
{
    ;WM_MOUSEFIRST = 0x200
	;WM_MOUSEMOVE = 0x200
	;WM_LBUTTONDOWN = 0x201
	;WM_LBUTTONUP = 0x202
	;WM_LBUTTONDBLCLK = 0x203
	;WM_RBUTTONDOWN = 0x204
	;WM_RBUTTONUP = 0x205
	;WM_RBUTTONDBLCLK = 0x206
	;WM_MBUTTONDOWN = 0x207
	;WM_MBUTTONUP = 0x208
	;WM_MBUTTONDBLCLK = 0x209
	;WM_MOUSEWHEEL = 0x20A
	;WM_MOUSEHWHEEL = 0x20E
	
	if (lParam = 0x202 or lParam = 0x205) ; WM_LBUTTONUP
	{
		run,autoconnectvpn.exe togglevpn.ahk
	}
}

