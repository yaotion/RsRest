#ifndef __BRIWND_H__
#define __BRIWND_H__


class	CBriWnd
{
public:
	CBriWnd();
	virtual ~CBriWnd();
public:
	BOOL	Create();
	HWND	GetSafeHwnd(){return m_hWnd;}
	virtual void	SetCBWndAndID(HWND hWnd,DWORD dwMsgID){m_hCBWnd=hWnd;m_dwMsgID=dwMsgID;}
protected:
	virtual void	StopTimer(UINT &nTimer){if(nTimer) {::KillTimer(m_hWnd,nTimer);nTimer=NULL;}}	
	virtual LRESULT WindowProc(UINT msg, WPARAM wParam, LPARAM lParam);
	virtual LRESULT SendCBMsg(WPARAM wParam,LPARAM lParam){return ::SendMessage(m_hCBWnd,m_dwMsgID,wParam,lParam);}
	virtual LRESULT PostCBMsg(WPARAM wParam,LPARAM lParam){return ::PostMessage(m_hCBWnd,m_dwMsgID,wParam,lParam);}
private:
	static LRESULT CALLBACK MsgWndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam);
protected:
	HWND	m_hWnd;
	HWND	m_hCBWnd;
	DWORD	m_dwMsgID;
};

#endif