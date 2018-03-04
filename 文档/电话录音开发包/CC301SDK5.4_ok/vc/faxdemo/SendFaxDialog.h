#if !defined(AFX_SENDFAXDIALOG_H__FC611DF8_0175_4A33_9335_79CD2709881C__INCLUDED_)
#define AFX_SENDFAXDIALOG_H__FC611DF8_0175_4A33_9335_79CD2709881C__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// SendFaxDialog.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CSendFaxDialog dialog

class CSendFaxDialog : public CDialog
{
// Construction
public:
	CSendFaxDialog(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CSendFaxDialog)
	enum { IDD = IDD_SENDFAX_DIALOG };
	CEdit	m_cSendPath;
	CStatic	m_cSendState;
	CString	m_strSendPath;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CSendFaxDialog)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CSendFaxDialog)
	afx_msg void OnViewsend();
	virtual BOOL OnInitDialog();
	afx_msg void OnOpendoplay();
	afx_msg void OnBrowser();
	afx_msg void OnStartsend();
	afx_msg void OnStopsend();
	virtual void OnCancel();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	short	m_nChannelID;
	CString GetSelectedFilePath2(CString szFilter,CString szExtName,CString szDefaultPath,CString strDefaultFileName,HWND hOwerWnd,BOOL bType);
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_SENDFAXDIALOG_H__FC611DF8_0175_4A33_9335_79CD2709881C__INCLUDED_)
