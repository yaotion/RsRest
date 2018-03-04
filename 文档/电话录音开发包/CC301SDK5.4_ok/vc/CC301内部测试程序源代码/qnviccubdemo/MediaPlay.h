#if !defined(AFX_MEDIAPLAY_H__FEA20F1D_BF16_4605_813F_0690C73E3C5E__INCLUDED_)
#define AFX_MEDIAPLAY_H__FEA20F1D_BF16_4605_813F_0690C73E3C5E__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// MediaPlay.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CMediaPlay dialog

class CMediaPlay : public CDialog
{
// Construction
public:
	CMediaPlay(CWnd* pParent = NULL);   // standard constructor
	BRIINT16	m_nChannelID;
// Dialog Data
	//{{AFX_DATA(CMediaPlay)
	enum { IDD = IDD_MEDIAPLAY_DIALOG };
	CStatic	m_cTotalPlay;
	CStatic	m_cTotalLen;
	CButton	m_cOpenFile;
	CSliderCtrl	m_cPlaySlider;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CMediaPlay)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CMediaPlay)
	afx_msg void OnOpenfile();
	virtual BOOL OnInitDialog();
	afx_msg void OnStop();
	afx_msg void OnPause();
	afx_msg void OnResume();
	afx_msg void OnDestroy();
	afx_msg void OnRemotefile();
	afx_msg void OnReleasedcapturePlayslider(NMHDR* pNMHDR, LRESULT* pResult);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	BOOL	StartPlayTimer();
	void	StopPlayTimer();

	BOOL	StartPlayFile(CString strFilePath);

	void	ShowTotalLen();
private:
	long	m_lPlayFileHandle;
	UINT	m_uPlayTimer;
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_MEDIAPLAY_H__FEA20F1D_BF16_4605_813F_0690C73E3C5E__INCLUDED_)
