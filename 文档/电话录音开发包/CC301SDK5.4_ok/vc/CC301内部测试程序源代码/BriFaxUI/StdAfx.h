// stdafx.h : include file for standard system include files,
//  or project specific include files that are used frequently, but
//      are changed infrequently
//

#if !defined(AFX_STDAFX_H__C1116475_F37F_46E6_83F8_BE56DFC4E1AF__INCLUDED_)
#define AFX_STDAFX_H__C1116475_F37F_46E6_83F8_BE56DFC4E1AF__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#define VC_EXTRALEAN		// Exclude rarely-used stuff from Windows headers

#include <afxwin.h>         // MFC core and standard components
#include <afxext.h>         // MFC extensions

/*
#ifndef _AFX_NO_OLE_SUPPORT
#include <afxole.h>         // MFC OLE classes
#include <afxodlgs.h>       // MFC OLE dialog classes
#include <afxdisp.h>        // MFC Automation classes
#endif // _AFX_NO_OLE_SUPPORT


#ifndef _AFX_NO_DB_SUPPORT
#include <afxdb.h>			// MFC ODBC database classes
#endif // _AFX_NO_DB_SUPPORT

#ifndef _AFX_NO_DAO_SUPPORT
#include <afxdao.h>			// MFC DAO database classes
#endif // _AFX_NO_DAO_SUPPORT
*/

#include <afxdtctl.h>		// MFC support for Internet Explorer 4 Common Controls
#ifndef _AFX_NO_AFXCMN_SUPPORT
#include <afxcmn.h>			// MFC support for Windows Common Controls
#endif // _AFX_NO_AFXCMN_SUPPORT

#include "../../include/BriSDKLib.h"
#include "../../include/BriChipErr.h"

#pragma comment(lib,"../../lib/qnviccub.lib")

#include "resource.h"

#define		FAX_CLOSERECV_MESSAGE		(WM_USER+4000)
#define		FAX_CLOSESEND_MESSAGE		(WM_USER+4001)
#define		FAX_CLOSELOG_MESSAGE		(WM_USER+4002)
#define		FAX_TOOLTIP_MESSAGE			(WM_USER+4003)

#define		FAX_LOG_FILE				"TmMdb\\FaxLog.db"
#define		FAX_RECV_FILE				"FaxFile\\Recv"
#define		FAX_SEND_FILE				"FaxFile\\Send"

enum
{
	FFT_NULL=0x0,
	FFT_UNKNOW,
	FFT_PIC,
	FFT_DOC,
	FFT_WEB
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_STDAFX_H__C1116475_F37F_46E6_83F8_BE56DFC4E1AF__INCLUDED_)
