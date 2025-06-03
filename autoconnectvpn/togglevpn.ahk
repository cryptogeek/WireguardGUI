#NoTrayIcon
#SingleInstance, Force

SetWorkingDir %A_ScriptDir%

run, autoconnectvpn.exe vpntraystatus.ahk

vpnserverstatus=CHECKING STATUS
vpnserverColor=FF0000
entrepriseInternalTestIPstatus=CHECKING STATUS
entrepriseInternalTestIPColor=FF0000
autostatus=CHECKING STATUS
autostatusColor=FF0000

FileRead, entrepriseInternalTestIP, entrepriseInternalTestIP.txt
FileRead, VPNServerCentralIP, VPNServerCentralIP.txt
file=2faURL.txt
if (FileExist(file)){
	FileRead, 2faURL, 2faURL.txt
}

Menu, Tray, Icon, wireguardDEFAULT.ico
;Gui, Add, Text,, Ouvrir "%filesToOpen%" dans:
Gui, Add, Text,, Version: 4.9
Gui, Add, Text,, Connexion en télétravail (%VPNServerCentralIP%):
Gui, Font, c%vpnserverColor%
Gui, Add, Text, w300 vText1, %vpnserverstatus%
Gui, Font
Gui, Add, Text,, Connexion réseau entreprise (%entrepriseInternalTestIP%):
Gui, Font, c%entrepriseInternalTestIPColor%
Gui, Add, Text, w300 vText2, %entrepriseInternalTestIPstatus%
Gui, Font
;Gui, Add, Text,, Connexion du VPN au démarrage:
;Gui, Font, c%autostatusColor%
;Gui, Add, Text, w300 vText3, %autostatus%
;Gui, Font
Gui, Add, Text,, 
Gui, Add, CheckBox, vopenVpn gupdateVpn, Activer télétravail
;Gui, Add, Button, default gclose, Fermer le VPN
;Gui, Add, Button, default gopen, Ouvrir le VPN
Gui, Add, CheckBox, vautoVpn gupdateAuto, Activer télétravail automatiquement si en dehors de l'entreprise
;Gui, Add, Button, default gauto, VPN automatique au démarrage PC
;Gui, Add, Button, default gmanual, VPN manuel au démarrage PC
Gui, Add, Button, default gconfig, Modifier config Wireguard
Gui, Show,, Télétravail

checkvpnstatus:

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

if(vpnserviceON){
	GuiControl, , openVpn, 1
}else{
	GuiControl, , openVpn, 0
}


file=%PUBLIC%\vpnalwayson
if (FileExist(file)){
	GuiControl, , autoVpn, 1
}else{
	GuiControl, , autoVpn, 0
}

file=%PUBLIC%\vpnalwaysonforced
if (FileExist(file)){
	GuiControl, Disable, openVpn
	GuiControl, Disable, autoVpn
}else{
	GuiControl, Enable, openVpn
	GuiControl, Enable, autoVpn
}

Server=%VPNServerCentralIP%
FileDelete, %A_Temp%\vpnenabledPing.log
Target = %Server% -n 1 -w 3000 
RunWait, %comspec% /c ping %Target% > %A_Temp%\vpnenabledPing.log, , Hide 
Sleep, 500
FileRead, FileContent, %A_Temp%\vpnenabledPing.log
If FileContent contains TTL
{
	If FileContent contains Reply from
	{ 
		;;msgbox, %Server% is up
		vpnserverstatus=OK
		vpnserverColor=008000
	} 
	else if FileContent contains ponse de
	{ 
		;;msgbox, %Server% est up
		vpnserverstatus=OK
		vpnserverColor=008000
	} 
	Else 
	{ 
		;;msgbox, %Server% is down
		vpnserverstatus=TRYING
	} 
}
Else
{
	;;msgbox, %Server% not found in Ping.log
	vpnserverstatus=TRYING
}

