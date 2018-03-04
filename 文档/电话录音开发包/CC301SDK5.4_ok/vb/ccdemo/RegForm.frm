VERSION 5.00
Begin VB.Form RegForm 
   Caption         =   "注册CC"
   ClientHeight    =   5835
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   7110
   LinkTopic       =   "Form1"
   ScaleHeight     =   5835
   ScaleWidth      =   7110
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox svrid 
      Height          =   375
      Left            =   1560
      TabIndex        =   9
      Top             =   2520
      Width           =   2535
   End
   Begin VB.TextBox ccnick 
      Height          =   375
      Left            =   1560
      TabIndex        =   8
      Top             =   1800
      Width           =   2535
   End
   Begin VB.TextBox ccpwd 
      Height          =   375
      IMEMode         =   3  'DISABLE
      Left            =   1560
      PasswordChar    =   "*"
      TabIndex        =   7
      Top             =   960
      Width           =   2535
   End
   Begin VB.TextBox cccode 
      Height          =   375
      Left            =   1560
      TabIndex        =   6
      Top             =   240
      Width           =   2535
   End
   Begin VB.CommandButton IDCANCEL 
      Caption         =   "取消"
      Height          =   495
      Left            =   4320
      TabIndex        =   5
      Top             =   5160
      Width           =   1455
   End
   Begin VB.CommandButton IDOK 
      Caption         =   "注册"
      Height          =   495
      Left            =   960
      TabIndex        =   4
      Top             =   5160
      Width           =   1455
   End
   Begin VB.Label Label9 
      Caption         =   "4.找到运行参数设置界面，在这里找到""服务器注册校验ID""设置"
      Height          =   255
      Left            =   1560
      TabIndex        =   14
      Top             =   4560
      Width           =   5175
   End
   Begin VB.Label Label8 
      Caption         =   "3.登录管理界面"
      Height          =   255
      Left            =   1560
      TabIndex        =   13
      Top             =   4200
      Width           =   3135
   End
   Begin VB.Label Label7 
      Caption         =   "2.在IE输入http://设备的IP:8000"
      Height          =   255
      Left            =   1560
      TabIndex        =   12
      Top             =   3840
      Width           =   3255
   End
   Begin VB.Label Label6 
      Caption         =   "1.先知道设备的IP"
      Height          =   255
      Left            =   1560
      TabIndex        =   11
      Top             =   3480
      Width           =   3135
   End
   Begin VB.Label Label5 
      Caption         =   "如何获取服务器ID:"
      Height          =   255
      Left            =   1560
      TabIndex        =   10
      Top             =   3120
      Width           =   1695
   End
   Begin VB.Label Label4 
      Caption         =   "服务器ID："
      Height          =   255
      Left            =   480
      TabIndex        =   3
      Top             =   2640
      Width           =   975
   End
   Begin VB.Label Label3 
      Caption         =   "昵称："
      Height          =   255
      Left            =   720
      TabIndex        =   2
      Top             =   1920
      Width           =   615
   End
   Begin VB.Label Label2 
      Caption         =   "CC密码："
      Height          =   255
      Left            =   600
      TabIndex        =   1
      Top             =   1080
      Width           =   855
   End
   Begin VB.Label Label1 
      Caption         =   "cc号码："
      Height          =   255
      Left            =   600
      TabIndex        =   0
      Top             =   360
      Width           =   855
   End
End
Attribute VB_Name = "RegForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub IDCANCEL_Click()
Unload Me
End Sub

Private Sub IDOK_Click()
If cccode.Text = "" Then
    MsgBox "CC号码不能为空"
ElseIf InStr(cccode.Text, ",") Then '不能输入','
    MsgBox "CC不能有逗号"
ElseIf ccpwd.Text = "" Then
    MsgBox "密码不能为空"
ElseIf InStr(ccpwd.Text, ",") Then '不能输入','
    MsgBox "密码不能有逗号"
ElseIf ccnick.Text = "" Then
    MsgBox "昵称不能为空"
ElseIf InStr(ccnick.Text, ",") Then ' 不能输入','
    MsgBox "昵称不能有逗号"
ElseIf InStr(svrid.Text, ",") Then ' 不能输入','
    MsgBox "服务器ID不能有逗号"
Else
    Dim strValue As String
    strValue = cccode.Text + "," + ccpwd.Text + "," + ccnick.Text + "," + svrid.Text ' ','分隔
    If QNV_CCCtrl(QNV_CCCTRL_REGCC, strValue, 0) <= 0 Then
        MsgBox "注册失败"
    Else
        MsgBox "开始注册..."
        Unload Me
    End If
End If
End Sub

