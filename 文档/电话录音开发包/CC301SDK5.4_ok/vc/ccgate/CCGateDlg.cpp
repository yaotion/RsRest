// CCGateDlg.cpp : implementation file
//

#include "stdafx.h"
#include "CCGate.h"
#include "CCGateDlg.h"

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
// CCCGateDlg dialog

CCCGateDlg::CCCGateDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CCCGateDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CCCGateDlg)
	m_strDestCC = _T("");
	m_strGateStatus = _T("");
	m_strServer = _T("");
	m_strCC = _T("");
	m_strPwd = _T("");
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CCCGateDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CCCGateDlg)
	DDX_Control(pDX, IDC_DESTCC, m_cDestCC);
	DDX_Control(pDX, IDC_GATESTATUS, m_cGateStatus);
	DDX_Text(pDX, IDC_DESTCC, m_strDestCC);
	DDV_MaxChars(pDX, m_strDestCC, 18);
	DDX_Text(pDX, IDC_GATESTATUS, m_strGateStatus);
	DDX_Text(pDX, IDC_SERVER, m_strServer);
	DDX_Text(pDX, IDC_CC, m_strCC);
	DDX_Text(pDX, IDC_PWD, m_strPwd);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CCCGateDlg, CDialog)
	//{{AFX_MSG_MAP(CCCGateDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_SETSERVER, OnSetserver)
	ON_BN_CLICKED(IDC_LOGON, OnLogon)
	ON_BN_CLICKED(IDC_LOGOUT, OnLogout)
	ON_WM_DESTROY()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CCCGateDlg message handlers

BOOL CCCGateDlg::OnInitDialog()
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
	
	if(OpenDev() <= 0)
	{
		AfxMessageBox("打开设备失败");
		CDialog::OnOK();
		return FALSE;
	}
	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CCCGateDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CCCGateDlg::OnPaint() 
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
HCURSOR CCCGateDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

//显示提示状态文本
void CCCGateDlg::AppendStatus(CString strStatus)
{
	CString str,strTime;
	CTime ct=CTime::GetCurrentTime();
	strTime.Format("[%02d:%02d:%02d] %s",ct.GetHour(),ct.GetMinute(),ct.GetSecond(),strStatus);	
	CString strSrc;
	GetDlgItem(IDC_GATESTATUS)->GetWindowText(strSrc);
	if(strSrc.GetLength() > 16000)
		strSrc .Empty();
	str=strTime+"\r\n"+strSrc;
	GetDlgItem(IDC_GATESTATUS)->SetWindowText(str);
}

long CCCGateDlg::CloseDev()
{
	QNV_CloseDevice(ODT_ALL,0);//关闭所有设备
	AppendStatus("关闭所有设备");
	return 0;
}

long CCCGateDlg::OpenDev()
{
	//打开所有BRIDGE设备
	if(QNV_OpenDevice(ODT_LBRIDGE,0,0) <= 0 || QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS) <= 0)
	{
		AppendStatus("打开设备失败");
		AfxMessageBox("打开设备失败");
		return 0;
	}
	for(BRIINT16 i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{//在windowproc处理接收到的消息
		QNV_Event(i,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);
	}
	//打开CC模块
	if(QNV_OpenDevice(ODT_CC,0,QNV_CC_LICENSE) <= 0 )//加载CC模块
	{
		AppendStatus("加载CC模块失败");
		AfxMessageBox("加载CC模块失败");
		return 0;
	}else
	{
		//注册本窗口接收CC模块的事件
		//在windowproc处理接收到的消息
		QNV_Event(CCCTRL_CHANNELID,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);
		AppendStatus("加载CC模块完成");		
	}
	memset((void*)&m_tagGateData[0],0,sizeof(m_tagGateData));
	AppendStatus("打开设备成功");	
	return 1;
}

