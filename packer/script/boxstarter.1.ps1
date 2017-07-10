$WinlogonPath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
Remove-ItemProperty -Path $WinlogonPath -Name AutoAdminLogon
Remove-ItemProperty -Path $WinlogonPath -Name DefaultUserName

iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/mwrock/boxstarter/master/BuildScripts/bootstrapper.ps1'))
Get-Boxstarter -Force

Write-Output "installed boxstarter stuff"
$secpasswd = ConvertTo-SecureString "labview===123" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("lvuser", $secpasswd)

Import-Module $env:appdata\boxstarter\boxstarter.chocolatey\boxstarter.chocolatey.psd1
