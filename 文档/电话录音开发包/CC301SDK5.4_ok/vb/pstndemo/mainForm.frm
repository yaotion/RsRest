VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form mainform 
   Caption         =   "CC301�������ܿ�����ʾ 1.1"
   ClientHeight    =   9435
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   9405
   LinkTopic       =   "Form1"
   ScaleHeight     =   9435
   ScaleWidth      =   9405
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton ResumePlayFile 
      Caption         =   "�ָ�����"
      Height          =   615
      Left            =   3960
      TabIndex        =   36
      Top             =   5400
      Width           =   1095
   End
   Begin VB.CommandButton PausePlayFile 
      Caption         =   "��ͣ����"
      Height          =   615
      Left            =   2760
      TabIndex        =   35
      Top             =   5400
      Width           =   1095
   End
   Begin VB.CheckBox PhoneRing 
      Caption         =   "���߼������"
      Height          =   375
      Left            =   3480
      TabIndex        =   34
      Top             =   8160
      Width           =   1575
   End
   Begin MSComDlg.CommonDialog FileDialog 
      Left            =   8760
      Top             =   3120
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
      DefaultExt      =   ".wav"
      Filter          =   "wave files(*.wav)|*.wav|all files(*.*)|*.*"
   End
   Begin VB.Frame Frame4 
      Caption         =   "¼��"
      Height          =   1815
      Left            =   120
      TabIndex        =   26
      Top             =   6120
      Width           =   4935
      Begin VB.CommandButton ResumeRecFile 
         Caption         =   "�ָ�¼��"
         Height          =   495
         Left            =   3600
         TabIndex        =   38
         Top             =   1200
         Width           =   1095
      End
      Begin VB.CommandButton PauseRecFile 
         Caption         =   "��ͣ¼��"
         Height          =   495
         Left            =   2520
         TabIndex        =   37
         Top             =   1200
         Width           =   975
      End
      Begin VB.CommandButton StopRecFile 
         Caption         =   "ֹͣ¼��"
         Height          =   495
         Left            =   1440
         TabIndex        =   32
         Top             =   1200
         Width           =   975
      End
      Begin VB.CommandButton StartRecFile 
         Caption         =   "��ʼ¼��"
         Height          =   495
         Left            =   120
         TabIndex        =   31
         Top             =   1200
         Width           =   1095
      End
      Begin VB.CheckBox CheckAGC 
         Caption         =   "�Զ�����"
         Height          =   375
         Left            =   2520
         TabIndex        =   30
         Top             =   720
         Width           =   1215
      End
      Begin VB.CheckBox CheckEcho 
         Caption         =   "��������"
         Height          =   255
         Left            =   480
         TabIndex        =   29
         Top             =   720
         Width           =   1575
      End
      Begin VB.ComboBox ComboRecFormat 
         Height          =   315
         Left            =   1800
         TabIndex        =   28
         Top             =   360
         Width           =   2895
      End
      Begin VB.Label Label5 
         Caption         =   "�ļ�ѹ����ʽ��"
         Height          =   255
         Left            =   120
         TabIndex        =   27
         Top             =   360
         Width           =   1455
      End
   End
   Begin VB.ComboBox ComboChannel 
      Height          =   315
      ItemData        =   "mainForm.frx":0000
      Left            =   4800
      List            =   "mainForm.frx":0002
      Style           =   2  'Dropdown List
      TabIndex        =   25
      Top             =   3360
      Width           =   1455
   End
   Begin VB.Frame Frame3 
      Caption         =   "�������"
      Height          =   1455
      Left            =   5520
      TabIndex        =   20
      Top             =   7800
      Width           =   3735
      Begin VB.ComboBox ComboMicAM 
         Height          =   315
         Left            =   1560
         TabIndex        =   24
         Top             =   840
         Width           =   1935
      End
      Begin VB.ComboBox ComboSpkAM 
         Height          =   315
         Left            =   1560
         TabIndex        =   21
         Top             =   360
         Width           =   1935
      End
      Begin VB.Label Label4 
         Caption         =   "��˷����棺"
         Height          =   255
         Left            =   240
         TabIndex        =   23
         Top             =   840
         Width           =   1215
      End
      Begin VB.Label Label3 
         Caption         =   "�������棺"
         Height          =   255
         Left            =   360
         TabIndex        =   22
         Top             =   360
         Width           =   1095
      End
   End
   Begin VB.CommandButton StartFlash 
      Caption         =   "�Ĳ��"
      Height          =   495
      Left            =   1560
      TabIndex        =   19
      Top             =   8160
      Width           =   1215
   End
   Begin VB.CommandButton RefuseCallIn 
      Caption         =   "�ܽ�����"
      Height          =   495
      Left            =   120
      TabIndex        =   18
      Top             =   8160
      Width           =   1335
   End
   Begin VB.Frame Frame2 
      Caption         =   "״̬����"
      Height          =   3375
      Left            =   5520
      TabIndex        =   10
      Top             =   4200
      Width           =   3735
      Begin VB.ComboBox ComboDoPlayMutex 
         Height          =   315
         Left            =   1680
         TabIndex        =   17
         Top             =   2880
         Width           =   1935
      End
      Begin VB.CheckBox CheckDoPlay 
         Caption         =   "������"
         Height          =   375
         Left            =   360
         TabIndex        =   16
         Top             =   2880
         Width           =   1215
      End
      Begin VB.CheckBox CheckMic2Line 
         Caption         =   "��˷���������·"
         Height          =   375
         Left            =   360
         TabIndex        =   15
         Top             =   2400
         Width           =   2415
      End
      Begin VB.CheckBox CheckPlay2Spk 
         Caption         =   "��������������"
         Height          =   255
         Left            =   360
         TabIndex        =   14
         Top             =   1920
         Width           =   2655
      End
      Begin VB.CheckBox CheckLine2Spk 
         Caption         =   "����·����������"
         Height          =   375
         Left            =   360
         TabIndex        =   13
         Top             =   1320
         Width           =   2535
      End
      Begin VB.CheckBox CheckDoPhone 
         Caption         =   "�Ͽ�������PSTN����"
         Height          =   375
         Left            =   360
         TabIndex        =   12
         Top             =   840
         Width           =   2415
      End
      Begin VB.CheckBox CheckDoHook 
         Caption         =   "ժ��/����"
         Height          =   375
         Left            =   360
         TabIndex        =   11
         Top             =   360
         Width           =   1455
      End
   End
   Begin VB.CommandButton StopPlayFile 
      Caption         =   "ֹͣ����"
      Height          =   615
      Left            =   1560
      TabIndex        =   9
      Top             =   5400
      Width           =   1095
   End
   Begin VB.CommandButton StartPlayFile 
      Caption         =   "�����ļ�"
      Height          =   615
      Left            =   120
      TabIndex        =   8
      Top             =   5400
      Width           =   1335
   End
   Begin VB.Frame Frame1 
      Caption         =   "����"
      Height          =   1095
      Left            =   120
      TabIndex        =   4
      Top             =   4200
      Width           =   4935
      Begin VB.CommandButton stopdial 
         Caption         =   "ֹͣ/�һ�"
         Height          =   375
         Left            =   3720
         TabIndex        =   33
         Top             =   480
         Width           =   1095
      End
      Begin VB.CommandButton btnstartdial 
         Caption         =   "��ʼ����"
         Height          =   375
         Left            =   2640
         TabIndex        =   7
         Top             =   480
         Width           =   975
      End
      Begin VB.TextBox dialcode 
         Height          =   375
         Left            =   960
         TabIndex        =   6
         Top             =   480
         Width           =   1695
      End
      Begin VB.Label Label2 
         Caption         =   "���룺"
         Height          =   255
         Left            =   240
         TabIndex        =   5
         Top             =   480
         Width           =   615
      End
   End
   Begin VB.ListBox lstMessage 
      Height          =   2985
      Left            =   120
      TabIndex        =   2
      Top             =   120
      Width           =   9135
   End
   Begin VB.CommandButton CloseDevice 
      Caption         =   "�ر��豸"
      Height          =   615
      Left            =   1560
      TabIndex        =   1
      Top             =   3240
      Width           =   1335
   End
   Begin VB.CommandButton opendevice 
      Caption         =   "���豸"
      Height          =   615
      Left            =   120
      TabIndex        =   0
      Top             =   3240
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "��ǰ����ͨ����"
      Height          =   255
      Left            =   3240
      TabIndex        =   3
      Top             =   3360
      Width           =   1455
   End
