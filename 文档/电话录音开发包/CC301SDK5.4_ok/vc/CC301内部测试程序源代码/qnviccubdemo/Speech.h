#if !defined(AFX_SPEECH_H__03F6A495_5613_4FC2_B30B_2EED0D18208C__INCLUDED_)
#define AFX_SPEECH_H__03F6A495_5613_4FC2_B30B_2EED0D18208C__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// Speech.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CSpeech dialog

class CSpeech : public CDialog
{
// Construction
public:
	CSpeech(CWnd* pParent = NULL);   // standard constructor
	BRIINT16	m_nChannelID;
// Dialog Data
	//{{AFX_DATA(CSpeech)
	enum { IDD = IDD_SPEECH_DIALOG };
	CComboBox	m_gender;
	CEdit	m_cSilenceAM;
	CEdit	m_cThreshold;
	CEdit	m_cSpeechResult;
	CEdit	m_cSpeechContent;
	CString	m_strSpeechContent;
	CString	m_strSpeechResult;
	UINT	m_nThreshold;
	UINT	m_nSilenceAM;
	int		m_igender;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CSpeech)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CSpeech)
	virtual BOOL OnInitDialog();
	afx_msg void OnStartspeechi();
	afx_msg void OnStartspeeche();
	afx_msg void OnStartspeechmic();
	afx_msg void OnStopspeech();
	virtual void OnCancel();
	afx_msg void OnDestroy();
	afx_msg void OnSetthreshold();
	afx_msg void OnSetsilenceam();
	afx_msg void OnStartfilespeech();
	afx_msg void OnSetgender();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	void AppendResult(char *pBuf);
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_SPEECH_H__03F6A495_5613_4FC2_B30B_2EED0D18208C__INCLUDED_)
