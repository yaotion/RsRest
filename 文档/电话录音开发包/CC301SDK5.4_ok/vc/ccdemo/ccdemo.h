// ccdemo.h : main header file for the CCDEMO application
//

#if !defined(AFX_CCDEMO_H__1B8AB186_B6AE_44BB_ABEA_556D76EA4C01__INCLUDED_)
#define AFX_CCDEMO_H__1B8AB186_B6AE_44BB_ABEA_556D76EA4C01__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CCcdemoApp:
// See ccdemo.cpp for the implementation of this class
//

class CCcdemoApp : public CWinApp
{
public:
	CCcdemoApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CCcdemoApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CCcdemoApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CCDEMO_H__1B8AB186_B6AE_44BB_ABEA_556D76EA4C01__INCLUDED_)
