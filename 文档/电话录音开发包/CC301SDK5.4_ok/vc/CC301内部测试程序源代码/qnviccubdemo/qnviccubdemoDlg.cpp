// qnviccubdemoDlg.cpp : implementation file
//

#include "stdafx.h"
#include "qnviccubdemo.h"
#include "qnviccubdemoDlg.h"
#include "SocketUDP.h"
#include "storage.h"
#include <math.h>
#include <imagehlp.h>
#pragma comment(lib,"imagehlp.lib")

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// Dialog Data
	//{{AFX_DATA(CAboutDlg)
	enum { IDD = IDD_ABOUTBOX };
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAboutDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	//{{AFX_MSG(CAboutDlg)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
	//{{AFX_DATA_INIT(CAboutDlg)
	//}}AFX_DATA_INIT
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CAboutDlg)
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
	//{{AFX_MSG_MAP(CAboutDlg)
		// No message handlers
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CQnviccubdemoDlg dialog

CQnviccubdemoDlg::CQnviccubdemoDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CQnviccubdemoDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CQnviccubdemoDlg)
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
	m_pConference = NULL;
	m_pCCModule	  = NULL;
	m_pBroadcast  = NULL;
	m_pRecvBroad  = NULL;	
}

void CQnviccubdemoDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CQnviccubdemoDlg)
	DDX_Control(pDX, IDC_DEVSTATUS, m_cDevStatus);
	DDX_Control(pDX, IDC_STSEAP2, m_cStseap2);
	DDX_Control(pDX, IDCANCEL, m_cancel);
	DDX_Control(pDX, IDC_STSEAP, m_cStSeap);
	DDX_Control(pDX, IDC_STCHIPTYPE, m_cChipType);
	DDX_Control(pDX, IDC_CLOSEDEV, m_closedev);
	DDX_Control(pDX, IDC_OPENDEV, m_opendev);
	DDX_Control(pDX, IDC_CHANNELLIST, m_cChannelList);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CQnviccubdemoDlg, CDialog)
	//{{AFX_MSG_MAP(CQnviccubdemoDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_OPENDEV, OnOpendev)
	ON_BN_CLICKED(IDC_CLOSEDEV, OnClosedev)
	ON_WM_DESTROY()
	ON_CBN_SELCHANGE(IDC_CHANNELLIST, OnSelchangeChannellist)
	ON_WM_SIZE()
	ON_BN_CLICKED(IDC_OPENREMOTE, OnOpenremote)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CQnviccubdemoDlg message handlers

BOOL CQnviccubdemoDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	
	srand(time(NULL));	
	SetWindowText((CString)"CC301内部测试程序 V"+_VER_TEXT_);

	CTime ct=CTime::GetCurrentTime();
	CString strLog;
	strLog.Format("%slog\\%04d%02d%02d%02d%02dlog.txt",GetModulePath(),ct.GetYear(),ct.GetMonth(),ct.GetDay(),ct.GetHour(),ct.GetMinute(),ct.GetSecond());
	MakeSureDirectoryPathExists(strLog);
	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

CString CQnviccubdemoDlg::GetModulePath()
{
	char szSourcePath[_MAX_PATH];
	GetModuleFileName(NULL, szSourcePath, _MAX_PATH); 
    *(strrchr(szSourcePath, '\\') + 1) = '\0';          
	CString RetStr=szSourcePath;
	return RetStr;
}

void CQnviccubdemoDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CQnviccubdemoDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, (WPARAM) dc.GetSafeHdc(), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

// The system calls this to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CQnviccubdemoDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void CQnviccubdemoDlg::DeleteAllChannelCtrl()
{
	for(int i=0;i<m_ChannelCtrlArray.GetSize();i++)
	{
		m_ChannelCtrlArray[i]->FreeSource();
		delete m_ChannelCtrlArray[i];
	}
	m_ChannelCtrlArray.RemoveAll();
}
        
