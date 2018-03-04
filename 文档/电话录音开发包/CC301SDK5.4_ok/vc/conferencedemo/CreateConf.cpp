// CreateConf.cpp : implementation file
//

#include "stdafx.h"
#include "ConferenceDemo.h"
#include "CreateConf.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CCreateConf dialog


CCreateConf::CCreateConf(CWnd* pParent /*=NULL*/)
	: CDialog(CCreateConf::IDD, pParent)
{
	//{{AFX_DATA_INIT(CCreateConf)
	m_strConfName = _T("����");
	//}}AFX_DATA_INIT
	m_lConfID= 0;
}


void CCreateConf::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CCreateConf)
	DDX_Control(pDX, IDC_CHANNELLIST, m_cChannelList);
	DDX_Text(pDX, IDC_CONFNAME, m_strConfName);
	DDV_MaxChars(pDX, m_strConfName, 128);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CCreateConf, CDialog)
	//{{AFX_MSG_MAP(CCreateConf)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CCreateConf message handlers

BOOL CCreateConf::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	m_cChannelList.SetExtendedStyle(LVS_EX_CHECKBOXES|LVS_EX_FULLROWSELECT|LVS_EX_GRIDLINES|m_cChannelList.GetExtendedStyle());
	m_cChannelList.InsertColumn(0,"ͨ����",LVCFMT_LEFT,200);
	CString str;
	for(BRIINT16 i=0;i<QNV_DevInfo(-1,QNV_DEVINFO_GETCHANNELS);i++)
	{
		str.Format("ͨ��%d",i+1);
		m_cChannelList.InsertItem(i,str,0);
	}
	m_cChannelList.InsertItem(i,"����ͨ��(256)",0);
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CCreateConf::OnOK() 
{
	UpdateData(TRUE);
	m_ChannelArray.RemoveAll();
	m_lConfID = QNV_Conference(-1,0,QNV_CONFERENCE_CREATE,0,NULL);	//����һ���ջ���
	if(m_lConfID <= 0)
	{
		AfxMessageBox("��������ʧ��");
		return;
	}
	for(int i=0;i<m_cChannelList.GetItemCount();i++)
	{
		if(m_cChannelList.GetCheck(i))
		{
			if(i == m_cChannelList.GetItemCount() - 1)//��������һ����Ϊ����ͨ��
			{
				//ʹ������ģ��ǰ����Ҫ������ͨ��
				//QNV_OpenDevice(ODT_SOUND,0,0)
				if(QNV_Conference(SOUND_CHANNELID,m_lConfID,QNV_CONFERENCE_ADDTOCONF,0,NULL) > 0)//��ͨ�����뵽������
				{
					TRACE("����ͨ�� %s \r\n",m_cChannelList.GetItemText(i,0));
					m_ChannelArray.Add(SOUND_CHANNELID);
				}else
				{
					AfxMessageBox("��ӻ���ͨ��ʧ��");
				}
			}else
			{
				if(QNV_Conference(i,m_lConfID,QNV_CONFERENCE_ADDTOCONF,0,NULL) > 0)//��ͨ�����뵽������
				{
					TRACE("����ͨ�� %s \r\n",m_cChannelList.GetItemText(i,0));
					m_ChannelArray.Add(i);
				}else
				{
					AfxMessageBox("��ӻ���ͨ��ʧ��");
				}
			}
		}
	}	
	if(m_ChannelArray.GetSize() == 0)
	{
		QNV_Conference(0,m_lConfID,QNV_CONFERENCE_DELETECONF,0,NULL);//ɾ������
		m_lConfID = 0;
		AfxMessageBox("��ѡ���ڻ����е�ͨ��");
	}else
	{
		CDialog::OnOK();
	}
}
