$HomeProxyIP = "192.168.1.11"
$ProxyPort = "3128"

$IsHome = Test-NetConnection -ComputerName $HomeProxyIP -Port $ProxyPort -InformationLevel Quiet

$log = "C:\ProgramData\proxy-user.log"
Add-Content $log "$(Get-Date) - Test maison = $IsHome"

if ($IsHome) {
    Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' ProxyEnable 1
    Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' ProxyServer "$HomeProxyIP:$ProxyPort"
    Add-Content $log "Proxy ACTIVÉ"
}
else {
    Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' ProxyEnable 0
    Remove-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' ProxyServer -ErrorAction SilentlyContinue
    Add-Content $log "Proxy DÉSACTIVÉ"
}
