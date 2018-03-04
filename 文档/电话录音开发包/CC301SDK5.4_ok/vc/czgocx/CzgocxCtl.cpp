// CzgocxCtl.cpp : Implementation of the CCzgocxCtrl ActiveX Control class.

#include "stdafx.h"
#include "czgocx.h"
#include "CzgocxCtl.h"
#include "CzgocxPpg.h"


#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif


IMPLEMENT_DYNCREATE(CCzgocxCtrl, COleControl)


/////////////////////////////////////////////////////////////////////////////
// Message map

BEGIN_MESSAGE_MAP(CCzgocxCtrl, COleControl)
	//{{AFX_MSG_MAP(CCzgocxCtrl)
	ON_WM_CREATE()
	//}}AFX_MSG_MAP
	ON_OLEVERB(AFX_IDS_VERB_PROPERTIES, OnProperties)
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// Dispatch map

BEGIN_DISPATCH_MAP(CCzgocxCtrl, COleControl)
	//{{AFX_DISPATCH_MAP(CCzgocxCtrl)
	DISP_FUNCTION(CCzgocxCtrl, "OpenDev", OpenDev, VT_I4, VTS_NONE)
	DISP_FUNCTION(CCzgocxCtrl, "CloseDev", CloseDev, VT_I4, VTS_NONE)
	//}}AFX_DISPATCH_MAP
	DISP_FUNCTION_ID(CCzgocxCtrl, "AboutBox", DISPID_ABOUTBOX, AboutBox, VT_EMPTY, VTS_NONE)
END_DISPATCH_MAP()


/////////////////////////////////////////////////////////////////////////////
// Event map

BEGIN_EVENT_MAP(CCzgocxCtrl, COleControl)
	//{{AFX_EVENT_MAP(CCzgocxCtrl)
	// NOTE - ClassWizard will add and remove event map entries
	//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_EVENT_MAP
END_EVENT_MAP()


/////////////////////////////////////////////////////////////////////////////
// Property pages

// TODO: Add more property pages as needed.  Remember to increase the count!
BEGIN_PROPPAGEIDS(CCzgocxCtrl, 1)
	PROPPAGEID(CCzgocxPropPage::guid)
END_PROPPAGEIDS(CCzgocxCtrl)


/////////////////////////////////////////////////////////////////////////////
// Initialize class factory and guid

IMPLEMENT_OLECREATE_EX(CCzgocxCtrl, "CZGOCX.CzgocxCtrl.1",
	0xbaf5f3c3, 0x6c27, 0x4944, 0xaf, 0x7a, 0x1b, 0x3c, 0x34, 0xa7, 0xdd, 0x40)


/////////////////////////////////////////////////////////////////////////////
// Type library ID and version

IMPLEMENT_OLETYPELIB(CCzgocxCtrl, _tlid, _wVerMajor, _wVerMinor)


/////////////////////////////////////////////////////////////////////////////
// Interface IDs

const IID BASED_CODE IID_DCzgocx =
		{ 0xfdd48749, 0x36a2, 0x4f12, { 0xaa, 0xc, 0xf9, 0x8a, 0x5b, 0x76, 0xd1, 0xad } };
const IID BASED_CODE IID_DCzgocxEvents =
		{ 0x95aecd4d, 0xd9c8, 0x4437, { 0x84, 0x55, 0x37, 0x84, 0xd1, 0xba, 0x47, 0x45 } };


/////////////////////////////////////////////////////////////////////////////
// Control type information

static const DWORD BASED_CODE _dwCzgocxOleMisc =
	OLEMISC_ACTIVATEWHENVISIBLE |
	OLEMISC_SETCLIENTSITEFIRST |
	OLEMISC_INSIDEOUT |
	OLEMISC_CANTLINKINSIDE |
	OLEMISC_RECOMPOSEONRESIZE;

IMPLEMENT_OLECTLTYPE(CCzgocxCtrl, IDS_CZGOCX, _dwCzgocxOleMisc)


/////////////////////////////////////////////////////////////////////////////
// CCzgocxCtrl::CCzgocxCtrlFactory::UpdateRegistry -
// Adds or removes system registry entries for CCzgocxCtrl

