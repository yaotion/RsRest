// ConferenceDemoDlg.cpp : implementation file
//

#include "stdafx.h"
#include "ConferenceDemo.h"
#include "ConferenceDemoDlg.h"

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
// CConferenceDemoDlg dialog

CConferenceDemoDlg::CConferenceDemoDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CConferenceDemoDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CConferenceDemoDlg)
	m_strDialCode = _T("");
	m_nSpkVolume = 100;
	m_nMicVolume = 100;
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
	m_lCurSelConfID= 0;
}

void CConferenceDemoDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CConferenceDemoDlg)
	DDX_Control(pDX, IDC_SELECTLINE, m_cSelectLine);
	DDX_Control(pDX, IDC_MICVOLUME, m_cMicVolume);
	DDX_Control(pDX, IDC_SPKVOLUME, m_cSpkVolume);
	DDX_Control(pDX, IDC_ADBUSY, m_cAdBusy);
	DDX_Control(pDX, IDC_DISABLESPK, m_cDisableSpk);
	DDX_Control(pDX, IDC_DISABLEMIC, m_cDisableMic);
	DDX_Control(pDX, IDC_CHANNELLIST, m_cChannelList);
	DDX_Control(pDX, IDC_DOPHONE, m_cDoPhone);
	DDX_Control(pDX, IDC_CONFLIST, m_cConfList);
	DDX_Control(pDX, IDC_COMBOCHANNEL, m_cComboChannel);
	DDX_Control(pDX, IDC_DOHOOK, m_cDoHook);
	DDX_Text(pDX, IDC_DIALCODE, m_strDialCode);
	DDX_Text(pDX, IDC_SPKVOLUME, m_nSpkVolume);
	DDX_Text(pDX, IDC_MICVOLUME, m_nMicVolume);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CConferenceDemoDlg, CDialog)
	//{{AFX_MSG_MAP(CConferenceDemoDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_WM_DESTROY()
	ON_BN_CLICKED(IDC_CREATECONF, OnCreateconf)
	ON_BN_CLICKED(IDC_DIAL, OnDial)
	ON_BN_CLICKED(IDC_DOHOOK, OnDohook)
	ON_NOTIFY(HDN_ITEMCHANGED, IDC_CONFLIST, OnItemchangedConflist)
	ON_BN_CLICKED(IDC_DOPHONE, OnDophone)
	ON_BN_CLICKED(IDC_DELCONF, OnDelconf)
	ON_BN_CLICKED(IDC_STARTREC, OnStartrec)
	ON_BN_CLICKED(IDC_STOPREC, OnStoprec)
	ON_BN_CLICKED(IDC_DISABLEMIC, OnDisablemic)
	ON_BN_CLICKED(IDC_DISABLESPK, OnDisablespk)
	ON_BN_CLICKED(IDC_PAUSE, OnPause)
	ON_BN_CLICKED(IDC_RESUME, OnResume)
	ON_BN_CLICKED(IDC_SETVOLUME, OnSetvolume)
	ON_BN_CLICKED(IDC_ADBUSY, OnAdbusy)
	ON_LBN_SELCHANGE(IDC_CHANNELLIST, OnSelchangeChannellist)
	ON_CBN_SELCHANGE(IDC_COMBOCHANNEL, OnSelchangeCombochannel)
	ON_NOTIFY(LVN_ITEMCHANGED, IDC_CONFLIST, OnItemchangedConflist)
	ON_CBN_SELCHANGE(IDC_SELECTLINE, OnSelchangeSelectline)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CConferenceDemoDlg message handlers

BOOL CConferenceDemoDlg::OnInitDialog()
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
	
	if(!OpenDev())
	{
		CDialog::OnOK();
		return FALSE;
	}
	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CConferenceDemoDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CConferenceDemoDlg::OnPaint() 
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
HCURSOR CConferenceDemoDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

