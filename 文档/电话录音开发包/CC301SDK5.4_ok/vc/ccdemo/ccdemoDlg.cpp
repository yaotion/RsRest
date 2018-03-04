// ccdemoDlg.cpp : implementation file
//

#include "stdafx.h"
#include "ccdemo.h"
#include "ccdemoDlg.h"
#include "contact.h"

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
// CCcdemoDlg dialog

CCcdemoDlg::CCcdemoDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CCcdemoDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CCcdemoDlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
	m_pCCMsg = NULL;
	m_pCCCmd = NULL;
	m_pCCCall = NULL;
	m_pFileTrans=NULL;
}

void CCcdemoDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CCcdemoDlg)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CCcdemoDlg, CDialog)
	//{{AFX_MSG_MAP(CCcdemoDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_WM_DESTROY()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CCcdemoDlg message handlers

BOOL CCcdemoDlg::OnInitDialog()
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

	InitCCModule();
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CCcdemoDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CCcdemoDlg::OnPaint() 
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
HCURSOR CCcdemoDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}
//初始化启动CC模块
long	CCcdemoDlg::InitCCModule()
{
	if(QNV_OpenDevice(ODT_CC,0,QNV_CC_LICENSE) <= 0 )//加载CC模块
	{
		AppendStatus("加载CC模块失败");
		AfxMessageBox("加载CC模块失败");
		return 0;
	}else
	{
		//注册本窗口接收CC模块的事件
		//在windowproc处理接收到的消息
		//QNV_Event(CCCTRL_CHANNELID,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);
		//注册使用回调函数方式获取事件,跟窗口消息只要二选一就可以
		QNV_Event(CCCTRL_CHANNELID,QNV_EVENT_REGCBFUNC,(long)this,(char*)CallbackEvent,NULL,0);
		//
		AppendStatus("加载CC模块完成");
		SetSvrAddr();
		return 1;
	}
}

BRIINT32 WINAPI CCcdemoDlg::CallbackEvent(BRIINT16 uChannelID,BRIUINT32 dwUserData,BRIINT32 lType,BRIINT32 lHandle,BRIINT32 lResult,BRIINT32 lParam,BRIPCHAR8 pData,BRIPCHAR8 pDataEx)
{
	CCcdemoDlg *p=(CCcdemoDlg*)dwUserData;
	BRI_EVENT Event={0};
	Event.lEventHandle = lHandle;
	Event.lEventType = lType;
	Event.lParam=lParam;
	Event.lResult=lResult;
	Event.uChannelID=uChannelID;
	if(pData) strcpy(Event.szData,pData);
	if(pDataEx) strcpy(Event.szDataEx,pDataEx);
	p->ShowEvent(&Event);
	return 1;
}


BOOL	CCcdemoDlg::CreateCCCmd()
{
	if(!m_pCCCmd)
	{
		m_pCCCmd = new CCCCmd();
		m_pCCCmd->Create(CCCCmd::IDD,CWnd::FromHandle(::GetDesktopWindow()));
	}else if(m_pCCCmd->IsIconic())
	{
		m_pCCCmd->ShowWindow(SW_RESTORE);
	}
	m_pCCCmd->ShowWindow(SW_SHOW);
	return TRUE;
}

BOOL	CCcdemoDlg::CloseCCCmd()
{
	if(m_pCCCmd)
	{
		m_pCCCmd->FreeSource();
		delete m_pCCCmd;
		m_pCCCmd=NULL;
	}
	return TRUE;
}

BOOL	CCcdemoDlg::CreateCCMsg()
{
	if(!m_pCCMsg)
	{
		m_pCCMsg = new CCCMsg();
		m_pCCMsg->Create(CCCMsg::IDD,CWnd::FromHandle(::GetDesktopWindow()));
	}else if(m_pCCMsg->IsIconic())
	{
		m_pCCMsg->ShowWindow(SW_RESTORE);
	}
	m_pCCMsg->ShowWindow(SW_SHOW);
	return TRUE;
}

BOOL	CCcdemoDlg::CloseCCMsg()
{
	if(m_pCCMsg)
	{
		m_pCCMsg->FreeSource();
		delete m_pCCMsg;
		m_pCCMsg=NULL;
	}
	return TRUE;
}

BOOL	CCcdemoDlg::CreateCCCall()
{
	if(!m_pCCCall)
	{
		m_pCCCall = new CCCCall();
		m_pCCCall->Create(CCCCall::IDD,CWnd::FromHandle(::GetDesktopWindow()));
	}else if(m_pCCCall->IsIconic())
	{
		m_pCCCall->ShowWindow(SW_RESTORE);
	}
	m_pCCCall->ShowWindow(SW_SHOW);
	return TRUE;
}

BOOL	CCcdemoDlg::CloseCCCall()
{
	if(m_pCCCall)
	{
		m_pCCCall->FreeSource();
		delete m_pCCCall;
		m_pCCCall=NULL;
	}
	return TRUE;
}

