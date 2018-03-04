#if !defined(AFX_CZGOCX_H__A222747D_2296_4279_AAD4_C37C8682DD26__INCLUDED_)
#define AFX_CZGOCX_H__A222747D_2296_4279_AAD4_C37C8682DD26__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

// czgocx.h : main header file for CZGOCX.DLL

#if !defined( __AFXCTL_H__ )
	#error include 'afxctl.h' before including this file
#endif

#include "resource.h"       // main symbols

/////////////////////////////////////////////////////////////////////////////
// CCzgocxApp : See czgocx.cpp for implementation.

class CCzgocxApp : public COleControlModule
{
public:
	BOOL InitInstance();
	int ExitInstance();
};

extern const GUID CDECL _tlid;
extern const WORD _wVerMajor;
extern const WORD _wVerMinor;

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CZGOCX_H__A222747D_2296_4279_AAD4_C37C8682DD26__INCLUDED)
