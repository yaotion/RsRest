; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=CTestDialog
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "czgocx.h"
CDK=Y

ClassCount=3
Class1=CCzgocxCtrl
Class2=CCzgocxPropPage

ResourceCount=3
Resource1=IDD_PROPPAGE_CZGOCX
LastPage=0
Resource2=IDD_ABOUTBOX_CZGOCX
Class3=CTestDialog
Resource3=IDD_TEST_DIALOG

[CLS:CCzgocxCtrl]
Type=0
HeaderFile=CzgocxCtl.h
ImplementationFile=CzgocxCtl.cpp
Filter=W
LastObject=CCzgocxCtrl
BaseClass=COleControl
VirtualFilter=wWC

[CLS:CCzgocxPropPage]
Type=0
HeaderFile=CzgocxPpg.h
ImplementationFile=CzgocxPpg.cpp
Filter=D

[DLG:IDD_ABOUTBOX_CZGOCX]
Type=1
Class=?
ControlCount=4
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308352
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889

[DLG:IDD_PROPPAGE_CZGOCX]
Type=1
Class=CCzgocxPropPage
ControlCount=1
Control1=IDC_STATIC,static,1342308352

[DLG:IDD_TEST_DIALOG]
Type=1
Class=CTestDialog
ControlCount=15
Control1=IDC_OPENDEV,button,1342242816
Control2=IDC_CLOSEDEV,button,1342242816
Control3=IDC_CCSTATUS,edit,1353777348
Control4=IDC_CC301,button,1342177287
Control5=IDC_DISABLERING,button,1342242819
Control6=IDC_STARTRING,button,1342242819
Control7=IDC_CCGROUP,button,1342177287
Control8=IDC_SETCCSERVER,button,1342242816
Control9=IDC_LOGON,button,1342242816
Control10=IDC_LOGOFF,button,1342242816
Control11=IDC_ANSWERCALL,button,1342242816
Control12=IDC_REJECTCALL,button,1342242816
Control13=IDC_STOP,button,1342242816
Control14=IDC_S,static,1342308352
Control15=IDC_SELECTLINE,combobox,1344339971

[CLS:CTestDialog]
Type=0
HeaderFile=TestDialog.h
ImplementationFile=TestDialog.cpp
BaseClass=CDialog
Filter=D
LastObject=CTestDialog
VirtualFilter=dWC

