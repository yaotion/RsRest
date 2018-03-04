// CCCall.cpp : implementation file
//

#include "stdafx.h"
#include "ccdemo.h"
#include "CCCall.h"
#include "inputcc.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CCCCall dialog


CCCCall::CCCCall(CWnd* pParent /*=NULL*/)
	: CDialog(CCCCall::IDD, pParent)
{
	//{{AFX_DATA_INIT(CCCCall)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}


void CCCCall::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CCCCall)
	DDX_Control(pDX, IDC_REFUSE, m_cRefuse);
	DDX_Control(pDX, IDC_ANSWER, m_cAnswer);
	DDX_Control(pDX, IDC_BUSY, m_cBusy);
	DDX_Control(pDX, IDC_CALLLIST, m_CallList);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CCCCall, CDialog)
	//{{AFX_MSG_MAP(CCCCall)
	ON_BN_CLICKED(IDC_ANSWER, OnAnswer)
	ON_BN_CLICKED(IDC_REFUSE, OnRefuse)
	ON_BN_CLICKED(IDC_BUSY, OnBusy)
	ON_BN_CLICKED(IDC_STOP, OnStop)
	ON_BN_CLICKED(IDC_STARTPLAYFILE, OnStartplayfile)
	ON_BN_CLICKED(IDC_STOPPLAYFILE, OnStopplayfile)
	ON_BN_CLICKED(IDC_STARTRECORDFILE, OnStartrecordfile)
	ON_BN_CLICKED(IDC_STOPFILERECORD, OnStopfilerecord)
	ON_BN_CLICKED(IDC_HOLD, OnHold)
	ON_BN_CLICKED(IDC_UNHOLD, OnUnhold)
	ON_BN_CLICKED(IDC_SWITCH, OnSwitch)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CCCCall message handlers

