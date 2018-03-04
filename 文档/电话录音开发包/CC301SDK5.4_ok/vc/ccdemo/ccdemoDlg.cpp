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
//��ʼ������CCģ��
long	CCcdemoDlg::InitCCModule()
{
	if(QNV_OpenDevice(ODT_CC,0,QNV_CC_LICENSE) <= 0 )//����CCģ��
	{
		AppendStatus("����CCģ��ʧ��");
		AfxMessageBox("����CCģ��ʧ��");
		return 0;
	}else
	{
		//ע�᱾���ڽ���CCģ����¼�
		//��windowproc������յ�����Ϣ
		//QNV_Event(CCCTRL_CHANNELID,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);
		//ע��ʹ�ûص�������ʽ��ȡ�¼�,��������ϢֻҪ��ѡһ�Ϳ���
		QNV_Event(CCCTRL_CHANNELID,QNV_EVENT_REGCBFUNC,(long)this,(char*)CallbackEvent,NULL,0);
		//
		AppendStatus("����CCģ�����");
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
		//����ǰ��ע���ļ���������
		CString strPath=GetModulePath()+"qnvfiletrans.dll";
		//::ShellExecute(m_hWnd,"open","regsvr32","-u "+strPath,NULL,SW_SHOWNORMAL);//ɾ�����
		::ShellExecute(m_hWnd,"open","regsvr32","-s "+strPath,NULL,SW_SHOWNORMAL);//ע�����,����ʾ����
		//::ShellExecute(m_hWnd,"open","regsvr32",strPath,NULL,SW_SHOWNORMAL);//ע�����	

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
			str.Format("���ӷ�����ʧ��");
		}break;
	case BriEvent_CC_LoginFailed://��½ʧ��
		{
			str.Format("��½ʧ�� ԭ��=%d %s",pEvent->lResult,strValue);
			QNV_CCCtrl(QNV_CCCTRL_LOGOUT,NULL,0);//�ͷ���Դ
			AfxMessageBox("��½ʧ��");
		}break;
	case BriEvent_CC_LoginSuccess:
		{
			str.Format("��½�ɹ� %s",strValue);
		}break;
	case BriEvent_CC_SystemTimeErr:
		{
			str.Format("����ϵͳʱ����� %s",strValue);
			AfxMessageBox("ϵͳʱ�����");
		}break;
	case BriEvent_CC_CallIn:
		{
			if(!m_pCCCall)//������д��ڲ����ھʹ�������ʾ�����¼�,����Ѿ������ͺ��ԣ����д����Լ�������¼�
			{
				CreateCCCall();
				m_pCCCall->AppendCallIn(pEvent->lEventHandle,pEvent->szData);	
			}				
		}break;
	case BriEvent_CC_ReplyBusy:
		{
			str.Format("�Է��ظ�æ \r\n%s",pEvent->szData);
		}break;
	case BriEvent_CC_RecvedMsg:
		{
			str.Format("���յ���Ϣ \r\n%s",pEvent->szData);
			CreateCCMsg();
			m_pCCMsg->AppendRecvMsg(pEvent->szData);
		}break;
	case BriEvent_CC_RecvedCmd:
		{
			str.Format("���յ����� \r\n%s",pEvent->szData);
			CreateCCCmd();
			m_pCCCmd->AppendRecvCmd(pEvent->szData);
		}break;
	case BriEvent_CC_RecvFileRequest:
		{
			str.Format("���յ��ļ����� %s",strValue);
			CreateFileTrans();
			m_pFileTrans->AppendRecvFile(pEvent->lEventHandle,pEvent->szData);
		}break;
	case BriEvent_CC_TransFileFinished:
		{
			str.Format("�����ļ����� %s",strValue);
		}break;
	case BriEvent_CC_RegSuccess:
		{
			str.Format("ע��CC�ɹ� %s",pEvent->szData);
		}break;
	case BriEvent_CC_RegFailed:
		{
			str.Format("ע��CCʧ�� %s",strValue);
		}break;
	case BriEvent_CC_ContactUpdateStatus:
		{
			str.Format("�û�״̬ %s",strValue);
		}break;
	default:break;
	}
	if(!str.IsEmpty())
		AppendStatus(str);
	return 1;
}

