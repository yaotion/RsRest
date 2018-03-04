#if !defined(AFX_CCCMD_H__29018548_09FE_44EB_9FB3_92825716AF85__INCLUDED_)
#define AFX_CCCMD_H__29018548_09FE_44EB_9FB3_92825716AF85__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// CCCmd.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CCCCmd dialog

class CCCCmd : public CDialog
{
// Construction
public:
	CCCCmd(CWnd* pParent = NULL);   // standard constructor
	void	FreeSource();
	long	AppendRecvCmd(CString strCmd);
// Dialog Data
	//{{AFX_DATA(CCCCmd)
	enum { IDD = IDD_CCCMD_DIALOG };
	CEdit	m_cRecvCmd;
	CEdit	m_cSendCmd;
	CEdit	m_cDestCC;
	CString	m_strRecvCmd;
	CString	m_strDestCC;
	CString	m_strSendCmd;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CCCCmd)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CCCCmd)
	virtual BOOL OnInitDialog();
	virtual void OnCancel();
	afx_msg void OnSendcmd();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	long	AppendRecvCmd(LPCTSTR lpVID,LPCTSTR lpNick,LPCTSTR lpMsg);
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CCCMD_H__29018548_09FE_44EB_9FB3_92825716AF85__INCLUDED_)
