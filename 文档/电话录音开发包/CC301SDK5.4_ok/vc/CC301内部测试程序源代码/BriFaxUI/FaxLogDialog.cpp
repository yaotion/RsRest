// FaxLogDialog.cpp : implementation file
//

#include "stdafx.h"
#include "FaxLogDialog.h"
#include <fstream.h>
#include "BriStringLib.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CFaxLogDialog dialog


CFaxLogDialog::CFaxLogDialog(CWnd* pParent /*=NULL*/)
	: CDialog(CFaxLogDialog::IDD, pParent)
{
	//{{AFX_DATA_INIT(CFaxLogDialog)
	m_cBeginDate = 0;
	m_cEndDate = 0;
	//}}AFX_DATA_INIT
	m_lCoumnCount= 0;
	m_lCurPage=-1;
	m_lTotalPage= 0;
}

void CFaxLogDialog::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CFaxLogDialog)
	DDX_Control(pDX, IDC_STPAGE, m_cStPage);
	DDX_Control(pDX, IDC_PREV, m_cPrev);
	DDX_Control(pDX, IDC_NEXT, m_cNext);
	DDX_Control(pDX, IDC_LAST, m_cLast);
	DDX_Control(pDX, IDC_FIRST, m_cFirst);
	DDX_Control(pDX, IDC_FAXLOGLIST, m_cFaxLogList);
	DDX_DateTimeCtrl(pDX, IDC_BEGINDATE, m_cBeginDate);
	DDX_DateTimeCtrl(pDX, IDC_ENDDATE, m_cEndDate);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CFaxLogDialog, CDialog)
	//{{AFX_MSG_MAP(CFaxLogDialog)
	ON_BN_CLICKED(IDC_SEARCH, OnSearch)
	ON_WM_SIZE()
	ON_NOTIFY(NM_DBLCLK, IDC_FAXLOGLIST, OnDblclkFaxloglist)
	ON_BN_CLICKED(IDC_FIRST, OnFirst)
	ON_BN_CLICKED(IDC_PREV, OnPrev)
	ON_BN_CLICKED(IDC_NEXT, OnNext)
	ON_BN_CLICKED(IDC_LAST, OnLast)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CFaxLogDialog message handlers


