; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=CDialNotifyDlg
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "DialNotify.h"

ClassCount=3
Class1=CDialNotifyApp
Class2=CDialNotifyDlg
Class3=CAboutDlg

ResourceCount=3
Resource1=IDD_ABOUTBOX
Resource2=IDR_MAINFRAME
Resource3=IDD_DIALNOTIFY_DIALOG

[CLS:CDialNotifyApp]
Type=0
HeaderFile=DialNotify.h
ImplementationFile=DialNotify.cpp
Filter=N

[CLS:CDialNotifyDlg]
Type=0
HeaderFile=DialNotifyDlg.h
ImplementationFile=DialNotifyDlg.cpp
Filter=D
LastObject=CDialNotifyDlg
BaseClass=CDialog
VirtualFilter=dWC

[CLS:CAboutDlg]
Type=0
HeaderFile=DialNotifyDlg.h
ImplementationFile=DialNotifyDlg.cpp
Filter=D

[DLG:IDD_ABOUTBOX]
Type=1
Class=CAboutDlg
ControlCount=4
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308480
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889

[DLG:IDD_DIALNOTIFY_DIALOG]
Type=1
Class=CDialNotifyDlg
ControlCount=13
Control1=IDOK,button,1073807361
Control2=IDCANCEL,button,1342242816
Control3=IDC_DIALLIST,listbox,1352728833
Control4=IDC_STARTDIAL,button,1342242816
Control5=IDC_STATIC,button,1342177287
Control6=IDC_STATIC,static,1342308352
Control7=IDC_FILEPATH,edit,1350633600
Control8=IDC_SELECTFILE,button,1342242816
Control9=IDC_STATIC,button,1342177287
Control10=IDC_FINISHLIST,listbox,1352728833
Control11=IDC_STOPDIAL,button,1342242816
Control12=IDC_DIALLOG,edit,1353785540
Control13=IDC_STATIC,button,1342177287

