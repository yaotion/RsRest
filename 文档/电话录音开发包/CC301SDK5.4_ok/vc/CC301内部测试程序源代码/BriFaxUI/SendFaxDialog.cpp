// SendFaxDialog.cpp : implementation file
//

#include "stdafx.h"
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
	//}}AFX_DATA_INIT
	m_lImageSize= 0;
	m_LogData.m_lSendRecvType = FAX_SEND;
}


void CSendFaxDialog::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CSendFaxDialog)
	DDX_Control(pDX, IDC_SENDPROGRESS, m_cSendProgress);
	DDX_Control(pDX, IDC_STELAPSE, m_cStElapse);
	DDX_Control(pDX, IDC_DOPLAY, m_cDoPlay);
	DDX_Control(pDX, IDC_SENDFILEPATH, m_cSendFilePath);
	DDX_Control(pDX, IDC_SENDSTATE, m_cSendState);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CSendFaxDialog, CDialog)
	//{{AFX_MSG_MAP(CSendFaxDialog)
	ON_BN_CLICKED(IDC_VIEWSENDFILE, OnViewsendfile)
	ON_WM_DESTROY()
	ON_BN_CLICKED(IDC_DOPLAY, OnDoplay)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CSendFaxDialog message handlers

BOOL CSendFaxDialog::OnInitDialog() 
{
	CDialog::OnInitDialog();
	m_cSendProgress.SetRange(0,100);
	QNV_Fax(0,QNV_FAX_LOAD,0,NULL);		
	QNV_Event(m_LogData.m_lChannelID,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);
	m_cDoPlay.SetCheck(QNV_GetDevCtrl(m_LogData.m_lChannelID,QNV_CTRL_DOPLAY));
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}


long	CSendFaxDialog::GetFileType(char *pFilePath)
{
	if(!pFilePath || strlen(pFilePath) < 5) return FT_NULL;
	else
	{
		char *pDot=strrchr(pFilePath,'.');
		if(!pDot) return FFT_UNKNOW;
		else
		{
			if(_tcsicmp(pDot,".doc") == 0 || _tcsicmp(pDot,".dot") == 0 ) return FFT_DOC;
			else if(_tcsicmp(pDot,".htm") == 0 || _tcsicmp(pDot,".mht") == 0 ||_tcsicmp(pDot,".html") == 0 ) return FFT_WEB;
			else
				return FFT_PIC;
		}
	}
}


void CSendFaxDialog::OnViewsendfile() 
{
	if(GetFileType((char*)(LPCTSTR)m_LogData.m_strFaxPath) != FFT_PIC)
	{
		::ShellExecute(NULL,"open",m_LogData.m_strFaxPath,"",NULL,SW_SHOWNORMAL);	
	}else
	{
		::ShellExecute(NULL,"open","rundll32.exe","shimgvw.dll,ImageView_Fullscreen "+m_LogData.m_strFaxPath,NULL,SW_SHOWNORMAL); 
	}
}

long	CSendFaxDialog::SaveSendFaxFile(CString strFileName)
{	
	char szFaxFile[_MAX_PATH]={0};
	CTime ct=CTime::GetCurrentTime();
	BS_GetModulePath(szFaxFile,_MAX_PATH);
	int iPos=strFileName.ReverseFind('.');
	if(iPos > 0) strFileName=strFileName.Left(iPos);
	CString strSendFile;
	strSendFile.Format("%s%s\\%04d%02d\\%s_%02d%02d%02d%02d_%d.tif",szFaxFile,FAX_SEND_FILE,ct.GetYear(),ct.GetMonth(),strFileName,ct.GetDay(),ct.GetHour(),ct.GetMinute(),ct.GetSecond(),m_LogData.m_lChannelID+1);
	if( QNV_Fax(m_LogData.m_lChannelID,QNV_FAX_SAVESENDFILE,0,(char*)(LPCTSTR)strSendFile) > 0)
	{
		m_LogData.m_strFaxPath=strSendFile;
		return 1;
	}else
	{
		return 0;
	}
}

