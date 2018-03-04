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
	if(m_lPlayFileHandle <= 0) AfxMessageBox("���ű�����ʧ��");
	m_lSwitchStatus=SS_BACKGROUP;
	m_strStatus.Format("ͨ��%d:��ʼ���ű�����...",m_uChannelID+1);
	SendCBMsg(SS_APPENDSTATUS,(LPARAM)(char*)(LPCTSTR)m_strStatus);
	return 0;
}

long	CSwitchChannel::ProcessCallInID(char *szCallID)
{	
	m_strCallID=szCallID;
	m_strStatus.Format("ͨ��%d:׼������...",m_uChannelID+1);
	SendCBMsg(SS_APPENDSTATUS,(LPARAM)(char*)(LPCTSTR)m_strStatus);
	StopPlayFile();
	//ժ������
	QNV_SetDevCtrl(m_uChannelID,QNV_CTRL_DOHOOK,1);
	//������ʾ��
	//PLAYFILE_MASK_REPEAT->ѭ������
	m_lPlayFileHandle=QNV_PlayFile(m_uChannelID,QNV_PLAY_FILE_START,0,PLAYFILE_MASK_REPEAT,PLAY_TOOLTIP_PATH);
	if(m_lPlayFileHandle <= 0)
	{
		AfxMessageBox("������ʾ��ʧ��");
	}
	//
	m_lSwitchStatus = SS_PLAYTOOLTIP;
	m_strStatus.Format("ͨ��%d:��ʼ������ʾ��...",m_uChannelID+1);
	SendCBMsg(SS_APPENDSTATUS,(LPARAM)(char*)(LPCTSTR)m_strStatus);
	return 1;
}

BRIINT16	CSwitchChannel::GetFreeChannel()//����һ�����е�����ͨ��
{
	for(BRIINT16 i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{
		if(QNV_General(i,QNV_GENERAL_GETUSERVALUE,0,"") != CH_STATUS_BUSY
			&& QNV_DevInfo(i,QNV_DEVINFO_GETCHANNELTYPE) == CHANNELTYPE_PHONE
			&& QNV_GetDevCtrl(i,QNV_CTRL_PHONE)<= 0)//�ӻ��������ܽ����ߵ�ͨ��
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
			m_uSwitchChannelID=GetFreeChannel();//Ѱ��һ�����е�����ͨ��
			if(m_uSwitchChannelID >= 0)
			{
				QNV_General(m_uSwitchChannelID,QNV_GENERAL_SETUSERVALUE,CH_STATUS_BUSY,"");//��������ͨ��Ϊæ
				StartPlayBackgroup();//��������·����ת�˹��ı�����				
				QNV_SetDevCtrl(m_uSwitchChannelID,QNV_CTRL_DOPHONE,0);//ǿ�ƶϿ�Ĭ������
				QNV_SetParam(m_uSwitchChannelID,QNV_PARAM_RINGCALLIDTYPE,/*DIALTYPE_FSK*/DIALTYPE_DTMF);//�������뷽ʽΪһ����FSKģʽ,Ĭ��Ϊһ��ǰdtmfģʽ
				QNV_General(m_uSwitchChannelID,QNV_GENERAL_STARTRING,0,"");//������ģ������
				
				QNV_Event(m_uSwitchChannelID,QNV_EVENT_REGWND,(DWORD)GetSafeHwnd(),NULL,NULL,0);//������ͨ�����¼����͵��ô���

				m_lConfID=QNV_Conference(m_uChannelID,0,QNV_CONFERENCE_CREATE,0,NULL);//�����»���
				QNV_Conference(m_uSwitchChannelID,m_lConfID,QNV_CONFERENCE_ADDTOCONF,0,NULL);//������ͨ�����뵽�û�����ʵ������

				QNV_Conference(m_uChannelID,m_lConfID,QNV_CONFERENCE_SETMICVOLUME,500,NULL);//Ĭ��linein������������,����linein¼�������Ŵ�5��

				m_strStatus.Format("ͨ��%d:������ͨ��%dģ������...",m_uChannelID+1,m_uSwitchChannelID+1);
				SendCBMsg(SS_APPENDSTATUS,(LPARAM)(char*)(LPCTSTR)m_strStatus);
			}else
			{
				m_strStatus.Format("ͨ��%d:��ȡ��������ͨ��ʧ��...",m_uChannelID+1);
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
	QNV_Event(m_uSwitchChannelID,QNV_EVENT_UNREGWND,(DWORD)GetSafeHwnd(),NULL,NULL,0);//ȡ������ͨ�����¼����͵��ô���
	QNV_Conference(0,m_lConfID,QNV_CONFERENCE_DELETECONF,0,NULL);//ɾ������
	m_lConfID = -1;
	QNV_General(m_uSwitchChannelID,QNV_GENERAL_SETUSERVALUE,CH_STATUS_NULL,"");//��������ͨ��Ϊ����
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
				if(pEvent->lResult == 2 && pEvent->szData[0] == RING_END_SIGN_CH)//2���������,��ʾû�н��յ�����
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
				{//ѭ��������ʾ����ʱ

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
			{//�Է��һ�,����
				End();
			}break;
		case BriEvent_RingBack:break;
		case BriEvent_PSTNFree:break;
		case BriEvent_RingTimeOut://�������峬ʱ
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
	if(!(QNV_DevInfo(m_uChannelID,QNV_DEVINFO_GETMODULE)&DEVMODULE_HOOK))//�豸������ժ���������繦��
	{
		return 0;
	}else
	{
		QNV_Event(m_uChannelID,QNV_EVENT_REGWND,(DWORD)GetSafeHwnd(),NULL,NULL,0);
		QNV_SetDevCtrl(m_uChannelID,QNV_CTRL_DOPHONE,0);//��Ĭ��LINE�ڵ�PSTN��·�Ͽ�,������ʱû��Ĭ�ϻ���������
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
