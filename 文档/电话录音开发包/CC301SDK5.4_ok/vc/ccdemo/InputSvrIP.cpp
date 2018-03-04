// InputSvrIP.cpp : implementation file
//

#include "stdafx.h"
#include "ccdemo.h"
#include "InputSvrIP.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CInputSvrIP dialog


CInputSvrIP::CInputSvrIP(CWnd* pParent /*=NULL*/)
	: CDialog(CInputSvrIP::IDD, pParent)
{
	//{{AFX_DATA_INIT(CInputSvrIP)
	m_strSvrIP = _T("");
	//}}AFX_DATA_INIT
}


void CInputSvrIP::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CInputSvrIP)
	DDX_Text(pDX, IDC_SVRIP, m_strSvrIP);
	DDV_MaxChars(pDX, m_strSvrIP, 64);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CInputSvrIP, CDialog)
	//{{AFX_MSG_MAP(CInputSvrIP)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CInputSvrIP message handlers

BOOL CInputSvrIP::OnInitDialog() 
{
	CDialog::OnInitDialog();
		
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CInputSvrIP::OnCancel() 
{	
	CDialog::OnCancel();
}

void CInputSvrIP::OnOK() 
{
	UpdateData(TRUE);
	CDialog::OnOK();
}
