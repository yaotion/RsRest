#ifndef __BRIFAXLOG_H__
#define __BRIFAXLOG_H__
#include "BriStringLib.h"

//������־
//ͨ��,��ʼʱ�䣬����ʱ�䣬�ɹ�/ʧ�ܣ��Է�����,����/����������/���գ��ļ�·��
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
		//�ļ�·�����Բ�ɾ���������ű����ã�ÿ���շ������Զ�����
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