long	CConferenceDemoDlg::OpenDev()
{
	//������BRIDGE�豸
	if(QNV_OpenDevice(ODT_LBRIDGE,0,0) <= 0 || QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS) <= 0)
	{
		AppendStatus("���豸ʧ��");
		AfxMessageBox("���豸ʧ��");
		return 0;
	}
	CString str;
	//������ͨ��
	if(QNV_OpenDevice(ODT_SOUND,0,0) <= 0)//������������ͨ��
	{
		AppendStatus("������ͨ��ʧ��");	
	}
	for(BRIINT16 i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{//��windowproc������յ�����Ϣ
		QNV_Event(i,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);
		str.Format("ͨ��%d",i+1);
		m_cComboChannel.AddString(str);
	}
	AppendStatus("���豸�ɹ�");	
	m_cComboChannel.SetCurSel(0);
	OnSelchangeCombochannel();

	m_cConfList.SetExtendedStyle(LVS_EX_FULLROWSELECT|LVS_EX_GRIDLINES|m_cConfList.GetExtendedStyle());
	m_cConfList.InsertColumn(0,"������",LVCFMT_LEFT,100);
	m_cConfList.InsertColumn(1,"������",LVCFMT_LEFT,64);
	m_cConfList.InsertColumn(2,"����ͨ����Ա",LVCFMT_LEFT,200);
	return 1;
}

//��ʾ��ʾ״̬�ı�
void CConferenceDemoDlg::AppendStatus(CString strStatus)
{
	CString str,strTime;
	CTime ct=CTime::GetCurrentTime();
	strTime.Format("[%02d:%02d:%02d] %s",ct.GetHour(),ct.GetMinute(),ct.GetSecond(),strStatus);	
	CString strSrc;
	GetDlgItem(IDC_CONFSTATUS)->GetWindowText(strSrc);
	if(strSrc.GetLength() > 16000)
		strSrc .Empty();
	str=strTime+"\r\n"+strSrc;
	GetDlgItem(IDC_CONFSTATUS)->SetWindowText(str);
}

long	CConferenceDemoDlg::CloseDev()
{
	QNV_CloseDevice(ODT_ALL,0);//�ر������豸
	AppendStatus("�ر������豸");
	return 0;
}

void CConferenceDemoDlg::OnDestroy() 
{
	CloseDev();
	CDialog::OnDestroy();	
}

void CConferenceDemoDlg::OnCreateconf() 
{
	CString str;
	CCreateConf create;
	if(create.DoModal() == IDOK)
	{
		long L=m_cConfList.InsertItem(m_cConfList.GetItemCount(),create.m_strConfName,0);
		str.Format("%d",create.m_lConfID);
		m_cConfList.SetItemText(L,1,str);
		CString strtmp;
		str.Empty();
		for(int i=0;i<create.m_ChannelArray.GetSize();i++)
		{
			strtmp.Format("%d,",create.m_ChannelArray.GetAt(i));
			str+=strtmp;
		}
		m_cConfList.SetItemText(L,2,str);
		if(m_cConfList.GetItemCount() > 0) m_cConfList.SetItemState(0,LVIS_SELECTED, LVIS_SELECTED);
	}
}

void CConferenceDemoDlg::OnDial() 
{
	UpdateData(TRUE);
	if(m_strDialCode.IsEmpty())
	{
		AfxMessageBox("���������");
	}else
	{
		QNV_General(m_cComboChannel.GetCurSel(),QNV_GENERAL_STARTDIAL,0,(char*)(LPCTSTR)m_strDialCode);		
	}	
}

void CConferenceDemoDlg::OnDohook() 
{
	QNV_SetDevCtrl(m_cComboChannel.GetCurSel(),QNV_CTRL_DOHOOK,m_cDoHook.GetCheck());	
}

int CConferenceDemoDlg::_StringSplit(const CString &str, CStringArray &arr, TCHAR chDelimitior)
{
	int nStart = 0, nEnd = 0;
	if(str.IsEmpty()) 
		return 0;
	while (nEnd < str.GetLength())
	{
		nEnd = str.Find(chDelimitior, nStart);
		if( nEnd == -1 )
		{
			// reached the end of string
			nEnd = str.GetLength();
		}
		CString s = str.Mid(nStart, nEnd - nStart);
		if (!s.IsEmpty())
			arr.Add(s);

		nStart = nEnd + 1;
	}
	return arr.GetSize();
}

long CConferenceDemoDlg::ShowConfChannelList(long lConfID,CString strChannelList)
{
	m_cChannelList.ResetContent();
	//ʹ�ö��ŷָ�ͨ���б�
	m_lCurSelConfID = lConfID;
	if(m_lCurSelConfID == 0)
	{		
		return 0;
	}else
	{
		CStringArray	avr;
		_StringSplit(strChannelList,avr,',');
		for(int i=0;i<avr.GetSize();i++)
		{
			m_cChannelList.AddString(avr.GetAt(i));
		}
		if(m_cChannelList.GetCount() > 0) m_cChannelList.SetCurSel(0);
		return 1;
	}
}

