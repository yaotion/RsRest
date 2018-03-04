#if !defined(AFX_MEDIAPLAYBUF_H__7CFC02A1_03D9_4A84_B3D4_7F2169E105BD__INCLUDED_)
#define AFX_MEDIAPLAYBUF_H__7CFC02A1_03D9_4A84_B3D4_7F2169E105BD__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// MediaplayBuf.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CMediaplayBuf dialog

class CMediaplayBuf : public CDialog
{
// Construction
public:
	CMediaplayBuf(CWnd* pParent = NULL);   // standard constructor
	BRIINT16	m_nChannelID;
// Dialog Data
	//{{AFX_DATA(CMediaplayBuf)
	enum { IDD = IDD_MEDIAPLAYBUF_DIALOG };
	CButton	m_cOpenFile;
	CButton	m_cStopBuf;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CMediaplayBuf)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CMediaplayBuf)
	virtual void OnCancel();
	virtual BOOL OnInitDialog();
	afx_msg void OnOpenfile();
	afx_msg void OnStopbuf();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	long	m_lPlayBufHandle;
	static long WINAPI PlayBufCallback(BRIINT16 uChannelID,BRIUINT32 dwUserData,BRIINT32 lHandle,BRIINT32 lDataSize,BRIINT32 lFreeSize);
	long	WriteBuf();
private:
	long	StopPlayBuf();
	CFile	m_WaveFile;
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_MEDIAPLAYBUF_H__7CFC02A1_03D9_4A84_B3D4_7F2169E105BD__INCLUDED_)
