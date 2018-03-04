// InputIP.cpp : implementation file
//

#include "stdafx.h"
#include "qnviccubdemo.h"
#include "InputIP.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CInputIP dialog


CInputIP::CInputIP(CWnd* pParent /*=NULL*/)
	: CDialog(CInputIP::IDD, pParent)
{
	//{{AFX_DATA_INIT(CInputIP)
	m_strIPAddr = _T("");
	//}}AFX_DATA_INIT
}


void CInputIP::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CInputIP)
	DDX_Text(pDX, IDC_IPADDR, m_strIPAddr);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CInputIP, CDialog)
	//{{AFX_MSG_MAP(CInputIP)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CInputIP message handlers


BOOL CInputIP::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	// TODO: Add extra initialization here
	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CInputIP::OnOK() 
{
	UpdateData(TRUE);
	if(m_strIPAddr.IsEmpty())
	{
		AfxMessageBox("IP地址不能为空");
		return;
	}
	CDialog::OnOK();
}
