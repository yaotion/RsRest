#if !defined(AFX_SOCKETUDP_H__ED821689_714D_40E2_AA18_47EC81BD67CE__INCLUDED_)
#define AFX_SOCKETUDP_H__ED821689_714D_40E2_AA18_47EC81BD67CE__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// SocketUDP.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CSocketUDP dialog

class CSocketUDP : public CDialog
{
// Construction
public:
	CSocketUDP(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CSocketUDP)
	enum { IDD = IDD_SOCKETUDP_DIALOG };
	CString	m_strIP;
	int		m_nPort;
	CString	m_strData;
	CString	m_strServerName;
	int		m_nFindPort;
	CString	m_strFindServerName;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CSocketUDP)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CSocketUDP)
	virtual BOOL OnInitDialog();
	afx_msg void OnSend();
	afx_msg void OnSetservername();
	afx_msg void OnStartfind();
	afx_msg void OnStopfind();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	void	AppendStatus(CString strStatus);
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_SOCKETUDP_H__ED821689_714D_40E2_AA18_47EC81BD67CE__INCLUDED_)
