#if !defined(AFX_INPUTCC_H__171CFA63_6107_4428_919B_DDBDFAE6205C__INCLUDED_)
#define AFX_INPUTCC_H__171CFA63_6107_4428_919B_DDBDFAE6205C__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// InputCC.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CInputCC dialog

class CInputCC : public CDialog
{
// Construction
public:
	CInputCC(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CInputCC)
	enum { IDD = IDD_INPUTCC_DIALOG };
	CString	m_strCC;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CInputCC)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CInputCC)
	virtual void OnOK();
	virtual BOOL OnInitDialog();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_INPUTCC_H__171CFA63_6107_4428_919B_DDBDFAE6205C__INCLUDED_)
