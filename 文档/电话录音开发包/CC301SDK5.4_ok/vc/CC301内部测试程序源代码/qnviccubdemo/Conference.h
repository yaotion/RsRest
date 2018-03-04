#if !defined(AFX_CONFERENCE_H__3F59645E_6D8F_47F8_81F1_3DCBD75CFD4D__INCLUDED_)
#define AFX_CONFERENCE_H__3F59645E_6D8F_47F8_81F1_3DCBD75CFD4D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// Conference.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CConference dialog

class CConference : public CDialog
{
// Construction
public:
	CConference(CWnd* pParent = NULL);   // standard constructor
	BRIINT16  m_nChannelID;
	void	FreeSource();
// Dialog Data
	//{{AFX_DATA(CConference)
	enum { IDD = IDD_CONFERENCE_DIALOG };
	CEdit	m_cMicVolume;
	CButton	m_cResume;
	CButton	m_cPause;
	CButton	m_cDisableSpk;
	CButton	m_cDisableMic;
	CEdit	m_cVolume;
	CButton	m_cStopRec;
	CButton	m_cStartRec;
	CStatic		m_cStConfID;
	CListBox	m_cOutList;
	CListBox	m_cInList;
	UINT	m_nVolume;
	UINT	m_nMicVolume;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CConference)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CConference)
	virtual void OnCancel();
	virtual BOOL OnInitDialog();
	afx_msg void OnAdd();
	afx_msg void OnDel();
	afx_msg void OnDestroy();
	afx_msg void OnStartrec();
	afx_msg void OnStoprec();
	afx_msg void OnSetvolume();
	afx_msg void OnSelchangeInlist();
	afx_msg void OnPause();
	afx_msg void OnResume();
	afx_msg void OnDisablemic();
	afx_msg void OnDisablespk();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	BRIINT32	m_nConfID;
private:
	void		InitDevList();
	BRIINT16	GetChannelID(CString strText);
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CONFERENCE_H__3F59645E_6D8F_47F8_81F1_3DCBD75CFD4D__INCLUDED_)