CString CQnviccubdemoDlg::GetModule(BRIINT16 chID)
{
	CString strModule,str;
	long lModule=QNV_DevInfo(chID,QNV_DEVINFO_GETMODULE);
	str.Format("(0x%x)/",lModule);
	strModule+=str;
	if(lModule&DEVMODULE_DOPLAY) strModule+="有喇叭/";
	if(lModule&DEVMODULE_CALLID) strModule+="有来电显示/";
	if(lModule&DEVMODULE_PHONE) strModule+="话机拨号/";
	if(lModule&DEVMODULE_SWITCH) strModule+="断开电话机,接收话机按键/";
	if(lModule&DEVMODULE_PLAY2TEL) strModule+="播放语音到电话机/";
	if(lModule&DEVMODULE_HOOK) strModule+="软摘机/";
	if(lModule&DEVMODULE_MICSPK) strModule+="有耳机/MIC/";
	if(lModule&DEVMODULE_RING) strModule+="模拟话机震铃/";
	if(lModule&DEVMODULE_STORAGE) strModule+="FLASH数据存储/";
	if(lModule&DEVMODULE_FAX) strModule+="收发传真/";
	if(lModule&DEVMODULE_POLARITY) strModule+="反级检测/";	
	return strModule;
}

CString CQnviccubdemoDlg::GetDevType(long lDevType)
{
	CString str;
	str.Format("0x%x",lDevType);
	switch(lDevType)
	{
	case DEVTYPE_T1:str+="(cc301 T1)";break;
	case DEVTYPE_T2:str+="(cc301 T2)";break;
	case DEVTYPE_T3:str+="(cc301 T3)";break;
	case DEVTYPE_T4:str+="(cc301 T4)";break;	
	case DEVTYPE_T5:str+="(cc301 T5)";break;
	case DEVTYPE_T6:str+="(cc301 T6)";break;	
	case DEVTYPE_IR1:str+="(cc301 IR1)";break;
	case DEVTYPE_ID1:str+="(cc301 ID1)";break;
	case DEVTYPE_IP1:str+="(cc301 IP1)";break;
	case DEVTYPE_IA1:str+="(cc301 IA1)";break;
	case DEVTYPE_IA2:str+="(cc301 IA2)";break;
	case DEVTYPE_IA3:str+="(cc301 IA3)";break;
	case DEVTYPE_IA4:str+="(cc301 IA4)";break;
	case DEVTYPE_IB1:str+="(cc301 IB1)";break;
	case DEVTYPE_IB2:str+="(cc301 IB2)";break;
	case DEVTYPE_IB3:str+="(cc301 IB3)";break;
	case DEVTYPE_IB4:str+="(cc301 IB4)";break;
	case DEVTYPE_IP1_F:str+="(cc301 IP1_F)";break;
	case DEVTYPE_IA4_F:str+="(cc301 IA4_F)";break;
	case DEVTYPE_IC2_R:str+="(cc301 IC2_R)";break;
	case DEVTYPE_IC2_LP:str+="(cc301 IC2_LP)";break;
	case DEVTYPE_IC2_LPQ:str+="(cc301 IC2_LPQ)";break;
	case DEVTYPE_IC2_LPF:str+="(cc301 IC2_LPF)";break;
	case DEVTYPE_IC4_R:str+="(cc301 IC4_R)";break;
	case DEVTYPE_IC4_LP:str+="(cc301 IC4_LP)";break;
	case DEVTYPE_IC4_LPQ:str+="(cc301 IC4_LPQ)";break;
	case DEVTYPE_IC4_LPF:str+="(cc301 IC4_LPF)";break;
	case DEVTYPE_IC7_R:str+="(cc301 IC7_R)";break;
	case DEVTYPE_IC7_LP:str+="(cc301 IC7_LP)";break;
	case DEVTYPE_IC7_LPQ:str+="(cc301 IC7_LPQ)";break;
	case DEVTYPE_IC7_LPF:str+="(cc301 IC7_LPF)";break;
	case DEVTYPE_A1:str+="(玻瑞器 A1)";break;
	case DEVTYPE_A2:str+="(玻瑞器 A2)";break;
	case DEVTYPE_A3:str+="(玻瑞器 A3)";break;
	case DEVTYPE_A4:str+="(玻瑞器 A4)";break;
	case DEVTYPE_B1:str+="(玻瑞器 B1)";break;
	case DEVTYPE_B2:str+="(玻瑞器 B2)";break;
	case DEVTYPE_B3:str+="(玻瑞器 B3)";break;
	case DEVTYPE_B4:str+="(玻瑞器 B4)";break;
	case DEVTYPE_C4_L:str+="(玻瑞器 C4-L)";break;
	case DEVTYPE_C4_P:str+="(玻瑞器 C4-P)";break;
	case DEVTYPE_C4_LP:str+="(玻瑞器 C4-LP)";break;
	case DEVTYPE_C4_LPQ:str+="(玻瑞器 C4-LPQ)";break;
	case DEVTYPE_C7_L:str+="(玻瑞器 C7-L)";break;
	case DEVTYPE_C7_P:str+="(玻瑞器 C7-P)";break;
	case DEVTYPE_C7_LP:str+="(玻瑞器 C7-LP)";break;
	case DEVTYPE_C7_LPQ:str+="(玻瑞器 C7-LPQ)";break;
	case DEVTYPE_R1:str+="(玻瑞器 R1)";break;
	case DEVTYPE_C4_R:str+="(玻瑞器 C4-R)";break;
	case DEVTYPE_C7_R:str+="(玻瑞器 C7-R)";break;
	default:
		{
		}break;
	}
	return str;
}

