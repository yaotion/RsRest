#if !defined(AFX_CZGOCXPPG_H__F1EE2C3A_849C_4FC4_B66D_2EFC3A3A5B7D__INCLUDED_)
#define AFX_CZGOCXPPG_H__F1EE2C3A_849C_4FC4_B66D_2EFC3A3A5B7D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

// CzgocxPpg.h : Declaration of the CCzgocxPropPage property page class.

////////////////////////////////////////////////////////////////////////////
// CCzgocxPropPage : See CzgocxPpg.cpp.cpp for implementation.

class CCzgocxPropPage : public COlePropertyPage
{
	DECLARE_DYNCREATE(CCzgocxPropPage)
	DECLARE_OLECREATE_EX(CCzgocxPropPage)

// Constructor
public:
	CCzgocxPropPage();

// Dialog Data
	//{{AFX_DATA(CCzgocxPropPage)
	enum { IDD = IDD_PROPPAGE_CZGOCX };
		// NOTE - ClassWizard will add data members here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_DATA

// Implementation
protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

// Message maps
protected:
	//{{AFX_MSG(CCzgocxPropPage)
		// NOTE - ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CZGOCXPPG_H__F1EE2C3A_849C_4FC4_B66D_2EFC3A3A5B7D__INCLUDED)
