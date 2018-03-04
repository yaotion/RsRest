// switchdemoDlg.cpp : implementation file
//

#include "stdafx.h"
#include "switchdemo.h"
#include "switchdemoDlg.h"

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
// CSwitchdemoDlg dialog

CSwitchdemoDlg::CSwitchdemoDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CSwitchdemoDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CSwitchdemoDlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CSwitchdemoDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CSwitchdemoDlg)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CSwitchdemoDlg, CDialog)
	//{{AFX_MSG_MAP(CSwitchdemoDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_WM_DESTROY()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CSwitchdemoDlg message handlers

BOOL CSwitchdemoDlg::OnInitDialog()
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
	
	InitDevice();
	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CSwitchdemoDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CSwitchdemoDlg::OnPaint() 
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
HCURSOR CSwitchdemoDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void CSwitchdemoDlg::AppendStatus(CString strStatus)
{
	CString str,strTime;
	CTime ct=CTime::GetCurrentTime();
	strTime.Format("[%02d:%02d:%02d] %s tick=%d",ct.GetHour(),ct.GetMinute(),ct.GetSecond(),strStatus,GetTickCount());	
	CString strSrc;
	GetDlgItem(IDC_SWITCHSTATUS)->GetWindowText(strSrc);
	if(strSrc.GetLength() > 16000)
		strSrc .Empty();
	str=strTime+"\r\n"+strSrc;
	GetDlgItem(IDC_SWITCHSTATUS)->SetWindowText(str);
}

long	CSwitchdemoDlg::InitDevice()
{
	long lRet=QNV_OpenDevice(ODT_LBRIDGE,0,0);
	if(lRet == ERROR_INVALIDDLL) AfxMessageBox("DLL不合法");
	else if(lRet <= 0 || QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS) <= 0)
	{
		AfxMessageBox("打开设备失败,请检查设备是否已经插入并安装了驱动,并且没有其它程序已经打开设备");
	}else
	{		
		InitDevInfo();
		AppendStatus("初始化完成,接入电话线/电话机后等待呼入....");
		AppendStatus("请把接入的话机从PHONE-1到PHONE-N按循序接入....");
	}
	return 1;
}


CString CSwitchdemoDlg::GetModule(BRIINT16 chID)
{
	CString strModule;
	long lModule=QNV_DevInfo(chID,QNV_DEVINFO_GETMODULE);
	if(lModule&DEVMODULE_DOPLAY) strModule+="有喇叭/";
	if(lModule&DEVMODULE_CALLID) strModule+="有来电显示/";
	if(lModule&DEVMODULE_PHONE) strModule+="话机拨号/";
	if(lModule&DEVMODULE_SWITCH) strModule+="断开电话机/";
	if(lModule&DEVMODULE_PLAY2TEL) strModule+="播放语音到电话机/";
	if(lModule&DEVMODULE_HOOK) strModule+="软摘机/";
	if(lModule&DEVMODULE_MICSPK) strModule+="有耳机/MIC/";
	if(lModule&DEVMODULE_RING) strModule+="模拟话机震铃/";
	if(lModule&DEVMODULE_FAX) strModule+="收发传真/";
	if(lModule&DEVMODULE_POLARITY) strModule+="反级检测/";
	return strModule;
}

