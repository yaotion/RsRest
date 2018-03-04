#ifndef __BRISTRINGLIB_H__
#define __BRISTRINGLIB_H__

#include <malloc.h>


#define	BRI_LTOA(x)	_ltoa((x), (char*)alloca(12), 10)

char*	BS_GetModulePath(char *szModulePath,int iLen);
long	BS_GetModuleFilePath(char *pFile,char *pFilePath,unsigned int iMaxLen);
long	BS_GetModuleFilePathEx(HINSTANCE hModuleInst,char *pFile,char *pFilePath,unsigned int iMaxLen);
char*	BS_GetFileName(char *pFilePath);
char*	BS_GetFileExtName(char *pFilePath);
char*	BS_GetFilePath(char *pFilePath);
BOOL	BS_MakeSureDirectoryExists(char *pFilePath);
BOOL	BS_IsFileExists(char *pFilePath);
long	BS_SplitMsg(char** out, int count, char* in, int len,BOOL bDelNULL);
long	BS_SplitMsgEx(char** out, int count, char* in, int len,unsigned char chDem,BOOL bDelNULL);
long	BS_Replace(char* in,int iLen,unsigned char chDem,unsigned char chDest);

#endif