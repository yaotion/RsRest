// SendFile.cpp : implementation file
//

#include "stdafx.h"
#include "ccdemo.h"
#include "SendFile.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CSendFile dialog


CSendFile::CSendFile(CWnd* pParent /*=NULL*/)
	: CDialog(CSendFile::IDD, pParent)
{
	//{{AFX_DATA_INIT(CSendFile)
	m_strDestCC = _T("");
	m_strFilePath = _T("");
	//}}AFX_DATA_INIT
}


void CSendFile::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CSendFile)
	DDX_Control(pDX, IDC_FIELPATH, m_cFilePath);
	DDX_Text(pDX, IDC_DESTCC, m_strDestCC);
	DDX_Text(pDX, IDC_FIELPATH, m_strFilePath);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CSendFile, CDialog)
	//{{AFX_MSG_MAP(CSendFile)
	ON_BN_CLICKED(IDC_SELECTFILE, OnSelectfile)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CSendFile message handlers

BOOL CSendFile::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CSendFile::OnSelectfile() 
{
	CString strFilePath=SelectFilePath();
	if(!strFilePath.IsEmpty())
	{
		m_cFilePath.SetWindowText(strFilePath);
	}
}

CString CSendFile::SelectFilePath()
{
	CString strDestPath;
	char szFile[260]={0};       // buffer for filename
	OPENFILENAME ofn={0};
	ofn.lStructSize = sizeof(OPENFILENAME);
	ofn.hwndOwner = m_hWnd;
	ofn.lpstrFile = szFile;
	ofn.nMaxFile = sizeof(szFile);	
	ofn.nFilterIndex = 1;
	ofn.lpstrFileTitle = NULL;
	ofn.nMaxFileTitle = 0;	
	ofn.lpstrInitialDir = NULL;
	ofn.Flags = OFN_PATHMUSTEXIST | OFN_FILEMUSTEXIST|OFN_OVERWRITEPROMPT;	
	ofn.lpstrFilter = "All file\0*.*\0";
	ofn.lpstrDefExt = NULL;	
	if(::GetOpenFileName(&ofn))
	{
		strDestPath = szFile;			
	}
	return strDestPath;
}
