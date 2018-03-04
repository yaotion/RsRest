; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=CSendFaxDialog
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "FaxDemo.h"

ClassCount=5
Class1=CFaxDemoApp
Class2=CFaxDemoDlg
Class3=CAboutDlg

ResourceCount=5
Resource1=IDD_RECVFAX_DIALOG
Resource2=IDR_MAINFRAME
Resource3=IDD_FAXDEMO_DIALOG
Resource4=IDD_ABOUTBOX
Class4=CRecvFaxDialog
Class5=CSendFaxDialog
Resource5=IDD_SENDFAX_DIALOG

[CLS:CFaxDemoApp]
Type=0
HeaderFile=FaxDemo.h
ImplementationFile=FaxDemo.cpp
Filter=N

[CLS:CFaxDemoDlg]
Type=0
HeaderFile=FaxDemoDlg.h
ImplementationFile=FaxDemoDlg.cpp
Filter=D
LastObject=CFaxDemoDlg
BaseClass=CDialog
VirtualFilter=dWC

[CLS:CAboutDlg]
Type=0
HeaderFile=FaxDemoDlg.h
ImplementationFile=FaxDemoDlg.cpp
Filter=D

[DLG:IDD_ABOUTBOX]
Type=1
Class=CAboutDlg
ControlCount=4
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308480
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889

[DLG:IDD_FAXDEMO_DIALOG]
Type=1
Class=CFaxDemoDlg
ControlCount=6
Control1=IDCANCEL,button,1342242816
Control2=IDC_DEVSTATUS,edit,1353777348
Control3=IDC_RECVFAX,button,1342242816
Control4=IDC_SENDFAX,button,1342242816
Control5=IDC_OPENDEV,button,1342242816
Control6=IDC_CLOSEDEV,button,1342242816

[DLG:IDD_RECVFAX_DIALOG]
Type=1
Class=CRecvFaxDialog
ControlCount=8
Control1=IDCANCEL,button,1342242816
Control2=IDC_STATIC,static,1342308352
Control3=IDC_RECVPATH,edit,1350631552
Control4=IDC_VIEW,button,1342242816
Control5=IDC_STARTRECV,button,1342242816
Control6=IDC_STOPRECV,button,1342242816
Control7=IDC_OPENDOPLAY,button,1342242819
Control8=IDC_STSTATUS,static,1342308864

[DLG:IDD_SENDFAX_DIALOG]
Type=1
Class=CSendFaxDialog
ControlCount=9
Control1=IDCANCEL,button,1342242816
Control2=IDC_VIEWSEND,button,1342242816
Control3=IDC_SENDPATH,edit,1350631552
Control4=IDC_STATIC,static,1342308352
Control5=IDC_BROWSER,button,1342242816
Control6=IDC_OPENDOPLAY,button,1342242819
Control7=IDC_STSTATUS,static,1342308864
Control8=IDC_STARTSEND,button,1342242816
Control9=IDC_STOPSEND,button,1342242816

[CLS:CRecvFaxDialog]
Type=0
HeaderFile=RecvFaxDialog.h
ImplementationFile=RecvFaxDialog.cpp
BaseClass=CDialog
Filter=D
LastObject=CRecvFaxDialog
VirtualFilter=dWC

[CLS:CSendFaxDialog]
Type=0
HeaderFile=SendFaxDialog.h
ImplementationFile=SendFaxDialog.cpp
BaseClass=CDialog
Filter=D
LastObject=IDC_SENDPATH
VirtualFilter=dWC

