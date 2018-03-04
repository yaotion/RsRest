#if !defined(AFX_BRIWAVEFORMAT_H__B8A86298_0DCB_4EEA_8114_CB7C7B8C5DBE__INCLUDED_)
#define AFX_BRIWAVEFORMAT_H__B8A86298_0DCB_4EEA_8114_CB7C7B8C5DBE__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// BriWaveFormat.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CBriWaveFormat window
#define		_UP_SAMPLES_		310

class CBriWaveFormat : public CStatic
{
// Construction
public:
	CBriWaveFormat();
	long	AppendWave(short *pWaveData,long lSamples);
	void	ReInitView();
	void	ResetMax(){m_shMax = 0;m_shMaxA = 0;}
	short	GetMax(){return m_shMax;}
	short	GetMaxA(){return m_shMaxA;}
// Attributes
public:

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CBriWaveFormat)
	protected:
	virtual void PreSubclassWindow();
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual ~CBriWaveFormat();

	// Generated message map functions
protected:
	//{{AFX_MSG(CBriWaveFormat)
	afx_msg void OnPaint();
	afx_msg void OnDestroy();
	afx_msg void OnTimer(UINT nIDEvent);
	afx_msg BOOL OnEraseBkgnd(CDC* pDC);
	//}}AFX_MSG

	DECLARE_MESSAGE_MAP()
private:
	CRect   m_crc;
	CDC     m_MemDC;
	CBrush  m_bkBrush,m_PeakBrush;
	DWORD	m_dwRightLine;
	long	m_lMiddley;
	int		m_iprecx,m_iprecy;
	CPen	m_pen;
	short	m_shMax,m_shMaxA;

	short	m_shSampesData[_UP_SAMPLES_*2];
	long	m_lCurSamples;
private:
	BOOL	DrawHorLine(CDC* pDC,CRect *pRect,int iHight,COLORREF clrLine);
	BOOL	DrawVerLine(CDC* pDC,CRect *pRect,int iWidth,COLORREF clrLine);
	void	InitView();
	void	FreeSource();
	void	UpdataWaveData(short *pWaveData,long lSamples);

};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_BRIWAVEFORMAT_H__B8A86298_0DCB_4EEA_8114_CB7C7B8C5DBE__INCLUDED_)
