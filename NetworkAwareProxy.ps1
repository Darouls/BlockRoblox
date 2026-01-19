$HomeProxyIP = "192.168.1.11"
$ProxyPort = "3128"

$FirewallRules = @(
    "BLOQUE Internet direct",
    "BLOQUE QUIC UDP 443"
)

$IsHome = Test-NetConnection -ComputerName $HomeProxyIP -Port $ProxyPort -InformationLevel Quiet

if ($IsHome) {
    # ===== MAISON =====

    # Proxy ON
    Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' ProxyEnable 1
    Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' ProxyServer "$HomeProxyIP:$ProxyPort"

    # Pare-feu ON
    foreach ($rule in $FirewallRules) {
        Set-NetFirewallRule -DisplayName $rule -Enabled True
    }
}
else {
    # ===== EXTERIEUR =====

    # Proxy OFF
    Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' ProxyEnable 0
    Remove-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' ProxyServer -ErrorAction SilentlyContinue

    # Pare-feu OFF
    foreach ($rule in $FirewallRules) {
        Set-NetFirewallRule -DisplayName $rule -Enabled False
    }
}
