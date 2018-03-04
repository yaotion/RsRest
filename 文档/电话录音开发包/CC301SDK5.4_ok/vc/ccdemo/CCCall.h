#if !defined(AFX_CCCALL_H__E586044A_18AE_4355_B205_DE7811D8045D__INCLUDED_)
#define AFX_CCCALL_H__E586044A_18AE_4355_B205_DE7811D8045D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// CCCall.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CCCCall dialog

class CCCCall : public CDialog
{
// Construction
public:
	CCCCall(CWnd* pParent = NULL);   // standard constructor
	void	FreeSource();
	long	AppendCallIn(DWORD dwHandle,CString  strData);
	long	CallCC(LPCTSTR lpCC);
// Dialog Data
	//{{AFX_DATA(CCCCall)
	enum { IDD = IDD_CCCALL_DIALOG };
	CButton	m_cRefuse;
	CButton	m_cAnswer;
	CButton	m_cBusy;
	CListCtrl	m_CallList;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CCCCall)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CCCCall)
	virtual BOOL OnInitDialog();
	virtual void OnCancel();
	afx_msg void OnAnswer();
	afx_msg void OnRefuse();
	afx_msg void OnBusy();
	afx_msg void OnStop();
	afx_msg void OnStartplayfile();
	afx_msg void OnStopplayfile();
	afx_msg void OnStartrecordfile();
	afx_msg void OnStopfilerecord();
	afx_msg void OnHold();
	afx_msg void OnUnhold();
	afx_msg void OnSwitch();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	long	AppendCallList(LPCTSTR lpCC,LPCTSTR lpNick,LPCTSTR lpCallType,LPCTSTR lpState,DWORD dwHandle);
	long	InitList();
	void AppendStatus(CString strStatus);
	long	GetHandleItem(DWORD dwHandle);
	long	GetFirstSelectedItem();
	CString	GetCallErr(int iErrID);

	CString SelectFilePath(int iType);
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CCCALL_H__E586044A_18AE_4355_B205_DE7811D8045D__INCLUDED_)
