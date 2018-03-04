// LoginCC.cpp : implementation file
//

#include "stdafx.h"
#include "ccdemo.h"
#include "LoginCC.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CLoginCC dialog


CLoginCC::CLoginCC(CWnd* pParent /*=NULL*/)
	: CDialog(CLoginCC::IDD, pParent)
{
	//{{AFX_DATA_INIT(CLoginCC)
	m_strCCNumber = _T("");
	m_strCCPwd = _T("");
	//}}AFX_DATA_INIT
}


void CLoginCC::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CLoginCC)
	DDX_Text(pDX, IDC_CCNUMBER, m_strCCNumber);
	DDX_Text(pDX, IDC_CCPWD, m_strCCPwd);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CLoginCC, CDialog)
	//{{AFX_MSG_MAP(CLoginCC)
	ON_BN_CLICKED(IDC_LOGON, OnLogon)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CLoginCC message handlers


BOOL CLoginCC::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CLoginCC::OnLogon() 
{
	UpdateData(TRUE);
	if(m_strCCNumber.IsEmpty())
	{
		AfxMessageBox("CC号码不能为空");
		return;
	}
	if(m_strCCPwd.IsEmpty())
	{
		AfxMessageBox("密码不能为空");
		return;
	}
	if(m_strCCPwd.Find(",") >= 0)
	{
		AfxMessageBox("密码不能有','");
		return;
	}
	CDialog::OnOK();
}
