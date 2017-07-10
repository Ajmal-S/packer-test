@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (%~dp0\_packer_config*.cmd) do @call "%%~i"
@if defined PACKER_DEBUG (@echo on) else (@echo off)

title Enabling Windows Remote Management. Please wait...

echo ==^> Turning off User Account Control (UAC)
:: see http://www.howtogeek.com/howto/windows-vista/enable-or-disable-uac-from-the-windows-vista-command-line/
reg ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f
@if errorlevel 1 echo ==^> WARNING: Error %ERRORLEVEL% was returned by: reg ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f

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

if not exist a:\fixnetwork.ps1 echo ==^> ERROR: File not found: a:\fixnetwork.ps1

echo ==^> Setting the Network Location to private
:: see http://blogs.msdn.com/b/powershell/archive/2009/04/03/setting-network-location-to-private.aspx
powershell -File a:\fixnetwork.ps1 <NUL
@if errorlevel 1 echo ==^> WARNING: Error %ERRORLEVEL% was returned by: powershell -File a:\fixnetwork.ps1

:skip_fixnetwork

cmd.exe /c winrm quickconfig -q
cmd.exe /c winrm quickconfig -transport:http
cmd.exe /c winrm set winrm/config @{MaxTimeoutms="1800000"}
cmd.exe /c winrm set winrm/config/winrs @{MaxMemoryPerShellMB="300"}
cmd.exe /c winrm set winrm/config/service @{AllowUnencrypted="true"}
cmd.exe /c winrm set winrm/config/service/auth @{Basic="true"}
cmd.exe /c winrm set winrm/config/client/auth @{Basic="true"}
cmd.exe /c winrm set winrm/config/listener?Address=*+Transport=HTTP @{Port="5985"}
cmd.exe /c netsh advfirewall firewall set rule group="remote administration" new enable=yes
cmd.exe /c netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow
cmd.exe /c netsh advfirewall firewall add rule name="WinRM 5986" protocol=TCP dir=in localport=5986 action=allow
cmd.exe /c net stop winrm
cmd.exe /c sc config winrm start= disabled
cmd.exe /c winrm set winrm/config/winrs @{MaxShellsPerUser="30"}
cmd.exe /c winrm set winrm/config/winrs @{MaxProcessesPerShell="25"}
cmd.exe /c netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow