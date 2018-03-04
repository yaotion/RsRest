#include "stdafx.h"
#include "BriStringLib.h"


char*	BS_GetModulePath(char *szModulePath,int iLen)
{
	::GetModuleFileName(NULL,szModulePath,iLen);       
	*(strrchr(szModulePath, '\\') + 1) = '\0'; 	
	return szModulePath;
}

char*	BS_GetFileName(char *pFilePath)
{
	if(!pFilePath) return pFilePath;
	char *p=strrchr(pFilePath,'\\');
	if(p) return p+1;
	else return pFilePath;
}

char* BS_GetFileExtName(char *pFilePath)
{
	if(!pFilePath) return NULL;
	return strrchr(pFilePath,'.');
}

char*	BS_GetFilePath(char *pFilePath)
{
	if(!pFilePath) return pFilePath;
	char *p=strrchr(pFilePath,'\\');
	if(p) *(p+1)='\0';
	return pFilePath;
}
BOOL	BS_IsFileExists(char *pFilePath)
{
	WIN32_FIND_DATA FindFileData={0};
	HANDLE hSearch=::FindFirstFile(pFilePath,&FindFileData);
	if(hSearch != INVALID_HANDLE_VALUE)
	{
		::FindClose(hSearch);
		return TRUE;
	}else
		return FALSE;
}

long	BS_GetModuleFilePathEx(HINSTANCE hModuleInst,char *pFile,char *pFilePath,unsigned int iMaxLen)
{
	if(!pFile || strlen(pFile) <= 0 || strlen(pFile) > iMaxLen)
		return 0;
	memset(pFilePath,0,iMaxLen);
	if(strlen(pFile) > 2 &&\
		((pFile[0] == '\\' && pFile[1] == '\\') \
		|| pFile[1] == ':'))
	{
	}else
	{
		::GetModuleFileName(hModuleInst,pFilePath,iMaxLen);       
		*(strrchr(pFilePath, '\\') + 1) = '\0'; 
	}
	if(strlen(pFilePath) + strlen(pFile) > iMaxLen) 
	{
		strcpy(pFilePath,pFile);
	}else
	{
		strcat(pFilePath,pFile);
	}
	return strlen(pFilePath);
}
long	BS_GetModuleFilePath(char *pFile,char *pFilePath,unsigned int iMaxLen)
{
	return BS_GetModuleFilePathEx(NULL,pFile,pFilePath,iMaxLen);
}
//c:\\aa\\bb\\"最后一个必须使用\结束
//c:\\aa\\bb\\a.wav" = c:\\aa\\bb\\"
//\\192.168.0.1\\a
BOOL	BS_MakeSureDirectoryExists(char *pFilePath)
{
	if(!pFilePath || strlen(pFilePath) < 6) return FALSE;
	else if(pFilePath[0] != '\\' && pFilePath[1] != ':') return FALSE;
	else if(pFilePath[0] != '\\' && pFilePath[2] != '\\') return FALSE;
	char *p=pFilePath+3;
	char ch;
	while((p=strchr(p,'\\')) != NULL)
	{
		p++;
		ch=p[0];
		*p='\0';			
		if(!CreateDirectory(pFilePath,NULL) && GetLastError() != ERROR_ALREADY_EXISTS) return FALSE;
		*p=ch;
	}
	return TRUE;
}

long	BS_Replace(char* in,int iLen,unsigned char chDem,unsigned char chDest)
{
	for(int j=0;j<(int)iLen;j++)
	{
		if(in[j] == chDem)
		{
			in[j] = chDest;			
		}
	}
	return iLen;
}

long	BS_SplitMsg(char** out, int count, char* in, int len,BOOL bDelNULL)
{
	int i = 0;
	int n = 0;
	if(!in) return 0;
	while (len > 0)
	{
		out[i++] = in;
		if (i > count)
			break;
		n = strlen(in)+1;
		in+=n;
		len-=n;	
		if(bDelNULL && out[i-1][0] == 0) i--;//丢弃连续的分隔'\0'
	}
	return i;
}

long	BS_SplitMsgEx(char** out, int count, char* in, int len,unsigned char chDem,BOOL bDelNULL)
{
	int i = 0;
	int n = 0;
	if(!in) return 0;
	if(chDem != 0)
	{
		BS_Replace(in,len,chDem,0);
	}
	return BS_SplitMsg(out,count,in,len,bDelNULL);
}