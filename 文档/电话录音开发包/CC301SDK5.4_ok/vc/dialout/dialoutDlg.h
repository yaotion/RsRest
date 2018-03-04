// dialoutDlg.h : header file
//

#if !defined(AFX_DIALOUTDLG_H__D0A71007_F4BA_4D59_960A_FFF3DA993F17__INCLUDED_)
#define AFX_DIALOUTDLG_H__D0A71007_F4BA_4D59_960A_FFF3DA993F17__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CDialoutDlg dialog

class CDialoutDlg : public CDialog
{
// Construction
public:
	CDialoutDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CDialoutDlg)
	enum { IDD = IDD_DIALOUT_DIALOG };
	CString	m_strCode;
	int		m_chid;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDialoutDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CDialoutDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnTimer(UINT nIDEvent);
	afx_msg void OnDestroy();
	afx_msg void OnStartdial();
	afx_msg void OnHangup();
	afx_msg void OnHook();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	void AppendStatus(CString strStatus);
	void OpenDev();
	void InitDevInfo();
	CString GetDevType(long lDevType);
	CString GetModule(BRIINT16 chID);
	long	ProcessEvent(PBRI_EVENT pEvent);
	UINT	m_nTimer;
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DIALOUTDLG_H__D0A71007_F4BA_4D59_960A_FFF3DA993F17__INCLUDED_)
