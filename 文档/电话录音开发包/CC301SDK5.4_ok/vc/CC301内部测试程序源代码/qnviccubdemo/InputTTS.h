#if !defined(AFX_INPUTTTS_H__DB4F614A_13AA_4D57_B9F9_100757A5D3AD__INCLUDED_)
#define AFX_INPUTTTS_H__DB4F614A_13AA_4D57_B9F9_100757A5D3AD__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// InputTTS.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CInputTTS dialog

class CInputTTS : public CDialog
{
// Construction
public:
	CInputTTS(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CInputTTS)
	enum { IDD = IDD_INPUTTTS_DIALOG };
	CString	m_strTTS;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CInputTTS)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CInputTTS)
	virtual void OnOK();
	virtual BOOL OnInitDialog();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_INPUTTTS_H__DB4F614A_13AA_4D57_B9F9_100757A5D3AD__INCLUDED_)
