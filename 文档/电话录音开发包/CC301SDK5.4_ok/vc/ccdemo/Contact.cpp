// Contact.cpp : implementation file
//

#include "stdafx.h"
#include "ccdemo.h"
#include "Contact.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CContact dialog


CContact::CContact(CWnd* pParent /*=NULL*/)
	: CDialog(CContact::IDD, pParent)
{
	//{{AFX_DATA_INIT(CContact)
	m_strCC = _T("");
	//}}AFX_DATA_INIT
}


void CContact::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CContact)
	DDX_Text(pDX, IDC_CC, m_strCC);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CContact, CDialog)
	//{{AFX_MSG_MAP(CContact)
	ON_BN_CLICKED(IDC_ADD, OnAdd)
	ON_BN_CLICKED(IDC_DEL, OnDel)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CContact message handlers

BOOL CContact::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	QNV_Event(CCCTRL_CHANNELID,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

LRESULT CContact::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	if(message == BRI_EVENT_MESSAGE)//接收到事件
	{
		PBRI_EVENT pEvent=(PBRI_EVENT)lParam;//获取事件数据结构
		switch(pEvent->lEventType)
		{	
		case BriEvent_CC_AddContactSuccess://增加好友成功
			{
				AfxMessageBox("增加好友成功");
			}break;
		case BriEvent_CC_AddContactFailed://增加好友失败
			{
				AfxMessageBox("增加好友失败");
			}break;
		case BriEvent_CC_InviteContact://接收到增加好好友邀请
			{
				CMsgParse parse(pEvent->szData);
				CString str;
				str.Format("接收到增加好友的邀请 是否接受? \r\n cc:%s \r\n提示:%s",parse.GetParam(MSG_KEY_CC),parse.GetMsgText());
				if(MessageBox(str,"提示",MB_YESNO) == IDYES)
				{
					QNV_CCCtrl_Contact(QNV_CCCTRL_CONTACT_ACCEPT,(char*)(LPCTSTR)parse.GetParam(MSG_KEY_CC),"同意");
				}else
				{
					QNV_CCCtrl_Contact(QNV_CCCTRL_CONTACT_REFUSE,(char*)(LPCTSTR)parse.GetParam(MSG_KEY_CC),"拒绝");
				}
			}break;
		case BriEvent_CC_ReplyAcceptContact://对方回复同意为好友
			{
				CMsgParse parse(pEvent->szData);
				CString str;
				str.Format("%s 同意好友邀请",parse.GetParam(MSG_KEY_CC));
				MessageBox(str,"提示",MB_OK);
			}break;
		case BriEvent_CC_ReplyRefuseContact://对方回复拒绝为好友
			{
				CMsgParse parse(pEvent->szData);
				CString str;
				str.Format("%s 拒绝好友邀请",parse.GetParam(MSG_KEY_CC));
				MessageBox(str,"提示",MB_OK);
			}break;
		case BriEvent_CC_AcceptContactSuccess:
			{
				MessageBox("接收好友成功","提示",MB_OK);
			}break;//接受好友成功
		case BriEvent_CC_AcceptContactFailed:
			{
				MessageBox("接收好友失败","提示",MB_OK);
			}break;//接受好友失败
		case BriEvent_CC_RefuseContactSuccess:
			{
				MessageBox("拒绝好友成功","提示",MB_OK);
			}break;//拒绝好友成功
		case BriEvent_CC_RefuseContactFailed:
			{
				MessageBox("拒绝好友失败","提示",MB_OK);
			}break;//拒绝好友失败	
		case BriEvent_CC_DeleteContactSuccess:
			{
				MessageBox("删除好友成功","提示",MB_OK);
			}break;//删除好友成功
		case BriEvent_CC_DeleteContactFailed:
			{
				MessageBox("删除好友失败","提示",MB_OK);
			}break;//删除好友失败
		default:break;
		}
	}
	return CDialog::WindowProc(message, wParam, lParam);
}

void CContact::OnAdd() 
{
	UpdateData(TRUE);
	if( QNV_CCCtrl_Contact(QNV_CCCTRL_CONTACT_ADD,(char*)(LPCTSTR)m_strCC,"请求加为好友") <= 0)
		AfxMessageBox("添加好友失败");
}

void CContact::OnDel() 
{
	UpdateData(TRUE);
	if( QNV_CCCtrl_Contact(QNV_CCCTRL_CONTACT_DELETE,(char*)(LPCTSTR)m_strCC,"") <= 0)
		AfxMessageBox("添加好友失败");
}
