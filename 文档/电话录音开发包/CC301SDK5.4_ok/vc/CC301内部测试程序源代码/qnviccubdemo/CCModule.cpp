// CCModule.cpp : implementation file
//

#include "stdafx.h"
#include "qnviccubdemo.h"
#include "CCModule.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CCCModule dialog


CCCModule::CCCModule(CWnd* pParent /*=NULL*/)
	: CDialog(CCCModule::IDD, pParent)
{
	//{{AFX_DATA_INIT(CCCModule)
	m_strPwd = _T("111111");
	m_strCC = _T("1004129971204");
	m_strCallCC = _T("100888888888889");
	m_strMsgText = _T("");
	m_strCCNum = _T("");
	m_strRegPwd = _T("");
	m_strRegNick = _T("");
	m_strServerAddr = _T("");
	m_strSvrID = _T("100A11111111");
	m_strOldPwd = _T("");
	m_strNewPwd = _T("");
	//}}AFX_DATA_INIT
	m_nChannelID = CCCTRL_CHANNELID;
	m_dwCallSessID = 0;
	m_pFileTransfer=NULL;
}


void CCCModule::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CCCModule)
	DDX_Control(pDX, IDC_SERVERADDR, m_cServerAddr);
	DDX_Control(pDX, IDC_REGCCNUM, m_cCCNum);
	DDX_Control(pDX, IDC_MSGTEXT, m_cMsgText);
	DDX_Control(pDX, IDC_CHANNELID, m_cChannelID);
	DDX_Text(pDX, IDC_CCPWD, m_strPwd);
	DDX_Text(pDX, IDC_CCNUMBER, m_strCC);
	DDX_Text(pDX, IDC_CALLCC, m_strCallCC);
	DDX_Text(pDX, IDC_MSGTEXT, m_strMsgText);
	DDV_MaxChars(pDX, m_strMsgText, 400);
	DDX_Text(pDX, IDC_REGCCNUM, m_strCCNum);
	DDX_Text(pDX, IDC_REGPWD, m_strRegPwd);
	DDX_Text(pDX, IDC_REGNICK, m_strRegNick);
	DDX_Text(pDX, IDC_SERVERADDR, m_strServerAddr);
	DDV_MaxChars(pDX, m_strServerAddr, 16);
	DDX_Text(pDX, IDC_SVRID, m_strSvrID);
	DDV_MaxChars(pDX, m_strSvrID, 32);
	DDX_Text(pDX, IDC_OLDPWD, m_strOldPwd);
	DDX_Text(pDX, IDC_NEWPWD, m_strNewPwd);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CCCModule, CDialog)
	//{{AFX_MSG_MAP(CCCModule)
	ON_BN_CLICKED(IDC_LOGON, OnLogon)
	ON_BN_CLICKED(IDC_LOGOUT, OnLogout)
	ON_BN_CLICKED(IDC_STARTCALL, OnStartcall)
	ON_BN_CLICKED(IDC_STOPCALL, OnStopcall)
	ON_BN_CLICKED(IDC_ANSWER, OnAnswer)
	ON_BN_CLICKED(IDC_REFUSE, OnRefuse)
	ON_BN_CLICKED(IDC_SENDMSG, OnSendmsg)
	ON_BN_CLICKED(IDC_SENDCMD, OnSendcmd)
	ON_BN_CLICKED(IDC_REGCC, OnRegcc)
	ON_BN_CLICKED(IDC_SETSERVER, OnSetserver)
	ON_BN_CLICKED(IDC_FINDSVR, OnFindsvr)
	ON_BN_CLICKED(IDC_MODIFYPWD, OnModifypwd)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CCCModule message handlers

BOOL CCCModule::OnInitDialog() 
{
	CDialog::OnInitDialog();
		
	CString str;
	for(int i=0;i<QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS);i++)
	{
		str.Format("%d",i+1);
		m_cChannelID.AddString(str);
	}
	if(m_cChannelID.GetCount() > 0) m_cChannelID.SetCurSel(0);
	QNV_OpenDevice(ODT_CC,0,QNV_CC_LICENSE);
	QNV_Event(m_nChannelID,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);
	QNV_CCCtrl(QNV_CCCTRL_SETFINDSVRTIMEOUT,NULL,1000);
	//QNV_Event(m_nChannelID,QNV_EVENT_REGCBFUNC,(DWORD)this,(char*)ProcEventCallback,NULL,0);//ʹ�ûص�������ʽ
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

BRIINT32	WINAPI CCCModule::ProcEventCallback(BRIINT16 uChannelID,BRIUINT32 dwUserData,BRIINT32 lType,BRIINT32 lHandle,BRIINT32 lResult,BRIINT32 lParam,BRIPCHAR8 pData,BRIPCHAR8 pDataEx)
{
	return 0;
}

