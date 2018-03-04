; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=CContact
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "ccdemo.h"

ClassCount=14
Class1=CCcdemoApp
Class2=CCcdemoDlg
Class3=CAboutDlg

ResourceCount=15
Resource1=IDD_REGCC_DIALOG
Resource2=IDR_MAINFRAME
Resource3=IDD_INPUTSVRIP_DIALOG
Class4=CCCMsg
Resource4=IDD_CONTACT_DIALOG
Resource5=IDD_SENDFILE_DIALOG
Class5=CCCCmd
Resource6=IDD_INPUTCC_DIALOG
Class6=CRegCC
Resource7=IDD_CCMSG_DIALOG
Class7=CLoginCC
Resource8=IDD_CCCALL_DIALOG
Class8=CInputSvrIP
Resource9=IDD_CCDEMO_DIALOG
Class9=CCCCall
Resource10=IDD_FILETRANS_DIALOG
Class10=CInputCC
Resource11=IDD_RECVFILE_DIALOG
Resource12=IDD_CCCMD_DIALOG
Class11=CSendFile
Class12=CRecvFile
Resource13=IDD_ABOUTBOX
Class13=CFileTrans
Resource14=IDD_LOGINCC_DIALOG
Class14=CContact
Resource15=IDR_MENU1

[CLS:CCcdemoApp]
Type=0
HeaderFile=ccdemo.h
ImplementationFile=ccdemo.cpp
Filter=N

[CLS:CCcdemoDlg]
Type=0
HeaderFile=ccdemoDlg.h
ImplementationFile=ccdemoDlg.cpp
Filter=D
BaseClass=CDialog
VirtualFilter=dWC
LastObject=CCcdemoDlg

[CLS:CAboutDlg]
Type=0
HeaderFile=ccdemoDlg.h
ImplementationFile=ccdemoDlg.cpp
Filter=D

[DLG:IDD_ABOUTBOX]
Type=1
Class=CAboutDlg
ControlCount=4
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308480
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889

[DLG:IDD_CCDEMO_DIALOG]
Type=1
Class=CCcdemoDlg
ControlCount=2
Control1=IDCANCEL,button,1342242816
Control2=IDC_CCSTATUS,edit,1353777348

[DLG:IDD_CCMSG_DIALOG]
Type=1
Class=CCCMsg
ControlCount=6
Control1=IDC_STATIC,static,1342308352
Control2=IDC_CCSENDVIEW,edit,1352728772
Control3=IDC_SENDMSG,button,1342242816
Control4=IDC_CCRECVVIEW,edit,1353777348
Control5=IDC_STATIC,static,1342308352
Control6=IDC_DESTCC,edit,1350631552

[CLS:CCCMsg]
Type=0
HeaderFile=CCMsg.h
ImplementationFile=CCMsg.cpp
BaseClass=CDialog
Filter=D
VirtualFilter=dWC
LastObject=IDC_DESTCC

[MNU:IDR_MENU1]
Type=1
Class=?
Command1=ID_MENU_LOGINCC
Command2=ID_MENU_OFFLINE
Command3=ID_MENU_REGCC
Command4=ID_MENU_EXIT
Command5=ID_MENU_SENDMSG
Command6=ID_MENU_SENDCMD
Command7=ID_MENU_CALLCC
Command8=ID_MENU_SENDFILE
Command9=ID_MENU_CONTACT
Command10=ID_MENU_SETSERVER
CommandCount=10

[DLG:IDD_CCCMD_DIALOG]
Type=1
Class=CCCCmd
ControlCount=7
Control1=IDC_STATIC,static,1342308352
Control2=IDC_CCSENDCMD,edit,1352728772
Control3=IDC_SENDCMD,button,1342242816
Control4=IDC_CCRECVCMD,edit,1353777348
Control5=IDC_STATIC,static,1342308352
Control6=IDC_DESTCC,edit,1350631552
Control7=IDC_AUTOSAVE,button,1342242819

[CLS:CCCCmd]
Type=0
HeaderFile=CCCmd.h
ImplementationFile=CCCmd.cpp
BaseClass=CDialog
Filter=D
VirtualFilter=dWC
LastObject=IDC_CCRECVCMD

[DLG:IDD_REGCC_DIALOG]
Type=1
Class=CRegCC
ControlCount=13
Control1=IDC_REGCCNUM,edit,1350631552
Control2=IDC_REGPWD,edit,1350631584
Control3=IDC_REGNICK,edit,1350631552
Control4=IDC_SVRID,edit,1350631552
Control5=IDC_REG,button,1342242816
Control6=IDCANCEL,button,1342242816
Control7=IDC_STATIC,button,1342177287
Control8=IDC_STATIC,static,1342308352
Control9=IDC_STATIC,static,1342308352
Control10=IDC_STATIC,static,1342308352
Control11=IDC_STATIC,static,1342308352
Control12=IDC_STATIC,static,1342308352
Control13=IDC_STATIC,static,1342308352

[CLS:CRegCC]
Type=0
HeaderFile=RegCC.h
ImplementationFile=RegCC.cpp
BaseClass=CDialog
Filter=D
VirtualFilter=dWC
LastObject=CRegCC

[DLG:IDD_LOGINCC_DIALOG]
Type=1
Class=CLoginCC
ControlCount=8
Control1=IDC_CCNUMBER,edit,1350631552
Control2=IDC_CCPWD,edit,1350631584
Control3=IDC_LOGON,button,1342242816
Control4=IDCANCEL,button,1342242816
Control5=IDC_STATIC,button,1342177287
Control6=IDC_STATIC,static,1342308352
Control7=IDC_STATIC,static,1342308352
Control8=IDC_STATIC,static,1342308352

