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
	case 0:return "��ȡ���ݴ���";
	case 1:return "д�����ݴ���";
	case 2:return "����֡ID��ʧ,������CPU̫æ";
	case 3:return "�豸�Ѿ����ε�";
	case 4:return "���кų�ͻ";
	default:return "δ֪����";
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
		case BriEvent_PhoneHook:str.Format("ͨ��%d: �绰��ժ�� %s",m_uChannelID+1,strValue);break;
		case BriEvent_PhoneHang:str.Format("ͨ��%d: �绰���һ� %s",m_uChannelID+1,strValue);break;
		case BriEvent_DialEnd:
			{
				str.Format("ͨ��%d: ���Ž��� %s",m_uChannelID+1,strValue);
				//��ѭ��������ʾ��
				StartPlayTooltip();
				//
			}break;
		case BriEvent_PlayFileEnd:
			{
				str.Format("ͨ��%d: �����ļ����� %s",m_uChannelID+1,strValue);
			}break;
		case BriEvent_RepeatPlayFile:str.Format("ͨ��%d: ѭ�������ļ� %s",m_uChannelID+1,strValue);break;
		case BriEvent_Silence:str.Format("ͨ��%d: ͨ����һ��ʱ��ľ��� %s",m_uChannelID+1,strValue);break;
		case BriEvent_GetDTMFChar:
			{
				str.Format("ͨ��%d: ���յ����� %s",m_uChannelID+1,strValue);
				if(m_lDialStatus == DCT_TOOLTIP && pEvent->szData[0] == '1')
				{
					StartPlayData();
				}
			}break;
		case BriEvent_RemoteHook:str.Format("ͨ��%d: Զ��ժ�� %s",m_uChannelID+1,strValue);break;
		case BriEvent_RemoteHang:case BriEvent_Busy:
			{
				if(m_lDialStatus >= DCT_PLAYDATA) 	SendCBMsg(DC_DIAL_FINISH,(LPARAM)&m_cbdata);
				else SendCBMsg(DC_DIAL_NOTTALK,(LPARAM)&m_cbdata);
				if(pEvent->lEventType ==BriEvent_RemoteHang) str.Format("ͨ��%d: Զ�̹һ� %s",m_uChannelID+1,strValue);
				else if(pEvent->lEventType ==BriEvent_Busy)str.Format("ͨ��%d: ���յ�æ��,��·�Ѿ��Ͽ� %s",m_uChannelID+1,strValue);
				QNV_SetDevCtrl(m_uChannelID,QNV_CTRL_DOHOOK,FALSE);//�һ�
				Sleep(2000);//�ȴ���·�ͷţ����ⱻʶ����Ĳ��
				StartDialOut();
			}break;
		case BriEvent_RingBack:str.Format("ͨ��%d: ���ź���յ������� %s",m_uChannelID+1,strValue);break;
		case BriEvent_PSTNFree:str.Format("ͨ��%d: PSTN��·�ѿ��� %s",m_uChannelID+1,strValue);break;	
		case BriEvent_DevErr:str.Format("ͨ��%d: �豸��������ԭ��=%s(%d/%d) %s",m_uChannelID+1,GetDevErrStr(pEvent->lResult),(atol(pEvent->szData)&0xFF00)>>8,(atol(pEvent->szData)&0xFF),strValue);break;
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
	DWORD dwMask=PLAYFILE_MASK_REPEAT;//ѭ������
	m_lPlayFileHandle = QNV_PlayFile(m_uChannelID,QNV_PLAY_FILE_START,0,dwMask,(char*)(LPCTSTR)strPath);
	if(m_lPlayFileHandle <= 0)
	{		
		str.Format("����ʧ�� errid=%d file=%s",m_lPlayFileHandle,strPath);	
		AppendStatus(str);
		return 0;
	}else
	{
		str.Format("��ʼ���� file=%s",strPath);	
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
	DWORD dwMask=PLAYFILE_MASK_REPEAT;//ѭ������
	m_lPlayFileHandle = QNV_PlayFile(m_uChannelID,QNV_PLAY_FILE_START,0,dwMask,(char*)(LPCTSTR)strPath);
	if(m_lPlayFileHandle <= 0)
	{		
		str.Format("����ʧ�� errid=%d file=%s",m_lPlayFileHandle,strPath);	
		AppendStatus(str);
		return 0;
	}else
	{
		str.Format("��ʼ���� file=%s",strPath);	
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
	if(!(QNV_DevInfo(m_uChannelID,QNV_DEVINFO_GETMODULE)&DEVMODULE_HOOK))//�豸������ժ���ſ���Ⱥ��
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
		QNV_SetDevCtrl(m_uChannelID,QNV_CTRL_PLAYTOLINE,TRUE);//�Զ��򿪲���������LINE
		QNV_SetDevCtrl(m_uChannelID,QNV_CTRL_LINEOUT,TRUE);//�Զ�����·���뿪��,������������������أ��Ͳ�����������
		QNV_General(m_uChannelID,QNV_GENERAL_STARTDIAL,0,m_cbdata.szData);
		m_lDialStatus = DCT_DIAL;
		AppendStatus((CString)"��ʼ���ţ�"+m_cbdata.szData);
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