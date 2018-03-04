// SocketClient.cpp : implementation file
//

#include "stdafx.h"
#include "qnviccubdemo.h"
#include "SocketClient.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CSocketClient dialog


CSocketClient::CSocketClient(CWnd* pParent /*=NULL*/)
	: CDialog(CSocketClient::IDD, pParent)
{
	//{{AFX_DATA_INIT(CSocketClient)
	m_strData = _T("");
	m_strSvrIP = _T("127.0.0.1");
	m_nSvrPort = 8888;
	//}}AFX_DATA_INIT
	m_lSocketHandle=0;
}


void CSocketClient::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CSocketClient)
	DDX_Text(pDX, IDC_DATA, m_strData);
	DDX_Text(pDX, IDC_SVRIPADDR, m_strSvrIP);
	DDX_Text(pDX, IDC_SVRPORT, m_nSvrPort);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CSocketClient, CDialog)
	//{{AFX_MSG_MAP(CSocketClient)
	ON_BN_CLICKED(IDC_STARTCONNECT, OnStartconnect)
	ON_BN_CLICKED(IDC_STOPCONNECT, OnStopconnect)
	ON_BN_CLICKED(IDC_SEND, OnSend)
	ON_WM_DESTROY()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CSocketClient message handlers


BOOL CSocketClient::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	QNV_OpenDevice(ODT_SOCKET_CLIENT,0,NULL);
	QNV_Event(SOCKET_CLIENT_CHANNELID,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);
	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CSocketClient::OnStartconnect() 
{
	UpdateData(TRUE);
	OnStopconnect();
	m_lSocketHandle = QNV_Socket_Client(QNV_SOCKET_CLIENT_CONNECT,0,m_nSvrPort,(char*)(LPCTSTR)m_strSvrIP,0);
	if(m_lSocketHandle <= 0)
	{
		AfxMessageBox("����ʧ��");
	}else
	{
		AppendStatus("��ʼ����");
	}
}

void CSocketClient::OnStopconnect() 
{
	if(m_lSocketHandle != 0)
	{
		QNV_Socket_Client(QNV_SOCKET_CLIENT_DISCONNECT,m_lSocketHandle,0,NULL,0);
		m_lSocketHandle=0;
		AppendStatus("�Ͽ�����");
	}	
}

void CSocketClient::OnSend() 
{
	UpdateData(TRUE);
	if(m_lSocketHandle != 0)
	{
		QNV_Socket_Client(QNV_SOCKET_CLIENT_SENDDATA,m_lSocketHandle,0,(char*)(LPCTSTR)m_strData,m_strData.GetLength());		
	}else
	{
		AfxMessageBox("��δ����");
	}
}


void	CSocketClient::AppendStatus(CString strStatus)
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

LRESULT CSocketClient::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	if(message == BRI_EVENT_MESSAGE)
	{
		PBRI_EVENT pEvent=(PBRI_EVENT)lParam;	
		switch(pEvent->lEventType)
		{
		case BriEvent_Socket_C_ConnectSuccess:
			{
				AppendStatus("���ӳɹ�....");
			}break;
		case BriEvent_Socket_C_ConnectFailed:
			{
				AppendStatus("����ʧ��....");
				QNV_Socket_Client(QNV_SOCKET_CLIENT_STARTRECONNECT,m_lSocketHandle,3000,NULL,0);
				AppendStatus("3���������������....");
			}break;
		case BriEvent_Socket_C_ReConnect:
			{
				AppendStatus("��ʼ��������....");
			}break;
		case BriEvent_Socket_C_ReConnectFailed:
			{
				AppendStatus("��������ʧ��....");
			}break;
		case BriEvent_Socket_C_ServerClose:
			{
				AppendStatus("�������ѶϿ�����....");
			}break;
		case BriEvent_Socket_C_DisConnect:
			{
				AppendStatus("���ʱ,������������....");
			}break;
		case BriEvent_Socket_C_RecvedData:
			{
				AppendStatus(CString("�ն˽��յ����ݣ�")+pEvent->szData);
			}break;
		default:break;
		}
	}
	return CDialog::WindowProc(message, wParam, lParam);
}

void CSocketClient::OnDestroy() 
{
	QNV_CloseDevice(ODT_SOCKET_CLIENT,0);
	CDialog::OnDestroy();	
}
