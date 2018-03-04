#include "stdafx.h"
#include "BriFaxLog.h"

const char g_szLogHeader[]="begintime,endtime,channel,code,sendrecv,result,filepath,serial,errorid\r\n";
CBriFaxLog::CBriFaxLog()
{	
	m_pLogFile= NULL;	
}

CBriFaxLog::~CBriFaxLog()
{
	CloseLogFile();
}

BOOL	CBriFaxLog::OpenLogFile()
{
	if(!m_pLogFile)
	{
		char szLogFile[_MAX_PATH]={0};
		BS_GetModuleFilePath(FAX_LOG_FILE,szLogFile,_MAX_PATH);	
		BS_MakeSureDirectoryExists(szLogFile);
		m_pLogFile = fopen(szLogFile,"ac");
		if(m_pLogFile)
		{
			fseek(m_pLogFile,0,SEEK_END);
			if(ftell(m_pLogFile) == 0)
			{
				fwrite(g_szLogHeader,1,strlen(g_szLogHeader),m_pLogFile);
			}
		}
	}
	return m_pLogFile!=NULL;
}

BOOL	CBriFaxLog::CloseLogFile()
{
	if(m_pLogFile)
	{
		fclose(m_pLogFile);
		m_pLogFile=NULL;		
	}
	return TRUE;
}
/*
	long	m_lBeginTime;
	long	m_lEndTime;
	short	m_lChannelID;
	long	m_lSerial;
	long	m_lResult;
	long	m_lSendRecvType;
	CString m_strCode;	
	CString m_strFaxPath;
*/
long	CBriFaxLog::WriteLog(CLogData *pLogData)
{
	if(OpenLogFile())
	{
		CString str;
		str.Format("%d,%d,%d,%s,%d,%d,%s,%d,%d,\r\n",
			pLogData->m_lBeginTime,
			pLogData->m_lEndTime,
			pLogData->m_lChannelID,
			pLogData->m_strCode,
			pLogData->m_lSendRecvType,
			pLogData->m_lResult,
			pLogData->m_strFaxPath,
			pLogData->m_lSerial,
			pLogData->m_lErrorID);
		fwrite((char*)(LPCTSTR)str,1,str.GetLength(),m_pLogFile);
		fflush(m_pLogFile);
		pLogData->Reset();
		return 1;
	}else
		return 0;
}
