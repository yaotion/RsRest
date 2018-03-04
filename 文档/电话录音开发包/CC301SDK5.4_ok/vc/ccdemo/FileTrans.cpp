// FileTrans.cpp : implementation file
//

#include "stdafx.h"
#include "ccdemo.h"
#include "FileTrans.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CFileTrans dialog


CFileTrans::CFileTrans(CWnd* pParent /*=NULL*/)
	: CDialog(CFileTrans::IDD, pParent)
{
	//{{AFX_DATA_INIT(CFileTrans)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}


void CFileTrans::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CFileTrans)
	DDX_Control(pDX, IDC_FILELIST, m_FileList);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CFileTrans, CDialog)
	//{{AFX_MSG_MAP(CFileTrans)
	ON_BN_CLICKED(IDC_STOP, OnStop)
	ON_BN_CLICKED(IDC_SHOWWIN, OnShowwin)
	ON_BN_CLICKED(IDC_HIDEWIN, OnHidewin)
	ON_BN_CLICKED(IDC_SAVE, OnSave)
	ON_BN_CLICKED(IDC_REFUSEFILE, OnRefusefile)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CFileTrans message handlers

BOOL CFileTrans::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	//�����ڻ�ȡ�¼�
	QNV_Event(CCCTRL_CHANNELID,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);
	InitList();
	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

long	CFileTrans::InitList()
{
	long lCoumnCount=0;	
	m_FileList.InsertColumn(lCoumnCount++,"CC",LVCFMT_LEFT,130);
	m_FileList.InsertColumn(lCoumnCount++,"�ǳ�",LVCFMT_LEFT,50);
	m_FileList.InsertColumn(lCoumnCount++,"��������",LVCFMT_LEFT,64);	
	m_FileList.InsertColumn(lCoumnCount++,"״̬",LVCFMT_LEFT,100);	
	m_FileList.InsertColumn(lCoumnCount++,"�ļ���",LVCFMT_LEFT,100);	
	m_FileList.InsertColumn(lCoumnCount++,"����(�ֽ�)",LVCFMT_LEFT,100);
	m_FileList.InsertColumn(lCoumnCount++,"����·��",LVCFMT_LEFT,64);
	m_FileList.SetExtendedStyle(m_FileList.GetExtendedStyle()|(LVS_EX_FULLROWSELECT | LVS_EX_SUBITEMIMAGES|LVS_EX_GRIDLINES));
	return 1;
}

void CFileTrans::FreeSource()
{
	for(int i=0;i<m_FileList.GetItemCount();i++)
	{
		Cqnvfiletransfer1 *p=(Cqnvfiletransfer1*)m_FileList.GetItemData(i);
		p->FT_StopFileTrans(0);
		p->FT_ReleaseSource(0);
		delete p;
	}
	m_FileList.DeleteAllItems();
}

void CFileTrans::OnCancel() 
{	
	ShowWindow(SW_HIDE);//ֻ���ز�����(Ҫ���پͻص���Ϣ��������)
	//CDialog::OnCancel();
}

long CFileTrans::GetFirstSelectedItem()
{
	POSITION pos=m_FileList.GetFirstSelectedItemPosition();
	if (pos == NULL) return -1;
	return m_FileList.GetNextSelectedItem(pos);	
}

void CFileTrans::OnStop() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("��ѡ���¼");
	}else
	{
		DeleteTransItem(L);
	}	
}
//ɾ���ڵ�
long	CFileTrans::DeleteTransItem(int L)
{
	Cqnvfiletransfer1 *p=(Cqnvfiletransfer1*)m_FileList.GetItemData(L);
	p->FT_StopFileTrans(0);
	p->FT_ReleaseSource(0);
	delete p;
	m_FileList.DeleteItem(L);
	return 1;
}

//�̶ֹ�λ�ô����ļ��������
Cqnvfiletransfer1*	CFileTrans::CreateTransferOCX()
{
	Cqnvfiletransfer1 *pfiletransfer=new Cqnvfiletransfer1();
	RECT rc={150,153,335,230};
	CString szClassName = AfxRegisterWndClass(CS_CLASSDC|CS_SAVEBITS,LoadCursor(NULL, IDC_ARROW));
	if(!pfiletransfer->Create(szClassName,_T("filetransfer"),WS_CHILD ,rc,this,19995))		
	{//|WS_TABSTOP|WS_CLIPCHILDREN	
		delete pfiletransfer;
		return NULL;
	}else
	{
		pfiletransfer->ShowWindow(SW_HIDE);	
		return pfiletransfer;
	}
}

