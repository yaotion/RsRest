object frmTuDingTimeRange: TfrmTuDingTimeRange
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #26102#38388#36873#25321
  ClientHeight = 169
  ClientWidth = 437
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 23
  object RzGroupBox1: TRzGroupBox
    Left = 8
    Top = 8
    Width = 419
    Height = 113
    Caption = #35831#36873#25321#26102#38388#33539#22260
    TabOrder = 0
    object Label1: TLabel
      Left = 40
      Top = 35
      Width = 83
      Height = 23
      Caption = #24320#22987#26102#38388':'
    end
    object Label2: TLabel
      Left = 40
      Top = 72
      Width = 83
      Height = 23
      Caption = #32467#26463#26102#38388':'
    end
    object dtBeginDatePicker: TRzDateTimePicker
      Left = 129
      Top = 34
      Width = 144
      Height = 31
      Date = 41576.580392789350000000
      Format = 'yyy-MM-dd'
      Time = 41576.580392789350000000
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      TabOrder = 0
      FramingPreference = fpCustomFraming
    end
    object dtBeginTimePicker: TRzDateTimePicker
      Left = 279
      Top = 34
      Width = 114
      Height = 31
      Date = 41576.000011574080000000
      Time = 41576.000011574080000000
      DateMode = dmUpDown
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      Kind = dtkTime
      TabOrder = 1
      FramingPreference = fpCustomFraming
    end
    object dtEndDatePicker: TRzDateTimePicker
      Left = 129
      Top = 71
      Width = 144
      Height = 31
      Date = 41576.580392789350000000
      Format = 'yyy-MM-dd'
      Time = 41576.580392789350000000
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      TabOrder = 2
      FramingPreference = fpCustomFraming
    end
    object dtEndTimePicker: TRzDateTimePicker
      Left = 279
      Top = 71
      Width = 114
      Height = 31
      Date = 41576.999988425920000000
      Time = 41576.999988425920000000
      DateMode = dmUpDown
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      Kind = dtkTime
      TabOrder = 3
      FramingPreference = fpCustomFraming
    end
  end
  object Button1: TButton
    Left = 245
    Top = 127
    Width = 75
    Height = 34
    Caption = #30830#23450
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 326
    Top = 127
    Width = 75
    Height = 34
    Caption = #21462#28040
    TabOrder = 2
    OnClick = Button2Click
  end
end
