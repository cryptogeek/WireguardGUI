SetWorkingDir %A_ScriptDir%

filedelete, autoconnectvpn.log.txt
filedelete, %PUBLIC%\openautoconnect2faurl

fileread, ipPingableQueDepuisBureau, ipPingableQueDepuisBureau.txt
fileread, VPNServerCentralIP, VPNServerCentralIP.txt

disableVPNOnStartup:=1

test:

FormatTime, currentTime, %A_Now%, yyyy-MM-dd HH:mm:ss

fileappend, %currentTime% début test`n, autoconnectvpn.log.txt

fileappend, %currentTime% test 8.8.8.8`n, autoconnectvpn.log.txt
if(ping("8.8.8.8")){
	fileappend, %currentTime% test vpnalwayson`n, autoconnectvpn.log.txt
	file=%PUBLIC%\vpnalwayson
	if (FileExist(file)){
		fileappend, %currentTime% test %ipPingableQueDepuisBureau%`n, autoconnectvpn.log.txt
		;si ip interne du serveur wireguard 192.168.222.12 répond
		if(ping(ipPingableQueDepuisBureau)){
			fileappend, %currentTime% on est au bureau et vpn site a site est on`n, autoconnectvpn.log.txt
			;on est au bureau et le vpn site à site est up
			run,autoconnectvpn.exe VPNDisable.ahk
			fileappend, %currentTime% désactivation du vpn car on est au bureau`n, autoconnectvpn.log.txt
			sleep 60000
			goto test
		}else{
			fileappend, %currentTime% activation du vpn car pas au bureau`n, autoconnectvpn.log.txt
			;on est pas au bureau ou le vpn site à site est down
			run,autoconnectvpn.exe VPNEnable.ahk
			fileappend, %currentTime% vpn activé`n, autoconnectvpn.log.txt
			fileappend, %currentTime% test si %VPNServerCentralIP% répond`n, autoconnectvpn.log.txt
			if(!ping(VPNServerCentralIP)){
				fileappend, %currentTime% %VPNServerCentralIP% répond pas`n, autoconnectvpn.log.txt
				fileappend, %currentTime% on ouvre l'url`n, autoconnectvpn.log.txt
				file=%PUBLIC%\openautoconnect2faurl
				fileappend, ok`n, %file%
				while(FileExist(file)){
					fileappend, %currentTime% on attend que l'url soit ouverte`n, autoconnectvpn.log.txt
					sleep 1000
				}
			}else{
				fileappend, %currentTime% %VPNServerCentralIP% répond`n, autoconnectvpn.log.txt
			}
			sleep 60000
			goto test
		}
	}else{
		fileappend, %currentTime% vpnalwayson pas activé`n, autoconnectvpn.log.txt
		
		if (disableVPNOnStartup){
			fileappend, %currentTime% désactivation du vpn au démarrage`n, autoconnectvpn.log.txt
			run,autoconnectvpn.exe VPNDisable.ahk
			disableVPNOnStartup:=0
		}

		sleep 5000
		goto test
	}
}else{
	fileappend, %currentTime% 8.8.8.8 répond pas`n, autoconnectvpn.log.txt
	sleep 5000
	goto test
}


return

ping(server) {
    FileDelete, Ping%server%.log
    Target := server " -n 4 -w 5000"
    RunWait, %comspec% /c ping %Target% > Ping%server%.log, , Hide
    Sleep, 500
    FileRead, FileContent, Ping%server%.log
    if (InStr(FileContent, "TTL")) {
        ; The server is up
        ;msgbox, %server% is up
        return true
    } else {
        ; The server is down
        ;msgbox, %server% is down
        return false
    }
}