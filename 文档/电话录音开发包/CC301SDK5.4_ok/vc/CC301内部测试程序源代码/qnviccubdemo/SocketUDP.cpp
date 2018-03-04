// SocketUDP.cpp : implementation file
//

#include "stdafx.h"
#include "qnviccubdemo.h"
#include "SocketUDP.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CSocketUDP dialog


CSocketUDP::CSocketUDP(CWnd* pParent /*=NULL*/)
	: CDialog(CSocketUDP::IDD, pParent)
{
	//{{AFX_DATA_INIT(CSocketUDP)
	m_strIP = _T("127.0.0.1");
	m_nPort = 0;
	m_strData = _T("");
	m_strServerName = _T("");
	m_nFindPort = 0;
	m_strFindServerName = _T("");
	//}}AFX_DATA_INIT
}


void CSocketUDP::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CSocketUDP)
	DDX_Text(pDX, IDC_SVRIPADDR, m_strIP);
	DDX_Text(pDX, IDC_SVRPORT, m_nPort);
	DDX_Text(pDX, IDC_DATA, m_strData);
	DDX_Text(pDX, IDC_SERVERNAME, m_strServerName);
	DDV_MaxChars(pDX, m_strServerName, 32);
	DDX_Text(pDX, IDC_FINDPORT, m_nFindPort);
	DDX_Text(pDX, IDC_FINDSERVERNAME, m_strFindServerName);
	DDV_MaxChars(pDX, m_strFindServerName, 32);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CSocketUDP, CDialog)
	//{{AFX_MSG_MAP(CSocketUDP)
	ON_BN_CLICKED(IDC_SEND, OnSend)
	ON_BN_CLICKED(IDC_SETSERVERNAME, OnSetservername)
	ON_BN_CLICKED(IDC_STARTFIND, OnStartfind)
	ON_BN_CLICKED(IDC_STOPFIND, OnStopfind)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CSocketUDP message handlers

BOOL CSocketUDP::OnInitDialog() 
{
	CDialog::OnInitDialog();
	long lRet=QNV_OpenDevice(ODT_SOCKET_UDP,0,NULL);
	if(lRet > 0)
	{
		CString str;
		str.Format("打开UDP通道成功：端口=%d",lRet);
		AppendStatus(str);
		QNV_Event(SOCKET_UDP_CHANNELID,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);
	}else
	{
		AppendStatus("打开UDP通道失败");
	}
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void	CSocketUDP::AppendStatus(CString strStatus)
{
	CString str,strTime;
	CTime ct=CTime::GetCurrentTime();
	strTime.Format("[%02d:%02d:%02d] %s",ct.GetHour(),ct.GetMinute(),ct.GetSecond(),strStatus);	
	CString strSrc;
	GetDlgItem(IDC_SOCKETSTATUS)->GetWindowText(strSrc);
	if(strSrc.GetLength() > 160000)
		strSrc .Empty();
	str=strTime+"\r\n"+strSrc;
	GetDlgItem(IDC_SOCKETSTATUS)->SetWindowText(str);
}

LRESULT CSocketUDP::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	if(message == BRI_EVENT_MESSAGE)
	{
		CString str;
		PBRI_EVENT pEvent=(PBRI_EVENT)lParam;	
		switch(pEvent->lEventType)
		{
		case BriEvent_Socket_U_RecvedData:
			{
				str.Format("接收到数据：%s",pEvent->szData);				
			}break;
		case BriEvent_Socket_U_FindUDPSuccess:
			{
				str.Format("搜索UDP服务器成功 %s",pEvent->szData);
			}break;
		case BriEvent_Socket_U_FindUDPFailed:
			{
				str.Format("搜索UDP服务器失败 %s",pEvent->szData);
			}break;
		default:break;
		}
		if(!str.IsEmpty()) AppendStatus(str);
	}
	return CDialog::WindowProc(message, wParam, lParam);
}

void CSocketUDP::OnSend() 
{
	UpdateData(TRUE);
	QNV_Socket_UDP(QNV_SOCKET_UDP_SENDDATA,m_nPort,(char*)(LPCTSTR)m_strIP,(char*)(LPCTSTR)m_strData,m_strData.GetLength());		
}

void CSocketUDP::OnSetservername() 
{
	UpdateData(TRUE);
	if(QNV_Socket_UDP(QNV_SOCKET_UDP_SETSVRNAME,0,NULL,(char*)(LPCTSTR)m_strServerName,0) <= 0)
	{
		AfxMessageBox("失败");
	}
}

void CSocketUDP::OnStartfind() 
{
	UpdateData(TRUE);
	if(QNV_Socket_UDP(QNV_SOCKET_UDP_STARTFINDSVR,m_nFindPort,NULL,(char*)(LPCTSTR)m_strFindServerName,0) <= 0)
	{
		AfxMessageBox("失败");
	}
	
}

void CSocketUDP::OnStopfind() 
{
	UpdateData(TRUE);
	if(QNV_Socket_UDP(QNV_SOCKET_UDP_STOPFINDSVR,0,NULL,NULL,0) <= 0)
	{
		AfxMessageBox("失败");
	}	
}
