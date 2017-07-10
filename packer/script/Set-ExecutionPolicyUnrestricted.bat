
powershell -Command "Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force"

if exist %SystemRoot%\SysWOW64\cmd.exe (
  %SystemRoot%\SysWOW64\cmd.exe /c powershell -Command "Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force"
)

EXIT /b 0