LRESULT CCcdemoDlg::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	if(message == BRI_EVENT_MESSAGE)//���յ��¼�
	{
		PBRI_EVENT pEvent=(PBRI_EVENT)lParam;//��ȡ�¼����ݽṹ
		ShowEvent(pEvent);
	}	
	return CDialog::WindowProc(message, wParam, lParam);
}

//��ʾ��ʾ״̬�ı�
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
	CloseFileTrans();//�ر��ļ����䴰��
	CloseCCCall();//�ر��������д���
	CloseCCCmd();//�ر������
	CloseCCMsg();//�ر���Ϣ����
	QNV_Event(CCCTRL_CHANNELID,QNV_EVENT_UNREGCBFUNC,(long)this,(char*)CallbackEvent,NULL,0);//ɾ���ص�����
	QNV_CCCtrl(QNV_CCCTRL_LOGOUT,NULL,0);//����
	QNV_CloseDevice(ODT_CC,0);//�ر�CCģ��
	CDialog::OnDestroy();	
}

BOOL CCcdemoDlg::OnCommand(WPARAM wParam, LPARAM lParam) 
{
	switch(wParam)
	{
	case ID_MENU_EXIT://�˳�
		{
			OnCancel();
		}break;
	case ID_MENU_LOGINCC://��½CC
		{
			CLoginCC login;
			if(login.DoModal() == IDOK)
			{
				if(QNV_CCCtrl(QNV_CCCTRL_ISLOGON,NULL,0) > 0)
				{
					QNV_CCCtrl(QNV_CCCTRL_LOGOUT,NULL,0);
					AppendStatus("�Ѿ�����,������.");
				}
				CString strValue=login.m_strCCNumber+","+login.m_strCCPwd;//','�ָ�
				if(QNV_CCCtrl(QNV_CCCTRL_LOGIN,(char*)(LPCTSTR)strValue,0) <= 0)//��ʼ��½
				{
					AfxMessageBox("��½ʧ��,CC:"+login.m_strCCNumber);
				}
				else
					AppendStatus("��ʼ��½,CC: "+login.m_strCCNumber);
			}
		}break;
	case ID_MENU_REGCC://ע��CC
		{//���ʹ��Ĭ�Ϸ�����,�����ڲ�������,����ע��CC
			CRegCC	regcc;
			if(regcc.DoModal() == IDOK)
			{
				CString strValue=regcc.m_strRegCC+","+regcc.m_strRegPwd+","+regcc.m_strRegNick+","+regcc.m_strSvrID;//','�ָ�
				long lRet=QNV_CCCtrl(QNV_CCCTRL_REGCC,(char*)(LPCTSTR)strValue,0);
				if(lRet <= 0)//��ʼע��
				{
					CString strErr;
					strErr.Format("ע��ʧ�� ����ID=%d",lRet);
					AfxMessageBox(strErr);
				}
				else
					AppendStatus("����ע��...");
			}
		}break;
	case ID_MENU_SENDMSG://������Ϣ
		{
			CreateCCMsg();
		}break;
	case ID_MENU_SENDCMD://��������
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
			AppendStatus("CC�Ѿ�����");
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
		AfxMessageBox("�Ѿ���½�����޸ķ�������ַ,��������");				
		return 0;
	}else
	{
		CInputSvrIP SvrIP;
		if(SvrIP.DoModal() == IDOK)
		{				
			AppendStatus("�˳�CC");
			if(QNV_CCCtrl(QNV_CCCTRL_SETSERVER,(char*)(LPCTSTR)SvrIP.m_strSvrIP,0) <= 0)
			{
				AppendStatus("�޸ķ�����IP��ַʧ��");
			}else
				AppendStatus("�޸ķ�����IP��ַ���,�������µ�½..");
		}
		return 1;
	}
}

void CCcdemoDlg::OnCancel() 
{	
	CDialog::OnCancel();
}
