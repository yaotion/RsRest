#if !defined(AFX_CZGOCXCTL_H__0CC6C59F_D1C8_48F6_8535_B6CA26DB9D84__INCLUDED_)
#define AFX_CZGOCXCTL_H__0CC6C59F_D1C8_48F6_8535_B6CA26DB9D84__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

// CzgocxCtl.h : Declaration of the CCzgocxCtrl ActiveX Control class.

/////////////////////////////////////////////////////////////////////////////
// CCzgocxCtrl : See CzgocxCtl.cpp for implementation.
#include "testdialog.h"

class CCzgocxCtrl : public COleControl
{
	DECLARE_DYNCREATE(CCzgocxCtrl)

// Constructor
public:
	CCzgocxCtrl();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CCzgocxCtrl)
	public:
	virtual void OnDraw(CDC* pdc, const CRect& rcBounds, const CRect& rcInvalid);
	virtual void DoPropExchange(CPropExchange* pPX);
	virtual void OnResetState();
	virtual void OnFinalRelease();
	//}}AFX_VIRTUAL

// Implementation
protected:
	~CCzgocxCtrl();

	DECLARE_OLECREATE_EX(CCzgocxCtrl)    // Class factory and guid
	DECLARE_OLETYPELIB(CCzgocxCtrl)      // GetTypeInfo
	DECLARE_PROPPAGEIDS(CCzgocxCtrl)     // Property page IDs
	DECLARE_OLECTLTYPE(CCzgocxCtrl)		// Type name and misc status

// Message maps
	//{{AFX_MSG(CCzgocxCtrl)
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

// Dispatch maps
	//{{AFX_DISPATCH(CCzgocxCtrl)
	afx_msg long OpenDev();
	afx_msg long CloseDev();
	//}}AFX_DISPATCH
	DECLARE_DISPATCH_MAP()

	afx_msg void AboutBox();

// Event maps
	//{{AFX_EVENT(CCzgocxCtrl)
	//}}AFX_EVENT
	DECLARE_EVENT_MAP()

// Dispatch and event IDs
public:
	enum {
	//{{AFX_DISP_ID(CCzgocxCtrl)
	dispidOpenDev = 1L,
	dispidCloseDev = 2L,
	//}}AFX_DISP_ID
	};

	CTestDialog *m_pTest;
	CTestDialog  m_Test ;
private:
//	long	OpenDev();
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CZGOCXCTL_H__0CC6C59F_D1C8_48F6_8535_B6CA26DB9D84__INCLUDED)
