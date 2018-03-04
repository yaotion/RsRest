VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form mainform 
   Caption         =   "CC301基本功能开发演示 1.1"
   ClientHeight    =   9435
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   9405
   LinkTopic       =   "Form1"
   ScaleHeight     =   9435
   ScaleWidth      =   9405
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton ResumePlayFile 
      Caption         =   "恢复播放"
      Height          =   615
      Left            =   3960
      TabIndex        =   36
      Top             =   5400
      Width           =   1095
   End
   Begin VB.CommandButton PausePlayFile 
      Caption         =   "暂停播放"
      Height          =   615
      Left            =   2760
      TabIndex        =   35
      Top             =   5400
      Width           =   1095
   End
   Begin VB.CheckBox PhoneRing 
      Caption         =   "内线间隔震铃"
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
      Caption         =   "录音"
      Height          =   1815
      Left            =   120
      TabIndex        =   26
      Top             =   6120
      Width           =   4935
      Begin VB.CommandButton ResumeRecFile 
         Caption         =   "恢复录音"
         Height          =   495
         Left            =   3600
         TabIndex        =   38
         Top             =   1200
         Width           =   1095
      End
      Begin VB.CommandButton PauseRecFile 
         Caption         =   "暂停录音"
         Height          =   495
         Left            =   2520
         TabIndex        =   37
         Top             =   1200
         Width           =   975
      End
      Begin VB.CommandButton StopRecFile 
         Caption         =   "停止录音"
         Height          =   495
         Left            =   1440
         TabIndex        =   32
         Top             =   1200
         Width           =   975
      End
      Begin VB.CommandButton StartRecFile 
         Caption         =   "开始录音"
         Height          =   495
         Left            =   120
         TabIndex        =   31
         Top             =   1200
         Width           =   1095
      End
      Begin VB.CheckBox CheckAGC 
         Caption         =   "自动增益"
         Height          =   375
         Left            =   2520
         TabIndex        =   30
         Top             =   720
         Width           =   1215
      End
      Begin VB.CheckBox CheckEcho 
         Caption         =   "回音抵消"
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
         Caption         =   "文件压缩格式："
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
      Caption         =   "增益控制"
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
         Caption         =   "麦克风增益："
         Height          =   255
         Left            =   240
         TabIndex        =   23
         Top             =   840
         Width           =   1215
      End
      Begin VB.Label Label3 
         Caption         =   "耳机增益："
         Height          =   255
         Left            =   360
         TabIndex        =   22
         Top             =   360
         Width           =   1095
      End
   End
   Begin VB.CommandButton StartFlash 
      Caption         =   "拍插簧"
      Height          =   495
      Left            =   1560
      TabIndex        =   19
      Top             =   8160
      Width           =   1215
   End
   Begin VB.CommandButton RefuseCallIn 
      Caption         =   "拒接来电"
      Height          =   495
      Left            =   120
      TabIndex        =   18
      Top             =   8160
      Width           =   1335
   End
   Begin VB.Frame Frame2 
      Caption         =   "状态控制"
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
         Caption         =   "打开喇叭"
         Height          =   375
         Left            =   360
         TabIndex        =   16
         Top             =   2880
         Width           =   1215
      End
      Begin VB.CheckBox CheckMic2Line 
         Caption         =   "麦克风声音到线路"
         Height          =   375
         Left            =   360
         TabIndex        =   15
         Top             =   2400
         Width           =   2415
      End
      Begin VB.CheckBox CheckPlay2Spk 
         Caption         =   "播放声音到耳机"
         Height          =   255
         Left            =   360
         TabIndex        =   14
         Top             =   1920
         Width           =   2655
      End
      Begin VB.CheckBox CheckLine2Spk 
         Caption         =   "打开线路声音到耳机"
         Height          =   375
         Left            =   360
         TabIndex        =   13
         Top             =   1320
         Width           =   2535
      End
      Begin VB.CheckBox CheckDoPhone 
         Caption         =   "断开话机与PSTN连接"
         Height          =   375
         Left            =   360
         TabIndex        =   12
         Top             =   840
         Width           =   2415
      End
      Begin VB.CheckBox CheckDoHook 
         Caption         =   "摘机/接听"
         Height          =   375
         Left            =   360
         TabIndex        =   11
         Top             =   360
         Width           =   1455
      End
   End
   Begin VB.CommandButton StopPlayFile 
      Caption         =   "停止播放"
      Height          =   615
      Left            =   1560
      TabIndex        =   9
      Top             =   5400
      Width           =   1095
   End
   Begin VB.CommandButton StartPlayFile 
      Caption         =   "播放文件"
      Height          =   615
      Left            =   120
      TabIndex        =   8
      Top             =   5400
      Width           =   1335
   End
   Begin VB.Frame Frame1 
      Caption         =   "拨号"
      Height          =   1095
      Left            =   120
      TabIndex        =   4
      Top             =   4200
      Width           =   4935
      Begin VB.CommandButton stopdial 
         Caption         =   "停止/挂机"
         Height          =   375
         Left            =   3720
         TabIndex        =   33
         Top             =   480
         Width           =   1095
      End
      Begin VB.CommandButton btnstartdial 
         Caption         =   "开始拨号"
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
         Caption         =   "号码："
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
      Caption         =   "关闭设备"
      Height          =   615
      Left            =   1560
      TabIndex        =   1
      Top             =   3240
      Width           =   1335
   End
   Begin VB.CommandButton opendevice 
      Caption         =   "打开设备"
      Height          =   615
      Left            =   120
      TabIndex        =   0
      Top             =   3240
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "当前控制通道："
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
    nPlayFileHandle As Long '保存通道播放文件句柄
    nRecFileHandle As Long '保存通道文件录音句柄
