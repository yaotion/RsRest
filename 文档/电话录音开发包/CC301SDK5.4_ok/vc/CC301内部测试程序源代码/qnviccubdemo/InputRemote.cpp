// InputRemote.cpp : implementation file
//

#include "stdafx.h"
#include "qnviccubdemo.h"
#include "InputRemote.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CInputRemote dialog


CInputRemote::CInputRemote(CWnd* pParent /*=NULL*/)
	: CDialog(CInputRemote::IDD, pParent)
{
	//{{AFX_DATA_INIT(CInputRemote)
	m_strRemoteFile = _T("http://");
	//}}AFX_DATA_INIT
}


void CInputRemote::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CInputRemote)
	DDX_Control(pDX, IDC_REMOTEFILE, m_cRemoteFile);
	DDX_Text(pDX, IDC_REMOTEFILE, m_strRemoteFile);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CInputRemote, CDialog)
	//{{AFX_MSG_MAP(CInputRemote)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CInputRemote message handlers

BOOL CInputRemote::OnInitDialog() 
{
	CDialog::OnInitDialog();
		
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CInputRemote::OnOK() 
{
	UpdateData(TRUE);
	if(m_strRemoteFile.IsEmpty())
	{
		m_cRemoteFile.SetFocus();
		AfxMessageBox("文件不能为空");
		return;
	}
	CDialog::OnOK();
}
