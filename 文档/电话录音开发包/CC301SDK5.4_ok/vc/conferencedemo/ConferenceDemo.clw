; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=CConferenceDemoDlg
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "ConferenceDemo.h"

ClassCount=4
Class1=CConferenceDemoApp
Class2=CConferenceDemoDlg
Class3=CAboutDlg

ResourceCount=4
Resource1=IDD_CONFERENCEDEMO_DIALOG
Resource2=IDR_MAINFRAME
Resource3=IDD_ABOUTBOX
Class4=CCreateConf
Resource4=IDD_CREATECONF_DIALOG

[CLS:CConferenceDemoApp]
Type=0
HeaderFile=ConferenceDemo.h
ImplementationFile=ConferenceDemo.cpp
Filter=N

[CLS:CConferenceDemoDlg]
Type=0
HeaderFile=ConferenceDemoDlg.h
ImplementationFile=ConferenceDemoDlg.cpp
Filter=D
BaseClass=CDialog
VirtualFilter=dWC
LastObject=IDC_SELECTLINE

[CLS:CAboutDlg]
Type=0
HeaderFile=ConferenceDemoDlg.h
ImplementationFile=ConferenceDemoDlg.cpp
Filter=D

[DLG:IDD_ABOUTBOX]
Type=1
Class=CAboutDlg
ControlCount=4
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308480
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889

[DLG:IDD_CONFERENCEDEMO_DIALOG]
Type=1
Class=CConferenceDemoDlg
ControlCount=34
Control1=IDOK,button,1342242817
Control2=IDCANCEL,button,1342242816
Control3=IDC_CONFSTATUS,edit,1353777348
Control4=IDC_CREATECONF,button,1342242816
Control5=IDC_STATIC,button,1342177287
Control6=IDC_STATIC,button,1342177287
Control7=IDC_CHANNELLIST,listbox,1352728835
Control8=IDC_STARTREC,button,1342242816
Control9=IDC_STOPREC,button,1342242816
Control10=IDC_SPKVOLUME,edit,1350631552
Control11=IDC_SETVOLUME,button,1342242816
Control12=IDC_PAUSE,button,1342242816
Control13=IDC_RESUME,button,1342242816
Control14=IDC_DISABLEMIC,button,1342242819
Control15=IDC_DISABLESPK,button,1342242819
Control16=IDC_STATIC,static,1342308352
Control17=IDC_STATIC,static,1342308352
Control18=IDC_MICVOLUME,edit,1350631552
Control19=IDC_DELCONF,button,1342242816
Control20=IDC_CONFLIST,SysListView32,1350664201
Control21=IDC_STATIC,button,1342177287
Control22=IDC_STATIC,static,1342308352
Control23=IDC_COMBOCHANNEL,combobox,1344339971
Control24=IDC_STATIC,button,1342177287
Control25=IDC_DOHOOK,button,1342242819
Control26=IDC_DIALCODE,edit,1350631552
Control27=IDC_DIAL,button,1342242816
Control28=IDC_STATIC,static,1342308352
Control29=IDC_DOPHONE,button,1342242819
Control30=IDC_ADBUSY,button,1342242819
Control31=IDC_STATIC,button,1342177287
Control32=IDC_STATIC,static,1342308352
Control33=IDC_STATIC,static,1342308352
Control34=IDC_SELECTLINE,combobox,1344339971

[DLG:IDD_CREATECONF_DIALOG]
Type=1
Class=CCreateConf
ControlCount=6
Control1=IDC_CONFNAME,edit,1350631552
Control2=IDC_CHANNELLIST,SysListView32,1350664201
Control3=IDOK,button,1342242817
Control4=IDCANCEL,button,1342242816
Control5=IDC_STATIC,static,1342308352
Control6=IDC_STATIC,static,1342308352

[CLS:CCreateConf]
Type=0
HeaderFile=CreateConf.h
ImplementationFile=CreateConf.cpp
BaseClass=CDialog
Filter=D
LastObject=IDC_CONFNAME
VirtualFilter=dWC

