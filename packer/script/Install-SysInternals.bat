call C:\MapNetworkDrives.bat

pushd "Z:\Software\Microsoft\Sysinternals"

MKDIR C:\Sysinternals
COPY * C:\Sysinternals

popd

exit /b 0