void	CQnviccubdemoDlg::InitDevInfo()
{
	CString str,strInfo,strFileVersion;
	strFileVersion = (char*)QNV_DevInfo(0,QNV_DEVINFO_FILEVERSION);
	str.Format("打开设备成功(%s/%s) 通道数=%d 设备数=%d",_VER_TEXT_,strFileVersion,QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS),QNV_DevInfo(0,QNV_DEVINFO_GETCHIPS));
	//str.Format("打开设备成功(%s/%d) 通道数=%d 设备数=%d",_VER_TEXT_,QNV_DevInfo(0,QNV_DEVINFO_FILEVERSIONL),QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS),QNV_DevInfo(0,QNV_DEVINFO_GETCHIPS));
	AppendStatus(str);
	for(BRIINT16 i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{
		str.Format("%d",i+1);
		m_cChannelList.AddString(str);
		CChannelCtrl *pChannel=new CChannelCtrl();
		_ASSERT(pChannel);
		m_ChannelCtrlArray.Add(pChannel);
		pChannel->Create(CChannelCtrl::IDD,this);
		pChannel->SetChannelCtrlID(i);
		//本地城市区号 010,设置城市区号后如果呼叫的号码开头跟本地城市区号相同时，系统自动过滤区号
		//如：如果设置了区号010
		//startdial("01082891111"),系统自动转换成startdial("82891111");
		//startdial("9,,;01082891111"),系统自动转换成startdial("9,,82891111");//';'->为号码内部处理区号的标记
		//QNV_SetParam(i,QNV_PARAM_CITYCODE,10);//设置区号为北京:010,设置时第一个0不能写，如果第一个为0，编译器会识别成其它进制 如：vc的010->8(八进制的10=8)

		str.Format("通道ID=%d 设备ID=%d 序列号=%d 设备类型=%s 芯片类型=%d 模块=%s",
			i,
			QNV_DevInfo(i,QNV_DEVINFO_GETDEVID),
			QNV_DevInfo(i,QNV_DEVINFO_GETSERIAL),						
			GetDevType(QNV_DevInfo(i,QNV_DEVINFO_GETTYPE)),
			QNV_DevInfo(i,QNV_DEVINFO_GETCHIPTYPE),
			GetModule(i));
		AppendStatus(str);

		QNV_SetParam(i,QNV_PARAM_MAXCHKFLASHELAPSE,0);//不检测话机拍插簧功能
		QNV_SetParam(i,QNV_PARAM_HANGUPELAPSE,200);//设置话机挂机反应速度 Nms
//		QNV_SetParam(i,QNV_PARAM_OFFHOOKELAPSE,500);//设置话机摘机反应速度 Nms//太快<1000ms  bridge系列某些设备来电反应前可能会引起摘机误测		
		
		//---------------------------------------------dtmf来电号码接收灵敏度
		//QNV_SetParam(i,QNV_PARAM_DTMFCALLIDVOL,50);//
		//QNV_SetParam(i,QNV_PARAM_DTMFCALLIDLEVEL,4);//
		//QNV_SetParam(i,QNV_PARAM_DTMFCALLIDNUM,8);//
		//---------------------------------------------

		//QNV_SetParam(i,QNV_PARAM_DTMFNUM,7);//设置DTMF检测持续时间7*8ms=56ms
		//QNV_SetParam(i,QNV_PARAM_DTMFLEVEL,4);//
		//QNV_SetParam(i,QNV_PARAM_DTMFVOL,70);//设置DTMF允许的最低(幅度/能量)

		//CHECKDIALTONE_FAILED=3 检测拨号音超时就提示错误，不强制拨号
		//默认检测超时就强制拨号
		//QNV_SetParam(i,QNV_PARAM_DIALTONERESULT,CHECKDIALTONE_FAILED);

//		QNV_SetParam(i,QNV_PARAM_ECHOTHRESHOLD,20);//回音抵消N倍以后自动删除	
//		QNV_SetParam(i,QNV_PARAM_ECHODECVALUE,1);//回音抵消N倍以后再除以N倍

		//如果有反级，可以设置到6个以上
		if(QNV_GetDevCtrl(i,QNV_CTRL_POLARITY) > 0)
			QNV_SetParam(i,QNV_PARAM_BUSY,8);
		else
			QNV_SetParam(i,QNV_PARAM_BUSY,2);

		QNV_SetDevCtrl(i,QNV_CTRL_READFRAMENUM,8);//降低CPU利用率,增加延迟N*12ms
		QNV_SetParam(i,QNV_PARAM_FLASHELAPSE,300);

		//QNV_SetParam(i,QNV_PARAM_RINGTHRESHOLD,30);
	}

	//---------------打开虚拟声卡功能模块
	/*
#ifdef _DEBUG
	QNV_Audrv(QNV_AUDRV_UNINSTALL,0,NULL,NULL,0);//删除虚拟声卡驱动
	if(QNV_Audrv(QNV_AUDRV_INSTALL,0,(char*)(LPCTSTR)(GetModulePath()+"BriAudrv.dll"),NULL,0) > 0)//文件名建议使用 BriAuDrv.dll
	{
		AppendStatus("安装驱动成功");
	}else
	{
		CString strErr;
		strErr.Format("安装虚拟声卡驱动失败.eid=%d",QNV_GetLastError());
		AppendStatus(str);
	}
#endif
	*/

	if(QNV_Audrv(QNV_AUDRV_ISINSTALL,0,NULL,NULL,0) > 0)
	{
		AppendStatus("检测到系统已安装ICC301虚拟声卡驱动");
	}else
	{
		AppendStatus("系统未安装ICC301虚拟声卡驱动");
	}
	if(QNV_OpenDevice(ODT_AUDRV,0,0) > 0)
	{
		AppendStatus("启动ICC301虚拟声卡功能成功");
		QNV_Audrv(QNV_AUDRV_SETWAVEOUTID,0,NULL,NULL,0);//设置虚拟声卡的语音输出通道为0
		QNV_Audrv(QNV_AUDRV_SETWAVEINID,0,NULL,NULL,0);//设置虚拟声卡的语音输入通道为0
	}else
	{
		AppendStatus("启动ICC301虚拟声卡功能失败");
	}
	//---------------------
	
	ResizeWindow();
	//
	m_cChannelList.SetCurSel(0);
	SelectChannel(0);
	GetMenu()->EnableMenuItem(ID_MENU_TOOLS,MF_BYCOMMAND);
	GetMenu()->EnableMenuItem(ID_MENU_CONFERENCE,MF_BYCOMMAND);
	//GetMenu()->EnableMenuItem(ID_MENU_REMOTE,MF_BYCOMMAND);
	//GetMenu()->EnableMenuItem(ID_MENU_CCMODULE,MF_BYCOMMAND);
	QNV_Tool(QNV_TOOL_APMQUERYSUSPEND,FALSE,NULL,NULL,NULL,0);//禁止系统待机
	//QNV_Tool(QNV_TOOL_APMQUERYSUSPEND,TRUE,NULL,NULL,NULL,0);//允许系统待机
	QNV_Tool(QNV_TOOL_SETUSERVALUE,SUD_WRITEFILE|SUD_ENCRYPT,"serverip","192.168.0.120",0,0);//保存任意数据,serverip的内容为 192.168.0.120,该值保存的硬盘，退出程序后并不释放，下次启动后还能读取
	QNV_Tool(QNV_TOOL_SETUSERVALUE,SUD_ENCRYPT,"uupwd","bbbb",0,0);//加密
	QNV_Tool(QNV_TOOL_SETUSERVALUE,SUD_WRITEFILE,"uuname","aaaa",0,0);//不加密，立即写文件
	char szOutBuf[256]={0};
	QNV_Tool(QNV_TOOL_GETUSERVALUE,SUD_ENCRYPT,"serverip",0,szOutBuf,256);//读取保存的任意数据,返回保存的192.168.0.120	
}

