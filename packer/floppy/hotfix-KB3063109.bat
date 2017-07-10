
echo "Installing HyperV Integration Services Update KB3063109"

start /wait Pkgmgr /ip /quiet /norestart /m:a:\windows6.x-hypervintegrationservices-x64.cab /l:C:\Windows\Temp\hyperv-integrationservices.log

echo "Finished Installing HyperV Integration Services Update KB3063109"

type C:\Windows\Temp\hyperv-integrationservices.log