#ifndef __BRIFAXMANA_H__
#define __BRIFAXMANA_H__
#include "BriWnd.h"
#include "RecvFaxDialog.h"
#include "SendFaxDialog.h"
#include "BriFaxLog.h"
#include "FaxLogDialog.h"
#include "FaxTooltip.h"

class	CBriFaxMana : public CBriWnd
{
public:
	CBriFaxMana();
	virtual ~CBriFaxMana();
public:
	long	StartRecvFax(short nChannelID,char *szFilePath,long lType);
	long	StopRecvFax(short nChannelID);
	long	StartSendFax(short nChannelID,char *szFilePath,long lType);
	long	StopSendFax(short nChannelID);
	long	FaxLog();
	long	CloseFaxLog();
	long	FaxTooltip(short nChannelID);
	long	CloseFaxTooltip(short nChannelID);
	long	FreeSource();
protected:
	virtual LRESULT	WindowProc(UINT msg,WPARAM wParam,LPARAM lParam);
private:
	
	void	CloseFaxLogDialog();
	BOOL	CreateFaxLogDialog();
	void	CloseFaxTooltip();
	BOOL	CreateFaxTooltip(short nChannelID);

	void	ShowDialog(HWND hWnd);
private:
	CRecvFaxDialog	*m_pRecvFaxDialog[MAX_CHANNEL_COUNT];
	CSendFaxDialog	*m_pSendFaxDialog[MAX_CHANNEL_COUNT];
private:
	CBriFaxLog	m_FaxLog;
	CFaxLogDialog	*m_pFaxLogDialog;
	CFaxTooltip		*m_pFaxTooltip;

};

#endif