// Conference.cpp : implementation file
//

#include "stdafx.h"
#include "qnviccubdemo.h"
#include "Conference.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

#define		CHANNEL_NAME	"通道"

/////////////////////////////////////////////////////////////////////////////
// CConference dialog


CConference::CConference(CWnd* pParent /*=NULL*/)
	: CDialog(CConference::IDD, pParent)
{
	//{{AFX_DATA_INIT(CConference)
	m_nVolume = 0;
	m_nMicVolume = 0;
	//}}AFX_DATA_INIT
	m_nConfID= -1;
	m_nChannelID = SOUND_CHANNELID;
}


void CConference::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CConference)
	DDX_Control(pDX, IDC_MICVOLUME, m_cMicVolume);
	DDX_Control(pDX, IDC_RESUME, m_cResume);
	DDX_Control(pDX, IDC_PAUSE, m_cPause);
	DDX_Control(pDX, IDC_DISABLESPK, m_cDisableSpk);
	DDX_Control(pDX, IDC_DISABLEMIC, m_cDisableMic);
	DDX_Control(pDX, IDC_VOLUME, m_cVolume);
	DDX_Control(pDX, IDC_STOPREC, m_cStopRec);
	DDX_Control(pDX, IDC_STARTREC, m_cStartRec);
	DDX_Control(pDX, IDC_STCONFID, m_cStConfID);
	DDX_Control(pDX, IDC_OUTLIST, m_cOutList);
	DDX_Control(pDX, IDC_INLIST, m_cInList);
	DDX_Text(pDX, IDC_VOLUME, m_nVolume);
	DDX_Text(pDX, IDC_MICVOLUME, m_nMicVolume);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CConference, CDialog)
	//{{AFX_MSG_MAP(CConference)
	ON_BN_CLICKED(IDC_ADD, OnAdd)
	ON_BN_CLICKED(IDC_DEL, OnDel)
	ON_WM_DESTROY()
	ON_BN_CLICKED(IDC_STARTREC, OnStartrec)
	ON_BN_CLICKED(IDC_STOPREC, OnStoprec)
	ON_BN_CLICKED(IDC_SETVOLUME, OnSetvolume)
	ON_LBN_SELCHANGE(IDC_INLIST, OnSelchangeInlist)
	ON_BN_CLICKED(IDC_PAUSE, OnPause)
	ON_BN_CLICKED(IDC_RESUME, OnResume)
	ON_BN_CLICKED(IDC_DISABLEMIC, OnDisablemic)
	ON_BN_CLICKED(IDC_DISABLESPK, OnDisablespk)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CConference message handlers

BOOL CConference::OnInitDialog() 
{
	CDialog::OnInitDialog();

	QNV_OpenDevice(ODT_SOUND,0,0);//启用声卡控制通道
	QNV_Event(m_nChannelID,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);
	//创建会议
	BRIINT16 nCreateChannelID=0;//创建者通道
	BRIUINT32 uMask=0;//_RECORD_MASK_AGC_;
	m_nConfID = QNV_Conference(nCreateChannelID,0,QNV_CONFERENCE_CREATE,uMask,NULL);	
	CString str;
	str.Format("会议已创建：会议ID=%d",m_nConfID);
	m_cStConfID.SetWindowText(str);
	InitDevList();
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CConference::InitDevList()
{
	CString strChannel=CHANNEL_NAME,str;
	str.Format("%s%d",strChannel,1);
	m_cInList.AddString(str);
	for(int i=1;i<QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS);i++)
	{
		str.Format("%s%d",strChannel,i+1);
		m_cOutList.AddString(str);
	}
	str.Format("%s%d (声卡通道)",strChannel,SOUND_CHANNELID+1);//读取时减了1，跟设备ID匹配，这里就加上1
	m_cOutList.AddString(str);
}

