#if !defined(AFX_CONTACT_H__7CC7CB22_8557_426F_9A4B_15367615D498__INCLUDED_)
#define AFX_CONTACT_H__7CC7CB22_8557_426F_9A4B_15367615D498__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// Contact.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CContact dialog

class CContact : public CDialog
{
// Construction
public:
	CContact(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CContact)
	enum { IDD = IDD_CONTACT_DIALOG };
	CString	m_strCC;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CContact)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CContact)
	virtual BOOL OnInitDialog();
	afx_msg void OnAdd();
	afx_msg void OnDel();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:

};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CONTACT_H__7CC7CB22_8557_426F_9A4B_15367615D498__INCLUDED_)
