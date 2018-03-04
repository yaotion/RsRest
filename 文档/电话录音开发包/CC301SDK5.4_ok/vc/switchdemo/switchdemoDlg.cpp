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
	if(lRet == ERROR_INVALIDDLL) AfxMessageBox("DLL���Ϸ�");
	else if(lRet <= 0 || QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS) <= 0)
	{
		AfxMessageBox("���豸ʧ��,�����豸�Ƿ��Ѿ����벢��װ������,����û�����������Ѿ����豸");
	}else
	{		
		InitDevInfo();
		AppendStatus("��ʼ�����,����绰��/�绰����ȴ�����....");
		AppendStatus("��ѽ���Ļ�����PHONE-1��PHONE-N��ѭ�����....");
	}
	return 1;
}


CString CSwitchdemoDlg::GetModule(BRIINT16 chID)
{
	CString strModule;
	long lModule=QNV_DevInfo(chID,QNV_DEVINFO_GETMODULE);
	if(lModule&DEVMODULE_DOPLAY) strModule+="������/";
	if(lModule&DEVMODULE_CALLID) strModule+="��������ʾ/";
	if(lModule&DEVMODULE_PHONE) strModule+="��������/";
	if(lModule&DEVMODULE_SWITCH) strModule+="�Ͽ��绰��/";
	if(lModule&DEVMODULE_PLAY2TEL) strModule+="�����������绰��/";
	if(lModule&DEVMODULE_HOOK) strModule+="��ժ��/";
	if(lModule&DEVMODULE_MICSPK) strModule+="�ж���/MIC/";
	if(lModule&DEVMODULE_RING) strModule+="ģ�⻰������/";
	if(lModule&DEVMODULE_FAX) strModule+="�շ�����/";
	if(lModule&DEVMODULE_POLARITY) strModule+="�������/";
	return strModule;
}

void	CSwitchdemoDlg::InitDevInfo()
{
	CString str,strInfo;
	str.Format("���豸�ɹ� ͨ����=%d �豸��=%d",QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS),QNV_DevInfo(0,QNV_DEVINFO_GETCHIPS));
	AppendStatus(str);
	for(BRIINT16 i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{		
		QNV_Event(i,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);

		CSwitchChannel *pChannel=new CSwitchChannel();
		m_ChannelCtrlArray.Add(pChannel);
		pChannel->SetChannelCtrlID(i);
		pChannel->SetCBWndAndID(m_hWnd,DC_CALLBACK_MESSAGE);
		pChannel->StartSwitch();

		str.Format("ͨ��ID=%d �豸ID=%d ���к�=%d ͨ������=0x%x оƬ����=%d ģ��=%s",
			i,
			QNV_DevInfo(i,QNV_DEVINFO_GETDEVID),
			QNV_DevInfo(i,QNV_DEVINFO_GETSERIAL),						
			QNV_DevInfo(i,QNV_DEVINFO_GETTYPE),
			QNV_DevInfo(i,QNV_DEVINFO_GETCHIPTYPE),
			GetModule(i));
		AppendStatus(str);
#ifdef _DEBUG
		//QNV_SetDevCtrl(i,QNV_CTRL_WATCHDOG,0);//����״̬���������Ź�
#endif
	}
	QNV_Tool(QNV_TOOL_APMQUERYSUSPEND,FALSE,NULL,NULL,NULL,0);//��ֹϵͳ����
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
		//PBRI_EVENT pEvent=(PBRI_EVENT)lParam;//ֱ��ʹ���²���ڴ�ָ��,ʹ���ڼ���ڲβ��ܱ��ͷ�,�磺QNV_CloseDevice���ͷŸ��ڴ�
		memcpy((char*)pEvent,(char*)lParam,sizeof(BRI_EVENT));//�����ĺô��ǲ�����Ҫ�²���ڴ�ָ��,���Ա��ͷ�
		CString str,strValue;
		strValue.Format("Handle=%d Result=%d Data=%s",pEvent->lEventHandle,pEvent->lResult,pEvent->szData);
		switch(pEvent->lEventType)
		{
		case BriEvent_PhoneHook:
			{//�绰��ͨ����ݶԷ��迹��С�����������С,200��̫���м����200��̫��,100����
				QNV_SetParam(pEvent->uChannelID,QNV_PARAM_DTMFVOL,100);
				str.Format("ͨ��%d: �绰��ժ��,�޸ļ��DTMF������,dtmfvol=200,�����ⲻ���绰�����ž��޸ĸ�ֵ��С",pEvent->uChannelID+1);
			}break;
		case BriEvent_PhoneHang:
			{
				QNV_SetParam(pEvent->uChannelID,QNV_PARAM_DTMFVOL,10);
				str.Format("ͨ��%d: �绰���һ�,�޸ļ��DTMF������ dtmfvol=10",pEvent->uChannelID+1);
			}break;
		case BriEvent_CallIn:str.Format("ͨ��%d: �������� %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_GetCallID:str.Format("ͨ��%d: ���յ�������� %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_StopCallIn:str.Format("ͨ��%d: ֹͣ���룬����һ��δ�ӵ绰 %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_DialEnd:str.Format("ͨ��%d: ���Ž��� %s",pEvent->uChannelID+1,strValue);break;
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
		case BriEvent_RefuseEnd:str.Format("ͨ��%d: �ܽ�������� %s",pEvent->uChannelID+1,strValue);break;	
		case BriEvent_PSTNFree:
			{
				str.Format("ͨ��%d: PSTN��·�ѿ��� %s",pEvent->uChannelID+1,strValue);
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
