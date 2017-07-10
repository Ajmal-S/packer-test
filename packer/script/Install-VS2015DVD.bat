call C:\MapNetworkDrives.bat

pushd "Z:\Software\Microsoft\Visual Studio\2015\RTM"

START "Mount VS2015" /WAIT "C:\Program Files (x86)\Elaborate Bytes\VirtualCloneDrive\VCDMount.exe" en_visual_studio_enterprise_2015_x86_x64_dvd_6850497.iso
START "Install VS2015" /WAIT E:\vs_enterprise.exe /InstallSelectableItems VSUV3RTMV1;NativeLanguageSupport_VCV1;Windows10_ToolsAndSDKV13 /NoRefresh /NoRestart /Quiet /Log C:\InstallLogs\VS2015DVD.log
START "Unmount VS2015" /WAIT "C:\Program Files (x86)\Elaborate Bytes\VirtualCloneDrive\VCDMount.exe" /u

popd

exit /b 0