#include "stdafx.h"
#include "switchchannel.h"

#define		PLAY_TOOLTIP_PATH		"wave\\tooltip.wav"
#define		PLAY_BACKGROUP_PATH		"wave\\rings.wav"

CSwitchChannel::CSwitchChannel()
{
	memset(&m_cbdata,0,sizeof(m_cbdata));
	m_uChannelID =-1;
	m_lPlayFileHandle = -1;
	m_lConfID = 0;
	m_uSwitchChannelID= 0;
	m_lSwitchStatus = SS_NULL;
}


CSwitchChannel::~CSwitchChannel()
{
}

long	CSwitchChannel::StopPlayFile()
{
	if(m_lPlayFileHandle != -1)
	{		
		QNV_PlayFile(m_uChannelID,QNV_PLAY_FILE_STOP,m_lPlayFileHandle,0,NULL);
		m_lPlayFileHandle = -1;
		return 1;
	}else return 0;
}

long	CSwitchChannel::StartPlayBackgroup()
{
	StopPlayFile();	
	m_lPlayFileHandle=QNV_PlayFile(m_uChannelID,QNV_PLAY_FILE_START,0,PLAYFILE_MASK_REPEAT,PLAY_BACKGROUP_PATH);
	if(m_lPlayFileHandle <= 0) AfxMessageBox("播放背景音失败");
	m_lSwitchStatus=SS_BACKGROUP;
	m_strStatus.Format("通道%d:开始播放背景音...",m_uChannelID+1);
	SendCBMsg(SS_APPENDSTATUS,(LPARAM)(char*)(LPCTSTR)m_strStatus);
	return 0;
}

long	CSwitchChannel::ProcessCallInID(char *szCallID)
{	
	m_strCallID=szCallID;
	m_strStatus.Format("通道%d:准备接听...",m_uChannelID+1);
	SendCBMsg(SS_APPENDSTATUS,(LPARAM)(char*)(LPCTSTR)m_strStatus);
	StopPlayFile();
	//摘机接听
	QNV_SetDevCtrl(m_uChannelID,QNV_CTRL_DOHOOK,1);
	//播放提示音
	//PLAYFILE_MASK_REPEAT->循环播放
	m_lPlayFileHandle=QNV_PlayFile(m_uChannelID,QNV_PLAY_FILE_START,0,PLAYFILE_MASK_REPEAT,PLAY_TOOLTIP_PATH);
	if(m_lPlayFileHandle <= 0)
	{
		AfxMessageBox("播放提示音失败");
	}
	//
	m_lSwitchStatus = SS_PLAYTOOLTIP;
	m_strStatus.Format("通道%d:开始播放提示音...",m_uChannelID+1);
	SendCBMsg(SS_APPENDSTATUS,(LPARAM)(char*)(LPCTSTR)m_strStatus);
	return 1;
}

