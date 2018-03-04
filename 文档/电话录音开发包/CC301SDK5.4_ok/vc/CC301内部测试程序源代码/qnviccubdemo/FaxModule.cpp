// FaxModule.cpp : implementation file
//

#include "stdafx.h"
#include "qnviccubdemo.h"
#include "FaxModule.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CFaxModule dialog


CFaxModule::CFaxModule(CWnd* pParent /*=NULL*/)
	: CDialog(CFaxModule::IDD, pParent)
{
	//{{AFX_DATA_INIT(CFaxModule)
	m_strRecvPath = _T("c:\\recvfax.tif");
	m_strSendPath = _T("e:\\temp.bmp");
	//}}AFX_DATA_INIT
	m_nChannelID= -1;
}


void CFaxModule::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CFaxModule)
	DDX_Text(pDX, IDC_RECVPATH, m_strRecvPath);
	DDX_Text(pDX, IDC_SENDPATH, m_strSendPath);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CFaxModule, CDialog)
	//{{AFX_MSG_MAP(CFaxModule)
	ON_BN_CLICKED(IDC_STARTSEND, OnStartsend)
	ON_BN_CLICKED(IDC_STOPSEND, OnStopsend)
	ON_BN_CLICKED(IDC_VIEWSEND, OnViewsend)
	ON_BN_CLICKED(IDC_STARTRECV, OnStartrecv)
	ON_BN_CLICKED(IDC_STOPRECV, OnStoprecv)
	ON_BN_CLICKED(IDC_VIEWRECV, OnViewrecv)
	ON_BN_CLICKED(IDC_SELECTSEND, OnSelectsend)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CFaxModule message handlers

BOOL CFaxModule::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	QNV_Fax(0,QNV_FAX_LOAD,0,NULL);
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_RECVFSK,0);//停止接收FSK来电，节省CPU资源
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_RECVDTMF,0);//停止接收DTMF来电/按键，节省CPU资源
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CFaxModule::OnCancel() 
{
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_RECVFSK,1);//回复接收FSK来电
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_RECVDTMF,1);//回复接收DTMF来电/按键
	QNV_Fax(m_nChannelID,QNV_FAX_STOPRECV,0,NULL);
	QNV_Fax(m_nChannelID,QNV_FAX_STOPSEND,0,NULL);
	QNV_Fax(0,QNV_FAX_UNLOAD,0,NULL);
	CDialog::OnCancel();
}

#define			TIFF_SPACEPIX_		0//160 图片左右/上空白像素
void CFaxModule::OnStartsend() 
{
	UpdateData(TRUE);
	long lRet=QNV_Fax(m_nChannelID,QNV_FAX_STARTSEND,TIFF_SPACEPIX_,(char*)(LPCTSTR)m_strSendPath);
	if(lRet <= 0) 
	{
		AfxMessageBox("发送失败");
	}	
}

void CFaxModule::OnStopsend() 
{
	QNV_Fax(m_nChannelID,QNV_FAX_STOPSEND,0,NULL);	
}

void CFaxModule::OnViewsend() 
{
	UpdateData(TRUE);
	::ShellExecute(NULL,"open",m_strSendPath,"",NULL,SW_SHOWNORMAL);	
}

void CFaxModule::OnStartrecv() 
{
	long lRet=QNV_Fax(m_nChannelID,QNV_FAX_STARTRECV,0,(char*)(LPCTSTR)m_strRecvPath);
	if(lRet <= 0) 
	{
		AfxMessageBox("接收失败");
	}		
}

void CFaxModule::OnStoprecv() 
{
	QNV_Fax(m_nChannelID,QNV_FAX_STOPRECV,0,NULL);	
}

void CFaxModule::OnViewrecv() 
{
	UpdateData(TRUE);
	::ShellExecute(NULL,"open",m_strRecvPath,"",NULL,SW_SHOWNORMAL);	
}

void CFaxModule::OnSelectsend() 
{
	CString strPath=((CQnviccubdemoApp*)AfxGetApp())->GetSelectedFilePath2("Image Files(*.bmp,*.jpg,*.jpeg,*.gif,*.png,*.pcx,*.tif,*.tiff)|*.bmp;*.jpg;*.jpeg;*.gif;*.png;*.pcx;*.tif;*.tiff;||","","","",m_hWnd,TRUE);
	if(!strPath.IsEmpty())
	{
		m_strSendPath = strPath;
		UpdateData(FALSE);
	}
}
