#if !defined(AFX_STDAFX_H__129A7664_1D3D_4BE6_92EC_8DB82AE4F510__INCLUDED_)
#define AFX_STDAFX_H__129A7664_1D3D_4BE6_92EC_8DB82AE4F510__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

// stdafx.h : include file for standard system include files,
//      or project specific include files that are used frequently,
//      but are changed infrequently

#define VC_EXTRALEAN		// Exclude rarely-used stuff from Windows headers

#include <afxctl.h>         // MFC support for ActiveX Controls
#include <afxext.h>         // MFC extensions
#include <afxdtctl.h>		// MFC support for Internet Explorer 4 Comon Controls
#ifndef _AFX_NO_AFXCMN_SUPPORT
#include <afxcmn.h>			// MFC support for Windows Common Controls
#endif // _AFX_NO_AFXCMN_SUPPORT

// Delete the two includes below if you do not wish to use the MFC
//  database classes
#include <afxdb.h>			// MFC database classes
#include <afxdao.h>			// MFC DAO database classes

#include "../include/BriSDKLib.h"
#include "../include/BriChipErr.h"

#pragma comment(lib,"../lib/qnviccub.lib")
#define		QNV_CHANNEL_MESSAGE				(WM_USER+3000)
#define		QNV_CLOSECONFERENCE_MESSAGE		(WM_USER+3001)
#define		QNV_CLOSECCMODULE_MESSAGE		(WM_USER+3002)
#define		QNV_CLOSEFILETRANSFER_MESSAGE	(WM_USER+3003)
enum
{
	CB_NULL=0x0,
	CB_APPENDSTATUS
};
//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_STDAFX_H__129A7664_1D3D_4BE6_92EC_8DB82AE4F510__INCLUDED_)
