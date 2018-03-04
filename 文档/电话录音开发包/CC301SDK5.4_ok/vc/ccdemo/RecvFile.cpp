// RecvFile.cpp : implementation file
//

#include "stdafx.h"
#include "ccdemo.h"
#include "RecvFile.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CRecvFile dialog


CRecvFile::CRecvFile(CWnd* pParent /*=NULL*/)
	: CDialog(CRecvFile::IDD, pParent)
{
	//{{AFX_DATA_INIT(CRecvFile)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}


void CRecvFile::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CRecvFile)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CRecvFile, CDialog)
	//{{AFX_MSG_MAP(CRecvFile)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CRecvFile message handlers

BOOL CRecvFile::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}
