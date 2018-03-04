// switchdemoDlg.h : header file
//

#if !defined(AFX_SWITCHDEMODLG_H__954B0FA4_97FD_48C1_A1A6_BE5CD4F1059B__INCLUDED_)
#define AFX_SWITCHDEMODLG_H__954B0FA4_97FD_48C1_A1A6_BE5CD4F1059B__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CSwitchdemoDlg dialog
#include "switchchannel.h"
#include <afxtempl.h>
class CSwitchdemoDlg : public CDialog
{
// Construction
public:
	CSwitchdemoDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CSwitchdemoDlg)
	enum { IDD = IDD_SWITCHDEMO_DIALOG };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CSwitchdemoDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CSwitchdemoDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnDestroy();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	long	InitDevice();
	void	InitDevInfo();
	void	AppendStatus(CString strStatus);
	CString GetModule(BRIINT16 chID);
private:
	CArray<CSwitchChannel*,CSwitchChannel*> m_ChannelCtrlArray;
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_SWITCHDEMODLG_H__954B0FA4_97FD_48C1_A1A6_BE5CD4F1059B__INCLUDED_)
