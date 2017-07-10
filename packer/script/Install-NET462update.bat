call C:\MapNetworkDrives.bat

pushd "Z:\Software\Microsoft\NET 4.6.2DevPack\"

::default logs to %temp%
START "Install .NET 4.6.2" /WAIT "NDP462-DevPack-KB3151934-ENU.exe" /install /quiet /log C:\InstallLogs\NDP462-DevPack-KB3151934-ENU.exe.log

popd

exit /b 0