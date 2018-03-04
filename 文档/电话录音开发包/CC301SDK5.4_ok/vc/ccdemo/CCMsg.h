#if !defined(AFX_CCMSG_H__6407FDCF_884A_46A1_A387_6D3E17915B64__INCLUDED_)
#define AFX_CCMSG_H__6407FDCF_884A_46A1_A387_6D3E17915B64__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// CCMsg.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CCCMsg dialog

class CCCMsg : public CDialog
{
// Construction
public:
	CCCMsg(CWnd* pParent = NULL);   // standard constructor
	void	FreeSource();
	long	AppendRecvMsg(CString strMsg);
// Dialog Data
	//{{AFX_DATA(CCCMsg)
	enum { IDD = IDD_CCMSG_DIALOG };
	CEdit	m_cSendView;
	CEdit	m_cDestCC;
	CString	m_strDestCC;
	CString	m_strSendView;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CCCMsg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CCCMsg)
	virtual BOOL OnInitDialog();
	virtual void OnCancel();
	afx_msg void OnSendmsg();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	long	AppendRecvView(LPCTSTR lpVID,LPCTSTR lpNick,LPCTSTR lpMsg,long lTime);
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CCMSG_H__6407FDCF_884A_46A1_A387_6D3E17915B64__INCLUDED_)
