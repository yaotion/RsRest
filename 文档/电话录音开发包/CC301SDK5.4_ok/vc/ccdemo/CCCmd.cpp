// CCCmd.cpp : implementation file
//

#include "stdafx.h"
#include "ccdemo.h"
#include "CCCmd.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CCCCmd dialog


CCCCmd::CCCCmd(CWnd* pParent /*=NULL*/)
	: CDialog(CCCCmd::IDD, pParent)
{
	//{{AFX_DATA_INIT(CCCCmd)
	m_strRecvCmd = _T("");
	m_strDestCC = _T("");
	m_strSendCmd = _T("");
	//}}AFX_DATA_INIT
}


void CCCCmd::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CCCCmd)
	DDX_Control(pDX, IDC_CCRECVCMD, m_cRecvCmd);
	DDX_Control(pDX, IDC_CCSENDCMD, m_cSendCmd);
	DDX_Control(pDX, IDC_DESTCC, m_cDestCC);
	DDX_Text(pDX, IDC_CCRECVCMD, m_strRecvCmd);
	DDX_Text(pDX, IDC_DESTCC, m_strDestCC);
	DDV_MaxChars(pDX, m_strDestCC, 18);
	DDX_Text(pDX, IDC_CCSENDCMD, m_strSendCmd);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CCCCmd, CDialog)
	//{{AFX_MSG_MAP(CCCCmd)
	ON_BN_CLICKED(IDC_SENDCMD, OnSendcmd)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CCCCmd message handlers

BOOL CCCCmd::OnInitDialog() 
{
	CDialog::OnInitDialog();	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CCCCmd::OnCancel() 
{	
	ShowWindow(SW_HIDE);//只隐藏不销毁(要销毁就回调消息给主窗口)
	//CDialog::OnCancel();
}

void	CCCCmd::FreeSource()
{

}


long	CCCCmd::AppendRecvCmd(CString strCmd)
{
	CMsgParse parse(strCmd);
	CString strCC=parse.GetParam(MSG_KEY_CC);//cc号码
	CString strNick=parse.GetParam(MSG_KEY_NAME);//昵称
	m_cDestCC.SetWindowText(strCC);
	AppendRecvCmd(strCC,strNick,parse.GetMsgText());
	return 1;
}

void CCCCmd::OnSendcmd() 
{
	UpdateData(TRUE);
	if(m_strDestCC.IsEmpty())
	{
		m_cDestCC.SetFocus();
		AfxMessageBox("目标CC不能为空");
		return;
	}
	if(m_strSendCmd.IsEmpty())
	{
		m_cSendCmd.SetFocus();
		AfxMessageBox("发送内容不能为空");
		return;
	}
	if(QNV_CCCtrl_Msg(QNV_CCCTRL_MSG_SENDCMD,(char*)(LPCTSTR)m_strDestCC,(char*)(LPCTSTR)m_strSendCmd,NULL,((CButton*)GetDlgItem(IDC_AUTOSAVE))->GetCheck()) <= 0)
	{
		AfxMessageBox("发送消息失败");
	}else
	{
		char szCC[32]={0};
		char szNick[64]={0};
		QNV_CCCtrl_CCInfo(QNV_CCCTRL_CCINFO_OWNERCC,0,szCC,32);//本人CC
		QNV_CCCtrl_CCInfo(QNV_CCCTRL_CCINFO_NICK,szCC,szNick,64);//本人昵称,可以使用szCC或者为空QNV_CCCtrl_CCInfo(QNV_CCCTRL_CONTACTINFO_NICK,NULL,szNick,64);
		AppendRecvCmd(szCC,szNick,m_strSendCmd);
		m_cSendCmd.SetWindowText("");
		m_cSendCmd.SetFocus();
	}	
}

long	CCCCmd::AppendRecvCmd(LPCTSTR lpVID,LPCTSTR lpNick,LPCTSTR lpMsg)
{	
	CString str,strSrc,strNew;
	str.Format("%s [%s]\r\n  %s\r\n",lpVID,lpNick,lpMsg);
	GetDlgItem(IDC_CCRECVCMD)->GetWindowText(strSrc);
	strNew = strSrc+str;
	GetDlgItem(IDC_CCRECVCMD)->SetWindowText(strNew);
	((CEdit*)GetDlgItem(IDC_CCRECVCMD))->SetFocus();
	((CEdit*)GetDlgItem(IDC_CCRECVCMD))->SetSel(-1,-1);	
	return 1;
}

