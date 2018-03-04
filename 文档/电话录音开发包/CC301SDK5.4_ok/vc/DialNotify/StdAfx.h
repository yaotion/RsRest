// stdafx.h : include file for standard system include files,
//  or project specific include files that are used frequently, but
//      are changed infrequently
//

#if !defined(AFX_STDAFX_H__6EE8A3A5_E920_48DA_B272_87005CE70A73__INCLUDED_)
#define AFX_STDAFX_H__6EE8A3A5_E920_48DA_B272_87005CE70A73__INCLUDED_

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


#define		DC_CALLBACK_MESSAGE		(WM_USER+2000)
enum
{
	DC_NULL=0x0,
	DC_REQUEST_CODE=0x1,//请求一个号码
	DC_DIAL_NOTTALK=0x2,
	DC_DIAL_FINISH=0x3,//已经结束
	DC_DIAL_STATUS=0x4,//提示一个状态

};

typedef struct tag_dcdata
{
	short uchannelid;
	long ltype;
	char szData[256];
	long lresult;
}DC_DATA,*PDC_DATA;


#define		DC_TOOLTIP_FILE		"wave\\tooltip.wav"
#define		DC_DATA_FILE		"wave\\data.wav"

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_STDAFX_H__6EE8A3A5_E920_48DA_B272_87005CE70A73__INCLUDED_)