void	CSwitchdemoDlg::InitDevInfo()
{
	CString str,strInfo;
	str.Format("打开设备成功 通道数=%d 设备数=%d",QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS),QNV_DevInfo(0,QNV_DEVINFO_GETCHIPS));
	AppendStatus(str);
	for(BRIINT16 i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{		
		QNV_Event(i,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);

		CSwitchChannel *pChannel=new CSwitchChannel();
		m_ChannelCtrlArray.Add(pChannel);
		pChannel->SetChannelCtrlID(i);
		pChannel->SetCBWndAndID(m_hWnd,DC_CALLBACK_MESSAGE);
		pChannel->StartSwitch();

		str.Format("通道ID=%d 设备ID=%d 序列号=%d 通道类型=0x%x 芯片类型=%d 模块=%s",
			i,
			QNV_DevInfo(i,QNV_DEVINFO_GETDEVID),
			QNV_DevInfo(i,QNV_DEVINFO_GETSERIAL),						
			QNV_DevInfo(i,QNV_DEVINFO_GETTYPE),
			QNV_DevInfo(i,QNV_DEVINFO_GETCHIPTYPE),
			GetModule(i));
		AppendStatus(str);
#ifdef _DEBUG
		//QNV_SetDevCtrl(i,QNV_CTRL_WATCHDOG,0);//测试状态，不开看门狗
#endif
	}
	QNV_Tool(QNV_TOOL_APMQUERYSUSPEND,FALSE,NULL,NULL,NULL,0);//禁止系统待机
}

LRESULT CSwitchdemoDlg::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{	
	if(message == DC_CALLBACK_MESSAGE)
	{
		switch(wParam)
		{
		case SS_APPENDSTATUS:
			{
				AppendStatus((char*)lParam);
			}break;
		default:break;
		}
	}
	else if(message == BRI_EVENT_MESSAGE)
	{
		BRI_EVENT ev;
		PBRI_EVENT pEvent=&ev;
		//PBRI_EVENT pEvent=(PBRI_EVENT)lParam;//直接使用下层的内存指针,使用期间该内参不能被释放,如：QNV_CloseDevice会释放该内存
		memcpy((char*)pEvent,(char*)lParam,sizeof(BRI_EVENT));//这样的好处是不再需要下层的内存指针,可以被释放
		CString str,strValue;
		strValue.Format("Handle=%d Result=%d Data=%s",pEvent->lEventHandle,pEvent->lResult,pEvent->szData);
		switch(pEvent->lEventType)
		{
		case BriEvent_PhoneHook:
			{//电话接通后根据对方阻抗大小，声音会变大变小,200就太大，中间幅度200就太大,100可以
				QNV_SetParam(pEvent->uChannelID,QNV_PARAM_DTMFVOL,100);
				str.Format("通道%d: 电话机摘机,修改检测DTMF灵敏度,dtmfvol=200,如果检测不到电话机拨号就修改该值更小",pEvent->uChannelID+1);
			}break;
		case BriEvent_PhoneHang:
			{
				QNV_SetParam(pEvent->uChannelID,QNV_PARAM_DTMFVOL,10);
				str.Format("通道%d: 电话机挂机,修改检测DTMF灵敏度 dtmfvol=10",pEvent->uChannelID+1);
			}break;
		case BriEvent_CallIn:str.Format("通道%d: 来电响铃 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_GetCallID:str.Format("通道%d: 接收到来电号码 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_StopCallIn:str.Format("通道%d: 停止呼入，产生一个未接电话 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_DialEnd:str.Format("通道%d: 拨号结束 %s",pEvent->uChannelID+1,strValue);break;
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
		case BriEvent_RefuseEnd:str.Format("通道%d: 拒接来电完成 %s",pEvent->uChannelID+1,strValue);break;	
		case BriEvent_PSTNFree:
			{
				str.Format("通道%d: PSTN线路已空闲 %s",pEvent->uChannelID+1,strValue);
			}break;	
		default:break;
		}
		if(!str.IsEmpty())
		{
			AppendStatus(str);
		}
	}
	return CDialog::WindowProc(message, wParam, lParam);
}

void CSwitchdemoDlg::OnDestroy() 
{
	for(int i=0;i<m_ChannelCtrlArray.GetSize();i++)
	{
		m_ChannelCtrlArray[i]->FreeSource();
		delete m_ChannelCtrlArray[i];
	}
	m_ChannelCtrlArray.RemoveAll();
	QNV_CloseDevice(ODT_ALL,0);
	CDialog::OnDestroy();	
}
