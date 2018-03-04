#if !defined(AFX_BROADCAST_H__11FE1A19_A475_414C_9FDD_E93A1D5A6E0A__INCLUDED_)
#define AFX_BROADCAST_H__11FE1A19_A475_414C_9FDD_E93A1D5A6E0A__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// Broadcast.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CBroadcast dialog

class CBroadcast : public CDialog
{
// Construction
public:
	CBroadcast(CWnd* pParent = NULL);   // standard constructor
	void	FreeSource();
// Dialog Data
	//{{AFX_DATA(CBroadcast)
	enum { IDD = IDD_BROADCAST_DIALOG };
	CComboBox	m_cChannelList;
	CListBox	m_IPList;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CBroadcast)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CBroadcast)
	virtual BOOL OnInitDialog();
	virtual void OnCancel();
	afx_msg void OnAdd();
	afx_msg void OnDel();
	afx_msg void OnDestroy();
	afx_msg void OnStartbroad();
	afx_msg void OnStopbroad();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	BRIINT16	GetChannelID(CString strText);
	void		InitDevList();
	short		m_nChannelID;
	long		GetSelectChannel();

	long		AddIPList();
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_BROADCAST_H__11FE1A19_A475_414C_9FDD_E93A1D5A6E0A__INCLUDED_)
