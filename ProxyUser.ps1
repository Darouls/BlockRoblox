$HomeProxyIP = "192.168.1.11"
$ProxyPort = "3128"

$LogDir = "$env:LOCALAPPDATA\NetworkProxy"
$LogFile = "$LogDir\proxy-user.log"

if (!(Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

$IsHome = Test-NetConnection -ComputerName $HomeProxyIP -Port $ProxyPort -InformationLevel Quiet

Add-Content $LogFile "$(Get-Date) - Test maison = $IsHome"

if ($IsHome) {
    Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' ProxyEnable 1
    Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' ProxyServer "${HomeProxyIP}:${ProxyPort}"
    Add-Content $LogFile "Proxy ACTIVÉ"
}
else {
    Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' ProxyEnable 0
    Remove-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' ProxyServer -ErrorAction SilentlyContinue
    Add-Content $LogFile "Proxy DÉSACTIVÉ"
}
