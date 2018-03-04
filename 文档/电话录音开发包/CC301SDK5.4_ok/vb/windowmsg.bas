Attribute VB_Name = "windowmsg"
    '参考文献
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
                                     AddressOf WindowProc) '用 AddressOf 取出的函数地址，这个函数必须在 VB 的标准模块中。
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
            Case BRI_EVENT_MESSAGE 'cc301设备消息
                'Dim EventData As TBriEvent_Data
                'CopyMemory EventData, ByVal lParam, Len(EventData) '获取结构体数据
                'mainform.ProcEvent ByVal VarPtr(EventData)
                mainform.ProcEvent ByVal lParam
            Case Else
                WindowProc = CallWindowProc(lpPrevWndProc, hw, _
                                           uMsg, wParam, lParam) '返回值
        End Select
    End Function
