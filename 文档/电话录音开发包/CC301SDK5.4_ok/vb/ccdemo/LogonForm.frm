VERSION 5.00
Begin VB.Form LogonForm 
   Caption         =   "µ«¬ΩCC"
   ClientHeight    =   3360
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   4815
   LinkTopic       =   "Form1"
   ScaleHeight     =   3360
   ScaleWidth      =   4815
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton IDCANCEL 
      Caption         =   "»°œ˚"
      Height          =   495
      Left            =   2880
      TabIndex        =   6
      Top             =   2640
      Width           =   1335
   End
   Begin VB.CommandButton IDOK 
      Caption         =   "»∑∂®"
      Height          =   495
      Left            =   720
      TabIndex        =   5
      Top             =   2640
      Width           =   1215
   End
   Begin VB.Frame Frame1 
      Caption         =   "µ«¬Ω"
      Height          =   2055
      Left            =   360
      TabIndex        =   0
      Top             =   240
      Width           =   3975
      Begin VB.TextBox PWD 
         Height          =   375
         IMEMode         =   3  'DISABLE
         Left            =   960
         PasswordChar    =   "*"
         TabIndex        =   4
         Top             =   1080
         Width           =   2295
      End
      Begin VB.TextBox CC 
         Height          =   375
         Left            =   960
         TabIndex        =   3
         Top             =   480
         Width           =   2295
      End
      Begin VB.Label Label2 
         Caption         =   "√‹¬Î£∫"
         Height          =   255
         Left            =   240
         TabIndex        =   2
         Top             =   1200
         Width           =   615
      End
      Begin VB.Label Label1 
         Caption         =   "CC£∫"
         Height          =   255
         Left            =   360
         TabIndex        =   1
         Top             =   480
         Width           =   495
      End
   End
End
Attribute VB_Name = "LogonForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub IDCANCEL_Click()
CC.Text = ""
PWD.Text = ""
Unload Me
End Sub

Private Sub IDOK_Click()
Dim strValue As String
If CC.Text = "" Then
    MsgBox "«Î ‰»ÎCC∫≈"
ElseIf PWD.Text = "" Then
    MsgBox "«Î ‰»Î√‹¬Î"
Else
    strValue = CC.Text + "," + PWD.Text '','∑÷∏Ù
    If QNV_CCCtrl(QNV_CCCTRL_LOGIN, strValue, 0) <= 0 Then 'ø™ ºµ«¬Ω
         MsgBox "µ«¬ΩCC ß∞‹"
     Else
        Unload Me
        End If
End If
End Sub