BRIINT16	CSwitchChannel::GetFreeChannel()//查找一个空闲的内线通道
{
	for(BRIINT16 i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{
		if(QNV_General(i,QNV_GENERAL_GETUSERVALUE,0,"") != CH_STATUS_BUSY
			&& QNV_DevInfo(i,QNV_DEVINFO_GETCHANNELTYPE) == CHANNELTYPE_PHONE
			&& QNV_GetDevCtrl(i,QNV_CTRL_PHONE)<= 0)//接话机但不能接外线的通道
		{
			return i;
		}
	}
	return -1;
}

long	CSwitchChannel::ProcessGetDTMF(char szDTMF)
{
	switch(szDTMF)
	{
	case '0':case '1':case '2':case '3':case '4':case '5':case '6':case '7':case '8':case '9':
		{			
			m_uSwitchChannelID=GetFreeChannel();//寻找一个空闲的内线通道
			if(m_uSwitchChannelID >= 0)
			{
				QNV_General(m_uSwitchChannelID,QNV_GENERAL_SETUSERVALUE,CH_STATUS_BUSY,"");//设置内线通道为忙
				StartPlayBackgroup();//给来电线路播放转人工的背景音				
				QNV_SetDevCtrl(m_uSwitchChannelID,QNV_CTRL_DOPHONE,0);//强制断开默认连接
				QNV_SetParam(m_uSwitchChannelID,QNV_PARAM_RINGCALLIDTYPE,/*DIALTYPE_FSK*/DIALTYPE_DTMF);//设置送码方式为一声后FSK模式,默认为一声前dtmf模式
				QNV_General(m_uSwitchChannelID,QNV_GENERAL_STARTRING,0,"");//给内线模拟震铃
				
				QNV_Event(m_uSwitchChannelID,QNV_EVENT_REGWND,(DWORD)GetSafeHwnd(),NULL,NULL,0);//把内线通道的事件发送到该窗口

				m_lConfID=QNV_Conference(m_uChannelID,0,QNV_CONFERENCE_CREATE,0,NULL);//创建新会议
				QNV_Conference(m_uSwitchChannelID,m_lConfID,QNV_CONFERENCE_ADDTOCONF,0,NULL);//把内线通道加入到该会议中实现软交换

				QNV_Conference(m_uChannelID,m_lConfID,QNV_CONFERENCE_SETMICVOLUME,500,NULL);//默认linein的音量不够大,设置linein录音音量放大5倍

				m_strStatus.Format("通道%d:给内线通道%d模拟震铃...",m_uChannelID+1,m_uSwitchChannelID+1);
				SendCBMsg(SS_APPENDSTATUS,(LPARAM)(char*)(LPCTSTR)m_strStatus);
			}else
			{
				m_strStatus.Format("通道%d:获取空闲内线通道失败...",m_uChannelID+1);
				SendCBMsg(SS_APPENDSTATUS,(LPARAM)(char*)(LPCTSTR)m_strStatus);
			}
		}break;
	default:break;
	}
	return 0;
}

long	CSwitchChannel::End()
{
	StopPlayFile();
	QNV_General(m_uSwitchChannelID,QNV_GENERAL_STOPRING,0,NULL);
	QNV_SetDevCtrl(m_uChannelID,QNV_CTRL_DOHOOK,0);
	QNV_Event(m_uSwitchChannelID,QNV_EVENT_UNREGWND,(DWORD)GetSafeHwnd(),NULL,NULL,0);//取消内线通道的事件发送到该窗口
	QNV_Conference(0,m_lConfID,QNV_CONFERENCE_DELETECONF,0,NULL);//删除会议
	m_lConfID = -1;
	QNV_General(m_uSwitchChannelID,QNV_GENERAL_SETUSERVALUE,CH_STATUS_NULL,"");//设置内线通道为空闲
	m_strCallID.Empty();
	return 0;
}

LRESULT CSwitchChannel::WindowProc(UINT msg, WPARAM wParam, LPARAM lParam)
{
	if(msg == BRI_EVENT_MESSAGE)
	{
		PBRI_EVENT pEvent=(PBRI_EVENT)lParam;
		switch(pEvent->lEventType)
		{
		case BriEvent_CallIn:
			{
				if(pEvent->lResult == 2 && pEvent->szData[0] == RING_END_SIGN_CH)//2声响铃结束,表示没有接收到号码
				{
					ProcessCallInID("");
				}
			}break;
		case BriEvent_GetCallID:
			{
				ProcessCallInID(pEvent->szData);
			}break;
		case BriEvent_PhoneHook:
			{
				QNV_General(pEvent->uChannelID,QNV_GENERAL_STOPRING,0,NULL);
				StopPlayFile();
			}break;
		case BriEvent_PhoneHang:
			{
				End();
			}break;
		case BriEvent_DialEnd:break;
		case BriEvent_PlayFileEnd:break;
		case BriEvent_RepeatPlayFile:
			{
				if(m_lSwitchStatus == SS_PLAYTOOLTIP && pEvent->lResult == 3)
				{//循环播放提示音超时

				}
			}break;
		case BriEvent_Silence:break;
		case BriEvent_GetDTMFChar:
			{
				if(m_lSwitchStatus == SS_PLAYTOOLTIP)
				{
					ProcessGetDTMF(pEvent->szData[0]);
				}
			}break;
		case BriEvent_RemoteHook:break;
		case BriEvent_RemoteHang:case BriEvent_Busy:
			{//对方挂机,结束
				End();
			}break;
		case BriEvent_RingBack:break;
		case BriEvent_PSTNFree:break;
		case BriEvent_RingTimeOut://内线震铃超时
			{
				End();
			}break;
		default:break;
		}
		return  TRUE;
	}
	return CBriWnd::WindowProc(msg,wParam,lParam);
}


long	CSwitchChannel::StartSwitch()
{
	Create();
	m_cbdata.uchannelid = m_uChannelID;
	if(!(QNV_DevInfo(m_uChannelID,QNV_DEVINFO_GETMODULE)&DEVMODULE_HOOK))//设备具有软摘机接听来电功能
	{
		return 0;
	}else
	{
		QNV_Event(m_uChannelID,QNV_EVENT_REGWND,(DWORD)GetSafeHwnd(),NULL,NULL,0);
		QNV_SetDevCtrl(m_uChannelID,QNV_CTRL_DOPHONE,0);//跟默认LINE口的PSTN线路断开,是来电时没有默认话机会震铃
		return 1;
	}
}

long	CSwitchChannel::StopSwitch()
{
	return 0;
}

void	CSwitchChannel::FreeSource()
{
	return;
}
