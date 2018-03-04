#if !defined(AFX_WAVEFORMAT_H__87983897_ED9E_4739_AF67_9845459D1C38__INCLUDED_)
#define AFX_WAVEFORMAT_H__87983897_ED9E_4739_AF67_9845459D1C38__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// WaveFormat.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CWaveFormat dialog
#include "Briwaveformat.h"

class CWaveFormat : public CDialog
{
// Construction
public:
	CWaveFormat(CWnd* pParent = NULL);   // standard constructor
	long	AppendWaveData(short *pWaveData,long lSamples);
// Dialog Data
	//{{AFX_DATA(CWaveFormat)
	enum { IDD = IDD_WAVEFORMAT_DIALOG };
	CStatic	m_cMaxValue;
	CButton	m_Cancel;
	CBriWaveFormat	m_cWaveFormat;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CWaveFormat)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CWaveFormat)
	virtual void OnCancel();
	virtual BOOL OnInitDialog();
	afx_msg void OnSize(UINT nType, int cx, int cy);
	afx_msg void OnResetmax();
	afx_msg void OnPause();
	afx_msg void OnResume();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	void	ResizeWindow();
	void	UpdateMax(short shMax,short shMaxA);
	short	m_shMax,m_shMaxA;
	BOOL	m_bPause;
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_WAVEFORMAT_H__87983897_ED9E_4739_AF67_9845459D1C38__INCLUDED_)