End Type
Dim ChannelStatus(64) As TChannel_Status ' 演示保存最多支持64个通道
Private Const MAX_PATH = 260
   
Public Sub ShowMsg(Msg As String)
    lstMessage.AddItem Msg, 0
End Sub

Private Sub btnstartdial_Click()
QNV_General ComboChannel.ListIndex, QNV_GENERAL_STARTDIAL, 0, dialcode.Text
ShowMsg "通道" + Str(ComboChannel.ListIndex) + ": 开始拨号 " + dialcode.Text
End Sub

Private Sub CheckDoHook_Click()
QNV_SetDevCtrl ComboChannel.ListIndex, QNV_CTRL_DOHOOK, CheckDoHook.Value
End Sub

Private Sub CheckDoPhone_Click()
QNV_SetDevCtrl ComboChannel.ListIndex, QNV_CTRL_DOPHONE, CheckDoPhone.Value = 0 'check为1时表示断开不可用，控制值为0。反之
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
    QNV_CloseDevice ODT_ALL, 0 '关闭所有打开的设备，该例子里只打开了301设备，也就等效于QNV_CloseDevice ODT_LBRIDGE, 0
    ShowMsg "设备已关闭"
    ComboChannel.Clear
    ComboDoPlayMutex.Clear
    ComboRecFormat.Clear
    ComboSpkAM.Clear
    ComboMicAM.Clear
    UnHook  '取消自定义消息处理 windowsmsg.bas 模块
End Sub

Private Sub Form_Load()
'MsgBox App.Path 'CurDir()
lpPrevWndProc = 0 ' 还没有接收窗口消息，默认初始为0
gHW = Me.hWnd ' 设置接收消息的窗口值 ，windowsmsg.bas 模块
End Sub

Private Sub Form_Unload(Cancel As Integer)
CloseDevice_Click
End Sub

