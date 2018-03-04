// CCCall.cpp : implementation file
//

#include "stdafx.h"
#include "ccdemo.h"
#include "CCCall.h"
#include "inputcc.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CCCCall dialog


CCCCall::CCCCall(CWnd* pParent /*=NULL*/)
	: CDialog(CCCCall::IDD, pParent)
{
	//{{AFX_DATA_INIT(CCCCall)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}


void CCCCall::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CCCCall)
	DDX_Control(pDX, IDC_REFUSE, m_cRefuse);
	DDX_Control(pDX, IDC_ANSWER, m_cAnswer);
	DDX_Control(pDX, IDC_BUSY, m_cBusy);
	DDX_Control(pDX, IDC_CALLLIST, m_CallList);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CCCCall, CDialog)
	//{{AFX_MSG_MAP(CCCCall)
	ON_BN_CLICKED(IDC_ANSWER, OnAnswer)
	ON_BN_CLICKED(IDC_REFUSE, OnRefuse)
	ON_BN_CLICKED(IDC_BUSY, OnBusy)
	ON_BN_CLICKED(IDC_STOP, OnStop)
	ON_BN_CLICKED(IDC_STARTPLAYFILE, OnStartplayfile)
	ON_BN_CLICKED(IDC_STOPPLAYFILE, OnStopplayfile)
	ON_BN_CLICKED(IDC_STARTRECORDFILE, OnStartrecordfile)
	ON_BN_CLICKED(IDC_STOPFILERECORD, OnStopfilerecord)
	ON_BN_CLICKED(IDC_HOLD, OnHold)
	ON_BN_CLICKED(IDC_UNHOLD, OnUnhold)
	ON_BN_CLICKED(IDC_SWITCH, OnSwitch)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CCCCall message handlers

