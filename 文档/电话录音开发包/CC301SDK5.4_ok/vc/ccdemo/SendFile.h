#if !defined(AFX_SENDFILE_H__308A6A9C_922B_4CFE_A1A2_C59CC3FAD2FA__INCLUDED_)
#define AFX_SENDFILE_H__308A6A9C_922B_4CFE_A1A2_C59CC3FAD2FA__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// SendFile.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CSendFile dialog

class CSendFile : public CDialog
{
// Construction
public:
	CSendFile(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CSendFile)
	enum { IDD = IDD_SENDFILE_DIALOG };
	CEdit	m_cFilePath;
	CString	m_strDestCC;
	CString	m_strFilePath;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CSendFile)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CSendFile)
	afx_msg void OnSelectfile();
	virtual BOOL OnInitDialog();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	CString SelectFilePath();
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_SENDFILE_H__308A6A9C_922B_4CFE_A1A2_C59CC3FAD2FA__INCLUDED_)
