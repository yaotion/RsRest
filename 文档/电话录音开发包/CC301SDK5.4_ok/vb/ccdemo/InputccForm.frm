VERSION 5.00
Begin VB.Form InputccForm 
   Caption         =   "����Ŀ��CC"
   ClientHeight    =   1740
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   4290
   LinkTopic       =   "Form1"
   ScaleHeight     =   1740
   ScaleWidth      =   4290
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton IDCANCEL 
      Caption         =   "ȡ��"
      Height          =   495
      Left            =   2640
      TabIndex        =   3
      Top             =   1080
      Width           =   1335
   End
   Begin VB.CommandButton IDOK 
      Caption         =   "ȷ��"
      Height          =   495
      Left            =   840
      TabIndex        =   2
      Top             =   1080
      Width           =   1215
   End
   Begin VB.TextBox DestCC 
      Height          =   375
      Left            =   1320
      TabIndex        =   1
      Top             =   360
      Width           =   2535
   End
   Begin VB.Label Label1 
      Caption         =   "Ŀ��CC��"
      Height          =   255
      Left            =   360
      TabIndex        =   0
      Top             =   360
      Width           =   855
   End
End
Attribute VB_Name = "InputccForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub IDCANCEL_Click()
Unload Me
End Sub

Private Sub IDOK_Click()
If DestCC.Text = "" Then
    MsgBox "������Ŀ��CC"
Else
    Dim lcallhandle As Long
    lcallhandle = QNV_CCCtrl_Call(QNV_CCCTRL_CALL_START, 0, DestCC.Text, 0)
    If lcallhandle <= 0 Then
        MsgBox "����ʧ��"
    Else
        MsgBox "�Ѻ���"
        Unload Me
    End If
End If
End Sub
