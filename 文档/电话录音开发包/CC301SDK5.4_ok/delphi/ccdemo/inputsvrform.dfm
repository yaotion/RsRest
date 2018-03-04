object inputsvrd: Tinputsvrd
  Left = 265
  Top = 236
  Width = 394
  Height = 237
  Caption = #36755#20837#26381#21153#22120#22320#22336
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 32
    Width = 73
    Height = 13
    Caption = #26381#21153#22120'IP'#22320#22336':'
  end
  object Label2: TLabel
    Left = 136
    Top = 72
    Width = 225
    Height = 57
    AutoSize = False
    Caption = '('#22914#26524#27809#26377#36755#20837'IP,'#31995#32479#33258#21160#35774#32622#20026#40664#35748#27979#35797#26381#21153#22120#22320#22336','#35813#26381#21153#22120#19981#33021#34987#27880#20876' CC)'
    WordWrap = True
  end
  object ipaddr: TEdit
    Left = 136
    Top = 32
    Width = 201
    Height = 21
    TabOrder = 0
  end
  object idok: TButton
    Left = 80
    Top = 144
    Width = 113
    Height = 41
    Caption = #30830#23450
    TabOrder = 1
    OnClick = idokClick
  end
  object idcancel: TButton
    Left = 224
    Top = 144
    Width = 113
    Height = 41
    Caption = #21462#28040
    TabOrder = 2
    OnClick = idcancelClick
  end
end