void CCCGateDlg::OnSetserver() 
{
	UpdateData(TRUE);
	if(QNV_CCCtrl(QNV_CCCTRL_SETSERVER,(char*)(LPCTSTR)m_strServer,0) <= 0)
	{
		AppendStatus("修改服务器IP地址失败 "+m_strServer);
	}else
		AppendStatus("修改服务器IP地址完成,可以重新登陆.. "+m_strServer);	
}

void CCCGateDlg::OnLogon() 
{
	UpdateData(TRUE);
	if(QNV_CCCtrl(QNV_CCCTRL_ISLOGON,NULL,0) > 0)
	{
		QNV_CCCtrl(QNV_CCCTRL_LOGOUT,NULL,0);
		AppendStatus("已经在线,先离线.");
	}
	CString strValue=m_strCC+","+m_strPwd;//','分隔
	if(QNV_CCCtrl(QNV_CCCTRL_LOGIN,(char*)(LPCTSTR)strValue,0) <= 0)//开始登陆
	{
		AfxMessageBox("登陆失败,CC:"+m_strCC);
	}
	else
		AppendStatus("开始登陆,CC: "+m_strCC);	
}

void CCCGateDlg::OnLogout() 
{
	QNV_CCCtrl(QNV_CCCTRL_LOGOUT,NULL,0);
	AppendStatus("CC已经离线");	
}

void CCCGateDlg::OnDestroy() 
{
	CloseDev();
	CDialog::OnDestroy();	
}
//CC呼叫句柄所在的通道ID
long	CCCGateDlg::GetCCHandleGateID(long lCCHandle)
{
	for(int i=0;i<MAX_CHANNEL_COUNT;i++)
	{
		if(m_tagGateData[i].lCCHandle == lCCHandle) return i;
	}
	return -1;
}

long	CCCGateDlg::AnswerCCHandle(long lCCHandle)//CC接通，同时接通PSTN
{
	long lID=GetCCHandleGateID(lCCHandle);
	if(lID >= 0)
	{
		return AnswerChannel((short)lID);
	}else
		return 0;
}

long	CCCGateDlg::AnswerChannel(short uChannelID)//接通PSTN
{	
	ASSERT(uChannelID >= 0 && uChannelID < MAX_CHANNEL_COUNT);
	QNV_SetDevCtrl(uChannelID,QNV_CTRL_DOHOOK,1);//接通PSTN
	AppendStatus("接通线路");
	return 1;
}

long	CCCGateDlg::StopChannel(long lCCHandle)//CC呼叫停止，断开通道PSTN线路
{
	long lID=GetCCHandleGateID(lCCHandle);
	if(lID >= 0)
	{//如果已经是接通了
		QNV_SetDevCtrl(m_tagGateData[lID].uChannelID,QNV_CTRL_DOPHONE,TRUE);//话机可用
		if(QNV_GetDevCtrl(m_tagGateData[lID].uChannelID,QNV_CTRL_DOHOOK) > 0)
		{
			QNV_SetDevCtrl(m_tagGateData[lID].uChannelID,QNV_CTRL_DOHOOK,0);
		}else//还没有接通，直接调用拒接
		{
			QNV_General(m_tagGateData[lID].uChannelID,QNV_GENERAL_STARTREFUSE,0,0);
		}
		AppendStatus("停止通道转移");	
		memset((void*)&m_tagGateData[lID],0,sizeof(GATE_DATA));
		return 1;
	}else
		return 0;
}

