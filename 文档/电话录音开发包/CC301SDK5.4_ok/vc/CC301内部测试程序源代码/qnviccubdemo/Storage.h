#if !defined(AFX_STORAGE_H__17104263_9EB1_4C8F_82F7_36D7BC9E45D3__INCLUDED_)
#define AFX_STORAGE_H__17104263_9EB1_4C8F_82F7_36D7BC9E45D3__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// Storage.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CStorage dialog

class CStorage : public CDialog
{
// Construction
public:
	CStorage(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CStorage)
	enum { IDD = IDD_STORAGE_DIALOG };
	CEdit	m_cstoragedataread;
	CEdit	m_cWritePwd;
	CEdit	m_cReadPwd;
	CEdit	m_cstoragedata;
	CString	m_strStoragedata;
	CString	m_strreadpwd;
	CString	m_strwritepwd;
	int		m_nSelDevID;
	CString	m_strReadNew;
	CString	m_strReadSrc;
	CString	m_strWriteNew;
	CString	m_strWriteSrc;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CStorage)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CStorage)
	afx_msg void OnRead();
	afx_msg void OnWrite();
	virtual BOOL OnInitDialog();
	afx_msg void OnSetchannle();
	afx_msg void OnModifyread();
	afx_msg void OnModifywrite();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	short	m_uChannelID;
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_STORAGE_H__17104263_9EB1_4C8F_82F7_36D7BC9E45D3__INCLUDED_)