Server=%entrepriseInternalTestIP%
FileDelete, %A_Temp%\entrepriseInternalTestIPPing.log
Target = %Server% -n 1 -w 3000 
RunWait, %comspec% /c ping %Target% > %A_Temp%\entrepriseInternalTestIPPing.log, , Hide 
Sleep, 500
FileRead, FileContent, %A_Temp%\entrepriseInternalTestIPPing.log
If FileContent contains TTL
{
	If FileContent contains Reply from
	{ 
		;;msgbox, %Server% is up
		entrepriseInternalTestIPstatus=OK
		entrepriseInternalTestIPColor=008000
	} 
	else if FileContent contains ponse de
	{ 
		;;msgbox, %Server% est up
		entrepriseInternalTestIPstatus=OK
		entrepriseInternalTestIPColor=008000
	} 
	Else 
	{ 
		;;msgbox, %Server% is down
		entrepriseInternalTestIPstatus=TRYING
	} 
}
Else
{
	;;msgbox, %Server% not found in Ping.log
	entrepriseInternalTestIPstatus=TRYING
}

if (!vpnserviceON){
	vpnserverstatus=OFF
	vpnserverColor=FF0000
	;entrepriseInternalTestIPstatus=OFF
	;entrepriseInternalTestIPColor=FF0000
}


file=%PUBLIC%\vpnalwayson
if (FileExist(file)){
	autostatus=AUTOMATIQUE
	autostatusColor=008000
}else{
	autostatus=MANUEL
	autostatusColor=FF0000
}



GuiControl,, Text1, %vpnserverstatus%
GuiControl,, Text2, %entrepriseInternalTestIPstatus%
;GuiControl,, Text3, %autostatus%

Gui, Font, c%vpnserverColor%
GuiControl, Font, Text1
Gui, Font

Gui, Font, c%entrepriseInternalTestIPColor%
GuiControl, Font, Text2
Gui, Font

Gui, Font, c%autostatusColor%
;GuiControl, Font, Text3
Gui, Font

sleep 1000
goto, checkvpnstatus

return

updateVpn:
Gui, Submit, NoHide ;this command submits the guis' datas' state
if(openVpn=="1"){
	goto, open
}else{
	goto, close
}

close:

Gui, popup: Destroy
Gui, popup: +AlwaysOnTop -Caption +Border
Gui, popup: Font, S10
Gui, popup: Add, Text,, Déconnexion VPN...
Gui, popup: Show, NA

;runwait,autoconnectvpn.exe VPNDisable.ahk
FileAppend,,  %PUBLIC%\togglevpnoff

file=%PUBLIC%\togglevpnoff
while (FileExist(file)){
	sleep 1000
}

Gui, popup: Destroy

return

open:

Gui, popup: Destroy
Gui, popup: +AlwaysOnTop -Caption +Border
Gui, popup: Font, S10
Gui, popup: Add, Text,, Connexion au serveur VPN...
Gui, popup: Show, NA

;runwait,autoconnectvpn.exe VPNEnable.ahk
FileAppend,,  %PUBLIC%\togglevpnon

file=%PUBLIC%\togglevpnon
while (FileExist(file)){
	sleep 1000
}

Gui, popup: Destroy

;file=2faURL.txt
;if (FileExist(file)){
;	run, "%2faURL%"
;}
fileappend, ok`n, %PUBLIC%\openautoconnect2faurl

;run, autoconnectvpn.exe vpntraystatus.ahk

return

updateAuto:
Gui, Submit, NoHide ;this command submits the guis' datas' state
if(autoVpn=="1"){
	goto, auto
}else{
	goto, manual
}

auto:
	FileAppend,,  %PUBLIC%\vpnalwayson
	;msgbox, VPN est maintenant automatique au démarrage PC
return

manual:
	filedelete, %PUBLIC%\vpnalwayson
	;msgbox, VPN est maintenant manuel au démarrage PC
return

config:
	InputBox, password, Mot de passe,, hide
	if(password=="137137137"){
		run, notepad.exe "%PUBLIC%\ac.conf"
	}else{
		msgbox, mauvais mot de passe
	}
return

GuiClose:
ExitApp