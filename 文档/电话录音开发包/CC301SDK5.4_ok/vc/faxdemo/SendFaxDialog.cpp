// SendFaxDialog.cpp : implementation file
//

#include "stdafx.h"
#include "FaxDemo.h"
#include "SendFaxDialog.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CSendFaxDialog dialog


CSendFaxDialog::CSendFaxDialog(CWnd* pParent /*=NULL*/)
	: CDialog(CSendFaxDialog::IDD, pParent)
{
	//{{AFX_DATA_INIT(CSendFaxDialog)
	m_strSendPath = _T("");
	//}}AFX_DATA_INIT
	m_nChannelID=0;
}


void CSendFaxDialog::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CSendFaxDialog)
	DDX_Control(pDX, IDC_SENDPATH, m_cSendPath);
	DDX_Control(pDX, IDC_STSTATUS, m_cSendState);
	DDX_Text(pDX, IDC_SENDPATH, m_strSendPath);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CSendFaxDialog, CDialog)
	//{{AFX_MSG_MAP(CSendFaxDialog)
	ON_BN_CLICKED(IDC_VIEWSEND, OnViewsend)
	ON_BN_CLICKED(IDC_OPENDOPLAY, OnOpendoplay)
	ON_BN_CLICKED(IDC_BROWSER, OnBrowser)
	ON_BN_CLICKED(IDC_STARTSEND, OnStartsend)
	ON_BN_CLICKED(IDC_STOPSEND, OnStopsend)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CSendFaxDialog message handlers

BOOL CSendFaxDialog::OnInitDialog() 
{
	CDialog::OnInitDialog();

	QNV_Fax(0,QNV_FAX_LOAD,0,NULL);	
	QNV_Event(m_nChannelID,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);

	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CSendFaxDialog::OnViewsend() 
{
	UpdateData(TRUE);
	char *pExt=NULL;
	char *pFilePath=(char*)(LPCTSTR)m_strSendPath;
	if(strlen(pFilePath) > 4) 
		pExt = pFilePath+strlen(pFilePath) - 4;
	if(pExt &&_tcsicmp(pExt,".doc") == 0 )//
	{
		::ShellExecute(NULL,"open",m_strSendPath,"",NULL,SW_SHOWNORMAL);	
	}else
	{
		::ShellExecute(NULL,"open","rundll32.exe","shimgvw.dll,ImageView_Fullscreen "+m_strSendPath,NULL,SW_SHOWNORMAL); 
	}		
}

void CSendFaxDialog::OnOpendoplay() 
{
    QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_DOPLAY,((CButton*)GetDlgItem(IDC_OPENDOPLAY))->GetCheck());
    QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_PLAYMUX,DOPLAY_CHANNEL0_ADC);//选择听线路声音		
}


CString CSendFaxDialog::GetSelectedFilePath2(CString szFilter,CString szExtName,CString szDefaultPath,CString strDefaultFileName,HWND hOwerWnd,BOOL bType)
{
	char szFile[512];       // buffer for filename
	OPENFILENAME ofn;
	ZeroMemory(szFile,sizeof(szFile));
	ZeroMemory(&ofn, sizeof(OPENFILENAME));
	ofn.lStructSize = sizeof(OPENFILENAME);
	if(strDefaultFileName.GetLength() < 512)
	{
		strcpy(szFile,(LPTSTR)(LPCTSTR)strDefaultFileName);
	}
	ofn.hwndOwner = hOwerWnd;
	ofn.lpstrFile = szFile;
	ofn.nMaxFile = sizeof(szFile);
	szFilter.Replace('|','\0');
	ofn.lpstrFilter=(LPCTSTR)szFilter;
	ofn.lpstrInitialDir=(LPCTSTR)szDefaultPath;
	ofn.nFilterIndex = 1;
	ofn.lpstrFileTitle = NULL;
	ofn.nMaxFileTitle = 0;
	ofn.Flags = OFN_PATHMUSTEXIST | OFN_FILEMUSTEXIST|OFN_OVERWRITEPROMPT;
	if(bType)
	{
		if(::GetOpenFileName(&ofn))
		{
			CString strPath = szFile;			
			return strPath;
		}else
			return "";
	}else
	{
		if(::GetSaveFileName(&ofn))
		{
			CString strPath = szFile;			
			return strPath;
		}else
			return "";
	}
}

