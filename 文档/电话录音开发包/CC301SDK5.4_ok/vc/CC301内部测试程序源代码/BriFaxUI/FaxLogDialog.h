#if !defined(AFX_FAXLOGDIALOG_H__871B002A_932E_4F5E_9AC9_9F0245D269A8__INCLUDED_)
#define AFX_FAXLOGDIALOG_H__871B002A_932E_4F5E_9AC9_9F0245D269A8__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// FaxLogDialog.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CFaxLogDialog dialog
#include "resource.h"
#include <iostream.h>
#include "BriFaxBase.h"


#define			COUNT_PER_PAGE			60

class CFaxLogDialog : public CDialog,public CBriFaxBase
{
// Construction
public:
	CFaxLogDialog(CWnd* pParent = NULL);   // standard constructor
	void	FreeSource();
// Dialog Data
	//{{AFX_DATA(CFaxLogDialog)
	enum { IDD = IDD_FAXLOG_DIALOG };
	CStatic	m_cStPage;
	CButton	m_cPrev;
	CButton	m_cNext;
	CButton	m_cLast;
	CButton	m_cFirst;
	CListCtrl	m_cFaxLogList;
	CTime	m_cBeginDate;
	CTime	m_cEndDate;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CFaxLogDialog)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CFaxLogDialog)
	afx_msg void OnSearch();
	virtual BOOL OnInitDialog();
	virtual void OnCancel();
	afx_msg void OnSize(UINT nType, int cx, int cy);
	afx_msg void OnDblclkFaxloglist(NMHDR* pNMHDR, LRESULT* pResult);
	afx_msg void OnFirst();
	afx_msg void OnPrev();
	afx_msg void OnNext();
	afx_msg void OnLast();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	long	m_lCoumnCount;
	CStringArray	m_strLogArray;
	long	m_lCurPage;
	long	m_lTotalPage;
private:
	void	InitList();
	CString	GetLogFile();
	istream & getline(istream & is, CString & str);
	long	AppendLog(int iSeek,CString strLog);

	long	GetFileType(char *pFilePath);
private:
	BOOL	ListLog(long lBeginTime,long lEndTime);
	long	ShowLog(int iPage);
	void	ResizeWindow();

};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_FAXLOGDIALOG_H__871B002A_932E_4F5E_9AC9_9F0245D269A8__INCLUDED_)