Private Sub opendevice_Click()
Dim i As Integer
    CloseDevice_Click '先强制关闭
    If QNV_OpenDevice(ODT_LBRIDGE, 0, "") > 0 Then 'VB中函数申明为string 时如果使用0为参数时VB会自动转换为字符"0"传给DLL，所以建议这里使用string的参数用空字符""来代替0
        ShowMsg "初始化设备成功 通道数:" + Str(QNV_DevInfo(0, QNV_DEVINFO_GETCHANNELS))
        For i = 0 To QNV_DevInfo(0, QNV_DEVINFO_GETCHANNELS) - 1
            ComboChannel.AddItem Str(i + 1)
            
            ChannelStatus(i).nPlayFileHandle = 0
            ChannelStatus(i).nRecFileHandle = 0
            
            QNV_Event i, QNV_EVENT_REGWND, Me.hWnd, 0, 0, 0 '注册本窗口句柄为接收事件的窗口 ,在windowmsg模块的WindowProc函数里接收事件消息
            'QNV_SetDevCtrl i, QNV_CTRL_WATCHDOG, 0 ' 如果需要调试程序，建议先关闭看门狗
        Next i
        
        ComboChannel.ListIndex = 0
        
        '初始化压缩格式列表
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
        '初始化喇叭输出列表
        ComboDoPlayMutex.Clear
        ComboDoPlayMutex.AddItem "播放的语音到喇叭"
        ComboDoPlayMutex.AddItem "线路语音到喇叭"
        ComboDoPlayMutex.ListIndex = 0
        
        '初始化耳机增益列表
        ComboSpkAM.Clear
        For i = 0 To 15
            ComboSpkAM.AddItem Str(i)
        Next i
        ComboSpkAM.ListIndex = 13
        
        '初始化MIC增益列表
        ComboMicAM.Clear
        For i = 0 To 15
            ComboMicAM.AddItem Str(i)
        Next i
        ComboMicAM.ListIndex = 5
        
        Hook '获取自定义消息处理 windowsmsg.bas 模块
    Else
        ShowMsg "初始化设备失败,请检查设备是否已正常插入USB口并安装了驱动"
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
    If QNV_General(ComboChannel.ListIndex, QNV_GENERAL_STARTRING, 0, "1234") > 0 Then   '响铃并让话机显示1234
        ShowMsg "开始启动间隔响铃"
    Else
        ShowMsg "启动间隔响铃失败"
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
QNV_General ComboChannel.ListIndex, QNV_GENERAL_STARTFLASH, FT_ALL, "" ' 拍插簧后不要自动拨分机，传入空字符
End Sub

Private Sub StartPlayFile_Click()
If ComboChannel.ListIndex >= 0 Then
    FileDialog.ShowOpen
    If FileDialog.FileName <> "" Then
        QNV_PlayFile ComboChannel.ListIndex, QNV_PLAY_FILE_STOP, ChannelStatus(ComboChannel.ListIndex).nPlayFileHandle, 0, "" ' 先停止上次播放
        Dim lMask As Long
        lMask = PLAYFILE_MASK_REPEAT '循环播放
        ChannelStatus(ComboChannel.ListIndex).nPlayFileHandle = QNV_PlayFile(ComboChannel.ListIndex, QNV_PLAY_FILE_START, 0, lMask, FileDialog.FileName)
        If ChannelStatus(ComboChannel.ListIndex).nPlayFileHandle > 0 Then
            ShowMsg "开始播放文件: " + FileDialog.FileName
        Else
            ShowMsg "播放文件失败: " + FileDialog.FileName
        End If
    End If
 End If
End Sub

Private Sub StartRecFile_Click()
If ComboChannel.ListIndex >= 0 Then
    FileDialog.ShowSave
    If FileDialog.FileName <> "" Then
        QNV_RecordFile ComboChannel.ListIndex, QNV_RECORD_FILE_STOP, ChannelStatus(ComboChannel.ListIndex).nRecFileHandle, 0, "" ' 先停止上次录音
        Dim lMask As Long
        lMask = 0
        If CheckEcho.Value = 1 Then
        lMask = lMask Or RECORD_MASK_ECHO ' 增加回音抵消后的数据属性
        End If
        If CheckEcho.Value = 1 Then
        lMask = lMask Or RECORD_MASK_AGC '录音数据进行自动增益处理
        End If
        '开始录音
        ChannelStatus(ComboChannel.ListIndex).nRecFileHandle = QNV_RecordFile(ComboChannel.ListIndex, QNV_RECORD_FILE_START, ComboRecFormat.ListIndex, lMask, FileDialog.FileName)
        If ChannelStatus(ComboChannel.ListIndex).nRecFileHandle > 0 Then
            ShowMsg "开始文件录音: " + FileDialog.FileName
        Else
            ShowMsg "开始文件录音失败: " + FileDialog.FileName
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
     '获取录音文件路径
        Dim sTemp As String * MAX_PATH '分配足够大的内存
        Dim lSize As Long
        Dim lElapse As Long '时长 单位(s)
        Dim strPath As String
        lSize = QNV_RecordFile(ComboChannel.ListIndex, QNV_RECORD_FILE_PATH, ChannelStatus(ComboChannel.ListIndex).nRecFileHandle, MAX_PATH, sTemp)
        strPath = Left(sTemp, lSize) ''\0'结束
        lElapse = QNV_RecordFile(ComboChannel.ListIndex, QNV_RECORD_FILE_ELAPSE, ChannelStatus(ComboChannel.ListIndex).nRecFileHandle, 0, "")
        QNV_RecordFile ComboChannel.ListIndex, QNV_RECORD_FILE_STOP, ChannelStatus(ComboChannel.ListIndex).nRecFileHandle, 0, "" '停止录音
        ChannelStatus(ComboChannel.ListIndex).nRecFileHandle = 0
        ShowMsg "停止文件路径:" + "时长=" + Str(lElapse) + "秒 路径=" + strPath
    End If
