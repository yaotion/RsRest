object FrmEditCallWorkTime: TFrmEditCallWorkTime
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #20462#25913#21483#29677#26102#38388
  ClientHeight = 192
  ClientWidth = 371
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 25
    Top = 65
    Width = 86
    Height = 19
    Caption = #21407#21483#29677#26102#38388':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 25
    Top = 108
    Width = 86
    Height = 19
    Caption = #26032#21483#29677#26102#38388':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 23
    Top = 23
    Width = 90
    Height = 19
    Caption = #24320' '#36710'  '#26102' '#38388':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object dtpDay: TRzDateTimePicker
    Left = 119
    Top = 104
    Width = 117
    Height = 27
    Date = 41969.616881689810000000
    Time = 41969.616881689810000000
    DateMode = dmUpDown
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 0
  end
  object edtSourceDateTime: TRzEdit
    Left = 119
    Top = 61
    Width = 219
    Height = 27
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 1
  end
  object dtpTime: TRzDateTimePicker
    Left = 235
    Top = 104
    Width = 103
    Height = 27
    Date = 41969.616881689810000000
    Time = 41969.616881689810000000
    DateMode = dmUpDown
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    Kind = dtkTime
    ParentFont = False
    TabOrder = 2
  end
  object btnOK: TButton
    Left = 145
    Top = 151
    Width = 82
    Height = 33
    Caption = #30830#23450
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 253
    Top = 151
    Width = 82
    Height = 33
    Caption = #21462#28040
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = btnCancelClick
  end
  object edtWaitWorkTIme: TRzEdit
    Left = 119
    Top = 20
    Width = 219
    Height = 27
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 5
  end
end
