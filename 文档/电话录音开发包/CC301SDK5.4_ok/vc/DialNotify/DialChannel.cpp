#include "stdafx.h"
#include "DialChannel.h"

CDialChannel::CDialChannel()
{
	memset(m_szDialCode,0,sizeof(m_szDialCode));
	memset(&m_cbdata,0,sizeof(m_cbdata));
	m_lPlayFileHandle = -1;
	m_lDialStatus = DCT_NULL;
}

CDialChannel::~CDialChannel()
{

}

CString		CDialChannel::GetDevErrStr(long lResult)
{
	switch(lResult)
	{
	case 0:return "读取数据错误";
	case 1:return "写入数据错误";
	case 2:return "数据帧ID丢失,可能是CPU太忙";
	case 3:return "设备已经被拔掉";
	case 4:return "序列号冲突";
	default:return "未知错误";
	}
	return "";
}

CString CDialChannel::GetModulePath()
{
	char szSourcePath[_MAX_PATH];
	GetModuleFileName(NULL, szSourcePath, _MAX_PATH); 
    *(strrchr(szSourcePath, '\\') + 1) = '\0';          
	CString RetStr=szSourcePath;
	return RetStr;
}

LRESULT CDialChannel::WindowProc(UINT msg, WPARAM wParam, LPARAM lParam)
{
	if(msg == BRI_EVENT_MESSAGE)
	{
		PBRI_EVENT pEvent=(PBRI_EVENT)lParam;
		CString str,strValue;
		strValue.Format("Handle=%d Result=%d Data=%s",pEvent->lEventHandle,pEvent->lResult,pEvent->szData);
		switch(pEvent->lEventType)
		{
		case BriEvent_PhoneHook:str.Format("通道%d: 电话机摘机 %s",m_uChannelID+1,strValue);break;
		case BriEvent_PhoneHang:str.Format("通道%d: 电话机挂机 %s",m_uChannelID+1,strValue);break;
		case BriEvent_DialEnd:
			{
				str.Format("通道%d: 拨号结束 %s",m_uChannelID+1,strValue);
				//先循环播放提示音
				StartPlayTooltip();
				//
			}break;
		case BriEvent_PlayFileEnd:
			{
				str.Format("通道%d: 播放文件结束 %s",m_uChannelID+1,strValue);
			}break;
		case BriEvent_RepeatPlayFile:str.Format("通道%d: 循环播放文件 %s",m_uChannelID+1,strValue);break;
		case BriEvent_Silence:str.Format("通道%d: 通话中一定时间的静音 %s",m_uChannelID+1,strValue);break;
		case BriEvent_GetDTMFChar:
			{
				str.Format("通道%d: 接收到按键 %s",m_uChannelID+1,strValue);
				if(m_lDialStatus == DCT_TOOLTIP && pEvent->szData[0] == '1')
				{
					StartPlayData();
				}
			}break;
		case BriEvent_RemoteHook:str.Format("通道%d: 远程摘机 %s",m_uChannelID+1,strValue);break;
		case BriEvent_RemoteHang:case BriEvent_Busy:
			{
				if(m_lDialStatus >= DCT_PLAYDATA) 	SendCBMsg(DC_DIAL_FINISH,(LPARAM)&m_cbdata);
				else SendCBMsg(DC_DIAL_NOTTALK,(LPARAM)&m_cbdata);
				if(pEvent->lEventType ==BriEvent_RemoteHang) str.Format("通道%d: 远程挂机 %s",m_uChannelID+1,strValue);
				else if(pEvent->lEventType ==BriEvent_Busy)str.Format("通道%d: 接收到忙音,线路已经断开 %s",m_uChannelID+1,strValue);
				QNV_SetDevCtrl(m_uChannelID,QNV_CTRL_DOHOOK,FALSE);//挂机
				Sleep(2000);//等待线路释放，避免被识别成拍插簧
				StartDialOut();
			}break;
		case BriEvent_RingBack:str.Format("通道%d: 拨号后接收到回铃音 %s",m_uChannelID+1,strValue);break;
		case BriEvent_PSTNFree:str.Format("通道%d: PSTN线路已空闲 %s",m_uChannelID+1,strValue);break;	
		case BriEvent_DevErr:str.Format("通道%d: 设备发生错误！原因=%s(%d/%d) %s",m_uChannelID+1,GetDevErrStr(pEvent->lResult),(atol(pEvent->szData)&0xFF00)>>8,(atol(pEvent->szData)&0xFF),strValue);break;
		default:break;
		}
		if(!str.IsEmpty())
		{			
			AppendStatus(str);
		}
		return  TRUE;
	}
	return CBriWnd::WindowProc(msg,wParam,lParam);
}


