@echo off
:start
set /p o=�豸��64λϵͳ�����п�����Ҫ�ر�����ǩ��ǿ��,��Ҫ�ر�����ǩ��ģʽ? (Yes/No):
if /i "%o%"=="y" goto yes
if /i "%o%"=="yes" goto yes
if /i "%o%"=="n" goto no
if /i "%o%"=="no" goto no
goto start
:yes
bcdedit.exe -set loadoptions DDISABLE_INTEGRITY_CHECKS
bcdedit.exe -set TESTSIGNING ON
rundll32.exe cryptext.dll,CryptExtAddCER spc\icc301root.cer
exit
:no
exit