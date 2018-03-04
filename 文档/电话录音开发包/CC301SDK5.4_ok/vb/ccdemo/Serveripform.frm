VERSION 5.00
Begin VB.Form SetServeripform 
   Caption         =   "设置服务器地址"
   ClientHeight    =   2700
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   5790
   LinkTopic       =   "Form1"
   ScaleHeight     =   2700
   ScaleWidth      =   5790
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton IDCANCEL 
      Caption         =   "取消"
      Height          =   495
      Left            =   3840
      TabIndex        =   4
      Top             =   1920
      Width           =   1095
   End
   Begin VB.CommandButton IDOK 
      Caption         =   "确定"
      Height          =   495
      Left            =   1680
      TabIndex        =   3
      Top             =   1920
      Width           =   1215
   End
   Begin VB.TextBox serverip 
      Height          =   375
      Left            =   1920
      TabIndex        =   1
      Top             =   360
      Width           =   3375
   End
   Begin VB.Label Label2 
      Caption         =   "(如果没有输入IP,系统自动设置为默认测试服务器地址,该服务器不能被注册 CC)"
      Height          =   615
      Left            =   1920
      TabIndex        =   2
      Top             =   960
      Width           =   3615
   End
   Begin VB.Label Label1 
      Caption         =   "服务器IP地址："
      Height          =   375
      Left            =   360
      TabIndex        =   0
      Top             =   360
      Width           =   1335
   End
End
Attribute VB_Name = "SetServeripform"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub IDCANCEL_Click()
Unload Me
End Sub

Private Sub IDOK_Click()
 If QNV_CCCtrl(QNV_CCCTRL_ISLOGON, NULL_VB, 0) > 0 Then
    MsgBox "已经登陆不能修改服务器地址,请先离线"
    Unload Me
Else
    If QNV_CCCtrl(QNV_CCCTRL_SETSERVER, serverip.Text, 0) <= 0 Then
        MsgBox "修改服务器IP地址失败"
    Else
        MsgBox "修改服务器IP地址完成,可以重新登陆.."
        Unload Me
    End If
End If
End Sub
