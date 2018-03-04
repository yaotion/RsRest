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
	m_strSpeechContent = _T("小王,小张,小明,久久,大哥,爸爸,妈妈,大嫂,0,1,2,3,4,5,6,7,8,9");
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
	
	//接收事件消息
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
		AfxMessageBox("该通道不是电话机内线，不能进行内线识别");
		return ;
	}

	if(!(QNV_DevInfo(m_nChannelID,QNV_DEVINFO_GETMODULE) & DEVMODULE_SWITCH))
	{
		AfxMessageBox("该通道不能断开电话机，不能进行内线识别");
		return ;
	}

	UpdateData(TRUE);
	if(m_strSpeechContent.IsEmpty())
	{
		AfxMessageBox("识别内容不能为空");
		return;
	}
	AppendResult("请拿起话机说列表中的单词进行识别...");
	//断开电话机
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_DOPHONE,0);
	//选择采集线路的语音
//	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_SELECTADCIN,ADCIN_ID_LINE);	
	//选择使用电话机断开后后话柄录音
//	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_SELECTLINEIN,LINEIN_ID_2);	
	
	QNV_Speech(m_nChannelID,QNV_SPEECH_CONTENTLIST,0,(char*)(LPCTSTR)m_strSpeechContent);
	if(QNV_Speech(m_nChannelID,QNV_SPEECH_STARTSPEECH,0,NULL) <= 0) AfxMessageBox("启动语音识别失败");
}

void CSpeech::OnStartspeeche() 
{	
	UpdateData(TRUE);
	//
	AppendResult("请接通PSTN线路,拿起话通话后说列表中的单词进行识别...");
	//接通电话机
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_DOPHONE,1);
	//选择采集线路的语音
//	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_SELECTADCIN,ADCIN_ID_LINE);	
	//软摘机,提升对方的音量
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_DOHOOK,1);	
	//选择使用软摘机通道录音
//	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_SELECTLINEIN,LINEIN_ID_1);
	
	QNV_Speech(m_nChannelID,QNV_SPEECH_CONTENTLIST,0,(char*)(LPCTSTR)m_strSpeechContent);
	if(QNV_Speech(m_nChannelID,QNV_SPEECH_STARTSPEECH,0,NULL) <= 0)  AfxMessageBox("启动语音识别失败");
}

void CSpeech::OnStartspeechmic() 
{	
	UpdateData(TRUE);
	AppendResult("请把MIC插入到USB盒子并拿起MIC说列表中的单词进行识别...");	
	//选择采集MIC的语音
	QNV_SetDevCtrl(m_nChannelID,QNV_CTRL_SELECTADCIN,ADCIN_ID_MIC);	
	//
	QNV_Speech(m_nChannelID,QNV_SPEECH_CONTENTLIST,0,(char*)(LPCTSTR)m_strSpeechContent);
	if(QNV_Speech(m_nChannelID,QNV_SPEECH_STARTSPEECH,0,NULL) <= 0)  AfxMessageBox("启动语音识别失败");
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
				str.Format("通道%d: 语音识别结束 lResult=%d szData=%s",m_nChannelID+1,lResult,pEvent->szData);
				AppendResult((char*)(LPCTSTR)str);
				if(lResult == SPEECH_DEV)
				{
					//重新开始识别
					if(QNV_Speech(m_nChannelID,QNV_SPEECH_STARTSPEECH,0,NULL) <= 0) 
					{
						AfxMessageBox("启动语音识别失败");
					}else
					{
						AppendResult("重新开始识别...");
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
	//该值越大，需要说的普通话精确度越高，误识别的机会就越小
	//建议设置在50-90
	QNV_SetParam(m_nChannelID,QNV_PARAM_SPEECHTHRESHOLD,m_nThreshold);
}

void CSpeech::OnSetsilenceam() 
{
	UpdateData(TRUE);
	//该值越大，识别前对外界环境的干扰越不明显，但同时需要识别着的语音超过该幅度
	//建议设置在256-4096
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
			AfxMessageBox("识别错误");
		}else if(lRet == 0)
		{
			AfxMessageBox("识别结果错误");
		}
		else
		{
			//识别到到结果了回调事件
		}
	}
}

void CSpeech::OnSetgender() 
{
	int icursel=m_gender.GetCurSel();	
	if(icursel >= 0)
	{//icursel:0->2
		QNV_SetParam(m_nChannelID,QNV_PARAM_SPEECHGENDER,icursel+1);//1->男,2->女,3->自动
	}else
	{
		AfxMessageBox("请选择性别");
	}
}
