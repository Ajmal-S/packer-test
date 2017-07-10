call C:\MapNetworkDrives.bat

pushd "Z:\Software\3rdParty\Virtual Clone CD"

start certutil -addstore "TrustedPublisher" Elaborate5440.p7b
start "Install Virtual Clone Drive" /wait SetupVirtualCloneDrive5440.exe /S /noreboot

popd

exit /b 0