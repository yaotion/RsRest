// FileTransfer.cpp : implementation file
//

#include "stdafx.h"
#include "qnviccubdemo.h"
#include "FileTransfer.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CFileTransfer dialog


CFileTransfer::CFileTransfer(CWnd* pParent /*=NULL*/)
	: CDialog(CFileTransfer::IDD, pParent)
{
	//{{AFX_DATA_INIT(CFileTransfer)
	m_strDestCC = _T("");
	m_strFilePath = _T("");
	//}}AFX_DATA_INIT
	m_pfiletransfer=NULL;
	m_lTransHandle = 0;
}


void CFileTransfer::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CFileTransfer)
	DDX_Control(pDX, IDC_FIELPATH, m_cFilePath);
	DDX_Text(pDX, IDC_DESTCC, m_strDestCC);
	DDX_Text(pDX, IDC_FIELPATH, m_strFilePath);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CFileTransfer, CDialog)
	//{{AFX_MSG_MAP(CFileTransfer)
	ON_BN_CLICKED(IDC_SELECTFILE, OnSelectfile)
	ON_BN_CLICKED(IDC_STARTSEND, OnStartsend)
	ON_BN_CLICKED(IDC_STOPSEND, OnStopsend)
	ON_WM_DESTROY()
	ON_BN_CLICKED(IDC_RECVFILE, OnRecvfile)
	ON_BN_CLICKED(IDC_STOPRECV, OnStoprecv)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CFileTransfer message handlers

BOOL CFileTransfer::OnInitDialog() 
{
	CDialog::OnInitDialog();
		
	CreateTransfer();
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

BOOL	CFileTransfer::CreateTransfer()
{
	if(!m_pfiletransfer)
	{
		m_pfiletransfer = new Cqnvfiletransfer();
		RECT rc;
		rc.left = 5;rc.top = 120;rc.right = rc.left+185;rc.bottom = rc.top+75;
		CString szClassName = AfxRegisterWndClass(CS_CLASSDC|CS_SAVEBITS,LoadCursor(NULL, IDC_ARROW));
		if(!m_pfiletransfer->Create(szClassName,_T("filetransfer"),WS_CHILD ,rc,this,19995))		
		{//|WS_TABSTOP|WS_CLIPCHILDREN			
			return FALSE;
		}
		m_pfiletransfer->ShowWindow(SW_SHOW);
	}
	return 0;
}

BOOL	CFileTransfer::CloseTransfer()
{
	if(m_pfiletransfer)
	{
		m_pfiletransfer->FT_StopFileTrans(0);
		delete m_pfiletransfer;
		m_pfiletransfer=NULL;
	}
	return 0;
}

void CFileTransfer::OnSelectfile() 
{	
	CString strFilePath=((CQnviccubdemoApp*)AfxGetApp())->SelectFilePath(1);
	if(!strFilePath.IsEmpty())
	{
		m_cFilePath.SetWindowText(strFilePath);
	}
}

void CFileTransfer::OnStartsend() 
{
	UpdateData(TRUE);	
	m_lTransHandle=m_pfiletransfer->FT_SendRequest((LPCTSTR)m_strDestCC,(LPCTSTR)m_strFilePath,0x30301,0);	
	if( m_lTransHandle <= 0)
	{
		AfxMessageBox("发送失败");
	}else
	{
		long lFileSize=m_pfiletransfer->FT_GetFileSize();
		TRACE("等待传输...filesize=%d",lFileSize);
	}
}

void CFileTransfer::OnStopsend() 
{
	m_pfiletransfer->FT_StopFileTrans(0);		
}

void CFileTransfer::OnDestroy() 
{
	CloseTransfer();
	CDialog::OnDestroy();	
}

void	CFileTransfer::FreeSource()
{
	CloseTransfer();
}

void CFileTransfer::OnCancel() 
{	
	GetParent()->PostMessage(QNV_CLOSEFILETRANSFER_MESSAGE,0,0);
}

long	CFileTransfer::TransferFinished()
{
	if(!m_pfiletransfer) return -1;
	long lRequestType=m_pfiletransfer->FT_GetRequestType();
	long lRet=m_pfiletransfer->FT_StopFileTrans(0);
	if(lRet == 2)//已经结束
	{
	}
	if(lRet == 0)//失败
	{
		if(lRequestType == 0)
			AfxMessageBox("文件接收失败");
		else
			AfxMessageBox("文件发送失败");
	}else if(lRet == 1)
	{		
		CString strFilePath=m_pfiletransfer->FT_GetFilePath();
		if (lRequestType == 0)//接收
		{
			AfxMessageBox("接收完毕");
		}else//发送
		{
			AfxMessageBox("发送完毕");
		}
	}
	return lRet;
}

long	CFileTransfer::RecvFileRequest(long lHandle,LPCTSTR lpCC,LPCTSTR lpFile,DWORD dwSize)
{
	long lRet=m_pfiletransfer->FT_RecvRequest(lpCC,lpFile,dwSize,0x30301,0,lHandle);
	m_lTransHandle = lHandle;
	return 0;
}

void CFileTransfer::OnRecvfile() 
{
	CString strFilePath=((CQnviccubdemoApp*)AfxGetApp())->SelectFilePath(0);
	if(!strFilePath.IsEmpty())
	{
		m_pfiletransfer->FT_ReplyRecvFileRequest(m_lTransHandle,(LPCTSTR)strFilePath,0,TRUE);
	}
}

void CFileTransfer::OnStoprecv() 
{
	m_pfiletransfer->FT_StopFileTrans(0);	
}
