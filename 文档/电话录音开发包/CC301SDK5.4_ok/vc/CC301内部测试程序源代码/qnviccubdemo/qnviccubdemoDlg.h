// qnviccubdemoDlg.h : header file
//

#if !defined(AFX_QNVICCUBDEMODLG_H__8D2B6B38_2003_420E_B1CD_44A29D87C0BB__INCLUDED_)
#define AFX_QNVICCUBDEMODLG_H__8D2B6B38_2003_420E_B1CD_44A29D87C0BB__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CQnviccubdemoDlg dialog
#include <afxtempl.h>
#include "ChannelCtrl.h"
#include "Mediaplay.h"
#include "Tools.h"
#include "Remote.h"
#include "conference.h"
#include "ccmodule.h"
#include "Broadcast.h"
#include "RecvBroad.h"
#include "SocketClient.h"
#include "CheckLine.h"

class CQnviccubdemoDlg : public CDialog
{
// Construction
public:
	CQnviccubdemoDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CQnviccubdemoDlg)
	enum { IDD = IDD_QNVICCUBDEMO_DIALOG };
	CEdit	m_cDevStatus;
	CButton	m_cStseap2;
	CButton	m_cancel;
	CStatic	m_cStSeap;
	CStatic	m_cChipType;
	CButton	m_closedev;
	CButton	m_opendev;
	CComboBox	m_cChannelList;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CQnviccubdemoDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	virtual BOOL OnCommand(WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CQnviccubdemoDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnOpendev();
	afx_msg void OnClosedev();
	afx_msg void OnDestroy();
	afx_msg void OnSelchangeChannellist();
	afx_msg void OnSize(UINT nType, int cx, int cy);
	afx_msg void OnOpenremote();
	virtual void OnCancel();

	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	long	SelectChannel(BRIINT16 chID);
	void	DeleteAllChannelCtrl();
	void	ResizeWindow();
	void	AppendStatus(CString strStatus);
	void	InitDevInfo();

	CString GetModulePath();
	CString GetModule(BRIINT16 chID);
	CString GetDevType(long lDevType);

	long	CheckLineState();
	
	static UINT	WINAPI TestThread(VOID *pParam);
private:
	BOOL	CreateConference();
	void	CloseConference();
	void	CreateCCModule();
	void	CloseCCModule();
	void	CreateBroadcast();
	void	CloseBroadcast();
	void	CreateRecvBroad();
	void	CloseRecvBroad();

	CConference	*m_pConference;
	CCCModule	*m_pCCModule;
	CBroadcast  *m_pBroadcast;
	CRecvBroad	*m_pRecvBroad;
private:
	CArray<CChannelCtrl*,CChannelCtrl*> m_ChannelCtrlArray;	
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_QNVICCUBDEMODLG_H__8D2B6B38_2003_420E_B1CD_44A29D87C0BB__INCLUDED_)
