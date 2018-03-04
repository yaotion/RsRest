// stdafx.h : include file for standard system include files,
//  or project specific include files that are used frequently, but
//      are changed infrequently
//

#if !defined(AFX_STDAFX_H__D0658F02_E0F5_464C_BB0C_549BDBD8E640__INCLUDED_)
#define AFX_STDAFX_H__D0658F02_E0F5_464C_BB0C_549BDBD8E640__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#define VC_EXTRALEAN		// Exclude rarely-used stuff from Windows headers

#include <afxwin.h>         // MFC core and standard components
#include <afxext.h>         // MFC extensions
#include <afxdisp.h>        // MFC Automation classes
#include <afxdtctl.h>		// MFC support for Internet Explorer 4 Common Controls
#ifndef _AFX_NO_AFXCMN_SUPPORT
#include <afxcmn.h>			// MFC support for Windows Common Controls
#endif // _AFX_NO_AFXCMN_SUPPORT

#include "../include/BriSDKLib.h"
#include "../include/BriChipErr.h"

#pragma comment(lib,"../lib/qnviccub.lib")

#define		DC_CALLBACK_MESSAGE		(WM_USER+3000)
typedef struct tag_dcdata
{
	short uchannelid;
	long ltype;
	char szData[256];
	long lresult;
}DC_DATA,*PDC_DATA;


//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_STDAFX_H__D0658F02_E0F5_464C_BB0C_549BDBD8E640__INCLUDED_)