long	CCCModule::GetChannelID()
{
	return m_cChannelID.GetCurSel();
}

void	CCCModule::FreeSource()
{
	OnLogout();
	QNV_CloseDevice(ODT_CC,0);
}

void CCCModule::OnLogon() 
{
	OnLogout();//������
	UpdateData(TRUE);
	if(m_strCC.IsEmpty())
	{
		AfxMessageBox("CC���벻��Ϊ��");
		return;
	}
	if(m_strPwd.IsEmpty())
	{
		AfxMessageBox("���벻��Ϊ��");
		return;
	}
	if(m_strPwd.Find(",") >= 0)
	{
		AfxMessageBox("���벻����','");
		return;
	}
	CString strValue=m_strCC+","+m_strPwd;//','�ָ�
	if(QNV_CCCtrl(QNV_CCCTRL_LOGIN,(char*)(LPCTSTR)strValue,0) <= 0)
		AfxMessageBox("��½ʧ��");
	else
		AppendStatus("��ʼ��½...");
}

void CCCModule::OnLogout() 
{
	QNV_CCCtrl(QNV_CCCTRL_LOGOUT,NULL,0);
	AppendStatus("�˳�CC");
}

void CCCModule::OnCancel() 
{	
	GetParent()->PostMessage(QNV_CLOSECCMODULE_MESSAGE,0,0);
	//CDialog::OnCancel();
}

CString CCCModule::GetMsgValue(CString strMsg,CString strKey)
{
	int iPos=strMsg.Find(strKey);
	if(iPos>=0)
	{
		int iEnd=strMsg.Find(MSG_KEY_SPLIT,iPos);
		if(iEnd)
		{
			return strMsg.Mid(iPos+strKey.GetLength(),iEnd-iPos-strKey.GetLength());
		}else
			return strMsg.Mid(iPos+strKey.GetLength());
	}else
		return "";
}

