//{{AFX_INCLUDES()
#include "qnvfiletransfer.h"
//}}AFX_INCLUDES
#if !defined(AFX_FILETRANSFER_H__93362F43_35F2_4699_92D8_C38E24370926__INCLUDED_)
#define AFX_FILETRANSFER_H__93362F43_35F2_4699_92D8_C38E24370926__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// FileTransfer.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CFileTransfer dialog

class CFileTransfer : public CDialog
{
// Construction
public:
	CFileTransfer(CWnd* pParent = NULL);   // standard constructor
	void	FreeSource();
	long	TransferFinished();
	Cqnvfiletransfer*	GetFiletransfer(){return m_pfiletransfer;}
	//endRecvFileRequest(Owner()->szVID,file,size,dwDestVer,dwTransSign,sid,m_wLanguage);
	long	RecvFileRequest(long lHandle,LPCTSTR lpCC,LPCTSTR lpFile,DWORD dwSize);
// Dialog Data
	//{{AFX_DATA(CFileTransfer)
	enum { IDD = IDD_FILETRANSFER_DIALOG };
	CEdit	m_cFilePath;
	CString	m_strDestCC;
	CString	m_strFilePath;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CFileTransfer)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CFileTransfer)
	afx_msg void OnSelectfile();
	afx_msg void OnStartsend();
	afx_msg void OnStopsend();
	virtual BOOL OnInitDialog();
	afx_msg void OnDestroy();
	virtual void OnCancel();
	afx_msg void OnRecvfile();
	afx_msg void OnStoprecv();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	BOOL	CreateTransfer();
	BOOL	CloseTransfer();
	Cqnvfiletransfer	*m_pfiletransfer;
	long	m_lTransHandle;
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_FILETRANSFER_H__93362F43_35F2_4699_92D8_C38E24370926__INCLUDED_)
