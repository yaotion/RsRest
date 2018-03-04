#if !defined(AFX_SELECTMULTIFILE_H__465C10E9_3228_401D_BE8A_B584C1C901C6__INCLUDED_)
#define AFX_SELECTMULTIFILE_H__465C10E9_3228_401D_BE8A_B584C1C901C6__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// SelectMultiFile.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CSelectMultiFile dialog

class CSelectMultiFile : public CDialog
{
// Construction
public:
	CSelectMultiFile(CWnd* pParent = NULL);   // standard constructor
	CString	m_strFileList;
// Dialog Data
	//{{AFX_DATA(CSelectMultiFile)
	enum { IDD = IDD_SELECTMULTIFILE_DIALOG };
	CListBox	m_cFileList;	
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CSelectMultiFile)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CSelectMultiFile)
	virtual void OnOK();
	virtual BOOL OnInitDialog();
	afx_msg void OnAdd();
	afx_msg void OnDel();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_SELECTMULTIFILE_H__465C10E9_3228_401D_BE8A_B584C1C901C6__INCLUDED_)
