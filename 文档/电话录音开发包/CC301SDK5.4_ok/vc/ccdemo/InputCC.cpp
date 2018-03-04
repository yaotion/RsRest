// InputCC.cpp : implementation file
//

#include "stdafx.h"
#include "ccdemo.h"
#include "InputCC.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CInputCC dialog


CInputCC::CInputCC(CWnd* pParent /*=NULL*/)
	: CDialog(CInputCC::IDD, pParent)
{
	//{{AFX_DATA_INIT(CInputCC)
	m_strCC = _T("");
	//}}AFX_DATA_INIT
}


void CInputCC::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CInputCC)
	DDX_Text(pDX, IDC_CC, m_strCC);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CInputCC, CDialog)
	//{{AFX_MSG_MAP(CInputCC)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CInputCC message handlers

void CInputCC::OnOK() 
{
	UpdateData(TRUE);
	if(m_strCC.IsEmpty())
	{
		AfxMessageBox("CC²»ÄÜÎª¿Õ");
		return;
	}	
	CDialog::OnOK();
}

LRESULT CInputCC::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	// TODO: Add your specialized code here and/or call the base class
	
	return CDialog::WindowProc(message, wParam, lParam);
}

BOOL CInputCC::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	// TODO: Add extra initialization here
	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}
