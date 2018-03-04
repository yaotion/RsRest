#ifndef __BRIFAXBASE_H__
#define __BRIFAXBASE_H__
#include "BriFaxLog.h"
#include "BriFaxUI.h"

class	CBriFaxBase
{
public:
	CBriFaxBase();
	virtual ~CBriFaxBase();
public:
	virtual void	SetChannel(int iID);
	virtual long	StopFax();
	virtual long	FinishedFax(HWND hWnd);
	virtual long	FailedFax(HWND hWnd);
	virtual long	EnableDoPlay(BOOL bEnable);
	
	void	SetCBMsg(HWND hWnd,DWORD dwMsgID){m_hCBWnd = hWnd;m_dwMsgID = dwMsgID;}
	void	SetFaxLog(CBriFaxLog *pFaxLog){m_pFaxLog = pFaxLog;}
	CString CreateFaxFile();
	short	GetChannel(){return m_LogData.m_lChannelID;}
	long	StartElapseTimer(HWND hWnd);
	void	StopElapseTimer(HWND hWnd);
protected:
	void	StopRecFile();
	long	StareRecFile();
protected:
	CBriFaxLog	*m_pFaxLog;
	HWND		m_hCBWnd;
	DWORD		m_dwMsgID;
	CLogData	m_LogData;
	UINT		m_nElapseTimer;
	long		m_lElapse;
	long		m_lRecHandle;
};

#endif