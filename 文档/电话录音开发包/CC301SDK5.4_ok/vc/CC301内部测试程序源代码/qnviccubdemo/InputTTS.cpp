// InputTTS.cpp : implementation file
//

#include "stdafx.h"
#include "qnviccubdemo.h"
#include "InputTTS.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CInputTTS dialog


CInputTTS::CInputTTS(CWnd* pParent /*=NULL*/)
	: CDialog(CInputTTS::IDD, pParent)
{
	//{{AFX_DATA_INIT(CInputTTS)
	m_strTTS = _T("ÄãºÃ<19900>»¶Ó­1234567890»¶Ó­<100000000>ÄãºÃ<50001>");
	//}}AFX_DATA_INIT
}


void CInputTTS::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CInputTTS)
	DDX_Text(pDX, IDC_TTS, m_strTTS);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CInputTTS, CDialog)
	//{{AFX_MSG_MAP(CInputTTS)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CInputTTS message handlers


BOOL CInputTTS::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	UpdateData(FALSE);
	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CInputTTS::OnOK() 
{
	UpdateData(TRUE);
	if(m_strTTS.IsEmpty())
	{
		AfxMessageBox("×Ö·û²»ÄÜÎª¿Õ");
		return;
	}
	
	CDialog::OnOK();
}
