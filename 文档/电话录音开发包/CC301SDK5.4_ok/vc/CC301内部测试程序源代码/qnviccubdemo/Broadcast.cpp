// Broadcast.cpp : implementation file
//

#include "stdafx.h"
#include "qnviccubdemo.h"
#include "Broadcast.h"
#include "InputIP.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CBroadcast dialog


CBroadcast::CBroadcast(CWnd* pParent /*=NULL*/)
	: CDialog(CBroadcast::IDD, pParent)
{
	//{{AFX_DATA_INIT(CBroadcast)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	m_nChannelID=-1;
}


void CBroadcast::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CBroadcast)
	DDX_Control(pDX, IDC_COMBOCHANNEL, m_cChannelList);
	DDX_Control(pDX, IDC_IPLIST, m_IPList);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CBroadcast, CDialog)
	//{{AFX_MSG_MAP(CBroadcast)
	ON_BN_CLICKED(IDC_ADD, OnAdd)
	ON_BN_CLICKED(IDC_DEL, OnDel)
	ON_WM_DESTROY()
	ON_BN_CLICKED(IDC_STARTBROAD, OnStartbroad)
	ON_BN_CLICKED(IDC_STOPBROAD, OnStopbroad)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CBroadcast message handlers

BOOL CBroadcast::OnInitDialog() 
{
	CDialog::OnInitDialog();
		
	InitDevList();
	QNV_OpenDevice(ODT_SOUND,0,NULL);//启动声卡控制
	m_IPList.AddString("127.0.0.1");	
	QNV_Broadcast((BRIINT16)GetSelectChannel(),QNV_BROADCAST_SEND_ADDADDR,RECVBROADCAST_PORT,(char*)"127.0.0.1");
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

#define		CHANNEL_NAME		"通道"
void CBroadcast::InitDevList()
{
	CString strChannel=CHANNEL_NAME,str;
	for(int i=0;i<QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS);i++)
	{
		str.Format("%s%d",strChannel,i+1);
		m_cChannelList.AddString(str);
	}
	str.Format("%s%d (声卡通道)",strChannel,SOUND_CHANNELID+1);//读取时减了1，跟设备ID匹配，这里就加上1
	m_cChannelList.AddString(str);
	m_cChannelList.SetCurSel(0);
}

//根据通道名获得通道ID
BRIINT16  CBroadcast::GetChannelID(CString strText)
{
	CString strChannel=CHANNEL_NAME;
	if(strText.GetLength() <= strChannel.GetLength())
	{
		return -1;
	}else
		return atol((LPCTSTR)strText.Right(strText.GetLength() - strChannel.GetLength())) - 1;
}

void CBroadcast::FreeSource()
{
	QNV_Broadcast((BRIINT16)GetSelectChannel(),QNV_BROADCAST_SEND_STOP,0,NULL);
}

void CBroadcast::OnCancel() 
{
	QNV_Broadcast((BRIINT16)GetSelectChannel(),QNV_BROADCAST_SEND_STOP,0,NULL);
	ShowWindow(SW_HIDE);
	//CDialog::OnCancel();
}

long CBroadcast::AddIPList()
{
	CString str;
	for(int i=0;i<m_IPList.GetCount();i++)
	{
		m_IPList.GetText(i,str);
		QNV_Broadcast((BRIINT16)GetSelectChannel(),QNV_BROADCAST_SEND_ADDADDR,RECVBROADCAST_PORT,(char*)(LPCTSTR)str);
	}
	return 0;
}

void CBroadcast::OnAdd() 
{
	CInputIP input;
	if(input.DoModal() == IDOK)
	{
		if(!input.m_strIPAddr.IsEmpty())
		{
			m_IPList.AddString((LPCTSTR)input.m_strIPAddr);
			QNV_Broadcast((BRIINT16)GetSelectChannel(),QNV_BROADCAST_SEND_ADDADDR,RECVBROADCAST_PORT,(char*)(LPCTSTR)input.m_strIPAddr);
		}
	}	
}

void CBroadcast::OnDel() 
{
	int icursel=m_IPList.GetCurSel();
	if(icursel >= 0)
	{
		CString str;
		m_IPList.GetText(icursel,str);
		m_IPList.DeleteString(icursel);
		QNV_Broadcast((BRIINT16)GetSelectChannel(),QNV_BROADCAST_SEND_DELETEADDR,RECVBROADCAST_PORT,(char*)(LPCTSTR)str);		
	}	
}

void CBroadcast::OnDestroy() 
{
	QNV_Broadcast((BRIINT16)GetSelectChannel(),QNV_BROADCAST_SEND_STOP,0,NULL);
	CDialog::OnDestroy();	
}

long CBroadcast::GetSelectChannel()
{
	int iCurSel=m_cChannelList.GetCurSel();
	if(iCurSel >= 0)
	{
		CString str;
		m_cChannelList.GetLBText(iCurSel,str);
		m_nChannelID = GetChannelID(str);
	}
	return m_nChannelID;
}

void CBroadcast::OnStartbroad() 
{
	QNV_Broadcast((BRIINT16)GetSelectChannel(),QNV_BROADCAST_SEND_START,0,NULL);
	AddIPList();
}

void CBroadcast::OnStopbroad() 
{
	QNV_Broadcast((BRIINT16)GetSelectChannel(),QNV_BROADCAST_SEND_STOP,0,NULL);
}
