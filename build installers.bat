cd "%~dp0"

rem customisation customer1
del autoconnectvpn\2faURL.txt
copy customisationClients\customer1\*.* autoconnectvpn

7z a "autoconnectvpn.zip" "autoconnectvpn"
copy /a templateInstaller.txt + /b autoconnectvpn.zip /b "install wireguard customer1 (run as admin).bat"
del autoconnectvpn.zip