LRESULT CCCModule::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	if(message == QNV_CLOSEFILETRANSFER_MESSAGE)
	{
		CloseFileTransfer();
	}
	else if(message == BRI_EVENT_MESSAGE)
	{
		PBRI_EVENT pEvent=(PBRI_EVENT)lParam;
		CString strValue,str;
		strValue.Format("Handle=%d Result=%d Data=%s",pEvent->lEventHandle,pEvent->lResult,pEvent->szData);
		switch(pEvent->lEventType)
		{
		case BriEvent_CC_ConnectFailed:
			{
				str.Format("ͨ��%d: ����ʧ�� ԭ��=%d %s",m_nChannelID,pEvent->lResult,strValue);
			}break;
		case BriEvent_CC_LoginFailed:
			{
				str.Format("ͨ��%d: ��½ʧ�� ԭ��=%d %s",m_nChannelID,pEvent->lResult,strValue);
				QNV_CCCtrl(QNV_CCCTRL_LOGOUT,NULL,0);//�ͷ���Դ
			}break;
		case BriEvent_CC_LoginSuccess:
			{
				char szCC[32]={0};
				QNV_CCCtrl_CCInfo(QNV_CCCTRL_CCINFO_OWNERCC,"",szCC,32);
				str.Format("ͨ��%d: ��½�ɹ� cc=%s %s",m_nChannelID,szCC,strValue);
			}break;
		case BriEvent_CC_SystemTimeErr:
			{
				str.Format("ͨ��%d: ϵͳʱ����� %s",m_nChannelID,strValue);
			}break;
		case BriEvent_CC_CallIn:
			{
				if(m_dwCallSessID != 0)//��ʾͬʱֻ����һ��
				{//��æ���ܾ�
					QNV_CCCtrl_Call(QNV_CCCTRL_CALL_BUSY,pEvent->lEventHandle,NULL,0);
					QNV_CCCtrl_Call(QNV_CCCTRL_CALL_REFUSE,pEvent->lEventHandle,NULL,0);
					str.Format("ͨ��%d: CC�������󱻾ܽ� %s",m_nChannelID,strValue);
				}else
				{
					m_dwCallSessID = pEvent->lEventHandle;
					str.Format("ͨ��%d: CC�������� %s",m_nChannelID,strValue);
				}
			}break;
		case BriEvent_CC_CallOutSuccess:
			{
				str.Format("ͨ��%d: ���ں���... %s",m_nChannelID,strValue);
			}break;
		case BriEvent_CC_CallOutFailed:
			{
				m_dwCallSessID= 0;//��λm_dwCallSessID
				str.Format("ͨ��%d: ����ʧ�� %s",m_nChannelID,strValue);
			}break;
		case BriEvent_CC_Connected:
			{
				str.Format("ͨ��%d: CC�Ѿ���ͨ %s",m_nChannelID,strValue);
			}break;
		case BriEvent_CC_CallFinished:
			{
				m_dwCallSessID= 0;//��λm_dwCallSessID
				str.Format("ͨ��%d: ���н��� %s",m_nChannelID,strValue);
			}break;
		case BriEvent_CC_RecvedMsg:
			{
				str.Format("ͨ��%d: ���յ���Ϣ \r\n%s",m_nChannelID,pEvent->szData);
			}break;
		case BriEvent_CC_RecvedCmd:
			{
				str.Format("ͨ��%d: ���յ����� \r\n%s",m_nChannelID,pEvent->szData);
			}break;
		case BriEvent_CC_RegSuccess:
			{
				str.Format("ͨ��%d: ע��CC�ɹ� %s",m_nChannelID,pEvent->szData);
			}break;
		case BriEvent_CC_RegFailed:
			{
				str.Format("ͨ��%d: ע��CCʧ�� %s",m_nChannelID,strValue);
			}break;
		case BriEvent_CC_FindSuccess:
			{
				m_cServerAddr.SetWindowText(GetMsgValue(pEvent->szData,MSG_KEY_IP));
				str.Format("ͨ��%d: ����CC�������ɹ� %s",m_nChannelID,strValue);
			}break;
		case BriEvent_CC_FindFailed:
			{
				str.Format("ͨ��%d: ����CC������ʧ�� %s",m_nChannelID,strValue);
			}break;
		case BriEvent_CC_ModifyPwdFailed:
			{
				str.Format("ͨ��%d: �޸�����ʧ�� %s",m_nChannelID,strValue);
			}break;
		case BriEvent_CC_ModifyPwdSuccess:
			{
				str.Format("ͨ��%d: �޸�����ɹ� %s",m_nChannelID,strValue);
			}break;
		case BriEvent_CC_RecvFileRequest:
			{
				str.Format("ͨ��%d: ���յ��ļ����� %s",m_nChannelID,strValue);
				CreateFileTransfer();
				CString strCC=GetMsgValue(pEvent->szData,MSG_KEY_CC);
				CString strFile=GetMsgValue(pEvent->szData,MSG_KEY_FILENAME);
				CString strSize=GetMsgValue(pEvent->szData,MSG_KEY_FILESIZE);
				//char *lpCC=strstr((char*)(LPCTSTR)strValue,MSG_KEY_CC);
				//char *lpFile=strstr((char*)(LPCTSTR)strValue,MSG_KEY_FILENAME);
				//char *lpSize=strstr((char*)(LPCTSTR)strValue,MSG_KEY_FILESIZE);
				//strValue.Replace('\r','\0');
				//_ASSERT(lpCC && lpFile && lpSize);
				//m_pFileTransfer->RecvFileRequest(pEvent->lEventHandle,lpCC+strlen(MSG_KEY_CC),lpFile+strlen(MSG_KEY_FILENAME),atol(lpSize+strlen(MSG_KEY_FILESIZE)));
				m_pFileTransfer->RecvFileRequest(pEvent->lEventHandle,strCC,strFile,atol((char*)(LPCTSTR)strSize));
			}break;
		case BriEvent_CC_TransFileFinished:
			{
				str.Format("ͨ��%d: �����ļ����� %s",m_nChannelID,strValue);
				if(m_pFileTransfer) m_pFileTransfer->TransferFinished();
			}break;
		default:break;
		}
		if(!str.IsEmpty())
			AppendStatus(str);
	}
	return CDialog::WindowProc(message, wParam, lParam);
}

void CCCModule::AppendStatus(CString strStatus)
{
	CString str,strTime;
	CTime ct=CTime::GetCurrentTime();
	strTime.Format("[%02d:%02d:%02d] %s tick=%d",ct.GetHour(),ct.GetMinute(),ct.GetSecond(),strStatus,GetTickCount());	
	CString strSrc;
	GetDlgItem(IDC_CCSTATUS)->GetWindowText(strSrc);
	if(strSrc.GetLength() > 16000)
		strSrc .Empty();
	str=strTime+"\r\n"+strSrc;
	GetDlgItem(IDC_CCSTATUS)->SetWindowText(str);
}

void CCCModule::OnStartcall() 
{
	UpdateData(TRUE);
	//ʹ��ָ�����豸ͨ��������������
	if((m_dwCallSessID=QNV_CCCtrl_Call(QNV_CCCTRL_CALL_START,0,(char*)(LPCTSTR)m_strCallCC,GetChannelID())) == 0)
	{
		AfxMessageBox("����ʧ��");
	}else
	{
		AppendStatus("��ʼ����"+m_strCallCC);
	}
}

void CCCModule::OnStopcall() 
{
	if(m_dwCallSessID > 0)
	{
		QNV_CCCtrl_Call(QNV_CCCTRL_CALL_STOP,m_dwCallSessID,NULL,0);
		m_dwCallSessID= 0;
		AppendStatus("ֹͣ����");
	}	
}

