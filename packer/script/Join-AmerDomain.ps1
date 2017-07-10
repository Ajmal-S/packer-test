$DomainName = "amer.corp.natinst.com"
$Password = ConvertTo-SecureString -String "Bu1lD3r" -asPlainText -Force
$Credentials = New-Object System.Management.Automation.PSCredential("amer\labviewbuild",$Password)
$OUPath = "OU=Maint-Win-2,OU=Build Machines,OU=R&D,OU=Desktops,OU=Workstations,OU=US-AUS,OU=AMER,DC=amer,DC=corp,DC=natinst,DC=com"
Add-Computer -DomainName $DomainName -Credential $Credentials -OUPath $OUPath

exit 0