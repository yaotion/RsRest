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
	if(message == BRI_EVENT_MESSAGE)//���յ��¼�
	{
		PBRI_EVENT pEvent=(PBRI_EVENT)lParam;//��ȡ�¼����ݽṹ
		switch(pEvent->lEventType)
		{	
		case BriEvent_CC_AddContactSuccess://���Ӻ��ѳɹ�
			{
				AfxMessageBox("���Ӻ��ѳɹ�");
			}break;
		case BriEvent_CC_AddContactFailed://���Ӻ���ʧ��
			{
				AfxMessageBox("���Ӻ���ʧ��");
			}break;
		case BriEvent_CC_InviteContact://���յ����Ӻú�������
			{
				CMsgParse parse(pEvent->szData);
				CString str;
				str.Format("���յ����Ӻ��ѵ����� �Ƿ����? \r\n cc:%s \r\n��ʾ:%s",parse.GetParam(MSG_KEY_CC),parse.GetMsgText());
				if(MessageBox(str,"��ʾ",MB_YESNO) == IDYES)
				{
					QNV_CCCtrl_Contact(QNV_CCCTRL_CONTACT_ACCEPT,(char*)(LPCTSTR)parse.GetParam(MSG_KEY_CC),"ͬ��");
				}else
				{
					QNV_CCCtrl_Contact(QNV_CCCTRL_CONTACT_REFUSE,(char*)(LPCTSTR)parse.GetParam(MSG_KEY_CC),"�ܾ�");
				}
			}break;
		case BriEvent_CC_ReplyAcceptContact://�Է��ظ�ͬ��Ϊ����
			{
				CMsgParse parse(pEvent->szData);
				CString str;
				str.Format("%s ͬ���������",parse.GetParam(MSG_KEY_CC));
				MessageBox(str,"��ʾ",MB_OK);
			}break;
		case BriEvent_CC_ReplyRefuseContact://�Է��ظ��ܾ�Ϊ����
			{
				CMsgParse parse(pEvent->szData);
				CString str;
				str.Format("%s �ܾ���������",parse.GetParam(MSG_KEY_CC));
				MessageBox(str,"��ʾ",MB_OK);
			}break;
		case BriEvent_CC_AcceptContactSuccess:
			{
				MessageBox("���պ��ѳɹ�","��ʾ",MB_OK);
			}break;//���ܺ��ѳɹ�
		case BriEvent_CC_AcceptContactFailed:
			{
				MessageBox("���պ���ʧ��","��ʾ",MB_OK);
			}break;//���ܺ���ʧ��
		case BriEvent_CC_RefuseContactSuccess:
			{
				MessageBox("�ܾ����ѳɹ�","��ʾ",MB_OK);
			}break;//�ܾ����ѳɹ�
		case BriEvent_CC_RefuseContactFailed:
			{
				MessageBox("�ܾ�����ʧ��","��ʾ",MB_OK);
			}break;//�ܾ�����ʧ��	
		case BriEvent_CC_DeleteContactSuccess:
			{
				MessageBox("ɾ�����ѳɹ�","��ʾ",MB_OK);
			}break;//ɾ�����ѳɹ�
		case BriEvent_CC_DeleteContactFailed:
			{
				MessageBox("ɾ������ʧ��","��ʾ",MB_OK);
			}break;//ɾ������ʧ��
		default:break;
		}
	}
	return CDialog::WindowProc(message, wParam, lParam);
}

void CContact::OnAdd() 
{
	UpdateData(TRUE);
	if( QNV_CCCtrl_Contact(QNV_CCCTRL_CONTACT_ADD,(char*)(LPCTSTR)m_strCC,"�����Ϊ����") <= 0)
		AfxMessageBox("��Ӻ���ʧ��");
}

void CContact::OnDel() 
{
	UpdateData(TRUE);
	if( QNV_CCCtrl_Contact(QNV_CCCTRL_CONTACT_DELETE,(char*)(LPCTSTR)m_strCC,"") <= 0)
		AfxMessageBox("��Ӻ���ʧ��");
}
