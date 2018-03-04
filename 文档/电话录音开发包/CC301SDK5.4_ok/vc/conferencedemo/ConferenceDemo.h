// ConferenceDemo.h : main header file for the CONFERENCEDEMO application
//

#if !defined(AFX_CONFERENCEDEMO_H__01385D12_62F3_461E_9C52_1B1D6B5E1415__INCLUDED_)
#define AFX_CONFERENCEDEMO_H__01385D12_62F3_461E_9C52_1B1D6B5E1415__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CConferenceDemoApp:
// See ConferenceDemo.cpp for the implementation of this class
//

class CConferenceDemoApp : public CWinApp
{
public:
	CConferenceDemoApp();

	CString SelectFilePath(int iType);
// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CConferenceDemoApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CConferenceDemoApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CONFERENCEDEMO_H__01385D12_62F3_461E_9C52_1B1D6B5E1415__INCLUDED_)
