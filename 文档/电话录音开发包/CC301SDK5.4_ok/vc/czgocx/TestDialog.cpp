// TestDialog.cpp : implementation file
//

#include "stdafx.h"
#include "czgocx.h"
#include "TestDialog.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CTestDialog dialog

const int THISCHANNEL = 0 ;
CTestDialog::CTestDialog(CWnd* pParent /*=NULL*/)
	: CDialog(CTestDialog::IDD, pParent)
{
	//{{AFX_DATA_INIT(CTestDialog)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	m_strServer = "" ;
	m_strCC = "1001622952968" ;
	m_strPwd = "czg20100308" ;
	m_nChannelID = THISCHANNEL ;
}


void CTestDialog::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CTestDialog)
	DDX_Control(pDX, IDC_SELECTLINE, m_cSelectLine);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CTestDialog, CDialog)
	//{{AFX_MSG_MAP(CTestDialog)
	ON_BN_CLICKED(IDC_OPENDEV, OnOpendev)
	ON_BN_CLICKED(IDC_CLOSEDEV, OnClosedev)
	ON_BN_CLICKED(IDC_SETCCSERVER, OnSetccserver)
	ON_BN_CLICKED(IDC_LOGON, OnLogon)
	ON_BN_CLICKED(IDC_LOGOFF, OnLogoff)
	ON_BN_CLICKED(IDC_ANSWERCALL, OnAnswercall)
	ON_BN_CLICKED(IDC_REJECTCALL, OnRejectcall)
	ON_BN_CLICKED(IDC_DISABLERING, OnDisablering)
	ON_BN_CLICKED(IDC_STARTRING, OnStartring)
	ON_BN_CLICKED(IDC_STOP, OnStop)
	ON_CBN_SELCHANGE(IDC_SELECTLINE, OnSelchangeSelectline)
	ON_WM_DESTROY()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CTestDialog message handlers


//显示提示状态文本
void CTestDialog::AppendStatus(CString strStatus)
{
	TRACE ( "显示信息:%s\n" , strStatus ) ;
	CString str,strTime;
	CTime ct=CTime::GetCurrentTime();
	strTime.Format("[%02d:%02d:%02d] %s",ct.GetHour(),ct.GetMinute(),ct.GetSecond(),strStatus);	
	CString strSrc;
	GetDlgItem(IDC_CCSTATUS)->GetWindowText(strSrc);
	if(strSrc.GetLength() > 16000)
		strSrc .Empty();
	str=strTime+"\r\n"+strSrc;
	GetDlgItem(IDC_CCSTATUS)->SetWindowText(str);
}

