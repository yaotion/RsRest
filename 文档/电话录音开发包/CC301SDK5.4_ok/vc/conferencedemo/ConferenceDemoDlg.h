// ConferenceDemoDlg.h : header file
//

#if !defined(AFX_CONFERENCEDEMODLG_H__662CFB54_DE68_4674_8A8D_730845458FA7__INCLUDED_)
#define AFX_CONFERENCEDEMODLG_H__662CFB54_DE68_4674_8A8D_730845458FA7__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CConferenceDemoDlg dialog
#include "CreateConf.h"

class CConferenceDemoDlg : public CDialog
{
// Construction
public:
	CConferenceDemoDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CConferenceDemoDlg)
	enum { IDD = IDD_CONFERENCEDEMO_DIALOG };
	CComboBox	m_cSelectLine;
	CEdit	m_cMicVolume;
	CEdit	m_cSpkVolume;
	CButton	m_cAdBusy;
	CButton	m_cDisableSpk;
	CButton	m_cDisableMic;
	CListBox	m_cChannelList;
	CButton	m_cDoPhone;
	CListCtrl	m_cConfList;
	CComboBox	m_cComboChannel;
	CButton	m_cDoHook;
	CString	m_strDialCode;
	int		m_nSpkVolume;
	int		m_nMicVolume;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CConferenceDemoDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CConferenceDemoDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnDestroy();
	afx_msg void OnCreateconf();
	afx_msg void OnDial();
	afx_msg void OnDohook();
	afx_msg void OnItemchangedConflist(NMHDR* pNMHDR, LRESULT* pResult);
	afx_msg void OnDophone();
	afx_msg void OnDelconf();
	afx_msg void OnStartrec();
	afx_msg void OnStoprec();
	afx_msg void OnDisablemic();
	afx_msg void OnDisablespk();
	afx_msg void OnPause();
	afx_msg void OnResume();
	afx_msg void OnSetvolume();
	afx_msg void OnAdbusy();
	afx_msg void OnSelchangeChannellist();
	afx_msg void OnSelchangeCombochannel();
	afx_msg void OnSelchangeSelectline();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	long	OpenDev();
	long	CloseDev();
	void	AppendStatus(CString strStatus);

	long	GetSelectConf();

	BRIINT16	GetSelectedChannelID();
private:
	long	ShowConfChannelList(long lConfID,CString strChannelList);
	int		_StringSplit(const CString &str, CStringArray &arr, TCHAR chDelimitior);
	long	m_lCurSelConfID;
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CONFERENCEDEMODLG_H__662CFB54_DE68_4674_8A8D_730845458FA7__INCLUDED_)
