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
//д�뻺������
long	CMediaplayBuf::WriteBuf()
{
	DWORD dwLen=0;
	if(m_WaveFile.m_hFile != (UINT)CFile::hFileNull)
	{
		char szBuf[256];//ʹ���Զ������ļ�ͷ��ʽ,��ȡ�ĳ��Ȳ�������wave�ļ�ͷ����
		DWORD dwReadLen=0;
		while(QNV_PlayBuf(m_nChannelID,QNV_PLAY_BUF_FREESIZE,m_lPlayBufHandle,0,NULL) > 256)//������㹻�Ļ��壬��֤��ȡ����Ա�д��
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
				AfxMessageBox("д�뻺������ʧ��");
			}
		}
		//TRACE("write buf len=%d \r\n",dwLen);
	}
	return 0;
}
//�̻߳ص�,��OnOpenfile��WriteBuf()�����ʼ������ʱ,�ٽ�ʱ����ͬʱ�����ļ���ȡ��������m_WaveFile.m_hFile���ʳ�ͻ
//����һ������
//����������OnOpenfile��WriteBuf()ʱ��ͣ���ţ�����ص�
//����������OnOpenfile��WriteBuf()ʱ�Ȳ����ûص�
//�����ģ�....
//������ʹ�÷������ͷ�������ʹ��
long WINAPI CMediaplayBuf::PlayBufCallback(BRIINT16 uChannelID,BRIUINT32 dwUserData,BRIINT32 lHandle,BRIINT32 lDataSize,BRIINT32 lFreeSize)
{
	CMediaplayBuf *p=(CMediaplayBuf*)dwUserData;
	//TRACE("freesize=%d datasize=%d tick=%d\r\n",lFreeSize,lDataSize,GetTickCount());
	if(lDataSize == 0 && p->m_WaveFile.m_hFile == (UINT)CFile::hFileNull)//����û�������ˣ������ļ��Ѿ�����ر��ˣ��ͱ�ʾ�ļ��Ѿ��������
	{
		TRACE("���Ż������ .....\r\n");
		p->OnStopbuf();
		AfxMessageBox("�ļ���������ȫ���������");
	}else if(lFreeSize > 0 && lFreeSize >= lDataSize)//��������ֽ���һ�����ϾͿ�ʼ����д��lFreeSize + lDataSizeΪ���л���ĳ���
		p->WriteBuf();//���㹻�Ŀ��о�д������	
	return 0;
}

void CMediaplayBuf::OnOpenfile() 
{
	CString strFilePath=((CQnviccubdemoApp*)AfxGetApp())->SelectFilePath(1);
	if(!strFilePath.IsEmpty())
	{
		StopPlayBuf();//��ֹͣ���ڲ��ŵ�
		if(!m_WaveFile.Open(strFilePath,CFile::modeRead,NULL))
		{
			AfxMessageBox("���ļ�ʧ��");
		}else
		{
			//SOUND_CHANNELID
			m_cStopBuf.EnableWindow(TRUE);
			m_cOpenFile.EnableWindow(FALSE);
			m_lPlayBufHandle=QNV_PlayBuf(m_nChannelID,QNV_PLAY_BUF_START,0,0,NULL);	//ʹ��Ĭ��wave��ʽ����		
			QNV_PlayBuf(m_nChannelID,QNV_PLAY_BUF_SETWAVEFORMAT,m_lPlayBufHandle,-1,(char*)NULL);//Ĭ�Ϸ�ʽ���ܲ�ƥ��ʵ���ļ��ĸ�ʽ������ΪNULL��ʾʹ�����ݿ�ʼ��Buf�Զ�������ȡwave�ļ�ͷ��ʽ					
			QNV_PlayBuf(m_nChannelID,QNV_PLAY_BUF_PAUSE,m_lPlayBufHandle,0,0);//�Ȳ����ţ��ȳ�ʼ��д������
			WriteBuf();//����д����������
			QNV_PlayBuf(m_nChannelID,QNV_PLAY_BUF_SETCALLBACK,m_lPlayBufHandle,(long)this,(char*)PlayBufCallback);//����ʼ�ص�
			QNV_PlayBuf(m_nChannelID,QNV_PLAY_BUF_RESUME,m_lPlayBufHandle,0,0);//��ʼ����		
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
		m_WaveFile.Close();//�ر��ļ�
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
