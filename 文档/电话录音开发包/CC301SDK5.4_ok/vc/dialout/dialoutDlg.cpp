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
	if(lRet == ERROR_INVALIDDLL) AfxMessageBox("DLL���Ϸ�");
	else if(lRet <= 0 || QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS) <= 0)
	{
		AfxMessageBox("���豸ʧ��,�����豸�Ƿ��Ѿ����벢��װ������,����û�����������Ѿ����豸");
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
	case DEVTYPE_A1:str+="(������ A1)";break;
	case DEVTYPE_A2:str+="(������ A2)";break;
	case DEVTYPE_A3:str+="(������ A3)";break;
	case DEVTYPE_A4:str+="(������ A4)";break;
	case DEVTYPE_B1:str+="(������ B1)";break;
	case DEVTYPE_B2:str+="(������ B2)";break;
	case DEVTYPE_B3:str+="(������ B3)";break;
	case DEVTYPE_B4:str+="(������ B4)";break;
	case DEVTYPE_C4_L:str+="(������ C4-L)";break;
	case DEVTYPE_C4_P:str+="(������ C4-P)";break;
	case DEVTYPE_C4_LP:str+="(������ C4-LP)";break;
	case DEVTYPE_C4_LPQ:str+="(������ C4-LPQ)";break;
	case DEVTYPE_C7_L:str+="(������ C7-L)";break;
	case DEVTYPE_C7_P:str+="(������ C7-P)";break;
	case DEVTYPE_C7_LP:str+="(������ C7-LP)";break;
	case DEVTYPE_C7_LPQ:str+="(������ C7-LPQ)";break;
	case DEVTYPE_R1:str+="(������ R1)";break;
	case DEVTYPE_C4_R:str+="(������ C4-R)";break;
	case DEVTYPE_C7_R:str+="(������ C7-R)";break;
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
	if(lModule&DEVMODULE_DOPLAY) strModule+="������/";
	if(lModule&DEVMODULE_CALLID) strModule+="��������ʾ/";
	if(lModule&DEVMODULE_PHONE) strModule+="��������/";
	if(lModule&DEVMODULE_SWITCH) strModule+="�Ͽ��绰��,���ջ�������/";
	if(lModule&DEVMODULE_PLAY2TEL) strModule+="�����������绰��/";
	if(lModule&DEVMODULE_HOOK) strModule+="��ժ��/";
	if(lModule&DEVMODULE_MICSPK) strModule+="�ж���/MIC/";
	if(lModule&DEVMODULE_RING) strModule+="ģ�⻰������/";
	if(lModule&DEVMODULE_FAX) strModule+="�շ�����/";
	if(lModule&DEVMODULE_POLARITY) strModule+="�������/";
	return strModule;
}

