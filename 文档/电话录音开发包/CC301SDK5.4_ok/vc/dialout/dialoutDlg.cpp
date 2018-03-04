// dialoutDlg.cpp : implementation file
//

#include "stdafx.h"
#include "dialout.h"
#include "dialoutDlg.h"

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
// CDialoutDlg dialog

CDialoutDlg::CDialoutDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CDialoutDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CDialoutDlg)
	m_strCode = _T("");
	m_chid = 0;
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CDialoutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CDialoutDlg)
	DDX_Text(pDX, IDC_CODE, m_strCode);
	DDX_Text(pDX, IDC_CHID, m_chid);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CDialoutDlg, CDialog)
	//{{AFX_MSG_MAP(CDialoutDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_WM_TIMER()
	ON_WM_DESTROY()
	ON_BN_CLICKED(IDC_STARTDIAL, OnStartdial)
	ON_BN_CLICKED(IDC_HANGUP, OnHangup)
	ON_BN_CLICKED(IDC_HOOK, OnHook)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDialoutDlg message handlers

BOOL CDialoutDlg::OnInitDialog()
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
	m_nTimer=NULL;
	OpenDev();
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CDialoutDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CDialoutDlg::OnPaint() 
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
HCURSOR CDialoutDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void CDialoutDlg::OpenDev()
{
	long lRet=QNV_OpenDevice(ODT_LBRIDGE,0,0);
	if(lRet == ERROR_INVALIDDLL) AfxMessageBox("DLL不合法");
	else if(lRet <= 0 || QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS) <= 0)
	{
		AfxMessageBox("打开设备失败,请检查设备是否已经插入并安装了驱动,并且没有其它程序已经打开设备");
	}else
	{		
		InitDevInfo();
	}
}

CString CDialoutDlg::GetDevType(long lDevType)
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
	case DEVTYPE_IP1:str+="(cc301 IP1)";break;
	case DEVTYPE_IA1:str+="(cc301 IA1)";break;
	case DEVTYPE_IA2:str+="(cc301 IA2)";break;
	case DEVTYPE_IA4:str+="(cc301 IA4)";break;
	case DEVTYPE_IB2:str+="(cc301 IB2)";break;
	case DEVTYPE_IB3:str+="(cc301 IB3)";break;
	case DEVTYPE_IC2_R:str+="(cc301 IC2_R)";break;
	case DEVTYPE_IC2_LP:str+="(cc301 IC2_LP)";break;
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


CString CDialoutDlg::GetModule(BRIINT16 chID)
{
	CString strModule;
	long lModule=QNV_DevInfo(chID,QNV_DEVINFO_GETMODULE);
	if(lModule&DEVMODULE_DOPLAY) strModule+="有喇叭/";
	if(lModule&DEVMODULE_CALLID) strModule+="有来电显示/";
	if(lModule&DEVMODULE_PHONE) strModule+="话机拨号/";
	if(lModule&DEVMODULE_SWITCH) strModule+="断开电话机,接收话机按键/";
	if(lModule&DEVMODULE_PLAY2TEL) strModule+="播放语音到电话机/";
	if(lModule&DEVMODULE_HOOK) strModule+="软摘机/";
	if(lModule&DEVMODULE_MICSPK) strModule+="有耳机/MIC/";
	if(lModule&DEVMODULE_RING) strModule+="模拟话机震铃/";
	if(lModule&DEVMODULE_FAX) strModule+="收发传真/";
	if(lModule&DEVMODULE_POLARITY) strModule+="反级检测/";
	return strModule;
}

void	CDialoutDlg::InitDevInfo()
{
	CString str,strInfo;
	str.Format("打开设备成功 通道数=%d 设备数=%d",QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS),QNV_DevInfo(0,QNV_DEVINFO_GETCHIPS));
	AppendStatus(str);
	for(BRIINT16 i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{
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

		QNV_SetParam(i,QNV_PARAM_DTMFNUM,7);
		//QNV_SetParam(i,QNV_PARAM_DIALVOL,130);
		//QNV_SetParam(i,QNV_PARAM_HANGUPELAPSE,10000);
		QNV_Event(i,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);//使用窗口消息方式获取事件
	}
	
	QNV_Tool(QNV_TOOL_APMQUERYSUSPEND,FALSE,NULL,NULL,NULL,0);//禁止系统待机
	QNV_Tool(QNV_TOOL_SETUSERVALUE,SUD_WRITEFILE|SUD_ENCRYPT,"serverip","192.168.0.120",0,0);//保存任意数据,serverip的内容为 192.168.0.120,该值保存的硬盘，退出程序后并不释放，下次启动后还能读取
	QNV_Tool(QNV_TOOL_SETUSERVALUE,2,"uupwd","bbbb",0,0);
	QNV_Tool(QNV_TOOL_SETUSERVALUE,1,"uuname","aaaa",0,0);
	char szOutBuf[256]={0};
	QNV_Tool(QNV_TOOL_GETUSERVALUE,SUD_ENCRYPT,"serverip",0,szOutBuf,256);//读取保存的任意数据,返回保存的192.168.0.120	
	
	//m_nTimer=SetTimer(0x20,200,NULL);
}

