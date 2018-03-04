VERSION 5.00
Begin VB.Form SendCmdForm 
   Caption         =   "发送用户自定义命令"
   ClientHeight    =   6285
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   10155
   LinkTopic       =   "Form1"
   ScaleHeight     =   6285
   ScaleWidth      =   10155
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox DestCC 
      Height          =   375
      Left            =   5880
      TabIndex        =   3
      Top             =   4440
      Width           =   2415
   End
   Begin VB.TextBox SendText 
      Height          =   1215
      Left            =   120
      MultiLine       =   -1  'True
      TabIndex        =   2
      Top             =   4920
      Width           =   8175
   End
   Begin VB.CommandButton Send 
      Caption         =   "发送"
      Height          =   1215
      Left            =   8400
      TabIndex        =   1
      Top             =   4920
      Width           =   1455
   End
   Begin VB.ListBox RecvMsg 
      Height          =   3960
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   9615
   End
   Begin VB.Label Label1 
      Caption         =   "消息内容："
      Height          =   255
      Left            =   120
      TabIndex        =   5
      Top             =   4440
      Width           =   975
   End
   Begin VB.Label Label2 
      Caption         =   "目标CC号："
      Height          =   255
      Left            =   4680
      TabIndex        =   4
      Top             =   4560
      Width           =   1095
   End
End
Attribute VB_Name = "SendCmdForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Function GetMsgParam(ByVal strMsg As String, ByVal strParam As String) As String
Dim strValue As String
Dim vsplit() As String
Dim i As Long
Dim isize As Long
vsplit = Split(strMsg, MSG_KEY_SPLIT)
GetMsgParam = ""
isize = UBound(vsplit)
For i = 0 To isize
If strParam = Left(vsplit(i), Len(strParam)) Then
    strValue = Right(vsplit(i), Len(vsplit(i)) - Len(strParam))
    Trim (strValue)
    GetMsgParam = strValue
    Exit For
End If
Next i
End Function
Private Sub AppendRecvView(ByVal strCC As String, ByVal strNick As String, ByVal strMsgText As String, ByVal strtime As String)
Dim strInfo As String
strInfo = strCC + " [" + strNick + "]  " + strtime
RecvMsg.AddItem strInfo
RecvMsg.AddItem "   " + strMsgText
End Sub
Public Sub ProcRecvCmd(ByVal strData As String)
Dim varray() As String
varray = Split(strData, MSG_TEXT_SPLIT)
Dim strParam As String
Dim strMsgText As String
Dim strCC As String
Dim strNick As String
If UBound(varray) < 1 Then
MsgBox "消息参数错误"
Else
    strParam = varray(0)
    strMsgText = varray(1)
    strCC = GetMsgParam(strParam, MSG_KEY_CC)
    strNick = GetMsgParam(strParam, MSG_KEY_NAME)
    DestCC.Text = strCC
    AppendRecvView strCC, strNick, strMsgText, Str(Date) + " " + Str(Time())
    SendText.SetFocus
End If
End Sub

Private Sub Send_Click()
If SendText.Text = "" Then
    MsgBox "请输入命令内容"
ElseIf DestCC.Text = "" Then
    MsgBox "请输入目标CC"
Else
       If QNV_CCCtrl_Msg(QNV_CCCTRL_MSG_SENDCMD, DestCC.Text, SendText.Text, NULL_VB, 0) <= 0 Then
            MsgBox "发送命令失败"
        Else
            Dim szNick As String * 64
            Dim szOwnerCC As String * 64
            Dim szNickData As String
            Dim szCCData As String
            QNV_CCCtrl_CCInfo QNV_CCCTRL_CCINFO_OWNERCC, "", szOwnerCC, 32 '本人CC
            QNV_CCCtrl_CCInfo QNV_CCCTRL_CCINFO_NICK, szOwnerCC, szNick, 64 '本人昵称,可以使用szCC或者为空QNV_CCCtrl_CCInfo(QNV_CCCTRL_CONTACTINFO_NICK,NULL,szNick,64);
            szCCData = Left(szOwnerCC, InStr(1, szOwnerCC, Chr(0)) - 1) '去掉后面多余的字符
            szNickData = Left(szNick, InStr(1, szNick, Chr(0)) - 1) '去掉后面多余的字符
            AppendRecvView szCCData, szNickData, SendText.Text, Str(Date) + " " + Str(Time())
            SendText.Text = ""
            SendText.SetFocus
        End If
End If
End Sub
