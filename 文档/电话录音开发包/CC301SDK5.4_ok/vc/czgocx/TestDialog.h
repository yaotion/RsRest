#if !defined(AFX_TESTDIALOG_H__18CA8DDD_09D9_4932_B1D3_CE3426C18184__INCLUDED_)
#define AFX_TESTDIALOG_H__18CA8DDD_09D9_4932_B1D3_CE3426C18184__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// TestDialog.h : header file
//
#include "MsgParse.h"
/////////////////////////////////////////////////////////////////////////////
// CTestDialog dialog

class CTestDialog : public CDialog
{
// Construction
public:
	CTestDialog(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CTestDialog)
	enum { IDD = IDD_TEST_DIALOG };
	CComboBox	m_cSelectLine;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CTestDialog)
	public:
	virtual BOOL PreTranslateMessage(MSG* pMsg);
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
//protected:
	public:
		int m_nChannelID;
		long AppendCallIn(DWORD dwHandle,CString  strData);
		CString m_strCallInCC ;//CCºÅÂë
		CString m_strNick ;//êÇ³Æ
		DWORD m_dwHandle;//ºô½Ð±êÊ¶
		CString m_strPwd;//CCÃÜÂë
		CString m_strCC;//CCºÅÂë
		CString m_strServer;//CC·þÎñÆ÷IP

	// Generated message map functions
	//{{AFX_MSG(CTestDialog)
	afx_msg void OnOpendev();
	afx_msg void OnClosedev();
	afx_msg void OnSetccserver();
	afx_msg void OnLogon();
	afx_msg void OnLogoff();
	afx_msg void OnAnswercall();
	afx_msg void OnRejectcall();
	afx_msg void OnDisablering();
	afx_msg void OnStartring();
	afx_msg void OnStop();
	afx_msg void OnSelchangeSelectline();
	afx_msg void OnDestroy();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	void	AppendStatus(CString strStatus);
	long	ShowEvent(PBRI_EVENT pEvent);
	static BRIINT32 WINAPI CallbackEvent(BRIINT16 uChannelID,BRIUINT32 dwUserData,BRIINT32 lType,BRIINT32 lHandle,BRIINT32 lResult,BRIINT32 lParam,BRIPCHAR8 pData,BRIPCHAR8 pDataEx);

};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_TESTDIALOG_H__18CA8DDD_09D9_4932_B1D3_CE3426C18184__INCLUDED_)
