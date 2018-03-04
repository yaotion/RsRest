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
		AfxMessageBox("���豸ʧ��");
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

//��ʾ��ʾ״̬�ı�
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
	QNV_CloseDevice(ODT_ALL,0);//�ر������豸
	AppendStatus("�ر������豸");
	return 0;
}

long CCCGateDlg::OpenDev()
{
	//������BRIDGE�豸
	if(QNV_OpenDevice(ODT_LBRIDGE,0,0) <= 0 || QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS) <= 0)
	{
		AppendStatus("���豸ʧ��");
		AfxMessageBox("���豸ʧ��");
		return 0;
	}
	for(BRIINT16 i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{//��windowproc������յ�����Ϣ
		QNV_Event(i,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);
	}
	//��CCģ��
	if(QNV_OpenDevice(ODT_CC,0,QNV_CC_LICENSE) <= 0 )//����CCģ��
	{
		AppendStatus("����CCģ��ʧ��");
		AfxMessageBox("����CCģ��ʧ��");
		return 0;
	}else
	{
		//ע�᱾���ڽ���CCģ����¼�
		//��windowproc������յ�����Ϣ
		QNV_Event(CCCTRL_CHANNELID,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);
		AppendStatus("����CCģ�����");		
	}
	memset((void*)&m_tagGateData[0],0,sizeof(m_tagGateData));
	AppendStatus("���豸�ɹ�");	
	return 1;
}

void CCCGateDlg::OnSetserver() 
{
	UpdateData(TRUE);
	if(QNV_CCCtrl(QNV_CCCTRL_SETSERVER,(char*)(LPCTSTR)m_strServer,0) <= 0)
	{
		AppendStatus("�޸ķ�����IP��ַʧ�� "+m_strServer);
	}else
		AppendStatus("�޸ķ�����IP��ַ���,�������µ�½.. "+m_strServer);	
}

void CCCGateDlg::OnLogon() 
{
	UpdateData(TRUE);
	if(QNV_CCCtrl(QNV_CCCTRL_ISLOGON,NULL,0) > 0)
	{
		QNV_CCCtrl(QNV_CCCTRL_LOGOUT,NULL,0);
		AppendStatus("�Ѿ�����,������.");
	}
	CString strValue=m_strCC+","+m_strPwd;//','�ָ�
	if(QNV_CCCtrl(QNV_CCCTRL_LOGIN,(char*)(LPCTSTR)strValue,0) <= 0)//��ʼ��½
	{
		AfxMessageBox("��½ʧ��,CC:"+m_strCC);
	}
	else
		AppendStatus("��ʼ��½,CC: "+m_strCC);	
}

void CCCGateDlg::OnLogout() 
{
	QNV_CCCtrl(QNV_CCCTRL_LOGOUT,NULL,0);
	AppendStatus("CC�Ѿ�����");	
}

void CCCGateDlg::OnDestroy() 
{
	CloseDev();
	CDialog::OnDestroy();	
}
//CC���о�����ڵ�ͨ��ID
long	CCCGateDlg::GetCCHandleGateID(long lCCHandle)
{
	for(int i=0;i<MAX_CHANNEL_COUNT;i++)
	{
		if(m_tagGateData[i].lCCHandle == lCCHandle) return i;
	}
	return -1;
}

long	CCCGateDlg::AnswerCCHandle(long lCCHandle)//CC��ͨ��ͬʱ��ͨPSTN
{
	long lID=GetCCHandleGateID(lCCHandle);
	if(lID >= 0)
	{
		return AnswerChannel((short)lID);
	}else
		return 0;
}

long	CCCGateDlg::AnswerChannel(short uChannelID)//��ͨPSTN
{	
	ASSERT(uChannelID >= 0 && uChannelID < MAX_CHANNEL_COUNT);
	QNV_SetDevCtrl(uChannelID,QNV_CTRL_DOHOOK,1);//��ͨPSTN
	AppendStatus("��ͨ��·");
	return 1;
}

long	CCCGateDlg::StopChannel(long lCCHandle)//CC����ֹͣ���Ͽ�ͨ��PSTN��·
{
	long lID=GetCCHandleGateID(lCCHandle);
	if(lID >= 0)
	{//����Ѿ��ǽ�ͨ��
		QNV_SetDevCtrl(m_tagGateData[lID].uChannelID,QNV_CTRL_DOPHONE,TRUE);//��������
		if(QNV_GetDevCtrl(m_tagGateData[lID].uChannelID,QNV_CTRL_DOHOOK) > 0)
		{
			QNV_SetDevCtrl(m_tagGateData[lID].uChannelID,QNV_CTRL_DOHOOK,0);
		}else//��û�н�ͨ��ֱ�ӵ��þܽ�
		{
			QNV_General(m_tagGateData[lID].uChannelID,QNV_GENERAL_STARTREFUSE,0,0);
		}
		AppendStatus("ֹͣͨ��ת��");	
		memset((void*)&m_tagGateData[lID],0,sizeof(GATE_DATA));
		return 1;
	}else
		return 0;
}

