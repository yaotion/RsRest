#if !defined(AFX_CREATECONF_H__DD6E2728_AED8_4669_B9AE_DD0C5D958F15__INCLUDED_)
#define AFX_CREATECONF_H__DD6E2728_AED8_4669_B9AE_DD0C5D958F15__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// CreateConf.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CCreateConf dialog

class CCreateConf : public CDialog
{
// Construction
public:
	CCreateConf(CWnd* pParent = NULL);   // standard constructor

	CDWordArray	m_ChannelArray;
	long	m_lConfID;
// Dialog Data
	//{{AFX_DATA(CCreateConf)
	enum { IDD = IDD_CREATECONF_DIALOG };
	CListCtrl	m_cChannelList;
	CString		m_strConfName;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CCreateConf)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CCreateConf)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CREATECONF_H__DD6E2728_AED8_4669_B9AE_DD0C5D958F15__INCLUDED_)
