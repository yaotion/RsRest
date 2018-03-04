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
	
	//本窗口获取事件
	QNV_Event(CCCTRL_CHANNELID,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);
	InitList();
	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

long	CFileTrans::InitList()
{
	long lCoumnCount=0;	
	m_FileList.InsertColumn(lCoumnCount++,"CC",LVCFMT_LEFT,130);
	m_FileList.InsertColumn(lCoumnCount++,"昵称",LVCFMT_LEFT,50);
	m_FileList.InsertColumn(lCoumnCount++,"传输类型",LVCFMT_LEFT,64);	
	m_FileList.InsertColumn(lCoumnCount++,"状态",LVCFMT_LEFT,100);	
	m_FileList.InsertColumn(lCoumnCount++,"文件名",LVCFMT_LEFT,100);	
	m_FileList.InsertColumn(lCoumnCount++,"长度(字节)",LVCFMT_LEFT,100);
	m_FileList.InsertColumn(lCoumnCount++,"本地路径",LVCFMT_LEFT,64);
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
	ShowWindow(SW_HIDE);//只隐藏不销毁(要销毁就回调消息给主窗口)
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
		AfxMessageBox("请选择记录");
	}else
	{
		DeleteTransItem(L);
	}	
}
//删除节点
long	CFileTrans::DeleteTransItem(int L)
{
	Cqnvfiletransfer1 *p=(Cqnvfiletransfer1*)m_FileList.GetItemData(L);
	p->FT_StopFileTrans(0);
	p->FT_ReleaseSource(0);
	delete p;
	m_FileList.DeleteItem(L);
	return 1;
}

//字固定位置创建文件传输组件
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
	CString strCC=parse.GetParam(MSG_KEY_CC);//cc号码
	CString strNick=parse.GetParam(MSG_KEY_NAME);//昵称
	CString strFile=parse.GetParam(MSG_KEY_FILENAME);//文件名
	__int64 i64Size=_atoi64((char*)(LPCTSTR)parse.GetParam(MSG_KEY_FILESIZE));//目前版本最大支持文件长度为0x7FFFFFFF字节
	CString strLocalPath;
	Cqnvfiletransfer1 *p=CreateTransferOCX();
	if(!p) 
	{
		AfxMessageBox("创建文件传输组件失败");
		return 0;
	}else
	{
		long lRet=p->FT_RecvRequest(strCC,strFile,(DWORD)i64Size,0x30301,0,dwHandle);//0x30301 版本标记，不能修改
		AppendFileList(strCC,strNick,"接收","等待保存",strFile,i64Size,strLocalPath,p);
		return 1;
	}
}

long	CFileTrans::StartSendFile(LPCTSTR lpCC,LPCTSTR lpFilePath)
{
	Cqnvfiletransfer1 *p=CreateTransferOCX();
	if(!p) 
	{
		AfxMessageBox("创建文件传输组件失败");
		return 0;
	}else
	{
		long lTransHandle=p->FT_SendRequest((LPCTSTR)lpCC,(LPCTSTR)lpFilePath,0x30301,0);	//0x30301 版本标记，不能修改
		if( lTransHandle <= 0)
		{
			AfxMessageBox("发送失败");
			return 0;
		}else
		{			
			AppendFileList(lpCC,"","发送","等待传输",lpFilePath,p->FT_GetFileSize(),lpFilePath,p);
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

//根据连接句柄获得节点ID
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
	if(message == BRI_EVENT_MESSAGE)//接收到事件
	{
		PBRI_EVENT pEvent=(PBRI_EVENT)lParam;//获取事件数据结构
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
						long lRequestType=p->FT_GetRequestType();//获取传输类型/发送/接收
						long lRet=p->FT_StopFileTrans(0);//停止并返回传输结果				
						if(lRet == 1)
						{
							if (lRequestType == 0)//接收
							{
								str.Format("接收文件完成 %s",strValue);
							}else//发送
							{
								str.Format("发送文件完成 %s",strValue);
							}
						}else if( lRet != 2)//已经停止过的忽略
						{
							if (pEvent->lResult == TMMERR_CLIENTREFUSE ||
								pEvent->lResult == TMMERR_CLIENTCANCEL || 
								pEvent->lResult == TMMERR_CLIENTSTOP)
									str.Format("对方停止传输 %s",strValue);							
							else
								str.Format("您已经停止传输 %s",strValue);	
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

//显示提示状态文本
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
		AfxMessageBox("请选择记录");
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
		AfxMessageBox("请选择记录");
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
		AfxMessageBox("请选择记录");
	}else
	{
		if(m_FileList.GetItemText(L,2) == "接收" && m_FileList.GetItemText(L,3) == "等待保存")
		{
			CString strFilePath = GetSaveFilePath(m_FileList.GetItemText(L,4));
			if(!strFilePath.IsEmpty())
			{
				Cqnvfiletransfer1 *p=(Cqnvfiletransfer1*)m_FileList.GetItemData(L);		
				p->FT_ReplyRecvFileRequest(p->FT_GetSID(),(LPCTSTR)strFilePath,0,TRUE);
				m_FileList.SetItemText(L,3,"已接收");
			}
		}else
		{
			AfxMessageBox("该状态不能接收保存");
		}
	}			
}

void CFileTrans::OnRefusefile() 
{
	long L=GetFirstSelectedItem();
	if(L < 0) 
	{
		AfxMessageBox("请选择记录");
	}else
	{
		if(m_FileList.GetItemText(L,2) == "接收" && m_FileList.GetItemText(L,3) == "等待保存")
		{
			Cqnvfiletransfer1 *p=(Cqnvfiletransfer1*)m_FileList.GetItemData(L);		
			p->FT_StopFileTrans(0);	
		}else
			AfxMessageBox("该状态不能拒绝接收");
	}				
}
