// FaxTooltip.cpp : implementation file
//

#include "stdafx.h"
#include "resource.h"
#include "FaxTooltip.h"
#include "BriFaxUI.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CFaxTooltip dialog


CFaxTooltip::CFaxTooltip(CWnd* pParent /*=NULL*/)
	: CDialog(CFaxTooltip::IDD, pParent)
{
	//{{AFX_DATA_INIT(CFaxTooltip)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	m_nTimer=NULL;
	m_lElapseTick=0;
	m_lType= 0;
}


void CFaxTooltip::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CFaxTooltip)
	DDX_Control(pDX, IDOK, m_OK);
	DDX_Control(pDX, IDCANCEL, m_Cancel);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CFaxTooltip, CDialog)
	//{{AFX_MSG_MAP(CFaxTooltip)
	ON_WM_TIMER()
	ON_WM_DESTROY()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CFaxTooltip message handlers

BOOL CFaxTooltip::OnInitDialog() 
{
	CDialog::OnInitDialog();		
	CRect rc;
	GetWindowRect(&rc);
	CPoint pt;
	pt.x = GetSystemMetrics(SM_CXSCREEN)-rc.Width()-2;
	pt.y = GetSystemMetrics(SM_CYSCREEN)-30-rc.Height();	
	SetWindowPos(&wndTopMost,pt.x,pt.y,0,0,SWP_NOSIZE|SWP_NOACTIVATE);
	m_lElapseTick= 0 ;
	//自动软摘机,检测用户如果挂机就自动接收
	QNV_SetDevCtrl(m_LogData.m_lChannelID,QNV_CTRL_DOHOOK,1);
	QNV_Event(m_LogData.m_lChannelID,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);
	//disable hangup->0x40000000
	long lUserValue=QNV_General(m_LogData.m_lChannelID,QNV_GENERAL_GETUSERVALUE,0,0);
	QNV_General(m_LogData.m_lChannelID,QNV_GENERAL_SETUSERVALUE,0x40000000|lUserValue,NULL);
	m_nTimer = SetTimer(0x30,1000,NULL);
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CFaxTooltip::FreeSource()
{
	long lUserValue=QNV_General(m_LogData.m_lChannelID,QNV_GENERAL_GETUSERVALUE,0,0);
	lUserValue&=~0x40000000;
	QNV_General(m_LogData.m_lChannelID,QNV_GENERAL_SETUSERVALUE,lUserValue,NULL);
	QNV_Event(m_LogData.m_lChannelID,QNV_EVENT_UNREGWND,(DWORD)m_hWnd,NULL,NULL,0);
	CloseTimer();
}

void CFaxTooltip::CloseTimer()
{
	if(m_nTimer)
	{
		KillTimer(m_nTimer);
		m_nTimer=NULL;
	}
}
void CFaxTooltip::OnOK() 
{
	CloseTimer();
	::PostMessage(m_hCBWnd,m_dwMsgID,FT_ACCEPTFAX,(LPARAM)this);
	//CDialog::OnOK();
}

void CFaxTooltip::OnCancel() 
{
	CloseTimer();
	::PostMessage(m_hCBWnd,m_dwMsgID,FT_CANCELFAX,(LPARAM)this);
	//CDialog::OnCancel();
}

void CFaxTooltip::OnTimer(UINT nIDEvent) 
{
	if(nIDEvent == m_nTimer)
	{		
		CString str;
		if(m_lType == TTIP_AUTORECV)
		{
			str.Format("接收(%d)",5-m_lElapseTick);
			m_OK.SetWindowText(str);
		}else
		{
			str.Format("取消(%d)",5-m_lElapseTick);
			m_Cancel.SetWindowText(str);
		}
		m_lElapseTick++;
		if(m_lElapseTick >= 5)
		{
			if(m_lType == TTIP_AUTORECV) OnOK();
			else OnCancel();
		}
	}
	CDialog::OnTimer(nIDEvent);
}

void CFaxTooltip::OnDestroy() 
{
	CloseTimer();
	CDialog::OnDestroy();	
}

LRESULT CFaxTooltip::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	if(message == BRI_EVENT_MESSAGE)
	{
		PBRI_EVENT pEvent=(PBRI_EVENT)lParam;
		_ASSERT(pEvent->uChannelID == m_LogData.m_lChannelID);
		switch(pEvent->lEventType)
		{
			case BriEvent_PhoneHang:
			{	
				OnOK();
			}break;
		}
	}
	return CDialog::WindowProc(message, wParam, lParam);
}
