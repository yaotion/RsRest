; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=CCCGateDlg
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "CCGate.h"

ClassCount=3
Class1=CCCGateApp
Class2=CCCGateDlg
Class3=CAboutDlg

ResourceCount=4
Resource1=IDD_CCGATE_DIALOG
Resource2=IDR_MAINFRAME
Resource3=IDD_ABOUTBOX
Resource4=IDR_MENU1

[CLS:CCCGateApp]
Type=0
HeaderFile=CCGate.h
ImplementationFile=CCGate.cpp
Filter=N

[CLS:CCCGateDlg]
Type=0
HeaderFile=CCGateDlg.h
ImplementationFile=CCGateDlg.cpp
Filter=D
BaseClass=CDialog
VirtualFilter=dWC
LastObject=IDC_DESTCC

[CLS:CAboutDlg]
Type=0
HeaderFile=CCGateDlg.h
ImplementationFile=CCGateDlg.cpp
Filter=D

[DLG:IDD_ABOUTBOX]
Type=1
Class=CAboutDlg
ControlCount=4
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308480
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889

[DLG:IDD_CCGATE_DIALOG]
Type=1
Class=CCCGateDlg
ControlCount=19
Control1=IDOK,button,1342242817
Control2=IDCANCEL,button,1342242816
Control3=IDC_STATIC,static,1342308352
Control4=IDC_DESTCC,edit,1350631552
Control5=IDC_STATIC,button,1342177287
Control6=IDC_GATESTATUS,edit,1353777348
Control7=IDC_STATIC,static,1342308352
Control8=IDC_CC,edit,1350631552
Control9=IDC_STATIC,static,1342308352
Control10=IDC_PWD,edit,1350631584
Control11=IDC_LOGON,button,1342242816
Control12=IDC_LOGOUT,button,1342242816
Control13=IDC_STATIC,button,1342177287
Control14=IDC_STATIC,static,1342308352
Control15=IDC_SERVER,edit,1350631552
Control16=IDC_SETSERVER,button,1342242816
Control17=IDC_STATIC,static,1342308352
Control18=IDC_STATIC,static,1342308352
Control19=IDC_STATIC,button,1342177287

[MNU:IDR_MENU1]
Type=1
Class=?
Command1=ID_MENU_SETSERVER
Command2=ID_MENU_LOGINCC
Command3=ID_MENU_EXIT
CommandCount=3

