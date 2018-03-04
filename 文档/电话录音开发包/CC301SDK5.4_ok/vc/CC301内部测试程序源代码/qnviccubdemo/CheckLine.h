#if !defined(AFX_CHECKLINE_H__AACFB8BD_C088_4F54_8DD2_9C93E7139916__INCLUDED_)
#define AFX_CHECKLINE_H__AACFB8BD_C088_4F54_8DD2_9C93E7139916__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// CheckLine.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CCheckLine dialog

class CCheckLine : public CDialog
{
// Construction
public:
	CCheckLine(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CCheckLine)
	enum { IDD = IDD_CHECKLINE_DIALOG };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CCheckLine)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CCheckLine)
	virtual BOOL OnInitDialog();
	afx_msg void OnStartcheckline();
	afx_msg void OnStartlineerr();
	afx_msg void OnAsyncheck();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CHECKLINE_H__AACFB8BD_C088_4F54_8DD2_9C93E7139916__INCLUDED_)
