// qnviccubdemo.h : main header file for the QNVICCUBDEMO application
//

#if !defined(AFX_QNVICCUBDEMO_H__BEA4EF8C_352A_4076_B2F9_9928A2F5D8E3__INCLUDED_)
#define AFX_QNVICCUBDEMO_H__BEA4EF8C_352A_4076_B2F9_9928A2F5D8E3__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CQnviccubdemoApp:
// See qnviccubdemo.cpp for the implementation of this class
//

class CQnviccubdemoApp : public CWinApp
{
public:
	CQnviccubdemoApp();
	CString SelectFilePath(int iType);
	CString GetSelectedFilePath2(CString szFilter,CString szExtName,CString szDefaultPath,CString strDefaultFileName,HWND hOwerWnd,BOOL bType);
// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CQnviccubdemoApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CQnviccubdemoApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_QNVICCUBDEMO_H__BEA4EF8C_352A_4076_B2F9_9928A2F5D8E3__INCLUDED_)