void CTestDialog::OnOpendev() 
{
	if(QNV_OpenDevice(ODT_LBRIDGE,0,0) > 0)
	{
		AppendStatus("打开设备成功");
		for(BRIINT16 i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
		{//在windowproc处理接收到的消息
			m_cSelectLine.SetCurSel(QNV_GetDevCtrl(m_nChannelID,QNV_CTRL_SELECTLINEIN));
			//QNV_Event(i,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);//窗口模式
			QNV_Event(i,QNV_EVENT_REGCBFUNC,(long)this,(char*)CallbackEvent,NULL,0);//回调函数模式
		}	
	}else
	{
		AppendStatus("打开设备失败");
	}
}

BRIINT32 WINAPI CTestDialog::CallbackEvent(BRIINT16 uChannelID,BRIUINT32 dwUserData,BRIINT32 lType,BRIINT32 lHandle,BRIINT32 lResult,BRIINT32 lParam,BRIPCHAR8 pData,BRIPCHAR8 pDataEx)
{
	CTestDialog *p=(CTestDialog*)dwUserData;
	BRI_EVENT Event={0};
	Event.lEventHandle = lHandle;
	Event.lEventType = lType;
	Event.lParam=lParam;
	Event.lResult=lResult;
	Event.uChannelID=uChannelID;
	if(pData) strcpy(Event.szData,pData);
	if(pDataEx) strcpy(Event.szDataEx,pDataEx);
	p->ShowEvent(&Event);
	return 1;
}

long	CTestDialog::ShowEvent(PBRI_EVENT pEvent)
{
	CString strValue,str;
	strValue.Format("Handle=%d Result=%d Data=%s",pEvent->lEventHandle,pEvent->lResult,pEvent->szData);
	switch(pEvent->lEventType)
	{
	case BriEvent_PhoneHook:str.Format("通道%d: 电话机摘机 %s",pEvent->uChannelID+1,strValue);break;
	case BriEvent_PhoneHang:str.Format("通道%d: 电话机挂机 %s",pEvent->uChannelID+1,strValue);break;
	case BriEvent_CallIn:
		{
			str.Format("通道%d: 来电响铃 %s",pEvent->uChannelID+1,strValue);
		}break;
	case BriEvent_GetCallID:
		{
			str.Format("通道%d: 接收到来电号码 %s",pEvent->uChannelID+1,strValue);
			return 1;
		}break;
	case BriEvent_StopCallIn:
		{
			str.Format("通道%d: 停止呼入，产生一个未接电话 %s",pEvent->uChannelID+1,strValue);
		}break;
	case BriEvent_GetDTMFChar:str.Format("通道%d: 接收到按键 %s",pEvent->uChannelID+1,strValue);break;		
	case BriEvent_RemoteHang:
		{
			str.Format("通道%d: 远程挂机 %s",pEvent->uChannelID+1,strValue);
		}break;
	case BriEvent_Busy:
		{
			str.Format("通道%d: 接收到忙音,线路已经断开 %s",pEvent->uChannelID+1,strValue);
		}break;
	case BriEvent_DialTone:str.Format("通道%d: 检测到拨号音 %s",pEvent->uChannelID+1,strValue);break;
	case BriEvent_PhoneDial:str.Format("通道%d: 电话机拨号 %s",pEvent->uChannelID+1,strValue);break;
	case BriEvent_RingBack:str.Format("通道%d: 拨号后接收到回铃音 %s",pEvent->uChannelID+1,strValue);break;
		
	case BriEvent_CC_ConnectFailed:str.Format("连接服务器失败");break;
	case BriEvent_CC_LoginFailed://登陆失败
		{
			str.Format("登陆失败 原因=%d %s",pEvent->lResult,strValue);
		}break;
	case BriEvent_CC_CallOutSuccess:str.Format("正在呼叫... %s",strValue);break;
	case BriEvent_CC_CallOutFailed:
		{				
			str.Format("呼叫失败 原因=%d ",pEvent->lResult);				
		}break;
	case BriEvent_CC_Connected:
		{
			str.Format("CC已经连通 %s",strValue);				
		}break;
	case BriEvent_CC_CallFinished:
		{
			str.Format("呼叫结束 原因=%d",pEvent->lResult);
		}break;
		
	case BriEvent_CC_LoginSuccess:str.Format("登陆成功 %s",strValue);break;
	case BriEvent_CC_CallIn:
		str.Format("来电呼入 \r\n%s",pEvent->szData);
		AppendCallIn(pEvent->lEventHandle,pEvent->szData);
		break;
	case BriEvent_CC_ReplyBusy:str.Format("对方回复忙 \r\n%s",pEvent->szData);break;
	case BriEvent_CC_RecvedMsg:str.Format("接收到消息 \r\n%s",pEvent->szData);break;
	case BriEvent_CC_RecvedCmd:str.Format("接收到命令 \r\n%s",pEvent->szData);break;
	default:break;
	}
	if(!str.IsEmpty())
		AppendStatus(str);
	return 1;
}

void CTestDialog::OnClosedev() 
{
	QNV_CloseDevice(ODT_ALL,0);
	AppendStatus("关闭设备完成");
}

LRESULT CTestDialog::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	if(message == BRI_EVENT_MESSAGE)//接收到事件
	{
		PBRI_EVENT pEvent=(PBRI_EVENT)lParam;//获取事件数据结构
		ShowEvent(pEvent);
	}
	return CDialog::WindowProc(message, wParam, lParam);
}

BOOL CTestDialog::PreTranslateMessage(MSG* pMsg) 
{
	if(pMsg->message == WM_KEYDOWN && pMsg->wParam == VK_ESCAPE)
	{//不能呼叫掉TSTCON32.EXE,该TSTCON32.EXE自动处理了被强制处理esc键，在其它容器应该会忽略该键盘事件，直接传递到本窗口
		return FALSE;
	}
	return CDialog::PreTranslateMessage(pMsg);
}

void CTestDialog::OnSetccserver() 
{
	// TODO: Add your control notification handler code here
	if(QNV_OpenDevice(ODT_CC,0,QNV_CC_LICENSE) <= 0 )//加载CC模块
	{
		AppendStatus("加载CC模块失败");
		return ;
	}else
	{
		//注册本窗口接收CC模块的事件
		//在windowproc处理接收到的消息
		//QNV_Event(CCCTRL_CHANNELID,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);
		//注册使用回调函数方式获取事件,跟窗口消息只要二选一就可以
		QNV_Event(CCCTRL_CHANNELID,QNV_EVENT_REGCBFUNC,(long)this,(char*)CallbackEvent,NULL,0);
		//
		AppendStatus("加载CC模块完成");
		return ;
	}
	if(QNV_CCCtrl(QNV_CCCTRL_SETSERVER,(char*)(LPCTSTR)m_strServer,0) <= 0)
	{
		AppendStatus("修改服务器IP地址失败 "+m_strServer);
	}else
		AppendStatus("修改服务器IP地址完成,可以重新登陆.. "+m_strServer);
}