End
Attribute VB_Name = "mainform"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Type TChannel_Status
    nPlayFileHandle As Long '����ͨ�������ļ����
    nRecFileHandle As Long '����ͨ���ļ�¼�����
End Type
Dim ChannelStatus(64) As TChannel_Status ' ��ʾ�������֧��64��ͨ��
Private Const MAX_PATH = 260
   
Public Sub ShowMsg(Msg As String)
    lstMessage.AddItem Msg, 0
End Sub

Private Sub btnstartdial_Click()
QNV_General ComboChannel.ListIndex, QNV_GENERAL_STARTDIAL, 0, dialcode.Text
ShowMsg "ͨ��" + Str(ComboChannel.ListIndex) + ": ��ʼ���� " + dialcode.Text
End Sub

Private Sub CheckDoHook_Click()
QNV_SetDevCtrl ComboChannel.ListIndex, QNV_CTRL_DOHOOK, CheckDoHook.Value
End Sub

Private Sub CheckDoPhone_Click()
QNV_SetDevCtrl ComboChannel.ListIndex, QNV_CTRL_DOPHONE, CheckDoPhone.Value = 0 'checkΪ1ʱ��ʾ�Ͽ������ã�����ֵΪ0����֮
End Sub

Private Sub CheckDoPlay_Click()
QNV_SetDevCtrl ComboChannel.ListIndex, QNV_CTRL_DOPLAY, CheckDoPlay.Value
End Sub