CString	CCcdemoDlg::GetModulePath()
{
	CString strRet;
	char szModulePath[_MAX_PATH]={0};
	::GetModuleFileName(NULL,szModulePath,sizeof(szModulePath));       
	*(strrchr(szModulePath, '\\') + 1) = '\0'; 	
	strRet=szModulePath;
	return strRet;
}

BOOL	CCcdemoDlg::CreateFileTrans()
{
	if(!m_pFileTrans)
	{
		//创建前先注册文件传输的组件
		CString strPath=GetModulePath()+"qnvfiletrans.dll";
		//::ShellExecute(m_hWnd,"open","regsvr32","-u "+strPath,NULL,SW_SHOWNORMAL);//删除组件
		::ShellExecute(m_hWnd,"open","regsvr32","-s "+strPath,NULL,SW_SHOWNORMAL);//注册组件,不提示窗口
		//::ShellExecute(m_hWnd,"open","regsvr32",strPath,NULL,SW_SHOWNORMAL);//注册组件	

		m_pFileTrans = new CFileTrans();
		m_pFileTrans->Create(CFileTrans::IDD,CWnd::FromHandle(::GetDesktopWindow()));
	}else if(m_pFileTrans->IsIconic())
	{
		m_pFileTrans->ShowWindow(SW_RESTORE);
	}
	m_pFileTrans->ShowWindow(SW_SHOW);
	return TRUE;
}

BOOL	CCcdemoDlg::CloseFileTrans()
{
	if(m_pFileTrans)
	{
		m_pFileTrans->FreeSource();
		delete m_pFileTrans;
		m_pFileTrans=NULL;
	}
	return TRUE;
}

long	CCcdemoDlg::ShowEvent(PBRI_EVENT pEvent)
{
	CString strValue,str;
	strValue.Format("Handle=%d Result=%d Data=%s",pEvent->lEventHandle,pEvent->lResult,pEvent->szData);
	switch(pEvent->lEventType)
	{
	case BriEvent_CC_ConnectFailed:
		{
			str.Format("连接服务器失败");
		}break;
	case BriEvent_CC_LoginFailed://登陆失败
		{
			str.Format("登陆失败 原因=%d %s",pEvent->lResult,strValue);
			QNV_CCCtrl(QNV_CCCTRL_LOGOUT,NULL,0);//释放资源
			AfxMessageBox("登陆失败");
		}break;
	case BriEvent_CC_LoginSuccess:
		{
			str.Format("登陆成功 %s",strValue);
		}break;
	case BriEvent_CC_SystemTimeErr:
		{
			str.Format("本地系统时间错误 %s",strValue);
			AfxMessageBox("系统时间错误");
		}break;
	case BriEvent_CC_CallIn:
		{
			if(!m_pCCCall)//如果呼叫窗口不存在就创建后提示呼入事件,如果已经创建就忽略，呼叫窗口自己会接收事件
			{
				CreateCCCall();
				m_pCCCall->AppendCallIn(pEvent->lEventHandle,pEvent->szData);	
			}				
		}break;
	case BriEvent_CC_ReplyBusy:
		{
			str.Format("对方回复忙 \r\n%s",pEvent->szData);
		}break;
	case BriEvent_CC_RecvedMsg:
		{
			str.Format("接收到消息 \r\n%s",pEvent->szData);
			CreateCCMsg();
			m_pCCMsg->AppendRecvMsg(pEvent->szData);
		}break;
	case BriEvent_CC_RecvedCmd:
		{
			str.Format("接收到命令 \r\n%s",pEvent->szData);
			CreateCCCmd();
			m_pCCCmd->AppendRecvCmd(pEvent->szData);
		}break;
	case BriEvent_CC_RecvFileRequest:
		{
			str.Format("接收到文件请求 %s",strValue);
			CreateFileTrans();
			m_pFileTrans->AppendRecvFile(pEvent->lEventHandle,pEvent->szData);
		}break;
	case BriEvent_CC_TransFileFinished:
		{
			str.Format("传输文件结束 %s",strValue);
		}break;
	case BriEvent_CC_RegSuccess:
		{
			str.Format("注册CC成功 %s",pEvent->szData);
		}break;
	case BriEvent_CC_RegFailed:
		{
			str.Format("注册CC失败 %s",strValue);
		}break;
	case BriEvent_CC_ContactUpdateStatus:
		{
			str.Format("用户状态 %s",strValue);
		}break;
	default:break;
	}
	if(!str.IsEmpty())
		AppendStatus(str);
	return 1;
}

LRESULT CCcdemoDlg::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	if(message == BRI_EVENT_MESSAGE)//接收到事件
	{
		PBRI_EVENT pEvent=(PBRI_EVENT)lParam;//获取事件数据结构
		ShowEvent(pEvent);
	}	
	return CDialog::WindowProc(message, wParam, lParam);
}

