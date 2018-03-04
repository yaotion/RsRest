; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=CDialoutDlg
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "dialout.h"

ClassCount=3
Class1=CDialoutApp
Class2=CDialoutDlg
Class3=CAboutDlg

ResourceCount=3
Resource1=IDD_ABOUTBOX
Resource2=IDR_MAINFRAME
Resource3=IDD_DIALOUT_DIALOG

[CLS:CDialoutApp]
Type=0
HeaderFile=dialout.h
ImplementationFile=dialout.cpp
Filter=N

[CLS:CDialoutDlg]
Type=0
HeaderFile=dialoutDlg.h
ImplementationFile=dialoutDlg.cpp
Filter=D
BaseClass=CDialog
VirtualFilter=dWC
LastObject=IDC_CODE

[CLS:CAboutDlg]
Type=0
HeaderFile=dialoutDlg.h
ImplementationFile=dialoutDlg.cpp
Filter=D

[DLG:IDD_ABOUTBOX]
Type=1
Class=CAboutDlg
ControlCount=4
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308480
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889

[DLG:IDD_DIALOUT_DIALOG]
Type=1
Class=CDialoutDlg
ControlCount=9
Control1=IDCANCEL,button,1342242816
Control2=IDC_STATIC,static,1342308352
Control3=IDC_CHID,edit,1350631552
Control4=IDC_STATIC,static,1342308352
Control5=IDC_CODE,edit,1350631552
Control6=IDC_STARTDIAL,button,1342242816
Control7=IDC_HANGUP,button,1342242816
Control8=IDC_DEVSTATUS,edit,1353777348
Control9=IDC_HOOK,button,1342242816