BOOL CCzgocxCtrl::CCzgocxCtrlFactory::UpdateRegistry(BOOL bRegister)
{
	// TODO: Verify that your control follows apartment-model threading rules.
	// Refer to MFC TechNote 64 for more information.
	// If your control does not conform to the apartment-model rules, then
	// you must modify the code below, changing the 6th parameter from
	// afxRegApartmentThreading to 0.

	if (bRegister)
		return AfxOleRegisterControlClass(
			AfxGetInstanceHandle(),
			m_clsid,
			m_lpszProgID,
			IDS_CZGOCX,
			IDB_CZGOCX,
			afxRegApartmentThreading,
			_dwCzgocxOleMisc,
			_tlid,
			_wVerMajor,
			_wVerMinor);
	else
		return AfxOleUnregisterClass(m_clsid, m_lpszProgID);
}


/////////////////////////////////////////////////////////////////////////////
// CCzgocxCtrl::CCzgocxCtrl - Constructor

CCzgocxCtrl::CCzgocxCtrl()
{
	InitializeIIDs(&IID_DCzgocx, &IID_DCzgocxEvents);
	m_pTest=NULL;
	// TODO: Initialize your control's instance data here.
}


/////////////////////////////////////////////////////////////////////////////
// CCzgocxCtrl::~CCzgocxCtrl - Destructor

CCzgocxCtrl::~CCzgocxCtrl()
{
	if(m_pTest)
	{
		delete m_pTest;
		m_pTest=NULL;
	}
	// TODO: Cleanup your control's instance data here.
}


/////////////////////////////////////////////////////////////////////////////
// CCzgocxCtrl::OnDraw - Drawing function

void CCzgocxCtrl::OnDraw(
			CDC* pdc, const CRect& rcBounds, const CRect& rcInvalid)
{
	// TODO: Replace the following code with your own drawing code.
	pdc->FillRect(rcBounds, CBrush::FromHandle((HBRUSH)GetStockObject(WHITE_BRUSH)));
	pdc->Ellipse(rcBounds);

	
}


/*long	CCzgocxCtrl::OpenDev()
{
	return QNV_OpenDevice(ODT_LBRIDGE,0,0);
}*/

/////////////////////////////////////////////////////////////////////////////
// CCzgocxCtrl::DoPropExchange - Persistence support

void CCzgocxCtrl::DoPropExchange(CPropExchange* pPX)
{
	ExchangeVersion(pPX, MAKELONG(_wVerMinor, _wVerMajor));
	COleControl::DoPropExchange(pPX);

	// TODO: Call PX_ functions for each persistent custom property.

}


/////////////////////////////////////////////////////////////////////////////
// CCzgocxCtrl::OnResetState - Reset control to default state

void CCzgocxCtrl::OnResetState()
{
	COleControl::OnResetState();  // Resets defaults found in DoPropExchange

	// TODO: Reset any other control state here.
}


/////////////////////////////////////////////////////////////////////////////
// CCzgocxCtrl::AboutBox - Display an "About" box to the user

void CCzgocxCtrl::AboutBox()
{
	CDialog dlgAbout(IDD_ABOUTBOX_CZGOCX);
	dlgAbout.DoModal();
}


/////////////////////////////////////////////////////////////////////////////
// CCzgocxCtrl message handlers

long CCzgocxCtrl::OpenDev() 
{
	// TODO: Add your dispatch handler code here
	m_Test.OnOpendev () ;
	return 1 ;
}

long CCzgocxCtrl::CloseDev() 
{
	// TODO: Add your dispatch handler code here
	m_Test.OnClosedev () ;
	return 0;
}

int CCzgocxCtrl::OnCreate(LPCREATESTRUCT lpCreateStruct) 
{
	if (COleControl::OnCreate(lpCreateStruct) == -1)
		return -1;
	
	// TODO: Add your specialized creation code here
	if(!m_pTest)
	{
		m_pTest = new CTestDialog();
		m_pTest->Create(CTestDialog::IDD,this);
		m_pTest->ShowWindow(SW_SHOW);
	}
	m_pTest->SetWindowPos(NULL,0,0,500,500,NULL);	
	return 0;
}

void CCzgocxCtrl::OnFinalRelease() 
{
	if(m_pTest)
	{
		delete m_pTest;
		m_pTest=NULL;
	}	
	COleControl::OnFinalRelease();
}
