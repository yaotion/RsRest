# Microsoft Developer Studio Project File - Name="qnviccubdemo" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Application" 0x0101

CFG=qnviccubdemo - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "qnviccubdemo.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "qnviccubdemo.mak" CFG="qnviccubdemo - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "qnviccubdemo - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "qnviccubdemo - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "qnviccubdemo - Win32 Release"

# PROP BASE Use_MFC 6
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 6
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /Yu"stdafx.h" /FD /c
# ADD CPP /nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR /Yu"stdafx.h" /FD /c
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x804 /d "NDEBUG" /d "_AFXDLL"
# ADD RSC /l 0x804 /d "NDEBUG" /d "_AFXDLL"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /subsystem:windows /machine:I386
# ADD LINK32 /nologo /subsystem:windows /machine:I386 /out:"../../../bin/qnviccubdemo.exe"

!ELSEIF  "$(CFG)" == "qnviccubdemo - Win32 Debug"

# PROP BASE Use_MFC 6
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 6
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MDd /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /Yu"stdafx.h" /FD /GZ /c
# ADD CPP /nologo /MDd /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR /Yu"stdafx.h" /FD /GZ /c
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x804 /d "_DEBUG" /d "_AFXDLL"
# ADD RSC /l 0x804 /d "_DEBUG" /d "_AFXDLL"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /subsystem:windows /debug /machine:I386 /pdbtype:sept
# ADD LINK32 /nologo /subsystem:windows /debug /machine:I386 /out:"../../../bin/qnviccubdemod.exe" /pdbtype:sept
# SUBTRACT LINK32 /nodefaultlib

!ENDIF 

# Begin Target

# Name "qnviccubdemo - Win32 Release"
# Name "qnviccubdemo - Win32 Debug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Source File

SOURCE=.\BriWaveFormat.cpp
# End Source File
# Begin Source File

SOURCE=.\Broadcast.cpp
# End Source File
# Begin Source File

SOURCE=.\CCModule.cpp
# End Source File
# Begin Source File

SOURCE=.\ChannelCtrl.cpp
# End Source File
# Begin Source File

SOURCE=.\CheckLine.cpp
# End Source File
# Begin Source File

SOURCE=.\Conference.cpp
# End Source File
# Begin Source File

SOURCE=.\FaxModule.cpp
# End Source File
# Begin Source File

SOURCE=.\FileTransfer.cpp
# End Source File
# Begin Source File

SOURCE=.\InputIP.cpp
# End Source File
# Begin Source File

SOURCE=.\InputRemote.cpp
# End Source File
# Begin Source File

SOURCE=.\InputTTS.cpp
# End Source File
# Begin Source File

SOURCE=.\MediaPlay.cpp
# End Source File
# Begin Source File

SOURCE=.\MediaplayBuf.cpp
# End Source File
# Begin Source File

SOURCE=.\qnvfiletransfer.cpp
# End Source File
# Begin Source File

SOURCE=.\qnviccubdemo.cpp
# End Source File
# Begin Source File

SOURCE=.\qnviccubdemo.rc
# End Source File
# Begin Source File

SOURCE=.\qnviccubdemoDlg.cpp
# End Source File
# Begin Source File

SOURCE=.\RecvBroad.cpp
# End Source File
# Begin Source File

SOURCE=.\Remote.cpp
# End Source File
# Begin Source File

SOURCE=.\SelectMultiFile.cpp
# End Source File
# Begin Source File

SOURCE=.\SocketClient.cpp
# End Source File
# Begin Source File

SOURCE=.\SocketUDP.cpp
# End Source File
# Begin Source File

SOURCE=.\Speech.cpp
# End Source File
# Begin Source File

SOURCE=.\StdAfx.cpp
# ADD CPP /Yc"stdafx.h"
# End Source File
# Begin Source File

SOURCE=.\Storage.cpp
# End Source File
# Begin Source File

SOURCE=.\Tools.cpp
# End Source File
# Begin Source File

SOURCE=.\WaveFormat.cpp
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# Begin Source File

SOURCE=.\BriWaveFormat.h
# End Source File
# Begin Source File

SOURCE=.\Broadcast.h
# End Source File
# Begin Source File

SOURCE=.\CCModule.h
# End Source File
# Begin Source File

SOURCE=.\ChannelCtrl.h
# End Source File
# Begin Source File

SOURCE=.\CheckLine.h
# End Source File
# Begin Source File

SOURCE=.\Conference.h
# End Source File
# Begin Source File

SOURCE=.\FaxModule.h
# End Source File
# Begin Source File

SOURCE=.\FileTransfer.h
# End Source File
# Begin Source File

SOURCE=.\InputIP.h
# End Source File
# Begin Source File

SOURCE=.\InputRemote.h
# End Source File
# Begin Source File

SOURCE=.\InputTTS.h
# End Source File
# Begin Source File

SOURCE=.\MediaPlay.h
# End Source File
# Begin Source File

SOURCE=.\MediaplayBuf.h
# End Source File
# Begin Source File

SOURCE=.\qnvfiletransfer.h
# End Source File
# Begin Source File

SOURCE=.\qnviccubdemo.h
# End Source File
# Begin Source File

SOURCE=.\qnviccubdemoDlg.h
# End Source File
# Begin Source File

SOURCE=.\RecvBroad.h
# End Source File
# Begin Source File

SOURCE=.\Remote.h
# End Source File
# Begin Source File

SOURCE=.\Resource.h
# End Source File
# Begin Source File

SOURCE=.\SelectMultiFile.h
# End Source File
# Begin Source File

SOURCE=.\SocketClient.h
# End Source File
# Begin Source File

SOURCE=.\SocketUDP.h
# End Source File
# Begin Source File

SOURCE=.\Speech.h
# End Source File
# Begin Source File

SOURCE=.\StdAfx.h
# End Source File
# Begin Source File

SOURCE=.\Storage.h
# End Source File
# Begin Source File

SOURCE=.\Tools.h
# End Source File
# Begin Source File

SOURCE=.\WaveFormat.h
# End Source File
# End Group
# Begin Group "Resource Files"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe"
# Begin Source File

SOURCE=.\res\qnviccubdemo.ico
# End Source File
# Begin Source File

SOURCE=.\res\qnviccubdemo.rc2
# End Source File
# End Group
# Begin Source File

SOURCE=.\ReadMe.txt
# End Source File
# End Target
# End Project
# Section qnviccubdemo : {4453740F-D970-4021-89AC-41DC6F704C26}
# 	2:21:DefaultSinkHeaderFile:qnvfiletransfer.h
# 	2:16:DefaultSinkClass:Cqnvfiletransfer
# End Section
# Section qnviccubdemo : {0CF2C656-7A4F-4CA9-9959-8375D1C38560}
# 	2:5:Class:Cqnvfiletransfer
# 	2:10:HeaderFile:qnvfiletransfer.h
# 	2:8:ImplFile:qnvfiletransfer.cpp
# End Section
