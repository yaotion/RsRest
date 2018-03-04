// RecvFaxDialog.cpp : implementation file
//

#include "stdafx.h"
#include "RecvFaxDialog.h"
#include "resource.h"
#include "BriFaxUI.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CRecvFaxDialog dialog


CRecvFaxDialog::CRecvFaxDialog(CWnd* pParent /*=NULL*/)
	: CDialog(CRecvFaxDialog::IDD, pParent)
{
	//{{AFX_DATA_INIT(CRecvFaxDialog)
	//}}AFX_DATA_INIT
	m_lType = RECVF_NULL;	
	m_LogData.m_lSendRecvType = FAX_RECV;
}


void CRecvFaxDialog::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CRecvFaxDialog)
	DDX_Control(pDX, IDC_OPENDIR, m_cOpenDir);
	DDX_Control(pDX, IDC_STELAPSE, m_cStElapse);
	DDX_Control(pDX, IDC_DOPLAY, m_cDoPlay);
	DDX_Control(pDX, IDC_FILEPATH, m_cFilePath);
	DDX_Control(pDX, IDC_VIEWRECVFILE, m_cViewRecvFile);
	DDX_Control(pDX, IDC_STSTATE, m_cState);
	DDX_Control(pDX, IDCANCEL, m_Cancel);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CRecvFaxDialog, CDialog)
	//{{AFX_MSG_MAP(CRecvFaxDialog)	
	ON_WM_DESTROY()
	ON_BN_CLICKED(IDC_VIEWRECVFILE, OnViewrecvfile)
	ON_BN_CLICKED(IDC_DOPLAY, OnDoplay)
	ON_BN_CLICKED(IDC_OPENDIR, OnOpendir)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CRecvFaxDialog message handlers

BOOL CRecvFaxDialog::OnInitDialog() 
{
	CDialog::OnInitDialog();
	QNV_Fax(0,QNV_FAX_LOAD,0,NULL);	
	QNV_Event(m_LogData.m_lChannelID,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);
	m_cDoPlay.SetCheck(QNV_GetDevCtrl(m_LogData.m_lChannelID,QNV_CTRL_DOPLAY));
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}


CString CRecvFaxDialog::CreateFaxFile()
{
	CString strFile;
	char szFaxFile[_MAX_PATH]={0};
	CTime ct=CTime::GetCurrentTime();
	BS_GetModulePath(szFaxFile,_MAX_PATH);
	strFile.Format("%s%s\\%04d%02d\\%02d%02d%02d%02d_%d.tif",szFaxFile,FAX_RECV_FILE,ct.GetYear(),ct.GetMonth(),ct.GetDay(),ct.GetHour(),ct.GetMinute(),ct.GetSecond(),m_LogData.m_lChannelID+1);
	return strFile;
}

long	CRecvFaxDialog::StartRecv(char *szFilePath,long lType)
{	
	if(m_LogData.m_lChannelID >= 0 && QNV_Fax(m_LogData.m_lChannelID,QNV_FAX_TYPE,0,NULL) != FAX_TYPE_NULL) return 0;
	m_lType = lType;
	m_LogData.m_strFaxPath=szFilePath;
	if(m_LogData.m_strFaxPath.IsEmpty()) m_LogData.m_strFaxPath=CreateFaxFile();	
	m_cFilePath.SetWindowText(m_LogData.m_strFaxPath);	
	m_cViewRecvFile.EnableWindow(FALSE);
	m_cOpenDir.EnableWindow(FALSE);
	m_LogData.m_lBeginTime = time(NULL);
	if(QNV_Fax(m_LogData.m_lChannelID,QNV_FAX_STARTRECV,0,(char*)(LPCTSTR)m_LogData.m_strFaxPath) > 0)
	{
		if((QNV_DevInfo(m_LogData.m_lChannelID,QNV_DEVINFO_GETMODULE)&DEVMODULE_SWITCH)
			|| !QNV_GetDevCtrl(m_LogData.m_lChannelID,QNV_CTRL_PHONE))
		{
			m_cState.SetWindowText("正在接收传真,建议暂停操作电脑!");
			StartElapseTimer(m_hWnd);			
			StareRecFile();
		}else
		{
			//如果没有继电器的,软摘机,然后提示用户挂机,检测到挂机后启动传真
			//这样主窗口检测到挂机后不能让它软挂机成功
			//立即暂停,等待挂机后恢复开始
			QNV_Fax(m_LogData.m_lChannelID,QNV_FAX_PAUSE,0,NULL);
			m_cState.SetWindowText("准备接收传真,请挂机...");
		}
		return 1;
	}else
	{
		m_cState.SetWindowText("启动接收传真失败...");
		return 0;
	}
}

