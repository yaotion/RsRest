// BriWaveFormat.cpp : implementation file
//

#include "stdafx.h"
#include "BriWaveFormat.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif


#define		UNIT_SEEK		1//每次移动N个像素
#define		UNIT_LINECOLOR	RGB(0,120,0)

#define		UNIT_PEAKCOLOR	RGB(0,255,0)

#define		UNIT_ZEROCOLOR	RGB(255,0,0)

#define		MAX_PEAK		32767
#define		MIN_PEAK		-32767

#define		PEAK_CX			1

/////////////////////////////////////////////////////////////////////////////
// CBriWaveFormat

CBriWaveFormat::CBriWaveFormat()
{
	m_shMax = 0;
	m_shMaxA= 0;
	m_dwRightLine =0;
	m_iprecx=m_iprecy=0;
	m_lCurSamples= 0;
}

CBriWaveFormat::~CBriWaveFormat()
{
}


BEGIN_MESSAGE_MAP(CBriWaveFormat, CStatic)
	//{{AFX_MSG_MAP(CBriWaveFormat)
	ON_WM_PAINT()
	ON_WM_DESTROY()
	ON_WM_TIMER()
	ON_WM_ERASEBKGND()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CBriWaveFormat message handlers

long	CBriWaveFormat::AppendWave(short *pWaveData,long lSamples)
{	
	if(!::IsWindowVisible(m_hWnd) || ::IsIconic(m_hWnd)) return -1;
	ASSERT(m_lCurSamples + lSamples < _UP_SAMPLES_*2);
	memcpy(&m_shSampesData[m_lCurSamples],(void*)pWaveData,lSamples*sizeof(short));
	m_lCurSamples += lSamples;
	if(m_lCurSamples + lSamples >= _UP_SAMPLES_ || m_lCurSamples + lSamples >= ((m_crc.Width() - lSamples)/PEAK_CX))
	{
		UpdataWaveData(m_shSampesData,m_lCurSamples);
		m_lCurSamples = 0;
		return 1;
	}else return 0;	
}

void	CBriWaveFormat::UpdataWaveData(short *pWaveData,long lSamples)
{
	long lSeekPix=lSamples*PEAK_CX;
	m_MemDC.BitBlt(0,0,m_crc.Width(),m_crc.Height(),&m_MemDC,lSeekPix,0,SRCCOPY);
	int icx=m_crc.Width() - lSeekPix;	
	int icy=0;
	if(m_iprecx > 0) m_MemDC.MoveTo(m_iprecx-lSeekPix,m_iprecy);
	for(int i=0;i<lSamples;i++)
	{
		if(pWaveData[i] > m_shMax)  m_shMax = pWaveData[i];
		else if(pWaveData[i] < m_shMaxA) m_shMaxA = pWaveData[i];

		icy=m_lMiddley-pWaveData[i]*m_lMiddley/MAX_PEAK;		
		m_MemDC.LineTo(icx,icy);
		icx+=PEAK_CX;
	}
	m_iprecx=icx - PEAK_CX;
	m_iprecy=icy;
	Invalidate();
}

void CBriWaveFormat::OnPaint() 
{
	CPaintDC dc(this); // device context for painting

	dc.BitBlt(0,0,m_crc.Width(),m_crc.Height(),&m_MemDC,0,0,SRCCOPY);
	
	// Do not call CStatic::OnPaint() for painting messages
}

void CBriWaveFormat::OnDestroy() 
{
	m_MemDC.DeleteDC();
	CStatic::OnDestroy();	
}

void CBriWaveFormat::OnTimer(UINT nIDEvent) 
{	
	CStatic::OnTimer(nIDEvent);
}

void CBriWaveFormat::PreSubclassWindow() 
{
	CStatic::PreSubclassWindow();
	InitView();
}

BOOL CBriWaveFormat::DrawVerLine(CDC* pDC,CRect *pRect,int iWidth,COLORREF clrLine)
{
	int iSeek=0;
	while(iSeek <= pRect->Width()*2)
	{
		m_dwRightLine=pRect->left+iSeek;
		pDC->FillSolidRect(m_dwRightLine,pRect->top,1,pRect->Height(),clrLine);
		iSeek+=iWidth;
	}
	return TRUE;
}

BOOL CBriWaveFormat::DrawHorLine(CDC* pDC,CRect *pRect,int iHight,COLORREF clrLine)
{
	int iSeek=0;
	m_lMiddley=pRect->Height()/2;
	pDC->FillSolidRect(pRect->left,m_lMiddley,pRect->Width(),1,UNIT_ZEROCOLOR);
	int iHeigth=pRect->Height()/14;
	iSeek = m_lMiddley+iHeigth;
	for(int i=0;i<6;i++)
	{
		pDC->FillSolidRect(pRect->left,iSeek,pRect->Width()*2,1,clrLine);
		iSeek+=iHeigth;
	}

	iSeek = m_lMiddley-iHeigth;
	for(i=0;i<6;i++)
	{
		pDC->FillSolidRect(pRect->left,iSeek,pRect->Width()*2,1,clrLine);
		iSeek-=iHeigth;
	}
	return TRUE;
}

void	CBriWaveFormat::FreeSource()
{
	m_MemDC.DeleteDC();
	m_bkBrush.DeleteObject();
	m_PeakBrush.DeleteObject();
	m_pen.DeleteObject();
}

void	CBriWaveFormat::ReInitView()
{	
	FreeSource();
	InitView();
}

void	CBriWaveFormat::InitView()
{
	GetClientRect(&m_crc);
	CPaintDC dc(this); // device context for painting	
	if(!m_MemDC.GetSafeHdc())
	{
		m_MemDC.CreateCompatibleDC(&dc);	
	}
	m_bkBrush.CreateSolidBrush(RGB(0,0,0));
	m_PeakBrush.CreateSolidBrush(RGB(255,0,0));
	CBitmap bmp;
	CBitmap*	pOldBitmap = NULL;

	bmp.CreateCompatibleBitmap(&dc,m_crc.Width()*2,m_crc.Height());
	pOldBitmap = m_MemDC.SelectObject(&bmp);
	CRect bkcrc=m_crc;
	bkcrc.right+=m_crc.Width();
	m_MemDC.FillRect(&bkcrc,&m_bkBrush);

	DrawVerLine(&m_MemDC,&m_crc,m_crc.Height()/14,UNIT_LINECOLOR);
	//画所有横的
	DrawHorLine(&m_MemDC,&bkcrc,0,UNIT_LINECOLOR);

	m_pen.CreatePen(PS_SOLID,1,UNIT_PEAKCOLOR);
	m_MemDC.SelectObject(&m_pen);

	m_MemDC.MoveTo(0,m_lMiddley);

}

BOOL CBriWaveFormat::OnEraseBkgnd(CDC* pDC) 
{	
	return TRUE;
	//return CStatic::OnEraseBkgnd(pDC);
}
