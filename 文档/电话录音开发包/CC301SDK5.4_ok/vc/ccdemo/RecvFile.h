#if !defined(AFX_RECVFILE_H__883BD7F7_E5D2_46DE_B0B4_E6E5EDFD3E07__INCLUDED_)
#define AFX_RECVFILE_H__883BD7F7_E5D2_46DE_B0B4_E6E5EDFD3E07__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// RecvFile.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CRecvFile dialog

class CRecvFile : public CDialog
{
// Construction
public:
	CRecvFile(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CRecvFile)
	enum { IDD = IDD_RECVFILE_DIALOG };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CRecvFile)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CRecvFile)
	virtual BOOL OnInitDialog();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_RECVFILE_H__883BD7F7_E5D2_46DE_B0B4_E6E5EDFD3E07__INCLUDED_)
