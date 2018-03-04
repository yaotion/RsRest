// DialNotifyDlg.h : header file
//

#if !defined(AFX_DIALNOTIFYDLG_H__74A3B2DB_A0D9_4D6E_84FA_41F11B869F73__INCLUDED_)
#define AFX_DIALNOTIFYDLG_H__74A3B2DB_A0D9_4D6E_84FA_41F11B869F73__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CDialNotifyDlg dialog
#include "DialChannel.h"
#include <afxtempl.h>
class CDialNotifyDlg : public CDialog
{
// Construction
public:
	CDialNotifyDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CDialNotifyDlg)
	enum { IDD = IDD_DIALNOTIFY_DIALOG };
	CEdit		m_cFilePath;
	CListBox	m_cFinishList;
	CEdit		m_cDialLog;
	CListBox	m_cDialList;
	CString		m_strFilePath;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDialNotifyDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CDialNotifyDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnStartdial();
	afx_msg void OnStopdial();
	afx_msg void OnDestroy();
	afx_msg void OnSelectfile();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	long	InitDevice();
	void	InitDevInfo();
	void	FreeSource();
	CString GetModule(BRIINT16 chID);
	void	AppendStatus(BRIINT16 uChannel,CString strStatus);
	CString GetFirstDialCode();
	CString SelectFilePath();
	long	ParseFile(CString strFilePath);//Ω‚Œˆ∫≈¬Î¡–±Ì
	long	AddCodeList(char *pCode);
private:
	CArray<CDialChannel*,CDialChannel*> m_ChannelCtrlArray;
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DIALNOTIFYDLG_H__74A3B2DB_A0D9_4D6E_84FA_41F11B869F73__INCLUDED_)
