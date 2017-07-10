call C:\MapNetworkDrives.bat

pushd "Z:\Software\Microsoft\IE10"

START "Installing IE 10" /WAIT "IE10-Windows6.1-en-us.exe" /quiet /norestart /log:C:\InstallLogs\IE10-Windows6.1-en-us.exe.log

popd

exit /b 0