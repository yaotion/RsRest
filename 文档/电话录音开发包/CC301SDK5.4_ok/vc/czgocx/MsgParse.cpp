#include "stdafx.h"
#include "msgparse.h"

CMsgParse::CMsgParse()
{
}

CMsgParse::~CMsgParse()
{
}

CMsgParse::CMsgParse(CString strMsg)
{
	int iText=strMsg.Find(MSG_TEXT_SPLIT);
	if(iText >= 0)//切分参数和消息正文
	{
		m_strParamText=strMsg.Left(iText);
		m_strMsgText=strMsg.Right(strMsg.GetLength() - iText - strlen(MSG_TEXT_SPLIT));
	}else
	{
		//AfxMessageBox("没有分隔符号");
	}
}

//获取消息格式中的数据
CString CMsgParse::GetMsgParam(CString strMsg,CString strParamName)
{
	CString strRet;
	int iPos=strMsg.Find(strParamName);
	if(iPos >= 0) 
	{
		int iEnd=strMsg.Find(MSG_KEY_SPLIT,iPos+strParamName.GetLength());
		if(iEnd > iPos)
		{
			strRet = strMsg.Mid(iPos+strParamName.GetLength(),iEnd - iPos - strParamName.GetLength());
		}else
			strRet = strMsg.Mid(iPos+strParamName.GetLength());
	}
	return strRet;
}


CString CMsgParse::GetParam(LPCTSTR lpParam)
{
	return GetMsgParam(m_strParamText,lpParam);
}
