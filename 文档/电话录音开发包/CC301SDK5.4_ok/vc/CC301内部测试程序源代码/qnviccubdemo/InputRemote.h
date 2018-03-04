#if !defined(AFX_INPUTREMOTE_H__ED0A69CD_5E8A_4BB3_8B8E_4235D5AA0EBE__INCLUDED_)
#define AFX_INPUTREMOTE_H__ED0A69CD_5E8A_4BB3_8B8E_4235D5AA0EBE__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// InputRemote.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CInputRemote dialog

class CInputRemote : public CDialog
{
// Construction
public:
	CInputRemote(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CInputRemote)
	enum { IDD = IDD_INPUTREMOTE_DIALOG };
	CEdit	m_cRemoteFile;
	CString	m_strRemoteFile;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CInputRemote)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CInputRemote)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_INPUTREMOTE_H__ED0A69CD_5E8A_4BB3_8B8E_4235D5AA0EBE__INCLUDED_)
