// CCMsg.cpp : implementation file
//

#include "stdafx.h"
#include "ccdemo.h"
#include "CCMsg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CCCMsg dialog


CCCMsg::CCCMsg(CWnd* pParent /*=NULL*/)
	: CDialog(CCCMsg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CCCMsg)
	m_strDestCC = _T("");
	m_strSendView = _T("");
	//}}AFX_DATA_INIT
}


void CCCMsg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CCCMsg)
	DDX_Control(pDX, IDC_CCSENDVIEW, m_cSendView);
	DDX_Control(pDX, IDC_DESTCC, m_cDestCC);
	DDX_Text(pDX, IDC_DESTCC, m_strDestCC);
	DDV_MaxChars(pDX, m_strDestCC, 18);
	DDX_Text(pDX, IDC_CCSENDVIEW, m_strSendView);
	DDV_MaxChars(pDX, m_strSendView, 400);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CCCMsg, CDialog)
	//{{AFX_MSG_MAP(CCCMsg)
	ON_BN_CLICKED(IDC_SENDMSG, OnSendmsg)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CCCMsg message handlers

BOOL CCCMsg::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CCCMsg::FreeSource()
{

}

long CCCMsg::AppendRecvMsg(CString strMsg)
{
	CMsgParse parse(strMsg);
	CString strCC=parse.GetParam(MSG_KEY_CC);//cc����
	CString strNick=parse.GetParam(MSG_KEY_NAME);//�ǳ�
	long lTime=atol((LPCTSTR)parse.GetParam(MSG_KEY_TIME));//ʱ��
	m_cDestCC.SetWindowText(strCC);
	AppendRecvView(strCC,strNick,parse.GetMsgText(),lTime);
	return 1;	
}

void CCCMsg::OnCancel() 
{	
	ShowWindow(SW_HIDE);//ֻ���ز�����(Ҫ���پͻص���Ϣ��������)
	//CDialog::OnCancel();
}

void CCCMsg::OnSendmsg() 
{
	UpdateData(TRUE);
	if(m_strDestCC.IsEmpty())
	{
		m_cDestCC.SetFocus();
		AfxMessageBox("Ŀ��CC����Ϊ��");
		return;
	}
	if(m_strSendView.IsEmpty())
	{
		m_cSendView.SetFocus();
		AfxMessageBox("�������ݲ���Ϊ��");
		return;
	}
	if(QNV_CCCtrl_Msg(QNV_CCCTRL_MSG_SENDMSG,(char*)(LPCTSTR)m_strDestCC,(char*)(LPCTSTR)m_strSendView,NULL,0) <= 0)
	{
		AfxMessageBox("������Ϣʧ��");
	}else
	{
		char szCC[32]={0};
		char szNick[64]={0};
		QNV_CCCtrl_CCInfo(QNV_CCCTRL_CCINFO_OWNERCC,0,szCC,32);//����CC
		QNV_CCCtrl_CCInfo(QNV_CCCTRL_CCINFO_NICK,szCC,szNick,64);//�����ǳ�,����ʹ��szCC����Ϊ��QNV_CCCtrl_CCInfo(QNV_CCCTRL_CONTACTINFO_NICK,NULL,szNick,64);
		AppendRecvView(szCC,szNick,m_strSendView,CTime::GetCurrentTime().GetTime());
		m_cSendView.SetWindowText("");
		m_cSendView.SetFocus();
	}
}

long	CCCMsg::AppendRecvView(LPCTSTR lpVID,LPCTSTR lpNick,LPCTSTR lpMsg,long lTime)
{
	CTime ct(lTime);
	CString str,strSrc,strNew;
	str.Format("%s [%s] %02d:%02d\r\n  %s\r\n",lpVID,lpNick,ct.GetHour(),ct.GetMinute(),lpMsg);
	GetDlgItem(IDC_CCRECVVIEW)->GetWindowText(strSrc);
	strNew = strSrc+str;
	GetDlgItem(IDC_CCRECVVIEW)->SetWindowText(strNew);
	((CEdit*)GetDlgItem(IDC_CCRECVVIEW))->SetFocus();
	((CEdit*)GetDlgItem(IDC_CCRECVVIEW))->SetSel(-1,-1);	
	return 1;
}

