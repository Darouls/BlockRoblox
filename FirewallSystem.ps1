$HomeProxyIP = "192.168.1.11"
$ProxyPort = "3128"

$Rules = @(
    "BLOQUE Internet direct",
    "BLOQUE QUIC UDP 443"
)

$IsHome = Test-NetConnection -ComputerName $HomeProxyIP -Port $ProxyPort -InformationLevel Quiet

$log = "C:\ProgramData\firewall-system.log"
Add-Content $log "$(Get-Date) - Test maison = $IsHome"

foreach ($r in $Rules) {
    Set-NetFirewallRule -DisplayName $r -Enabled $IsHome
    Add-Content $log "Règle $r => $IsHome"
}