long	CFileTrans::AppendRecvFile(DWORD dwHandle,CString  strData)
{
	CMsgParse parse(strData);
	CString strCC=parse.GetParam(MSG_KEY_CC);//cc����
	CString strNick=parse.GetParam(MSG_KEY_NAME);//�ǳ�
	CString strFile=parse.GetParam(MSG_KEY_FILENAME);//�ļ���
	__int64 i64Size=_atoi64((char*)(LPCTSTR)parse.GetParam(MSG_KEY_FILESIZE));//Ŀǰ�汾���֧���ļ�����Ϊ0x7FFFFFFF�ֽ�
	CString strLocalPath;
	Cqnvfiletransfer1 *p=CreateTransferOCX();
	if(!p) 
	{
		AfxMessageBox("�����ļ��������ʧ��");
		return 0;
	}else
	{
		long lRet=p->FT_RecvRequest(strCC,strFile,(DWORD)i64Size,0x30301,0,dwHandle);//0x30301 �汾��ǣ������޸�
		AppendFileList(strCC,strNick,"����","�ȴ�����",strFile,i64Size,strLocalPath,p);
		return 1;
	}
}

long	CFileTrans::StartSendFile(LPCTSTR lpCC,LPCTSTR lpFilePath)
{
	Cqnvfiletransfer1 *p=CreateTransferOCX();
	if(!p) 
	{
		AfxMessageBox("�����ļ��������ʧ��");
		return 0;
	}else
	{
		long lTransHandle=p->FT_SendRequest((LPCTSTR)lpCC,(LPCTSTR)lpFilePath,0x30301,0);	//0x30301 �汾��ǣ������޸�
		if( lTransHandle <= 0)
		{
			AfxMessageBox("����ʧ��");
			return 0;
		}else
		{			
			AppendFileList(lpCC,"","����","�ȴ�����",lpFilePath,p->FT_GetFileSize(),lpFilePath,p);
			return 1;
		}
	}
}

long	CFileTrans::AppendFileList(LPCTSTR lpCC,LPCTSTR lpNick,LPCTSTR lpTransType,LPCTSTR lpState,LPCTSTR lpFileName,__int64 i64FileSize,LPCTSTR lpLocalPath,Cqnvfiletransfer1 *p)
{
	int L=0;
	m_FileList.InsertItem(L,lpCC);
	m_FileList.SetItemText(L,1,lpNick);
	m_FileList.SetItemText(L,2,lpTransType);
	m_FileList.SetItemText(L,3,lpState);
	m_FileList.SetItemText(L,4,lpFileName);
	CString strSize;
	strSize.Format("%i64",i64FileSize);
	m_FileList.SetItemText(L,5,strSize);
	m_FileList.SetItemText(L,6,lpLocalPath);
	m_FileList.SetItemData(L,(DWORD)p);
	return 1;
}

//�������Ӿ����ýڵ�ID
int		CFileTrans::GetHandleItem(DWORD dwHandle)
{
	for(int i=0;i<m_FileList.GetItemCount();i++)
	{
		Cqnvfiletransfer1 *p=(Cqnvfiletransfer1*)m_FileList.GetItemData(i);
		if((DWORD)p->FT_GetSID() == dwHandle) return i;
	}
	return -1;
}

LRESULT CFileTrans::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	if(message == BRI_EVENT_MESSAGE)//���յ��¼�
	{
		PBRI_EVENT pEvent=(PBRI_EVENT)lParam;//��ȡ�¼����ݽṹ
		CString strValue,str;
		strValue.Format("Handle=%d Result=%d Data=%s",pEvent->lEventHandle,pEvent->lResult,pEvent->szData);
		switch(pEvent->lEventType)
		{
			case BriEvent_CC_TransFileFinished:
				{					
					int L=GetHandleItem(pEvent->lEventHandle);
					if(L >= 0)
					{
						Cqnvfiletransfer1 *p=(Cqnvfiletransfer1*)m_FileList.GetItemData(L);
						long lRequestType=p->FT_GetRequestType();//��ȡ��������/����/����
						long lRet=p->FT_StopFileTrans(0);//ֹͣ�����ش�����				
						if(lRet == 1)
						{
							if (lRequestType == 0)//����
							{
								str.Format("�����ļ���� %s",strValue);
							}else//����
							{
								str.Format("�����ļ���� %s",strValue);
							}
						}else if( lRet != 2)//�Ѿ�ֹͣ���ĺ���
						{
							if (pEvent->lResult == TMMERR_CLIENTREFUSE ||
								pEvent->lResult == TMMERR_CLIENTCANCEL || 
								pEvent->lResult == TMMERR_CLIENTSTOP)
									str.Format("�Է�ֹͣ���� %s",strValue);							
							else
								str.Format("���Ѿ�ֹͣ���� %s",strValue);	
						}
						DeleteTransItem(L);
					}
				}break;
			default:break;
		}		
		if(!str.IsEmpty())
			AppendStatus(str);
	}
	return CDialog::WindowProc(message, wParam, lParam);
}