BOOL CCCCall::OnInitDialog() 
{
	CDialog::OnInitDialog();		
	//本窗口获取呼叫事件
	QNV_Event(CCCTRL_CHANNELID,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);
	InitList();
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void	CCCCall::FreeSource()
{
	m_CallList.DeleteAllItems();
}

void CCCCall::OnCancel() 
{
	ShowWindow(SW_HIDE);//只隐藏不销毁(要销毁就回调消息给主窗口)
	//CDialog::OnCancel();
}

long	CCCCall::InitList()
{
	long lCoumnCount=0;	
	m_CallList.InsertColumn(lCoumnCount++,"CC",LVCFMT_LEFT,150);
	m_CallList.InsertColumn(lCoumnCount++,"昵称",LVCFMT_LEFT,150);
	m_CallList.InsertColumn(lCoumnCount++,"呼叫类型",LVCFMT_LEFT,64);	
	m_CallList.InsertColumn(lCoumnCount++,"状态",LVCFMT_LEFT,64);	
	m_CallList.InsertColumn(lCoumnCount++," ",LVCFMT_LEFT,120);	
	m_CallList.SetExtendedStyle(m_CallList.GetExtendedStyle()|(LVS_EX_FULLROWSELECT | LVS_EX_SUBITEMIMAGES|LVS_EX_GRIDLINES));
	return 1;
}


long	CCCCall::AppendCallIn(DWORD dwHandle,CString  strData)
{
	CMsgParse parse(strData);
	CString strCC=parse.GetParam(MSG_KEY_CC);//cc号码
	CString strNick=parse.GetParam(MSG_KEY_NAME);//昵称
	return AppendCallList(strCC,strNick,"来电","正在呼入",dwHandle);
}
 
long CCCCall::CallCC(LPCTSTR lpCC)
{
	DWORD dwHandle=QNV_CCCtrl_Call(QNV_CCCTRL_CALL_START,0,(char*)lpCC,0);
	if(dwHandle == 0)
	{
		AppendStatus("呼叫CC失败");
		return 0;
	}else
	{
		AppendStatus("开始呼叫CC");
		AppendCallList(lpCC,"","去电","开始呼出",dwHandle);
		return 1;
	}	
}

long	CCCCall::AppendCallList(LPCTSTR lpCC,LPCTSTR lpNick,LPCTSTR lpCallType,LPCTSTR lpState,DWORD dwHandle)
{
	int L=0;//0->追加在最前面 m_CallList.GetItemCount()->追加到最后面
	m_CallList.InsertItem(L,lpCC);
	m_CallList.SetItemText(L,1,lpNick);
	m_CallList.SetItemText(L,2,lpCallType);
	m_CallList.SetItemText(L,3,lpState);
	m_CallList.SetItemData(L,dwHandle);
	return L;
}

long	CCCCall::GetHandleItem(DWORD dwHandle)
{
	for(int i=0;i<m_CallList.GetItemCount();i++)
	{
		if(m_CallList.GetItemData(i) == dwHandle) return i;
	}
	return -1;
}

CString	CCCCall::GetCallErr(int iErrID)
{
	switch(iErrID)
	{
	case TMMERR_USEROFFLINE:return "用户不在线";
	case TMMERR_INVALIDUSER:return "号码不合法";
	case TMMERR_VOIPCONNECTFAILED:return "连接VOIP服务器失败";
	case TMMERR_VOIPACCOUNTFAILED:return "VOIP帐户错误/余额不够";
	case TMMERR_CANCEL:return "自己取消当前语音呼叫";
	case TMMERR_CLIENTCANCEL:return "对方取消当前语音呼叫";
	case TMMERR_REFUSE:return "拒绝对方呼入";
	case TMMERR_CLIENTREFUSE:return "对方拒绝呼叫";
	case TMMERR_STOP:return "自己停止语音呼叫(已接通)";
	case TMMERR_CLIENTSTOP:return "对方停止语音呼叫(已接通)";
	default:break;
	}
	return "未知错误";
}

LRESULT CCCCall::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	if(message == BRI_EVENT_MESSAGE)//接收到事件
	{
		PBRI_EVENT pEvent=(PBRI_EVENT)lParam;//获取事件数据结构
		CString strValue,str;
		strValue.Format("Handle=%d Result=%d Data=%s",pEvent->lEventHandle,pEvent->lResult,pEvent->szData);
		CMsgParse parse(pEvent->szData);
		switch(pEvent->lEventType)
		{	
		case BriEvent_CC_CallIn:
			{
				AppendCallIn(pEvent->lEventHandle,pEvent->szData);
				ShowWindow(SW_SHOW);
			}break;
		case BriEvent_CC_CallOutSuccess:
			{
				str.Format("正在呼叫... %s",strValue);
				long L=GetHandleItem(pEvent->lEventHandle);
				if(L >= 0)
				{					
					m_CallList.SetItemText(L,3,"正在呼出");
				}
			}break;
		case BriEvent_CC_CallOutFailed:
			{
				str.Format("呼叫失败 失败原因=%s %s",GetCallErr(pEvent->lResult),strValue);
				long L=GetHandleItem(pEvent->lEventHandle);
				if(L >= 0) m_CallList.DeleteItem(L);//删除列表
			}break;
		case BriEvent_CC_Connected:
			{
				str.Format("CC已经连通 %s",strValue);
				long L=GetHandleItem(pEvent->lEventHandle);
				if(L >= 0) m_CallList.SetItemText(L,3,"已连通");
			}break;
		case BriEvent_CC_CallFinished:
			{
				str.Format("呼叫结束 原因=%s  %s",GetCallErr(pEvent->lResult),strValue);
				long L=GetHandleItem(pEvent->lEventHandle);
				if(L >= 0) m_CallList.DeleteItem(L);//删除列表
			}break;
		case BriEvent_CC_GetDTMF:
			{
				str.Format("接收到对方按键 %s",strValue);
				long L=GetHandleItem(pEvent->lEventHandle);
				if(L >= 0) m_CallList.SetItemText(L,4,"接收到对方按键:"+parse.GetMsgText());				
			}break;
		case BriEvent_CC_PlayFileEnd:
			{
				str.Format("播放文件结束 %s",strValue);
				long L=GetHandleItem(pEvent->lEventHandle);
				if(L >= 0) m_CallList.SetItemText(L,4,"播放文件结束");				
			}break;
		}
		if(!str.IsEmpty())
			AppendStatus(str);
	}
	return CDialog::WindowProc(message, wParam, lParam);
}

//显示提示状态文本
void CCCCall::AppendStatus(CString strStatus)
{
	CString str,strTime;
	CTime ct=CTime::GetCurrentTime();
	strTime.Format("[%02d:%02d:%02d] %s tick=%d",ct.GetHour(),ct.GetMinute(),ct.GetSecond(),strStatus,GetTickCount());	
	CString strSrc;
	GetDlgItem(IDC_CALLSTATUS)->GetWindowText(strSrc);
	if(strSrc.GetLength() > 16000)
		strSrc .Empty();
	str=strTime+"\r\n"+strSrc;
	GetDlgItem(IDC_CALLSTATUS)->SetWindowText(str);
}

long CCCCall::GetFirstSelectedItem()
{
	POSITION pos=m_CallList.GetFirstSelectedItemPosition();
	if (pos == NULL) return -1;
	return m_CallList.GetNextSelectedItem(pos);	
}

void CCCCall::OnAnswer() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("请选择呼入的记录");
	}else
	{
		DWORD dwHandle=m_CallList.GetItemData(L);
		if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_ACCEPT,dwHandle,NULL,-1) <= 0)
			AfxMessageBox("接听失败");
	}
}

void CCCCall::OnRefuse() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("请选择呼入的记录");
	}else
	{
		DWORD dwHandle=m_CallList.GetItemData(L);
		if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_REFUSE,dwHandle,NULL,-1) <= 0)
			AfxMessageBox("拒绝失败");
	}	
}