BOOL CFaxLogDialog::OnInitDialog() 
{
	CDialog::OnInitDialog();
	InitList();
	ResizeWindow();
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CFaxLogDialog::FreeSource()
{
	m_strLogArray.FreeExtra();
	m_cFaxLogList.DeleteAllItems();
}

CString	CFaxLogDialog::GetLogFile()
{
	char szLogFile[_MAX_PATH]={0};
	BS_GetModuleFilePath(FAX_LOG_FILE,szLogFile,_MAX_PATH);	
	BS_MakeSureDirectoryExists(szLogFile);
	CString str=szLogFile;
	return str;
}

//overloaded from original getline to take CString
istream & CFaxLogDialog:: getline(istream & is, CString & str)
{
    char buf[512];
    is.getline(buf,512);
    str = buf;
    return is;
}

void CFaxLogDialog::OnSearch() 
{
	UpdateData(TRUE);
	CTime bt(m_cBeginDate.GetYear(),m_cBeginDate.GetMonth(),m_cBeginDate.GetDay(),0,0,1);
	CTime et(m_cEndDate.GetYear(),m_cEndDate.GetMonth(),m_cEndDate.GetDay(),23,59,59);
	ListLog(bt.GetTime(),et.GetTime());
}

BOOL CFaxLogDialog::ListLog(long lBeginTime,long lEndTime)
{
	m_lCurPage=-1;
	m_lTotalPage= 0;
	m_strLogArray.FreeExtra();
	m_cFaxLogList.DeleteAllItems();
	m_cStPage.SetWindowText("0/0");
	CString path=GetLogFile();
	CFile file;
	CFileStatus status;
	if (!file.GetStatus(path,status)) return FALSE;
	ifstream logfile;
	logfile.open(path);	
	if (logfile.fail())	return FALSE;
	logfile.seekg(0,ios::end);
	streampos here = logfile.tellg();
	logfile.seekg(0,ios::beg);	
	CString strHeader,readinfo;
	char *szagv[17]={0};
	long lSize=here/50>0?here/50:1;
	m_strLogArray.SetSize(lSize);//假设每个记录50字节
	long lCount=0;
	while (getline(logfile,readinfo))
	{
		if(strHeader.IsEmpty())
		{
			strHeader = readinfo;
		}else
		{
			int agc=BS_SplitMsgEx(szagv,16,(char*)(LPCTSTR)readinfo,readinfo.GetLength(),',',FALSE);
			if(agc >= 8)
			{
				CTime bt(atol(szagv[0]));
				CTime et(atol(szagv[1]));
				if(bt.GetTime() >= lBeginTime && bt.GetTime() <= lEndTime)//如果确保记录是按时间排序的话,结束时间小于记录的开始时间后就可以停止了lEndTime < bt.GetTime()
				{
					m_strLogArray.SetAt(lCount++,readinfo);					
					if(m_strLogArray.GetSize() <= lCount)
					{
						m_strLogArray.SetSize(m_strLogArray.GetSize()*2);
					}
				}
			}
		}
	}
	logfile.close();
	m_strLogArray.SetSize(lCount);
	m_lTotalPage = (lCount+COUNT_PER_PAGE-1)/COUNT_PER_PAGE;
	ShowLog(0);
	return TRUE;
}

long	CFaxLogDialog::AppendLog(int iSeek,CString strLog)
{
	char *szagv[17]={0};
	int agc=BS_SplitMsgEx(szagv,16,(char*)(LPCTSTR)strLog,strLog.GetLength(),',',FALSE);
	if(agc < 8) return 0;
	CTime bt(atol(szagv[0]));
	CTime et(atol(szagv[1]));		
	int L=m_cFaxLogList.GetItemCount();
	int iSubItem=0;
	CString str,strID;
	strID.Format("%d",iSeek+L+1);
	str.Format("%04d-%02d-%02d %02d:%02d:%02d",bt.GetYear(),bt.GetMonth(),bt.GetDay(),bt.GetHour(),bt.GetMinute(),bt.GetSecond());
	m_cFaxLogList.InsertItem(L,strID);
	m_cFaxLogList.SetItemText(L,++iSubItem,str);
	str.Format("%04d-%02d-%02d %02d:%02d:%02d",et.GetYear(),et.GetMonth(),et.GetDay(),et.GetHour(),et.GetMinute(),et.GetSecond());
	m_cFaxLogList.SetItemText(L,++iSubItem,str);
	long lTimeLen=et.GetTime()-bt.GetTime();
	str.Format("%02d:%02d:%02d",lTimeLen/3600,lTimeLen%3600/60,lTimeLen%60);
	m_cFaxLogList.SetItemText(L,++iSubItem,str);
	m_cFaxLogList.SetItemText(L,++iSubItem,szagv[3]);
	if(atol(szagv[4]) == 0)
		m_cFaxLogList.SetItemText(L,++iSubItem,"接收");
	else
		m_cFaxLogList.SetItemText(L,++iSubItem,"发送");
	if(atol(szagv[5]) == 0)
	{
		m_cFaxLogList.SetItemText(L,++iSubItem,"失败");		
	}
	else if(atol(szagv[5]) == 1)
	{
		m_cFaxLogList.SetItemText(L,++iSubItem,"成功");		
	}
	else
	{
		m_cFaxLogList.SetItemText(L,++iSubItem,"取消");		
	}	
	m_cFaxLogList.SetItemText(L,++iSubItem,szagv[6]);
	m_cFaxLogList.SetItemText(L,++iSubItem,szagv[7]);
	return L+1;
}

long	CFaxLogDialog::ShowLog(int iPage)
{
	m_cFaxLogList.DeleteAllItems();	
	if(iPage < 0 || iPage >= m_lTotalPage) return -1;
	m_lCurPage = iPage;
	int iSeek=iPage*COUNT_PER_PAGE;
	for(int i=iSeek;i<(iPage+1)*COUNT_PER_PAGE&&i < m_strLogArray.GetSize();i++)
	{
		AppendLog(iSeek,m_strLogArray.GetAt(i));
	}
	m_cFirst.EnableWindow(m_lCurPage>0);
	m_cLast.EnableWindow(m_lCurPage<(m_lTotalPage-1));
	m_cNext.EnableWindow(m_lCurPage<(m_lTotalPage-1));
	m_cPrev.EnableWindow(m_lCurPage>0);
	CString strPage;
	strPage.Format("%d/%d",m_lCurPage+1,m_lTotalPage);
	m_cStPage.SetWindowText(strPage);
	return 1;
}

void CFaxLogDialog::InitList()
{
	m_cBeginDate = CTime::GetCurrentTime();
	m_cEndDate = CTime::GetCurrentTime();
	UpdateData(FALSE);

	m_cFaxLogList.InsertColumn(m_lCoumnCount++,"ID",LVCFMT_LEFT,32);
	m_cFaxLogList.InsertColumn(m_lCoumnCount++,"开始时间",LVCFMT_LEFT,150);
	m_cFaxLogList.InsertColumn(m_lCoumnCount++,"结束时间",LVCFMT_LEFT,150);
	m_cFaxLogList.InsertColumn(m_lCoumnCount++,"时长",LVCFMT_LEFT,64);
	m_cFaxLogList.InsertColumn(m_lCoumnCount++,"号码",LVCFMT_LEFT,100);
	m_cFaxLogList.InsertColumn(m_lCoumnCount++,"收发",LVCFMT_LEFT,40);
	m_cFaxLogList.InsertColumn(m_lCoumnCount++,"结果",LVCFMT_LEFT,40);
	m_cFaxLogList.InsertColumn(m_lCoumnCount++,"路径",LVCFMT_LEFT,100);
	m_cFaxLogList.InsertColumn(m_lCoumnCount++,"序列号",LVCFMT_LEFT,50);
	
	m_cFaxLogList.SetExtendedStyle(m_cFaxLogList.GetExtendedStyle()|(LVS_EX_FULLROWSELECT | LVS_EX_SUBITEMIMAGES|LVS_EX_GRIDLINES));
}

void CFaxLogDialog::OnCancel() 
{	
	::PostMessage(m_hCBWnd,m_dwMsgID,0,(LPARAM)this);
	//CDialog::OnCancel();
}

void CFaxLogDialog::ResizeWindow()
{
	CRect rc;
	GetClientRect(&rc);
	m_cFaxLogList.SetWindowPos(NULL,2,30,rc.right-2,rc.bottom-32-25,NULL);
	int iLeft=2,iWidth=70;
	m_cFirst.SetWindowPos(NULL,iLeft,rc.bottom-23,iWidth,21,NULL);
	iLeft+=iWidth+2;
	m_cNext.SetWindowPos(NULL,iLeft,rc.bottom-23,iWidth,21,NULL);
	iLeft+=iWidth+2;
	m_cPrev.SetWindowPos(NULL,iLeft,rc.bottom-23,iWidth,21,NULL);
	iLeft+=iWidth+2;
	m_cLast.SetWindowPos(NULL,iLeft,rc.bottom-23,iWidth,21,NULL);
	m_cStPage.SetWindowPos(NULL,rc.right-60,rc.bottom-23,58,21,NULL);
}

void CFaxLogDialog::OnSize(UINT nType, int cx, int cy) 
{
	CDialog::OnSize(nType, cx, cy);	
	if(::IsWindow(m_cFaxLogList.m_hWnd))
	{
		ResizeWindow();
	}
}

long	CFaxLogDialog::GetFileType(char *pFilePath)
{
	if(!pFilePath || strlen(pFilePath) < 5) return FT_NULL;
	else
	{
		char *pDot=strrchr(pFilePath,'.');
		if(!pDot) return FFT_UNKNOW;
		else
		{
			if(_tcsicmp(pDot,".doc") == 0 || _tcsicmp(pDot,".dot") == 0 ) return FFT_DOC;
			else if(_tcsicmp(pDot,".htm") == 0 || _tcsicmp(pDot,".mht") == 0 ||_tcsicmp(pDot,".html") == 0 ) return FFT_WEB;
			else
				return FFT_PIC;
		}
	}
}

void CFaxLogDialog::OnDblclkFaxloglist(NMHDR* pNMHDR, LRESULT* pResult) 
{
	POSITION pos=m_cFaxLogList.GetFirstSelectedItemPosition();
	if(pos)
	{
		int iItem=m_cFaxLogList.GetNextSelectedItem(pos);
		CString strItem=m_cFaxLogList.GetItemText(iItem,7);
		if(!strItem.IsEmpty())
		{
			if(GetFileType((char*)(LPCTSTR)strItem) != FFT_PIC)
			{
				::ShellExecute(NULL,"open",strItem,"",NULL,SW_SHOWNORMAL);	
			}else
			{
				::ShellExecute(NULL,"open","rundll32.exe","shimgvw.dll,ImageView_Fullscreen "+strItem,NULL,SW_SHOWNORMAL); 
			}
			//::ShellExecute(NULL,"open",strItem,"",NULL,SW_SHOWNORMAL);
			//::ShellExecute(NULL,"open","rundll32.exe","shimgvw.dll,ImageView_Fullscreen "+strItem,NULL,SW_SHOWNORMAL); 
		}
	}
	*pResult = 0;
}

void CFaxLogDialog::OnFirst() 
{
	ShowLog(0);
}

void CFaxLogDialog::OnPrev() 
{
	ShowLog(m_lCurPage-1);	
}

void CFaxLogDialog::OnNext() 
{
	ShowLog(m_lCurPage+1);
}

void CFaxLogDialog::OnLast() 
{
	ShowLog(m_lTotalPage-1);
}
