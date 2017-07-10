
if EXIST Z:\ GOTO :finish
::connect as amer\labviewbuild
net use Z:\\labviewstore\tfs Bu1lD3r /user:amer\labviewbuild

:finish
exit /b 0