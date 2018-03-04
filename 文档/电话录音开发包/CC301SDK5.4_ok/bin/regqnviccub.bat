regsvr32 /s "atl.dll"
mkdir c:\ICC301lib
copy "%~dp0\qnviccub.dll" c:\ICC301lib\qnviccub.dll
@echo off 
if errorlevel 1 echo ****文件[qnviccub.dll]复制失败********************* & pause 
@echo on
copy "%~dp0\bridge.dll" c:\ICC301lib\bridge.dll
@echo off 
if errorlevel 1 echo ****文件[bridge.dll]复制失败************************* & pause 
@echo on
regsvr32 /s c:\ICC301lib\qnviccub.dll
