#include "stdafx.h"
#include "BriWnd.h"

CBriWnd::CBriWnd()
{//WS_CLIPCHILDREN|WS_CLIPSIBLINGS|WS_POPUP
	//HINSTANCE(::GetModuleHandle(0))
	m_hWnd=NULL;
	m_hCBWnd = NULL;
	m_dwMsgID = 0;
}

CBriWnd::~CBriWnd()
{
	if(m_hWnd)
	{
		DestroyWindow(m_hWnd);
		m_hWnd=NULL;
	}
}

BOOL	CBriWnd::Create()
{
	if(!m_hWnd)
	{
		m_hWnd=CreateWindowEx(0,"STATIC",TEXT(""),0,0,0,1,1,NULL,NULL,NULL,NULL);
		::SetWindowLong(m_hWnd, GWL_USERDATA, (long)this);	
		::SetWindowLong(m_hWnd, GWL_WNDPROC, (LONG)MsgWndProc);	
	}
	return m_hWnd!=NULL;
}

LRESULT CBriWnd::MsgWndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
	CBriWnd *p = (CBriWnd*)::GetWindowLong(hwnd, GWL_USERDATA);
	if(p)
	{
		LRESULT lResult=p->WindowProc(msg,wParam,lParam);
		if(lResult > 0) return lResult;
	}
	return ::DefWindowProc(hwnd, msg, wParam, lParam);
}

LRESULT CBriWnd::WindowProc(UINT msg, WPARAM wParam, LPARAM lParam)
{
	return 0;
}