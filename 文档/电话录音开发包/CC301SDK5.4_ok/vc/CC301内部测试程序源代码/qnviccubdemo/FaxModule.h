#if !defined(AFX_FAXMODULE_H__D0CB979F_855E_4053_A7CC_870331D91844__INCLUDED_)
#define AFX_FAXMODULE_H__D0CB979F_855E_4053_A7CC_870331D91844__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// FaxModule.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CFaxModule dialog

class CFaxModule : public CDialog
{
// Construction
public:
	CFaxModule(CWnd* pParent = NULL);   // standard constructor
	BRIINT16	m_nChannelID;
// Dialog Data
	//{{AFX_DATA(CFaxModule)
	enum { IDD = IDD_FAXMODULE_DIALOG };
	CString	m_strRecvPath;
	CString	m_strSendPath;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CFaxModule)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CFaxModule)
	virtual void OnCancel();
	virtual BOOL OnInitDialog();
	afx_msg void OnStartsend();
	afx_msg void OnStopsend();
	afx_msg void OnViewsend();
	afx_msg void OnStartrecv();
	afx_msg void OnStoprecv();
	afx_msg void OnViewrecv();
	afx_msg void OnSelectsend();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_FAXMODULE_H__D0CB979F_855E_4053_A7CC_870331D91844__INCLUDED_)
