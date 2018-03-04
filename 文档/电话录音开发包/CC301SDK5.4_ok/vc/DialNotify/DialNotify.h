// DialNotify.h : main header file for the DIALNOTIFY application
//

#if !defined(AFX_DIALNOTIFY_H__76DC6B1E_26FE_49E3_8338_FADA66ACF0B6__INCLUDED_)
#define AFX_DIALNOTIFY_H__76DC6B1E_26FE_49E3_8338_FADA66ACF0B6__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CDialNotifyApp:
// See DialNotify.cpp for the implementation of this class
//

class CDialNotifyApp : public CWinApp
{
public:
	CDialNotifyApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDialNotifyApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CDialNotifyApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DIALNOTIFY_H__76DC6B1E_26FE_49E3_8338_FADA66ACF0B6__INCLUDED_)