//显示提示状态文本
void CCcdemoDlg::AppendStatus(CString strStatus)
{
	CString str,strTime;
	CTime ct=CTime::GetCurrentTime();
	strTime.Format("[%02d:%02d:%02d] %s",ct.GetHour(),ct.GetMinute(),ct.GetSecond(),strStatus);	
	CString strSrc;
	GetDlgItem(IDC_CCSTATUS)->GetWindowText(strSrc);
	if(strSrc.GetLength() > 16000)
		strSrc .Empty();
	str=strTime+"\r\n"+strSrc;
	GetDlgItem(IDC_CCSTATUS)->SetWindowText(str);
}

void CCcdemoDlg::OnDestroy() 
{
	CloseFileTrans();//关闭文件传输窗口
	CloseCCCall();//关闭语音呼叫窗口
	CloseCCCmd();//关闭命令窗口
	CloseCCMsg();//关闭消息窗口
	QNV_Event(CCCTRL_CHANNELID,QNV_EVENT_UNREGCBFUNC,(long)this,(char*)CallbackEvent,NULL,0);//删除回调函数
	QNV_CCCtrl(QNV_CCCTRL_LOGOUT,NULL,0);//离线
	QNV_CloseDevice(ODT_CC,0);//关闭CC模块
	CDialog::OnDestroy();	
}

BOOL CCcdemoDlg::OnCommand(WPARAM wParam, LPARAM lParam) 
{
	switch(wParam)
	{
	case ID_MENU_EXIT://退出
		{
			OnCancel();
		}break;
	case ID_MENU_LOGINCC://登陆CC
		{
			CLoginCC login;
			if(login.DoModal() == IDOK)
			{
				if(QNV_CCCtrl(QNV_CCCTRL_ISLOGON,NULL,0) > 0)
				{
					QNV_CCCtrl(QNV_CCCTRL_LOGOUT,NULL,0);
					AppendStatus("已经在线,先离线.");
				}
				CString strValue=login.m_strCCNumber+","+login.m_strCCPwd;//','分隔
				if(QNV_CCCtrl(QNV_CCCTRL_LOGIN,(char*)(LPCTSTR)strValue,0) <= 0)//开始登陆
				{
					AfxMessageBox("登陆失败,CC:"+login.m_strCCNumber);
				}
				else
					AppendStatus("开始登陆,CC: "+login.m_strCCNumber);
			}
		}break;
	case ID_MENU_REGCC://注册CC
		{//如果使用默认服务器,不是内部服务器,不能注册CC
			CRegCC	regcc;
			if(regcc.DoModal() == IDOK)
			{
				CString strValue=regcc.m_strRegCC+","+regcc.m_strRegPwd+","+regcc.m_strRegNick+","+regcc.m_strSvrID;//','分隔
				long lRet=QNV_CCCtrl(QNV_CCCTRL_REGCC,(char*)(LPCTSTR)strValue,0);
				if(lRet <= 0)//开始注册
				{
					CString strErr;
					strErr.Format("注册失败 错误ID=%d",lRet);
					AfxMessageBox(strErr);
				}
				else
					AppendStatus("正在注册...");
			}
		}break;
	case ID_MENU_SENDMSG://发送消息
		{
			CreateCCMsg();
		}break;
	case ID_MENU_SENDCMD://发送命令
		{
			CreateCCCmd();
		}break;
	case ID_MENU_CALLCC:
		{
			CInputCC inputcc;
			if(inputcc.DoModal() == IDOK)
			{
				CreateCCCall();
				m_pCCCall->CallCC(inputcc.m_strCC);
			}
		}break;
	case ID_MENU_SENDFILE:
		{
			CSendFile	send;
			if(send.DoModal() == IDOK)
			{
				CreateFileTrans();
				m_pFileTrans->StartSendFile(send.m_strDestCC,send.m_strFilePath);
			}
		}break;
	case ID_MENU_OFFLINE:
		{	
			QNV_CCCtrl(QNV_CCCTRL_LOGOUT,NULL,0);
			AppendStatus("CC已经离线");
		}break;
	case ID_MENU_SETSERVER:
		{
			SetSvrAddr();
		}break;
	case ID_MENU_CONTACT:
		{
			CContact contact;
			contact.DoModal();
		}break;
	default:
		break;
	}
	return CDialog::OnCommand(wParam, lParam);
}

long CCcdemoDlg::SetSvrAddr()
{
	if(QNV_CCCtrl(QNV_CCCTRL_ISLOGON,NULL,0) > 0)
	{
		AfxMessageBox("已经登陆不能修改服务器地址,请先离线");				
		return 0;
	}else
	{
		CInputSvrIP SvrIP;
		if(SvrIP.DoModal() == IDOK)
		{				
			AppendStatus("退出CC");
			if(QNV_CCCtrl(QNV_CCCTRL_SETSERVER,(char*)(LPCTSTR)SvrIP.m_strSvrIP,0) <= 0)
			{
				AppendStatus("修改服务器IP地址失败");
			}else
				AppendStatus("修改服务器IP地址完成,可以重新登陆..");
		}
		return 1;
	}
}

void CCcdemoDlg::OnCancel() 
{	
	CDialog::OnCancel();
}
