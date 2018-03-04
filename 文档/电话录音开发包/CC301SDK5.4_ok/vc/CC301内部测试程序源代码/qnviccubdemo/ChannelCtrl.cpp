// ChannelCtrl.cpp : implementation file
//

#include "stdafx.h"
#include "qnviccubdemo.h"
#include "ChannelCtrl.h"
#include "MediaPlay.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CChannelCtrl dialog


CChannelCtrl::CChannelCtrl(CWnd* pParent /*=NULL*/)
	: CDialog(CChannelCtrl::IDD, pParent)
{
	//{{AFX_DATA_INIT(CChannelCtrl)
	m_strCode = _T("");
	//}}AFX_DATA_INIT
	m_lPlayFileHandle = -1;
	m_lRecFileHandle = -1;
	m_nChannelID = -1;
	m_lPlayStringHandle= -1;
	m_pWaveView =NULL;
	m_nEventTimer=NULL;
}


void CChannelCtrl::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CChannelCtrl)
	DDX_Control(pDX, IDC_ADFUNC, m_cAdfunc);
	DDX_Control(pDX, IDC_PLAYREMOTE, m_cPlayRemote);
	DDX_Control(pDX, IDC_BUFAM, m_cBufAM);
	DDX_Control(pDX, IDC_STOPPLAYFILE, m_cStopPlayFile);
	DDX_Control(pDX, IDC_STARTPLAYFILE, m_cStartPlayFile);
	DDX_Control(pDX, IDC_STARTRECFILE, m_cStartRecFile);
	DDX_Control(pDX, IDC_STOPRECFILE, m_cStopRecFile);
	DDX_Control(pDX, IDC_STARTBUFREC, m_cStartRecBuf);
	DDX_Control(pDX, IDC_STOPRECBUF, m_cStopRecBuf);
	DDX_Control(pDX, IDC_VIEWBUF, m_cViewBuf);
	DDX_Control(pDX, IDC_SELECTLINE, m_cSelectLine);
	DDX_Control(pDX, IDC_LINEINAM, m_cLineInAM);
	DDX_Control(pDX, IDC_SPKAM, m_cSpkAM);
	DDX_Control(pDX, IDC_MICAM, m_cMicAM);
	DDX_Control(pDX, IDC_COMLINE3X, m_cLine3x);
	DDX_Control(pDX, IDC_ADCIN, m_cADCIn);
	DDX_Text(pDX, IDC_DIALCODE, m_strCode);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CChannelCtrl, CDialog)
	//{{AFX_MSG_MAP(CChannelCtrl)	
	ON_BN_CLICKED(IDC_STOPPLAYFILE, OnStopplayfile)
	ON_BN_CLICKED(IDC_ENABLEHOOK, OnEnablehook)
	ON_BN_CLICKED(IDC_ENABLEMIC, OnEnablemic)
	ON_BN_CLICKED(IDC_DISABLERING, OnDisablering)
	ON_BN_CLICKED(IDC_ENABLELINE2SPK, OnEnablespk)
	ON_BN_CLICKED(IDC_STARTRECFILE, OnStartrecfile)
	ON_BN_CLICKED(IDC_STOPRECFILE, OnStoprecfile)
	ON_BN_CLICKED(IDC_STARTDIAL, OnStartdial)
	ON_BN_CLICKED(IDC_STOPDIAL, OnStopdial)
	ON_BN_CLICKED(IDC_MEDIAPLAY, OnMediaplay)
	ON_BN_CLICKED(IDC_ENABLEPLAY2SPK, OnEnableplay2spk)
	ON_BN_CLICKED(IDC_DOPLAY, OnDoplay)
	ON_BN_CLICKED(IDC_STARTMULTIPLAY, OnStartmultiplay)
	ON_BN_CLICKED(IDC_STOPMULTIPLAY, OnStopmultiplay)
	ON_BN_CLICKED(IDC_INITTTSLIST, OnInitttslist)
	ON_BN_CLICKED(IDC_PLAY2LINE, OnPlay2line)
	ON_CBN_SELCHANGE(IDC_SELECTLINE, OnSelchangeSelectline)
	ON_CBN_SELCHANGE(IDC_MICAM, OnSelchangeMicam)
	ON_CBN_SELCHANGE(IDC_SPKAM, OnSelchangeSpkam)
	ON_CBN_SELCHANGE(IDC_LINEINAM, OnSelchangeLineinam)
	ON_CBN_SELCHANGE(IDC_COMLINE3X, OnSelchangeComline3x)
	ON_CBN_SELCHANGE(IDC_ADCIN, OnSelchangeAdcin)
	ON_BN_CLICKED(IDC_RINGPOWER, OnRingpower)
	ON_BN_CLICKED(IDC_STARTBUFREC, OnStartbufrec)
	ON_BN_CLICKED(IDC_STOPRECBUF, OnStoprecbuf)
	ON_BN_CLICKED(IDC_VIEWBUF, OnViewbuf)
	ON_BN_CLICKED(IDC_STARTPLAYFILE, OnStartplayfile)
	ON_BN_CLICKED(IDC_STARTPLAYBUF, OnStartplaybuf)
	ON_BN_CLICKED(IDC_FAXMODULE, OnFaxmodule)
	ON_BN_CLICKED(IDC_STARTRING, OnStartring)
	ON_BN_CLICKED(IDC_REFUSE, OnRefuse)
	ON_BN_CLICKED(IDC_FLASH, OnFlash)
	ON_BN_CLICKED(IDC_PLAYTTS, OnPlaytts)
	ON_BN_CLICKED(IDC_STOPPLAYTTS, OnStopplaytts)
	ON_BN_CLICKED(IDC_SPEECH, OnSpeech)
	ON_BN_CLICKED(IDC_BUFECHOED, OnBufechoed)
	ON_BN_CLICKED(IDC_PAUSE, OnPause)
	ON_BN_CLICKED(IDC_RESUME, OnResume)
	ON_BN_CLICKED(IDC_LINEOUT, OnLineout)	
	ON_BN_CLICKED(IDC_DISABLEECHO, OnDisableecho)
	ON_BN_CLICKED(IDC_LED, OnLed)
	ON_BN_CLICKED(IDC_WATCHDOG, OnWatchdog)
	ON_BN_CLICKED(IDC_24V, On24v)
	ON_CBN_SELCHANGE(IDC_DOPLAYMUX, OnSelchangeDoplaymux)
	ON_CBN_SELCHANGE(IDC_DOPLAYAM, OnSelchangeDoplayam)
	ON_BN_CLICKED(IDC_DISABLEUPLOAD, OnDisableupload)
	ON_BN_CLICKED(IDC_DISABLEDOWNLOAD, OnDisabldownload)
	ON_BN_CLICKED(IDC_SAVEPARAM, OnSaveparam)
	ON_BN_CLICKED(IDC_READPARAM, OnReadparam)
	ON_WM_TIMER()
	ON_BN_CLICKED(IDC_PLAYREMOTE, OnPlayremote)
	ON_BN_CLICKED(IDC_RECVFSK, OnRecvfsk)
	ON_BN_CLICKED(IDC_RECVDTMF, OnRecvdtmf)
	ON_BN_CLICKED(IDC_RECVSIGN, OnRecvsign)
	ON_BN_CLICKED(IDC_RECVCALLIN, OnCallin)
	ON_BN_CLICKED(IDC_SENDDTMF, OnSenddtmf)
	ON_BN_CLICKED(IDC_SENDFSK, OnSendfsk)
	ON_BN_CLICKED(IDC_ADFUNC, OnAdfunc)
	ON_BN_CLICKED(IDC_EXCLUSIVE, OnExclusive)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CChannelCtrl message handlers


BOOL CChannelCtrl::OnInitDialog() 
{
	CDialog::OnInitDialog();	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

CString CChannelCtrl::GetModulePath()
{
	char szSourcePath[_MAX_PATH];
	GetModuleFileName(NULL, szSourcePath, _MAX_PATH); 
    *(strrchr(szSourcePath, '\\') + 1) = '\0';          
	CString RetStr=szSourcePath;
	return RetStr;
}

void	CChannelCtrl::FreeSource()
{	
	//�������в���
	/*
	CString strIniPath;
	strIniPath.Format("%s%s%d.ini",GetModulePath(),"qnvini\\param_",m_nChannelID+1);
	if(QNV_General(m_nChannelID,QNV_GENERAL_WRITEPARAM,0,(char*)(LPCTSTR)strIniPath) <= 0)
	{
		AfxMessageBox("�������ʧ��");
	}
	*/
	OnStoprecbuf();
	if(m_nEventTimer)
	{
		KillTimer(m_nEventTimer);
		m_nEventTimer=NULL;
	}
	QNV_Event(m_nChannelID,QNV_EVENT_UNREGWND,(DWORD)m_hWnd,NULL,NULL,0);
	CloseWaveView();
}

void	CChannelCtrl::InitChannelParam()
{
	//QNV_SetParam(m_nChannelID,QNV_PARAM_AM_LINEOUT,15);	

	m_cADCIn.SetCurSel(QNV_GetDevCtrl(m_nChannelID,QNV_CTRL_SELECTADCIN));
	m_cLine3x.SetCurSel(QNV_GetParam(m_nChannelID,QNV_PARAM_AM_LINEOUT));
	m_cMicAM.SetCurSel(QNV_GetParam(m_nChannelID,QNV_PARAM_AM_MIC));
	m_cSpkAM.SetCurSel(QNV_GetParam(m_nChannelID,QNV_PARAM_AM_SPKOUT));	
	m_cLineInAM.SetCurSel(QNV_GetParam(m_nChannelID,QNV_PARAM_AM_LINEIN));
	m_cSelectLine.SetCurSel(QNV_GetDevCtrl(m_nChannelID,QNV_CTRL_SELECTLINEIN));
	
	((CButton*)GetDlgItem(IDC_LINEOUT))->SetCheck(QNV_GetDevCtrl(m_nChannelID,QNV_CTRL_LINEOUT));

	((CButton*)GetDlgItem(IDC_PLAY2LINE))->SetCheck(QNV_GetDevCtrl(m_nChannelID,QNV_CTRL_PLAYTOLINE));

	((CComboBox*)GetDlgItem(IDC_DOPLAYMUX))->SetCurSel(QNV_GetDevCtrl(m_nChannelID,QNV_CTRL_PLAYMUX));	
	((CComboBox*)GetDlgItem(IDC_DOPLAYAM))->SetCurSel(QNV_GetParam(m_nChannelID,QNV_PARAM_AM_DOPLAY));	
	((CButton*)GetDlgItem(IDC_WATCHDOG))->SetCheck(QNV_GetDevCtrl(m_nChannelID,QNV_CTRL_WATCHDOG));

	((CButton*)GetDlgItem(IDC_DISABLEECHO))->SetCheck(QNV_GetDevCtrl(m_nChannelID,QNV_CTRL_ECHO)==0);

	((CComboBox*)GetDlgItem(IDC_COMRECFORMAT))->SetCurSel(0);

	((CButton*)GetDlgItem(IDC_RECVFSK))->SetCheck(QNV_GetDevCtrl(m_nChannelID,QNV_CTRL_RECVFSK));	
	((CButton*)GetDlgItem(IDC_RECVDTMF))->SetCheck(QNV_GetDevCtrl(m_nChannelID,QNV_CTRL_RECVDTMF));	
	((CButton*)GetDlgItem(IDC_RECVSIGN))->SetCheck(QNV_GetDevCtrl(m_nChannelID,QNV_CTRL_RECVSIGN));	
	((CButton*)GetDlgItem(IDC_RECVCALLIN))->SetCheck(QNV_GetDevCtrl(m_nChannelID,QNV_CTRL_RECVCALLIN));	
	((CButton*)GetDlgItem(IDC_EXCLUSIVE))->SetCheck(1);
}

void CALLBACK CChannelCtrl::TimerProc(HWND hwnd, UINT uMsg, UINT idEvent, DWORD dwTime )
{

}

void	CChannelCtrl::SetChannelCtrlID(BRIINT16 nChannelID)
{
	m_nChannelID = nChannelID;
	CString str;
	str.Format("ͨ��ID=%d",nChannelID+1);
	GetDlgItem(IDC_STID)->SetWindowText(str);
	//3����ʽѡ������һ���Ϳ���
	//m_nEventTimer= SetTimer(0x20,200,NULL);//ʹ�ö�ʱ����ʽ��ȡ�¼�
	//m_nEventTimer= SetTimer(0x20,200,TimerProc);//ʹ�ö�ʱ����ʽ��ȡ�¼�
	//QNV_Event(m_nChannelID,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);//ʹ�ô�����Ϣ��ʽ��ȡ�¼�	
	QNV_Event(m_nChannelID,QNV_EVENT_REGCBFUNC,(DWORD)this,(char*)ProcEventCallback,NULL,0);//ʹ�ûص�������ʽ
	
	//CString strIniPath;
	//strIniPath.Format("%s%s%d.ini",GetModulePath(),"qnvini\\param_",m_nChannelID+1);
	//QNV_General(m_nChannelID,QNV_GENERAL_READPARAM,0,(char*)(LPCTSTR)strIniPath);
	InitChannelParam();
	QNV_SetParam(m_nChannelID,QNV_PARAM_DTMFVOL,5);//1500���ȵ�DTMFΪ7,�������õ�5������ͷ��ȵ�DTMF
	::SendMessage(GetParent()->GetSafeHwnd(),QNV_CHANNEL_MESSAGE,CB_APPENDSTATUS,(LPARAM)(LPCTSTR)"��ʼ�첽�����·״̬");
	QNV_General(m_nChannelID,QNV_GENERAL_CHECKLINESTATE,0,0);//�첽�����·״̬,ϵͳ����յ�BriEvent_CheckLine��Ϣ

	OnStartbufrec();//Ĭ����������¼��
}

void CChannelCtrl::OnStopplayfile() 
{
	if(m_lPlayFileHandle > 0)
	{
		QNV_PlayFile(m_nChannelID,QNV_PLAY_FILE_STOP,m_lPlayFileHandle,0,NULL);
		m_lPlayFileHandle= -1;
		::SendMessage(GetParent()->GetSafeHwnd(),QNV_CHANNEL_MESSAGE,CB_APPENDSTATUS,(LPARAM)(LPCTSTR)"ֹͣ�����ļ�");
	}
	m_cStartPlayFile.EnableWindow(TRUE);
	m_cPlayRemote.EnableWindow(TRUE);
	m_cStopPlayFile.EnableWindow(FALSE);
}

void CChannelCtrl::OnEnablehook() 
{
	if(!(QNV_DevInfo(m_nChannelID,QNV_DEVINFO_GETMODULE)&DEVMODULE_CALLID))
	{		
		AfxMessageBox("��ͨ�����ܽ�������,����ժ��");
		return;
	}
	if(!(QNV_DevInfo(m_nChannelID,QNV_DEVINFO_GETMODULE)&DEVMODULE_HOOK))
	{
		((CButton*)GetDlgItem(IDC_ENABLEHOOK))->SetCheck(0);
		AfxMessageBox("��ͨ����֧����ժ��,��ʹ��֧����ժ����������");
		return;
	}
	if(QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_DOHOOK,((CButton*)GetDlgItem(IDC_ENABLEHOOK))->GetCheck()) <= 0)
	{
		CString str;
		str.Format("����ʧ�� id=%d",QNV_GetLastError());
		AfxMessageBox(str);
	}
}

void CChannelCtrl::OnEnablemic() 
{
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_DOMICTOLINE,((CButton*)GetDlgItem(IDC_ENABLEMIC))->GetCheck());	
}

void CChannelCtrl::OnDisablering() 
{	
	if(QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_DOPHONE,!((CButton*)GetDlgItem(IDC_DISABLERING))->GetCheck()) <= 0
		&& ((CButton*)GetDlgItem(IDC_DISABLERING))->GetCheck() )
	{
		((CButton*)GetDlgItem(IDC_DISABLERING))->SetCheck(FALSE);
		AfxMessageBox("�Ͽ�ʧ��,�������豸��֧�ָù���");
	}else
	{
		if(QNV_General(AUDRV_CHANNELID,QNV_GENERAL_CHECKCHANNELID,0,NULL) > 0)
		{
			long lchipid=QNV_DevInfo(m_nChannelID,QNV_DEVINFO_GETCHIPCHID);//��ȡ��ͨ�����ڵ�оƬID						
			long llinechid=QNV_DevInfo(m_nChannelID,QNV_DEVINFO_GETCHIPCHANNEL);//lineͨ������ID			
			long lphonechid=QNV_DevInfo(m_nChannelID,QNV_DEVINFO_GETCHIPCHANNELS);//phoneͨ������ID
			if(((CButton*)GetDlgItem(IDC_DISABLERING))->GetCheck())
			{//������������/¼��ͨ�����Ӹ�оƬ��LINEͨ���л���PHONEͨ��
				//�������𻰻��Ϳ��������������ŵ��������ӻ���˵������������������
				//���lineͨ��ʹ��255,�Ǳ�ʾ���е�ǰ��������ͨ�����л�����ͨ��
				long lValue=(llinechid<<16)|lphonechid;
				QNV_Audrv(QNV_AUDRV_SWITCHWAVEOUTID,lValue,NULL,NULL,0);
				QNV_Audrv(QNV_AUDRV_SWITCHWAVEINID,lValue,NULL,NULL,0);
				::SendMessage(GetParent()->GetSafeHwnd(),QNV_CHANNEL_MESSAGE,CB_APPENDSTATUS,(LPARAM)(LPCTSTR)"�������������������𻰻�����������ICC301�����������ŵ�����");
			}else
			{//������������/¼��ͨ�����Ӹ�оƬ��PHONEͨ���л���LINEͨ��
				//���lineͨ��ʹ��255,�Ǳ�ʾ���е�ǰ��������ͨ�����л�����ͨ��
				long lValue=(lphonechid<<16)|llinechid;
				QNV_Audrv(QNV_AUDRV_SWITCHWAVEOUTID,lValue,NULL,NULL,0);
				QNV_Audrv(QNV_AUDRV_SWITCHWAVEINID,lValue,NULL,NULL,0);				
			}
		}
	}
}

void CChannelCtrl::OnEnablespk() 
{
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_DOLINETOSPK,((CButton*)GetDlgItem(IDC_ENABLELINE2SPK))->GetCheck());	
}

CString		CChannelCtrl::GetDevErrStr(long lResult)
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

long CChannelCtrl::WriteCallLog(USHORT uChannelID)
{
	long lBeginTime=QNV_CallLog(uChannelID,QNV_CALLLOG_BEGINTIME,NULL,0);
	long lEndTime=QNV_CallLog(uChannelID,QNV_CALLLOG_ENDTIME,NULL,0);
	long lSerial=QNV_DevInfo(uChannelID,QNV_DEVINFO_GETSERIAL);
	long lRingBackTime=QNV_CallLog(uChannelID,QNV_CALLLOG_RINGBACKTIME,NULL,0);
	long lConnectedTime=QNV_CallLog(uChannelID,QNV_CALLLOG_CONNECTEDTIME,NULL,0);
	long lCallType=QNV_CallLog(uChannelID,QNV_CALLLOG_CALLTYPE,NULL,0);
	long lCallResult=QNV_CallLog(uChannelID,QNV_CALLLOG_CALLRESULT,NULL,0);
	char szCallID[MAX_BRIEVENT_DATA]={0};
	char szFilePath[_MAX_PATH]={0};
	long lRet=QNV_CallLog(uChannelID,QNV_CALLLOG_CALLID,szCallID,MAX_BRIEVENT_DATA);
	CTime bt(lBeginTime);
	CTime et(lEndTime);	
	CString str;
	str.Format("���м�¼,����:%s ��ʼʱ��:%04d/%02d/%02d %02d:%02d:%02d ����ʱ��:%04d/%02d/%02d %02d:%02d:%02d",szCallID,bt.GetYear(),bt.GetMonth(),bt.GetDay(),bt.GetHour(),bt.GetMinute(),bt.GetSecond(),et.GetYear(),et.GetMonth(),et.GetDay(),et.GetHour(),et.GetMinute(),et.GetSecond());
	//ͬʱֻ��һ��¼��������ֱ�ӻ�ȡ,�����Ϊ���һ���ļ�¼��·��
	lRet=QNV_CallLog(uChannelID,QNV_CALLLOG_CALLRECFILE,szFilePath,_MAX_PATH);	
	::SendMessage(GetParent()->GetSafeHwnd(),QNV_CHANNEL_MESSAGE,CB_APPENDSTATUS,(LPARAM)(LPCTSTR)str);	
	/*
	if(strlen(szFilePath) > 0)
	{
		lRet=QNV_CallLog(uChannelID,QNV_CALLLOG_DELRECFILE,NULL,0);	
		if(lRet <= 0)
		{
			str.Format("ɾ��ʧ��,��ȷ���Ѿ�ֹͣ¼�� err=%d",lRet);
			AfxMessageBox(str);
		}
	}
	*/
	//������λ����״̬
	QNV_CallLog(uChannelID,QNV_CALLLOG_RESET,0,0);
	return 0;
}

long	CChannelCtrl::ProcessEvent(PBRI_EVENT pEvent)
{
//		int iRet=QNV_Event(0,2,0,"","",0);
		CString str,strValue;
		strValue.Format("Handle=%d Result=%d Data=%s",pEvent->lEventHandle,pEvent->lResult,pEvent->szData);
		switch(pEvent->lEventType)
		{
		case BriEvent_PhoneHook:
			{//�绰��ͨ����ݶԷ��迹��С�����������С,200��̫���м����200��̫��,һ��绰��100����
				/*
				QNV_SetParam(pEvent->uChannelID,QNV_PARAM_DTMFVOL,50);
				QNV_SetParam(pEvent->uChannelID,QNV_PARAM_DTMFLEVEL,4);
				QNV_SetParam(pEvent->uChannelID,QNV_PARAM_DTMFNUM,9);
				QNV_SetParam(pEvent->uChannelID,QNV_PARAM_DTMFLOWINHIGH,20);
				QNV_SetParam(pEvent->uChannelID,QNV_PARAM_DTMFHIGHINLOW,20);
				*/
				//str.Format("ͨ��%d: �绰��ժ��,��ʾ�޸ļ��DTMF������,DTMFVOL=50/DTMFLEVEL=5/DTMFNUM=10,�����ⲻ���绰�����ž��޸ĸ�ֵ��С",m_nChannelID+1);
				if(QNV_General(pEvent->uChannelID,QNV_GENERAL_ISDIALING,0,NULL) <= 0)
				{
					//QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_DOHOOK,0);//û�����ڲ��ſ��Կ����Զ���һ�,����3��ͨ��״̬���������б���������
				}
				str.Format("ͨ��%d: �绰��ժ��",m_nChannelID+1);
			}break;
		case BriEvent_PhoneHang:
			{
			//	QNV_SetParam(pEvent->uChannelID,QNV_PARAM_DTMFVOL,5);
			//	QNV_SetParam(pEvent->uChannelID,QNV_PARAM_DTMFLEVEL,3);
			//	QNV_SetParam(pEvent->uChannelID,QNV_PARAM_DTMFNUM,6);
			//	str.Format("ͨ��%d: �绰���һ�,��ʾ�޸ļ��DTMF������",m_nChannelID+1);
				str.Format("ͨ��%d: �绰���һ�",m_nChannelID+1);
			}break;
		case BriEvent_CallIn:str.Format("ͨ��%d: �������� %s",m_nChannelID+1,strValue);break;
		case BriEvent_GetCallID:
			{
				long lSerial=QNV_DevInfo(m_nChannelID,QNV_DEVINFO_GETSERIAL);
				str.Format("ͨ��%d: ���յ�������� %s",m_nChannelID+1,strValue);
			}break;
		case BriEvent_StopCallIn:str.Format("ͨ��%d: ֹͣ����,����һ��δ�ӵ绰 %s",m_nChannelID+1,strValue);break;
		case BriEvent_DialEnd:
			{
				if(QNV_GetDevCtrl(pEvent->uChannelID,QNV_CTRL_PHONE) > 0)
				{
					//QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_DOHOOK,0);//�绰���Ѿ����ſ��Կ����Զ���һ�,����3��ͨ��״̬���������б���������
				}
				str.Format("ͨ��%d: ���Ž��� %s",m_nChannelID+1,strValue);
			}break;
		case BriEvent_PlayFileEnd:str.Format("ͨ��%d: �����ļ����� %s",m_nChannelID+1,strValue);break;
		case BriEvent_PlayMultiFileEnd:str.Format("ͨ��%d: ���ļ��������� %s",m_nChannelID+1,strValue);break;
		case BriEvent_RepeatPlayFile:str.Format("ͨ��%d: ѭ�������ļ� %s",m_nChannelID+1,strValue);break;
		case BriEvent_PlayStringEnd:str.Format("ͨ��%d: �����ַ����� %s",m_nChannelID+1,strValue);break;
		case BriEvent_SendCallIDEnd:str.Format("ͨ��%d: ����������ʱ���ͺ������ %s",m_nChannelID+1,strValue);break;
		case BriEvent_Silence:str.Format("ͨ��%d: ͨ����һ��ʱ��ľ��� %s",m_nChannelID+1,strValue);break;
		case BriEvent_GetDTMFChar:str.Format("ͨ��%d: ���յ����� %s",m_nChannelID+1,strValue);break;
		case BriEvent_RemoteHook:
			{
				if(HOOK_POLARITY == pEvent->lResult)
				{
					str.Format("ͨ��%d: Զ��ժ��(�������) %s",m_nChannelID+1,strValue);
				}else
					str.Format("ͨ��%d: �ź������Զ��ժ���ź�,�����ο� %s",m_nChannelID+1,strValue);
			}break;
		case BriEvent_RemoteHang:
			{
				if(HOOK_POLARITY == pEvent->lResult)
				{
					str.Format("ͨ��%d: Զ�̹һ�(�������) %s",m_nChannelID+1,strValue);
				}else
				{
					str.Format("ͨ��%d: �ź������Զ�̹һ�(æ�����),�����ο� %s",m_nChannelID+1,strValue);
				}
			}break;
		case BriEvent_Busy:str.Format("ͨ��%d: ���յ�æ��,��·�����Ѿ��Ͽ� %s",m_nChannelID+1,strValue);break;
		case BriEvent_DialTone:str.Format("ͨ��%d: ��⵽������ %s",m_nChannelID+1,strValue);break;
		case BriEvent_DialToneEx:str.Format("ͨ��%d: ��ͨ״̬�¼�⵽�������ź�,����Ǹ�����,�����Ǹղŵ������Ѿ�δ����,�����ο� %s",m_nChannelID+1,strValue);break;
		case BriEvent_PhoneDial:str.Format("ͨ��%d: �绰������ %s",m_nChannelID+1,strValue);break;
		case BriEvent_RingBack:str.Format("ͨ��%d: ���ź���յ������� %s",m_nChannelID+1,strValue);break;
		case BriEvent_MicIn:str.Format("ͨ��%d: ��˷���� %s",m_nChannelID+1,strValue);break;
		case BriEvent_MicOut:str.Format("ͨ��%d: ��˷�γ� %s",m_nChannelID+1,strValue);break;
		case BriEvent_FlashEnd:str.Format("ͨ��%d: �Ĳ����� %s",m_nChannelID+1,strValue);break;
		case BriEvent_RemoteSendFax:str.Format("ͨ��%d: �Է�׼�����ʹ��� %s",m_nChannelID+1,strValue);break;
		case BriEvent_FaxRecvFinished:str.Format("ͨ��%d: ���մ������ %s",m_nChannelID+1,strValue);break;
		case BriEvent_FaxRecvFailed:str.Format("ͨ��%d: ���մ���ʧ�� %s",m_nChannelID+1,strValue);break;
		case BriEvent_FaxSendFinished:str.Format("ͨ��%d: ���ʹ������ %s",m_nChannelID+1,strValue);break;
		case BriEvent_FaxSendFailed:str.Format("ͨ��%d: ���ʹ���ʧ�� %s",m_nChannelID+1,strValue);break;
		case BriEvent_RefuseEnd:str.Format("ͨ��%d: �ܽ�������� %s",m_nChannelID+1,strValue);break;	
		case BriEvent_RecvedFSK:
			{
				if(pEvent->lResult == CALLIDMODE_FSK) str.Format("ͨ��%d: ���յ����������ϢFSK���� %s",m_nChannelID+1,strValue);
				else str.Format("ͨ��%d: ���յ����������ϢDTMF���� %s",m_nChannelID+1,strValue);
			}break;	
		case BriEvent_PSTNFree:
			{
				str.Format("ͨ��%d: PSTN��·�ѿ��� %s",m_nChannelID+1,strValue);
				WriteCallLog(m_nChannelID);
			}break;	
		case BriEvent_CheckLine:
			{
				if(pEvent->lResult & CHECKLINE_MASK_DIALOUT)
				{
					str.Format("ͨ��%d: [ok]***��·����������,����������***-----------------",m_nChannelID+1);					
				}else
				{
					str.Format("ͨ��%d: [err]��·������������,���ܲ����������ţ����LINE����·!!!",m_nChannelID+1);
					AfxMessageBox(str);
				}					
				::SendMessage(GetParent()->GetSafeHwnd(),QNV_CHANNEL_MESSAGE,CB_APPENDSTATUS,(LPARAM)(LPCTSTR)str);
				if(pEvent->lResult & CHECKLINE_MASK_REV)
				{
					str.Format("ͨ��%d: [ok]***��·LINE��/PHONE��δ�ӷ�***----------------------",m_nChannelID+1);					
				}else
				{
					str.Format("ͨ��%d: [err]��·LINE��/PHONE�ڿ��ܽӷ���",m_nChannelID+1);
					AfxMessageBox(str);
				}
			}break;
		case BriEvent_DevErr:
			{
				str.Format("ͨ��%d: �豸��������ԭ��=%s(%d/%d) %s",m_nChannelID+1,GetDevErrStr(pEvent->lResult),(atol(pEvent->szData)&0xFF00)>>8,(atol(pEvent->szData)&0xFF),strValue);				
				if(pEvent->lResult == 3)// || (atol(pEvent->szData)&0xFF) == 6)//��⵽�Ƴ���ȡ���ʧ��
				{
					/*
					QNV_CloseDevice(ODT_CHANNEL,m_nChannelID);
					long lChNum=QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS);
					str.Format("��ǰͨ������:%d,�������³�ʼ�������豸",lChNum<0?0:lChNum);
					*/
					CString s;
					CTime ct=CTime::GetCurrentTime();
					s.Format("%04d-%02d-%02d %02d:%02d:%02d �豸��������",ct.GetYear(),ct.GetMonth(),ct.GetDay(),ct.GetHour(),ct.GetMinute(),ct.GetSecond());
					AfxMessageBox(s);
				}
			}break;
		case BriEvent_PlugOut:
			{
				str.Format("ͨ��%d: �豸���ε�",m_nChannelID+1);				
			}break;
		case BriEvent_EnableHook:
			{
				((CButton*)GetDlgItem(IDC_ENABLEHOOK))->SetCheck(pEvent->lResult);
				str.Format("ͨ��%d: HOOK������ lResult=%d",m_nChannelID+1,pEvent->lResult);				
			}break;
		case BriEvent_EnablePlay:
			{
				((CButton*)GetDlgItem(IDC_DOPLAY))->SetCheck(pEvent->lResult);
				str.Format("ͨ��%d: ���ȱ����� lResult=%d",m_nChannelID+1,pEvent->lResult);
			}break;
		case BriEvent_EnablePlayMux:
			{
				((CComboBox*)GetDlgItem(IDC_DOPLAYMUX))->SetCurSel(pEvent->lResult);
				str.Format("ͨ��%d: ����mux�޸� lResult=%d",m_nChannelID+1,pEvent->lResult);
			}break;
		case BriEvent_DoStartDial:
			{
				if(pEvent->lResult == CHECKDIALTONE_FAILED)
				{
					str.Format("ͨ��%d: �Զ�����ʧ�ܣ�δ��⵽������,������·",m_nChannelID+1);
					AfxMessageBox(str);
				}else
				{
					str.Format("ͨ��%d: ��ʼ���� data=%s",m_nChannelID+1,pEvent->szData);
				}
			}break;
		case BriEvent_DevCtrl:
			{
				if(pEvent->lResult == QNV_CTRL_PLAYTOLINE)
				{
					if(atol(pEvent->szData) > 0)
					{
						((CButton*)GetDlgItem(IDC_PLAY2LINE))->SetCheck(TRUE);
					}else
					{
						((CButton*)GetDlgItem(IDC_PLAY2LINE))->SetCheck(FALSE);
					}
				}
			}break;
		default:
			{
				str.Format("ͨ��%d: ���������¼� eventid=%d lResult=%d szData=%s",m_nChannelID+1,pEvent->lEventType,pEvent->lResult,pEvent->szData);
			}break;
		}
		if(!str.IsEmpty())
		{
			::SendMessage(GetParent()->GetSafeHwnd(),QNV_CHANNEL_MESSAGE,CB_APPENDSTATUS,(LPARAM)(LPCTSTR)str);
		}
		if(pEvent && pEvent->lEventType == BriEvent_RemoteSendFax && pEvent->lResult == 1)
		{
			BFU_FaxTooltip(m_nChannelID,"",TTIP_AUTORECV);
			/*
			if(MessageBox("�Է�׼�����ʹ��棬�Ƿ����?","������ʾ",MB_YESNO|MB_ICONWARNING) == IDYES)
			{
				BFU_StartRecvFax(m_nChannelID,"",0);
			}
			*/
		}
		return 1;
}

LRESULT CChannelCtrl::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	if(message ==  UPDATE_AM_MESSAGE)
	{
		CString str;
		str.Format("��ǰ����=%d",wParam);
		m_cBufAM.SetWindowText(str);
	}
	else if(message == BRI_EVENT_MESSAGE)
	{
		BRI_EVENT ev;
		PBRI_EVENT pEvent=&ev;
		//PBRI_EVENT pEvent=(PBRI_EVENT)lParam;//ֱ��ʹ���²���ڴ�ָ��,ʹ���ڼ���ڲβ��ܱ��ͷ�,�磺QNV_CloseDevice���ͷŸ��ڴ�
		memcpy((char*)pEvent,(char*)lParam,sizeof(BRI_EVENT));//�����ĺô��ǲ�����Ҫ�²���ڴ�ָ��,���Ա��ͷ�
		_ASSERT(pEvent->uChannelID == m_nChannelID);
		ProcessEvent(pEvent);
		return  TRUE;
	}else if(message == BRI_RECBUF_MESSAGE)
	{
		AppendRecBuf((short*)lParam,(long)wParam);
	}
	return CDialog::WindowProc(message, wParam, lParam);
}

long	CChannelCtrl::AppendRecBuf(short *pWaveData,long lBufSize)
{	
	//--------------------------------------
	long lsample=lBufSize/sizeof(short);
	for(int i=0;i<lsample;i++)
	{
		if(m_shBufMax < abs(pWaveData[i]))
		{
			m_shBufMax = abs(pWaveData[i]);
		}
	}
	//----------------------------------------	
	m_lBufTimes++;
	if(m_lBufTimes == 20)
	{
		//���Կ��Ǵ�SDKֱ�ӻ�ȡ����,��ȡ��ǰ���ȱ��Զ���Ϊ0
		//m_shBufMax=(short)QNV_General(m_nChannelID,QNV_GENERAL_GETMAXPOWER,0,NULL);
		PostMessage(UPDATE_AM_MESSAGE,m_shBufMax,0);
		m_lBufTimes = 0;
		m_shBufMax = 0;
	}
	if(m_pWaveView) m_pWaveView->AppendWaveData(pWaveData,lBufSize/sizeof(short));
	else
	{
		//TRACE("buf samples =%d \r\n",lBufSize/sizeof(short));
	}
	return 0;
}

BRIINT32	WINAPI CChannelCtrl::ProcEventCallback(BRIINT16 uChannelID,BRIUINT32 dwUserData,BRIINT32 lType,BRIINT32 lHandle,BRIINT32 lResult,BRIINT32 lParam,BRIPCHAR8 pData,BRIPCHAR8 pDataEx)
{
	CChannelCtrl *p=(CChannelCtrl *)dwUserData;
	BRI_EVENT ev={0};	
	ev.uChannelID = uChannelID;
	ev.lEventType = lType;
	ev.lEventHandle=lHandle;
	ev.lParam=lParam;
	ev.lResult=lResult;
	memcpy(ev.szData,pData,sizeof(ev.szData));
	memcpy(ev.szDataEx,pDataEx,sizeof(ev.szDataEx));	
	return p->ProcessEvent(&ev);
}

long	WINAPI CChannelCtrl::RecordBuf(BRIINT16 uChannelID,BRIUINT32 dwUserData,BRIBYTE8 *pBufData,BRIINT32 lBufSize)
{
	CChannelCtrl *p=(CChannelCtrl *)dwUserData;
	return p->AppendRecBuf((short*)pBufData,lBufSize);
}

void CChannelCtrl::OnStartrecfile() 
{
	OnStoprecfile();
	CString strFilePath=((CQnviccubdemoApp*)AfxGetApp())->SelectFilePath(0);
	if(!strFilePath.IsEmpty())
	{
		//QNV_RecordFile(m_nChannelID,QNV_RECORD_FILE_SETROOT,0,0,"");//������Ŀ¼ʱ����ʹ�����ø�Ŀ¼

		CString str;
		DWORD dwMask=0;
		if(((CButton*)GetDlgItem(IDC_FILEECHOED))->GetCheck()) dwMask|= RECORD_MASK_ECHO;
		if(((CButton*)GetDlgItem(IDC_RECFILEAGC))->GetCheck()) dwMask|= RECORD_MASK_AGC;
		//strFilePath="\\\\127.0.0.1\\output\\recfile\\a.wav";
		//strFilePath="\\\\192.168.0.233\\backup\\recfile\\a.wav";
		m_lRecFileHandle = QNV_RecordFile(m_nChannelID,QNV_RECORD_FILE_START,((CComboBox*)GetDlgItem(IDC_COMRECFORMAT))->GetCurSel(),dwMask,(char*)(LPCTSTR)strFilePath);		
		if(m_lRecFileHandle <= 0)
		{
			str.Format("¼��ʧ�� errid=%d",m_lRecFileHandle);
			AfxMessageBox(str);
		}else
		{
			long lVolume=100;//��������,Ĭ��Ϊ100,200��ʾ�Ŵ�һ��,0��ʾ����,������豸��Ҫ���Զ��������һ��ʹ��
			QNV_RecordFile(m_nChannelID,QNV_RECORD_FILE_SETVOLUME,m_lRecFileHandle,lVolume,NULL);
			m_cStartRecFile.EnableWindow(FALSE);
			m_cStopRecFile.EnableWindow(TRUE);	
			::SendMessage(GetParent()->GetSafeHwnd(),QNV_CHANNEL_MESSAGE,CB_APPENDSTATUS,(LPARAM)(LPCTSTR)"��ʼ�ļ�¼��...");
		}
	}
}

void CChannelCtrl::OnStoprecfile() 
{
	long lElapse=0;
	if(m_lRecFileHandle > 0)
	{
		char szPath[_MAX_PATH]={0};
		QNV_RecordFile(m_nChannelID,QNV_RECORD_FILE_PATH,m_lRecFileHandle,_MAX_PATH,szPath);
		lElapse = QNV_RecordFile(m_nChannelID,QNV_RECORD_FILE_ELAPSE,m_lRecFileHandle,0,NULL);
		if(QNV_RecordFile(m_nChannelID,QNV_RECORD_FILE_STOP,m_lRecFileHandle,0,"") <= 0)//c:\\a.wav//ֹͣ¼�������Ұ��ļ����±��浽Ϊc:\\a.wav,ɾ��ԭ��·�����ļ�
		{
			::SendMessage(GetParent()->GetSafeHwnd(),QNV_CHANNEL_MESSAGE,CB_APPENDSTATUS,(LPARAM)(LPCTSTR)"ֹͣ¼��ʧ��");
			AfxMessageBox("ֹͣ¼������");
		}
		//QNV_RecordFile(m_nChannelID,QNV_RECORD_FILE_STOP,m_lRecFileHandle,0,NULL);
		m_lRecFileHandle = -1;
		CString str;
		str.Format("ֹͣ¼�� ʱ��=%d�� ·��=%s",lElapse,szPath);
		::SendMessage(GetParent()->GetSafeHwnd(),QNV_CHANNEL_MESSAGE,CB_APPENDSTATUS,(LPARAM)(LPCTSTR)str);
	}
	m_cStartRecFile.EnableWindow(TRUE);
	m_cStopRecFile.EnableWindow(FALSE);	
}

DWORD WINAPI CChannelCtrl::DialThreadProc(LPVOID lpParam)
{
	CChannelCtrl *p=(CChannelCtrl*)lpParam;
	QNV_General(p->m_nChannelID,QNV_GENERAL_STARTDIAL,0,(char*)(LPCTSTR)p->m_strCode);
	return 1;
}
void CChannelCtrl::OnStartdial() 
{
	/*
#ifdef _DEBUG
	UpdateData(TRUE);
	DWORD dwThreadId=0;
	CreateThread(NULL,			// Attributes
						0,				// Stack Size
						DialThreadProc,		// Start Address
						this,			// Parameter
						0,//0/, // Creation Flags 
						&dwThreadId); // Thread Id	
	
	return ;
#endif
*/
	if(!(QNV_DevInfo(m_nChannelID,QNV_DEVINFO_GETMODULE)&DEVMODULE_CALLID))
	{
		AfxMessageBox("��ͨ�����ܽ�������,���ܲ���");
		return;
	}
	if(DEVTYPE_ID1 == QNV_DevInfo(m_nChannelID,QNV_DEVINFO_GETTYPE))
	{
		if(QNV_GetDevCtrl(m_nChannelID,QNV_CTRL_PHONE) <= 0)
		{
			AfxMessageBox("����ǰ�������𻰻�");
			return ;
		}else
		{//ID1/IR1��Ʒû����ժ�����ܣ�ֱ��ʹ�ö��η��뷽ʽ����
			::SendMessage(GetParent()->GetSafeHwnd(),QNV_CHANNEL_MESSAGE,CB_APPENDSTATUS,(LPARAM)(LPCTSTR)"ID1��Ʒû����ժ�����ܣ�ֱ��ʹ�ö��η��뷽ʽ����");
			QNV_General(m_nChannelID,QNV_GENERAL_SENDNUMBER,DIALTYPE_DTMF,(char*)(LPCTSTR)m_strCode);
		}
	}else
	{
		if(!(QNV_DevInfo(m_nChannelID,QNV_DEVINFO_GETMODULE)&DEVMODULE_HOOK))
		{
			AfxMessageBox("��ͨ����֧����ժ��,���ܲ���,��ʹ��֧�����ŵ�������");
			return;
		}
	}
	UpdateData(TRUE);

	::SendMessage(GetParent()->GetSafeHwnd(),QNV_CHANNEL_MESSAGE,CB_APPENDSTATUS,(LPARAM)(LPCTSTR)"����ʱ���ܲ�������,������ܻ����𲦺Ų��ɹ�");
	//QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_PLAYTOLINE,TRUE);//�Զ��򿪲���������LINE,�������Զ�����ժ�һ�״̬�򿪹رտ���
	//((CButton*)GetDlgItem(IDC_PLAY2LINE))->SetCheck(TRUE);
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_LINEOUT,TRUE);//�Զ�����·���뿪��,������������������أ��Ͳ�����������	
	((CButton*)GetDlgItem(IDC_LINEOUT))->SetCheck(TRUE);
	QNV_General(m_nChannelID,QNV_GENERAL_STARTDIAL,0,(char*)(LPCTSTR)m_strCode);

	::SendMessage(GetParent()->GetSafeHwnd(),QNV_CHANNEL_MESSAGE,CB_STARTDIAL,m_nChannelID);
}

void CChannelCtrl::OnStopdial() 
{
	QNV_General(m_nChannelID,QNV_GENERAL_STOPDIAL,0,NULL);
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_DOHOOK,FALSE);
	((CButton*)GetDlgItem(IDC_ENABLEHOOK))->SetCheck(FALSE);
}

void CChannelCtrl::OnMediaplay() 
{
	CMediaPlay media;
	media.m_nChannelID = m_nChannelID;
	media.DoModal();
}

void CChannelCtrl::OnEnableplay2spk() 
{
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_DOPLAYTOSPK,((CButton*)GetDlgItem(IDC_ENABLEPLAY2SPK))->GetCheck());	
}

void CChannelCtrl::OnDoplay() 
{
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_DOPLAY,((CButton*)GetDlgItem(IDC_DOPLAY))->GetCheck());
}

void CChannelCtrl::OnStartmultiplay() 
{
	CSelectMultiFile select;
	if(select.DoModal())
	{
		QNV_PlayMultiFile(m_nChannelID,QNV_PLAY_MULTIFILE_START,0,0,(char*)(LPCTSTR)select.m_strFileList);	
	}
}

void CChannelCtrl::OnStopmultiplay() 
{
	QNV_PlayMultiFile(m_nChannelID,QNV_PLAY_MULTIFILE_STOP,0,0,NULL);
}

void CChannelCtrl::OnInitttslist() 
{
	QNV_PlayString(m_nChannelID,QNV_PLAY_STRING_INITLIST,TTS_LIST_REINIT,0,(char*)(LPCTSTR)(GetModulePath()+"FileList.txt"));		
}

void CChannelCtrl::OnPlay2line() 
{
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_PLAYTOLINE,((CButton*)GetDlgItem(IDC_PLAY2LINE))->GetCheck());
	if(!((CButton*)GetDlgItem(IDC_PLAY2LINE))->GetCheck())
		AfxMessageBox("�رո�ģ���ʹ���Ź���ʧЧ");
}

void CChannelCtrl::OnSelchangeSelectline() 
{
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_SELECTLINEIN,m_cSelectLine.GetCurSel());
}

void CChannelCtrl::OnSelchangeMicam() 
{
	QNV_SetParam(m_nChannelID,QNV_PARAM_AM_MIC,m_cMicAM.GetCurSel());	
}

void CChannelCtrl::OnSelchangeSpkam() 
{
	QNV_SetParam(m_nChannelID,QNV_PARAM_AM_SPKOUT,m_cSpkAM.GetCurSel());
}

void CChannelCtrl::OnSelchangeLineinam() 
{
	QNV_SetParam(m_nChannelID,QNV_PARAM_AM_LINEIN,m_cLineInAM.GetCurSel());	
}

void CChannelCtrl::OnSelchangeComline3x() 
{
	QNV_SetParam(m_nChannelID,QNV_PARAM_AM_LINEOUT,m_cLine3x.GetCurSel());	
}

void CChannelCtrl::OnSelchangeAdcin() 
{
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_SELECTADCIN,m_cADCIn.GetCurSel());			
}

void CChannelCtrl::OnRingpower() 
{
	if(!(QNV_DevInfo(m_nChannelID,QNV_DEVINFO_GETMODULE)&DEVMODULE_RING))
	{
		AfxMessageBox("��ͨ�����ܿ���PHONE����,�뻻����ͨ��");
		return;
	}
	if(QNV_GetDevCtrl(m_nChannelID,QNV_CTRL_DOPHONE) && ((CButton*)GetDlgItem(IDC_RINGPOWER))->GetCheck())
	{
		((CButton*)GetDlgItem(IDC_RINGPOWER))->SetCheck(FALSE);
		AfxMessageBox("���ȶϿ��绰��");
	}else
	{
		QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_RINGPOWER,((CButton*)GetDlgItem(IDC_RINGPOWER))->GetCheck());					
	}
}

void CChannelCtrl::OnStartbufrec() 
{
	m_shBufMax=0;
	m_lBufTimes=0;
	DWORD dwMask=0;
	if(((CButton*)GetDlgItem(IDC_BUFECHOED))->GetCheck()) dwMask|=RECORD_MASK_ECHO;
	//QNV_RecordBuf(m_nChannelID,QNV_RECORD_BUF_HWND_START,(BRIINT32)m_hWnd,dwMask,NULL);//ʹ�ô�����Ϣģʽ
	QNV_RecordBuf(m_nChannelID,QNV_RECORD_BUF_CALLBACK_START,(BRIINT32)this,dwMask,(char*)RecordBuf);//ʹ�ûص�����ģʽ	
	//���ûص�������
	//N�������ص�һ��
	long lCBSamples=130;
	QNV_RecordBuf(m_nChannelID,QNV_RECORD_BUF_SETCBSAMPLES,(BRIINT32)this,lCBSamples,(char*)RecordBuf);
	long lVolume=100;//��������
	QNV_RecordBuf(m_nChannelID,QNV_RECORD_BUF_SETVOLUME,(BRIINT32)this,lVolume,(char*)RecordBuf);

	m_cViewBuf.EnableWindow(TRUE);
	m_cStartRecBuf.EnableWindow(FALSE);
	m_cStopRecBuf.EnableWindow(TRUE);
}

void CChannelCtrl::OnStoprecbuf() 
{
	QNV_RecordBuf(m_nChannelID,QNV_RECORD_BUF_HWND_STOP,(BRIINT32)m_hWnd,0,NULL);
	QNV_RecordBuf(m_nChannelID,QNV_RECORD_BUF_CALLBACK_STOP,(BRIINT32)this,0,(char*)RecordBuf);
	CloseWaveView();
	m_cViewBuf.EnableWindow(FALSE);
	m_cStartRecBuf.EnableWindow(TRUE);
	m_cStopRecBuf.EnableWindow(FALSE);	
}

void CChannelCtrl::OnViewbuf() 
{
	if(!m_pWaveView) 
	{
		m_pWaveView = new CWaveFormat();
		m_pWaveView->Create(CWaveFormat::IDD,GetDesktopWindow());
	}
	CString str;
	str.Format("ͨ��%d ����¼�����ݲ���",m_nChannelID+1);
	m_pWaveView->SetWindowText(str);
	m_pWaveView->ShowWindow(SW_SHOW);
}

void	CChannelCtrl::CloseWaveView()
{
	if(m_pWaveView)
	{
		delete m_pWaveView;
		m_pWaveView=NULL;
	}
}

long CChannelCtrl::StartPlayFile(CString strFilePath)
{
	OnStopplayfile();
	DWORD dwMask=PLAYFILE_MASK_REPEAT;//ѭ������
	m_lPlayFileHandle = QNV_PlayFile(m_nChannelID,QNV_PLAY_FILE_START,0,dwMask,(char*)(LPCTSTR)strFilePath);
	if(m_lPlayFileHandle <= 0)
	{
		CString str;
		str.Format("����ʧ�� errid=%d",m_lPlayFileHandle);
		AfxMessageBox(str);
		return 0;
	}else
	{
		m_cStartPlayFile.EnableWindow(FALSE);
		m_cPlayRemote.EnableWindow(FALSE);
		m_cStopPlayFile.EnableWindow(TRUE);
		::SendMessage(GetParent()->GetSafeHwnd(),QNV_CHANNEL_MESSAGE,CB_APPENDSTATUS,(LPARAM)(LPCTSTR)"��ʼ����ѭ���ļ�...");
		return 1;
	}
}
void CChannelCtrl::OnStartplayfile() 
{	
	CString strFilePath=((CQnviccubdemoApp*)AfxGetApp())->SelectFilePath(1);
	if(!strFilePath.IsEmpty())
	{
		StartPlayFile(strFilePath);
	}		
}

void CChannelCtrl::OnStartplaybuf() 
{
	CMediaplayBuf	playbuf;
	playbuf.m_nChannelID = m_nChannelID;
	playbuf.DoModal();
}

void CChannelCtrl::OnFaxmodule() 
{
	if(!(QNV_DevInfo(m_nChannelID,QNV_DEVINFO_GETMODULE) & DEVMODULE_FAX))
	{
		AfxMessageBox("���豸��֧�ִ��湦��");
		return ;
	}
	CFaxModule fax;
	fax.m_nChannelID = m_nChannelID;
	fax.DoModal();
}

void CChannelCtrl::OnStartring() 
{	
	if(!(QNV_DevInfo(m_nChannelID,QNV_DEVINFO_GETMODULE)&DEVMODULE_RING))
	{
		AfxMessageBox("��ͨ�����ܿ���PHONE����,�뻻����ͨ��");
		return;
	}
	
	if(QNV_GetDevCtrl(m_nChannelID,QNV_CTRL_DOPHONE) && ((CButton*)GetDlgItem(IDC_STARTRING))->GetCheck())
	{
		((CButton*)GetDlgItem(IDC_STARTRING))->SetCheck(FALSE);
		AfxMessageBox("���ȶϿ��绰��");
	}else
	{
		if(((CButton*)GetDlgItem(IDC_STARTRING))->GetCheck())
		{
			char szCallID[16]={0};//call ID
			for(int i=0;i<12;i++)
			{
				szCallID[i]=rand()%10+'0';
			}
			QNV_SetParam(m_nChannelID,QNV_PARAM_RINGCALLIDTYPE,/*DIALTYPE_FSK*/DIALTYPE_DTMF);//�������뷽ʽΪһ����FSKģʽ,����ʹ�ø÷�ʽ
			QNV_General(m_nChannelID,QNV_GENERAL_STARTRING,0,szCallID);	
			CString str=(CString)"��ʼ����ģ�������� -> ģ��������룺"+szCallID;
			::SendMessage(GetParent()->GetSafeHwnd(),QNV_CHANNEL_MESSAGE,CB_APPENDSTATUS,(LPARAM)(LPCTSTR)str);
		}else
		{
			QNV_General(m_nChannelID,QNV_GENERAL_STOPRING,0,NULL);	
		}
	}
}

void CChannelCtrl::OnRefuse() 
{
	if(QNV_GetDevCtrl(m_nChannelID,QNV_CTRL_RINGTIMES) <= 0)
	{
		AfxMessageBox("û�����磬��Ч�ľܽ�");
	}else
	{
		//REFUSE_ASYN�첽ģʽ,���ú����������أ���������ʾ�ܽ���ɣ��ܽ���ɺ󽫽��յ�һ���ܽ���ɵ��¼�
		//REFUSE_SYNͬ��ģʽ,���ú�ú������������ȴ��ܽ���ɷ��أ�ϵͳ�����оܽ���ɵ��¼�
		QNV_General(m_nChannelID,QNV_GENERAL_STARTREFUSE,REFUSE_ASYN,NULL);	
	}
}

void CChannelCtrl::OnFlash() 
{
	if(QNV_GetDevCtrl(m_nChannelID,QNV_CTRL_DOHOOK) <= 0
		&& QNV_GetDevCtrl(m_nChannelID,QNV_CTRL_PHONE) <= 0)
	{
		AfxMessageBox("û��ժ��״̬����Ч���Ĳ��");
	}else
	{
		if(QNV_General(m_nChannelID,QNV_GENERAL_STARTFLASH,FT_ALL,""/*1099*/) <= 0)
			AfxMessageBox("�Ĳ��ʧ��");
		else
		{
			QNV_General(m_nChannelID,QNV_GENERAL_RESETRINGBACKEX,0,NULL);
		}
	}
}

void CChannelCtrl::OnPlaytts() 
{
	CInputTTS tts;
	if(tts.DoModal() == IDOK)
	{
		OnStopplaytts();	
		m_lPlayStringHandle=QNV_PlayString(m_nChannelID,QNV_PLAY_STRING_START,0,0,(char*)(LPCTSTR)tts.m_strTTS);//
		if(m_lPlayStringHandle == BCERR_NOTCREATESTRINGPLAY)
		{
			AfxMessageBox("û�г�ʼ���ַ��б�!");
		}
	}
}

void CChannelCtrl::OnStopplaytts() 
{
	if(m_lPlayStringHandle > 0)
	{
		QNV_PlayString(m_nChannelID,QNV_PLAY_STRING_STOP,m_lPlayStringHandle,0,NULL);//	
		m_lPlayStringHandle = -1;
	}
}

void CChannelCtrl::OnSpeech() 
{
//	QNV_SetParam(m_nChannelID,QNV_PARAM_SPEECHSILENCEAM,5000);//����5000���ϲű�ʾ˵��
//	QNV_General(m_nChannelID,QNV_GENERAL_CHECKVOICE,500,NULL);//����500ms��ʾ��⵽����
//	return;

	CSpeech Speech;
	Speech.m_nChannelID = m_nChannelID;
	Speech.DoModal();
}

void CChannelCtrl::OnBufechoed() 
{
	QNV_RecordBuf(m_nChannelID,QNV_RECORD_BUF_ENABLEECHO,(BRIINT32)this,((CButton*)GetDlgItem(IDC_BUFECHOED))->GetCheck(),(char*)RecordBuf);	
}

void CChannelCtrl::OnPause() 
{
	if(m_lPlayFileHandle > 0)
	{
		QNV_PlayFile(m_nChannelID,QNV_PLAY_FILE_PAUSE,m_lPlayFileHandle,0,NULL);
	}	
}

void CChannelCtrl::OnResume() 
{
	if(m_lPlayFileHandle > 0)
	{
		QNV_PlayFile(m_nChannelID,QNV_PLAY_FILE_RESUME,m_lPlayFileHandle,0,NULL);
	}	
}

void CChannelCtrl::OnLineout() 
{
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_LINEOUT,((CButton*)GetDlgItem(IDC_LINEOUT))->GetCheck());
	if(!((CButton*)GetDlgItem(IDC_LINEOUT))->GetCheck())
		AfxMessageBox("�رո�ģ���ʹ���Ź���ʧЧ");
}

void CChannelCtrl::OnDisableecho() 
{
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_ECHO,!((CButton*)GetDlgItem(IDC_DISABLEECHO))->GetCheck());	
}

void CChannelCtrl::OnLed() 
{
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_LEDPOWER,!((CButton*)GetDlgItem(IDC_LED))->GetCheck());	
}

void CChannelCtrl::OnWatchdog() 
{
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_WATCHDOG,((CButton*)GetDlgItem(IDC_WATCHDOG))->GetCheck());		
}

void CChannelCtrl::On24v() 
{
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_PHONEPOWER,!((CButton*)GetDlgItem(IDC_24V))->GetCheck());		
}

void CChannelCtrl::OnSelchangeDoplaymux() 
{
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_PLAYMUX,((CComboBox*)GetDlgItem(IDC_DOPLAYMUX))->GetCurSel());	
}

void CChannelCtrl::OnSelchangeDoplayam() 
{
	QNV_SetParam(m_nChannelID,QNV_PARAM_AM_DOPLAY,((CComboBox*)GetDlgItem(IDC_DOPLAYAM))->GetCurSel());		
	long lam=QNV_GetParam(m_nChannelID,QNV_PARAM_AM_DOPLAY);
}

void CChannelCtrl::OnDisableupload() 
{
//	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_UPLOAD,!((CButton*)GetDlgItem(IDC_DISABLEUPLOAD))->GetCheck());	

	QNV_General(m_nChannelID,0x1FFF000b,!((CButton*)GetDlgItem(IDC_DISABLEUPLOAD))->GetCheck(),NULL);//��ͣ���̣߳���ʡCPU��Դ
}

void CChannelCtrl::OnDisabldownload() 
{
//	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_DOWNLOAD,!((CButton*)GetDlgItem(IDC_DISABLEDOWNLOAD))->GetCheck());	

	QNV_General(m_nChannelID,0x1FFF000c,!((CButton*)GetDlgItem(IDC_DISABLEDOWNLOAD))->GetCheck(),NULL);//��ͣд�̣߳���ʡCPU��Դ
}

void CChannelCtrl::OnSaveparam() 
{
	CString strIniPath;
	strIniPath.Format("%s%s%d.ini",GetModulePath(),"qnvini\\param_",m_nChannelID+1);
	if(QNV_General(m_nChannelID,QNV_GENERAL_WRITEPARAM,0,(char*)(LPCTSTR)strIniPath) > 0)
	{
		AfxMessageBox("�ɹ����������"+strIniPath);
	}else
		AfxMessageBox("�������ʧ��");
}

void CChannelCtrl::OnReadparam() 
{
	CString strIniPath;
	strIniPath.Format("%s%s%d.ini",GetModulePath(),"qnvini\\param_",m_nChannelID+1);
	//QNV_General(m_nChannelID,QNV_GENERAL_READPARAM,0,"ini\\configparam.ini");
	if(QNV_General(m_nChannelID,QNV_GENERAL_READPARAM,0,(char*)(LPCTSTR)strIniPath) > 0)
	{
		InitChannelParam();
	}else
	{
		AfxMessageBox("��ȡ����ʧ��");
	}
}

void CChannelCtrl::OnTimer(UINT nIDEvent) 
{
	if(m_nEventTimer == nIDEvent)
	{
		BRI_EVENT tEvent={0};
		//ʹ�÷�ɾ��ģʽ,���Զ�ɾ��ģʽ2��ѡ��һ�ַ�ʽ�Ϳ���,ֻ��һ���ط���Ҫ��ȡ�¼�ʱ������ʹ���Զ�ɾ��ģʽ
		tEvent.lEventType = QNV_Event(m_nChannelID, QNV_EVENT_TYPE, 0, NULL,NULL,0);
		if(tEvent.lEventType > 0)
		{		
			tEvent.lEventHandle= QNV_Event(m_nChannelID, QNV_EVENT_HANDLE, 0, NULL,NULL,0);
			tEvent.lParam = QNV_Event(m_nChannelID, QNV_EVENT_PARAM, 0, NULL,NULL,0);
			tEvent.lResult= QNV_Event(m_nChannelID, QNV_EVENT_RESULT, 0, NULL,NULL,0);
			QNV_Event(m_nChannelID, QNV_EVENT_DATA, 0, NULL,tEvent.szData,sizeof(tEvent.szData));
			QNV_Event(m_nChannelID, QNV_EVENT_REMOVE, 0, NULL,NULL,0);//ɾ��
			ProcessEvent(&tEvent);
		}
		/*
		//ʹ���Զ�ɾ��ģʽ
		int nRet = QNV_Event(m_nChannelID, QNV_EVENT_POP, 0, NULL, (char *)&tEvent, sizeof(BRI_EVENT));
		if (nRet > 0)
		{
			ProcessEvent(&tEvent);			
		}
		*/
	/*
#ifdef _DEBUG
	if(QNV_DevInfo(m_nChannelID,QNV_DEVINFO_GETMODULE) & DEVMODULE_SWITCH)
	{
		QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_DOPHONE,QNV_GetDevCtrl(m_nChannelID,QNV_CTRL_DOPHONE)>0?0:1);
	}
#endif
	*/
	}
	CDialog::OnTimer(nIDEvent);
}

void CChannelCtrl::OnPlayremote() 
{
	CInputRemote	input;
	if(input.DoModal() == IDOK)
	{
		StartPlayFile(input.m_strRemoteFile);
	}
}

void CChannelCtrl::OnRecvfsk() 
{
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_RECVFSK,((CButton*)GetDlgItem(IDC_RECVFSK))->GetCheck());	
}

void CChannelCtrl::OnRecvdtmf() 
{
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_RECVDTMF,((CButton*)GetDlgItem(IDC_RECVDTMF))->GetCheck());	
}

void CChannelCtrl::OnRecvsign() 
{
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_RECVSIGN,((CButton*)GetDlgItem(IDC_RECVSIGN))->GetCheck());	
}

void CChannelCtrl::OnCallin() 
{
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_RECVCALLIN,((CButton*)GetDlgItem(IDC_RECVCALLIN))->GetCheck());		
}

void CChannelCtrl::OnSenddtmf() 
{
	UpdateData(TRUE);
	if( QNV_General(m_nChannelID,QNV_GENERAL_SENDNUMBER,DIALTYPE_DTMF,(char*)(LPCTSTR)m_strCode) <= 0)
	{
		AfxMessageBox("����ʧ��");
	}
}

void CChannelCtrl::OnSendfsk() 
{
	UpdateData(TRUE);
	if( QNV_General(m_nChannelID,QNV_GENERAL_SENDNUMBER,DIALTYPE_FSK,(char*)(LPCTSTR)m_strCode) <= 0)
	{
		AfxMessageBox("����ʧ��");
	}	
}

void CChannelCtrl::OnAdfunc() 
{
	QNV_General(m_nChannelID,0x1FFF0007,!m_cAdfunc.GetCheck(),NULL);	
}

void CChannelCtrl::OnExclusive() 
{
	QNV_General(m_nChannelID,0x1FFF000d,((CButton*)GetDlgItem(IDC_EXCLUSIVE))->GetCheck(),NULL);		
}
