// switchdemo.h : main header file for the SWITCHDEMO application
//

#if !defined(AFX_SWITCHDEMO_H__6B2B0A6F_F2EC_4608_9BE8_F61B998ED4EB__INCLUDED_)
#define AFX_SWITCHDEMO_H__6B2B0A6F_F2EC_4608_9BE8_F61B998ED4EB__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CSwitchdemoApp:
// See switchdemo.cpp for the implementation of this class
//

class CSwitchdemoApp : public CWinApp
{
public:
	CSwitchdemoApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CSwitchdemoApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CSwitchdemoApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_SWITCHDEMO_H__6B2B0A6F_F2EC_4608_9BE8_F61B998ED4EB__INCLUDED_)