void CSendFaxDialog::OnBrowser() 
{
	CString strPath=GetSelectedFilePath2("Image Files(*.bmp,*.jpg,*.jpeg,*.gif,*.png,*.pcx,*.tif,*.tiff)|*.bmp;*.jpg;*.jpeg;*.gif;*.png;*.pcx;*.tif;*.tiff;|Word Files(*.doc)|*.doc;||","","","",m_hWnd,TRUE);
	if(!strPath.IsEmpty())
		m_cSendPath.SetWindowText(strPath);
}

void CSendFaxDialog::OnStartsend() 
{
	UpdateData(TRUE);
	if(m_strSendPath.IsEmpty())
	{
		AfxMessageBox("发送文件不能为空");
		return;
	}
	if(m_nChannelID >= 0 && QNV_Fax(m_nChannelID,QNV_FAX_TYPE,0,NULL) != FAX_TYPE_NULL)
	{
		AfxMessageBox("正在处理传真");
		return ;
	}
	if(QNV_Fax(m_nChannelID,QNV_FAX_STARTSEND,0,(char*)(LPCTSTR)m_strSendPath) > 0)
	{
		if((QNV_DevInfo(m_nChannelID,QNV_DEVINFO_GETMODULE)&DEVMODULE_SWITCH)
			|| !QNV_GetDevCtrl(m_nChannelID,QNV_CTRL_PHONE))
		{
			m_cSendState.SetWindowText("正在发送传真...");
		}else
		{
			//如果没有继电器的,软摘机,然后提示用户挂机,检测到挂机后启动传真
			//这样主窗口检测到挂机后不能让它软挂机成功
			//立即暂停,等待挂机后恢复开始
			QNV_Fax(m_nChannelID,QNV_FAX_PAUSE,0,NULL);
			m_cSendState.SetWindowText("请挂机...");
		}
		return ;
	}else
	{
		m_cSendState.SetWindowText("启动发送传真失败...");
		return ;
	}	
}

void CSendFaxDialog::OnStopsend() 
{
	QNV_Fax(m_nChannelID,QNV_FAX_STOPSEND,0,NULL);
}

void CSendFaxDialog::OnCancel() 
{
	if(QNV_Fax(m_nChannelID,QNV_FAX_TYPE,0,0) == FAX_TYPE_RECV)
	{
		if(MessageBox("正在接收传真，确实要终止吗？","警告",MB_YESNO|MB_ICONWARNING) == IDNO)
			return;
	}	
	OnStopsend();		
	CDialog::OnCancel();
}

LRESULT CSendFaxDialog::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	if(message == BRI_EVENT_MESSAGE)
	{
		PBRI_EVENT pEvent=(PBRI_EVENT)lParam;
		_ASSERT(pEvent->uChannelID == m_nChannelID);
		switch(pEvent->lEventType)
		{
		case BriEvent_FaxSendFinished:
			{
				m_cSendState.SetWindowText("发送传真完成");
				QNV_Fax(m_nChannelID,QNV_FAX_STOPSEND,0,NULL);
			}break;
		case BriEvent_FaxSendFailed:case BriEvent_Busy:case BriEvent_RemoteHang:
			{
				CString str;
				str.Format("发送传真失败 eid=%d",pEvent->lEventType);
				m_cSendState.SetWindowText(str);
				QNV_Fax(m_nChannelID,QNV_FAX_STOPSEND,0,NULL);
			}break;
		case BriEvent_PhoneHang:
			{
				if(QNV_Fax(m_nChannelID,QNV_FAX_ISPAUSE,0,NULL))
				{
					QNV_Fax(m_nChannelID,QNV_FAX_RESUME,0,NULL);
					m_cSendState.SetWindowText("正在发送传真...");
				}
			}break;
		}
	}	
	return CDialog::WindowProc(message, wParam, lParam);
}