void CCCCall::OnBusy() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("请选择呼入的记录");
	}else
	{
		DWORD dwHandle=m_CallList.GetItemData(L);
		if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_BUSY,dwHandle,NULL,-1) <= 0)
			AfxMessageBox("回复忙失败");
	}		
}

void CCCCall::OnStop() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("请选择记录");
	}else
	{
		DWORD dwHandle=m_CallList.GetItemData(L);
		if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_STOP	,dwHandle,NULL,-1) <= 0)
			AfxMessageBox("停止失败");
	}	
}

CString CCCCall::SelectFilePath(int iType)
{
	CString strDestPath;
	char szFile[260];       // buffer for filename
	OPENFILENAME ofn;
	memset(szFile,0,sizeof(szFile));
	ZeroMemory(&ofn, sizeof(OPENFILENAME));
	ofn.lStructSize = sizeof(OPENFILENAME);
	ofn.hwndOwner = AfxGetMainWnd()->GetSafeHwnd();
	ofn.lpstrFile = szFile;
	ofn.nMaxFile = sizeof(szFile);
	
	ofn.nFilterIndex = 1;
	ofn.lpstrFileTitle = NULL;
	ofn.nMaxFileTitle = 0;
	
	ofn.lpstrInitialDir = NULL;
	ofn.Flags = OFN_PATHMUSTEXIST | OFN_FILEMUSTEXIST|OFN_OVERWRITEPROMPT;
	
	ofn.lpstrFilter = "wav file\0*.wav;*.pcm;*.wave\0All file\0*.*\0";
	ofn.lpstrDefExt = ".wav";
	
	if(iType == 0)
	{
		if(::GetSaveFileName(&ofn))
		{
			strDestPath = szFile;
		}
	}else 
	{
		if(::GetOpenFileName(&ofn))
		{
			strDestPath = szFile;			
		}
	}
	if(!strDestPath.IsEmpty() && strDestPath.Find(".") < 0) strDestPath+=ofn.lpstrDefExt;
	return strDestPath;
}


void CCCCall::OnStartplayfile() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("请选择记录");
	}else
	{
		CString strFilePath=SelectFilePath(1);
		if(!strFilePath.IsEmpty())
		{
			DWORD dwHandle=m_CallList.GetItemData(L);
			if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_STARTPLAYFILE,dwHandle,(char*)(LPCTSTR)strFilePath,1) <= 0)
				AfxMessageBox("开始播放文件失败");
			else
				AppendStatus("开始播放文件");
		}
	}
}

void CCCCall::OnStopplayfile() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("请选择记录");
	}else
	{
		DWORD dwHandle=m_CallList.GetItemData(L);
		if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_STOPPLAYFILE,dwHandle,NULL,-1) <= 0)
			AfxMessageBox("停止播放文件");
		else
			AppendStatus("停止播放文件");
	}		
}

void CCCCall::OnStartrecordfile() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("请选择记录");
	}else
	{
		CString strFilePath=SelectFilePath(0);
		if(!strFilePath.IsEmpty())
		{
		DWORD dwHandle=m_CallList.GetItemData(L);
		if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_STARTRECFILE,dwHandle,(char*)(LPCTSTR)strFilePath,-1) <= 0)
			AfxMessageBox("开始文件录音失败");
		else
			AppendStatus("开始文件录音");
		}
	}	
}

void CCCCall::OnStopfilerecord() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("请选择记录");
	}else
	{
		DWORD dwHandle=m_CallList.GetItemData(L);
		if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_STOPRECFILE,dwHandle,NULL,-1) <= 0)
			AfxMessageBox("停止文件录音");
		else
			AppendStatus("停止文件录音");
	}			
}

void CCCCall::OnHold() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("请选择记录");
	}else
	{
		DWORD dwHandle=m_CallList.GetItemData(L);
		if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_HOLD,dwHandle,NULL,-1) <= 0)
			AfxMessageBox("保持通话失败");
		else
			AppendStatus("保持通话");
	}		
}

void CCCCall::OnUnhold() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("请选择记录");
	}else
	{
		DWORD dwHandle=m_CallList.GetItemData(L);
		if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_UNHOLD	,dwHandle,NULL,-1) <= 0)
			AfxMessageBox("恢复通话失败");
		else
			AppendStatus("恢复通话");
	}		
}

void CCCCall::OnSwitch() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("请选择记录");
	}else
	{
		CInputCC input;
		if(input.DoModal() == IDOK)
		{
		DWORD dwHandle=m_CallList.GetItemData(L);
		if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_SWITCH,dwHandle,(char*)(LPCTSTR)input.m_strCC,0) <= 0)
			AfxMessageBox("呼叫转移失败");
		}
	}		
}