void	CRecvFaxDialog::OnCancel() 
{	
	if(QNV_Fax(m_LogData.m_lChannelID,QNV_FAX_TYPE,0,0) == FAX_TYPE_RECV)
	{
		if(MessageBox("正在接收传真，确实要终止吗？","警告",MB_YESNO|MB_ICONWARNING) == IDNO)
			return;
	}
	EnableDoPlay(FALSE);
	QNV_Event(m_LogData.m_lChannelID,QNV_EVENT_UNREGWND,(DWORD)m_hWnd,NULL,NULL,0);
	::PostMessage(m_hCBWnd,m_dwMsgID,m_LogData.m_lChannelID,(LPARAM)this);
	//CDialog::OnCancel();
}

long	CRecvFaxDialog::StopRecv()
{	
	StopRecFile();
	EnableDoPlay(FALSE);
	QNV_Fax(m_LogData.m_lChannelID,QNV_FAX_STOPRECV,0,NULL);
	StopElapseTimer(m_hWnd);
	CBriFaxBase::StopFax();
	return 1;
}

LRESULT CRecvFaxDialog::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	if(message == BRI_EVENT_MESSAGE)
	{
		PBRI_EVENT pEvent=(PBRI_EVENT)lParam;
		_ASSERT(pEvent->uChannelID == m_LogData.m_lChannelID);
		switch(pEvent->lEventType)
		{
		case BriEvent_FaxRecvFinished:
			{
				StopRecFile();
				m_cState.SetWindowText("接收传真完成");
				m_cViewRecvFile.EnableWindow(TRUE);
				m_cOpenDir.EnableWindow(TRUE);
				FinishedFax(m_hWnd);	
				QNV_Fax(m_LogData.m_lChannelID,QNV_FAX_STOPRECV,0,NULL);
				if(m_lType == RECVF_AUTOCLOSE) 
				{
					QNV_Event(m_LogData.m_lChannelID,QNV_EVENT_UNREGWND,(DWORD)m_hWnd,NULL,NULL,0);
					::PostMessage(m_hCBWnd,m_dwMsgID,m_LogData.m_lChannelID,(LPARAM)this);
				}
			}break; 
		case BriEvent_FaxRecvFailed:case BriEvent_Silence:case BriEvent_Busy:case BriEvent_RemoteHang:
			{
				m_LogData.m_lErrorID = pEvent->lEventType;
				StopRecFile();
				CString str;
				if(BS_IsFileExists((char*)(LPCTSTR)m_LogData.m_strFaxPath))
				{
					str.Format("通信错误,接收到部分数据 eid=%d",pEvent->lEventType);
				}else
				{
					str.Format("接收传真失败 eid=%d result=%d",pEvent->lEventType,pEvent->lResult);
				}
				m_cState.SetWindowText(str);
				FailedFax(m_hWnd);
				QNV_Fax(m_LogData.m_lChannelID,QNV_FAX_STOPRECV,0,NULL);
				if(m_lType == RECVF_AUTOCLOSE) 
				{
					QNV_Event(m_LogData.m_lChannelID,QNV_EVENT_UNREGWND,(DWORD)m_hWnd,NULL,NULL,0);
					::PostMessage(m_hCBWnd,m_dwMsgID,m_LogData.m_lChannelID,(LPARAM)this);
				}
			}break;
		case BriEvent_PhoneHang:
			{
				if(QNV_Fax(m_LogData.m_lChannelID,QNV_FAX_ISPAUSE,0,NULL))
				{					
					StareRecFile();
					QNV_Fax(m_LogData.m_lChannelID,QNV_FAX_RESUME,0,NULL);
					m_cState.SetWindowText("正在接收传真,建议暂停操作电脑!");
					StartElapseTimer(m_hWnd);
					EnableDoPlay(m_cDoPlay.GetCheck());	
				}
			}break;
		default:break;
		}
	}else if(message == WM_TIMER && wParam == m_nElapseTimer)
	{
		m_lElapse++;
		CString str;
		str.Format("%02d:%02d:%02d",m_lElapse/3600,m_lElapse%3600/60,m_lElapse%60);
		m_cStElapse.SetWindowText(str);
	}
	return CDialog::WindowProc(message, wParam, lParam);
}


void CRecvFaxDialog::OnDestroy() 
{
	QNV_Event(m_LogData.m_lChannelID,QNV_EVENT_UNREGWND,(DWORD)m_hWnd,NULL,NULL,0);
	CDialog::OnDestroy();	
}

void CRecvFaxDialog::OnViewrecvfile() 
{
	//::ShellExecute(NULL,"open",m_LogData.m_strFaxPath,"",NULL,SW_SHOWNORMAL);	
	::ShellExecute(NULL,"open","rundll32.exe","shimgvw.dll,ImageView_Fullscreen "+m_LogData.m_strFaxPath,NULL,SW_SHOWNORMAL); 
}

void CRecvFaxDialog::OnDoplay() 
{
	EnableDoPlay(m_cDoPlay.GetCheck());	
}

void CRecvFaxDialog::OnOpendir()
{
	CString strPath="/select, "+m_LogData.m_strFaxPath;
	::ShellExecute(NULL, _T("open"), _T("Explorer.exe"), (char*)(LPCTSTR)strPath, NULL, SW_SHOW);
}
