object sendfiled: Tsendfiled
  Left = 468
  Top = 168
  Width = 440
  Height = 232
  Caption = #21457#36865#25991#20214
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
    Left = 24
    Top = 32
    Width = 57
    Height = 13
    Caption = #30446#26631'CC:'
  end
  object Label2: TLabel
    Left = 16
    Top = 72
    Width = 65
    Height = 13
    Caption = #26412#22320#25991#20214':'
  end
  object destcc: TEdit
    Left = 88
    Top = 24
    Width = 161
    Height = 21
    TabOrder = 0
  end
  object transfile: TEdit
    Left = 88
    Top = 72
    Width = 257
    Height = 21
    TabOrder = 1
  end
  object selectfile: TButton
    Left = 352
    Top = 71
    Width = 73
    Height = 26
    Caption = #36873#25321
    TabOrder = 2
    OnClick = selectfileClick
  end
  object idok: TButton
    Left = 64
    Top = 144
    Width = 97
    Height = 33
    Caption = #30830#23450
    TabOrder = 3
    OnClick = idokClick
  end
  object idcancel: TButton
    Left = 240
    Top = 144
    Width = 105
    Height = 33
    Caption = #21462#28040
    TabOrder = 4
    OnClick = idcancelClick
  end
  object selectlocalfile: TOpenDialog
    Filter = 'all files|*.*'
    Left = 88
    Top = 96
  end
end