void	CConference::FreeSource()
{
	QNV_Event(m_nChannelID,QNV_EVENT_UNREGWND,(DWORD)m_hWnd,NULL,NULL,0);
	if(m_nConfID > 0)
	{
		QNV_Conference(0,m_nConfID,QNV_CONFERENCE_DELETECONF,RECORD_MASK_AGC,NULL);//删除会议
		m_nConfID= -1;
	}
	QNV_Conference(0,0,QNV_CONFERENCE_DELETEALLCONF,0,NULL);
	QNV_CloseDevice(ODT_SOUND,0);//关闭声卡控制模块
}


void CConference::OnCancel() 
{	
	GetParent()->PostMessage(QNV_CLOSECONFERENCE_MESSAGE,0,0);
	//CDialog::OnCancel();
}

void CConference::OnDestroy() 
{
	FreeSource();
	CDialog::OnDestroy();	
}

//根据通道名获得通道ID
BRIINT16  CConference::GetChannelID(CString strText)
{
	CString strChannel=CHANNEL_NAME;
	if(strText.GetLength() <= strChannel.GetLength())
	{
		return -1;
	}else
		return atol((LPCTSTR)strText.Right(strText.GetLength() - strChannel.GetLength())) - 1;
}
void CConference::OnAdd() 
{
	int iCurSel=m_cOutList.GetCurSel();
	if(iCurSel >= 0)
	{
		CString str;
		m_cOutList.GetText(iCurSel,str);
		if(QNV_Conference(GetChannelID(str),m_nConfID,QNV_CONFERENCE_ADDTOCONF,0,NULL) > 0)
		{						
			m_cInList.AddString(str);
			m_cOutList.DeleteString(iCurSel);
		}else
		{
			AfxMessageBox("添加失败");
		}
	}else
	{
		AfxMessageBox("请从未在会议通道列表中选择要添加的通道");
	}
}

void CConference::OnDel() 
{
	int iCurSel=m_cInList.GetCurSel();
	if(iCurSel >= 0)
	{
		CString str;
		m_cInList.GetText(iCurSel,str);
		m_cOutList.AddString(str);
		m_cInList.DeleteString(iCurSel);
		QNV_Conference(GetChannelID(str),m_nConfID,QNV_CONFERENCE_DELETECHANNEL,0,NULL);
	}else
	{
		AfxMessageBox("请从会议通道列表中选择要删除的通道");
	}	
}

LRESULT CConference::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	if(message == BRI_EVENT_MESSAGE)
	{
		PBRI_EVENT pEvent=(PBRI_EVENT)lParam;
		long lResult=pEvent->lResult;
		CString str;
		switch(pEvent->lEventType)
		{
			case BriEvent_OpenSoundFailed:
				{
					str.Format("通道%d: 打开声卡失败 lResult=%d szData=%s",m_nChannelID+1,lResult,pEvent->szData);
					AfxMessageBox(str);
				}break;
			default:break;
		}
	}
	return CDialog::WindowProc(message, wParam, lParam);
}

void CConference::OnStartrec() 
{
	OnStoprec();
	CString strFilePath=((CQnviccubdemoApp*)AfxGetApp())->SelectFilePath(0);
	if(!strFilePath.IsEmpty())
	{
		long lFormatID=BRI_WAV_FORMAT_DEFAULT;
		if(QNV_Conference(0,m_nConfID,QNV_CONFERENCE_RECORD_START,lFormatID,(char*)(LPCTSTR)strFilePath) <= 0)
		{
			CString str;
			str.Format("录音失败");
			AfxMessageBox(str);
		}else
		{
			m_cStartRec.EnableWindow(FALSE);
			m_cStopRec.EnableWindow(TRUE);
		}
	}		
}

void CConference::OnStoprec() 
{
	QNV_Conference(0,m_nConfID,QNV_CONFERENCE_RECORD_STOP,0,NULL);
	m_cStartRec.EnableWindow(TRUE);
	m_cStopRec.EnableWindow(FALSE);	
}

