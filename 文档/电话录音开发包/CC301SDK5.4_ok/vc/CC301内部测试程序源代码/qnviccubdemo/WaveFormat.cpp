// WaveFormat.cpp : implementation file
//

#include "stdafx.h"
#include "qnviccubdemo.h"
#include "WaveFormat.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CWaveFormat dialog


CWaveFormat::CWaveFormat(CWnd* pParent /*=NULL*/)
	: CDialog(CWaveFormat::IDD, pParent)
{
	//{{AFX_DATA_INIT(CWaveFormat)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	m_shMax = 0;
	m_shMaxA = 0;
	m_bPause = FALSE;
}


void CWaveFormat::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CWaveFormat)
	DDX_Control(pDX, IDC_STMAXVALUE, m_cMaxValue);
	DDX_Control(pDX, IDCANCEL, m_Cancel);
	DDX_Control(pDX, IDC_WAVEFORMAT, m_cWaveFormat);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CWaveFormat, CDialog)
	//{{AFX_MSG_MAP(CWaveFormat)
	ON_WM_SIZE()
	ON_BN_CLICKED(IDC_RESETMAX, OnResetmax)
	ON_BN_CLICKED(IDC_PAUSE, OnPause)
	ON_BN_CLICKED(IDC_RESUME, OnResume)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CWaveFormat message handlers

BOOL CWaveFormat::OnInitDialog() 
{
	CDialog::OnInitDialog();	
	ResizeWindow();
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CWaveFormat::OnCancel() 
{
	ShowWindow(SW_HIDE);
	//CDialog::OnCancel();
}

long	CWaveFormat::AppendWaveData(short *pWaveData,long lSamples)
{
	if(m_bPause) return 0;
	m_cWaveFormat.AppendWave(pWaveData,lSamples);
	short shMax=m_cWaveFormat.GetMax();
	short shMaxA=m_cWaveFormat.GetMaxA();
	if(shMax != m_shMax || shMaxA != m_shMaxA)
	{
		UpdateMax(shMax,shMaxA);
	}
	return 0;
}

void	CWaveFormat::UpdateMax(short shMax,short shMaxA)
{
	CString str;
	str.Format("%d/%d",shMax,shMaxA);
	m_cMaxValue.SetWindowText(str);
	m_shMax = shMax;
	m_shMaxA = shMaxA;
}

void CWaveFormat::OnSize(UINT nType, int cx, int cy) 
{
	CDialog::OnSize(nType, cx, cy);
	ResizeWindow();
}

void	CWaveFormat::ResizeWindow()
{
	if(m_cWaveFormat.m_hWnd && ::IsWindow(m_cWaveFormat.m_hWnd))
	{
		CRect rc;
		GetClientRect(&rc);
		m_cWaveFormat.SetWindowPos(NULL,0,0,rc.Width(),rc.Height()-25,NULL);
		m_cWaveFormat.ReInitView();
		m_Cancel.SetWindowPos(NULL,rc.right - 65,rc.bottom - 22,63,22,NULL);
		((CButton*)GetDlgItem(IDC_STMAX))->SetWindowPos(NULL,2,rc.bottom - 20,0,0,SWP_NOSIZE);
		((CButton*)GetDlgItem(IDC_STMAXVALUE))->SetWindowPos(NULL,32,rc.bottom - 20,0,0,SWP_NOSIZE);
		((CButton*)GetDlgItem(IDC_RESETMAX))->SetWindowPos(NULL,112,rc.bottom - 23,0,0,SWP_NOSIZE);
		((CButton*)GetDlgItem(IDC_PAUSE))->SetWindowPos(NULL,182,rc.bottom - 23,0,0,SWP_NOSIZE);		
		((CButton*)GetDlgItem(IDC_RESUME))->SetWindowPos(NULL,262,rc.bottom - 23,0,0,SWP_NOSIZE);
	}
}

void CWaveFormat::OnResetmax() 
{
	m_cWaveFormat.ResetMax();	
	UpdateMax(0,0);
}

void CWaveFormat::OnPause() 
{
	m_bPause = TRUE;
	
}

void CWaveFormat::OnResume() 
{
	m_bPause = FALSE;
}
