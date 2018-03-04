#if !defined(AFX_RECVBROAD_H__107F2B81_8260_4A6A_8D76_CF77A7C9AC44__INCLUDED_)
#define AFX_RECVBROAD_H__107F2B81_8260_4A6A_8D76_CF77A7C9AC44__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// RecvBroad.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CRecvBroad dialog

class CRecvBroad : public CDialog
{
// Construction
public:
	CRecvBroad(CWnd* pParent = NULL);   // standard constructor
	void	FreeSource();
// Dialog Data
	//{{AFX_DATA(CRecvBroad)
	enum { IDD = IDD_RECVBROAD_DIALOG };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CRecvBroad)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CRecvBroad)
	virtual BOOL OnInitDialog();
	afx_msg void OnDestroy();
	afx_msg void OnStartrecv();
	afx_msg void OnStoprecv();
	virtual void OnCancel();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_RECVBROAD_H__107F2B81_8260_4A6A_8D76_CF77A7C9AC44__INCLUDED_)
