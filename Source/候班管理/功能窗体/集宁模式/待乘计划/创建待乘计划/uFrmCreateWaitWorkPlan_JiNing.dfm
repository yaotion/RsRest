object TFrmCreateWaitWorkPlan_JiNing: TTFrmCreateWaitWorkPlan_JiNing
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #21019#24314#35745#21010
  ClientHeight = 195
  ClientWidth = 512
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 19
  object lbl3: TLabel
    Left = 31
    Top = 102
    Width = 86
    Height = 19
    Caption = #24320#36710#26102#38388':'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object lbl4: TLabel
    Left = 31
    Top = 66
    Width = 86
    Height = 19
    Caption = #21483#29677#26102#38388':'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object lbl2: TLabel
    Left = 321
    Top = 31
    Width = 48
    Height = 19
    Caption = #25151#38388':'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object lbl1: TLabel
    Left = 30
    Top = 31
    Width = 78
    Height = 19
    Caption = #36710'   '#27425':'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object chk_UseWaitWork: TCheckBox
    Left = 122
    Top = 100
    Width = 69
    Height = 22
    Caption = #21551#29992
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 5
    OnClick = chk_UseWaitWorkClick
  end
  object chk_UseCallWork: TCheckBox
    Left = 121
    Top = 65
    Width = 63
    Height = 22
    Caption = #21551#29992
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = chk_UseCallWorkClick
  end
  object dtpJiaoBanDay: TDateTimePicker
    Left = 195
    Top = 62
    Width = 145
    Height = 27
    Date = 41947.461762893520000000
    Time = 41947.461762893520000000
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 3
  end
  object dtpHouBanDay: TDateTimePicker
    Left = 195
    Top = 98
    Width = 145
    Height = 27
    Date = 41947.461762893520000000
    Time = 41947.461762893520000000
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 6
  end
  object dtpHouBanTime: TDateTimePicker
    Left = 358
    Top = 98
    Width = 100
    Height = 27
    Date = 41947.462292407410000000
    Format = 'HH:mm'
    Time = 41947.462292407410000000
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    Kind = dtkTime
    ParentFont = False
    TabOrder = 7
  end
  object dtpJiaoBanTime: TDateTimePicker
    Left = 358
    Top = 62
    Width = 100
    Height = 27
    Date = 41947.837291666660000000
    Format = 'HH:mm'
    Time = 41947.837291666660000000
    DateFormat = dfLong
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    Kind = dtkTime
    ParentFont = False
    TabOrder = 4
  end
  object btnCancel: TButton
    Left = 367
    Top = 142
    Width = 90
    Height = 34
    Caption = #21462#28040
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    OnClick = btnCancelClick
  end
  object btnOK: TButton
    Left = 265
    Top = 142
    Width = 90
    Height = 34
    Caption = #30830#23450
    Default = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    OnClick = btnOKClick
  end
  object edtRoom: TEdit
    Left = 380
    Top = 27
    Width = 78
    Height = 27
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
  end
  object edtCheCi: TEdit
    Left = 125
    Top = 27
    Width = 190
    Height = 27
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 0
    OnChange = edtCheCiChange
  end
end
