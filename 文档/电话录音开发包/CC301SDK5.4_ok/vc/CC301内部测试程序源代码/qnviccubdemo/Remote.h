#if !defined(AFX_REMOTE_H__31CDBF4A_C02F_49FB_BE37_5FAF1BFFB2C9__INCLUDED_)
#define AFX_REMOTE_H__31CDBF4A_C02F_49FB_BE37_5FAF1BFFB2C9__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// Remote.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CRemote dialog

class CRemote : public CDialog
{
// Construction
public:
	CRemote(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CRemote)
	enum { IDD = IDD_REMOTE_DIALOG };
	CEdit	m_cSaveFilePath;
	CString	m_strFilePath;
	CString	m_strURL;
	CString	m_strSaveFilePath;
	CString	m_strdownurl;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CRemote)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CRemote)
	virtual BOOL OnInitDialog();
	afx_msg void OnUpload();
	afx_msg void OnSelect();
	afx_msg void OnDestroy();
	afx_msg void OnUploadlog();
	afx_msg void OnSelectfile();
	afx_msg void OnDownload();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	long	m_lUploadHandle;
	short	m_nChannelID;
	long	m_lDownloadHandle;
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_REMOTE_H__31CDBF4A_C02F_49FB_BE37_5FAF1BFFB2C9__INCLUDED_)
