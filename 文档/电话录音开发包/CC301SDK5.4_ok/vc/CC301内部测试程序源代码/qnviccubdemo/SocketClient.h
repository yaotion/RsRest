#if !defined(AFX_SOCKETCLIENT_H__F614662D_0F19_46B3_94EB_9DA256A2A18A__INCLUDED_)
#define AFX_SOCKETCLIENT_H__F614662D_0F19_46B3_94EB_9DA256A2A18A__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// SocketClient.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CSocketClient dialog

class CSocketClient : public CDialog
{
// Construction
public:
	CSocketClient(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CSocketClient)
	enum { IDD = IDD_SOCKETCLIENT_DIALOG };
	CString	m_strData;
	CString	m_strSvrIP;
	UINT	m_nSvrPort;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CSocketClient)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CSocketClient)
	afx_msg void OnStartconnect();
	virtual BOOL OnInitDialog();
	afx_msg void OnStopconnect();
	afx_msg void OnSend();
	afx_msg void OnDestroy();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	void	AppendStatus(CString strStatus);
	long	m_lSocketHandle;
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_SOCKETCLIENT_H__F614662D_0F19_46B3_94EB_9DA256A2A18A__INCLUDED_)
