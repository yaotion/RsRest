#if !defined(AFX_INPUTIP_H__068C9626_7821_4F2F_B9FC_B194BFEC5CB5__INCLUDED_)
#define AFX_INPUTIP_H__068C9626_7821_4F2F_B9FC_B194BFEC5CB5__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// InputIP.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CInputIP dialog

class CInputIP : public CDialog
{
// Construction
public:
	CInputIP(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CInputIP)
	enum { IDD = IDD_INPUTIP_DIALOG };
	CString	m_strIPAddr;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CInputIP)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CInputIP)
	virtual void OnOK();
	virtual BOOL OnInitDialog();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_INPUTIP_H__068C9626_7821_4F2F_B9FC_B194BFEC5CB5__INCLUDED_)
