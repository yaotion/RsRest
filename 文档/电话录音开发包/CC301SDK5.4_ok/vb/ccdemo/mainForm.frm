VERSION 5.00
Begin VB.Form mainform 
   Caption         =   "CC���缴ʱ��Ϣ/�ļ�����/P2P���� VB������ʾ1.1"
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
      Caption         =   "������Գ�����ʾδ�ҵ�qnviccub.dll,��ӿ�������binĿ¼����qnviccub.dll��bridge.dll�����̵���Ŀ¼��һ��Ĭ���Ǳ����̵�Ŀ¼"
      Height          =   255
      Left            =   240
      TabIndex        =   1
      Top             =   120
      Width           =   10575
   End
   Begin VB.Menu ID_MENU_FILE 
      Caption         =   "�ļ�"
      Index           =   0
      Begin VB.Menu ID_MENU_LOGON 
         Caption         =   "��½CC"
         Index           =   0
      End
      Begin VB.Menu ID_MENU_OFFLINE 
         Caption         =   "����"
         Index           =   1
      End
      Begin VB.Menu ID_MENU_REGCC 
         Caption         =   "ע��CC"
         Index           =   2
      End
   End
   Begin VB.Menu ID_MENU_OPERATOR 
      Caption         =   "����"
      Index           =   1
      Begin VB.Menu ID_MENU_SENDMSG 
         Caption         =   "������Ϣ"
         Index           =   0
      End
      Begin VB.Menu ID_MENU_SENDCMD 
         Caption         =   "��������"
         Index           =   1
      End
      Begin VB.Menu ID_MENU_SENDCALL 
         Caption         =   "������������"
         Index           =   2
      End
      Begin VB.Menu ID_MENU_SENDFILE 
         Caption         =   "�����ļ�"
         Index           =   3
      End
   End
   Begin VB.Menu ID_MENU_PARAM 
      Caption         =   "����"
      Index           =   2
      Begin VB.Menu ID_MENU_SETSVRADDR 
         Caption         =   "���÷�����IP��ַ"
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
lpPrevWndProc = 0 '��û�н��մ�����Ϣ��Ĭ�ϳ�ʼΪ0
gHW = Me.hWnd '���ý�����Ϣ�Ĵ���ֵ ��windowsmsg.bas ģ��
If QNV_OpenDevice(ODT_CC, 0, QNV_CC_LICENSE) > 0 Then
    ShowMsg "����CCģ��ɹ�"
    Hook
    QNV_Event CCCTRL_CHANNELID, QNV_EVENT_REGWND, Me.hWnd, NULL_VB, NULL_VB, 0
Else
    ShowMsg "����CCģ��ʧ��"
End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
UnHook
Dim frm     As Form
  For Each frm In Forms
        Unload frm
  Next
QNV_CloseDevice ODT_ALL, 0 '�ر����д򿪵��豸����������ֻ����CCģ�飬Ҳ�͵�Ч��QNV_CloseDevice ODT_CC, 0
ShowMsg "CCģ���ѹر�"
End Sub

Public Sub ProcEvent(ByVal lParam As Long) 'ByRef pEventData As TBriEvent_Data
    Dim EventData As TBriEvent_Data
    Dim szChannel As String
    Dim strData As String
    CopyMemory EventData, ByVal lParam, Len(EventData) '��ȡ�ṹ������
    szChannel = "ͨ��" + Str(EventData.uChannelID + 1) + ": "
    Select Case EventData.lEventType
        Case BriEvent_CC_ConnectFailed
            ShowMsg "���ӷ�����ʧ��"
        Case BriEvent_CC_LoginFailed
            ShowMsg "��½ʧ�� ԭ��=" + Str(EventData.lResult)
        Case BriEvent_CC_LoginSuccess
            ShowMsg "��½�ɹ�"
        Case BriEvent_CC_SystemTimeErr
            ShowMsg "����ϵͳʱ�����"
        Case BriEvent_CC_CallIn
            ShowMsg "CC������������"
            CallForm.Show vbModeless, Me
            CallForm.AppendCallIn EventData.lEventHandle, EventData.szData
        Case BriEvent_CC_CallOutSuccess
            ShowMsg "CC�������ں���"
            SendmsgForm.Show vbModeless, Me
            CallForm.AppendCallOut EventData.lEventHandle, EventData.szData
            CallForm.UpdateCallState EventData.lEventHandle, "���ں���"
        Case BriEvent_CC_CallOutFailed
            ShowMsg "CC��������ʧ��"
            SendmsgForm.Show vbModeless, Me
            CallForm.UpdateCallState EventData.lEventHandle, "����ʧ��"
        Case BriEvent_CC_ReplyBusy
            ShowMsg "CC�Է��ظ�æ"
        Case BriEvent_CC_Connected
            ShowMsg "CC�����Ѿ���ͨ"
            CallForm.UpdateCallState EventData.lEventHandle, "����ͨ"
        Case BriEvent_CC_CallFinished
            ShowMsg "CC�������н���"
            CallForm.UpdateCallState EventData.lEventHandle, "�ѽ���"
            CallForm.DeleteCallList EventData.lEventHandle
        Case BriEvent_CC_RecvedMsg
            ShowMsg "���յ���Ϣ"
            SendmsgForm.Show vbModeless, Me
            SendmsgForm.ProcRecvMsg EventData.szData
        Case BriEvent_CC_RecvedCmd
            ShowMsg "���յ�����"
            SendCmdForm.Show vbModeless, Me
            SendCmdForm.ProcRecvCmd EventData.szData
        Case BriEvent_CC_RecvFileRequest
            ShowMsg "���յ��ļ�����"
        Case BriEvent_CC_TransFileFinished
            ShowMsg "�����ļ�����"
        Case BriEvent_CC_RegSuccess
            ShowMsg "ע��CC�ɹ�"
        Case BriEvent_CC_RegFailed
            ShowMsg "ע��CCʧ��"
        Case BriEvent_CC_ContactUpdateStatus
            strData = EventData.szData
            Replace strData, MSG_KEY_SPLIT, "|" ' list ������ʾ����
            ShowMsg "��ȡ���û�״̬: " + strData
    Case Else
        ShowMsg szChannel + "���Դ�����Ϣ id=" + Str(EventData.lEventType) '������ʾ����
    End Select
End Sub
Private Sub ID_MENU_LOGON_Click(Index As Integer)
LogonForm.Show vbModal, Me ' vbModeless /vbModal
End Sub

Private Sub ID_MENU_OFFLINE_Click(Index As Integer)
QNV_CCCtrl QNV_CCCTRL_LOGOUT, NULL_VB, 0
ShowMsg "������"
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