void CConference::OnSetvolume() 
{
	UpdateData(TRUE);
	int iCurSel=m_cInList.GetCurSel();
	if(iCurSel >= 0)
	{
		CString str;
		m_cInList.GetText(iCurSel,str);
		QNV_Conference(GetChannelID(str),m_nConfID,QNV_CONFERENCE_SETSPKVOLUME,m_nVolume,NULL);
		QNV_Conference(GetChannelID(str),m_nConfID,QNV_CONFERENCE_SETMICVOLUME,m_nMicVolume,NULL);
	}
	else
	{
		AfxMessageBox("请从会议通道列表中选择要设置音量的通道");
	}
}

void CConference::OnSelchangeInlist() 
{
	int iCurSel=m_cInList.GetCurSel();
	if(iCurSel >= 0)
	{
		CString str;
		m_cInList.GetText(iCurSel,str);
		m_nVolume=QNV_Conference(GetChannelID(str),m_nConfID,QNV_CONFERENCE_GETSPKVOLUME,0,NULL);
		m_nMicVolume=QNV_Conference(GetChannelID(str),m_nConfID,QNV_CONFERENCE_GETMICVOLUME,0,NULL);
		UpdateData(FALSE);
		m_cDisableMic.SetCheck(!QNV_Conference(GetChannelID(str),m_nConfID,QNV_CONFERENCE_ISENABLEMIC,0,NULL));
		m_cDisableSpk.SetCheck(!QNV_Conference(GetChannelID(str),m_nConfID,QNV_CONFERENCE_ISENABLESPK,0,NULL));
		if(QNV_Conference(GetChannelID(str),m_nConfID,QNV_CONFERENCE_ISPAUSE,0,NULL))
		{
			m_cPause.EnableWindow(FALSE);
			m_cResume.EnableWindow(TRUE);
		}else
		{
			m_cPause.EnableWindow(TRUE);
			m_cResume.EnableWindow(FALSE);
		}
	}	
}

void CConference::OnPause() 
{
	int iCurSel=m_cInList.GetCurSel();
	if(iCurSel >= 0)
	{
		CString str;
		m_cInList.GetText(iCurSel,str);
		QNV_Conference(GetChannelID(str),m_nConfID,QNV_CONFERENCE_PAUSE,0,NULL);
	}
	else
	{
		AfxMessageBox("请从会议通道列表中选择要暂停的通道");
	}	
}

void CConference::OnResume() 
{
	int iCurSel=m_cInList.GetCurSel();
	if(iCurSel >= 0)
	{
		CString str;
		m_cInList.GetText(iCurSel,str);
		QNV_Conference(GetChannelID(str),m_nConfID,QNV_CONFERENCE_RESUME,0,NULL);
	}
	else
	{
		AfxMessageBox("请从会议通道列表中选择要恢复的通道");
	}		
}

void CConference::OnDisablemic() 
{
	int iCurSel=m_cInList.GetCurSel();
	if(iCurSel >= 0)
	{
		CString str;
		m_cInList.GetText(iCurSel,str);
		QNV_Conference(GetChannelID(str),m_nConfID,QNV_CONFERENCE_ENABLEMIC,!m_cDisableMic.GetCheck(),NULL);
	}
	else
	{
		AfxMessageBox("请从会议通道列表中选择要禁止说的通道");
	}			
}

void CConference::OnDisablespk() 
{
	int iCurSel=m_cInList.GetCurSel();
	if(iCurSel >= 0)
	{
		CString str;
		m_cInList.GetText(iCurSel,str);
		QNV_Conference(GetChannelID(str),m_nConfID,QNV_CONFERENCE_ENABLESPK,!m_cDisableSpk.GetCheck(),NULL);
	}
	else
	{
		AfxMessageBox("请从会议通道列表中选择要禁止听的通道");
	}			
}
