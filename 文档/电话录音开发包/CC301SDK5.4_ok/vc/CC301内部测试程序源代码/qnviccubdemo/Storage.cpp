// Storage.cpp : implementation file
//

#include "stdafx.h"
#include "qnviccubdemo.h"
#include "Storage.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CStorage dialog


CStorage::CStorage(CWnd* pParent /*=NULL*/)
	: CDialog(CStorage::IDD, pParent)
{
	//{{AFX_DATA_INIT(CStorage)
	m_strStoragedata = _T("");
	m_strreadpwd = _T("");
	m_strwritepwd = _T("");
	m_nSelDevID = 0;
	m_strReadNew = _T("");
	m_strReadSrc = _T("");
	m_strWriteNew = _T("");
	m_strWriteSrc = _T("");
	//}}AFX_DATA_INIT
	m_uChannelID = 0;
}


void CStorage::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CStorage)
	DDX_Control(pDX, IDC_STOREAGEDATAREAD, m_cstoragedataread);
	DDX_Control(pDX, IDC_WRITEPWD, m_cWritePwd);
	DDX_Control(pDX, IDC_READPWD, m_cReadPwd);
	DDX_Control(pDX, IDC_STOREAGEDATA, m_cstoragedata);
	DDX_Text(pDX, IDC_STOREAGEDATA, m_strStoragedata);
	DDX_Text(pDX, IDC_READPWD, m_strreadpwd);
	DDX_Text(pDX, IDC_WRITEPWD, m_strwritepwd);
	DDX_Text(pDX, IDC_CHANNELID, m_nSelDevID);
	DDX_Text(pDX, IDC_READNEW, m_strReadNew);
	DDX_Text(pDX, IDC_READSRC, m_strReadSrc);
	DDX_Text(pDX, IDC_WRITENEW, m_strWriteNew);
	DDX_Text(pDX, IDC_WRITESRC, m_strWriteSrc);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CStorage, CDialog)
	//{{AFX_MSG_MAP(CStorage)
	ON_BN_CLICKED(IDC_READ, OnRead)
	ON_BN_CLICKED(IDC_WRITE, OnWrite)
	ON_BN_CLICKED(IDC_SETCHANNLE, OnSetchannle)
	ON_BN_CLICKED(IDC_MODIFYREAD, OnModifyread)
	ON_BN_CLICKED(IDC_MODIFYWRITE, OnModifywrite)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CStorage message handlers


BOOL CStorage::OnInitDialog() 
{
	CDialog::OnInitDialog();
		
	m_nSelDevID = m_uChannelID = 0;
	if(!(QNV_DevInfo(m_uChannelID,QNV_DEVINFO_GETMODULE)&DEVMODULE_STORAGE))
		AfxMessageBox("通道0没有FLASH存储功能");
	UpdateData(FALSE);
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CStorage::OnRead() 
{
	UpdateData(TRUE);	
	char szBuf[257]={0};
	//设置USBID,不是通道ID
	long lReadLen=QNV_Storage((short)QNV_DevInfo(m_uChannelID,QNV_DEVINFO_GETDEVID),QNV_STORAGE_PUBLIC_READSTR,0,(char*)(LPCTSTR)m_strreadpwd,szBuf,256);	
	CString str;
	if(lReadLen >= 0)
	{
		m_cstoragedataread.SetWindowText(szBuf);
		str.Format("读取到 %d 个数据",lReadLen);
	}else
	{
		str.Format("读取错误 %d",lReadLen);
	}
	AfxMessageBox(str);
}

void CStorage::OnWrite() 
{
	UpdateData(TRUE);	
	//设置USBID,不是通道ID
	//多写个字符串结束符号
	long lWriteLen=QNV_Storage((short)QNV_DevInfo(m_uChannelID,QNV_DEVINFO_GETDEVID),QNV_STORAGE_PUBLIC_WRITE,0,(char*)(LPCTSTR)m_strwritepwd,(char*)(LPCTSTR)m_strStoragedata,m_strStoragedata.GetLength()+1);
	CString str;
	if(lWriteLen  > 0)
	{
		str.Format("写入 %d 个数据",lWriteLen - 1);
	}else
	{
		str.Format("写入错误 %d",lWriteLen);
	}
	AfxMessageBox(str);
}

void CStorage::OnSetchannle() 
{
	UpdateData(TRUE);
	//获得该USB芯片ID所在的通道ID
	//某些设备的一个USB芯片具有2个通道,当一个USB芯片只有一个通道时，设备ID就是通道ID
	m_uChannelID = (short)QNV_DevInfo((short)m_nSelDevID,QNV_DEVINFO_GETCHIPCHANNEL);
	if(m_uChannelID < 0 )
	{
		AfxMessageBox("选择的芯片ID不对");
	}else
	{
		if(!(QNV_DevInfo(m_uChannelID,QNV_DEVINFO_GETMODULE)&DEVMODULE_STORAGE))
			AfxMessageBox("该通道没有FLASH存储功能");
	}
}

void CStorage::OnModifyread() 
{
	UpdateData(TRUE);
	CString str;
	long lRet=QNV_Storage((short)QNV_DevInfo(m_uChannelID,QNV_DEVINFO_GETDEVID),QNV_STORAGE_PUBLIC_SETREADPWD,0,(char*)(LPCTSTR)m_strReadSrc,(char*)(LPCTSTR)m_strReadNew,0);
	if(lRet > 0)
	{
		m_cReadPwd.SetWindowText(m_strReadNew);
		AfxMessageBox("修改读取密码成功,请牢记密码");
	}else
	{
		str.Format("修改读取密码失败 id=%d",lRet);
		AfxMessageBox(str);
	}
}

void CStorage::OnModifywrite() 
{
	UpdateData(TRUE);
	CString str;
	long lRet=QNV_Storage((short)QNV_DevInfo(m_uChannelID,QNV_DEVINFO_GETDEVID),QNV_STORAGE_PUBLIC_SETWRITEPWD,0,(char*)(LPCTSTR)m_strWriteSrc,(char*)(LPCTSTR)m_strWriteNew,0);
	if(lRet > 0)
	{
		m_cWritePwd.SetWindowText(m_strWriteNew);
		AfxMessageBox("修改写入密码成功,请牢记密码");
	}else
	{
		str.Format("修改写入密码失败 id=%d",lRet);
		AfxMessageBox(str);
	}	
}
