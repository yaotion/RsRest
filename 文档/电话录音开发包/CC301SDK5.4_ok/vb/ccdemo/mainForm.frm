VERSION 5.00
Begin VB.Form mainform 
   Caption         =   "CC网络即时消息/文件传输/P2P语音 VB开发演示1.1"
   ClientHeight    =   6540
   ClientLeft      =   165
   ClientTop       =   855
   ClientWidth     =   10920
   LinkTopic       =   "Form1"
   ScaleHeight     =   6540
   ScaleWidth      =   10920
   StartUpPosition =   3  'Windows Default
   Begin VB.ListBox lstMessage 
      Height          =   5715
      Left            =   120
      TabIndex        =   0
      Top             =   600
      Width           =   10695
   End
   Begin VB.Label Label1 
      Caption         =   "如果调试程序提示未找到qnviccub.dll,请从开发包的bin目录复制qnviccub.dll和bridge.dll到工程调试目录，一般默认是本工程的目录"
      Height          =   255
      Left            =   240
      TabIndex        =   1
      Top             =   120
      Width           =   10575
   End
   Begin VB.Menu ID_MENU_FILE 
      Caption         =   "文件"
      Index           =   0
      Begin VB.Menu ID_MENU_LOGON 
         Caption         =   "登陆CC"
         Index           =   0
      End
      Begin VB.Menu ID_MENU_OFFLINE 
         Caption         =   "离线"
         Index           =   1
      End
      Begin VB.Menu ID_MENU_REGCC 
         Caption         =   "注册CC"
         Index           =   2
      End
   End
   Begin VB.Menu ID_MENU_OPERATOR 
      Caption         =   "操作"
      Index           =   1
      Begin VB.Menu ID_MENU_SENDMSG 
         Caption         =   "发送消息"
         Index           =   0
      End
      Begin VB.Menu ID_MENU_SENDCMD 
         Caption         =   "发送命令"
         Index           =   1
      End
      Begin VB.Menu ID_MENU_SENDCALL 
         Caption         =   "发送语音呼叫"
         Index           =   2
      End
      Begin VB.Menu ID_MENU_SENDFILE 
         Caption         =   "发送文件"
         Index           =   3
      End
   End
   Begin VB.Menu ID_MENU_PARAM 
      Caption         =   "参数"
      Index           =   2
      Begin VB.Menu ID_MENU_SETSVRADDR 
         Caption         =   "设置服务器IP地址"
         Index           =   0
      End
   End
End
Attribute VB_Name = "mainform"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public Sub ShowMsg(Msg As String)
    lstMessage.AddItem Msg, 0
End Sub

Private Sub Form_Load()
lpPrevWndProc = 0 '还没有接收窗口消息，默认初始为0
gHW = Me.hWnd '设置接收消息的窗口值 ，windowsmsg.bas 模块
If QNV_OpenDevice(ODT_CC, 0, QNV_CC_LICENSE) > 0 Then
    ShowMsg "加载CC模块成功"
    Hook
    QNV_Event CCCTRL_CHANNELID, QNV_EVENT_REGWND, Me.hWnd, NULL_VB, NULL_VB, 0
Else
    ShowMsg "加载CC模块失败"
End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
UnHook
Dim frm     As Form
  For Each frm In Forms
        Unload frm
  Next
QNV_CloseDevice ODT_ALL, 0 '关闭所有打开的设备，该例子里只打开了CC模块，也就等效于QNV_CloseDevice ODT_CC, 0
ShowMsg "CC模块已关闭"
End Sub