long	CCCGateDlg::StopCallCC(short uChannelID)//PSTN断开了，停止转移到该CC
{
	ASSERT(uChannelID >= 0 && uChannelID < MAX_CHANNEL_COUNT);
	if(m_tagGateData[uChannelID].lCCHandle > 0)
	{
		QNV_CCCtrl_Call(QNV_CCCTRL_CALL_STOP,m_tagGateData[uChannelID].lCCHandle,NULL,0);
		memset((void*)&m_tagGateData[uChannelID],0,sizeof(GATE_DATA));
		AppendStatus("通道线路断开，停止转移到CC");
		return 1;
	}else
		return 0;
}
//开始转移到CC
long	CCCGateDlg::StartCallCC(PBRI_EVENT pEvent)
{	
	AppendStatus("启动呼叫转移到CC");
	CString strDestCC;
	m_cDestCC.GetWindowText(strDestCC);
	if(strDestCC.IsEmpty())
	{
		AppendStatus("目标CC为空,转移失败");
		return 0;
	}else
	{//呼叫CC，使用 pEvent->uChannelID通道做为语音输入输出设备
		ASSERT(strDestCC.GetLength() <= 18);
		CString strCallParam=strDestCC;
		if(strlen(pEvent->szData) > 0)//","分隔参数
		{
			strCallParam+=",";
			strCallParam+="2 1 ";//发送PSTN号码过去,(使用该格式可以兼容CC商务终端,如果转移到的目标CC是使用CC商务终端登陆的话就可以在界面弹出接收到的来电号码)
			strCallParam+=pEvent->szData;			
		}
		m_tagGateData[pEvent->uChannelID].lCCHandle=QNV_CCCtrl_Call(QNV_CCCTRL_CALL_START,0,(char*)(LPCTSTR)strCallParam,pEvent->uChannelID);
		if(m_tagGateData[pEvent->uChannelID].lCCHandle > 0)
		{
			m_tagGateData[pEvent->uChannelID].uChannelID=pEvent->uChannelID;
			strcpy(m_tagGateData[pEvent->uChannelID].szCC,(char*)(LPCTSTR)strDestCC);
			AppendStatus("启动呼叫转移成功 CC:"+strDestCC);
			//----------
			//如果直接先接通，因为正在转移CC，无任何声音，就需要考虑给对方播放等候提示音，等CC接通后停止播放提示音
			//AnswerChannel(pEvent->uChannelID);
			//
			QNV_SetDevCtrl((short)pEvent->uChannelID,QNV_CTRL_DOPHONE,TRUE);//话机可用
			QNV_SetDevCtrl((short)pEvent->uChannelID,QNV_CTRL_SELECTLINEIN,LINEIN_ID_2);//使用线路录音
			return 1;
		}
		else
		{
			AppendStatus("呼叫CC失败:"+strDestCC);
			return 0;
		}
	}
}

long	CCCGateDlg::AcceptCCCallIn(PBRI_EVENT pEvent)//应答CC呼入
{	
	long nChannelID=0;//使用设备通道
//	m_tagGateData[(short)nChannelID].lCCHandle=pEvent->lEventHandle;
//	m_tagGateData[(short)nChannelID].uChannelID=(short)nChannelID;
	QNV_SetDevCtrl((short)nChannelID,QNV_CTRL_DOPHONE,FALSE);//话机不可用
	QNV_SetDevCtrl((short)nChannelID,QNV_CTRL_SELECTLINEIN,LINEIN_ID_1);//使用话机话柄
	if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_ACCEPT,pEvent->lEventHandle,NULL,nChannelID) <= 0)//应答
	{
		AfxMessageBox("应答失败");
	}
	CString str;
	str.Format("拿起话机通道%d话机进行通话:",nChannelID);
	AppendStatus(str);
	return nChannelID;
}