Private Sub CheckLine2Spk_Click()
QNV_SetDevCtrl ComboChannel.ListIndex, QNV_CTRL_DOLINETOSPK, CheckLine2Spk.Value
End Sub

Private Sub CheckMic2Line_Click()
QNV_SetDevCtrl ComboChannel.ListIndex, QNV_CTRL_DOMICTOLINE, CheckMic2Line.Value
End Sub

Private Sub CheckPlay2Spk_Click()
QNV_SetDevCtrl ComboChannel.ListIndex, QNV_CTRL_DOPLAYTOSPK, CheckPlay2Spk.Value
End Sub

Private Sub CloseDevice_Click()
    QNV_CloseDevice ODT_ALL, 0 '�ر����д򿪵��豸����������ֻ����301�豸��Ҳ�͵�Ч��QNV_CloseDevice ODT_LBRIDGE, 0
    ShowMsg "�豸�ѹر�"
    ComboChannel.Clear
    ComboDoPlayMutex.Clear
    ComboRecFormat.Clear
    ComboSpkAM.Clear
    ComboMicAM.Clear
    UnHook  'ȡ���Զ�����Ϣ���� windowsmsg.bas ģ��
End Sub

Private Sub Form_Load()
'MsgBox App.Path 'CurDir()
lpPrevWndProc = 0 ' ��û�н��մ�����Ϣ��Ĭ�ϳ�ʼΪ0
gHW = Me.hWnd ' ���ý�����Ϣ�Ĵ���ֵ ��windowsmsg.bas ģ��
End Sub

Private Sub Form_Unload(Cancel As Integer)
CloseDevice_Click
End Sub

