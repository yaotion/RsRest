#if !defined(AFX_RECVFAXDIALOG_H__5AA1C2D7_E9B9_42D9_A3EA_0EC44E29D713__INCLUDED_)
#define AFX_RECVFAXDIALOG_H__5AA1C2D7_E9B9_42D9_A3EA_0EC44E29D713__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// RecvFaxDialog.h : header file
//
#include "BriFaxBase.h"

/////////////////////////////////////////////////////////////////////////////
// CRecvFaxDialog dialog

class CRecvFaxDialog : public CDialog,public CBriFaxBase
{
// Construction
public:
	CRecvFaxDialog(CWnd* pParent = NULL);   // standard constructor
	long	StartRecv(char *szFilePath,long lType);
	long	StopRecv();

// Dialog Data
	//{{AFX_DATA(CRecvFaxDialog)
	enum { IDD = IDD_RECVFAX_DIALOG };
	CButton	m_cOpenDir;
	CStatic	m_cStElapse;
	CButton	m_cDoPlay;
	CEdit	m_cFilePath;
	CButton	m_cViewRecvFile;
	CStatic	m_cState;
	CButton	m_Cancel;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CRecvFaxDialog)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CRecvFaxDialog)
	virtual BOOL OnInitDialog();
	virtual void OnCancel();	
	afx_msg void OnDestroy();
	afx_msg void OnViewrecvfile();
	afx_msg void OnDoplay();
	afx_msg void OnOpendir();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	CString CreateFaxFile();
private:
	long	m_lType;

};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_RECVFAXDIALOG_H__5AA1C2D7_E9B9_42D9_A3EA_0EC44E29D713__INCLUDED_)
