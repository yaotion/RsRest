#ifndef __DIALCHANNEL_H__
#define __DIALCHANNEL_H__
#include "BriWnd.h"

enum
{
	DCT_NULL=0x0,
	DCT_DIAL=0x1,
	DCT_TOOLTIP=0x2,
	DCT_PLAYDATA=0x3,
	DCT_FINISH=0x4
};

class	CDialChannel : public CBriWnd
{
public:
	CDialChannel();
	virtual ~CDialChannel();
public:
	void	SetChannelCtrlID(BRIINT16 uID){m_uChannelID = uID;}
	long	StartDial();
	long	StopDial();
	void	FreeSource();
protected:
	virtual LRESULT WindowProc(UINT msg, WPARAM wParam, LPARAM lParam);
private:
	CString		GetDevErrStr(long lResult);
	CString		GetModulePath();
	long		AppendStatus(LPCTSTR lpStatus);
private:
	long		StartPlayTooltip();
	long		StartPlayData();
	long		StopPlayFile();

	long		StartDialOut();
private:
	DC_DATA		m_cbdata;
	BRIINT16	m_uChannelID;
	long		m_lPlayFileHandle;
	char		m_szDialCode[256];
private:
	long		m_lDialStatus;
};


#endif