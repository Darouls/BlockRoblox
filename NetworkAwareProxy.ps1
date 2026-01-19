$HomeProxyIP = "192.168.1.11"
$ProxyPort = "3128"
$TestTimeout = 1500

$reachable = Test-NetConnection -ComputerName $HomeProxyIP -Port $ProxyPort -InformationLevel Quiet

if ($reachable) {
    # Réseau maison
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' `
        -Name ProxyEnable -Value 1
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' `
        -Name ProxyServer -Value "$HomeProxyIP:$ProxyPort"

    Write-EventLog -LogName Application -Source "NetworkAwareProxy" `
        -EventId 1000 -EntryType Information `
        -Message "Proxy maison activé"
}
else {
    # Réseau externe
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' `
        -Name ProxyEnable -Value 0

    Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' `
        -Name ProxyServer -ErrorAction SilentlyContinue

    Write-EventLog -LogName Application -Source "NetworkAwareProxy" `
        -EventId 1001 -EntryType Information `
        -Message "Proxy désactivé (réseau externe)"
}