void CCCModule::OnAnswer() 
{
	if(m_dwCallSessID > 0)
	{//ʹ��ָ�����豸ͨ��������������
		QNV_CCCtrl_Call(QNV_CCCTRL_CALL_ACCEPT,m_dwCallSessID,NULL,GetChannelID());
	}else
	{
		AfxMessageBox("û�к��� refuse");
	}
}

void CCCModule::OnRefuse() 
{
	if(m_dwCallSessID > 0)
	{
		QNV_CCCtrl_Call(QNV_CCCTRL_CALL_REFUSE,m_dwCallSessID,NULL,0);
	}else
	{
		AfxMessageBox("û�к��� refuse");
	}	
}

void CCCModule::OnSendmsg() 
{
	UpdateData(TRUE);
	if(m_strMsgText.IsEmpty())
	{
		AfxMessageBox("���ܷ��Ϳ���Ϣ");
		return;
	}
	QNV_CCCtrl_Msg(QNV_CCCTRL_MSG_SENDMSG,(char*)(LPCTSTR)m_strCallCC,(char*)(LPCTSTR)m_strMsgText,NULL,0);
}

void CCCModule::OnSendcmd() 
{
	UpdateData(TRUE);
	if(m_strMsgText.IsEmpty())
	{
		AfxMessageBox("���ܷ��Ϳ�����");
		return;
	}
	QNV_CCCtrl_Msg(QNV_CCCTRL_MSG_SENDCMD,(char*)(LPCTSTR)m_strCallCC,(char*)(LPCTSTR)m_strMsgText,NULL,0);
}

void CCCModule::OnRegcc() 
{
	UpdateData(TRUE);
	if(m_strCCNum.IsEmpty())
	{
		AfxMessageBox("CC���벻��Ϊ��");
		return ;
	}
	if(m_strRegPwd.IsEmpty())
	{
		AfxMessageBox("CC���벻��Ϊ��");
		return ;
	}
	if(m_strRegNick.IsEmpty())
	{
		AfxMessageBox("�ǳƲ���Ϊ��");
		return ;
	}
	CString strValue=m_strCCNum+","+m_strRegPwd+","+m_strRegNick+","+m_strSvrID;
	if(QNV_CCCtrl(QNV_CCCTRL_REGCC,(char*)(LPCTSTR)strValue,0) <= 0)
	{
		AfxMessageBox("ע��ʧ��");
	}
}

void CCCModule::OnSetserver() 
{
	UpdateData(TRUE);
	if(QNV_CCCtrl(QNV_CCCTRL_SETSERVER,(char*)(LPCTSTR)m_strServerAddr,0) <= 0)
	{
		AfxMessageBox("�޸�ʧ��");
	}else
	{
		AppendStatus("�޸ķ�������ַ��� "+m_strServerAddr);
	}
}

BOOL CCCModule::OnCommand(WPARAM wParam, LPARAM lParam) 
{
	if(wParam == ID_MENU_FIELTRANSFER)
	{
		CreateFileTransfer();
	}
	return CDialog::OnCommand(wParam, lParam);
}

BOOL	CCCModule::CreateFileTransfer()
{
	if(!m_pFileTransfer)
	{
		m_pFileTransfer= new CFileTransfer();
		m_pFileTransfer->Create(CFileTransfer::IDD,this);
		m_pFileTransfer->ShowWindow(SW_SHOW);
	}
	return TRUE;
}

BOOL	CCCModule::CloseFileTransfer()
{
	if(m_pFileTransfer)
	{
		m_pFileTransfer->FreeSource();
		delete m_pFileTransfer;
		m_pFileTransfer=NULL;
	}
	return TRUE;
}

void CCCModule::OnFindsvr() 
{
	QNV_CCCtrl(QNV_CCCTRL_STARTFINDSERVER,"255.255.255.255",10088);//ֻ�㲥	
	//QNV_CCCtrl(QNV_CCCTRL_STARTFINDSERVER,"0.0.0.0",10088);//ֻ��ѭ
	//QNV_CCCtrl(QNV_CCCTRL_STARTFINDSERVER,NULL,10088);//�㲥+��ѭ
	//QNV_CCCtrl(QNV_CCCTRL_STARTFINDSERVER,"192.168.0.6 192.168.0.7",10088);//ָ��IP��ѯ
}

void CCCModule::OnModifypwd() 
{
//���벻��ʹ��','
	UpdateData(TRUE);
	CString strPwd=m_strOldPwd+","+m_strNewPwd;
	long lRet=QNV_CCCtrl(QNV_CCCTRL_MODIFYPWD,(char*)(LPCTSTR)strPwd,0);
	if(lRet == BCERR_INVALIDPWD)
	{
		AfxMessageBox("���������");
	}else if(lRet <= 0)
		AfxMessageBox("ʧ��");

}
