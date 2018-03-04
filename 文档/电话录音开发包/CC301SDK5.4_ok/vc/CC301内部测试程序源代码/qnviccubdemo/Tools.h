#if !defined(AFX_TOOLS_H__D29939E6_E58C_44A9_B7C6_239D103A7310__INCLUDED_)
#define AFX_TOOLS_H__D29939E6_E58C_44A9_B7C6_239D103A7310__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// Tools.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CTools dialog

class CTools : public CDialog
{
// Construction
public:
	CTools(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CTools)
	enum { IDD = IDD_TOOLS_DIALOG };
	CEdit	m_cFilePath;
	CEdit	m_cSelectDir;
	CString	m_strPSTN;
	CString	m_strFilePath;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CTools)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CTools)
	afx_msg void OnPSTNEnd();
	virtual BOOL OnInitDialog();
	afx_msg void OnLocation();
	afx_msg void OnCheckcodetype();
	afx_msg void OnBrower();
	afx_msg void OnBrowerfile();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_TOOLS_H__D29939E6_E58C_44A9_B7C6_239D103A7310__INCLUDED_)