Public Sub ProcEvent(ByVal lParam As Long) 'ByRef pEventData As TBriEvent_Data
    Dim EventData As TBriEvent_Data
    Dim szChannel As String
    Dim strData As String
    CopyMemory EventData, ByVal lParam, Len(EventData) '获取结构体数据
    szChannel = "通道" + Str(EventData.uChannelID + 1) + ": "
    Select Case EventData.lEventType
        Case BriEvent_CC_ConnectFailed
            ShowMsg "连接服务器失败"
        Case BriEvent_CC_LoginFailed
            ShowMsg "登陆失败 原因=" + Str(EventData.lResult)
        Case BriEvent_CC_LoginSuccess
            ShowMsg "登陆成功"
        Case BriEvent_CC_SystemTimeErr
            ShowMsg "本地系统时间错误"
        Case BriEvent_CC_CallIn
            ShowMsg "CC语音呼入请求"
            CallForm.Show vbModeless, Me
            CallForm.AppendCallIn EventData.lEventHandle, EventData.szData
        Case BriEvent_CC_CallOutSuccess
            ShowMsg "CC语音正在呼出"
            SendmsgForm.Show vbModeless, Me
            CallForm.AppendCallOut EventData.lEventHandle, EventData.szData
            CallForm.UpdateCallState EventData.lEventHandle, "正在呼出"
        Case BriEvent_CC_CallOutFailed
            ShowMsg "CC语音呼出失败"
            SendmsgForm.Show vbModeless, Me
            CallForm.UpdateCallState EventData.lEventHandle, "呼出失败"
        Case BriEvent_CC_ReplyBusy
            ShowMsg "CC对方回复忙"
        Case BriEvent_CC_Connected
            ShowMsg "CC语音已经连通"
            CallForm.UpdateCallState EventData.lEventHandle, "已连通"
        Case BriEvent_CC_CallFinished
            ShowMsg "CC语音呼叫结束"
            CallForm.UpdateCallState EventData.lEventHandle, "已结束"
            CallForm.DeleteCallList EventData.lEventHandle
        Case BriEvent_CC_RecvedMsg
            ShowMsg "接收到消息"
            SendmsgForm.Show vbModeless, Me
            SendmsgForm.ProcRecvMsg EventData.szData
        Case BriEvent_CC_RecvedCmd
            ShowMsg "接收到命令"
            SendCmdForm.Show vbModeless, Me
            SendCmdForm.ProcRecvCmd EventData.szData
        Case BriEvent_CC_RecvFileRequest
            ShowMsg "接收到文件请求"
        Case BriEvent_CC_TransFileFinished
            ShowMsg "传输文件结束"
        Case BriEvent_CC_RegSuccess
            ShowMsg "注册CC成功"
        Case BriEvent_CC_RegFailed
            ShowMsg "注册CC失败"
        Case BriEvent_CC_ContactUpdateStatus
            strData = EventData.szData
            Replace strData, MSG_KEY_SPLIT, "|" ' list 不能显示换行
            ShowMsg "获取到用户状态: " + strData
    Case Else
        ShowMsg szChannel + "忽略处理消息 id=" + Str(EventData.lEventType) '调用显示函数
    End Select
End Sub
Private Sub ID_MENU_LOGON_Click(Index As Integer)
LogonForm.Show vbModal, Me ' vbModeless /vbModal
End Sub

Private Sub ID_MENU_OFFLINE_Click(Index As Integer)
QNV_CCCtrl QNV_CCCTRL_LOGOUT, NULL_VB, 0
ShowMsg "已离线"
End Sub

Private Sub ID_MENU_REGCC_Click(Index As Integer)
RegForm.Show vbModeless, Me
End Sub

Private Sub ID_MENU_SENDCALL_Click(Index As Integer)
InputccForm.Show vbModal, Me
End Sub

Private Sub ID_MENU_SENDCMD_Click(Index As Integer)
SendCmdForm.Show vbModeless, Me
End Sub

Private Sub ID_MENU_SENDMSG_Click(Index As Integer)
SendmsgForm.Show vbModeless, Me
End Sub

Private Sub ID_MENU_SETSVRADDR_Click(Index As Integer)
SetServeripform.Show vbModal, Me
End Sub
