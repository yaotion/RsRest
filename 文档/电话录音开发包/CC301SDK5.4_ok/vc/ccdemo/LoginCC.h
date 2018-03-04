#if !defined(AFX_LOGINCC_H__7C25601E_6948_4708_A15B_F0E1E41DD119__INCLUDED_)
#define AFX_LOGINCC_H__7C25601E_6948_4708_A15B_F0E1E41DD119__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// LoginCC.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CLoginCC dialog

class CLoginCC : public CDialog
{
// Construction
public:
	CLoginCC(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CLoginCC)
	enum { IDD = IDD_LOGINCC_DIALOG };
	CString	m_strCCNumber;
	CString	m_strCCPwd;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CLoginCC)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CLoginCC)
	afx_msg void OnLogon();
	virtual BOOL OnInitDialog();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_LOGINCC_H__7C25601E_6948_4708_A15B_F0E1E41DD119__INCLUDED_)
