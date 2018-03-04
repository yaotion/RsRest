// dialout.h : main header file for the DIALOUT application
//

#if !defined(AFX_DIALOUT_H__17D12A34_2243_4D7F_9C36_184578DDAB93__INCLUDED_)
#define AFX_DIALOUT_H__17D12A34_2243_4D7F_9C36_184578DDAB93__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CDialoutApp:
// See dialout.cpp for the implementation of this class
//

class CDialoutApp : public CWinApp
{
public:
	CDialoutApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDialoutApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CDialoutApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DIALOUT_H__17D12A34_2243_4D7F_9C36_184578DDAB93__INCLUDED_)
