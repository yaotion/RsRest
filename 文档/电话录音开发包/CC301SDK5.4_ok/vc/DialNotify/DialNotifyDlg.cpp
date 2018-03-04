// DialNotifyDlg.cpp : implementation file
//

#include "stdafx.h"
#include "DialNotify.h"
#include "DialNotifyDlg.h"

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
// CDialNotifyDlg dialog

CDialNotifyDlg::CDialNotifyDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CDialNotifyDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CDialNotifyDlg)
	m_strFilePath = _T("");
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CDialNotifyDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CDialNotifyDlg)
	DDX_Control(pDX, IDC_FILEPATH, m_cFilePath);
	DDX_Control(pDX, IDC_FINISHLIST, m_cFinishList);
	DDX_Control(pDX, IDC_DIALLOG, m_cDialLog);
	DDX_Control(pDX, IDC_DIALLIST, m_cDialList);
	DDX_Text(pDX, IDC_FILEPATH, m_strFilePath);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CDialNotifyDlg, CDialog)
	//{{AFX_MSG_MAP(CDialNotifyDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_STARTDIAL, OnStartdial)
	ON_BN_CLICKED(IDC_STOPDIAL, OnStopdial)
	ON_WM_DESTROY()
	ON_BN_CLICKED(IDC_SELECTFILE, OnSelectfile)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDialNotifyDlg message handlers

BOOL CDialNotifyDlg::OnInitDialog()
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

void CDialNotifyDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CDialNotifyDlg::OnPaint() 
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
HCURSOR CDialNotifyDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

CString CDialNotifyDlg::SelectFilePath()
{
	CString strDestPath;
	char szFile[260];       // buffer for filename
	OPENFILENAME ofn;
	memset(szFile,0,sizeof(szFile));
	ZeroMemory(&ofn, sizeof(OPENFILENAME));
	ofn.lStructSize = sizeof(OPENFILENAME);
	ofn.hwndOwner = AfxGetMainWnd()->GetSafeHwnd();
	ofn.lpstrFile = szFile;
	ofn.nMaxFile = sizeof(szFile);
	
	ofn.nFilterIndex = 1;
	ofn.lpstrFileTitle = NULL;
	ofn.nMaxFileTitle = 0;
	
	ofn.lpstrInitialDir = NULL;
	ofn.Flags = OFN_PATHMUSTEXIST | OFN_FILEMUSTEXIST|OFN_OVERWRITEPROMPT;
	
	ofn.lpstrFilter = "text file\0*.txt;\0All file\0*.*\0";
	
	if(::GetOpenFileName(&ofn))
	{
		strDestPath = szFile;			
	}
	return strDestPath;
}

void CDialNotifyDlg::OnStartdial() 
{
	for(int i=0;i<m_ChannelCtrlArray.GetSize();i++)
	{
		m_ChannelCtrlArray[i]->StartDial();
	}		
}

void CDialNotifyDlg::OnStopdial() 
{
	for(int i=0;i<m_ChannelCtrlArray.GetSize();i++)
	{
		m_ChannelCtrlArray[i]->StopDial();
	}	
}

long	CDialNotifyDlg::InitDevice()
{
	long lRet=QNV_OpenDevice(ODT_LBRIDGE,0,0);
	if(lRet == ERROR_INVALIDDLL) AfxMessageBox("DLL不合法");
	else if(lRet <= 0 || QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS) <= 0)
	{
		AppendStatus(0,"初始化失败");
		AfxMessageBox("打开设备失败,请检查设备是否已经插入并安装了驱动,并且没有其它程序已经打开设备");
	}else
	{		
		InitDevInfo();
	}
	return 1;
}


CString CDialNotifyDlg::GetModule(BRIINT16 chID)
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

void	CDialNotifyDlg::InitDevInfo()
{
	CString str,strInfo;
	str.Format("打开设备成功 通道数=%d 设备数=%d",QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS),QNV_DevInfo(0,QNV_DEVINFO_GETCHIPS));
	AppendStatus(0,str);
	for(BRIINT16 i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{
		str.Format("%d",i+1);
		CDialChannel *pChannel=new CDialChannel();
		m_ChannelCtrlArray.Add(pChannel);
		pChannel->SetChannelCtrlID(i);
		pChannel->SetCBWndAndID(m_hWnd,DC_CALLBACK_MESSAGE);

		str.Format("设备ID=%d 序列号=%d 通道类型=0x%x 芯片类型=%d 模块=%s",
			QNV_DevInfo(i,QNV_DEVINFO_GETDEVID),
			QNV_DevInfo(i,QNV_DEVINFO_GETSERIAL),						
			QNV_DevInfo(i,QNV_DEVINFO_GETTYPE),
			QNV_DevInfo(i,QNV_DEVINFO_GETCHIPTYPE),
			GetModule(i));
		AppendStatus(i+1,str);
#ifdef _DEBUG
		//如果调试状态就关闭看门狗
		QNV_SetDevCtrl(i,QNV_CTRL_WATCHDOG,0);
#endif
	}	
	QNV_Tool(QNV_TOOL_APMQUERYSUSPEND,FALSE,NULL,NULL,NULL,0);//禁止待机
}

