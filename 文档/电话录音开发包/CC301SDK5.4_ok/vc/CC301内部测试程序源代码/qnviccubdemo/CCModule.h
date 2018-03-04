#if !defined(AFX_CCMODULE_H__418FCC03_EBDA_4B6D_B1F1_2EA24DA51247__INCLUDED_)
#define AFX_CCMODULE_H__418FCC03_EBDA_4B6D_B1F1_2EA24DA51247__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// CCModule.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CCCModule dialog
#include "FileTransfer.h"

class CCCModule : public CDialog
{
// Construction
public:
	CCCModule(CWnd* pParent = NULL);   // standard constructor
	void	FreeSource();
// Dialog Data
	//{{AFX_DATA(CCCModule)
	enum { IDD = IDD_CCMODULE_DIALOG };
	CEdit	m_cServerAddr;
	CEdit	m_cCCNum;
	CEdit	m_cMsgText;
	CComboBox	m_cChannelID;
	CString	m_strPwd;
	CString	m_strCC;
	CString	m_strCallCC;
	CString	m_strMsgText;
	CString	m_strCCNum;
	CString	m_strRegPwd;
	CString	m_strRegNick;
	CString	m_strServerAddr;
	CString	m_strSvrID;
	CString	m_strOldPwd;
	CString	m_strNewPwd;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CCCModule)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	virtual BOOL OnCommand(WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CCCModule)
	virtual BOOL OnInitDialog();
	afx_msg void OnLogon();
	afx_msg void OnLogout();
	virtual void OnCancel();
	afx_msg void OnStartcall();
	afx_msg void OnStopcall();
	afx_msg void OnAnswer();
	afx_msg void OnRefuse();
	afx_msg void OnSendmsg();
	afx_msg void OnSendcmd();
	afx_msg void OnRegcc();
	afx_msg void OnSetserver();
	afx_msg void OnFindsvr();
	afx_msg void OnModifypwd();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	short	m_nChannelID;
	DWORD	m_dwCallSessID;
private:
	void	AppendStatus(CString strStatus);
	long	GetChannelID();

	BOOL	CreateFileTransfer();
	BOOL	CloseFileTransfer();

	CString GetMsgValue(CString strMsg,CString strKey);
	CFileTransfer	*m_pFileTransfer;

	static BRIINT32	WINAPI CCCModule::ProcEventCallback(BRIINT16 uChannelID,BRIUINT32 dwUserData,BRIINT32 lType,BRIINT32 lHandle,BRIINT32 lResult,BRIINT32 lParam,BRIPCHAR8 pData,BRIPCHAR8 pDataEx);
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CCMODULE_H__418FCC03_EBDA_4B6D_B1F1_2EA24DA51247__INCLUDED_)
