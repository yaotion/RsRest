#if !defined(AFX_FILETRANS_H__BC412CAA_CA91_4AE0_A405_7F3FEB6C17A4__INCLUDED_)
#define AFX_FILETRANS_H__BC412CAA_CA91_4AE0_A405_7F3FEB6C17A4__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// FileTrans.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CFileTrans dialog
#include "qnvfiletransfer1.h"

class CFileTrans : public CDialog
{
// Construction
public:
	void FreeSource();
	CFileTrans(CWnd* pParent = NULL);   // standard constructor
	
	long	AppendRecvFile(DWORD dwHandle,CString  strData);
	long	StartSendFile(LPCTSTR lpCC,LPCTSTR lpFilePath);

// Dialog Data
	//{{AFX_DATA(CFileTrans)
	enum { IDD = IDD_FILETRANS_DIALOG };
	CListCtrl	m_FileList;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CFileTrans)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CFileTrans)
	virtual BOOL OnInitDialog();
	afx_msg void OnStop();
	virtual void OnCancel();
	afx_msg void OnShowwin();
	afx_msg void OnHidewin();
	afx_msg void OnSave();
	afx_msg void OnRefusefile();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	Cqnvfiletransfer1*	CreateTransferOCX();
	long	InitList();
	CString GetMsgParam(CString strData,CString strParamName);
	void	AppendStatus(CString strStatus);

	long	AppendFileList(LPCTSTR lpCC,LPCTSTR lpNick,LPCTSTR lpTransType,LPCTSTR lpState,LPCTSTR lpFileName,__int64 i64FileSize,LPCTSTR lpLocalPath,Cqnvfiletransfer1 *p);

	long	GetFirstSelectedItem();

	CString GetSaveFilePath(LPCTSTR lpFileName);

	int		GetHandleItem(DWORD dwHandle);

	long	DeleteTransItem(int L);
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_FILETRANS_H__BC412CAA_CA91_4AE0_A405_7F3FEB6C17A4__INCLUDED_)
