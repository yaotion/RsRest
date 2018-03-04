// Speech.cpp : implementation file
//

#include "stdafx.h"
#include "qnviccubdemo.h"
#include "Speech.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CSpeech dialog


CSpeech::CSpeech(CWnd* pParent /*=NULL*/)
	: CDialog(CSpeech::IDD, pParent)
{
	//{{AFX_DATA_INIT(CSpeech)
	m_strSpeechContent = _T("С��,С��,С��,�þ�,���,�ְ�,����,��ɩ,0,1,2,3,4,5,6,7,8,9");
	m_strSpeechResult = _T("");
	m_nThreshold = 50;
	m_nSilenceAM = 256;
	m_igender = 2;
	//}}AFX_DATA_INIT
	m_nChannelID=-1;
}


void CSpeech::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CSpeech)
	DDX_Control(pDX, IDC_GENDER, m_gender);
	DDX_Control(pDX, IDC_SILENCEAM, m_cSilenceAM);
	DDX_Control(pDX, IDC_THRESHOLD, m_cThreshold);
	DDX_Control(pDX, IDC_SPEECHRESULT, m_cSpeechResult);
	DDX_Control(pDX, IDC_SPEECHCONTENT, m_cSpeechContent);
	DDX_Text(pDX, IDC_SPEECHCONTENT, m_strSpeechContent);
	DDX_Text(pDX, IDC_SPEECHRESULT, m_strSpeechResult);
	DDX_Text(pDX, IDC_THRESHOLD, m_nThreshold);
	DDV_MinMaxUInt(pDX, m_nThreshold, 1, 100);
	DDX_Text(pDX, IDC_SILENCEAM, m_nSilenceAM);
	DDV_MinMaxUInt(pDX, m_nSilenceAM, 1, 32767);
	DDX_CBIndex(pDX, IDC_GENDER, m_igender);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CSpeech, CDialog)
	//{{AFX_MSG_MAP(CSpeech)
	ON_BN_CLICKED(IDC_STARTSPEECHI, OnStartspeechi)
	ON_BN_CLICKED(IDC_STARTSPEECHE, OnStartspeeche)
	ON_BN_CLICKED(IDC_STARTSPEECHMIC, OnStartspeechmic)
	ON_BN_CLICKED(IDC_STOPSPEECH, OnStopspeech)
	ON_WM_DESTROY()
	ON_BN_CLICKED(IDC_SETTHRESHOLD, OnSetthreshold)
	ON_BN_CLICKED(IDC_SETSILENCEAM, OnSetsilenceam)
	ON_BN_CLICKED(IDC_STARTFILESPEECH, OnStartfilespeech)
	ON_BN_CLICKED(IDC_SETGENDER, OnSetgender)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CSpeech message handlers

BOOL CSpeech::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	//�����¼���Ϣ
	QNV_Event(m_nChannelID,QNV_EVENT_REGWND,(DWORD)m_hWnd,NULL,NULL,0);
	m_nThreshold = QNV_GetParam(m_nChannelID,QNV_PARAM_SPEECHTHRESHOLD);
	m_nSilenceAM = QNV_GetParam(m_nChannelID,QNV_PARAM_SPEECHSILENCEAM);
	UpdateData(FALSE);

	if(QNV_DevInfo(m_nChannelID,QNV_DEVINFO_GETCHANNELTYPE) == CHANNELTYPE_PHONE)
	{
		GetDlgItem(IDC_STARTSPEECHI)->EnableWindow(TRUE);
		GetDlgItem(IDC_STARTSPEECHE)->EnableWindow(FALSE);
	}else
	{
		GetDlgItem(IDC_STARTSPEECHI)->EnableWindow(FALSE);
		GetDlgItem(IDC_STARTSPEECHE)->EnableWindow(TRUE);
	}

	if(!(QNV_DevInfo(m_nChannelID,QNV_DEVINFO_GETMODULE) & DEVMODULE_SWITCH))
	{
		GetDlgItem(IDC_STARTSPEECHI)->EnableWindow(FALSE);
	}
	m_gender.SetCurSel(QNV_GetParam(m_nChannelID,QNV_PARAM_SPEECHGENDER)-1);
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CSpeech::OnStartspeechi() 
{
	if(QNV_DevInfo(m_nChannelID,QNV_DEVINFO_GETCHANNELTYPE) != CHANNELTYPE_PHONE)
	{
		AfxMessageBox("��ͨ�����ǵ绰�����ߣ����ܽ�������ʶ��");
		return ;
	}

	if(!(QNV_DevInfo(m_nChannelID,QNV_DEVINFO_GETMODULE) & DEVMODULE_SWITCH))
	{
		AfxMessageBox("��ͨ�����ܶϿ��绰�������ܽ�������ʶ��");
		return ;
	}

	UpdateData(TRUE);
	if(m_strSpeechContent.IsEmpty())
	{
		AfxMessageBox("ʶ�����ݲ���Ϊ��");
		return;
	}
	AppendResult("�����𻰻�˵�б��еĵ��ʽ���ʶ��...");
	//�Ͽ��绰��
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_DOPHONE,0);
	//ѡ��ɼ���·������
//	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_SELECTADCIN,ADCIN_ID_LINE);	
	//ѡ��ʹ�õ绰���Ͽ���󻰱�¼��
//	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_SELECTLINEIN,LINEIN_ID_2);	
	
	QNV_Speech(m_nChannelID,QNV_SPEECH_CONTENTLIST,0,(char*)(LPCTSTR)m_strSpeechContent);
	if(QNV_Speech(m_nChannelID,QNV_SPEECH_STARTSPEECH,0,NULL) <= 0) AfxMessageBox("��������ʶ��ʧ��");
}