LRESULT CCCGateDlg::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	if(message == BRI_EVENT_MESSAGE)//接收到事件
	{
		PBRI_EVENT pEvent=(PBRI_EVENT)lParam;//获取事件数据结构
		CString strValue,str;
		strValue.Format("Handle=%d Result=%d Data=%s",pEvent->lEventHandle,pEvent->lResult,pEvent->szData);
		switch(pEvent->lEventType)
		{
		case BriEvent_PhoneHook:str.Format("通道%d: 电话机摘机 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_PhoneHang:str.Format("通道%d: 电话机挂机 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_CallIn:
			{
				//两声响铃结束后开始呼叫转移到CC
				if(pEvent->lResult == 2 
					&& pEvent->szData[0] == RING_END_SIGN_CH 
					&& m_tagGateData[pEvent->uChannelID].lCCHandle == 0)
				{
					StartCallCC(pEvent);
					return 1;
				}else
				{
					str.Format("通道%d: 来电响铃 %s",pEvent->uChannelID+1,strValue);
				}
			}break;
		case BriEvent_GetCallID:
			{
				str.Format("通道%d: 接收到来电号码 %s",pEvent->uChannelID+1,strValue);
				AppendStatus(str);
				//如果接收到来电号码就立即开始呼叫转移到CC
				StartCallCC(pEvent);
				//
				return 1;
			}break;
		case BriEvent_StopCallIn:
			{
				StopCallCC(pEvent->uChannelID);
				str.Format("通道%d: 停止呼入，产生一个未接电话 %s",pEvent->uChannelID+1,strValue);
			}break;
		case BriEvent_GetDTMFChar:str.Format("通道%d: 接收到按键 %s",pEvent->uChannelID+1,strValue);break;		
		case BriEvent_RemoteHang:
			{
				StopCallCC(pEvent->uChannelID);
				str.Format("通道%d: 远程挂机 %s",pEvent->uChannelID+1,strValue);
			}break;
		case BriEvent_Busy:
			{
				StopCallCC(pEvent->uChannelID);
				str.Format("通道%d: 接收到忙音,线路已经断开 %s",pEvent->uChannelID+1,strValue);
			}break;
		case BriEvent_DialTone:str.Format("通道%d: 检测到拨号音 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_PhoneDial:str.Format("通道%d: 电话机拨号 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_RingBack:str.Format("通道%d: 拨号后接收到回铃音 %s",pEvent->uChannelID+1,strValue);break;

		case BriEvent_CC_ConnectFailed:str.Format("连接服务器失败");break;
		case BriEvent_CC_LoginFailed://登陆失败
			{
				str.Format("登陆失败 原因=%d %s",pEvent->lResult,strValue);
				QNV_CCCtrl(QNV_CCCTRL_LOGOUT,NULL,0);//释放资源
				AfxMessageBox("登陆失败");
			}break;
		case BriEvent_CC_CallOutSuccess:str.Format("正在呼叫... %s",strValue);break;
		case BriEvent_CC_CallOutFailed:
			{				
				QNV_CCCtrl_Call(QNV_CCCTRL_CALL_STOP,pEvent->lEventType,NULL,0);//停止CC呼叫
				StopChannel(pEvent->lEventHandle);//停止PSTN通道
				str.Format("呼叫失败 原因=%d ",pEvent->lResult);				
			}break;
		case BriEvent_CC_Connected:
			{
				AnswerCCHandle(pEvent->lEventHandle);
				str.Format("CC已经连通 %s",strValue);				
			}break;
		case BriEvent_CC_CallFinished:
			{
				StopChannel(pEvent->lEventHandle);
				str.Format("呼叫结束 原因=%d",pEvent->lResult);
			}break;

		case BriEvent_CC_LoginSuccess:str.Format("登陆成功 %s",strValue);break;
		case BriEvent_CC_CallIn:
			{
				str.Format("CC呼入 %s",strValue);
				AcceptCCCallIn(pEvent);
				break;
			}
		case BriEvent_CC_ReplyBusy:str.Format("对方回复忙 \r\n%s",pEvent->szData);break;
		case BriEvent_CC_RecvedMsg:str.Format("接收到消息 \r\n%s",pEvent->szData);break;
		case BriEvent_CC_RecvedCmd:str.Format("接收到命令 \r\n%s",pEvent->szData);break;
		default:break;
		}
		if(!str.IsEmpty())
			AppendStatus(str);
	}			
	return CDialog::WindowProc(message, wParam, lParam);
}