void CConferenceDemoDlg::OnItemchangedConflist(NMHDR* pNMHDR, LRESULT* pResult) 
{
	HD_NOTIFY *phdn = (HD_NOTIFY *) pNMHDR;
	NM_LISTVIEW* pNMListView = (NM_LISTVIEW*)pNMHDR;
	if(pNMListView->uNewState&LVIS_SELECTED && pNMListView->iItem >= 0)
	{
		TRACE("ѡ���µĽڵ� item=%d \r\n",pNMListView->iItem);
		ShowConfChannelList(atol((char*)(LPCTSTR)m_cConfList.GetItemText(pNMListView->iItem,1)),m_cConfList.GetItemText(pNMListView->iItem,2));
	}
	*pResult = 0;
}

LRESULT CConferenceDemoDlg::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	if(message == BRI_EVENT_MESSAGE)
	{
		PBRI_EVENT pEvent=(PBRI_EVENT)lParam;
		CString str,strValue;
		strValue.Format("Handle=%d Result=%d Data=%s",pEvent->lEventHandle,pEvent->lResult,pEvent->szData);
		switch(pEvent->lEventType)
		{
		case BriEvent_PhoneHook:str.Format("ͨ��%d: �绰��ժ�� %s",pEvent->uChannelID+1,strValue);break;
		case BriEvent_PhoneHang:str.Format("ͨ��%d: �绰���һ� %s",pEvent->uChannelID+1,strValue);break;
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
		case BriEvent_RefuseEnd:str.Format("ͨ��%d: �ܽ�������� %s",pEvent->uChannelID+1,strValue);break;	
		case BriEvent_PSTNFree:str.Format("ͨ��%d: PSTN��·�ѿ��� %s",pEvent->uChannelID+1,strValue);break;	
		case BriEvent_EnableHook:
			{
				if(pEvent->uChannelID == m_cComboChannel.GetCurSel())
				{
					((CButton*)GetDlgItem(IDC_DOHOOK))->SetCheck(pEvent->lResult);
					str.Format("ͨ��%d: HOOK������ lResult=%d",pEvent->uChannelID+1,pEvent->lResult);
				}
				break;
			}		
		default:break;
		}
		if(!str.IsEmpty())
		{
			AppendStatus(str);
		}
	}
	return CDialog::WindowProc(message, wParam, lParam);
}

void CConferenceDemoDlg::OnDophone() 
{
	QNV_SetDevCtrl(m_cComboChannel.GetCurSel(),QNV_CTRL_DOPHONE,!m_cDoPhone.GetCheck());
}


long	CConferenceDemoDlg::GetSelectConf()
{
	POSITION pos=m_cConfList.GetFirstSelectedItemPosition();
	if(pos)
	{
		return m_cConfList.GetNextSelectedItem(pos);
	}else
		return -1;
}

void CConferenceDemoDlg::OnDelconf() 
{
	int iCurID=GetSelectConf();
	if(iCurID < 0)
	{
		AfxMessageBox("��ѡ�����");
	}else
	{
		long lConfID=atol((char*)(LPCTSTR)m_cConfList.GetItemText(iCurID,1));
		QNV_Conference(0,lConfID,QNV_CONFERENCE_DELETECONF,0,NULL);	//ɾ������
		m_cConfList.DeleteItem(iCurID);//ɾ���б�
		ShowConfChannelList(0,"");
	}
}

void CConferenceDemoDlg::OnStartrec() 
{
	CString strFilePath=((CConferenceDemoApp*)AfxGetApp())->SelectFilePath(0);
	if(!strFilePath.IsEmpty())
	{
		long lFormatID=BRI_WAV_FORMAT_DEFAULT;
		if(QNV_Conference(0,m_lCurSelConfID,QNV_CONFERENCE_RECORD_START,lFormatID,(char*)(LPCTSTR)strFilePath) <= 0)
		{
			CString str;
			str.Format("¼��ʧ��");
			AfxMessageBox(str);
		}
	}			
}

BRIINT16	CConferenceDemoDlg::GetSelectedChannelID()
{
	int iCurSel=m_cChannelList.GetCurSel();
	if(iCurSel >= 0)
	{
		CString str;
		m_cChannelList.GetText(iCurSel,str);
		return (BRIINT16)atol((char*)(LPCTSTR)str);
	}else
		return 0;
}

void CConferenceDemoDlg::OnStoprec() 
{
	QNV_Conference(0,m_lCurSelConfID,QNV_CONFERENCE_RECORD_STOP,0,NULL);	
}