void CTestDialog::OnLogon() 
{
	// TODO: Add your control notification handler code here
	if(QNV_CCCtrl(QNV_CCCTRL_ISLOGON,NULL,0) > 0)
	{
		QNV_CCCtrl(QNV_CCCTRL_LOGOUT,NULL,0);
		AppendStatus("已经在线,先离线.");
	}
	CString strValue=m_strCC+","+m_strPwd;//','分隔
	if(QNV_CCCtrl(QNV_CCCTRL_LOGIN,(char*)(LPCTSTR)strValue,0) <= 0)//开始登陆
	{
		AppendStatus("登陆失败,CC:"+m_strCC);
	}
	else
		AppendStatus("开始登陆,CC: "+m_strCC);	
}

void CTestDialog::OnLogoff() 
{
	// TODO: Add your control notification handler code here
	QNV_CCCtrl(QNV_CCCTRL_LOGOUT,NULL,0);
	AppendStatus("CC已经离线");	
}

void CTestDialog::OnAnswercall() 
{
	// TODO: Add your control notification handler code here
	QNV_SetDevCtrl((short)m_nChannelID,QNV_CTRL_DOPHONE,FALSE);//话机不可用
	QNV_SetDevCtrl((short)m_nChannelID,QNV_CTRL_SELECTLINEIN,LINEIN_ID_1);//使用话机话柄
	if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_ACCEPT,m_dwHandle,NULL,m_nChannelID) <= 0)
		AppendStatus("接听失败");
}

void CTestDialog::OnRejectcall() 
{
	// TODO: Add your control notification handler code here
	if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_REFUSE,m_dwHandle,NULL,-1) <= 0)
		AppendStatus("拒绝失败");
}

long CTestDialog::AppendCallIn(DWORD dwHandle, CString strData)
{
	CMsgParse parse(strData);
	m_strCC=parse.GetParam(MSG_KEY_CC);//cc号码
	m_strNick=parse.GetParam(MSG_KEY_NAME);//昵称
	m_dwHandle = dwHandle ;
	CString str ;
	str.Format ( "CC号码:%s 昵称:%s 呼叫ID:%d" , m_strCC , m_strNick , dwHandle ) ;
	AppendStatus(str) ;
	//add by czg 20100315
	OnAnswercall() ;
	return 1 ;
}

void CTestDialog::OnDisablering() 
{
	// TODO: Add your control notification handler code here
	if(QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_DOPHONE,!((CButton*)GetDlgItem(IDC_DISABLERING))->GetCheck()) <= 0
		&& ((CButton*)GetDlgItem(IDC_DISABLERING))->GetCheck() )
	{
		((CButton*)GetDlgItem(IDC_DISABLERING))->SetCheck(FALSE);
		AppendStatus("断开失败,可能是设备不支持该功能");
	}
}

void CTestDialog::OnStartring() 
{
	// TODO: Add your control notification handler code here
	if(QNV_GetDevCtrl(m_nChannelID,QNV_CTRL_DOPHONE) && ((CButton*)GetDlgItem(IDC_STARTRING))->GetCheck())
	{
		((CButton*)GetDlgItem(IDC_STARTRING))->SetCheck(FALSE);
		AppendStatus("请先断开电话机");
	}else
	{
	if(((CButton*)GetDlgItem(IDC_STARTRING))->GetCheck())
	{
		char szCallID[16]={0};//call ID
		for(int i=0;i<12;i++)
		{
			szCallID[i]=rand()%10+'0';
		}
		QNV_SetParam(m_nChannelID,QNV_PARAM_RINGCALLIDTYPE,DIALTYPE_FSK/*DIALTYPE_DTMF*/);//设置送码方式为一声后FSK模式,默认为一声前dtmf模式
		QNV_General(m_nChannelID,QNV_GENERAL_STARTRING,0,szCallID);	
		CString str=(CString)"开始内线模拟间隔震铃 -> 模拟来电号码："+szCallID;
		AppendStatus(str);
	}else
		QNV_General(m_nChannelID,QNV_GENERAL_STOPRING,0,NULL);	
	}
}

void CTestDialog::OnStop() 
{
	// TODO: Add your control notification handler code here
	if(QNV_CCCtrl_Call(QNV_CCCTRL_CALL_STOP	,m_dwHandle,NULL,-1) <= 0)
		AppendStatus("停止失败");
}

void CTestDialog::OnSelchangeSelectline() 
{
	// TODO: Add your control notification handler code here
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_SELECTLINEIN,LINEIN_ID_1);
}

void CTestDialog::OnDestroy() 
{
	OnClosedev();
	CDialog::OnDestroy();	
}
