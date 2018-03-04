#if !defined(AFX_CHANNELCTRL_H__90FAED21_4A2C_40F5_8E84_30AB8D7C1059__INCLUDED_)
#define AFX_CHANNELCTRL_H__90FAED21_4A2C_40F5_8E84_30AB8D7C1059__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// ChannelCtrl.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CChannelCtrl dialog
#include "WaveFormat.h"
#include "MediaplayBuf.h"
#include "FaxModule.h"
#include "InputTTS.h"
#include "SelectMultiFile.h"
#include "Speech.h"
#include "inputRemote.h"


#define		UPDATE_AM_MESSAGE	(WM_USER+10000)

class CChannelCtrl : public CDialog
{
// Construction
public:
	CChannelCtrl(CWnd* pParent = NULL);   // standard constructor
	void	SetChannelCtrlID(BRIINT16 nChannelID);
	void	FreeSource();
// Dialog Data
	//{{AFX_DATA(CChannelCtrl)
	enum { IDD = IDD_CHANNELCTRL_DIALOG };
	CButton	m_cAdfunc;
	CButton	m_cPlayRemote;
	CStatic	m_cBufAM;
	CButton	m_cStopPlayFile;
	CButton	m_cStartPlayFile;
	CButton	m_cStartRecFile;
	CButton	m_cStopRecFile;
	CButton	m_cStartRecBuf;
	CButton	m_cStopRecBuf;
	CButton	m_cViewBuf;
	CComboBox	m_cSelectLine;
	CComboBox	m_cLineInAM;
	CComboBox	m_cSpkAM;
	CComboBox	m_cMicAM;
	CComboBox	m_cLine3x;
	CComboBox	m_cADCIn;
	CString	m_strCode;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CChannelCtrl)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CChannelCtrl)	
	virtual BOOL OnInitDialog();
	afx_msg void OnStopplayfile();
	afx_msg void OnEnablehook();
	afx_msg void OnEnablemic();
	afx_msg void OnDisablering();
	afx_msg void OnEnablespk();
	afx_msg void OnStartrecfile();
	afx_msg void OnStoprecfile();
	afx_msg void OnStartdial();
	afx_msg void OnStopdial();
	afx_msg void OnMediaplay();
	afx_msg void OnEnableplay2spk();
	afx_msg void OnDoplay();
	afx_msg void OnStartmultiplay();
	afx_msg void OnStopmultiplay();
	afx_msg void OnInitttslist();
	afx_msg void OnPlay2line();
	afx_msg void OnSelchangeSelectline();
	afx_msg void OnSelchangeMicam();
	afx_msg void OnSelchangeSpkam();
	afx_msg void OnSelchangeLineinam();
	afx_msg void OnSelchangeComline3x();
	afx_msg void OnSelchangeAdcin();
	afx_msg void OnRingpower();
	afx_msg void OnStartbufrec();
	afx_msg void OnStoprecbuf();
	afx_msg void OnViewbuf();
	afx_msg void OnStartplayfile();
	afx_msg void OnStartplaybuf();
	afx_msg void OnFaxmodule();
	afx_msg void OnStartring();
	afx_msg void OnRefuse();
	afx_msg void OnFlash();
	afx_msg void OnPlaytts();
	afx_msg void OnStopplaytts();
	afx_msg void OnSpeech();
	afx_msg void OnBufechoed();
	afx_msg void OnPause();
	afx_msg void OnResume();
	afx_msg void OnLineout();	
	afx_msg void OnDisableecho();
	afx_msg void OnLed();
	afx_msg void OnWatchdog();
	afx_msg void On24v();
	afx_msg void OnSelchangeDoplaymux();
	afx_msg void OnSelchangeDoplayam();
	afx_msg void OnDisableupload();
	afx_msg void OnDisabldownload();
	afx_msg void OnSaveparam();
	afx_msg void OnReadparam();
	afx_msg void OnTimer(UINT nIDEvent);
	afx_msg void OnPlayremote();
	afx_msg void OnRecvfsk();
	afx_msg void OnRecvdtmf();
	afx_msg void OnRecvsign();
	afx_msg void OnCallin();
	afx_msg void OnSenddtmf();
	afx_msg void OnSendfsk();
	afx_msg void OnAdfunc();
	afx_msg void OnExclusive();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	long		m_lPlayFileHandle;
	long		m_lRecFileHandle;
	BRIINT16	m_nChannelID;
	CWaveFormat	*m_pWaveView;
	short		m_shBufMax;
	long		m_lBufTimes;
	long		m_lPlayStringHandle;
	CString		GetDevErrStr(long lResult);

	long		StartPlayFile(CString strFilePath);
private:
	void		InitChannelParam();
	void		CloseWaveView();
	long		AppendRecBuf(short *pWaveData,long lBufSize);
	CString		GetModulePath();
	long		WriteCallLog(USHORT uChannelID);

	long		ProcessEvent(PBRI_EVENT pEvent);
	UINT		m_nEventTimer;
private:
	static void CALLBACK TimerProc(HWND hwnd, UINT uMsg, UINT idEvent, DWORD dwTime );
	static DWORD WINAPI DialThreadProc(LPVOID lpParam);//测试在线程里拨号
	static long	WINAPI RecordBuf(BRIINT16 uChannelID,BRIUINT32 dwUserData,BRIBYTE8 *pBufData,BRIINT32 lBufSize);

	static BRIINT32	WINAPI ProcEventCallback(BRIINT16 uChannelID,BRIUINT32 dwUserData,BRIINT32	lType,BRIINT32 lHandle,BRIINT32 lResult,BRIINT32 lParam,BRIPCHAR8 pData,BRIPCHAR8 pDataEx);
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CHANNELCTRL_H__90FAED21_4A2C_40F5_8E84_30AB8D7C1059__INCLUDED_)
