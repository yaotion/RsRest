// RecvBroad.cpp : implementation file
//

#include "stdafx.h"
#include "qnviccubdemo.h"
#include "RecvBroad.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CRecvBroad dialog


CRecvBroad::CRecvBroad(CWnd* pParent /*=NULL*/)
	: CDialog(CRecvBroad::IDD, pParent)
{
	//{{AFX_DATA_INIT(CRecvBroad)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}


void CRecvBroad::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CRecvBroad)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CRecvBroad, CDialog)
	//{{AFX_MSG_MAP(CRecvBroad)
	ON_WM_DESTROY()
	ON_BN_CLICKED(IDC_STARTRECV, OnStartrecv)
	ON_BN_CLICKED(IDC_STOPRECV, OnStoprecv)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CRecvBroad message handlers

BOOL CRecvBroad::OnInitDialog() 
{
	CDialog::OnInitDialog();
	QNV_OpenDevice(ODT_SOUND,0,NULL);//启动声卡控制
	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CRecvBroad::OnDestroy() 
{
	OnStoprecv();
	CDialog::OnDestroy();	
}

void CRecvBroad::OnStartrecv() 
{
	if(QNV_Broadcast((BRIINT16)SOUND_CHANNELID,QNV_BROADCAST_RECV_START,RECVBROADCAST_PORT,NULL) <= 0)
		AfxMessageBox("接收失败");
}

void CRecvBroad::OnStoprecv() 
{
	QNV_Broadcast((BRIINT16)SOUND_CHANNELID,QNV_BROADCAST_RECV_STOP,0,NULL);	
}

void	CRecvBroad::FreeSource()
{
	QNV_Broadcast((BRIINT16)SOUND_CHANNELID,QNV_BROADCAST_RECV_STOP,0,NULL);
}

void CRecvBroad::OnCancel() 
{	
	QNV_Broadcast((BRIINT16)SOUND_CHANNELID,QNV_BROADCAST_RECV_STOP,0,NULL);	
	ShowWindow(SW_HIDE);
	//CDialog::OnCancel();
}