void CConferenceDemoDlg::OnDisablemic() 
{
	if(GetSelectedChannelID() < 0)
	{
		AfxMessageBox("��ѡ������ѡ��ͨ��");
		return ;
	}
	QNV_Conference(GetSelectedChannelID(),m_lCurSelConfID,QNV_CONFERENCE_ENABLEMIC,!m_cDisableMic.GetCheck(),NULL);	
}

void CConferenceDemoDlg::OnDisablespk() 
{
	if(GetSelectedChannelID() < 0)
	{
		AfxMessageBox("��ѡ������ѡ��ͨ��");
		return ;
	}
	QNV_Conference(GetSelectedChannelID(),m_lCurSelConfID,QNV_CONFERENCE_ENABLESPK,!m_cDisableSpk.GetCheck(),NULL);	
}

void CConferenceDemoDlg::OnPause() 
{
	if(GetSelectedChannelID() < 0)
	{
		AfxMessageBox("��ѡ������ѡ��ͨ��");
		return ;
	}
	QNV_Conference(GetSelectedChannelID(),m_lCurSelConfID,QNV_CONFERENCE_PAUSE,0,NULL);	
}

void CConferenceDemoDlg::OnResume() 
{
	if(GetSelectedChannelID() < 0)
	{
		AfxMessageBox("��ѡ������ѡ��ͨ��");
		return ;
	}
	QNV_Conference(GetSelectedChannelID(),m_lCurSelConfID,QNV_CONFERENCE_RESUME,0,NULL);		
}

void CConferenceDemoDlg::OnSetvolume() 
{
	if(GetSelectedChannelID() < 0)
	{
		AfxMessageBox("��ѡ������ѡ��ͨ��");
		return ;
	}
	UpdateData(TRUE);
	QNV_Conference(GetSelectedChannelID(),m_lCurSelConfID,QNV_CONFERENCE_SETSPKVOLUME,m_nSpkVolume,NULL);
	QNV_Conference(GetSelectedChannelID(),m_lCurSelConfID,QNV_CONFERENCE_SETMICVOLUME,m_nMicVolume,NULL);
}

void CConferenceDemoDlg::OnAdbusy() 
{//������ͨ��������������������ժ������ʱ��⵽æ��
 //Ĭ�ϼ��ֻ�ʺ�ֱ��450HZ��Ƶ�ʵ�æ��,������߲��ԵĽ��������Ǹ�Ƶ�ʾ���Ч
	QNV_SetDevCtrl(GetSelectedChannelID(),QNV_CTRL_ADBUSY,m_cAdBusy.GetCheck());	
}

void CConferenceDemoDlg::OnSelchangeChannellist() 
{
	m_nSpkVolume=QNV_Conference(GetSelectedChannelID(),m_lCurSelConfID,QNV_CONFERENCE_GETSPKVOLUME,0,NULL);
	m_nMicVolume=QNV_Conference(GetSelectedChannelID(),m_lCurSelConfID,QNV_CONFERENCE_GETMICVOLUME,0,NULL);
	UpdateData(FALSE);
	m_cDisableMic.SetCheck(QNV_Conference(GetSelectedChannelID(),m_lCurSelConfID,QNV_CONFERENCE_ISENABLEMIC,0,NULL) == 0);
	m_cDisableSpk.SetCheck(QNV_Conference(GetSelectedChannelID(),m_lCurSelConfID,QNV_CONFERENCE_ISENABLESPK,0,NULL) == 0);
}

void CConferenceDemoDlg::OnSelchangeCombochannel() 
{
	m_cDoHook.SetCheck(QNV_GetDevCtrl(m_cComboChannel.GetCurSel(),QNV_CTRL_DOHOOK));
	m_cDoPhone.SetCheck(!QNV_GetDevCtrl(m_cComboChannel.GetCurSel(),QNV_CTRL_DOPHONE));
	m_cAdBusy.SetCheck(QNV_GetDevCtrl(m_cComboChannel.GetCurSel(),QNV_CTRL_ADBUSY));
	m_cSelectLine.SetCurSel(QNV_GetDevCtrl(m_cComboChannel.GetCurSel(),QNV_CTRL_SELECTLINEIN));
}

void CConferenceDemoDlg::OnSelchangeSelectline() 
{
	QNV_SetDevCtrl(m_cComboChannel.GetCurSel(),QNV_CTRL_SELECTLINEIN,m_cSelectLine.GetCurSel());	
}
