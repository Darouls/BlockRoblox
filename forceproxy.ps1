New-Item -Path "HKLM:\Software\Policies\Microsoft\Internet Explorer\Control Panel" -Force
Set-ItemProperty `
 -Path "HKLM:\Software\Policies\Microsoft\Internet Explorer\Control Panel" `
 -Name Proxy -Value 1