//同步方式检测线路状态
long	CQnviccubdemoDlg::CheckLineState()
{
	AppendStatus("开始检测线路状态,支持软摘机的通道才能检测,请确认没有拿着话机...");
	for(BRIINT16 i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{
		long lModule=QNV_DevInfo(i,QNV_DEVINFO_GETMODULE);
		if((lModule&DEVMODULE_CALLID)&&(lModule&DEVMODULE_HOOK))//如果是外线通道,并且支持软摘机
		{
			QNV_SetDevCtrl(i,QNV_CTRL_DOHOOK,1);//软摘机
		}
	}
	CString strRet,str;
	Sleep(1000);//延迟等候线路拨号音,如果线路是分机，并且交换机反应时间比较长，建议延长该检测时间
	for(i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{
		long lModule=QNV_DevInfo(i,QNV_DEVINFO_GETMODULE);
		if((lModule&DEVMODULE_CALLID)&&(lModule&DEVMODULE_HOOK))//如果是外线通道,并且支持软摘机
		{
			if(QNV_General(i,QNV_GENERAL_CHECKDIALTONE,0,0) > 0)//检测到拨号音就表示可以正常拨号
			{
				str.Format("通道%d线路：可用(可正常软拨号)",i);				
			}else
			{
				str.Format("[错误xx]通道%d线路：不可用(不能正常软拨号，检查LINE口线路)xxxxx",i);
			}
			AppendStatus(str);
			strRet+=str;

			if(QNV_GetDevCtrl(i,QNV_CTRL_PHONE) > 0)//检测到本地话机摘机了(误测了)
			{
				str.Format("[错误xx]通道%d线路：LINE口/PHONE口线路接反了xxxxx",i);			
			}else
			{
				str.Format("通道%d线路：LINE口/PHONE口线路正常",i);
			}
			AppendStatus(str);
			strRet+=str;
		}
	}
	for(i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{
		long lModule=QNV_DevInfo(i,QNV_DEVINFO_GETMODULE);
		if((lModule&DEVMODULE_CALLID)&&(lModule&DEVMODULE_HOOK))//如果是外线通道,并且支持软摘机
		{
			QNV_SetDevCtrl(i,QNV_CTRL_DOHOOK,0);//软挂机
		}
	}
	if(strRet.IsEmpty())
	{
		strRet="无可用线路检测";
		AppendStatus(strRet);
	}
	return 1;
}

UINT	CQnviccubdemoDlg::TestThread(VOID *pParam)
{
	CQnviccubdemoDlg *p=(CQnviccubdemoDlg*)pParam;
	long lRet=QNV_OpenDevice(ODT_LBRIDGE,0,0);
	if(lRet == ERROR_INVALIDDLL) AfxMessageBox("DLL不合法");
	else if(lRet <= 0 || QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS) <= 0)
	{
		AfxMessageBox("打开设备失败,请检查设备是否已经插入并安装了驱动,并且没有其它程序已经打开设备");
	}else
	{		
		p->InitDevInfo();
		p->m_closedev.EnableWindow(TRUE);
		p->m_opendev.EnableWindow(FALSE);
	}
	/*
	MSG msg;
    while (GetMessage(&msg, 0, 0, 0))
        DispatchMessage(&msg);
	*/
	return 0;
}


void CQnviccubdemoDlg::OnOpendev() 
{	
//	DWORD dwID=0;
//	CreateThread(NULL,0,(LPTHREAD_START_ROUTINE)TestThread,(void*)this,0,&dwID);
//	return ;
	long lRet=QNV_OpenDevice(ODT_LBRIDGE,0,0);
	if(lRet == ERROR_INVALIDDLL) AfxMessageBox("DLL不合法");
	else if(lRet <= 0 || QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS) <= 0)
	{
		AfxMessageBox("打开设备失败,请检查设备是否已经插入并安装了驱动,并且没有其它程序已经打开设备");
	}else
	{		
		InitDevInfo();
		m_closedev.EnableWindow(TRUE);
		m_opendev.EnableWindow(FALSE);
		//CheckLineState();
	}
}

void CQnviccubdemoDlg::OnClosedev() 
{		
	CloseRecvBroad();
	CloseBroadcast();
	CloseCCModule();
	CloseConference();
	DeleteAllChannelCtrl();	
	BFU_FreeSource();
//	BBC_StopBroadcast();
	m_cChannelList.ResetContent();
	if(QNV_CloseDevice(ODT_ALL,0) != 0)
	{
		AppendStatus("设备关闭");
	}
	GetMenu()->EnableMenuItem(ID_MENU_TOOLS,MF_GRAYED|MF_BYCOMMAND);
	GetMenu()->EnableMenuItem(ID_MENU_CONFERENCE,MF_GRAYED|MF_BYCOMMAND);
	//GetMenu()->EnableMenuItem(ID_MENU_REMOTE,MF_GRAYED|MF_BYCOMMAND);
	m_closedev.EnableWindow(FALSE);
	m_opendev.EnableWindow(TRUE);
}

void CQnviccubdemoDlg::OnDestroy() 
{
	OnClosedev();
	CDialog::OnDestroy();	
}

long	CQnviccubdemoDlg::SelectChannel(BRIINT16 chID)
{
	long lType=QNV_DevInfo(chID,QNV_DEVINFO_GETCHIPTYPE);
	CString str;
	if(lType == 256)
	{
		str.Format("USB芯片组类型：玻瑞器芯片");
	}else
	{
		str.Format("USB芯片组类型：CC301芯片");
	}
	m_cChipType.SetWindowText(str);

	for(int i=0;i<m_ChannelCtrlArray.GetSize();i++)
	{
		m_ChannelCtrlArray[i]->ShowWindow(SW_HIDE);
	}
	m_ChannelCtrlArray[chID]->ShowWindow(SW_SHOW);
	return 0;
}

void CQnviccubdemoDlg::OnSelchangeChannellist() 
{
	SelectChannel(m_cChannelList.GetCurSel());
}

void	CQnviccubdemoDlg::ResizeWindow()
{
	CRect rc;
	GetClientRect(&rc);
	for(int i=0;i<m_ChannelCtrlArray.GetSize();i++)
	{
		m_ChannelCtrlArray[i]->SetWindowPos(NULL,0,80,500,rc.Height() - 100,NULL);
	}
	m_cancel.SetWindowPos(NULL,rc.right-70,rc.bottom-25,68,22,NULL);
	m_cStSeap.SetWindowPos(NULL,2,rc.bottom-29,rc.right-2,2,NULL);
	m_cStseap2.SetWindowPos(NULL,505,2,rc.right-505-2,rc.bottom-2-32,NULL);
	m_cDevStatus.SetWindowPos(NULL,507,18,rc.right-507-2,rc.bottom-2-32-2-18,NULL);
}

void CQnviccubdemoDlg::OnSize(UINT nType, int cx, int cy) 
{
	if(::IsWindow(m_cDevStatus.m_hWnd)) ResizeWindow();
	CDialog::OnSize(nType, cx, cy);	
}

void CQnviccubdemoDlg::AppendStatus(CString strStatus)
{
	//备注：设备关闭后不能被正常写入
	if(QNV_Tool(QNV_TOOL_WRITELOG,0,(char*)(LPCTSTR)strStatus,NULL,NULL,0) == 0)//写本地日志
	{
		AfxMessageBox("写本地日志失败");
	}
	CString str,strTime;
	CTime ct=CTime::GetCurrentTime();
	strTime.Format("[%02d:%02d:%02d] %s t=%d",ct.GetHour(),ct.GetMinute(),ct.GetSecond(),strStatus,GetTickCount());	
	CString strSrc;
	GetDlgItem(IDC_DEVSTATUS)->GetWindowText(strSrc);
	if(strSrc.GetLength() > 24000)
		strSrc.Empty();
	str=strTime+"\r\n"+strSrc;
	GetDlgItem(IDC_DEVSTATUS)->SetWindowText(str);
}

LRESULT CQnviccubdemoDlg::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	switch(message)
	{
	case QNV_CHANNEL_MESSAGE:
		{
			if(wParam == CB_APPENDSTATUS)
			{
				AppendStatus((LPCTSTR)lParam);
			}else if(wParam == CB_STARTDIAL)
			{//开始拨号了

			}
		}break;
	case QNV_CLOSECONFERENCE_MESSAGE:
		{
			CloseConference();
		}break;
	case QNV_CLOSECCMODULE_MESSAGE:
		{
			CloseCCModule();
		}break;
	default:break;
	}
	return CDialog::WindowProc(message, wParam, lParam);
}

