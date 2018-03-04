// MediaPlay.cpp : implementation file
//

#include "stdafx.h"
#include "qnviccubdemo.h"
#include "MediaPlay.h"
#include "inputremote.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CMediaPlay dialog


CMediaPlay::CMediaPlay(CWnd* pParent /*=NULL*/)
	: CDialog(CMediaPlay::IDD, pParent)
{
	//{{AFX_DATA_INIT(CMediaPlay)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	m_lPlayFileHandle=-1;
	m_nChannelID = -1;
	m_uPlayTimer =NULL;
}


void CMediaPlay::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CMediaPlay)
	DDX_Control(pDX, IDC_STTOTALPLAY, m_cTotalPlay);
	DDX_Control(pDX, IDC_STTOTALLEN, m_cTotalLen);
	DDX_Control(pDX, IDC_OPENFILE, m_cOpenFile);
	DDX_Control(pDX, IDC_PLAYSLIDER, m_cPlaySlider);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CMediaPlay, CDialog)
	//{{AFX_MSG_MAP(CMediaPlay)
	ON_BN_CLICKED(IDC_OPENFILE, OnOpenfile)
	ON_BN_CLICKED(IDC_STOP, OnStop)
	ON_BN_CLICKED(IDC_PAUSE, OnPause)
	ON_BN_CLICKED(IDC_RESUME, OnResume)
	ON_WM_DESTROY()
	ON_BN_CLICKED(IDC_REMOTEFILE, OnRemotefile)
	ON_NOTIFY(NM_RELEASEDCAPTURE, IDC_PLAYSLIDER, OnReleasedcapturePlayslider)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CMediaPlay message handlers

BOOL CMediaPlay::OnInitDialog() 
{
	CDialog::OnInitDialog();	

	QNV_Event(m_nChannelID,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);
	GetDlgItem(IDC_STOP)->EnableWindow(FALSE);
	GetDlgItem(IDC_PAUSE)->EnableWindow(FALSE);
	GetDlgItem(IDC_RESUME)->EnableWindow(FALSE);

	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CMediaPlay::OnOpenfile() 
{
	CString strFilePath=((CQnviccubdemoApp*)AfxGetApp())->SelectFilePath(1);
	if(!strFilePath.IsEmpty())
	{
		StartPlayFile(strFilePath);
	}		
}

void CMediaPlay::OnStop() 
{
	StopPlayTimer();
	m_cPlaySlider.SetPos(0);
	if(m_lPlayFileHandle > 0)
	{
		QNV_PlayFile(m_nChannelID,QNV_PLAY_FILE_STOP,m_lPlayFileHandle,0,NULL);
		m_lPlayFileHandle = -1;
	}
	GetDlgItem(IDC_OPENFILE)->EnableWindow(TRUE);
	GetDlgItem(IDC_STOP)->EnableWindow(FALSE);
	GetDlgItem(IDC_PAUSE)->EnableWindow(FALSE);
	GetDlgItem(IDC_RESUME)->EnableWindow(FALSE);
}

void CMediaPlay::OnPause() 
{
	if(m_lPlayFileHandle > 0)
	{
		QNV_PlayFile(m_nChannelID,QNV_PLAY_FILE_PAUSE,m_lPlayFileHandle,0,NULL);
	}	
	GetDlgItem(IDC_PAUSE)->EnableWindow(FALSE);
	GetDlgItem(IDC_RESUME)->EnableWindow(TRUE);
	StopPlayTimer();
}

void CMediaPlay::OnResume() 
{
	if(m_lPlayFileHandle > 0)
	{
		//先跳转到滚动条位置
		QNV_PlayFile(m_nChannelID,QNV_PLAY_FILE_SEEKTO,m_lPlayFileHandle,m_cPlaySlider.GetPos(),NULL);
		//开始播放
		QNV_PlayFile(m_nChannelID,QNV_PLAY_FILE_RESUME,m_lPlayFileHandle,0,NULL);
	}
	GetDlgItem(IDC_PAUSE)->EnableWindow(TRUE);
	GetDlgItem(IDC_RESUME)->EnableWindow(FALSE);
	StartPlayTimer();
}

LRESULT CMediaPlay::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	if(message == BRI_EVENT_MESSAGE)
	{
		PBRI_EVENT pEvent=(PBRI_EVENT)lParam;
		if(pEvent->lEventType == BriEvent_PlayFileEnd && pEvent->lResult == m_lPlayFileHandle)
		{
			OnStop();
		}
	}else if(message == WM_TIMER)
	{
		if(wParam == m_uPlayTimer && m_lPlayFileHandle > 0 && !QNV_PlayFile(m_nChannelID,QNV_PLAY_FILE_ISPAUSE,m_lPlayFileHandle,0,NULL))
		{
			if(m_cPlaySlider.GetRangeMax() <= 0)
			{//可能上次没有下载到总共长度,重新获取
				m_cPlaySlider.SetRange(0,QNV_PlayFile(m_nChannelID,QNV_PLAY_FILE_TOTALLEN,m_lPlayFileHandle,0,NULL));
				ShowTotalLen();
			}
			long lSeekTime=QNV_PlayFile(m_nChannelID,QNV_PLAY_FILE_CURSEEK,m_lPlayFileHandle,0,NULL);			
			m_cPlaySlider.SetPos(lSeekTime);
			TRACE("lSeekTime=%d\r\n",lSeekTime);
			CString str;
			str.Format("%02d:%02d:%02d",lSeekTime/1000/3600,lSeekTime/1000%3600/60,lSeekTime/1000%60);
			m_cTotalPlay.SetWindowText(str);
		}
	}
	return CDialog::WindowProc(message, wParam, lParam);
}

