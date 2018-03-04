#if !defined(AFX_REGCC_H__E0A9576A_2921_4E19_9316_FF5B2B6191FC__INCLUDED_)
#define AFX_REGCC_H__E0A9576A_2921_4E19_9316_FF5B2B6191FC__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// RegCC.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CRegCC dialog

class CRegCC : public CDialog
{
// Construction
public:
	CRegCC(CWnd* pParent = NULL);   // standard constructor
	
// Dialog Data
	//{{AFX_DATA(CRegCC)
	enum { IDD = IDD_REGCC_DIALOG };
	CString	m_strRegCC;
	CString	m_strRegNick;
	CString	m_strRegPwd;
	CString	m_strSvrID;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CRegCC)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CRegCC)
	virtual BOOL OnInitDialog();
	virtual void OnCancel();
	afx_msg void OnReg();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_REGCC_H__E0A9576A_2921_4E19_9316_FF5B2B6191FC__INCLUDED_)
