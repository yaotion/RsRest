// CheckLine.cpp : implementation file
//

#include "stdafx.h"
#include "qnviccubdemo.h"
#include "CheckLine.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CCheckLine dialog


CCheckLine::CCheckLine(CWnd* pParent /*=NULL*/)
	: CDialog(CCheckLine::IDD, pParent)
{
	//{{AFX_DATA_INIT(CCheckLine)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}


void CCheckLine::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CCheckLine)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CCheckLine, CDialog)
	//{{AFX_MSG_MAP(CCheckLine)
	ON_BN_CLICKED(IDC_STARTCHECKLINE, OnStartcheckline)
	ON_BN_CLICKED(IDC_STARTLINEERR, OnStartlineerr)
	ON_BN_CLICKED(IDC_ASYNCHECK, OnAsyncheck)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CCheckLine message handlers

BOOL CCheckLine::OnInitDialog() 
{
	CDialog::OnInitDialog();		
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CCheckLine::OnStartcheckline() 
{
	BOOL bWarn=FALSE;
	AfxMessageBox("检测前请确认没有拿着话机");
	for(BRIINT16 i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{
		long lModule=QNV_DevInfo(i,QNV_DEVINFO_GETMODULE);
		if((lModule&DEVMODULE_CALLID)&&(lModule&DEVMODULE_HOOK))//如果是外线通道,并且支持软摘机
		{
			QNV_SetDevCtrl(i,QNV_CTRL_DOHOOK,1);//软摘机
		}
	}
	CString strRet,str;
	Sleep(2000);//延迟等候线路拨号音
	for(i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{
		long lModule=QNV_DevInfo(i,QNV_DEVINFO_GETMODULE);
		if((lModule&DEVMODULE_CALLID)&&(lModule&DEVMODULE_HOOK))//如果是外线通道,并且支持软摘机
		{
			if(QNV_General(i,QNV_GENERAL_CHECKDIALTONE,0,0) > 0)//检测到拨号音就表示可以正常拨号
			{
				str.Format("通道%d线路：可用(可正常软拨号)\r\n",i);				
			}else
			{
				str.Format("通道%d线路：不可用(不能正常软拨号)\r\n",i);
				bWarn=TRUE;
			}
			strRet+=str;
		}
	}
	for(i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{
		long lModule=QNV_DevInfo(i,QNV_DEVINFO_GETMODULE);
		if((lModule&DEVMODULE_CALLID)&&(lModule&DEVMODULE_HOOK))//如果是外线通道,并且支持软摘机
		{
			QNV_SetDevCtrl(i,QNV_CTRL_DOHOOK,0);//软挂机
		}
	}
	if(strRet.IsEmpty()) strRet="无可用线路";
	if(bWarn)
	{
		MessageBox(strRet,"错误",MB_ICONSTOP|MB_OK);	
	}else
	{
		MessageBox(strRet,"完成",MB_ICONWARNING|MB_OK);	
	}
}

void CCheckLine::OnStartlineerr() 
{
	BOOL bWarn=FALSE;
	AfxMessageBox("检测前请确认没有拿着话机");
	for(BRIINT16 i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{
		long lModule=QNV_DevInfo(i,QNV_DEVINFO_GETMODULE);
		if((lModule&DEVMODULE_CALLID)&&(lModule&DEVMODULE_HOOK))//如果是外线通道,并且支持软摘机
		{
			QNV_SetDevCtrl(i,QNV_CTRL_DOHOOK,1);//软摘机
		}
	}
	CString strRet,str;
	Sleep(500);//延迟等候
	for(i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{
		long lModule=QNV_DevInfo(i,QNV_DEVINFO_GETMODULE);
		if((lModule&DEVMODULE_CALLID)&&(lModule&DEVMODULE_HOOK))//如果是外线通道,并且支持软摘机
		{
			if(QNV_GetDevCtrl(i,QNV_CTRL_PHONE) > 0)//检测到本地话机摘机了
			{
				str.Format("通道%d线路：LINE口/PHONE口线路接反了\r\n",i);				
				bWarn=TRUE;
			}else
			{
				str.Format("通道%d线路：LINE口/PHONE口线路正常\r\n",i);
			}
			strRet+=str;
		}
	}
	for(i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{
		long lModule=QNV_DevInfo(i,QNV_DEVINFO_GETMODULE);
		if((lModule&DEVMODULE_CALLID)&&(lModule&DEVMODULE_HOOK))//如果是外线通道,并且支持软摘机
		{
			QNV_SetDevCtrl(i,QNV_CTRL_DOHOOK,0);//软挂机
		}
	}
	if(strRet.IsEmpty()) strRet="无可用线路";
	if(bWarn)
	{
		MessageBox(strRet,"错误",MB_ICONSTOP|MB_OK);	
	}else
	{
		MessageBox(strRet,"完成",MB_ICONWARNING|MB_OK);	
	}
}

void CCheckLine::OnAsyncheck() 
{
	for(BRIINT16 i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{
		QNV_General(i,QNV_GENERAL_CHECKLINESTATE,0,0);//异步检测线路状态,系统会接收到BriEvent_CheckLine消息	
	}
}
