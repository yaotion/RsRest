// Remote.cpp : implementation file
//

#include "stdafx.h"
#include "qnviccubdemo.h"
#include "Remote.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CRemote dialog


CRemote::CRemote(CWnd* pParent /*=NULL*/)
	: CDialog(CRemote::IDD, pParent)
{
	//{{AFX_DATA_INIT(CRemote)
	m_strFilePath = _T("c:\\windows\\notepad.exe");
	m_strURL = _T("http://127.0.0.1:80/fileupload/upload.htm?path=cccc");
	m_strSaveFilePath = _T("baidu.html");
	m_strdownurl = _T("http://www.baidu.com");
	//}}AFX_DATA_INIT
	m_lUploadHandle = -1;
	m_lDownloadHandle= -1;
	m_nChannelID = REMOTE_CHANNELID;
}


void CRemote::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CRemote)
	DDX_Control(pDX, IDC_SAVEFILEPATH, m_cSaveFilePath);
	DDX_Text(pDX, IDC_UPLOADFILEPATH, m_strFilePath);
	DDX_Text(pDX, IDC_URL, m_strURL);
	DDX_Text(pDX, IDC_SAVEFILEPATH, m_strSaveFilePath);
	DDX_Text(pDX, IDC_DOWNLOADURL, m_strdownurl);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CRemote, CDialog)
	//{{AFX_MSG_MAP(CRemote)
	ON_BN_CLICKED(IDC_UPLOAD, OnUpload)
	ON_BN_CLICKED(IDC_SELECT, OnSelect)
	ON_WM_DESTROY()
	ON_BN_CLICKED(IDC_UPLOADLOG, OnUploadlog)
	ON_BN_CLICKED(IDC_SELECTFILE, OnSelectfile)
	ON_BN_CLICKED(IDC_DOWNLOAD, OnDownload)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CRemote message handlers


BOOL CRemote::OnInitDialog() 
{
	CDialog::OnInitDialog();
	QNV_Event(m_nChannelID,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);
	UpdateData(FALSE);
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}


void CRemote::OnUpload() 
{
	UpdateData(TRUE);
	/*
	if(m_strFilePath.IsEmpty())
	{
		AfxMessageBox("�ļ�·������Ϊ��");
		return;
	}
	*/
	if(m_strURL.IsEmpty())
	{
		AfxMessageBox("��������ַ����Ϊ��");
		return;
	}
	CString strHTTPCookie="asssssssssssssss";
	//QNV_Remote(QNV_REMOTE_SETCOOKIE,0,(char*)(LPCTSTR)strHTTPCookie,NULL,NULL,0);//����COOKIE
	//QNV_Remote(QNV_REMOTE_UPLOAD_START,OPTYPE_SAVE,(char*)(LPCTSTR)m_strURL,(char*)(LPCTSTR)"d:\\dem.txt",NULL,0);
	m_lUploadHandle=QNV_Remote(QNV_REMOTE_UPLOAD_START,OPTYPE_SAVE,(char*)(LPCTSTR)m_strURL,(char*)(LPCTSTR)m_strFilePath,NULL,0);
	if(m_lUploadHandle <= 0)
	{
		CString str;
		str.Format("�����ϴ�ʧ�� %d",m_lUploadHandle);
		AfxMessageBox(str);
	}
}

void CRemote::OnSelect() 
{
	CString strPath=((CQnviccubdemoApp*)AfxGetApp())->GetSelectedFilePath2("Select File(*.*)|*.*;||","","","",m_hWnd,TRUE);
	if(!strPath.IsEmpty())
	{
		m_strFilePath = strPath;
		UpdateData(FALSE);
	}
}

LRESULT CRemote::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	if(message == BRI_EVENT_MESSAGE)
	{
		PBRI_EVENT pEvent=(PBRI_EVENT)lParam;
		long lResult=pEvent->lResult;
		CString str;
		switch(pEvent->lEventType)
		{
		case BriEvent_UploadSuccess:
			{
				str.Format("ͨ��%d: �ϴ��ļ��ɹ� handle=%d szData=%s curhandle=%d",m_nChannelID+1,lResult,pEvent->szData,m_lUploadHandle);
			}break;
		case BriEvent_UploadFailed:
			{
				str.Format("ͨ��%d: �ϴ��ļ�ʧ�� handle=%d szData=%s curhandle=%d",m_nChannelID+1,lResult,pEvent->szData,m_lUploadHandle);
			}break;
		case BriEvent_DownloadSuccess:
			{
				str.Format("ͨ��%d: �����ļ��ɹ� handle=%d szData=%s curhandle=%d",m_nChannelID+1,lResult,pEvent->szData,m_lUploadHandle);
			}break;
		case BriEvent_DownloadFailed:
			{
				str.Format("ͨ��%d: �����ļ�ʧ�� handle=%d szData=%s curhandle=%d",m_nChannelID+1,lResult,pEvent->szData,m_lUploadHandle);
			}break;
		default:break;
		}
		if(!str.IsEmpty()) AfxMessageBox(str);
	}
	return CDialog::WindowProc(message, wParam, lParam);
}

void CRemote::OnDestroy() 
{
	QNV_Event(m_nChannelID,QNV_EVENT_UNREGWND,(DWORD)m_hWnd,NULL,NULL,0);
	CDialog::OnDestroy();	
}

void CRemote::OnUploadlog() 
{
	QNV_Remote(QNV_REMOTE_UPLOAD_LOG,0,NULL,NULL,NULL,0);	
}

void CRemote::OnSelectfile() 
{
	CString strPath=((CQnviccubdemoApp*)AfxGetApp())->GetSelectedFilePath2("Select File(*.*)|*.*;||","","","",m_hWnd,TRUE);
	if(!strPath.IsEmpty())
	{
		m_strSaveFilePath = strPath;
		UpdateData(FALSE);
	}	
}

void CRemote::OnDownload() 
{
	UpdateData(TRUE);
	if(m_strdownurl.IsEmpty())
	{
		AfxMessageBox("url��ַ����Ϊ��");
		return;
	}
	CString strHTTPCookie="asssssssssssssss";
	//QNV_Remote(QNV_REMOTE_SETCOOKIE,0,(char*)(LPCTSTR)strHTTPCookie,NULL,NULL,0);//����COOKIE
	if(m_strSaveFilePath.IsEmpty())
	{//���浽������
#define		BUF_SIZE	512
		//���ʹ���첽���ڴ������ȫ�ֵ�
		char szBuf[BUF_SIZE]={0};//����������ݳ��ȳ����û���ͻ�ʧ��
		//ʹ��ͬ����ʽ����
		long lDownloadSize=QNV_Remote(QNV_REMOTE_DOWNLOAD_START,0,(char*)(LPCTSTR)m_strdownurl,NULL,szBuf,BUF_SIZE);
		if(lDownloadSize <= 0)
		{
			AfxMessageBox("��������ʧ��");
		}else
		{
			AfxMessageBox(szBuf);
		}
	}else
	{
		m_lDownloadHandle=QNV_Remote(QNV_REMOTE_DOWNLOAD_START,0,(char*)(LPCTSTR)m_strdownurl,(char*)(LPCTSTR)m_strSaveFilePath,NULL,0);
		if(m_lDownloadHandle <= 0)
		{
			AfxMessageBox("��������ʧ��");
		}
	}
}
