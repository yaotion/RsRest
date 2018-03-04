#include "stdafx.h"
#include "BriFaxBase.h"

CBriFaxBase::CBriFaxBase()
{
	m_hCBWnd = NULL;
	m_dwMsgID = 0;
	m_pFaxLog=NULL;
	m_nElapseTimer=NULL;
	m_lElapse = 0;
	m_lRecHandle = -1;
}

CBriFaxBase::~CBriFaxBase()
{
}

void	CBriFaxBase::SetChannel(int iID)
{
	m_LogData.m_lChannelID=iID;	
}

long	CBriFaxBase::StopFax()
{
	if(m_LogData.m_lBeginTime != 0)
	{
		m_LogData.m_lResult = FAX_RESULT_CANCEL;
		m_LogData.m_lEndTime = time(NULL);
		m_LogData.m_strCode=(char*)QNV_CallLog(m_LogData.m_lChannelID,QNV_CALLLOG_CALLID,0,NULL);
		m_pFaxLog->WriteLog(&m_LogData);
		return 1;
	}else return 0;
}

long	CBriFaxBase::FinishedFax(HWND hWnd)
{
	StopElapseTimer(hWnd);
	m_LogData.m_lResult = FAX_RESULT_OK;
	m_LogData.m_lEndTime = time(NULL);
	m_LogData.m_strCode=(char*)QNV_CallLog(m_LogData.m_lChannelID,QNV_CALLLOG_CALLID,0,NULL);
	m_pFaxLog->WriteLog(&m_LogData);				
	return 1;
}

long	CBriFaxBase::FailedFax(HWND hWnd)
{	
	StopElapseTimer(hWnd);
	m_LogData.m_lResult = FAX_RESULT_FAILED;
	m_LogData.m_lEndTime = time(NULL);
	m_LogData.m_strCode=(char*)QNV_CallLog(m_LogData.m_lChannelID,QNV_CALLLOG_CALLID,0,NULL);
	m_pFaxLog->WriteLog(&m_LogData);
	return 1;
}

long	CBriFaxBase::EnableDoPlay(BOOL bEnable)
{
	QNV_SetDevCtrl(m_LogData.m_lChannelID,QNV_CTRL_DOPLAY,bEnable);
	if(bEnable)
	{
		QNV_SetDevCtrl(m_LogData.m_lChannelID,QNV_CTRL_PLAYMUX,DOPLAY_CHANNEL0_ADC);//收发传真,必须软摘机后执行	
		QNV_SetParam(m_LogData.m_lChannelID,QNV_PARAM_AM_DOPLAY,5);	
	}else
		QNV_SetParam(m_LogData.m_lChannelID,QNV_PARAM_AM_DOPLAY,14);	
	return 1;
}

long	CBriFaxBase::StartElapseTimer(HWND hWnd)
{
	m_lElapse= 0;
	if(!m_nElapseTimer)
	{
		m_nElapseTimer= ::SetTimer(hWnd,0x40,1000,NULL);
	}	
	return m_nElapseTimer;
}

void	CBriFaxBase::StopElapseTimer(HWND hWnd)
{
	if(m_nElapseTimer)
	{
		::KillTimer(hWnd,m_nElapseTimer);
		m_nElapseTimer=NULL;
	}
}

long	CBriFaxBase::StareRecFile()
{	
	StopRecFile();
	CString str;
	char szFile[_MAX_PATH]={0};
	BS_GetModuleFilePath("FaxRec",szFile,_MAX_PATH);	
	BS_MakeSureDirectoryExists(szFile);
	CTime ct=CTime::GetCurrentTime();
	str.Format("%s\\%04d%02d%02d%02d%02d%02d.wav",szFile,ct.GetYear(),ct.GetMonth(),ct.GetDay(),ct.GetHour(),ct.GetMinute(),ct.GetSecond());
	m_lRecHandle = QNV_RecordFile(m_LogData.m_lChannelID,QNV_RECORD_FILE_START,0,0,(char*)(LPCTSTR)str);
	return m_lRecHandle>0;
}

void	CBriFaxBase::StopRecFile()
{
	if(m_lRecHandle > 0)
	{
		QNV_RecordFile(m_LogData.m_lChannelID,QNV_RECORD_FILE_STOP,m_lRecHandle,0,NULL);
		m_lRecHandle = -1;		
	}
}