void	CDialoutDlg::InitDevInfo()
{
	CString str,strInfo;
	str.Format("���豸�ɹ� ͨ����=%d �豸��=%d",QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS),QNV_DevInfo(0,QNV_DEVINFO_GETCHIPS));
	AppendStatus(str);
	for(BRIINT16 i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{
		//���س������� 010,���ó������ź�������еĺ��뿪ͷ�����س���������ͬʱ��ϵͳ�Զ���������
		//�磺�������������010
		//startdial("01082891111"),ϵͳ�Զ�ת����startdial("82891111");
		//startdial("9,,;01082891111"),ϵͳ�Զ�ת����startdial("9,,82891111");//';'->Ϊ�����ڲ��������ŵı��
		//QNV_SetParam(i,QNV_PARAM_CITYCODE,10);//��������Ϊ����:010,����ʱ��һ��0����д�������һ��Ϊ0����������ʶ����������� �磺vc��010->8(�˽��Ƶ�10=8)

		str.Format("ͨ��ID=%d �豸ID=%d ���к�=%d �豸����=%s оƬ����=%d ģ��=%s",
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
		QNV_Event(i,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);//ʹ�ô�����Ϣ��ʽ��ȡ�¼�
	}
	
	QNV_Tool(QNV_TOOL_APMQUERYSUSPEND,FALSE,NULL,NULL,NULL,0);//��ֹϵͳ����
	QNV_Tool(QNV_TOOL_SETUSERVALUE,SUD_WRITEFILE|SUD_ENCRYPT,"serverip","192.168.0.120",0,0);//������������,serverip������Ϊ 192.168.0.120,��ֵ�����Ӳ�̣��˳�����󲢲��ͷţ��´��������ܶ�ȡ
	QNV_Tool(QNV_TOOL_SETUSERVALUE,2,"uupwd","bbbb",0,0);
	QNV_Tool(QNV_TOOL_SETUSERVALUE,1,"uuname","aaaa",0,0);
	char szOutBuf[256]={0};
	QNV_Tool(QNV_TOOL_GETUSERVALUE,SUD_ENCRYPT,"serverip",0,szOutBuf,256);//��ȡ�������������,���ر����192.168.0.120	
	
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
			{//�绰��ͨ����ݶԷ��迹��С�����������С,200��̫���м����200��̫��,100����
				QNV_SetParam(pEvent->uChannelID,QNV_PARAM_DTMFVOL,50);
				if(QNV_General(pEvent->uChannelID,QNV_GENERAL_ISDIALING,0,NULL) <= 0)
				{
					//QNV_SetDevCtrl(pEvent->uChannelID,QNV_CTRL_DOHOOK,0);//û�����ڲ��ſ��Կ����Զ���һ�,����3��ͨ��״̬���������б���������
				}
				str.Format("ͨ��%d: �绰��ժ��,�޸ļ��DTMF������,dtmfvol=50,�����ⲻ���绰�����ž��޸ĸ�ֵ��С",pEvent->uChannelID+1);
			}break;
		case BriEvent_PhoneHang:
			{
				QNV_SetParam(pEvent->uChannelID,QNV_PARAM_DTMFVOL,10);
				str.Format("ͨ��%d: �绰���һ�,�޸ļ��DTMF������ dtmfvol=10",pEvent->uChannelID+1);
			}break;
		case BriEvent_CallIn:str.Format("ͨ��%d: �������� %s",pEvent->uChannelID+1,strValue);break;
		//case BriEvent_CallInEx:str.Format("ͨ��%d: Ӳ������������ %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_GetCallID:str.Format("ͨ��%d: ���յ�������� %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_StopCallIn:str.Format("ͨ��%d: ֹͣ���룬����һ��δ�ӵ绰 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_DialEnd:
			{				
				if(QNV_GetDevCtrl(pEvent->uChannelID,QNV_CTRL_PHONE) > 0)
				{//�绰���Ѿ����ſ��Կ����Զ���һ�
					//����3��ͨ��״̬���������б���������
					//��������̫����·�ϵĵ�
					Sleep(500);
					QNV_SetDevCtrl(pEvent->uChannelID,QNV_CTRL_DOHOOK,0);					
				}
				QNV_SetParam(pEvent->uChannelID,QNV_PARAM_HANGUPELAPSE,500);
				str.Format("ͨ��%d: ���Ž��� %s",pEvent->uChannelID+1,strValue);
			}break;
		case BriEvent_PlayFileEnd:str.Format("ͨ��%d: �����ļ����� %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_PlayMultiFileEnd:str.Format("ͨ��%d: ���ļ��������� %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_RepeatPlayFile:str.Format("ͨ��%d: ѭ�������ļ� %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_PlayStringEnd:str.Format("ͨ��%d: �����ַ����� %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_SendCallIDEnd:str.Format("ͨ��%d: ����������ʱ���ͺ������ %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_Silence:str.Format("ͨ��%d: ͨ����һ��ʱ��ľ��� %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_GetDTMFChar:str.Format("ͨ��%d: ���յ����� %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_RemoteHook:str.Format("ͨ��%d: Զ��ժ�� %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_RemoteHang:str.Format("ͨ��%d: Զ�̹һ� %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_Busy:str.Format("ͨ��%d: ���յ�æ��,��·�Ѿ��Ͽ� %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_DialTone:str.Format("ͨ��%d: ��⵽������ %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_PhoneDial:str.Format("ͨ��%d: �绰������ %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_RingBack:str.Format("ͨ��%d: ���ź���յ������� %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_MicIn:str.Format("ͨ��%d: ��˷���� %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_MicOut:str.Format("ͨ��%d: ��˷�γ� %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_FlashEnd:str.Format("ͨ��%d: �Ĳ����� %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_RemoteSendFax:str.Format("ͨ��%d: �Է�׼�����ʹ��� %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_FaxRecvFinished:str.Format("ͨ��%d: ���մ������ %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_FaxRecvFailed:str.Format("ͨ��%d: ���մ���ʧ�� %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_FaxSendFinished:str.Format("ͨ��%d: ���ʹ������ %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_FaxSendFailed:str.Format("ͨ��%d: ���ʹ���ʧ�� %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_RefuseEnd:str.Format("ͨ��%d: �ܽ�������� %s",pEvent->uChannelID+1,strValue);break;	
		case BriEvent_PSTNFree:
			{
				str.Format("ͨ��%d: PSTN��·�ѿ��� %s",pEvent->uChannelID+1,strValue);
			}break;	
		case BriEvent_DevErr:
			{
				
			}break;
		case BriEvent_EnableHook:
			{
				str.Format("ͨ��%d: HOOK������ lResult=%d",pEvent->uChannelID+1,pEvent->lResult);				
			}break;
		case BriEvent_EnablePlay:
			{
				str.Format("ͨ��%d: ���ȱ����� lResult=%d",pEvent->uChannelID+1,pEvent->lResult);
			}break;
		case BriEvent_EnablePlayMux:
			{
				str.Format("ͨ��%d: ����mux�޸� lResult=%d",pEvent->uChannelID+1,pEvent->lResult);
			}break;
		default:
			{
				str.Format("ͨ��%d: ���������¼� eventid=%d lResult=%d",pEvent->uChannelID+1,pEvent->lEventType,pEvent->lResult);
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
		//PBRI_EVENT pEvent=(PBRI_EVENT)lParam;//ֱ��ʹ���²���ڴ�ָ��,ʹ���ڼ���ڲβ��ܱ��ͷ�,�磺QNV_CloseDevice���ͷŸ��ڴ�
		memcpy((char*)pEvent,(char*)lParam,sizeof(BRI_EVENT));//�����ĺô��ǲ�����Ҫ�²���ڴ�ָ��,���Ա��ͷ�
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
			//strValue.Format("ͨ��[%d] type=%d Handle=%d Result=%d Data=%s",i,tEvent.lEventType,tEvent.lEventHandle,tEvent.lResult,tEvent.szData);
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
		AppendStatus("����ʧ��");
	}else
	{
		AppendStatus("��ʼ����:"+m_strCode);
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
