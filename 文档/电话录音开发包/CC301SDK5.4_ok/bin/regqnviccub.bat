regsvr32 /s "atl.dll"
mkdir c:\ICC301lib
copy "%~dp0\qnviccub.dll" c:\ICC301lib\qnviccub.dll
@echo off 
if errorlevel 1 echo ****�ļ�[qnviccub.dll]����ʧ��********************* & pause 
@echo on
copy "%~dp0\bridge.dll" c:\ICC301lib\bridge.dll
@echo off 
if errorlevel 1 echo ****�ļ�[bridge.dll]����ʧ��************************* & pause 
@echo on
regsvr32 /s c:\ICC301lib\qnviccub.dll
