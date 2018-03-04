// CzgocxPpg.cpp : Implementation of the CCzgocxPropPage property page class.

#include "stdafx.h"
#include "czgocx.h"
#include "CzgocxPpg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif


IMPLEMENT_DYNCREATE(CCzgocxPropPage, COlePropertyPage)


/////////////////////////////////////////////////////////////////////////////
// Message map

BEGIN_MESSAGE_MAP(CCzgocxPropPage, COlePropertyPage)
	//{{AFX_MSG_MAP(CCzgocxPropPage)
	// NOTE - ClassWizard will add and remove message map entries
	//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// Initialize class factory and guid

IMPLEMENT_OLECREATE_EX(CCzgocxPropPage, "CZGOCX.CzgocxPropPage.1",
	0x7cb9f0c0, 0x1f89, 0x4ec0, 0xaa, 0x68, 0x50, 0x61, 0x76, 0x8b, 0x9b, 0x1)


/////////////////////////////////////////////////////////////////////////////
// CCzgocxPropPage::CCzgocxPropPageFactory::UpdateRegistry -
// Adds or removes system registry entries for CCzgocxPropPage

BOOL CCzgocxPropPage::CCzgocxPropPageFactory::UpdateRegistry(BOOL bRegister)
{
	if (bRegister)
		return AfxOleRegisterPropertyPageClass(AfxGetInstanceHandle(),
			m_clsid, IDS_CZGOCX_PPG);
	else
		return AfxOleUnregisterClass(m_clsid, NULL);
}


/////////////////////////////////////////////////////////////////////////////
// CCzgocxPropPage::CCzgocxPropPage - Constructor

CCzgocxPropPage::CCzgocxPropPage() :
	COlePropertyPage(IDD, IDS_CZGOCX_PPG_CAPTION)
{
	//{{AFX_DATA_INIT(CCzgocxPropPage)
	// NOTE: ClassWizard will add member initialization here
	//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_DATA_INIT
}


/////////////////////////////////////////////////////////////////////////////
// CCzgocxPropPage::DoDataExchange - Moves data between page and properties

void CCzgocxPropPage::DoDataExchange(CDataExchange* pDX)
{
	//{{AFX_DATA_MAP(CCzgocxPropPage)
	// NOTE: ClassWizard will add DDP, DDX, and DDV calls here
	//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_DATA_MAP
	DDP_PostProcessing(pDX);
}


/////////////////////////////////////////////////////////////////////////////
// CCzgocxPropPage message handlers
