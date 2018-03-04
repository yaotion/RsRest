// ConferenceDemo.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include "ConferenceDemo.h"
#include "ConferenceDemoDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CConferenceDemoApp

BEGIN_MESSAGE_MAP(CConferenceDemoApp, CWinApp)
	//{{AFX_MSG_MAP(CConferenceDemoApp)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG
	ON_COMMAND(ID_HELP, CWinApp::OnHelp)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CConferenceDemoApp construction

CConferenceDemoApp::CConferenceDemoApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}

/////////////////////////////////////////////////////////////////////////////
// The one and only CConferenceDemoApp object

CConferenceDemoApp theApp;

/////////////////////////////////////////////////////////////////////////////
// CConferenceDemoApp initialization

BOOL CConferenceDemoApp::InitInstance()
{
	AfxEnableControlContainer();

	// Standard initialization
	// If you are not using these features and wish to reduce the size
	//  of your final executable, you should remove from the following
	//  the specific initialization routines you do not need.

#ifdef _AFXDLL
	Enable3dControls();			// Call this when using MFC in a shared DLL
#else
	Enable3dControlsStatic();	// Call this when linking to MFC statically
#endif

	CConferenceDemoDlg dlg;
	m_pMainWnd = &dlg;
	int nResponse = dlg.DoModal();
	if (nResponse == IDOK)
	{
		// TODO: Place code here to handle when the dialog is
		//  dismissed with OK
	}
	else if (nResponse == IDCANCEL)
	{
		// TODO: Place code here to handle when the dialog is
		//  dismissed with Cancel
	}

	// Since the dialog has been closed, return FALSE so that we exit the
	//  application, rather than start the application's message pump.
	return FALSE;
}

CString CConferenceDemoApp::SelectFilePath(int iType)
{
	CString strDestPath;
	char szFile[260];       // buffer for filename
	OPENFILENAME ofn;
	memset(szFile,0,sizeof(szFile));
	ZeroMemory(&ofn, sizeof(OPENFILENAME));
	ofn.lStructSize = sizeof(OPENFILENAME);
	ofn.hwndOwner = AfxGetMainWnd()->GetSafeHwnd();
	ofn.lpstrFile = szFile;
	ofn.nMaxFile = sizeof(szFile);
	
	ofn.nFilterIndex = 1;
	ofn.lpstrFileTitle = NULL;
	ofn.nMaxFileTitle = 0;
	
	ofn.lpstrInitialDir = NULL;
	ofn.Flags = OFN_PATHMUSTEXIST | OFN_FILEMUSTEXIST|OFN_OVERWRITEPROMPT;
	
	ofn.lpstrFilter = "wav file\0*.wav;*.pcm;*.wave\0All file\0*.*\0";
	ofn.lpstrDefExt = ".wav";
	
	if(iType == 0)
	{
		if(::GetSaveFileName(&ofn))
		{
			strDestPath = szFile;
		}
	}else 
	{
		if(::GetOpenFileName(&ofn))
		{
			strDestPath = szFile;			
		}
	}
	if(!strDestPath.IsEmpty() && strDestPath.Find(".") < 0) strDestPath+=ofn.lpstrDefExt;
	return strDestPath;
}