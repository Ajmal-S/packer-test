call C:\MapNetworkDrives.bat

pushd "Z:\Software\Microsoft\WindowsManagementFramework5.0"

::Access Denied error when trying to install directly
:: WUSA can't be installed remotely in powershell 2.0
::https://support.microsoft.com/en-us/help/2773898/windows-update-standalone-installer-wusa-returns-0x5-error-access-denied-when-deploying-.msu-files-through-winrm-and-windows-remote-shell
mkdir C:\WMF50
START "Extract Windows Management Framework 5.0" /WAIT wusa.exe Win7AndW2K8R2-KB3134760-x64.msu /extract:C:\WMF50\Win7AndW2K8R2-KB3134760-x64.cab /log:C:\InstallLogs\ExtractWin7AndW2K8R2-KB3134760-x64.msu.log
START "Install WMF50 with DISM" /WAIT dism.exe /online /Quiet /NoRestart /LogPath:C:\InstallLogs\DISMWin7AndW2K8R2-KB3134760-x64.cab.log /add-package /PackagePath:C:\WMF50\Win7AndW2K8R2-KB3134760-x64.cab

popd

exit /b 0