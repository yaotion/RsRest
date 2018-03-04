; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
ClassCount=4
ResourceCount=4
NewFileInclude1=#include "stdafx.h"
Class1=CRecvFaxDialog
LastClass=CRecvFaxDialog
LastTemplate=CDialog
Resource1=IDD_FAXLOG_DIALOG
Class2=CSendFaxDialog
Resource2=IDD_SENDFAX_DIALOG
Class3=CFaxLogDialog
Resource3=IDD_RECVFAX_DIALOG
Class4=CFaxTooltip
Resource4=IDD_FAXTOOLTIP_DIALOG

[DLG:IDD_RECVFAX_DIALOG]
Type=1
Class=CRecvFaxDialog
ControlCount=10
Control1=IDOK,button,1073807361
Control2=IDCANCEL,button,1342242816
Control3=IDC_STSTATE,static,1342308865
Control4=IDC_STATIC,static,1342177287
Control5=IDC_STATIC,static,1342308352
Control6=IDC_VIEWRECVFILE,button,1476460544
Control7=IDC_FILEPATH,edit,1350633600
Control8=IDC_DOPLAY,button,1342242819
Control9=IDC_STELAPSE,static,1342308866
Control10=IDC_OPENDIR,button,1476460544

[CLS:CRecvFaxDialog]
Type=0
HeaderFile=RecvFaxDialog.h
ImplementationFile=RecvFaxDialog.cpp
BaseClass=CDialog
Filter=D
VirtualFilter=dWC
LastObject=IDC_OPENDIR

[DLG:IDD_SENDFAX_DIALOG]
Type=1
Class=CSendFaxDialog
ControlCount=10
Control1=IDOK,button,1073807361
Control2=IDCANCEL,button,1342242816
Control3=IDC_STATIC,static,1342308352
Control4=IDC_VIEWSENDFILE,button,1342242816
Control5=IDC_SENDSTATE,static,1342308865
Control6=IDC_STATIC,static,1342177287
Control7=IDC_SENDFILEPATH,edit,1350633600
Control8=IDC_DOPLAY,button,1342242819
Control9=IDC_STELAPSE,static,1342308866
Control10=IDC_SENDPROGRESS,msctls_progress32,1342177280

[CLS:CSendFaxDialog]
Type=0
HeaderFile=SendFaxDialog.h
ImplementationFile=SendFaxDialog.cpp
BaseClass=CDialog
Filter=D
LastObject=IDC_SENDPROGRESS
VirtualFilter=dWC

[DLG:IDD_FAXLOG_DIALOG]
Type=1
Class=CFaxLogDialog
ControlCount=13
Control1=IDOK,button,1073807361
Control2=IDCANCEL,button,1073807360
Control3=IDC_FAXLOGLIST,SysListView32,1350631433
Control4=IDC_STATIC,static,1342308352
Control5=IDC_STATIC,static,1342308352
Control6=IDC_BEGINDATE,SysDateTimePick32,1342242848
Control7=IDC_ENDDATE,SysDateTimePick32,1342242848
Control8=IDC_SEARCH,button,1342242816
Control9=IDC_FIRST,button,1476460544
Control10=IDC_PREV,button,1476460544
Control11=IDC_NEXT,button,1476460544
Control12=IDC_LAST,button,1476460544
Control13=IDC_STPAGE,static,1342308866

[CLS:CFaxLogDialog]
Type=0
HeaderFile=FaxLogDialog.h
ImplementationFile=FaxLogDialog.cpp
BaseClass=CDialog
Filter=D
VirtualFilter=dWC
LastObject=CFaxLogDialog

[DLG:IDD_FAXTOOLTIP_DIALOG]
Type=1
Class=CFaxTooltip
ControlCount=4
Control1=IDOK,button,1342242817
Control2=IDCANCEL,button,1342242816
Control3=IDC_STATIC,static,1342177287
Control4=IDC_STATIC,static,1342308352

[CLS:CFaxTooltip]
Type=0
HeaderFile=FaxTooltip.h
ImplementationFile=FaxTooltip.cpp
BaseClass=CDialog
Filter=D
VirtualFilter=dWC
LastObject=CFaxTooltip

