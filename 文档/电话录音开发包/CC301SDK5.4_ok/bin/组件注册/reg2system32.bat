regsvr32 /s "atl.dll"
mkdir %SystemRoot%\system32\cc301lib
copy ..\qnviccub.dll %SystemRoot%\system32\cc301lib\qnviccub.dll
copy ..\bridge.dll %SystemRoot%\system32\cc301lib\bridge.dll
regsvr32 %SystemRoot%\system32\cc301lib\qnviccub.dll