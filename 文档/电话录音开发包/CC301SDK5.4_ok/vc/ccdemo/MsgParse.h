#ifndef __MSGPARSE_H__
#define __MSGPARSE_H__


class	CMsgParse
{
public:
	CMsgParse();
	CMsgParse(CString strMsg);
	virtual ~CMsgParse();
public:
	CString GetParam(LPCTSTR lpParam);
	CString GetParamText(){return m_strParamText;}
	CString	GetMsgText(){return m_strMsgText;}
private:
	CString GetMsgParam(CString strMsg,CString strParamName);
private:
	CString m_strParamText;
	CString m_strMsgText;
	
};

#endif