long	CDialChannel::AppendStatus(LPCTSTR lpStatus)
{
	memset(&m_cbdata,0,sizeof(m_cbdata));
	if(strlen(lpStatus) < 256)
	{
		strcpy(m_cbdata.szData,(char*)lpStatus);
	}
	SendCBMsg(DC_DIAL_STATUS,(LPARAM)&m_cbdata);
	return 0;
}

long	CDialChannel::StartPlayTooltip()
{
	StopPlayFile();
	CString str;
	CString strPath=GetModulePath()+DC_TOOLTIP_FILE;
	DWORD dwMask=PLAYFILE_MASK_REPEAT;//循环播放
	m_lPlayFileHandle = QNV_PlayFile(m_uChannelID,QNV_PLAY_FILE_START,0,dwMask,(char*)(LPCTSTR)strPath);
	if(m_lPlayFileHandle <= 0)
	{		
		str.Format("播放失败 errid=%d file=%s",m_lPlayFileHandle,strPath);	
		AppendStatus(str);
		return 0;
	}else
	{
		str.Format("开始播放 file=%s",strPath);	
		AppendStatus(str);
		m_lDialStatus = DCT_TOOLTIP;
		return 1;
	}
}

long	CDialChannel::StartPlayData()
{
	StopPlayFile();
	CString str;
	CString strPath=GetModulePath()+DC_DATA_FILE;
	DWORD dwMask=PLAYFILE_MASK_REPEAT;//循环播放
	m_lPlayFileHandle = QNV_PlayFile(m_uChannelID,QNV_PLAY_FILE_START,0,dwMask,(char*)(LPCTSTR)strPath);
	if(m_lPlayFileHandle <= 0)
	{		
		str.Format("播放失败 errid=%d file=%s",m_lPlayFileHandle,strPath);	
		AppendStatus(str);
		return 0;
	}else
	{
		str.Format("开始播放 file=%s",strPath);	
		AppendStatus(str);
		m_lDialStatus = DCT_PLAYDATA;
		return 1;
	}
}

long	CDialChannel::StopPlayFile()
{
	if(m_lPlayFileHandle > 0)
	{
		QNV_PlayFile(m_uChannelID,QNV_PLAY_FILE_STOP,m_lPlayFileHandle,0,NULL);
		m_lPlayFileHandle = -1;
		return 1;
	}else
	{
		return 0;
	}
}

long	CDialChannel::StartDial()
{
	Create();
	m_cbdata.uchannelid = m_uChannelID;
#ifdef _DEBUG
	QNV_SetDevCtrl(m_uChannelID,QNV_CTRL_DOPLAY,1);
	QNV_SetDevCtrl(m_uChannelID,QNV_CTRL_PLAYMUX,DOPLAY_CHANNEL0_ADC);	
#endif
	if(!(QNV_DevInfo(m_uChannelID,QNV_DEVINFO_GETMODULE)&DEVMODULE_HOOK))//设备具有软摘机才可以群拨
	{
		return 0;
	}else
	{
		QNV_Event(m_uChannelID,QNV_EVENT_REGWND,(DWORD)GetSafeHwnd(),NULL,NULL,0);
		return StartDialOut();
	}
}

long	CDialChannel::StartDialOut()
{
	SendCBMsg(DC_REQUEST_CODE,(LPARAM)&m_cbdata);
	if(m_cbdata.lresult > 0)
	{
		QNV_SetDevCtrl(m_uChannelID,QNV_CTRL_PLAYTOLINE,TRUE);//自动打开播放语音到LINE
		QNV_SetDevCtrl(m_uChannelID,QNV_CTRL_LINEOUT,TRUE);//自动打开线路输入开关,如果不打开以上连个开关，就不能正常拨号
		QNV_General(m_uChannelID,QNV_GENERAL_STARTDIAL,0,m_cbdata.szData);
		m_lDialStatus = DCT_DIAL;
		AppendStatus((CString)"开始拨号："+m_cbdata.szData);
		return 1;
	}else
	{
		return 0;
	}
}

long	CDialChannel::StopDial()
{
	StopPlayFile();
	QNV_Event(m_uChannelID,QNV_EVENT_UNREGWND,(DWORD)GetSafeHwnd(),NULL,NULL,0);
	QNV_General(m_uChannelID,QNV_GENERAL_STOPDIAL,0,NULL);
	QNV_SetDevCtrl(m_uChannelID,QNV_CTRL_DOHOOK,FALSE);
	return 0;
}

void	CDialChannel::FreeSource()
{
	StopPlayFile();
	QNV_General(m_uChannelID,QNV_GENERAL_STOPDIAL,0,NULL);
	QNV_SetDevCtrl(m_uChannelID,QNV_CTRL_DOHOOK,FALSE);
}