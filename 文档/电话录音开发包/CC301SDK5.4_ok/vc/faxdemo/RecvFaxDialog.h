#if !defined(AFX_RECVFAXDIALOG_H__F6E7FAA5_B073_4F24_BF4A_2833C96B921F__INCLUDED_)
#define AFX_RECVFAXDIALOG_H__F6E7FAA5_B073_4F24_BF4A_2833C96B921F__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// RecvFaxDialog.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CRecvFaxDialog dialog

class CRecvFaxDialog : public CDialog
{
// Construction
public:
	CRecvFaxDialog(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CRecvFaxDialog)
	enum { IDD = IDD_RECVFAX_DIALOG };
	CStatic	m_cState;
	CString	m_strRecvPath;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CRecvFaxDialog)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CRecvFaxDialog)
	virtual BOOL OnInitDialog();
	virtual void OnCancel();
	afx_msg void OnView();
	afx_msg void OnStartrecv();
	afx_msg void OnStoprecv();
	afx_msg void OnOpendoplay();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	short	m_nChannelID;
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_RECVFAXDIALOG_H__F6E7FAA5_B073_4F24_BF4A_2833C96B921F__INCLUDED_)
