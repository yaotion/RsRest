// ccdemoDlg.h : header file
//

#if !defined(AFX_CCDEMODLG_H__4CB6594F_7BEB_455F_A6F4_B30C68D0DF47__INCLUDED_)
#define AFX_CCDEMODLG_H__4CB6594F_7BEB_455F_A6F4_B30C68D0DF47__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CCcdemoDlg dialog
#include "CCMsg.h"
#include "CCCmd.h"
#include "Logincc.h"
#include "RegCC.h"
#include "CCCall.h"
#include "inputSvrIP.h"
#include "inputcc.h"
#include "Filetrans.h"
#include "Sendfile.h"
#include "recvfile.h"

class CCcdemoDlg : public CDialog
{
// Construction
public:
	CCcdemoDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CCcdemoDlg)
	enum { IDD = IDD_CCDEMO_DIALOG };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CCcdemoDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	virtual BOOL OnCommand(WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CCcdemoDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnDestroy();
	virtual void OnCancel();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	CString	GetModulePath();
	long	InitCCModule();
	void	AppendStatus(CString strStatus);
	BOOL	CreateCCMsg();
	BOOL	CloseCCMsg();
	BOOL	CreateCCCmd();
	BOOL	CloseCCCmd();
	BOOL	CreateCCCall();
	BOOL	CloseCCCall();
	BOOL	CreateFileTrans();
	BOOL	CloseFileTrans();

	long	SetSvrAddr();

	long	ShowEvent(PBRI_EVENT pEvent);
private:
	CCCMsg		*m_pCCMsg;
	CCCCmd		*m_pCCCmd;
	CCCCall		*m_pCCCall;
	CFileTrans  *m_pFileTrans;
private:
	static BRIINT32 WINAPI CallbackEvent(BRIINT16 uChannelID,BRIUINT32 dwUserData,BRIINT32 lType,BRIINT32 lHandle,BRIINT32 lResult,BRIINT32 lParam,BRIPCHAR8 pData,BRIPCHAR8 pDataEx);
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CCDEMODLG_H__4CB6594F_7BEB_455F_A6F4_B30C68D0DF47__INCLUDED_)