void CDialoutDlg::AppendStatus(CString strStatus)
{
	CString str,strTime;
	CTime ct=CTime::GetCurrentTime();
	strTime.Format("[%02d:%02d:%02d] %s tick=%d",ct.GetHour(),ct.GetMinute(),ct.GetSecond(),strStatus,GetTickCount());	
	CString strSrc;
	GetDlgItem(IDC_DEVSTATUS)->GetWindowText(strSrc);
	if(strSrc.GetLength() > 16000)
		strSrc .Empty();
	str=strTime+"\r\n"+strSrc;
	GetDlgItem(IDC_DEVSTATUS)->SetWindowText(str);
}
long	CDialoutDlg::ProcessEvent(PBRI_EVENT pEvent)
{
		CString str,strValue;
		strValue.Format("Handle=%d Result=%d Data=%s",pEvent->lEventHandle,pEvent->lResult,pEvent->szData);
		switch(pEvent->lEventType)
		{
		case BriEvent_PhoneHook:
			{//电话接通后根据对方阻抗大小，声音会变大变小,200就太大，中间幅度200就太大,100可以
				QNV_SetParam(pEvent->uChannelID,QNV_PARAM_DTMFVOL,50);
				if(QNV_General(pEvent->uChannelID,QNV_GENERAL_ISDIALING,0,NULL) <= 0)
				{
					//QNV_SetDevCtrl(pEvent->uChannelID,QNV_CTRL_DOHOOK,0);//没有正在拨号可以考虑自动软挂机,避免3方通话状态，话机里有背景音出现
				}
				str.Format("通道%d: 电话机摘机,修改检测DTMF灵敏度,dtmfvol=50,如果检测不到电话机拨号就修改该值更小",pEvent->uChannelID+1);
			}break;
		case BriEvent_PhoneHang:
			{
				QNV_SetParam(pEvent->uChannelID,QNV_PARAM_DTMFVOL,10);
				str.Format("通道%d: 电话机挂机,修改检测DTMF灵敏度 dtmfvol=10",pEvent->uChannelID+1);
			}break;
		case BriEvent_CallIn:str.Format("通道%d: 来电响铃 %s",pEvent->uChannelID+1,strValue);break;
		//case BriEvent_CallInEx:str.Format("通道%d: 硬解码来电响铃 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_GetCallID:str.Format("通道%d: 接收到来电号码 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_StopCallIn:str.Format("通道%d: 停止呼入，产生一个未接电话 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_DialEnd:
			{				
				if(QNV_GetDevCtrl(pEvent->uChannelID,QNV_CTRL_PHONE) > 0)
				{//电话机已经拿着可以考虑自动软挂机
					//避免3方通话状态，话机里有背景音出现
					//避免消耗太多线路上的电
					Sleep(500);
					QNV_SetDevCtrl(pEvent->uChannelID,QNV_CTRL_DOHOOK,0);					
				}
				QNV_SetParam(pEvent->uChannelID,QNV_PARAM_HANGUPELAPSE,500);
				str.Format("通道%d: 拨号结束 %s",pEvent->uChannelID+1,strValue);
			}break;
		case BriEvent_PlayFileEnd:str.Format("通道%d: 播放文件结束 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_PlayMultiFileEnd:str.Format("通道%d: 多文件连播结束 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_RepeatPlayFile:str.Format("通道%d: 循环播放文件 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_PlayStringEnd:str.Format("通道%d: 播放字符结束 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_SendCallIDEnd:str.Format("通道%d: 给话机震铃时发送号码结束 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_Silence:str.Format("通道%d: 通话中一定时间的静音 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_GetDTMFChar:str.Format("通道%d: 接收到按键 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_RemoteHook:str.Format("通道%d: 远程摘机 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_RemoteHang:str.Format("通道%d: 远程挂机 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_Busy:str.Format("通道%d: 接收到忙音,线路已经断开 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_DialTone:str.Format("通道%d: 检测到拨号音 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_PhoneDial:str.Format("通道%d: 电话机拨号 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_RingBack:str.Format("通道%d: 拨号后接收到回铃音 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_MicIn:str.Format("通道%d: 麦克风插入 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_MicOut:str.Format("通道%d: 麦克风拔出 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_FlashEnd:str.Format("通道%d: 拍插簧完成 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_RemoteSendFax:str.Format("通道%d: 对方准备发送传真 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_FaxRecvFinished:str.Format("通道%d: 接收传真完成 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_FaxRecvFailed:str.Format("通道%d: 接收传真失败 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_FaxSendFinished:str.Format("通道%d: 发送传真完成 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_FaxSendFailed:str.Format("通道%d: 发送传真失败 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_RefuseEnd:str.Format("通道%d: 拒接来电完成 %s",pEvent->uChannelID+1,strValue);break;	
		case BriEvent_PSTNFree:
			{
				str.Format("通道%d: PSTN线路已空闲 %s",pEvent->uChannelID+1,strValue);
			}break;	
		case BriEvent_DevErr:
			{
				
			}break;
		case BriEvent_EnableHook:
			{
				str.Format("通道%d: HOOK被控制 lResult=%d",pEvent->uChannelID+1,pEvent->lResult);				
			}break;
		case BriEvent_EnablePlay:
			{
				str.Format("通道%d: 喇叭被控制 lResult=%d",pEvent->uChannelID+1,pEvent->lResult);
			}break;
		case BriEvent_EnablePlayMux:
			{
				str.Format("通道%d: 喇叭mux修改 lResult=%d",pEvent->uChannelID+1,pEvent->lResult);
			}break;
		default:
			{
				str.Format("通道%d: 其它忽略事件 eventid=%d lResult=%d",pEvent->uChannelID+1,pEvent->lEventType,pEvent->lResult);
			}break;
		}
		if(!str.IsEmpty())
		{
			AppendStatus((LPCTSTR)str);
		}
		return 1;
}

LRESULT CDialoutDlg::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{	
	if(message == BRI_EVENT_MESSAGE)
	{
		BRI_EVENT ev;
		PBRI_EVENT pEvent=&ev;
		//PBRI_EVENT pEvent=(PBRI_EVENT)lParam;//直接使用下层的内存指针,使用期间该内参不能被释放,如：QNV_CloseDevice会释放该内存
		memcpy((char*)pEvent,(char*)lParam,sizeof(BRI_EVENT));//这样的好处是不再需要下层的内存指针,可以被释放
		_ASSERT(pEvent->uChannelID == pEvent->uChannelID);
		ProcessEvent(pEvent);
		return  TRUE;
	}
	return CDialog::WindowProc(message, wParam, lParam);
}

void CDialoutDlg::OnTimer(UINT nIDEvent) 
{
	if(nIDEvent == m_nTimer)
	{
		CString strValue;
		for(int i = 0; i < QNV_DevInfo(-1, QNV_DEVINFO_GETCHANNELS); i++)
		{
			BRI_EVENT tEvent={0};
			int nRet = QNV_Event(i, QNV_EVENT_POP, 0, NULL, (char *)&tEvent, sizeof(BRI_EVENT));
			if (nRet <= 0) continue;
			//strValue.Format("通道[%d] type=%d Handle=%d Result=%d Data=%s",i,tEvent.lEventType,tEvent.lEventHandle,tEvent.lResult,tEvent.szData);
			AppendStatus(strValue);
			ProcessEvent(&tEvent);
		}
	}
	CDialog::OnTimer(nIDEvent);
}

void CDialoutDlg::OnDestroy() 
{
	QNV_CloseDevice(ODT_ALL,0);
	if(m_nTimer)
	{
		KillTimer(m_nTimer);
		m_nTimer=NULL;
	}
	CDialog::OnDestroy();
	
}

void CDialoutDlg::OnStartdial() 
{
	UpdateData(TRUE);	
	if(QNV_General(m_chid,QNV_GENERAL_STARTDIAL,0,(char*)(LPCTSTR)m_strCode) <= 0)
	{
		AppendStatus("拨号失败");
	}else
	{
		AppendStatus("开始拨号:"+m_strCode);
	}
}

void CDialoutDlg::OnHangup() 
{
	UpdateData(TRUE);
	QNV_SetDevCtrl(m_chid,QNV_CTRL_DOHOOK,0);
	QNV_SetParam(m_chid,QNV_PARAM_HANGUPELAPSE,500);
}

void CDialoutDlg::OnHook() 
{
	UpdateData(TRUE);
	QNV_SetDevCtrl(m_chid,QNV_CTRL_DOHOOK,1);	
}
