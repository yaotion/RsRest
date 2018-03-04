// qnviccubdemo.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include "qnviccubdemo.h"
#include "qnviccubdemoDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CQnviccubdemoApp

BEGIN_MESSAGE_MAP(CQnviccubdemoApp, CWinApp)
	//{{AFX_MSG_MAP(CQnviccubdemoApp)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG
	ON_COMMAND(ID_HELP, CWinApp::OnHelp)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CQnviccubdemoApp construction

CQnviccubdemoApp::CQnviccubdemoApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}

/////////////////////////////////////////////////////////////////////////////
// The one and only CQnviccubdemoApp object

CQnviccubdemoApp theApp;

/////////////////////////////////////////////////////////////////////////////
// CQnviccubdemoApp initialization

BOOL CQnviccubdemoApp::InitInstance()
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

	CQnviccubdemoDlg dlg;
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

CString CQnviccubdemoApp::SelectFilePath(int iType)
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

CString CQnviccubdemoApp::GetSelectedFilePath2(CString szFilter,CString szExtName,CString szDefaultPath,CString strDefaultFileName,HWND hOwerWnd,BOOL bType)
{
	char szFile[512]={0};       // buffer for filename	
	OPENFILENAME ofn={0};
	ofn.lStructSize = sizeof(OPENFILENAME);	
	if(strDefaultFileName.GetLength() < 512)
	{
		strcpy(szFile,(LPTSTR)(LPCTSTR)strDefaultFileName);
	}
	ofn.hwndOwner = hOwerWnd;
	ofn.lpstrFile = szFile;
	ofn.nMaxFile = sizeof(szFile);
	szFilter.Replace('|','\0');
	ofn.lpstrFilter=(LPCTSTR)szFilter;
	ofn.lpstrInitialDir=(LPCTSTR)szDefaultPath;
	ofn.nFilterIndex = 1;
	ofn.lpstrFileTitle = NULL;
	ofn.nMaxFileTitle = 0;
	ofn.Flags = OFN_PATHMUSTEXIST | OFN_FILEMUSTEXIST|OFN_OVERWRITEPROMPT;

	char OldDir[_MAX_PATH];
	GetCurrentDirectory(_MAX_PATH, OldDir);

	if(bType)
	{
		if(::GetOpenFileName(&ofn))
		{
			CString strPath = szFile;
			//SetCurrentDirectory(OldDir);
			return strPath;
		}else
			return "";
	}else
	{
		if(::GetSaveFileName(&ofn))
		{
			CString strPath = szFile;	
			//SetCurrentDirectory(OldDir);
			return strPath;
		}else
			return "";
	}
}