BOOL CCCCall::OnInitDialog() 
{
	CDialog::OnInitDialog();		
	//�����ڻ�ȡ�����¼�
	QNV_Event(CCCTRL_CHANNELID,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);
	InitList();
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void	CCCCall::FreeSource()
{
	m_CallList.DeleteAllItems();
}

void CCCCall::OnCancel() 
{
	ShowWindow(SW_HIDE);//ֻ���ز�����(Ҫ���پͻص���Ϣ��������)
	//CDialog::OnCancel();
}

long	CCCCall::InitList()
{
	long lCoumnCount=0;	
	m_CallList.InsertColumn(lCoumnCount++,"CC",LVCFMT_LEFT,150);
	m_CallList.InsertColumn(lCoumnCount++,"�ǳ�",LVCFMT_LEFT,150);
	m_CallList.InsertColumn(lCoumnCount++,"��������",LVCFMT_LEFT,64);	
	m_CallList.InsertColumn(lCoumnCount++,"״̬",LVCFMT_LEFT,64);	
	m_CallList.InsertColumn(lCoumnCount++," ",LVCFMT_LEFT,120);	
	m_CallList.SetExtendedStyle(m_CallList.GetExtendedStyle()|(LVS_EX_FULLROWSELECT | LVS_EX_SUBITEMIMAGES|LVS_EX_GRIDLINES));
	return 1;
}


long	CCCCall::AppendCallIn(DWORD dwHandle,CString  strData)
{
	CMsgParse parse(strData);
	CString strCC=parse.GetParam(MSG_KEY_CC);//cc����
	CString strNick=parse.GetParam(MSG_KEY_NAME);//�ǳ�
	return AppendCallList(strCC,strNick,"����","���ں���",dwHandle);
}
 
long CCCCall::CallCC(LPCTSTR lpCC)
{
	DWORD dwHandle=QNV_CCCtrl_Call(QNV_CCCTRL_CALL_START,0,(char*)lpCC,0);
	if(dwHandle == 0)
	{
		AppendStatus("����CCʧ��");
		return 0;
	}else
	{
		AppendStatus("��ʼ����CC");
		AppendCallList(lpCC,"","ȥ��","��ʼ����",dwHandle);
		return 1;
	}	
}

long	CCCCall::AppendCallList(LPCTSTR lpCC,LPCTSTR lpNick,LPCTSTR lpCallType,LPCTSTR lpState,DWORD dwHandle)
{
	int L=0;//0->׷������ǰ�� m_CallList.GetItemCount()->׷�ӵ������
	m_CallList.InsertItem(L,lpCC);
	m_CallList.SetItemText(L,1,lpNick);
	m_CallList.SetItemText(L,2,lpCallType);
	m_CallList.SetItemText(L,3,lpState);
	m_CallList.SetItemData(L,dwHandle);
	return L;
}

long	CCCCall::GetHandleItem(DWORD dwHandle)
{
	for(int i=0;i<m_CallList.GetItemCount();i++)
	{
		if(m_CallList.GetItemData(i) == dwHandle) return i;
	}
	return -1;
}

CString	CCCCall::GetCallErr(int iErrID)
{
	switch(iErrID)
	{
	case TMMERR_USEROFFLINE:return "�û�������";
	case TMMERR_INVALIDUSER:return "���벻�Ϸ�";
	case TMMERR_VOIPCONNECTFAILED:return "����VOIP������ʧ��";
	case TMMERR_VOIPACCOUNTFAILED:return "VOIP�ʻ�����/����";
	case TMMERR_CANCEL:return "�Լ�ȡ����ǰ��������";
	case TMMERR_CLIENTCANCEL:return "�Է�ȡ����ǰ��������";
	case TMMERR_REFUSE:return "�ܾ��Է�����";
	case TMMERR_CLIENTREFUSE:return "�Է��ܾ�����";
	case TMMERR_STOP:return "�Լ�ֹͣ��������(�ѽ�ͨ)";
	case TMMERR_CLIENTSTOP:return "�Է�ֹͣ��������(�ѽ�ͨ)";
	default:break;
	}
	return "δ֪����";
}

LRESULT CCCCall::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	if(message == BRI_EVENT_MESSAGE)//���յ��¼�
	{
		PBRI_EVENT pEvent=(PBRI_EVENT)lParam;//��ȡ�¼����ݽṹ
		CString strValue,str;
		strValue.Format("Handle=%d Result=%d Data=%s",pEvent->lEventHandle,pEvent->lResult,pEvent->szData);
		CMsgParse parse(pEvent->szData);
		switch(pEvent->lEventType)
		{	
		case BriEvent_CC_CallIn:
			{
				AppendCallIn(pEvent->lEventHandle,pEvent->szData);
				ShowWindow(SW_SHOW);
			}break;
		case BriEvent_CC_CallOutSuccess:
			{
				str.Format("���ں���... %s",strValue);
				long L=GetHandleItem(pEvent->lEventHandle);
				if(L >= 0)
				{					
					m_CallList.SetItemText(L,3,"���ں���");
				}
			}break;
		case BriEvent_CC_CallOutFailed:
			{
				str.Format("����ʧ�� ʧ��ԭ��=%s %s",GetCallErr(pEvent->lResult),strValue);
				long L=GetHandleItem(pEvent->lEventHandle);
				if(L >= 0) m_CallList.DeleteItem(L);//ɾ���б�
			}break;
		case BriEvent_CC_Connected:
			{
				str.Format("CC�Ѿ���ͨ %s",strValue);
				long L=GetHandleItem(pEvent->lEventHandle);
				if(L >= 0) m_CallList.SetItemText(L,3,"����ͨ");
			}break;
		case BriEvent_CC_CallFinished:
			{
				str.Format("���н��� ԭ��=%s  %s",GetCallErr(pEvent->lResult),strValue);
				long L=GetHandleItem(pEvent->lEventHandle);
				if(L >= 0) m_CallList.DeleteItem(L);//ɾ���б�
			}break;
		case BriEvent_CC_GetDTMF:
			{
				str.Format("���յ��Է����� %s",strValue);
				long L=GetHandleItem(pEvent->lEventHandle);
				if(L >= 0) m_CallList.SetItemText(L,4,"���յ��Է�����:"+parse.GetMsgText());				
			}break;
		case BriEvent_CC_PlayFileEnd:
			{
				str.Format("�����ļ����� %s",strValue);
				long L=GetHandleItem(pEvent->lEventHandle);
				if(L >= 0) m_CallList.SetItemText(L,4,"�����ļ�����");				
			}break;
		}
		if(!str.IsEmpty())
			AppendStatus(str);
	}
	return CDialog::WindowProc(message, wParam, lParam);
}

//��ʾ��ʾ״̬�ı�
void CCCCall::AppendStatus(CString strStatus)
{
	CString str,strTime;
	CTime ct=CTime::GetCurrentTime();
	strTime.Format("[%02d:%02d:%02d] %s tick=%d",ct.GetHour(),ct.GetMinute(),ct.GetSecond(),strStatus,GetTickCount());	
	CString strSrc;
	GetDlgItem(IDC_CALLSTATUS)->GetWindowText(strSrc);
	if(strSrc.GetLength() > 16000)
		strSrc .Empty();
	str=strTime+"\r\n"+strSrc;
	GetDlgItem(IDC_CALLSTATUS)->SetWindowText(str);
}

long CCCCall::GetFirstSelectedItem()
{
	POSITION pos=m_CallList.GetFirstSelectedItemPosition();
	if (pos == NULL) return -1;
	return m_CallList.GetNextSelectedItem(pos);	
}

void CCCCall::OnAnswer() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("��ѡ�����ļ�¼");
	}else
	{
		DWORD dwHandle=m_CallList.GetItemData(L);
		if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_ACCEPT,dwHandle,NULL,-1) <= 0)
			AfxMessageBox("����ʧ��");
	}
}

void CCCCall::OnRefuse() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("��ѡ�����ļ�¼");
	}else
	{
		DWORD dwHandle=m_CallList.GetItemData(L);
		if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_REFUSE,dwHandle,NULL,-1) <= 0)
			AfxMessageBox("�ܾ�ʧ��");
	}	
}

