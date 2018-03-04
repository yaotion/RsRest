object FrmMunualMonitor: TFrmMunualMonitor
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #30417#21548#25151#38388
  ClientHeight = 598
  ClientWidth = 720
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    720
    598)
  PixelsPerInch = 96
  TextHeight = 19
  object lbl1: TLabel
    Left = 16
    Top = 12
    Width = 100
    Height = 19
    Caption = #26597#25214#25151#38388#65306
    Font.Charset = ANSI_CHARSET
    Font.Color = clRed
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl2: TLabel
    Left = 295
    Top = 12
    Width = 48
    Height = 19
    Caption = #36710#27425':'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object lbl_Nofity: TLabel
    Left = 551
    Top = 13
    Width = 92
    Height = 17
    Caption = '6'#31186#21518#33258#21160#20851#38381
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -14
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object btnConnect: TButton
    Left = 15
    Top = 46
    Width = 118
    Height = 32
    Caption = #30417#21548#25151#38388
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = btnConnectClick
  end
  object btnSysVoice: TButton
    Left = 545
    Top = 414
    Width = 128
    Height = 32
    Caption = #25773#25918#21483#29677#38899#20048
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    Visible = False
    OnClick = btnSysVoiceClick
  end
  object edtRoomNum: TEdit
    Left = 126
    Top = 8
    Width = 131
    Height = 27
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 0
    Text = '1'
    OnChange = edtRoomNumChange
  end
  object edtTrainNo: TEdit
    Left = 343
    Top = 8
    Width = 134
    Height = 27
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 8
    Text = 'T112'
  end
  object btnDisconnect: TButton
    Left = 283
    Top = 46
    Width = 118
    Height = 32
    Caption = #25346#26029#35774#22791
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = btnDisconnectClick
  end
  object btnClose: TButton
    Left = 154
    Top = 46
    Width = 106
    Height = 33
    Caption = #20851'  '#38381
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = btnCloseClick
  end
  object mmoState: TMemo
    Left = 8
    Top = 499
    Width = 681
    Height = 78
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 7
  end
  object chkSaveVoice: TCheckBox
    Left = 551
    Top = 53
    Width = 113
    Height = 17
    Caption = #20445#23384#24405#38899
    Checked = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 5
  end
  object ListView1: TListView
    Left = 8
    Top = 84
    Width = 681
    Height = 396
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = #25151#38388#21495
        Width = 200
      end
      item
        Caption = #35774#22791#21495
        Width = 200
      end>
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = #23435#20307
    Font.Style = []
    GridLines = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    TabOrder = 6
    ViewStyle = vsReport
    OnClick = ListView1Click
  end
  object tmrAutoClose: TTimer
    Enabled = False
    OnTimer = tmrAutoCloseTimer
    Left = 655
    Top = 58
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 352
    Top = 296
  end
end