Private Sub opendevice_Click()
Dim i As Integer
    CloseDevice_Click '��ǿ�ƹر�
    If QNV_OpenDevice(ODT_LBRIDGE, 0, "") > 0 Then 'VB�к�������Ϊstring ʱ���ʹ��0Ϊ����ʱVB���Զ�ת��Ϊ�ַ�"0"����DLL�����Խ�������ʹ��string�Ĳ����ÿ��ַ�""������0
        ShowMsg "��ʼ���豸�ɹ� ͨ����:" + Str(QNV_DevInfo(0, QNV_DEVINFO_GETCHANNELS))
        For i = 0 To QNV_DevInfo(0, QNV_DEVINFO_GETCHANNELS) - 1
            ComboChannel.AddItem Str(i + 1)
            
            ChannelStatus(i).nPlayFileHandle = 0
            ChannelStatus(i).nRecFileHandle = 0
            
            QNV_Event i, QNV_EVENT_REGWND, Me.hWnd, 0, 0, 0 'ע�᱾���ھ��Ϊ�����¼��Ĵ��� ,��windowmsgģ���WindowProc����������¼���Ϣ
            'QNV_SetDevCtrl i, QNV_CTRL_WATCHDOG, 0 ' �����Ҫ���Գ��򣬽����ȹرտ��Ź�
        Next i
        
        ComboChannel.ListIndex = 0
        
        '��ʼ��ѹ����ʽ�б�
        ComboRecFormat.Clear
        ComboRecFormat.AddItem "BRI_WAV_FORMAT_DEFAULT (BRI_AUDIO_FORMAT_PCM8K16B)"
        ComboRecFormat.AddItem "BRI_WAV_FORMAT_ALAW8K (8k/s)"
        ComboRecFormat.AddItem "BRI_WAV_FORMAT_ULAW8K (8k/s)')"
        ComboRecFormat.AddItem "BRI_WAV_FORMAT_IMAADPCM8K4B (4k/s)"
        ComboRecFormat.AddItem "BRI_WAV_FORMAT_PCM8K8B (8k/s)"
        ComboRecFormat.AddItem "BRI_WAV_FORMAT_PCM8K16B (16k/s)"
        ComboRecFormat.AddItem "BRI_WAV_FORMAT_MP38K8B (1.2k/s)"
        ComboRecFormat.AddItem "BRI_WAV_FORMAT_MP38K16B( 2.4k/s)"
        ComboRecFormat.AddItem "BRI_WAV_FORMAT_TM8K1B (1.5k/s)"
        ComboRecFormat.AddItem "BRI_WAV_FORMAT_GSM6108K(2.2k/s)"
        ComboRecFormat.ListIndex = 0
        '��ʼ����������б�
        ComboDoPlayMutex.Clear
        ComboDoPlayMutex.AddItem "���ŵ�����������"
        ComboDoPlayMutex.AddItem "��·����������"
        ComboDoPlayMutex.ListIndex = 0
        
        '��ʼ�����������б�
        ComboSpkAM.Clear
        For i = 0 To 15
            ComboSpkAM.AddItem Str(i)
        Next i
        ComboSpkAM.ListIndex = 13
        
        '��ʼ��MIC�����б�
        ComboMicAM.Clear
        For i = 0 To 15
            ComboMicAM.AddItem Str(i)
        Next i
        ComboMicAM.ListIndex = 5
        
        Hook '��ȡ�Զ�����Ϣ���� windowsmsg.bas ģ��
    Else
        ShowMsg "��ʼ���豸ʧ��,�����豸�Ƿ�����������USB�ڲ���װ������"
    End If
End Sub

Private Sub PausePlayFile_Click()
If ComboChannel.ListIndex >= 0 Then
    If ChannelStatus(ComboChannel.ListIndex).nPlayFileHandle > 0 Then
       QNV_PlayFile ComboChannel.ListIndex, QNV_PLAY_FILE_PAUSE, ChannelStatus(ComboChannel.ListIndex).nPlayFileHandle, 0, ""
    End If
End If
End Sub

Private Sub PauseRecFile_Click()
If ComboChannel.ListIndex >= 0 Then
    If ChannelStatus(ComboChannel.ListIndex).nRecFileHandle > 0 Then
        QNV_RecordFile ComboChannel.ListIndex, QNV_RECORD_FILE_PAUSE, ChannelStatus(ComboChannel.ListIndex).nRecFileHandle, 0, ""
    End If
End If
End Sub

Private Sub PhoneRing_Click()
If PhoneRing.Value = 1 Then
    If QNV_General(ComboChannel.ListIndex, QNV_GENERAL_STARTRING, 0, "1234") > 0 Then   '���岢�û�����ʾ1234
        ShowMsg "��ʼ�����������"
    Else
        ShowMsg "�����������ʧ��"
    End If
Else
    QNV_General ComboChannel.ListIndex, QNV_GENERAL_STOPRING, 0, ""
End If
End Sub

Private Sub RefuseCallIn_Click()
QNV_General ComboChannel.ListIndex, QNV_GENERAL_STARTREFUSE, 0, ""
End Sub

Private Sub ResumePlayFile_Click()
If ComboChannel.ListIndex >= 0 Then
    If ChannelStatus(ComboChannel.ListIndex).nPlayFileHandle > 0 Then
       QNV_PlayFile ComboChannel.ListIndex, QNV_PLAY_FILE_RESUME, ChannelStatus(ComboChannel.ListIndex).nPlayFileHandle, 0, ""
    End If
End If
End Sub

Private Sub ResumeRecFile_Click()
If ComboChannel.ListIndex >= 0 Then
    If ChannelStatus(ComboChannel.ListIndex).nRecFileHandle > 0 Then
        QNV_RecordFile ComboChannel.ListIndex, QNV_RECORD_FILE_RESUME, ChannelStatus(ComboChannel.ListIndex).nRecFileHandle, 0, ""
    End If
End If
End Sub