void CCCCall::OnBusy() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("��ѡ�����ļ�¼");
	}else
	{
		DWORD dwHandle=m_CallList.GetItemData(L);
		if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_BUSY,dwHandle,NULL,-1) <= 0)
			AfxMessageBox("�ظ�æʧ��");
	}		
}

void CCCCall::OnStop() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("��ѡ���¼");
	}else
	{
		DWORD dwHandle=m_CallList.GetItemData(L);
		if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_STOP	,dwHandle,NULL,-1) <= 0)
			AfxMessageBox("ֹͣʧ��");
	}	
}

CString CCCCall::SelectFilePath(int iType)
{
	CString strDestPath;
	char szFile[260];       // buffer for filename
	OPENFILENAME ofn;
	memset(szFile,0,sizeof(szFile));
	ZeroMemory(&ofn, sizeof(OPENFILENAME));
	ofn.lStructSize = sizeof(OPENFILENAME);
	ofn.hwndOwner = AfxGetMainWnd()->GetSafeHwnd();
	ofn.lpstrFile = szFile;
	ofn.nMaxFile = sizeof(szFile);
	
	ofn.nFilterIndex = 1;
	ofn.lpstrFileTitle = NULL;
	ofn.nMaxFileTitle = 0;
	
	ofn.lpstrInitialDir = NULL;
	ofn.Flags = OFN_PATHMUSTEXIST | OFN_FILEMUSTEXIST|OFN_OVERWRITEPROMPT;
	
	ofn.lpstrFilter = "wav file\0*.wav;*.pcm;*.wave\0All file\0*.*\0";
	ofn.lpstrDefExt = ".wav";
	
	if(iType == 0)
	{
		if(::GetSaveFileName(&ofn))
		{
			strDestPath = szFile;
		}
	}else 
	{
		if(::GetOpenFileName(&ofn))
		{
			strDestPath = szFile;			
		}
	}
	if(!strDestPath.IsEmpty() && strDestPath.Find(".") < 0) strDestPath+=ofn.lpstrDefExt;
	return strDestPath;
}


void CCCCall::OnStartplayfile() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("��ѡ���¼");
	}else
	{
		CString strFilePath=SelectFilePath(1);
		if(!strFilePath.IsEmpty())
		{
			DWORD dwHandle=m_CallList.GetItemData(L);
			if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_STARTPLAYFILE,dwHandle,(char*)(LPCTSTR)strFilePath,1) <= 0)
				AfxMessageBox("��ʼ�����ļ�ʧ��");
			else
				AppendStatus("��ʼ�����ļ�");
		}
	}
}

void CCCCall::OnStopplayfile() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("��ѡ���¼");
	}else
	{
		DWORD dwHandle=m_CallList.GetItemData(L);
		if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_STOPPLAYFILE,dwHandle,NULL,-1) <= 0)
			AfxMessageBox("ֹͣ�����ļ�");
		else
			AppendStatus("ֹͣ�����ļ�");
	}		
}

void CCCCall::OnStartrecordfile() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("��ѡ���¼");
	}else
	{
		CString strFilePath=SelectFilePath(0);
		if(!strFilePath.IsEmpty())
		{
		DWORD dwHandle=m_CallList.GetItemData(L);
		if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_STARTRECFILE,dwHandle,(char*)(LPCTSTR)strFilePath,-1) <= 0)
			AfxMessageBox("��ʼ�ļ�¼��ʧ��");
		else
			AppendStatus("��ʼ�ļ�¼��");
		}
	}	
}

void CCCCall::OnStopfilerecord() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("��ѡ���¼");
	}else
	{
		DWORD dwHandle=m_CallList.GetItemData(L);
		if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_STOPRECFILE,dwHandle,NULL,-1) <= 0)
			AfxMessageBox("ֹͣ�ļ�¼��");
		else
			AppendStatus("ֹͣ�ļ�¼��");
	}			
}

void CCCCall::OnHold() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("��ѡ���¼");
	}else
	{
		DWORD dwHandle=m_CallList.GetItemData(L);
		if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_HOLD,dwHandle,NULL,-1) <= 0)
			AfxMessageBox("����ͨ��ʧ��");
		else
			AppendStatus("����ͨ��");
	}		
}

void CCCCall::OnUnhold() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("��ѡ���¼");
	}else
	{
		DWORD dwHandle=m_CallList.GetItemData(L);
		if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_UNHOLD	,dwHandle,NULL,-1) <= 0)
			AfxMessageBox("�ָ�ͨ��ʧ��");
		else
			AppendStatus("�ָ�ͨ��");
	}		
}

void CCCCall::OnSwitch() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("��ѡ���¼");
	}else
	{
		CInputCC input;
		if(input.DoModal() == IDOK)
		{
		DWORD dwHandle=m_CallList.GetItemData(L);
		if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_SWITCH,dwHandle,(char*)(LPCTSTR)input.m_strCC,0) <= 0)
			AfxMessageBox("����ת��ʧ��");
		}
	}		
}
