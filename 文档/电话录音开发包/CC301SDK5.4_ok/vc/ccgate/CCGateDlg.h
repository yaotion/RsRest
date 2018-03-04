// CCGateDlg.h : header file
//

#if !defined(AFX_CCGATEDLG_H__DA08B470_2BC4_4CCF_B0B8_96915C7503FF__INCLUDED_)
#define AFX_CCGATEDLG_H__DA08B470_2BC4_4CCF_B0B8_96915C7503FF__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CCCGateDlg dialog

typedef struct	tag_Gate_Data
{
	short uChannelID;//�豸ͨ��

	char szCC[32];//CC����
	long lCCHandle;//CC���о��

}GATE_DATA,*PGATE_DATA;

class CCCGateDlg : public CDialog
{
// Construction
public:
	CCCGateDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CCCGateDlg)
	enum { IDD = IDD_CCGATE_DIALOG };
	CEdit	m_cDestCC;
	CEdit	m_cGateStatus;
	CString	m_strDestCC;
	CString	m_strGateStatus;
	CString	m_strServer;
	CString	m_strCC;
	CString	m_strPwd;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CCCGateDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CCCGateDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnSetserver();
	afx_msg void OnLogon();
	afx_msg void OnLogout();
	afx_msg void OnDestroy();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	void	AppendStatus(CString strStatus);
	long	OpenDev();
	long	CloseDev();

	long	StartCallCC(PBRI_EVENT pEvent);
private:
	GATE_DATA	m_tagGateData[MAX_CHANNEL_COUNT];

private:
	long	GetCCHandleGateID(long lCCHandle);//��ȡCC���о�����ڵ����ݽṹID(m_tagGateData)

	long	StopCallCC(short uChannelID);//ֹͣת�Ƶ���CC
	long	StopChannel(long lCCHandle);//CC����ֹͣ���Ͽ�ͨ��PSTN��·
	long	AnswerCCHandle(long lCCHandle);//CC��ͨ��ͬʱ��ͨPSTN
	long	AnswerChannel(short uChannelID);//��ͨPSTN
private:
	long	AcceptCCCallIn(PBRI_EVENT pEvent);//Ӧ��CC����
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CCGATEDLG_H__DA08B470_2BC4_4CCF_B0B8_96915C7503FF__INCLUDED_)
