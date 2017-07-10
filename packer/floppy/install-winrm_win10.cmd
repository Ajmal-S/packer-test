@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (%~dp0\_packer_config*.cmd) do @call "%%~i"
@if defined PACKER_DEBUG (@echo on) else (@echo off)

title Enabling Windows Remote Management. Please wait...

echo ==^> Setting the PowerShell ExecutionPolicy to RemoteSigned (64 bit)
powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force" <NUL
@if errorlevel 1 echo ==^> WARNING: Error %ERRORLEVEL% was returned by: powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force"

if exist %SystemRoot%\SysWOW64\cmd.exe (
  echo ==^> Setting the PowerShell ExecutionPolicy to RemoteSigned (32 bit)
  %SystemRoot%\SysWOW64\cmd.exe /c powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force" <NUL
  @if errorlevel 1 echo ==^> WARNING: Error %ERRORLEVEL% was returned by: powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force" <NUL
)

wmic os get Caption | findstr /c:"Windows 7" /c:"Windows 10" >nul
if errorlevel 1 goto skip_fixnetwork
SLEEP 300

if not exist a:\fixnetwork.ps1 echo ==^> ERROR: File not found: a:\fixnetwork.ps1

echo ==^> Setting the Network Location to private
:: see http://blogs.msdn.com/b/powershell/archive/2009/04/03/setting-network-location-to-private.aspx
powershell -File a:\fixnetwork.ps1 <NUL
@if errorlevel 1 echo ==^> WARNING: Error %ERRORLEVEL% was returned by: powershell -File a:\fixnetwork.ps1

:skip_fixnetwork

echo ==^> Changing remote UAC account policy
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\system /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f
@if errorlevel 1 echo ==^> WARNING: Error %ERRORLEVEL% was returned by: reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\system /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f

cmd.exe /c winrm quickconfig -q
cmd.exe /c winrm quickconfig -transport:http
cmd.exe /c winrm set winrm/config @{MaxTimeoutms="1800000"}
cmd.exe /c winrm set winrm/config/winrs @{MaxMemoryPerShellMB="800"}
cmd.exe /c winrm set winrm/config/service @{AllowUnencrypted="true"}
cmd.exe /c winrm set winrm/config/service/auth @{Basic="true"}
cmd.exe /c winrm set winrm/config/client/auth @{Basic="true"}
cmd.exe /c winrm set winrm/config/listener?Address=*+Transport=HTTP @{Port="5985"}
cmd.exe /c netsh firewall set service type=remoteadmin mode=enable 
cmd.exe /c netsh advfirewall firewall set rule group="remote administration" new enable=yes
cmd.exe /c netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow
cmd.exe /c netsh advfirewall firewall add rule name="WinRM 5986" protocol=TCP dir=in localport=5986 action=allow
cmd.exe /c net stop winrm
%SystemRoot%\System32\reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v HideFileExt /t REG_DWORD /d 0 /f
%SystemRoot%\System32\reg.exe ADD HKCU\Console /v QuickEdit /t REG_DWORD /d 1 /f
%SystemRoot%\System32\reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v Start_ShowRun /t REG_DWORD /d 1 /f
%SystemRoot%\System32\reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v StartMenuAdminTools /t REG_DWORD /d 1 /f
%SystemRoot%\System32\reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateFileSizePercent /t REG_DWORD /d 0 /f
%SystemRoot%\System32\reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateEnabled /t REG_DWORD /d 0 /f
cmd.exe /c wmic useraccount where "name='vagrant'" set PasswordExpires=FALSE
cmd.exe /c sc config winrm start= auto
cmd.exe /c net start winrm
cmd.exe /c winrm set winrm/config/winrs @{MaxShellsPerUser="30"}
cmd.exe /c winrm set winrm/config/winrs @{MaxProcessesPerShell="25"}
%SystemRoot%\System32\reg.exe ADD "HKLM\System\CurrentControlSet\Services\Netlogon\Parameters" /v DisablePasswordChange /t REG_DWORD /d 1 /f
cmd.exe /c netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow