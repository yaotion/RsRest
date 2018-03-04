// TestDialog.cpp : implementation file
//

#include "stdafx.h"
#include "czgocx.h"
#include "TestDialog.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CTestDialog dialog

const int THISCHANNEL = 0 ;
CTestDialog::CTestDialog(CWnd* pParent /*=NULL*/)
	: CDialog(CTestDialog::IDD, pParent)
{
	//{{AFX_DATA_INIT(CTestDialog)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	m_strServer = "" ;
	m_strCC = "1001622952968" ;
	m_strPwd = "czg20100308" ;
	m_nChannelID = THISCHANNEL ;
}


void CTestDialog::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CTestDialog)
	DDX_Control(pDX, IDC_SELECTLINE, m_cSelectLine);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CTestDialog, CDialog)
	//{{AFX_MSG_MAP(CTestDialog)
	ON_BN_CLICKED(IDC_OPENDEV, OnOpendev)
	ON_BN_CLICKED(IDC_CLOSEDEV, OnClosedev)
	ON_BN_CLICKED(IDC_SETCCSERVER, OnSetccserver)
	ON_BN_CLICKED(IDC_LOGON, OnLogon)
	ON_BN_CLICKED(IDC_LOGOFF, OnLogoff)
	ON_BN_CLICKED(IDC_ANSWERCALL, OnAnswercall)
	ON_BN_CLICKED(IDC_REJECTCALL, OnRejectcall)
	ON_BN_CLICKED(IDC_DISABLERING, OnDisablering)
	ON_BN_CLICKED(IDC_STARTRING, OnStartring)
	ON_BN_CLICKED(IDC_STOP, OnStop)
	ON_CBN_SELCHANGE(IDC_SELECTLINE, OnSelchangeSelectline)
	ON_WM_DESTROY()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CTestDialog message handlers


//��ʾ��ʾ״̬�ı�
void CTestDialog::AppendStatus(CString strStatus)
{
	TRACE ( "��ʾ��Ϣ:%s\n" , strStatus ) ;
	CString str,strTime;
	CTime ct=CTime::GetCurrentTime();
	strTime.Format("[%02d:%02d:%02d] %s",ct.GetHour(),ct.GetMinute(),ct.GetSecond(),strStatus);	
	CString strSrc;
	GetDlgItem(IDC_CCSTATUS)->GetWindowText(strSrc);
	if(strSrc.GetLength() > 16000)
		strSrc .Empty();
	str=strTime+"\r\n"+strSrc;
	GetDlgItem(IDC_CCSTATUS)->SetWindowText(str);
}

void CTestDialog::OnOpendev() 
{
	if(QNV_OpenDevice(ODT_LBRIDGE,0,0) > 0)
	{
		AppendStatus("���豸�ɹ�");
		for(BRIINT16 i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
		{//��windowproc������յ�����Ϣ
			m_cSelectLine.SetCurSel(QNV_GetDevCtrl(m_nChannelID,QNV_CTRL_SELECTLINEIN));
			//QNV_Event(i,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);//����ģʽ
			QNV_Event(i,QNV_EVENT_REGCBFUNC,(long)this,(char*)CallbackEvent,NULL,0);//�ص�����ģʽ
		}	
	}else
	{
		AppendStatus("���豸ʧ��");
	}
}

BRIINT32 WINAPI CTestDialog::CallbackEvent(BRIINT16 uChannelID,BRIUINT32 dwUserData,BRIINT32 lType,BRIINT32 lHandle,BRIINT32 lResult,BRIINT32 lParam,BRIPCHAR8 pData,BRIPCHAR8 pDataEx)
{
	CTestDialog *p=(CTestDialog*)dwUserData;
	BRI_EVENT Event={0};
	Event.lEventHandle = lHandle;
	Event.lEventType = lType;
	Event.lParam=lParam;
	Event.lResult=lResult;
	Event.uChannelID=uChannelID;
	if(pData) strcpy(Event.szData,pData);
	if(pDataEx) strcpy(Event.szDataEx,pDataEx);
	p->ShowEvent(&Event);
	return 1;
}

long	CTestDialog::ShowEvent(PBRI_EVENT pEvent)
{
	CString strValue,str;
	strValue.Format("Handle=%d Result=%d Data=%s",pEvent->lEventHandle,pEvent->lResult,pEvent->szData);
	switch(pEvent->lEventType)
	{
	case BriEvent_PhoneHook:str.Format("ͨ��%d: �绰��ժ�� %s",pEvent->uChannelID+1,strValue);break;
	case BriEvent_PhoneHang:str.Format("ͨ��%d: �绰���һ� %s",pEvent->uChannelID+1,strValue);break;
	case BriEvent_CallIn:
		{
			str.Format("ͨ��%d: �������� %s",pEvent->uChannelID+1,strValue);
		}break;
	case BriEvent_GetCallID:
		{
			str.Format("ͨ��%d: ���յ�������� %s",pEvent->uChannelID+1,strValue);
			return 1;
		}break;
	case BriEvent_StopCallIn:
		{
			str.Format("ͨ��%d: ֹͣ���룬����һ��δ�ӵ绰 %s",pEvent->uChannelID+1,strValue);
		}break;
	case BriEvent_GetDTMFChar:str.Format("ͨ��%d: ���յ����� %s",pEvent->uChannelID+1,strValue);break;		
	case BriEvent_RemoteHang:
		{
			str.Format("ͨ��%d: Զ�̹һ� %s",pEvent->uChannelID+1,strValue);
		}break;
	case BriEvent_Busy:
		{
			str.Format("ͨ��%d: ���յ�æ��,��·�Ѿ��Ͽ� %s",pEvent->uChannelID+1,strValue);
		}break;
	case BriEvent_DialTone:str.Format("ͨ��%d: ��⵽������ %s",pEvent->uChannelID+1,strValue);break;
	case BriEvent_PhoneDial:str.Format("ͨ��%d: �绰������ %s",pEvent->uChannelID+1,strValue);break;
	case BriEvent_RingBack:str.Format("ͨ��%d: ���ź���յ������� %s",pEvent->uChannelID+1,strValue);break;
		
	case BriEvent_CC_ConnectFailed:str.Format("���ӷ�����ʧ��");break;
	case BriEvent_CC_LoginFailed://��½ʧ��
		{
			str.Format("��½ʧ�� ԭ��=%d %s",pEvent->lResult,strValue);
		}break;
	case BriEvent_CC_CallOutSuccess:str.Format("���ں���... %s",strValue);break;
	case BriEvent_CC_CallOutFailed:
		{				
			str.Format("����ʧ�� ԭ��=%d ",pEvent->lResult);				
		}break;
	case BriEvent_CC_Connected:
		{
			str.Format("CC�Ѿ���ͨ %s",strValue);				
		}break;
	case BriEvent_CC_CallFinished:
		{
			str.Format("���н��� ԭ��=%d",pEvent->lResult);
		}break;
		
	case BriEvent_CC_LoginSuccess:str.Format("��½�ɹ� %s",strValue);break;
	case BriEvent_CC_CallIn:
		str.Format("������� \r\n%s",pEvent->szData);
		AppendCallIn(pEvent->lEventHandle,pEvent->szData);
		break;
	case BriEvent_CC_ReplyBusy:str.Format("�Է��ظ�æ \r\n%s",pEvent->szData);break;
	case BriEvent_CC_RecvedMsg:str.Format("���յ���Ϣ \r\n%s",pEvent->szData);break;
	case BriEvent_CC_RecvedCmd:str.Format("���յ����� \r\n%s",pEvent->szData);break;
	default:break;
	}
	if(!str.IsEmpty())
		AppendStatus(str);
	return 1;
}

void CTestDialog::OnClosedev() 
{
	QNV_CloseDevice(ODT_ALL,0);
	AppendStatus("�ر��豸���");
}

LRESULT CTestDialog::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	if(message == BRI_EVENT_MESSAGE)//���յ��¼�
	{
		PBRI_EVENT pEvent=(PBRI_EVENT)lParam;//��ȡ�¼����ݽṹ
		ShowEvent(pEvent);
	}
	return CDialog::WindowProc(message, wParam, lParam);
}

BOOL CTestDialog::PreTranslateMessage(MSG* pMsg) 
{
	if(pMsg->message == WM_KEYDOWN && pMsg->wParam == VK_ESCAPE)
	{//���ܺ��е�TSTCON32.EXE,��TSTCON32.EXE�Զ������˱�ǿ�ƴ���esc��������������Ӧ�û���Ըü����¼���ֱ�Ӵ��ݵ�������
		return FALSE;
	}
	return CDialog::PreTranslateMessage(pMsg);
}

void CTestDialog::OnSetccserver() 
{
	// TODO: Add your control notification handler code here
	if(QNV_OpenDevice(ODT_CC,0,QNV_CC_LICENSE) <= 0 )//����CCģ��
	{
		AppendStatus("����CCģ��ʧ��");
		return ;
	}else
	{
		//ע�᱾���ڽ���CCģ����¼�
		//��windowproc������յ�����Ϣ
		//QNV_Event(CCCTRL_CHANNELID,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);
		//ע��ʹ�ûص�������ʽ��ȡ�¼�,��������ϢֻҪ��ѡһ�Ϳ���
		QNV_Event(CCCTRL_CHANNELID,QNV_EVENT_REGCBFUNC,(long)this,(char*)CallbackEvent,NULL,0);
		//
		AppendStatus("����CCģ�����");
		return ;
	}
	if(QNV_CCCtrl(QNV_CCCTRL_SETSERVER,(char*)(LPCTSTR)m_strServer,0) <= 0)
	{
		AppendStatus("�޸ķ�����IP��ַʧ�� "+m_strServer);
	}else
		AppendStatus("�޸ķ�����IP��ַ���,�������µ�½.. "+m_strServer);
}

void CTestDialog::OnLogon() 
{
	// TODO: Add your control notification handler code here
	if(QNV_CCCtrl(QNV_CCCTRL_ISLOGON,NULL,0) > 0)
	{
		QNV_CCCtrl(QNV_CCCTRL_LOGOUT,NULL,0);
		AppendStatus("�Ѿ�����,������.");
	}
	CString strValue=m_strCC+","+m_strPwd;//','�ָ�
	if(QNV_CCCtrl(QNV_CCCTRL_LOGIN,(char*)(LPCTSTR)strValue,0) <= 0)//��ʼ��½
	{
		AppendStatus("��½ʧ��,CC:"+m_strCC);
	}
	else
		AppendStatus("��ʼ��½,CC: "+m_strCC);	
}

void CTestDialog::OnLogoff() 
{
	// TODO: Add your control notification handler code here
	QNV_CCCtrl(QNV_CCCTRL_LOGOUT,NULL,0);
	AppendStatus("CC�Ѿ�����");	
}

void CTestDialog::OnAnswercall() 
{
	// TODO: Add your control notification handler code here
	QNV_SetDevCtrl((short)m_nChannelID,QNV_CTRL_DOPHONE,FALSE);//����������
	QNV_SetDevCtrl((short)m_nChannelID,QNV_CTRL_SELECTLINEIN,LINEIN_ID_1);//ʹ�û�������
	if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_ACCEPT,m_dwHandle,NULL,m_nChannelID) <= 0)
		AppendStatus("����ʧ��");
}

void CTestDialog::OnRejectcall() 
{
	// TODO: Add your control notification handler code here
	if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_REFUSE,m_dwHandle,NULL,-1) <= 0)
		AppendStatus("�ܾ�ʧ��");
}

long CTestDialog::AppendCallIn(DWORD dwHandle, CString strData)
{
	CMsgParse parse(strData);
	m_strCC=parse.GetParam(MSG_KEY_CC);//cc����
	m_strNick=parse.GetParam(MSG_KEY_NAME);//�ǳ�
	m_dwHandle = dwHandle ;
	CString str ;
	str.Format ( "CC����:%s �ǳ�:%s ����ID:%d" , m_strCC , m_strNick , dwHandle ) ;
	AppendStatus(str) ;
	//add by czg 20100315
	OnAnswercall() ;
	return 1 ;
}

void CTestDialog::OnDisablering() 
{
	// TODO: Add your control notification handler code here
	if(QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_DOPHONE,!((CButton*)GetDlgItem(IDC_DISABLERING))->GetCheck()) <= 0
		&& ((CButton*)GetDlgItem(IDC_DISABLERING))->GetCheck() )
	{
		((CButton*)GetDlgItem(IDC_DISABLERING))->SetCheck(FALSE);
		AppendStatus("�Ͽ�ʧ��,�������豸��֧�ָù���");
	}
}

void CTestDialog::OnStartring() 
{
	// TODO: Add your control notification handler code here
	if(QNV_GetDevCtrl(m_nChannelID,QNV_CTRL_DOPHONE) && ((CButton*)GetDlgItem(IDC_STARTRING))->GetCheck())
	{
		((CButton*)GetDlgItem(IDC_STARTRING))->SetCheck(FALSE);
		AppendStatus("���ȶϿ��绰��");
	}else
	{
	if(((CButton*)GetDlgItem(IDC_STARTRING))->GetCheck())
	{
		char szCallID[16]={0};//call ID
		for(int i=0;i<12;i++)
		{
			szCallID[i]=rand()%10+'0';
		}
		QNV_SetParam(m_nChannelID,QNV_PARAM_RINGCALLIDTYPE,DIALTYPE_FSK/*DIALTYPE_DTMF*/);//�������뷽ʽΪһ����FSKģʽ,Ĭ��Ϊһ��ǰdtmfģʽ
		QNV_General(m_nChannelID,QNV_GENERAL_STARTRING,0,szCallID);	
		CString str=(CString)"��ʼ����ģ�������� -> ģ��������룺"+szCallID;
		AppendStatus(str);
	}else
		QNV_General(m_nChannelID,QNV_GENERAL_STOPRING,0,NULL);	
	}
}

void CTestDialog::OnStop() 
{
	// TODO: Add your control notification handler code here
	if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_STOP	,m_dwHandle,NULL,-1) <= 0)
		AppendStatus("ֹͣʧ��");
}

void CTestDialog::OnSelchangeSelectline() 
{
	// TODO: Add your control notification handler code here
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_SELECTLINEIN,LINEIN_ID_1);
}

void CTestDialog::OnDestroy() 
{
	OnClosedev();
	CDialog::OnDestroy();	
}
