#ifndef __BRIFAXUI_H__
#define __BRIFAXUI_H__


#ifndef WIN32
#define BRIFAXUIFUNC
#else
#define BRIFAXUIFUNC WINAPI
#endif


enum{

	TTIP_AUTORECV=0x0,
	TTIP_AUTOCANCEL=0x1
};

enum
{
	RECVF_NULL=0x0,
	RECVF_AUTOCLOSE=0x1
};

enum
{
	FAX_RECV=0x0,	
	FAX_SEND=0x1
};

enum
{
	FAX_RESULT_FAILED=0x0,
	FAX_RESULT_OK=0x1,
	FAX_RESULT_CANCEL=0x2
};

#ifdef __cplusplus
extern "C" {
#endif

long	BRIFAXUIFUNC BFU_StartRecvFax(short nChannelID,LPCTSTR szFilePath,long lType);
long	BRIFAXUIFUNC BFU_StopRecvFax(short nChannelID);

long	BRIFAXUIFUNC BFU_StartSendFax(short nChannelID,LPCTSTR szFilePath,long lType);
long	BRIFAXUIFUNC BFU_StopSendFax(short nChannelID);

long	BRIFAXUIFUNC BFU_FaxLog(LPCTSTR lpCode,long lType);

long	BRIFAXUIFUNC BFU_FaxTooltip(short nChannelID,LPCTSTR lpCode,long lType);
long	BRIFAXUIFUNC BFU_CloseFaxTooltip(short nChannelID);

long	BRIFAXUIFUNC BFU_FreeSource();
long	BRIFAXUIFUNC BFU_CloseFaxLog();

#ifdef __cplusplus
}
#endif

#endif