// MediaplayBuf.cpp : implementation file
//

#include "stdafx.h"
#include "qnviccubdemo.h"
#include "MediaplayBuf.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CMediaplayBuf dialog


CMediaplayBuf::CMediaplayBuf(CWnd* pParent /*=NULL*/)
	: CDialog(CMediaplayBuf::IDD, pParent)
{
	//{{AFX_DATA_INIT(CMediaplayBuf)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	m_nChannelID= -1;
	m_lPlayBufHandle = -1;
}


void CMediaplayBuf::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CMediaplayBuf)
	DDX_Control(pDX, IDC_OPENFILE, m_cOpenFile);
	DDX_Control(pDX, IDC_STOPBUF, m_cStopBuf);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CMediaplayBuf, CDialog)
	//{{AFX_MSG_MAP(CMediaplayBuf)
	ON_BN_CLICKED(IDC_OPENFILE, OnOpenfile)
	ON_BN_CLICKED(IDC_STOPBUF, OnStopbuf)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CMediaplayBuf message handlers


BOOL CMediaplayBuf::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CMediaplayBuf::OnCancel() 
{
	StopPlayBuf();
	CDialog::OnCancel();
}
//写入缓冲数据
long	CMediaplayBuf::WriteBuf()
{
	DWORD dwLen=0;
	if(m_WaveFile.m_hFile != (UINT)CFile::hFileNull)
	{
		char szBuf[256];//使用自动分析文件头方式,读取的长度不能少与wave文件头长度
		DWORD dwReadLen=0;
		while(QNV_PlayBuf(m_nChannelID,QNV_PLAY_BUF_FREESIZE,m_lPlayBufHandle,0,NULL) > 256)//检测有足够的缓冲，保证读取后可以被写入
		{
			dwReadLen=m_WaveFile.Read(szBuf,256);
			if(dwReadLen == 0)
			{
				TRACE("read end.....\r\n");
				m_WaveFile.Close();
				break;
			}
			dwLen+=dwReadLen;
			if(QNV_PlayBuf(m_nChannelID,QNV_PLAY_BUF_WRITEDATA,m_lPlayBufHandle,dwReadLen,szBuf) <= 0)
			{
				AfxMessageBox("写入缓冲数据失败");
			}
		}
		//TRACE("write buf len=%d \r\n",dwLen);
	}
	return 0;
}
//线程回调,跟OnOpenfile的WriteBuf()输入初始化数据时,临界时可能同时进行文件读取，二引起m_WaveFile.m_hFile防问冲突
//方法一：加锁
//方法二：在OnOpenfile的WriteBuf()时暂停播放，避免回调
//方法三：在OnOpenfile的WriteBuf()时先不设置回调
//方法四：....
//本例子使用方法二和方法三都使用
long WINAPI CMediaplayBuf::PlayBufCallback(BRIINT16 uChannelID,BRIUINT32 dwUserData,BRIINT32 lHandle,BRIINT32 lDataSize,BRIINT32 lFreeSize)
{
	CMediaplayBuf *p=(CMediaplayBuf*)dwUserData;
	//TRACE("freesize=%d datasize=%d tick=%d\r\n",lFreeSize,lDataSize,GetTickCount());
	if(lDataSize == 0 && p->m_WaveFile.m_hFile == (UINT)CFile::hFileNull)//缓冲没有数据了，并且文件已经读完关闭了，就表示文件已经播放完毕
	{
		TRACE("播放缓冲结束 .....\r\n");
		p->OnStopbuf();
		AfxMessageBox("文件语音数据全部播放完毕");
	}else if(lFreeSize > 0 && lFreeSize >= lDataSize)//如果空闲字节有一半以上就开始继续写入lFreeSize + lDataSize为所有缓冲的长度
		p->WriteBuf();//有足够的空闲就写入数据	
	return 0;
}

void CMediaplayBuf::OnOpenfile() 
{
	CString strFilePath=((CQnviccubdemoApp*)AfxGetApp())->SelectFilePath(1);
	if(!strFilePath.IsEmpty())
	{
		StopPlayBuf();//先停止正在播放的
		if(!m_WaveFile.Open(strFilePath,CFile::modeRead,NULL))
		{
			AfxMessageBox("打开文件失败");
		}else
		{
			//SOUND_CHANNELID
			m_cStopBuf.EnableWindow(TRUE);
			m_cOpenFile.EnableWindow(FALSE);
			m_lPlayBufHandle=QNV_PlayBuf(m_nChannelID,QNV_PLAY_BUF_START,0,0,NULL);	//使用默认wave格式播放		
			QNV_PlayBuf(m_nChannelID,QNV_PLAY_BUF_SETWAVEFORMAT,m_lPlayBufHandle,-1,(char*)NULL);//默认方式可能不匹配实际文件的格式，设置为NULL表示使用数据开始的Buf自动解析获取wave文件头格式					
			QNV_PlayBuf(m_nChannelID,QNV_PLAY_BUF_PAUSE,m_lPlayBufHandle,0,0);//先不播放，等初始化写入数据
			WriteBuf();//立即写入语音数据
			QNV_PlayBuf(m_nChannelID,QNV_PLAY_BUF_SETCALLBACK,m_lPlayBufHandle,(long)this,(char*)PlayBufCallback);//允许开始回调
			QNV_PlayBuf(m_nChannelID,QNV_PLAY_BUF_RESUME,m_lPlayBufHandle,0,0);//开始播放		
			TRACE("init end ............\r\n");
		}
	}
}

long CMediaplayBuf::StopPlayBuf()
{
	if(m_lPlayBufHandle != -1)
	{
		QNV_PlayBuf(m_nChannelID,QNV_PLAY_BUF_STOP,m_lPlayBufHandle,0,NULL);
		m_lPlayBufHandle = -1;
	}
	if(m_WaveFile.m_hFile != (UINT)CFile::hFileNull)
	{
		m_WaveFile.Close();//关闭文件
		TRACE("close end.....\r\n");
	}
	return 0;
}

void CMediaplayBuf::OnStopbuf() 
{
	StopPlayBuf();
	m_cStopBuf.EnableWindow(FALSE);
	m_cOpenFile.EnableWindow(TRUE);	
}
