#ifndef __BRIFAXLOG_H__
#define __BRIFAXLOG_H__
#include "BriStringLib.h"

//传真日志
//通道,开始时间，结束时间，成功/失败，对方号码,呼入/呼出，发送/接收，文件路径
//

class	CLogData
{
public:
	CLogData(){m_lChannelID=-1;Reset();}
	virtual ~CLogData(){}
public:
	void	CLogData::Reset()
	{
		m_lBeginTime=m_lEndTime=m_lResult = 0;
		m_lSendRecvType = 0;
		m_lSerial = 0;
		m_lErrorID= 0;
		m_strCode.Empty();
		//文件路径可以不删除，保存着被调用，每次收发都会自动更新
	}
public:
	short	m_lChannelID;
	long	m_lSerial;
	long	m_lBeginTime;
	long	m_lEndTime;
	long	m_lResult;
	CString m_strCode;
	long	m_lSendRecvType;
	long	m_lErrorID;
	CString m_strFaxPath;
};

class	CBriFaxLog
{
public:
	CBriFaxLog();
	virtual ~CBriFaxLog();
public:
	long	WriteLog(CLogData *pLogData);
private:
	//void	Reset();
	BOOL	OpenLogFile();
	BOOL	CloseLogFile();
private:
	FILE*	m_pLogFile;
};

#endif