#if !defined(AFX_SENDFAXDIALOG_H__1EEBD7B8_D84B_454A_9C7A_63C9E36E70E9__INCLUDED_)
#define AFX_SENDFAXDIALOG_H__1EEBD7B8_D84B_454A_9C7A_63C9E36E70E9__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// SendFaxDialog.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CSendFaxDialog dialog
#include "resource.h"
#include "BriFaxBase.h"

class CSendFaxDialog : public CDialog,public CBriFaxBase
{
// Construction
public:
	CSendFaxDialog(CWnd* pParent = NULL);   // standard constructor
	long	StartSend(char *szFilePath,long lType);
	long	StopSend();
// Dialog Data
	//{{AFX_DATA(CSendFaxDialog)
	enum { IDD = IDD_SENDFAX_DIALOG };
	CProgressCtrl	m_cSendProgress;
	CStatic	m_cStElapse;
	CButton	m_cDoPlay;
	CEdit	m_cSendFilePath;
	CStatic	m_cSendState;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CSendFaxDialog)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CSendFaxDialog)
	afx_msg void OnViewsendfile();
	virtual BOOL OnInitDialog();
	virtual void OnCancel();
	afx_msg void OnDestroy();
	afx_msg void OnDoplay();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	long	m_lImageSize;
	long	GetFileType(char *pFilePath);
	long	SaveSendFaxFile(CString strFileName);
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_SENDFAXDIALOG_H__1EEBD7B8_D84B_454A_9C7A_63C9E36E70E9__INCLUDED_)
