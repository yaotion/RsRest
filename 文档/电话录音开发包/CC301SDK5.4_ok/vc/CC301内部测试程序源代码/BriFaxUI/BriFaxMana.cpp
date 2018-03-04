#include "stdafx.h"
#include "BriFaxMana.h"


CBriFaxMana::CBriFaxMana()
{	
	for(int i=0;i<MAX_CHANNEL_COUNT;i++)
	{
		m_pRecvFaxDialog[i]=NULL;
		m_pSendFaxDialog[i]=NULL;
	}
	m_pFaxLogDialog=NULL;
	m_pFaxTooltip=NULL;
}

CBriFaxMana::~CBriFaxMana()
{
	FreeSource();
}

void	CBriFaxMana::ShowDialog(HWND hWnd)
{
	if( ::IsIconic(hWnd))
		::ShowWindow(hWnd,SW_RESTORE);
	else
		::ShowWindow(hWnd,SW_SHOW);
}

long	CBriFaxMana::FreeSource()
{
	CloseFaxTooltip();
	CloseFaxLogDialog();
	for(int i=0;i<MAX_CHANNEL_COUNT;i++)
	{
		if(m_pRecvFaxDialog[i])
		{
			m_pRecvFaxDialog[i]->StopRecv();
			delete m_pRecvFaxDialog[i];
			m_pRecvFaxDialog[i]=NULL;
		}
		if(m_pSendFaxDialog[i])
		{
			m_pSendFaxDialog[i]->StopSend();
			delete m_pSendFaxDialog[i];
			m_pSendFaxDialog[i]=NULL;
		}
	}
	return 0;
}

void	CBriFaxMana::CloseFaxLogDialog()
{
	if(m_pFaxLogDialog)
	{
		m_pFaxLogDialog->FreeSource();
		delete m_pFaxLogDialog;
		m_pFaxLogDialog=NULL;
	}
}


BOOL	CBriFaxMana::CreateFaxLogDialog()
{
	Create();
	if(!m_pFaxLogDialog)
	{
		m_pFaxLogDialog= new CFaxLogDialog();
		m_pFaxLogDialog->Create(CFaxLogDialog::IDD,CWnd::FromHandle(::GetDesktopWindow()));
		m_pFaxLogDialog->SetCBMsg(m_hWnd,FAX_CLOSELOG_MESSAGE);
	}
	ShowDialog(m_pFaxLogDialog->m_hWnd);
	return m_pFaxLogDialog!=NULL;
}

void	CBriFaxMana::CloseFaxTooltip()
{
	if(m_pFaxTooltip)
	{
		m_pFaxTooltip->FreeSource();
		delete m_pFaxTooltip;
		m_pFaxTooltip=NULL;
	}
}

BOOL	CBriFaxMana::CreateFaxTooltip(short nChannelID)
{
	Create();
	if(!m_pFaxTooltip)
	{
		m_pFaxTooltip = new CFaxTooltip();
		m_pFaxTooltip->SetCBMsg(m_hWnd,FAX_TOOLTIP_MESSAGE);
		m_pFaxTooltip->SetChannel(nChannelID);
		m_pFaxTooltip->Create(CFaxTooltip::IDD,CWnd::FromHandle(::GetDesktopWindow()));
	}
	ShowDialog(m_pFaxTooltip->m_hWnd);
	return NULL!=m_pFaxTooltip;
}

long	CBriFaxMana::FaxLog()
{
	CreateFaxLogDialog();
	return 1;
}

long	CBriFaxMana::CloseFaxLog()
{
	CloseFaxLogDialog();
	return 1;
}
long	CBriFaxMana::FaxTooltip(short nChannelID)
{
	return CreateFaxTooltip(nChannelID);
}

long	CBriFaxMana::CloseFaxTooltip(short nChannelID)
{
	if(m_pFaxTooltip && m_pFaxTooltip->GetChannel() == nChannelID)
	{
		CloseFaxTooltip();
		return 1;
	}else return 0;
}