Private Sub StartFlash_Click()
QNV_General ComboChannel.ListIndex, QNV_GENERAL_STARTFLASH, FT_ALL, "" ' �Ĳ�ɺ�Ҫ�Զ����ֻ���������ַ�
End Sub

Private Sub StartPlayFile_Click()
If ComboChannel.ListIndex >= 0 Then
    FileDialog.ShowOpen
    If FileDialog.FileName <> "" Then
        QNV_PlayFile ComboChannel.ListIndex, QNV_PLAY_FILE_STOP, ChannelStatus(ComboChannel.ListIndex).nPlayFileHandle, 0, "" ' ��ֹͣ�ϴβ���
        Dim lMask As Long
        lMask = PLAYFILE_MASK_REPEAT 'ѭ������
        ChannelStatus(ComboChannel.ListIndex).nPlayFileHandle = QNV_PlayFile(ComboChannel.ListIndex, QNV_PLAY_FILE_START, 0, lMask, FileDialog.FileName)
        If ChannelStatus(ComboChannel.ListIndex).nPlayFileHandle > 0 Then
            ShowMsg "��ʼ�����ļ�: " + FileDialog.FileName
        Else
            ShowMsg "�����ļ�ʧ��: " + FileDialog.FileName
        End If
    End If
 End If
End Sub

Private Sub StartRecFile_Click()
If ComboChannel.ListIndex >= 0 Then
    FileDialog.ShowSave
    If FileDialog.FileName <> "" Then
        QNV_RecordFile ComboChannel.ListIndex, QNV_RECORD_FILE_STOP, ChannelStatus(ComboChannel.ListIndex).nRecFileHandle, 0, "" ' ��ֹͣ�ϴ�¼��
        Dim lMask As Long
        lMask = 0
        If CheckEcho.Value = 1 Then
        lMask = lMask Or RECORD_MASK_ECHO ' ���ӻ������������������
        End If
        If CheckEcho.Value = 1 Then
        lMask = lMask Or RECORD_MASK_AGC '¼�����ݽ����Զ����洦��
        End If
        '��ʼ¼��
        ChannelStatus(ComboChannel.ListIndex).nRecFileHandle = QNV_RecordFile(ComboChannel.ListIndex, QNV_RECORD_FILE_START, ComboRecFormat.ListIndex, lMask, FileDialog.FileName)
        If ChannelStatus(ComboChannel.ListIndex).nRecFileHandle > 0 Then
            ShowMsg "��ʼ�ļ�¼��: " + FileDialog.FileName
        Else
            ShowMsg "��ʼ�ļ�¼��ʧ��: " + FileDialog.FileName
        End If
    End If
 End If
End Sub

Private Sub stopdial_Click()
If ComboChannel.ListIndex >= 0 Then
    QNV_General ComboChannel.ListIndex, QNV_GENERAL_STOPDIAL, 0, 0
    QNV_SetDevCtrl ComboChannel.ListIndex, QNV_CTRL_DOHOOK, 0
End If
End Sub

Private Sub StopPlayFile_Click()
If ComboChannel.ListIndex >= 0 Then
    If ChannelStatus(ComboChannel.ListIndex).nPlayFileHandle > 0 Then
       QNV_PlayFile ComboChannel.ListIndex, QNV_PLAY_FILE_STOP, ChannelStatus(ComboChannel.ListIndex).nPlayFileHandle, 0, ""
      ChannelStatus(ComboChannel.ListIndex).nPlayFileHandle = 0
    End If
End If
End Sub

Private Sub StopRecFile_Click()
If ComboChannel.ListIndex >= 0 Then
    If ChannelStatus(ComboChannel.ListIndex).nRecFileHandle > 0 Then
     '��ȡ¼���ļ�·��
        Dim sTemp As String * MAX_PATH '�����㹻����ڴ�
        Dim lSize As Long
        Dim lElapse As Long 'ʱ�� ��λ(s)
        Dim strPath As String
        lSize = QNV_RecordFile(ComboChannel.ListIndex, QNV_RECORD_FILE_PATH, ChannelStatus(ComboChannel.ListIndex).nRecFileHandle, MAX_PATH, sTemp)
        strPath = Left(sTemp, lSize) ''\0'����
        lElapse = QNV_RecordFile(ComboChannel.ListIndex, QNV_RECORD_FILE_ELAPSE, ChannelStatus(ComboChannel.ListIndex).nRecFileHandle, 0, "")
        QNV_RecordFile ComboChannel.ListIndex, QNV_RECORD_FILE_STOP, ChannelStatus(ComboChannel.ListIndex).nRecFileHandle, 0, "" 'ֹͣ¼��
        ChannelStatus(ComboChannel.ListIndex).nRecFileHandle = 0
        ShowMsg "ֹͣ�ļ�·��:" + "ʱ��=" + Str(lElapse) + "�� ·��=" + strPath
    End If
