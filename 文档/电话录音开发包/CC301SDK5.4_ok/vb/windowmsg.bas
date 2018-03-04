Attribute VB_Name = "windowmsg"
    '�ο�����
    'http://support.microsoft.com/kb/q170570/
    Option Explicit
    Global lpPrevWndProc As Long
    Global gHW As Long
    Public Const GWL_WNDPROC = -4
    
    Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" _
           (ByVal lpPrevWndFunc As Long, _
            ByVal hWnd As Long, _
            ByVal Msg As Long, _
            ByVal wParam As Long, _
            ByVal lParam As Long) As Long

    Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" _
           (ByVal hWnd As Long, _
            ByVal nIndex As Long, _
            ByVal dwNewLong As Long) As Long
            
   Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (dest As _
          Any, source As Any, ByVal bytes As Long)
          
    Public Sub Hook()
        lpPrevWndProc = SetWindowLong(gHW, GWL_WNDPROC, _
                                     AddressOf WindowProc) '�� AddressOf ȡ���ĺ�����ַ��������������� VB �ı�׼ģ���С�
    End Sub
    Public Sub UnHook()
        If lpPrevWndProc <> 0 Then
        Dim lngReturnValue As Long
        lngReturnValue = SetWindowLong(gHW, GWL_WNDPROC, lpPrevWndProc)
        End If
    End Sub
    Function WindowProc(ByVal hw As Long, _
                        ByVal uMsg As Long, _
                        ByVal wParam As Long, _
                        ByVal lParam As Long) As Long

        Select Case uMsg
            Case BRI_EVENT_MESSAGE 'cc301�豸��Ϣ
                'Dim EventData As TBriEvent_Data
                'CopyMemory EventData, ByVal lParam, Len(EventData) '��ȡ�ṹ������
                'mainform.ProcEvent ByVal VarPtr(EventData)
                mainform.ProcEvent ByVal lParam
            Case Else
                WindowProc = CallWindowProc(lpPrevWndProc, hw, _
                                           uMsg, wParam, lParam) '����ֵ
        End Select
    End Function
