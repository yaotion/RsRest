// SelectMultiFile.cpp : implementation file
//

#include "stdafx.h"
#include "qnviccubdemo.h"
#include "SelectMultiFile.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CSelectMultiFile dialog


CSelectMultiFile::CSelectMultiFile(CWnd* pParent /*=NULL*/)
	: CDialog(CSelectMultiFile::IDD, pParent)
{
	//{{AFX_DATA_INIT(CSelectMultiFile)	
	//}}AFX_DATA_INIT
	m_strFileList = _T("");
}


void CSelectMultiFile::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CSelectMultiFile)
	DDX_Control(pDX, IDC_FILELIST, m_cFileList);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CSelectMultiFile, CDialog)
	//{{AFX_MSG_MAP(CSelectMultiFile)
	ON_BN_CLICKED(IDC_ADD, OnAdd)
	ON_BN_CLICKED(IDC_DEL, OnDel)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CSelectMultiFile message handlers


BOOL CSelectMultiFile::OnInitDialog() 
{
	CDialog::OnInitDialog();
		
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CSelectMultiFile::OnOK() 
{	
	if(m_cFileList.GetCount() <= 0)
	{
		AfxMessageBox("文件列表不能为空");
		return;
	}else
	{
		CString str;
		for(int i=0;i<m_cFileList.GetCount();i++)
		{
			m_cFileList.GetText(i,str);
			m_strFileList+=str;
			m_strFileList+=MULTI_SEPA_CHAR;
		}
	}	
	CDialog::OnOK();
}

void CSelectMultiFile::OnAdd() 
{
	CString strFile=((CQnviccubdemoApp*)AfxGetApp())->SelectFilePath(1);
	if(!strFile.IsEmpty())
		m_cFileList.AddString(strFile);
}

void CSelectMultiFile::OnDel() 
{
	int iCurSel=m_cFileList.GetCurSel();
	if(iCurSel < 0) AfxMessageBox("请选择一个文件");
	else
		m_cFileList.DeleteString(iCurSel);	
}
