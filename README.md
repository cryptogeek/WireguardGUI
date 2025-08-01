# WireguardGUI

For this gui to work, the wireguard official client for Windows has to be installed already.
You can get it from official source or you can build a silent Wireguard installer with: https://github.com/cryptogeek/silentWireguardInstaller

in folder customisationClients you have to set:

entrepriseInternalTestIP.txt: internal ip adress that the client will ping in the client GUI

ipPingableQueDepuisBureau.txt: internal ip adress that is pingable only when the computer is connecter to work wifi or ethernet and that ip should not be pingable from the wireguard VPN. That ip is used to test if the tunnel should be auto enabled or auto disabled.

vpnpopuptitle.txt: title of vpn client

vpnpopuptxt.txt: prompt for the userif they wish to enable the tunnel or not

VPNServerCentralIP.txt: should be set to the internal IP of your wireguard server. That ip will be pinged in the client GUI.

Once you are done with customatisation run "build installers.bat" to build the installers

if you did everything right the GUI should look like this:

![gui pic](https://github.com/cryptogeek/WireguardGUI/blob/main/gui%20exemple.png?raw=true)