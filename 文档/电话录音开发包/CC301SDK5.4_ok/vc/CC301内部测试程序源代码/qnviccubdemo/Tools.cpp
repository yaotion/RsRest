// Tools.cpp : implementation file
//

#include "stdafx.h"
#include "qnviccubdemo.h"
#include "Tools.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CTools dialog


CTools::CTools(CWnd* pParent /*=NULL*/)
	: CDialog(CTools::IDD, pParent)
{
	//{{AFX_DATA_INIT(CTools)
	m_strPSTN = _T("");
	m_strFilePath = _T("");
	//}}AFX_DATA_INIT
}


void CTools::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CTools)
	DDX_Control(pDX, IDC_FIELPATH, m_cFilePath);
	DDX_Control(pDX, IDC_SELECTDIR, m_cSelectDir);
	DDX_Text(pDX, IDC_PSTN, m_strPSTN);
	DDX_Text(pDX, IDC_FIELPATH, m_strFilePath);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CTools, CDialog)
	//{{AFX_MSG_MAP(CTools)
	ON_BN_CLICKED(IDC_PSTNEnd, OnPSTNEnd)
	ON_BN_CLICKED(IDC_LOCATION, OnLocation)
	ON_BN_CLICKED(IDC_CHECKCODETYPE, OnCheckcodetype)
	ON_BN_CLICKED(IDC_BROWER, OnBrower)
	ON_BN_CLICKED(IDC_BROWERFILE, OnBrowerfile)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CTools message handlers


BOOL CTools::OnInitDialog() 
{
	CDialog::OnInitDialog();	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CTools::OnPSTNEnd() 
{
	UpdateData(TRUE);
	long lRet=QNV_Tool(QNV_TOOL_PSTNEND,0,(char*)(LPCTSTR)m_strPSTN,NULL,NULL,0);
	if(lRet > 0)
	{
		AfxMessageBox("ºÅÂëÒÑ½áÊø");
	}else
	{
		CString str;
		str.Format("ºÅÂë»¹Î´½áÊø retid=%d",lRet);
		AfxMessageBox(str);
	}
}

void CTools::OnLocation() 
{
	UpdateData(TRUE);
	char szOut[OUTVALUE_MAX_SIZE]={0};
	long lRet=QNV_Tool(QNV_TOOL_LOCATION,OUTVALUE_MAX_SIZE,(char*)(LPCTSTR)m_strPSTN,NULL,szOut,OUTVALUE_MAX_SIZE);	
	CString str;
	str.Format("%s lRet=%d",szOut,lRet);
	AfxMessageBox(str);
}

void CTools::OnCheckcodetype() 
{
	switch(QNV_Tool(QNV_TOOL_CODETYPE,0,(char*)(LPCTSTR)m_strPSTN,NULL,NULL,0))
	{
	case CTT_MOBILE:AfxMessageBox("ÒÆ¶¯ºÅÂë");break;
	case CTT_PSTN:AfxMessageBox("¹Ì»°ºÅÂë");break;
	default:AfxMessageBox("Î´Öª");break;
	}
}

void CTools::OnBrower() 
{
	char szPath[_MAX_PATH]={0};
	long lRet=QNV_Tool(QNV_TOOL_SELECTDIRECTORY,0,(char*)"Ñ¡ÔñÄ¿Â¼",NULL,szPath,_MAX_PATH);
	if(lRet > 0)
	{
		m_cSelectDir.SetWindowText(szPath);
	}	
}

void CTools::OnBrowerfile() 
{
	char szPath[_MAX_PATH]={0};
	long lRet=QNV_Tool(QNV_TOOL_SELECTFILE,0,"wave Files(*.wav,*.wave)|*.wav;*.wave;|All Files(*.*)|*.*||",NULL,szPath,_MAX_PATH);
	if(lRet > 0)
	{
		m_cFilePath.SetWindowText(szPath);
	}		
}
