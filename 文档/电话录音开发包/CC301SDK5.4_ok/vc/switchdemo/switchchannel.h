#ifndef __SWITCHCHANNEL_H__
#define __SWITCHCHANNEL_H__
#include "BriWnd.h"

enum
{
	SS_NULL=0x0,
	SS_PLAYTOOLTIP=0x1,
	SS_BACKGROUP=0x2,
	SS_APPENDSTATUS=0x3,
};

enum
{
	CH_STATUS_NULL=0x0,
	CH_STATUS_BUSY=0x1,
};
class	CSwitchChannel : public CBriWnd
{
public:
	CSwitchChannel();
	virtual ~CSwitchChannel();
public:
	void	SetChannelCtrlID(BRIINT16 uID){m_uChannelID = uID;}
	long	StartSwitch();
	long	StopSwitch();
	void	FreeSource();
protected:
	virtual LRESULT WindowProc(UINT msg, WPARAM wParam, LPARAM lParam);
private:
	long	ProcessCallInID(char *szCallID);
	long	ProcessGetDTMF(char szDTMF);
	long	StopPlayFile();
	long	StartPlayBackgroup();
private:
	BRIINT16	GetFreeChannel();//查找一个空闲的内线通道
	long		End();
private:
	DC_DATA		m_cbdata;
	long		m_lPlayFileHandle;
	BRIINT16	m_uChannelID;
	long		m_lSwitchStatus;

	long		m_lConfID;//软交换使用的会议ID
	BRIINT16	m_uSwitchChannelID;//交换的内线通道
	CString		m_strStatus;
	CString		m_strCallID;
};	

#endif