long	CBriFaxMana::StartRecvFax(short nChannelID,char *szFilePath,long lType)
{
	if(nChannelID > MAX_CHANNEL_COUNT) return -1;
	if(QNV_Fax(nChannelID,QNV_FAX_TYPE,0,0) == FAX_TYPE_SEND) return -2;//如果正在发送
	if(QNV_Fax(nChannelID,QNV_FAX_TYPE,0,0) == FAX_TYPE_NULL)
	{
		StopRecvFax(nChannelID);
	}
	Create();
	if(!m_pRecvFaxDialog[nChannelID])
	{
		m_pRecvFaxDialog[nChannelID]= new CRecvFaxDialog();
		m_pRecvFaxDialog[nChannelID]->SetCBMsg(m_hWnd,FAX_CLOSERECV_MESSAGE);
		m_pRecvFaxDialog[nChannelID]->SetChannel(nChannelID);
		m_pRecvFaxDialog[nChannelID]->Create(CRecvFaxDialog::IDD,CWnd::FromHandle(::GetDesktopWindow()));
		m_pRecvFaxDialog[nChannelID]->SetFaxLog(&m_FaxLog);		
	}
	m_pRecvFaxDialog[nChannelID]->StartRecv(szFilePath,lType);
	ShowDialog(m_pRecvFaxDialog[nChannelID]->m_hWnd);
	CloseFaxTooltip();
	return m_pRecvFaxDialog[nChannelID]!=NULL;
}

long	CBriFaxMana::StopRecvFax(short nChannelID)
{
	if(m_pRecvFaxDialog[nChannelID])
	{
		m_pRecvFaxDialog[nChannelID]->StopRecv();
		delete m_pRecvFaxDialog[nChannelID];
		m_pRecvFaxDialog[nChannelID]=NULL;
	}
	return 1;
}

long	CBriFaxMana::StartSendFax(short nChannelID,char *szFilePath,long lType)
{
	if(nChannelID > MAX_CHANNEL_COUNT) return -1;
	if(QNV_Fax(nChannelID,QNV_FAX_TYPE,0,0) == FAX_TYPE_RECV) return -2;//如果正在发送
	if(QNV_Fax(nChannelID,QNV_FAX_TYPE,0,0) == FAX_TYPE_NULL)
	{
		StopSendFax(nChannelID);
	}
	Create();
	if(!m_pSendFaxDialog[nChannelID])
	{
		m_pSendFaxDialog[nChannelID]= new CSendFaxDialog();
		m_pSendFaxDialog[nChannelID]->SetCBMsg(m_hWnd,FAX_CLOSESEND_MESSAGE);
		m_pSendFaxDialog[nChannelID]->SetChannel(nChannelID);
		m_pSendFaxDialog[nChannelID]->SetFaxLog(&m_FaxLog);
		m_pSendFaxDialog[nChannelID]->Create(CSendFaxDialog::IDD,CWnd::FromHandle(::GetDesktopWindow()));
		m_pSendFaxDialog[nChannelID]->StartSend(szFilePath,lType);
	}
	ShowDialog(m_pSendFaxDialog[nChannelID]->m_hWnd);
	return m_pSendFaxDialog[nChannelID]!=NULL;
}

long	CBriFaxMana::StopSendFax(short nChannelID)
{
	if(m_pSendFaxDialog[nChannelID])
	{
		m_pSendFaxDialog[nChannelID]->StopSend();
		delete m_pSendFaxDialog[nChannelID];
		m_pSendFaxDialog[nChannelID]=NULL;
	}
	return 1;
}

LRESULT	CBriFaxMana::WindowProc(UINT msg,WPARAM wParam,LPARAM lParam)
{
	if(msg == FAX_CLOSERECV_MESSAGE)
	{
		StopRecvFax(wParam);
	}else if(msg == FAX_CLOSESEND_MESSAGE)
	{
		StopSendFax(wParam);
	}else if(msg == FAX_CLOSELOG_MESSAGE)
	{
		CloseFaxLogDialog();
	}else if(msg == FAX_TOOLTIP_MESSAGE)
	{
		if(wParam == FT_CANCELFAX)
		{
			CloseFaxTooltip(m_pFaxTooltip->GetChannel());
		}else if(wParam == FT_ACCEPTFAX && (QNV_GetDevCtrl(m_pFaxTooltip->GetChannel(),QNV_CTRL_DOHOOK) || QNV_GetDevCtrl(m_pFaxTooltip->GetChannel(),QNV_CTRL_PHONE)))
		{
			StartRecvFax(m_pFaxTooltip->GetChannel(),NULL,0);
		}
	}
	return CBriWnd::WindowProc(msg,wParam,lParam);
}
