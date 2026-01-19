# Variables
$ProxyIP = "192.168.1.11"
$ProxyPort = "3128"
$AdGuardIP = "192.168.1.11"

# Bloque HTTP/HTTPS direct
New-NetFirewallRule -DisplayName "BLOQUE Internet direct" `
 -Direction Outbound -Protocol TCP -RemotePort 80,443 `
 -Action Block

# Autorise proxy
New-NetFirewallRule -DisplayName "AUTORISE Proxy Synology" `
 -Direction Outbound -Protocol TCP -RemotePort 3128 `
 -RemoteAddress $ProxyIP -Action Allow

# Autorise DNS
New-NetFirewallRule -DisplayName "AUTORISE DNS UDP AdGuard" `
 -Direction Outbound -Protocol UDP -RemotePort 53 `
 -RemoteAddress $AdGuardIP -Action Allow

 New-NetFirewallRule -DisplayName "AUTORISE DNS TCP" `
 -Direction Outbound -Protocol TCP -RemotePort 53 `
 -RemoteAddress $AdGuardIP -Action Allow

# Bloque QUIC (UDP 443)
 New-NetFirewallRule -DisplayName "BLOQUE QUIC UDP 443" `
 -Direction Outbound `
 -Protocol UDP `
 -RemotePort 443 `
 -Action Block


 ## Ajoute le proxy aux paramètres système
netsh winhttp set proxy "${ProxyIP}:${ProxyPort}"
   Write-Host "Proxy configuré : ${ProxyIP}:${ProxyPort}"