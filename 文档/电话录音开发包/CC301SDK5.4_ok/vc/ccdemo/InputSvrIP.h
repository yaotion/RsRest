#if !defined(AFX_INPUTSVRIP_H__F7B178E9_EE77_4CC0_9C21_15B76A32D5CA__INCLUDED_)
#define AFX_INPUTSVRIP_H__F7B178E9_EE77_4CC0_9C21_15B76A32D5CA__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// InputSvrIP.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CInputSvrIP dialog

class CInputSvrIP : public CDialog
{
// Construction
public:
	CInputSvrIP(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CInputSvrIP)
	enum { IDD = IDD_INPUTSVRIP_DIALOG };
	CString	m_strSvrIP;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CInputSvrIP)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CInputSvrIP)
	virtual BOOL OnInitDialog();
	virtual void OnCancel();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_INPUTSVRIP_H__F7B178E9_EE77_4CC0_9C21_15B76A32D5CA__INCLUDED_)