void	CMediaPlay::ShowTotalLen()
{
	if(m_cPlaySlider.GetRangeMax() > 0)
	{
		long lTotalLen=m_cPlaySlider.GetRangeMax();
		CString str;
		str.Format("%02d:%02d:%02d %03d",lTotalLen/1000/3600,lTotalLen/1000%3600/60,lTotalLen/1000%60,lTotalLen%1000);
		m_cTotalLen.SetWindowText(str);
	}
}

BOOL	CMediaPlay::StartPlayTimer()
{
	if(NULL == m_uPlayTimer)
	{
		m_uPlayTimer = SetTimer(0x10,500,NULL);
	}
	return TRUE;
}

void	CMediaPlay::StopPlayTimer()
{
	if(NULL != m_uPlayTimer)
	{
		KillTimer(m_uPlayTimer);
		m_uPlayTimer = NULL;
	}
}

void CMediaPlay::OnDestroy() 
{
	QNV_Event(m_nChannelID,QNV_EVENT_UNREGWND,(DWORD)m_hWnd,NULL,NULL,0);
	OnStop();
	CDialog::OnDestroy();	
}

void CMediaPlay::OnRemotefile() 
{
	CInputRemote input;
	if(input.DoModal() == IDOK)
	{
		CString strHTTPCookie="asssssssssssssss";
		//QNV_Remote(QNV_REMOTE_SETCOOKIE,0,(char*)(LPCTSTR)strHTTPCookie,NULL,NULL,0);//设置COOKIE
		StartPlayFile(input.m_strRemoteFile);		
	}		
}

BOOL	CMediaPlay::StartPlayFile(CString strFilePath)
{	
	if(m_lPlayFileHandle > 0)
	{
		AfxMessageBox("请先停止");
	}
	m_lPlayFileHandle = QNV_PlayFile(m_nChannelID,QNV_PLAY_FILE_START,0,0,(char*)(LPCTSTR)strFilePath);
	if(m_lPlayFileHandle <= 0)
	{
		CString str;
		str.Format("播放失败 errid=%d",m_lPlayFileHandle);
		AfxMessageBox(str);
	}else
	{	
		GetDlgItem(IDC_OPENFILE)->EnableWindow(FALSE);
		GetDlgItem(IDC_STOP)->EnableWindow(TRUE);
		GetDlgItem(IDC_PAUSE)->EnableWindow(TRUE);
		GetDlgItem(IDC_RESUME)->EnableWindow(FALSE);
		
		//远程文件的可能还没有下载到总共长度，等下次获取SEEK时重新读取
		m_cPlaySlider.SetRange(0,QNV_PlayFile(m_nChannelID,QNV_PLAY_FILE_TOTALLEN,m_lPlayFileHandle,0,NULL));
		ShowTotalLen();
		StartPlayTimer();
	}
	return TRUE;
}

void CMediaPlay::OnReleasedcapturePlayslider(NMHDR* pNMHDR, LRESULT* pResult) 
{	
	int iPos=m_cPlaySlider.GetPos();
	if(m_lPlayFileHandle > 0)
	{
		long lSeek=QNV_PlayFile(m_nChannelID,QNV_PLAY_FILE_SEEKTO,m_lPlayFileHandle,iPos,NULL);
		TRACE("seek=%d ipos=%d\r\n",lSeek,iPos);
	}
	*pResult = 0;
}
