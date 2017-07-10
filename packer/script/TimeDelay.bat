@echo off
SETLOCAL

IF "%timetowait%"=="" ECHO timetowait is NOT defined ELSE GOTO wait
set timetowait=120

:wait
ECHO Waiting for %timetowait% seconds
TIMEOUT /T %timetowait% >nul