long	CCCGateDlg::StopCallCC(short uChannelID)//PSTN�Ͽ��ˣ�ֹͣת�Ƶ���CC
{
	ASSERT(uChannelID >= 0 && uChannelID < MAX_CHANNEL_COUNT);
	if(m_tagGateData[uChannelID].lCCHandle > 0)
	{
		QNV_CCCtrl_Call(QNV_CCCTRL_CALL_STOP,m_tagGateData[uChannelID].lCCHandle,NULL,0);
		memset((void*)&m_tagGateData[uChannelID],0,sizeof(GATE_DATA));
		AppendStatus("ͨ����·�Ͽ���ֹͣת�Ƶ�CC");
		return 1;
	}else
		return 0;
}
//��ʼת�Ƶ�CC
long	CCCGateDlg::StartCallCC(PBRI_EVENT pEvent)
{	
	AppendStatus("��������ת�Ƶ�CC");
	CString strDestCC;
	m_cDestCC.GetWindowText(strDestCC);
	if(strDestCC.IsEmpty())
	{
		AppendStatus("Ŀ��CCΪ��,ת��ʧ��");
		return 0;
	}else
	{//����CC��ʹ�� pEvent->uChannelIDͨ����Ϊ������������豸
		ASSERT(strDestCC.GetLength() <= 18);
		CString strCallParam=strDestCC;
		if(strlen(pEvent->szData) > 0)//","�ָ�����
		{
			strCallParam+=",";
			strCallParam+="2 1 ";//����PSTN�����ȥ,(ʹ�øø�ʽ���Լ���CC�����ն�,���ת�Ƶ���Ŀ��CC��ʹ��CC�����ն˵�½�Ļ��Ϳ����ڽ��浯�����յ����������)
			strCallParam+=pEvent->szData;			
		}
		m_tagGateData[pEvent->uChannelID].lCCHandle=QNV_CCCtrl_Call(QNV_CCCTRL_CALL_START,0,(char*)(LPCTSTR)strCallParam,pEvent->uChannelID);
		if(m_tagGateData[pEvent->uChannelID].lCCHandle > 0)
		{
			m_tagGateData[pEvent->uChannelID].uChannelID=pEvent->uChannelID;
			strcpy(m_tagGateData[pEvent->uChannelID].szCC,(char*)(LPCTSTR)strDestCC);
			AppendStatus("��������ת�Ƴɹ� CC:"+strDestCC);
			//----------
			//���ֱ���Ƚ�ͨ����Ϊ����ת��CC�����κ�����������Ҫ���Ǹ��Է����ŵȺ���ʾ������CC��ͨ��ֹͣ������ʾ��
			//AnswerChannel(pEvent->uChannelID);
			//
			QNV_SetDevCtrl((short)pEvent->uChannelID,QNV_CTRL_DOPHONE,TRUE);//��������
			QNV_SetDevCtrl((short)pEvent->uChannelID,QNV_CTRL_SELECTLINEIN,LINEIN_ID_2);//ʹ����·¼��
			return 1;
		}
		else
		{
			AppendStatus("����CCʧ��:"+strDestCC);
			return 0;
		}
	}
}

long	CCCGateDlg::AcceptCCCallIn(PBRI_EVENT pEvent)//Ӧ��CC����
{	
	long nChannelID=0;//ʹ���豸ͨ��
//	m_tagGateData[(short)nChannelID].lCCHandle=pEvent->lEventHandle;
//	m_tagGateData[(short)nChannelID].uChannelID=(short)nChannelID;
	QNV_SetDevCtrl((short)nChannelID,QNV_CTRL_DOPHONE,FALSE);//����������
	QNV_SetDevCtrl((short)nChannelID,QNV_CTRL_SELECTLINEIN,LINEIN_ID_1);//ʹ�û�������
	if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_ACCEPT,pEvent->lEventHandle,NULL,nChannelID) <= 0)//Ӧ��
	{
		AfxMessageBox("Ӧ��ʧ��");
	}
	CString str;
	str.Format("���𻰻�ͨ��%d��������ͨ��:",nChannelID);
	AppendStatus(str);
	return nChannelID;
}

