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
	AfxMessageBox("���ǰ��ȷ��û�����Ż���");
	for(BRIINT16 i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{
		long lModule=QNV_DevInfo(i,QNV_DEVINFO_GETMODULE);
		if((lModule&DEVMODULE_CALLID)&&(lModule&DEVMODULE_HOOK))//���������ͨ��,����֧����ժ��
		{
			QNV_SetDevCtrl(i,QNV_CTRL_DOHOOK,1);//��ժ��
		}
	}
	CString strRet,str;
	Sleep(2000);//�ӳٵȺ���·������
	for(i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{
		long lModule=QNV_DevInfo(i,QNV_DEVINFO_GETMODULE);
		if((lModule&DEVMODULE_CALLID)&&(lModule&DEVMODULE_HOOK))//���������ͨ��,����֧����ժ��
		{
			if(QNV_General(i,QNV_GENERAL_CHECKDIALTONE,0,0) > 0)//��⵽�������ͱ�ʾ������������
			{
				str.Format("ͨ��%d��·������(����������)\r\n",i);				
			}else
			{
				str.Format("ͨ��%d��·��������(������������)\r\n",i);
				bWarn=TRUE;
			}
			strRet+=str;
		}
	}
	for(i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{
		long lModule=QNV_DevInfo(i,QNV_DEVINFO_GETMODULE);
		if((lModule&DEVMODULE_CALLID)&&(lModule&DEVMODULE_HOOK))//���������ͨ��,����֧����ժ��
		{
			QNV_SetDevCtrl(i,QNV_CTRL_DOHOOK,0);//��һ�
		}
	}
	if(strRet.IsEmpty()) strRet="�޿�����·";
	if(bWarn)
	{
		MessageBox(strRet,"����",MB_ICONSTOP|MB_OK);	
	}else
	{
		MessageBox(strRet,"���",MB_ICONWARNING|MB_OK);	
	}
}

void CCheckLine::OnStartlineerr() 
{
	BOOL bWarn=FALSE;
	AfxMessageBox("���ǰ��ȷ��û�����Ż���");
	for(BRIINT16 i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{
		long lModule=QNV_DevInfo(i,QNV_DEVINFO_GETMODULE);
		if((lModule&DEVMODULE_CALLID)&&(lModule&DEVMODULE_HOOK))//���������ͨ��,����֧����ժ��
		{
			QNV_SetDevCtrl(i,QNV_CTRL_DOHOOK,1);//��ժ��
		}
	}
	CString strRet,str;
	Sleep(500);//�ӳٵȺ�
	for(i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{
		long lModule=QNV_DevInfo(i,QNV_DEVINFO_GETMODULE);
		if((lModule&DEVMODULE_CALLID)&&(lModule&DEVMODULE_HOOK))//���������ͨ��,����֧����ժ��
		{
			if(QNV_GetDevCtrl(i,QNV_CTRL_PHONE) > 0)//��⵽���ػ���ժ����
			{
				str.Format("ͨ��%d��·��LINE��/PHONE����·�ӷ���\r\n",i);				
				bWarn=TRUE;
			}else
			{
				str.Format("ͨ��%d��·��LINE��/PHONE����·����\r\n",i);
			}
			strRet+=str;
		}
	}
	for(i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{
		long lModule=QNV_DevInfo(i,QNV_DEVINFO_GETMODULE);
		if((lModule&DEVMODULE_CALLID)&&(lModule&DEVMODULE_HOOK))//���������ͨ��,����֧����ժ��
		{
			QNV_SetDevCtrl(i,QNV_CTRL_DOHOOK,0);//��һ�
		}
	}
	if(strRet.IsEmpty()) strRet="�޿�����·";
	if(bWarn)
	{
		MessageBox(strRet,"����",MB_ICONSTOP|MB_OK);	
	}else
	{
		MessageBox(strRet,"���",MB_ICONWARNING|MB_OK);	
	}
}

void CCheckLine::OnAsyncheck() 
{
	for(BRIINT16 i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{
		QNV_General(i,QNV_GENERAL_CHECKLINESTATE,0,0);//�첽�����·״̬,ϵͳ����յ�BriEvent_CheckLine��Ϣ	
	}
}