//��ʾ��ʾ״̬�ı�
void CFileTrans::AppendStatus(CString strStatus)
{
	CString str,strTime;
	CTime ct=CTime::GetCurrentTime();
	strTime.Format("[%02d:%02d:%02d] %s tick=%d",ct.GetHour(),ct.GetMinute(),ct.GetSecond(),strStatus,GetTickCount());	
	CString strSrc;
	GetDlgItem(IDC_FILESTATUS)->GetWindowText(strSrc);
	if(strSrc.GetLength() > 16000)
		strSrc .Empty();
	str=strTime+"\r\n"+strSrc;
	GetDlgItem(IDC_FILESTATUS)->SetWindowText(str);
}
//
void CFileTrans::OnShowwin() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("��ѡ���¼");
	}else
	{
		Cqnvfiletransfer1 *p=(Cqnvfiletransfer1*)m_FileList.GetItemData(L);
		p->ShowWindow(SW_SHOW);
	}		
}
//
void CFileTrans::OnHidewin() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("��ѡ���¼");
	}else
	{
		Cqnvfiletransfer1 *p=(Cqnvfiletransfer1*)m_FileList.GetItemData(L);
		p->ShowWindow(SW_HIDE);
	}				
}

CString CFileTrans::GetSaveFilePath(LPCTSTR lpFileName)
{
	CString strDestPath;
	char szFile[260]={0};
	if(lpFileName) strcpy(szFile,lpFileName);
	OPENFILENAME ofn={0};
	ofn.lStructSize = sizeof(OPENFILENAME);
	ofn.hwndOwner = m_hWnd;
	ofn.lpstrFile = szFile;
	ofn.nMaxFile = sizeof(szFile);
	ofn.nFilterIndex = 1;
	ofn.lpstrFileTitle = NULL;
	ofn.nMaxFileTitle = 0;
	ofn.lpstrInitialDir = NULL;
	ofn.Flags = OFN_PATHMUSTEXIST | OFN_OVERWRITEPROMPT;
	ofn.lpstrFilter = "All file\0*.*\0";
	ofn.lpstrDefExt = NULL;
	if(::GetSaveFileName(&ofn))
	{
		strDestPath = szFile;
	}	
	return strDestPath;
}

void CFileTrans::OnSave() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("��ѡ���¼");
	}else
	{
		if(m_FileList.GetItemText(L,2) == "����" && m_FileList.GetItemText(L,3) == "�ȴ�����")
		{
			CString strFilePath = GetSaveFilePath(m_FileList.GetItemText(L,4));
			if(!strFilePath.IsEmpty())
			{
				Cqnvfiletransfer1 *p=(Cqnvfiletransfer1*)m_FileList.GetItemData(L);		
				p->FT_ReplyRecvFileRequest(p->FT_GetSID(),(LPCTSTR)strFilePath,0,TRUE);
				m_FileList.SetItemText(L,3,"�ѽ���");
			}
		}else
		{
			AfxMessageBox("��״̬���ܽ��ձ���");
		}
	}			
}

void CFileTrans::OnRefusefile() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("��ѡ���¼");
	}else
	{
		if(m_FileList.GetItemText(L,2) == "����" && m_FileList.GetItemText(L,3) == "�ȴ�����")
		{
			Cqnvfiletransfer1 *p=(Cqnvfiletransfer1*)m_FileList.GetItemData(L);		
			p->FT_StopFileTrans(0);	
		}else
			AfxMessageBox("��״̬���ܾܾ�����");
	}				
}