End If
End Sub

Public Sub ProcEvent(ByVal lParam As Long) 'ByRef pEventData As TBriEvent_Data
    Dim EventData As TBriEvent_Data
    Dim szChannel As String
    CopyMemory EventData, ByVal lParam, Len(EventData) '获取结构数据
    szChannel = "通道" + Str(EventData.uChannelID + 1) + ": "
    Select Case EventData.lEventType
    Case BriEvent_PhoneHook
        ShowMsg szChannel + "话机摘机"
    Case BriEvent_PhoneHang
        ShowMsg szChannel + "话机挂机"
    Case BriEvent_CallIn
        ShowMsg szChannel + "来电震铃 " + EventData.szData
    Case BriEvent_GetCallID
        ShowMsg szChannel + "接收到来电号码 " + EventData.szData
    Case BriEvent_PhoneDial
        ShowMsg szChannel + "检测到话机拨号 " + EventData.szData
    Case BriEvent_StopCallIn
        ShowMsg szChannel + "对方停止呼入，产生一个未接电话"
    Case BriEvent_DialEnd
        ShowMsg szChannel + "软拨号结束"
    Case BriEvent_PlayFileEnd
        ShowMsg szChannel + "播放文件结束"
    Case BriEvent_PlayMultiFileEnd
        ShowMsg szChannel + "连续多文件播放结束"
    Case BriEvent_PlayStringEnd
        ShowMsg szChannel + "播放字符结束"
    Case BriEvent_RepeatPlayFile
        ShowMsg szChannel + "重复播放文件"
    Case BriEvent_SendCallIDEnd
        ShowMsg szChannel + "给本地phone口设备模拟震铃是发送号码结束"
    Case BriEvent_RingTimeOut
        ShowMsg szChannel + "给本地phone口设备模拟震铃超时"
    Case BriEvent_Ringing
        ShowMsg szChannel + "给本地phone口设备正在震铃 " + EventData.szData
    Case BriEvent_Silence
        ShowMsg szChannel + "通话中一定时间的静音了"
    Case BriEvent_GetDTMFChar
        ShowMsg szChannel + "通话中接收到DTMF按键"
    Case BriEvent_RemoteHook
        ShowMsg szChannel + "呼出后对方接听开始通话"
    Case BriEvent_RemoteHang
        ShowMsg szChannel + "呼出后对方接听通话后挂机了"
    Case BriEvent_Busy
        ShowMsg szChannel + "PSTN线路已经断开"
    Case BriEvent_DialTone
        ShowMsg szChannel + "检测拨号音了"
    Case BriEvent_RingBack
        ShowMsg szChannel + "检测到回铃了 result=" + Str(EventData.lResult) + " data=" + EventData.szData
    Case BriEvent_MicIn
        ShowMsg szChannel + "检测到麦克风插入了"
    Case BriEvent_MicOut
        ShowMsg szChannel + "检测到麦克风拔掉了"
    Case BriEvent_FlashEnd
        ShowMsg szChannel + "拍插簧完成，可以拨分机了"
    Case BriEvent_RefuseEnd
        ShowMsg szChannel + "拒接来电完成"
    Case BriEvent_SpeechResult
        ShowMsg szChannel + "语音识别完成"
    Case BriEvent_PSTNFree
        ShowMsg szChannel + "线路已空闲"
    Case BriEvent_CallLog
        ShowMsg szChannel + "产生一个呼叫日志"
    Case BriEvent_EnableHook
        ShowMsg szChannel + "软摘挂机状态变化了 " + Str(EventData.lResult)
    Case BriEvent_RecvedFSK
        ShowMsg szChannel + "接收来电号码信号，可能是本次来电，也可能是多次接收到来电号码 (保留功能)" + EventData.szData
    Case Else
        ShowMsg szChannel + "忽略处理消息 id=" + Str(EventData.lEventType) '调用显示函数
    End Select
End Sub

