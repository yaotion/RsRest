VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form CallForm 
   Caption         =   "语音呼叫"
   ClientHeight    =   6135
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   9390
   LinkTopic       =   "Form1"
   ScaleHeight     =   6135
   ScaleWidth      =   9390
   StartUpPosition =   3  'Windows Default
   Begin MSComctlLib.ListView callList 
      Height          =   5175
      Left            =   120
      TabIndex        =   4
      Top             =   120
      Width           =   9015
      _ExtentX        =   15901
      _ExtentY        =   9128
      View            =   3
      LabelEdit       =   1
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      Checkboxes      =   -1  'True
      FullRowSelect   =   -1  'True
      GridLines       =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin VB.CommandButton stop 
      Caption         =   "停止"
      Height          =   495
      Left            =   4080
      TabIndex        =   3
      Top             =   5520
      Width           =   1215
   End
   Begin VB.CommandButton busy 
      Caption         =   "回复忙"
      Height          =   495
      Left            =   2760
      TabIndex        =   2
      Top             =   5520
      Width           =   1215
   End
   Begin VB.CommandButton refuse 
      Caption         =   "拒接"
      Height          =   495
      Left            =   1440
      TabIndex        =   1
      Top             =   5520
      Width           =   1215
   End
   Begin VB.CommandButton answer 
      Caption         =   "接听"
      Height          =   495
      Left            =   120
      TabIndex        =   0
      Top             =   5520
      Width           =   1215
   End
End
Attribute VB_Name = "CallForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

'初始化列表头
Private Sub Form_Load()
callList.ColumnHeaders.Add , "CC", "CC"
callList.ColumnHeaders.Add , "Nick", "昵称"
callList.ColumnHeaders.Add , "CallType", "呼叫类型"
callList.ColumnHeaders.Add , "State", "状态"
callList.ColumnHeaders.Add , "Key", "句柄KEY"
'AppendCallOut 100, "10011111"
'AppendCallOut 101, "10011122"
End Sub
'插入到列表
Private Sub AppendCallList(ByVal strCC As String, ByVal strNick As String, ByVal strCallType As String, ByVal strCallState As String, ByVal lcallhandle As Long)
Dim itmX As ListItem
Set itmX = callList.ListItems.Add(1, "K" + Str(lcallhandle), strCC) 'Key不能使用数字开头 +"K"
itmX.SubItems(callList.ColumnHeaders("Nick").SubItemIndex) = strNick
itmX.SubItems(callList.ColumnHeaders("CallType").SubItemIndex) = strCallType
itmX.SubItems(callList.ColumnHeaders("State").SubItemIndex) = strState
itmX.SubItems(callList.ColumnHeaders("Key").SubItemIndex) = Str(lcallhandle)
End Sub
'获取参数内容
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
'增加一个呼入请求记录
Public Sub AppendCallIn(ByVal lcallhandle As Long, ByVal strData As String)
Dim strParamText As String
Dim strCC As String
Dim strNick As String
Dim varray() As String
varray = Split(strData, MSG_TEXT_SPLIT)
strParamText = varray(0)
strCC = GetMsgParam(strParamText, MSG_KEY_CC)
strNick = GetMsgParam(strParamText, MSG_KEY_NAME)
AppendCallList strCC, strNick, "来电", "正在呼入", lcallhandle
End Sub
'增加一个呼出
Public Sub AppendCallOut(ByVal lcallhandle As Long, ByVal strData As String)
Dim strParamText As String
Dim strCC As String
Dim strNick As String
Dim varray() As String
varray = Split(strData, MSG_TEXT_SPLIT)
strParamText = varray(0)
strCC = GetMsgParam(strParamText, MSG_KEY_CC)
strNick = GetMsgParam(strParamText, MSG_KEY_NAME)
AppendCallList strCC, strNick, "去电", "正在呼出", lcallhandle
End Sub
'根据句柄获取列表ID
Public Function GetHandleItem(ByVal lcallhandle As Long) As Long
Dim i As Long
Dim iKeyItem As Long
GetHandleItem = 0
iKeyItem = callList.ColumnHeaders("Key").SubItemIndex
For i = 1 To callList.ListItems.Count  '循环检测第一项到最后一项
If CLng(callList.ListItems(i).SubItems(iKeyItem)) = lcallhandle Then
GetHandleItem = i
Exit For
End If
Next i
End Function
Public Sub UpdateCallState(ByVal lcallhandle As Long, ByVal strState As String)
Dim iItem As Long
iItem = GetHandleItem(lcallhandle)
If iItem > 0 Then
callList.ListItems(iItem).SubItems(callList.ColumnHeaders("State").SubItemIndex) = strState
End If
End Sub
Public Sub DeleteCallList(ByVal lcallhandle As Long)
Dim iItem As Long
iItem = GetHandleItem(lcallhandle)
If iItem > 0 Then
callList.ListItems.Remove iItem
End If
End Sub

Private Sub refuse_Click()
If callList.SelectedItem.Index <= 0 Then
    MsgBox "请选择要拒接的CC列表"
Else
    Dim lcallhandle As Long
    lcallhandle = CLng(callList.SelectedItem.SubItems(callList.ColumnHeaders("Key").SubItemIndex))
    If QNV_CCCtrl_Call(QNV_CCCTRL_CALL_REFUSE, lcallhandle, NULL_VB, -1) <= 0 Then
        MsgBox "拒接失败 " + Str(lcallhandle)
    End If
End If
End Sub

Private Sub stop_Click()
If callList.SelectedItem.Index <= 0 Then
    MsgBox "请选择要停止的CC列表"
Else
    Dim lcallhandle As Long
    lcallhandle = CLng(callList.SelectedItem.SubItems(callList.ColumnHeaders("Key").SubItemIndex))
    If QNV_CCCtrl_Call(QNV_CCCTRL_CALL_STOP, lcallhandle, NULL_VB, -1) <= 0 Then
        MsgBox "停止失败 " + Str(lcallhandle)
        DeleteCallList lcallhandle
    End If
End If
End Sub
Private Sub answer_Click()
If callList.SelectedItem.Index <= 0 Then
    MsgBox "请选择要接听的CC列表"
Else
    Dim lcallhandle As Long
    lcallhandle = CLng(callList.SelectedItem.SubItems(callList.ColumnHeaders("Key").SubItemIndex))
    If QNV_CCCtrl_Call(QNV_CCCTRL_CALL_ACCEPT, lcallhandle, NULL_VB, -1) <= 0 Then
        MsgBox "接听失败 " + Str(lcallhandle)
    End If
End If
End Sub

Private Sub busy_Click()
If callList.SelectedItem.Index <= 0 Then
    MsgBox "请选择要回复忙的CC列表"
Else
    Dim lcallhandle As Long
    lcallhandle = CLng(callList.SelectedItem.SubItems(callList.ColumnHeaders("Key").SubItemIndex))
    If QNV_CCCtrl_Call(QNV_CCCTRL_CALL_BUSY, lcallhandle, NULL_VB, -1) <= 0 Then
        MsgBox "回复忙失败 " + Str(lcallhandle)
    End If
End If
End Sub
