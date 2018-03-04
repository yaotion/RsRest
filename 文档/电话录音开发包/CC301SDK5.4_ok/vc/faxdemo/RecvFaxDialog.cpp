// RecvFaxDialog.cpp : implementation file
//

#include "stdafx.h"
#include "FaxDemo.h"
#include "RecvFaxDialog.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CRecvFaxDialog dialog


CRecvFaxDialog::CRecvFaxDialog(CWnd* pParent /*=NULL*/)
	: CDialog(CRecvFaxDialog::IDD, pParent)
{
	//{{AFX_DATA_INIT(CRecvFaxDialog)
	m_strRecvPath = _T("c:\\recvfax.tif");
	//}}AFX_DATA_INIT
	m_nChannelID=0;
}


void CRecvFaxDialog::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CRecvFaxDialog)
	DDX_Control(pDX, IDC_STSTATUS, m_cState);
	DDX_Text(pDX, IDC_RECVPATH, m_strRecvPath);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CRecvFaxDialog, CDialog)
	//{{AFX_MSG_MAP(CRecvFaxDialog)
	ON_BN_CLICKED(IDC_VIEW, OnView)
	ON_BN_CLICKED(IDC_STARTRECV, OnStartrecv)
	ON_BN_CLICKED(IDC_STOPRECV, OnStoprecv)
	ON_BN_CLICKED(IDC_OPENDOPLAY, OnOpendoplay)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CRecvFaxDialog message handlers

BOOL CRecvFaxDialog::OnInitDialog() 
{
	CDialog::OnInitDialog();
		
	QNV_Fax(0,QNV_FAX_LOAD,0,NULL);	
	QNV_Event(m_nChannelID,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);

	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CRecvFaxDialog::OnCancel() 
{
	if(QNV_Fax(m_nChannelID,QNV_FAX_TYPE,0,0) == FAX_TYPE_RECV)
	{
		if(MessageBox("正在接收传真，确实要终止吗？","警告",MB_YESNO|MB_ICONWARNING) == IDNO)
			return;
	}	
	OnStoprecv();
	CDialog::OnCancel();
}

void CRecvFaxDialog::OnView() 
{
	UpdateData(TRUE);
	::ShellExecute(NULL,"open","rundll32.exe","shimgvw.dll,ImageView_Fullscreen "+m_strRecvPath,NULL,SW_SHOWNORMAL); 
}

void CRecvFaxDialog::OnStartrecv() 
{
	UpdateData(TRUE);
	if(m_nChannelID >= 0 && QNV_Fax(m_nChannelID,QNV_FAX_TYPE,0,NULL) != FAX_TYPE_NULL)
	{
		long lRet=QNV_Fax(m_nChannelID,QNV_FAX_TYPE,0,NULL);
		AfxMessageBox("通道错误");
		return ;
	}
	if(QNV_Fax(m_nChannelID,QNV_FAX_STARTRECV,0,(char*)(LPCTSTR)m_strRecvPath) > 0)
	{
		if((QNV_DevInfo(m_nChannelID,QNV_DEVINFO_GETMODULE)&DEVMODULE_SWITCH)
			|| !QNV_GetDevCtrl(m_nChannelID,QNV_CTRL_PHONE))
		{
			m_cState.SetWindowText("正在接收传真...");
		}else
		{
			//如果没有继电器的,软摘机,然后提示用户挂机,检测到挂机后启动传真
			//这样主窗口检测到挂机后不能让它软挂机成功
			//立即暂停,等待挂机后恢复开始
			QNV_Fax(m_nChannelID,QNV_FAX_PAUSE,0,NULL);
			m_cState.SetWindowText("准备接收传真,请挂机...");
		}
		return ;
	}else
	{
		m_cState.SetWindowText("启动接收传真失败...");
		return ;
	}	
}

void CRecvFaxDialog::OnStoprecv() 
{
	QNV_Fax(m_nChannelID,QNV_FAX_STOPRECV,0,NULL);
}

void CRecvFaxDialog::OnOpendoplay() 
{
     QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_DOPLAY,((CButton*)GetDlgItem(IDC_OPENDOPLAY))->GetCheck());
     QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_PLAYMUX,DOPLAY_CHANNEL0_ADC);//选择听线路声音	
}

LRESULT CRecvFaxDialog::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	if(message == BRI_EVENT_MESSAGE)
	{
		PBRI_EVENT pEvent=(PBRI_EVENT)lParam;
		_ASSERT(pEvent->uChannelID == m_nChannelID);
		switch(pEvent->lEventType)
		{
		case BriEvent_FaxRecvFinished:
			{
				m_cState.SetWindowText("接收传真完成");
				QNV_Fax(m_nChannelID,QNV_FAX_STOPRECV,0,NULL);
			}break; 
		case BriEvent_FaxRecvFailed:case BriEvent_Silence:case BriEvent_Busy:case BriEvent_RemoteHang:
			{
				CString str;
				str.Format("接收传真失败 eid=%d",pEvent->lEventType);
				m_cState.SetWindowText(str);
				QNV_Fax(m_nChannelID,QNV_FAX_STOPRECV,0,NULL);
			}break;
		case BriEvent_PhoneHang:
			{
				if(QNV_Fax(m_nChannelID,QNV_FAX_ISPAUSE,0,NULL))
				{					
					QNV_Fax(m_nChannelID,QNV_FAX_RESUME,0,NULL);
					m_cState.SetWindowText("正在接收传真...");
				}
			}break;
		default:break;
		}
	}	
	return CDialog::WindowProc(message, wParam, lParam);
}