[CLS:CLoginCC]
Type=0
HeaderFile=LoginCC.h
ImplementationFile=LoginCC.cpp
BaseClass=CDialog
Filter=D
LastObject=IDC_CCNUMBER
VirtualFilter=dWC

[DLG:IDD_INPUTSVRIP_DIALOG]
Type=1
Class=CInputSvrIP
ControlCount=6
Control1=IDC_SVRIP,edit,1350631552
Control2=IDOK,button,1342242817
Control3=IDCANCEL,button,1342242816
Control4=IDC_STATIC,static,1342308352
Control5=IDC_STATIC,static,1342308352
Control6=IDC_STATIC,button,1342177287

[CLS:CInputSvrIP]
Type=0
HeaderFile=InputSvrIP.h
ImplementationFile=InputSvrIP.cpp
BaseClass=CDialog
Filter=D
VirtualFilter=dWC
LastObject=CInputSvrIP

[DLG:IDD_CCCALL_DIALOG]
Type=1
Class=CCCCall
ControlCount=14
Control1=IDCANCEL,button,1342242816
Control2=IDC_CALLLIST,SysListView32,1350631437
Control3=IDC_CALLSTATUS,edit,1353777348
Control4=IDC_ANSWER,button,1342242816
Control5=IDC_REFUSE,button,1342242816
Control6=IDC_BUSY,button,1342242816
Control7=IDC_STOP,button,1342242816
Control8=IDC_STARTPLAYFILE,button,1342242816
Control9=IDC_STOPPLAYFILE,button,1342242816
Control10=IDC_STARTRECORDFILE,button,1342242816
Control11=IDC_STOPFILERECORD,button,1342242816
Control12=IDC_HOLD,button,1342242816
Control13=IDC_UNHOLD,button,1342242816
Control14=IDC_SWITCH,button,1342242816

[CLS:CCCCall]
Type=0
HeaderFile=CCCall.h
ImplementationFile=CCCall.cpp
BaseClass=CDialog
Filter=D
LastObject=CCCCall
VirtualFilter=dWC

[DLG:IDD_INPUTCC_DIALOG]
Type=1
Class=CInputCC
ControlCount=5
Control1=IDC_CC,edit,1350631552
Control2=IDOK,button,1342242817
Control3=IDCANCEL,button,1342242816
Control4=IDC_STATIC,button,1342177287
Control5=IDC_STATIC,static,1342308352

[CLS:CInputCC]
Type=0
HeaderFile=InputCC.h
ImplementationFile=InputCC.cpp
BaseClass=CDialog
Filter=D
VirtualFilter=dWC
LastObject=CInputCC

[DLG:IDD_SENDFILE_DIALOG]
Type=1
Class=CSendFile
ControlCount=8
Control1=IDC_DESTCC,edit,1350631552
Control2=IDC_FIELPATH,edit,1350631552
Control3=IDC_SELECTFILE,button,1342242816
Control4=IDOK,button,1342242817
Control5=IDCANCEL,button,1342242816
Control6=IDC_STATIC,static,1342308352
Control7=IDC_STATIC,static,1342308352
Control8=IDC_STATIC,button,1342177287

[DLG:IDD_RECVFILE_DIALOG]
Type=1
Class=CRecvFile
ControlCount=4
Control1=IDOK,button,1342242817
Control2=IDCANCEL,button,1342242816
Control3=IDC_STATIC,static,1342308865
Control4=IDC_STATIC,button,1342177287

[CLS:CSendFile]
Type=0
HeaderFile=SendFile.h
ImplementationFile=SendFile.cpp
BaseClass=CDialog
Filter=D
LastObject=CSendFile
VirtualFilter=dWC

[CLS:CRecvFile]
Type=0
HeaderFile=RecvFile.h
ImplementationFile=RecvFile.cpp
BaseClass=CDialog
Filter=D
LastObject=CRecvFile
VirtualFilter=dWC

[DLG:IDD_FILETRANS_DIALOG]
Type=1
Class=CFileTrans
ControlCount=8
Control1=IDCANCEL,button,1342242816
Control2=IDC_FILELIST,SysListView32,1350631437
Control3=IDC_STOP,button,1342242816
Control4=IDC_FILESTATUS,edit,1353777348
Control5=IDC_REFUSEFILE,button,1342242816
Control6=IDC_SAVE,button,1342242816
Control7=IDC_SHOWWIN,button,1342242816
Control8=IDC_HIDEWIN,button,1342242816

[CLS:CFileTrans]
Type=0
HeaderFile=FileTrans.h
ImplementationFile=FileTrans.cpp
BaseClass=CDialog
Filter=D
VirtualFilter=dWC
LastObject=CFileTrans

[DLG:IDD_CONTACT_DIALOG]
Type=1
Class=CContact
ControlCount=7
Control1=IDOK,button,1073807361
Control2=IDCANCEL,button,1342242816
Control3=IDC_ADD,button,1342242816
Control4=IDC_DEL,button,1342242816
Control5=IDC_CC,edit,1350631552
Control6=IDC_STATIC,button,1342177287
Control7=IDC_STATIC,static,1342308352

[CLS:CContact]
Type=0
HeaderFile=Contact.h
ImplementationFile=Contact.cpp
BaseClass=CDialog
Filter=D
LastObject=IDC_ADD
VirtualFilter=dWC