End If
End Sub

Public Sub ProcEvent(ByVal lParam As Long) 'ByRef pEventData As TBriEvent_Data
    Dim EventData As TBriEvent_Data
    Dim szChannel As String
    CopyMemory EventData, ByVal lParam, Len(EventData) '��ȡ�ṹ����
    szChannel = "ͨ��" + Str(EventData.uChannelID + 1) + ": "
    Select Case EventData.lEventType
    Case BriEvent_PhoneHook
        ShowMsg szChannel + "����ժ��"
    Case BriEvent_PhoneHang
        ShowMsg szChannel + "�����һ�"
    Case BriEvent_CallIn
        ShowMsg szChannel + "�������� " + EventData.szData
    Case BriEvent_GetCallID
        ShowMsg szChannel + "���յ�������� " + EventData.szData
    Case BriEvent_PhoneDial
        ShowMsg szChannel + "��⵽�������� " + EventData.szData
    Case BriEvent_StopCallIn
        ShowMsg szChannel + "�Է�ֹͣ���룬����һ��δ�ӵ绰"
    Case BriEvent_DialEnd
        ShowMsg szChannel + "���Ž���"
    Case BriEvent_PlayFileEnd
        ShowMsg szChannel + "�����ļ�����"
    Case BriEvent_PlayMultiFileEnd
        ShowMsg szChannel + "�������ļ����Ž���"
    Case BriEvent_PlayStringEnd
        ShowMsg szChannel + "�����ַ�����"
    Case BriEvent_RepeatPlayFile
        ShowMsg szChannel + "�ظ������ļ�"
    Case BriEvent_SendCallIDEnd
        ShowMsg szChannel + "������phone���豸ģ�������Ƿ��ͺ������"
    Case BriEvent_RingTimeOut
        ShowMsg szChannel + "������phone���豸ģ�����峬ʱ"
    Case BriEvent_Ringing
        ShowMsg szChannel + "������phone���豸�������� " + EventData.szData
    Case BriEvent_Silence
        ShowMsg szChannel + "ͨ����һ��ʱ��ľ�����"
    Case BriEvent_GetDTMFChar
        ShowMsg szChannel + "ͨ���н��յ�DTMF����"
    Case BriEvent_RemoteHook
        ShowMsg szChannel + "������Է�������ʼͨ��"
    Case BriEvent_RemoteHang
        ShowMsg szChannel + "������Է�����ͨ����һ���"
    Case BriEvent_Busy
        ShowMsg szChannel + "PSTN��·�Ѿ��Ͽ�"
    Case BriEvent_DialTone
        ShowMsg szChannel + "��Ⲧ������"
    Case BriEvent_RingBack
        ShowMsg szChannel + "��⵽������ result=" + Str(EventData.lResult) + " data=" + EventData.szData
    Case BriEvent_MicIn
        ShowMsg szChannel + "��⵽��˷������"
    Case BriEvent_MicOut
        ShowMsg szChannel + "��⵽��˷�ε���"
    Case BriEvent_FlashEnd
        ShowMsg szChannel + "�Ĳ����ɣ����Բ��ֻ���"
    Case BriEvent_RefuseEnd
        ShowMsg szChannel + "�ܽ��������"
    Case BriEvent_SpeechResult
        ShowMsg szChannel + "����ʶ�����"
    Case BriEvent_PSTNFree
        ShowMsg szChannel + "��·�ѿ���"
    Case BriEvent_CallLog
        ShowMsg szChannel + "����һ��������־"
    Case BriEvent_EnableHook
        ShowMsg szChannel + "��ժ�һ�״̬�仯�� " + Str(EventData.lResult)
    Case BriEvent_RecvedFSK
        ShowMsg szChannel + "������������źţ������Ǳ������磬Ҳ�����Ƕ�ν��յ�������� (��������)" + EventData.szData
    Case Else
        ShowMsg szChannel + "���Դ�����Ϣ id=" + Str(EventData.lEventType) '������ʾ����
    End Select
End Sub