long	CSendFaxDialog::StartSend(char *szFilePath,long lType)
{
	if(m_LogData.m_lChannelID >= 0 && QNV_Fax(m_LogData.m_lChannelID,QNV_FAX_TYPE,0,NULL) != FAX_TYPE_NULL) return 0;
	m_LogData.m_strFaxPath=szFilePath;
	m_cSendFilePath.SetWindowText(m_LogData.m_strFaxPath);
	m_LogData.m_lBeginTime = time(NULL);
	if(QNV_Fax(m_LogData.m_lChannelID,QNV_FAX_STARTSEND,0,szFilePath) > 0)
	{
		SaveSendFaxFile(BS_GetFileName(szFilePath));//复制转换黑白后保存到本地发送目录,以便以后查询
		if((QNV_DevInfo(m_LogData.m_lChannelID,QNV_DEVINFO_GETMODULE)&DEVMODULE_SWITCH)
			|| !QNV_GetDevCtrl(m_LogData.m_lChannelID,QNV_CTRL_PHONE))
		{
			StareRecFile();
			m_cSendState.SetWindowText("正在发送传真,建议暂停操作电脑!");
			StartElapseTimer(m_hWnd);
		}else
		{
			//如果没有继电器的,软摘机,然后提示用户挂机,检测到挂机后启动传真
			//这样主窗口检测到挂机后不能让它软挂机成功
			//立即暂停,等待挂机后恢复开始
			QNV_Fax(m_LogData.m_lChannelID,QNV_FAX_PAUSE,0,NULL);
			m_cSendState.SetWindowText("请挂机...");
		}
		return 1;
	}else
	{
		m_cSendState.SetWindowText("启动发送传真失败...");
		return 0;
	}
}

long	CSendFaxDialog::StopSend()
{
	QNV_Fax(m_LogData.m_lChannelID,QNV_FAX_STOPSEND,0,NULL);
	CBriFaxBase::StopFax();
	return 1;
}

LRESULT CSendFaxDialog::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	if(message == BRI_EVENT_MESSAGE)
	{
		PBRI_EVENT pEvent=(PBRI_EVENT)lParam;
		_ASSERT(pEvent->uChannelID == m_LogData.m_lChannelID);
		switch(pEvent->lEventType)
		{
		case BriEvent_FaxSendFinished:
			{
				StopRecFile();
				m_cSendState.SetWindowText("发送传真完成");
				FinishedFax(m_hWnd);
				QNV_Fax(m_LogData.m_lChannelID,QNV_FAX_STOPSEND,0,NULL);
			}break;
		case BriEvent_FaxSendFailed:case BriEvent_Busy:case BriEvent_RemoteHang:
			{
				m_LogData.m_lErrorID = pEvent->lEventType;
				StopRecFile();
				CString str;
				str.Format("发送传真失败 eid=%d result=%d",pEvent->lEventType,pEvent->lResult);
				m_cSendState.SetWindowText(str);
				FailedFax(m_hWnd);
				QNV_Fax(m_LogData.m_lChannelID,QNV_FAX_STOPSEND,0,NULL);
			}break;
		case BriEvent_PhoneHang:
			{
				if(QNV_Fax(m_LogData.m_lChannelID,QNV_FAX_ISPAUSE,0,NULL))
				{
					StareRecFile();
					QNV_Fax(m_LogData.m_lChannelID,QNV_FAX_RESUME,0,NULL);
					m_cSendState.SetWindowText("正在发送传真,建议暂停操作电脑!");
					StartElapseTimer(m_hWnd);
					EnableDoPlay(m_cDoPlay.GetCheck());	
				}
			}break;
		case BriEvent_EnablePlay:
			{
				//m_cDoPlay.SetCheck(pEvent->lResult);
			}break;
		}
	}else if(message == WM_TIMER && wParam == m_nElapseTimer)
	{
		m_lElapse++;
		CString str;
		str.Format("%02d:%02d:%02d",m_lElapse/3600,m_lElapse%3600/60,m_lElapse%60);		
		m_cStElapse.SetWindowText(str);
		if(m_lImageSize <=0 ) m_lImageSize = QNV_Fax(m_LogData.m_lChannelID,QNV_FAX_IMAGESIZE,0,0);
		long lTransmit=QNV_Fax(m_LogData.m_lChannelID,QNV_FAX_TRANSMITSIZE,0,0);
		if(m_lImageSize > 0 && lTransmit > 0)
		{			
			long lPos=lTransmit*100/m_lImageSize;
			TRACE("m_lImageSize=%d  lTransmit=%d  lPos=%d\r\n",m_lImageSize,lTransmit,lPos);
			if(lPos >= 0 && lPos <= 100)
			{
				m_cSendProgress.SetPos(lPos);
			}
		}		
	}
	return CDialog::WindowProc(message, wParam, lParam);
}

void CSendFaxDialog::OnCancel() 
{	
	EnableDoPlay(FALSE);
	QNV_Event(m_LogData.m_lChannelID,QNV_EVENT_UNREGWND,(DWORD)m_hWnd,NULL,NULL,0);
	::PostMessage(m_hCBWnd,m_dwMsgID,m_LogData.m_lChannelID,(LPARAM)this);
	//CDialog::OnCancel();
}

void CSendFaxDialog::OnDestroy() 
{
	QNV_Event(m_LogData.m_lChannelID,QNV_EVENT_UNREGWND,(DWORD)m_hWnd,NULL,NULL,0);
	EnableDoPlay(FALSE);//关闭喇叭
	CDialog::OnDestroy();	
}

void CSendFaxDialog::OnDoplay() 
{
	EnableDoPlay(m_cDoPlay.GetCheck());
}