BOOL CQnviccubdemoDlg::OnCommand(WPARAM wParam, LPARAM lParam) 
{
	switch(wParam)
	{
	case ID_MENU_CHECKLINE:
		{
			CCheckLine line;
			line.DoModal();
		}break;
	case ID_MENU_STORAGE:
		{
			CStorage storage;
			storage.DoModal();
		}break;
	case ID_MENU_TOOLS:
		{
			CTools t;
			t.DoModal();
		}break;
	case ID_MENU_CONFERENCE:
		{
			CreateConference();
		}break;
	case ID_MENU_REMOTE:
		{
			CRemote remote;
			remote.DoModal();
		}break;
	case ID_MENU_CCMODULE:
		{
			CreateCCModule();
		}break;
	case ID_MENU_RECVFAX:
		{
			if(!(QNV_DevInfo(0,QNV_DEVINFO_GETMODULE) & DEVMODULE_FAX))
			{
				AfxMessageBox("该设备不支持传真功能");
				break;
			}
			BFU_StartRecvFax(0,"",0);
		}break;
	case ID_MENU_SENDFAX:
		{
			if(!(QNV_DevInfo(0,QNV_DEVINFO_GETMODULE) & DEVMODULE_FAX))
			{
				AfxMessageBox("该设备不支持传真功能");
				break;
			}
			CString strPath=((CQnviccubdemoApp*)AfxGetApp())->GetSelectedFilePath2("Image Files(*.bmp,*.jpg,*.jpeg,*.gif,*.png,*.pcx,*.tif,*.tiff)|*.bmp;*.jpg;*.jpeg;*.gif;*.png;*.pcx;*.tif;*.tiff;|Web Files(*.mht,*.htm,*.html)|*.mht;*.htm;*.html;|Word Files(*.doc)|*.doc;||","","","",m_hWnd,TRUE);
			if(!strPath.IsEmpty())
			{
				BFU_StartSendFax(0,strPath,0);
			}
		}break;
	case ID_MENU_FAXLOG:
		{
			BFU_FaxLog(NULL,0);
		}break;
	case ID_MENU_BROADCAST:
		{
			CreateBroadcast();
		}break;
	case ID_MENU_RECVBROAD:
		{
			CreateRecvBroad();
		}break;
	case ID_MENU_SOCKETCLIENT:
		{
			CSocketClient sock;
			sock.DoModal();
		}break;
	case ID_MENU_SOCKETUDP:
		{
			CSocketUDP udp;
			udp.DoModal();
		}break;
	default:break;
	}
	return CDialog::OnCommand(wParam, lParam);
}

