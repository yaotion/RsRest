#if !defined(AFX_FAXTOOLTIP_H__2B80ED54_89AD_4585_AF99_F8E045ECE4F1__INCLUDED_)
#define AFX_FAXTOOLTIP_H__2B80ED54_89AD_4585_AF99_F8E045ECE4F1__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// FaxTooltip.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CFaxTooltip dialog
#include "BriFaxBase.h"

enum
{
	FT_NULLFAX=0x0,
	FT_ACCEPTFAX=0x1,
	FT_CANCELFAX=0x2
};

class CFaxTooltip : public CDialog , public CBriFaxBase
{
// Construction
public:
	CFaxTooltip(CWnd* pParent = NULL);   // standard constructor
	void	FreeSource();
	void	SetType(long lType){m_lType = lType;}
// Dialog Data
	//{{AFX_DATA(CFaxTooltip)
	enum { IDD = IDD_FAXTOOLTIP_DIALOG };
	CButton	m_OK;
	CButton	m_Cancel;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CFaxTooltip)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CFaxTooltip)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	virtual void OnCancel();
	afx_msg void OnTimer(UINT nIDEvent);
	afx_msg void OnDestroy();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	UINT	m_nTimer;
	long	m_lElapseTick;
	long	m_lType;
private:
	void	CloseTimer();

};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_FAXTOOLTIP_H__2B80ED54_89AD_4585_AF99_F8E045ECE4F1__INCLUDED_)
