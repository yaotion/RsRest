// RegCC.cpp : implementation file
//

#include "stdafx.h"
#include "ccdemo.h"
#include "RegCC.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CRegCC dialog


CRegCC::CRegCC(CWnd* pParent /*=NULL*/)
	: CDialog(CRegCC::IDD, pParent)
{
	//{{AFX_DATA_INIT(CRegCC)
	m_strRegCC = _T("");
	m_strRegNick = _T("");
	m_strRegPwd = _T("");
	m_strSvrID = _T("");
	//}}AFX_DATA_INIT
}


void CRegCC::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CRegCC)
	DDX_Text(pDX, IDC_REGCCNUM, m_strRegCC);
	DDV_MaxChars(pDX, m_strRegCC, 18);
	DDX_Text(pDX, IDC_REGNICK, m_strRegNick);
	DDV_MaxChars(pDX, m_strRegNick, 16);
	DDX_Text(pDX, IDC_REGPWD, m_strRegPwd);
	DDV_MaxChars(pDX, m_strRegPwd, 16);
	DDX_Text(pDX, IDC_SVRID, m_strSvrID);
	DDV_MaxChars(pDX, m_strSvrID, 32);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CRegCC, CDialog)
	//{{AFX_MSG_MAP(CRegCC)
	ON_BN_CLICKED(IDC_REG, OnReg)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CRegCC message handlers

BOOL CRegCC::OnInitDialog() 
{
	CDialog::OnInitDialog();	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CRegCC::OnCancel() 
{
	
	CDialog::OnCancel();
}

void CRegCC::OnReg() 
{
	UpdateData(TRUE);
	if(m_strRegCC.IsEmpty())
	{
		AfxMessageBox("CC号码不能为空");
		return ;
	}
	if(m_strRegCC.Find(",") >= 0)// 不能输入','
	{
		AfxMessageBox("CC不能有逗号");
		return;
	}

	if(m_strRegPwd.IsEmpty())
	{
		AfxMessageBox("CC密码不能为空");
		return ;
	}
	if(m_strRegPwd.Find(",") >= 0)// 不能输入','
	{
		AfxMessageBox("CC密码不能有逗号");
		return;
	}

	if(m_strRegNick.IsEmpty()) 
	{
		AfxMessageBox("昵称不能为空");
		return ;
	}
	if(m_strRegNick.Find(",") >= 0)// 不能输入','
	{
		AfxMessageBox("昵称不能有逗号");
		return;
	}

	if(m_strSvrID.Find(",") >= 0)// 不能输入','
	{
		AfxMessageBox("设备号不能有逗号");
		return;
	}
	CDialog::OnOK();
}
