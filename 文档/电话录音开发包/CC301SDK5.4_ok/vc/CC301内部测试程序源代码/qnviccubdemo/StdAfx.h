// stdafx.h : include file for standard system include files,
//  or project specific include files that are used frequently, but
//      are changed infrequently
//

#if !defined(AFX_STDAFX_H__C7216913_2ED7_475A_AA65_EA0A8062D3F9__INCLUDED_)
#define AFX_STDAFX_H__C7216913_2ED7_475A_AA65_EA0A8062D3F9__INCLUDED_

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

#include "../../include/BriSDKLib.h"
#include "../../include/BriChipErr.h"

#include "../BriFaxUI/BriFaxUI.h"
#ifdef _DEBUG
#pragma comment(lib,"../BriFaxUI/debug/BriFaxUI.lib")
#else
#pragma comment(lib,"../BriFaxUI/release/BriFaxUI.lib")
#endif

/*
#include "../BriBroadcast/BriBroadcast.h"
#pragma comment(lib,"../../lib/BriBroadcast.lib")
#endif
*/

#pragma comment(lib,"../../lib/qnviccub.lib")

#define		QNV_CHANNEL_MESSAGE				(WM_USER+3000)
#define		QNV_CLOSECONFERENCE_MESSAGE		(WM_USER+3001)
#define		QNV_CLOSECCMODULE_MESSAGE		(WM_USER+3002)
#define		QNV_CLOSEFILETRANSFER_MESSAGE	(WM_USER+3003)
enum
{
	CB_NULL=0x0,
	CB_APPENDSTATUS,
	CB_STARTDIAL,
};


#define			RECVBROADCAST_PORT		9988//½ÓÊÕ¶Ë¿Ú

#define			_VER_TEXT_				"2.16"
//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_STDAFX_H__C7216913_2ED7_475A_AA65_EA0A8062D3F9__INCLUDED_)