void CSpeech::OnStartspeeche() 
{	
	UpdateData(TRUE);
	//
	AppendResult("���ͨPSTN��·,����ͨ����˵�б��еĵ��ʽ���ʶ��...");
	//��ͨ�绰��
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_DOPHONE,1);
	//ѡ��ɼ���·������
//	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_SELECTADCIN,ADCIN_ID_LINE);	
	//��ժ��,�����Է�������
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_DOHOOK,1);	
	//ѡ��ʹ����ժ��ͨ��¼��
//	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_SELECTLINEIN,LINEIN_ID_1);
	
	QNV_Speech(m_nChannelID,QNV_SPEECH_CONTENTLIST,0,(char*)(LPCTSTR)m_strSpeechContent);
	if(QNV_Speech(m_nChannelID,QNV_SPEECH_STARTSPEECH,0,NULL) <= 0)  AfxMessageBox("��������ʶ��ʧ��");
}

void CSpeech::OnStartspeechmic() 
{	
	UpdateData(TRUE);
	AppendResult("���MIC���뵽USB���Ӳ�����MIC˵�б��еĵ��ʽ���ʶ��...");	
	//ѡ��ɼ�MIC������
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_SELECTADCIN,ADCIN_ID_MIC);	
	//
	QNV_Speech(m_nChannelID,QNV_SPEECH_CONTENTLIST,0,(char*)(LPCTSTR)m_strSpeechContent);
	if(QNV_Speech(m_nChannelID,QNV_SPEECH_STARTSPEECH,0,NULL) <= 0)  AfxMessageBox("��������ʶ��ʧ��");
}

void CSpeech::OnStopspeech() 
{
	QNV_Speech(m_nChannelID,QNV_SPEECH_STOPSPEECH,0,NULL);	
}

void CSpeech::OnCancel() 
{	
	CDialog::OnCancel();
}

void CSpeech::AppendResult(char *pBuf)
{
	CString strBuf;
	CTime ct=CTime::GetCurrentTime();
	strBuf.Format("%02d:%02d:%02d %s",ct.GetHour(),ct.GetMinute(),ct.GetSecond(),pBuf);
	CString str;
	m_cSpeechResult.GetWindowText(str);
	str=strBuf+"\r\n"+str+"\r\n";
	m_cSpeechResult.SetWindowText(str);
}

void CSpeech::OnDestroy() 
{
	QNV_Event(m_nChannelID,QNV_EVENT_UNREGWND,(DWORD)m_hWnd,NULL,NULL,0);
	CDialog::OnDestroy();	
}

LRESULT CSpeech::WindowProc(UINT message, WPARAM wParam, LPARAM lParam)
{
	if(message == BRI_EVENT_MESSAGE)
	{
		PBRI_EVENT pEvent=(PBRI_EVENT)lParam;
		long lResult=pEvent->lResult;
		CString str;
		switch(pEvent->lEventType)
		{
		case BriEvent_SpeechResult:
			{
				str.Format("ͨ��%d: ����ʶ����� lResult=%d szData=%s",m_nChannelID+1,lResult,pEvent->szData);
				AppendResult((char*)(LPCTSTR)str);
				if(lResult == SPEECH_DEV)
				{
					//���¿�ʼʶ��
					if(QNV_Speech(m_nChannelID,QNV_SPEECH_STARTSPEECH,0,NULL) <= 0) 
					{
						AfxMessageBox("��������ʶ��ʧ��");
					}else
					{
						AppendResult("���¿�ʼʶ��...");
					}
				}
			}break;
		default:break;
		}
	}
	return CDialog::WindowProc(message, wParam, lParam);
}

void CSpeech::OnSetthreshold() 
{
	UpdateData(TRUE);
	//��ֵԽ����Ҫ˵����ͨ����ȷ��Խ�ߣ���ʶ��Ļ����ԽС
	//����������50-90
	QNV_SetParam(m_nChannelID,QNV_PARAM_SPEECHTHRESHOLD,m_nThreshold);
}

void CSpeech::OnSetsilenceam() 
{
	UpdateData(TRUE);
	//��ֵԽ��ʶ��ǰ����绷���ĸ���Խ�����ԣ���ͬʱ��Ҫʶ���ŵ����������÷���
	//����������256-4096
	QNV_SetParam(m_nChannelID,QNV_PARAM_SPEECHSILENCEAM,m_nSilenceAM);	
}

void CSpeech::OnStartfilespeech() 
{
	UpdateData(TRUE);
	QNV_Speech(m_nChannelID,QNV_SPEECH_CONTENTLIST,0,(char*)(LPCTSTR)m_strSpeechContent);
	CString strFilePath=((CQnviccubdemoApp*)AfxGetApp())->SelectFilePath(1);
	if(!strFilePath.IsEmpty())
	{
		long lRet=QNV_Speech(m_nChannelID,QNV_SPEECH_STARTSPEECHFILE,0,(char*)(LPCTSTR)strFilePath);
		if(lRet < 0)
		{
			AfxMessageBox("ʶ�����");
		}else if(lRet == 0)
		{
			AfxMessageBox("ʶ��������");
		}
		else
		{
			//ʶ�𵽵�����˻ص��¼�
		}
	}
}

void CSpeech::OnSetgender() 
{
	int icursel=m_gender.GetCurSel();	
	if(icursel >= 0)
	{//icursel:0->2
		QNV_SetParam(m_nChannelID,QNV_PARAM_SPEECHGENDER,icursel+1);//1->��,2->Ů,3->�Զ�
	}else
	{
		AfxMessageBox("��ѡ���Ա�");
	}
}
