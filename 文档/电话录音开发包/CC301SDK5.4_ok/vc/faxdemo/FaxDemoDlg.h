// FaxDemoDlg.h : header file
//

#if !defined(AFX_FAXDEMODLG_H__E3917E46_B891_43EB_BE96_21A2C15C5D44__INCLUDED_)
#define AFX_FAXDEMODLG_H__E3917E46_B891_43EB_BE96_21A2C15C5D44__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CFaxDemoDlg dialog
#include "RecvFaxDialog.h"
#include "SendFaxDialog.h"

class CFaxDemoDlg : public CDialog
{
// Construction
public:
	CFaxDemoDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CFaxDemoDlg)
	enum { IDD = IDD_FAXDEMO_DIALOG };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CFaxDemoDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CFaxDemoDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnRecvfax();
	afx_msg void OnSendfax();
	afx_msg void OnOpendev();
	afx_msg void OnClosedev();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	void AppendStatus(CString strStatus);
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_FAXDEMODLG_H__E3917E46_B891_43EB_BE96_21A2C15C5D44__INCLUDED_)
