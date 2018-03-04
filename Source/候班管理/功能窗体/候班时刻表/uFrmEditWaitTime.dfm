object FrmEditWaitTime: TFrmEditWaitTime
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #32534#36753#20505#29677#34920
  ClientHeight = 213
  ClientWidth = 481
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
  object lbl3: TLabel
    Left = 17
    Top = 34
    Width = 68
    Height = 19
    Caption = #36710'      '#27425':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl8: TLabel
    Left = 17
    Top = 76
    Width = 70
    Height = 19
    Caption = #20505#29677#26102#38388':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl4: TLabel
    Left = 236
    Top = 75
    Width = 70
    Height = 19
    Caption = #21483#29677#26102#38388':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl5: TLabel
    Left = 17
    Top = 118
    Width = 70
    Height = 19
    Caption = #20986#21220#26102#38388':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl6: TLabel
    Left = 236
    Top = 117
    Width = 70
    Height = 19
    Caption = #24320#36710#26102#38388':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl2: TLabel
    Left = 236
    Top = 34
    Width = 74
    Height = 19
    Caption = #25151'  '#38388'  '#21495':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl10: TLabel
    Left = 16
    Top = 155
    Width = 70
    Height = 19
    Caption = #24378#20241#27169#24335':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object edtCheci: TEdit
    Left = 92
    Top = 31
    Width = 120
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 0
  end
  object edtHouBan: TRzDateTimeEdit
    Left = 92
    Top = 72
    Width = 120
    Height = 27
    EditType = etTime
    Format = 'hh:nn:ss'
    DropButtonVisible = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 2
  end
  object edtJiaoBan: TRzDateTimeEdit
    Left = 320
    Top = 72
    Width = 120
    Height = 27
    EditType = etTime
    Format = 'hh:nn:ss'
    DropButtonVisible = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 3
  end
  object edtChuQin: TRzDateTimeEdit
    Left = 92
    Top = 114
    Width = 120
    Height = 27
    EditType = etTime
    Format = 'hh:nn:ss'
    DropButtonVisible = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 4
  end
  object edtKaiche: TRzDateTimeEdit
    Left = 320
    Top = 114
    Width = 120
    Height = 27
    EditType = etTime
    Format = 'hh:nn:ss'
    DropButtonVisible = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 5
  end
  object btnOK: TButton
    Left = 234
    Top = 157
    Width = 88
    Height = 33
    Caption = #30830#23450
    TabOrder = 6
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 352
    Top = 157
    Width = 88
    Height = 33
    Caption = #21462#28040
    TabOrder = 7
    OnClick = btnCancelClick
  end
  object edtRoomNum: TEdit
    Left = 320
    Top = 31
    Width = 120
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 1
  end
  object chk_MustSleep: TCheckBox
    Left = 92
    Top = 155
    Width = 97
    Height = 17
    Caption = #21551#29992
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
  end
end