LRESULT CCCGateDlg::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	if(message == BRI_EVENT_MESSAGE)//���յ��¼�
	{
		PBRI_EVENT pEvent=(PBRI_EVENT)lParam;//��ȡ�¼����ݽṹ
		CString strValue,str;
		strValue.Format("Handle=%d Result=%d Data=%s",pEvent->lEventHandle,pEvent->lResult,pEvent->szData);
		switch(pEvent->lEventType)
		{
		case BriEvent_PhoneHook:str.Format("ͨ��%d: �绰��ժ�� %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_PhoneHang:str.Format("ͨ��%d: �绰���һ� %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_CallIn:
			{
				//�������������ʼ����ת�Ƶ�CC
				if(pEvent->lResult == 2 
					&& pEvent->szData[0] == RING_END_SIGN_CH 
					&& m_tagGateData[pEvent->uChannelID].lCCHandle == 0)
				{
					StartCallCC(pEvent);
					return 1;
				}else
				{
					str.Format("ͨ��%d: �������� %s",pEvent->uChannelID+1,strValue);
				}
			}break;
		case BriEvent_GetCallID:
			{
				str.Format("ͨ��%d: ���յ�������� %s",pEvent->uChannelID+1,strValue);
				AppendStatus(str);
				//������յ���������������ʼ����ת�Ƶ�CC
				StartCallCC(pEvent);
				//
				return 1;
			}break;
		case BriEvent_StopCallIn:
			{
				StopCallCC(pEvent->uChannelID);
				str.Format("ͨ��%d: ֹͣ���룬����һ��δ�ӵ绰 %s",pEvent->uChannelID+1,strValue);
			}break;
		case BriEvent_GetDTMFChar:str.Format("ͨ��%d: ���յ����� %s",pEvent->uChannelID+1,strValue);break;		
		case BriEvent_RemoteHang:
			{
				StopCallCC(pEvent->uChannelID);
				str.Format("ͨ��%d: Զ�̹һ� %s",pEvent->uChannelID+1,strValue);
			}break;
		case BriEvent_Busy:
			{
				StopCallCC(pEvent->uChannelID);
				str.Format("ͨ��%d: ���յ�æ��,��·�Ѿ��Ͽ� %s",pEvent->uChannelID+1,strValue);
			}break;
		case BriEvent_DialTone:str.Format("ͨ��%d: ��⵽������ %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_PhoneDial:str.Format("ͨ��%d: �绰������ %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_RingBack:str.Format("ͨ��%d: ���ź���յ������� %s",pEvent->uChannelID+1,strValue);break;

		case BriEvent_CC_ConnectFailed:str.Format("���ӷ�����ʧ��");break;
		case BriEvent_CC_LoginFailed://��½ʧ��
			{
				str.Format("��½ʧ�� ԭ��=%d %s",pEvent->lResult,strValue);
				QNV_CCCtrl(QNV_CCCTRL_LOGOUT,NULL,0);//�ͷ���Դ
				AfxMessageBox("��½ʧ��");
			}break;
		case BriEvent_CC_CallOutSuccess:str.Format("���ں���... %s",strValue);break;
		case BriEvent_CC_CallOutFailed:
			{				
				QNV_CCCtrl_Call(QNV_CCCTRL_CALL_STOP,pEvent->lEventType,NULL,0);//ֹͣCC����
				StopChannel(pEvent->lEventHandle);//ֹͣPSTNͨ��
				str.Format("����ʧ�� ԭ��=%d ",pEvent->lResult);				
			}break;
		case BriEvent_CC_Connected:
			{
				AnswerCCHandle(pEvent->lEventHandle);
				str.Format("CC�Ѿ���ͨ %s",strValue);				
			}break;
		case BriEvent_CC_CallFinished:
			{
				StopChannel(pEvent->lEventHandle);
				str.Format("���н��� ԭ��=%d",pEvent->lResult);
			}break;

		case BriEvent_CC_LoginSuccess:str.Format("��½�ɹ� %s",strValue);break;
		case BriEvent_CC_CallIn:
			{
				str.Format("CC���� %s",strValue);
				AcceptCCCallIn(pEvent);
				break;
			}
		case BriEvent_CC_ReplyBusy:str.Format("�Է��ظ�æ \r\n%s",pEvent->szData);break;
		case BriEvent_CC_RecvedMsg:str.Format("���յ���Ϣ \r\n%s",pEvent->szData);break;
		case BriEvent_CC_RecvedCmd:str.Format("���յ����� \r\n%s",pEvent->szData);break;
		default:break;
		}
		if(!str.IsEmpty())
			AppendStatus(str);
	}			
	return CDialog::WindowProc(message, wParam, lParam);
}
