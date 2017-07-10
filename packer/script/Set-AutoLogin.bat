reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "AutoAdminLogon" /d "1" /f
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "DefaultDomainName" /d "amer.corp.natinst.com" /f
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "DefaultPassword" /d "Bu1lD3r" /f
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "DefaultUserName" /d "labviewbuild" /f
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "AutoLogonCount" /f

EXIT /b 0