void CQnviccubdemoDlg::OnOpenremote() 
{	
	/*
	OnClosedev();
	if(QNV_OpenDevice(ODT_LBRIDGE,0,"127.0.0.1") <= 0)
	{
		AfxMessageBox("打开设备失败");
	}else
	{
		InitDevInfo();
	}		
	*/
}

void CQnviccubdemoDlg::OnCancel() 
{	
	OnClosedev();
	CDialog::OnCancel();
}

void	CQnviccubdemoDlg::CreateRecvBroad()
{
	if(!m_pRecvBroad)
	{
		m_pRecvBroad = new CRecvBroad();
		m_pRecvBroad->Create(CRecvBroad::IDD,this);
	}
	if(m_pRecvBroad->IsIconic()) m_pRecvBroad->ShowWindow(SW_RESTORE);
	m_pRecvBroad->ShowWindow(SW_SHOW);
}

void	CQnviccubdemoDlg::CloseRecvBroad()
{
	if(m_pRecvBroad)
	{
		m_pRecvBroad->FreeSource();
		delete m_pRecvBroad;
		m_pRecvBroad=NULL;
	}
}

void	CQnviccubdemoDlg::CreateBroadcast()
{
	if(!m_pBroadcast)
	{
		m_pBroadcast = new CBroadcast();
		m_pBroadcast->Create(CBroadcast::IDD,this);		
	}
	if(m_pBroadcast->IsIconic()) m_pBroadcast->ShowWindow(SW_RESTORE);
	m_pBroadcast->ShowWindow(SW_SHOW);
}

void	CQnviccubdemoDlg::CloseBroadcast()
{
	if(m_pBroadcast)
	{
		m_pBroadcast->FreeSource();
		delete m_pBroadcast;
		m_pBroadcast=NULL;
	}
}

void	CQnviccubdemoDlg::CreateCCModule()
{
	if(!m_pCCModule)
	{
		m_pCCModule = new CCCModule();
		m_pCCModule->Create(CCCModule::IDD,this);
		m_pCCModule->ShowWindow(SW_SHOW);
	}
}

void	CQnviccubdemoDlg::CloseCCModule()
{
	if(m_pCCModule)
	{
		m_pCCModule->FreeSource();
		delete m_pCCModule;
		m_pCCModule=NULL;
	}
}

BOOL	CQnviccubdemoDlg::CreateConference()
{
	if(!m_pConference)
	{
		m_pConference= new CConference();
		m_pConference->Create(CConference::IDD,this);
		m_pConference->ShowWindow(SW_SHOW);
	}
	return m_pConference!=NULL;
}

void	CQnviccubdemoDlg::CloseConference()
{
	if(m_pConference)
	{
		m_pConference->FreeSource();
		delete m_pConference;
		m_pConference=NULL;
	}
}