void CDialNotifyDlg::AppendStatus(BRIINT16 uChannel,CString strStatus)
{
	CString str,strTime;
	CTime ct=CTime::GetCurrentTime();
	if(uChannel != 0)
	{
		strTime.Format("[%02d:%02d:%02d] 通道%d: %s",ct.GetHour(),ct.GetMinute(),ct.GetSecond(),uChannel,strStatus);	
	}else
	{
		strTime.Format("[%02d:%02d:%02d] %s",ct.GetHour(),ct.GetMinute(),ct.GetSecond(),strStatus);	
	}
	CString strSrc;
	GetDlgItem(IDC_DIALLOG)->GetWindowText(strSrc);
	if(strSrc.GetLength() > 64000)
		strSrc .Empty();
	str=strTime+"\r\n"+strSrc;
	GetDlgItem(IDC_DIALLOG)->SetWindowText(str);
}

void	CDialNotifyDlg::FreeSource()
{
	for(int i=0;i<m_ChannelCtrlArray.GetSize();i++)
	{
		m_ChannelCtrlArray[i]->FreeSource();
		delete m_ChannelCtrlArray[i];
	}
	m_ChannelCtrlArray.RemoveAll();
	QNV_CloseDevice(ODT_ALL,0);
}

void CDialNotifyDlg::OnDestroy() 
{
	FreeSource();
	CDialog::OnDestroy();	
}

CString CDialNotifyDlg::GetFirstDialCode()
{
	CString strCode;
	if( m_cDialList.GetCount() > 0)
	{
		m_cDialList.GetText(0,strCode);
		m_cDialList.DeleteString(0);
	}
	return strCode;
}

LRESULT CDialNotifyDlg::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	if(message == DC_CALLBACK_MESSAGE)
	{
		PDC_DATA pdata=(PDC_DATA)lParam;
		switch(wParam)
		{
		case DC_REQUEST_CODE:
			{
				CString strCode=GetFirstDialCode();
				if(strCode.GetLength() > 0 && strCode.GetLength() < 256)
				{
					strcpy(pdata->szData,(char*)(LPCTSTR)strCode);
					pdata->lresult = strlen(pdata->szData);
				}
			}
			break;
		case DC_DIAL_NOTTALK:
			{//一个未接听的号码
				m_cDialList.AddString(pdata->szData);//追加到最后准备下次再拨
				AppendStatus(pdata->uchannelid,(CString)"未通:"+pdata->szData);
			}break;
		case DC_DIAL_FINISH:
			{//已经结束
				m_cFinishList.AddString(pdata->szData);
				AppendStatus(pdata->uchannelid,(CString)"完成:"+pdata->szData);
			}break;
		case DC_DIAL_STATUS:
			{
				AppendStatus(pdata->uchannelid,pdata->szData);
			}break;
		default:break;
		}
	}
	return CDialog::WindowProc(message, wParam, lParam);
}

void CDialNotifyDlg::OnSelectfile() 
{
	CString strFilePath=SelectFilePath();
	if(!strFilePath.IsEmpty())
	{
		m_cFilePath.SetWindowText(strFilePath);
		ParseFile(strFilePath);
	}
}

long	CDialNotifyDlg::AddCodeList(char *pCode)
{
	if(pCode && strlen(pCode) > 0)
	{
		m_cDialList.AddString(pCode);
		return 1;
	}else
	{
		return 0;
	}
}

long	CDialNotifyDlg::ParseFile(CString strFilePath)//解析号码列表
{	
	CFile file;
	if(file.Open(strFilePath,CFile::modeRead,NULL))
	{
		DWORD dwLen=file.GetLength();
		char *pBuf=new char[dwLen+1];
		memset(pBuf,0,dwLen+1);
		file.Read(pBuf,dwLen);
		file.Close();
		m_cDialList.ResetContent();
		long lSeek=0;
		while(lSeek < (long)dwLen)
		{
			char *p=strstr(pBuf+lSeek,"\r\n");
			if(p)
			{
				*p='\0';
				AddCodeList(pBuf+lSeek);				
				lSeek+=strlen(pBuf+lSeek)+2;
			}else
			{
				AddCodeList(pBuf+lSeek);
				break;
			}
		}		
		delete[] pBuf;
		return 1;
	}else
	{
		AfxMessageBox("打开文件失败...");
		return 0;
	}
}
