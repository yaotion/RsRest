object FrmCreateWaitWorkPlan: TFrmCreateWaitWorkPlan
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #21019#24314#35745#21010
  ClientHeight = 253
  ClientWidth = 460
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbl4: TLabel
    Left = 15
    Top = 171
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
  object lbl3: TLabel
    Left = 15
    Top = 134
    Width = 86
    Height = 19
    Caption = #20505#29677#26102#38388':'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object lbl1: TLabel
    Left = 14
    Top = 95
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
  object lbl2: TLabel
    Left = 305
    Top = 95
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
  object lbl5: TLabel
    Left = 17
    Top = 21
    Width = 78
    Height = 19
    Caption = #36710'   '#38388':'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object lbl6: TLabel
    Left = 16
    Top = 57
    Width = 78
    Height = 19
    Caption = #20132'   '#36335':'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object lbl7: TLabel
    Left = 305
    Top = 57
    Width = 48
    Height = 19
    Caption = #31616#31216':'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object dtpJiaoBanDay: TDateTimePicker
    Left = 179
    Top = 167
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
    TabOrder = 1
  end
  object dtpJiaoBanTime: TDateTimePicker
    Left = 342
    Top = 167
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
    TabOrder = 2
  end
  object dtpHouBanTime: TDateTimePicker
    Left = 342
    Top = 130
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
    TabOrder = 4
  end
  object dtpHouBanDay: TDateTimePicker
    Left = 179
    Top = 130
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
    TabOrder = 3
  end
  object btnOK: TButton
    Left = 249
    Top = 206
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
    TabOrder = 5
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 351
    Top = 206
    Width = 90
    Height = 34
    Caption = #21462#28040
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = btnCancelClick
  end
  object edtCheCi: TEdit
    Left = 109
    Top = 86
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
  object edtRoom: TEdit
    Left = 364
    Top = 91
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
    TabOrder = 7
  end
  object cbbCheJian: TComboBox
    Left = 109
    Top = 17
    Width = 332
    Height = 27
    Style = csDropDownList
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ItemHeight = 19
    ParentFont = False
    TabOrder = 8
    OnChange = cbbCheJianChange
  end
  object cbbJiaoLu: TComboBox
    Left = 109
    Top = 53
    Width = 190
    Height = 27
    Style = csDropDownList
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ItemHeight = 19
    ParentFont = False
    TabOrder = 9
  end
  object edtJiaoLuNickName: TEdit
    Left = 364
    Top = 53
    Width = 78
    Height = 27
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 10
  end
  object chk_UseCallWork: TCheckBox
    Left = 105
    Top = 170
    Width = 63
    Height = 22
    Caption = #21551#29992
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 11
    OnClick = chk_UseCallWorkClick
  end
  object chk_UseWaitWork: TCheckBox
    Left = 106
    Top = 132
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
    TabOrder = 12
    OnClick = chk_UseWaitWorkClick
  end
end
