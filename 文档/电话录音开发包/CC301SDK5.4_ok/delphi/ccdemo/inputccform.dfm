object inputccd: Tinputccd
  Left = 297
  Top = 165
  Width = 285
  Height = 178
  Caption = #36755#20837'CC'
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
    Top = 40
    Width = 57
    Height = 17
    Caption = #30446#26631'CC:'
  end
  object destcc: TEdit
    Left = 96
    Top = 40
    Width = 161
    Height = 21
    TabOrder = 0
  end
  object idok: TButton
    Left = 32
    Top = 104
    Width = 97
    Height = 33
    Caption = #30830#23450
    TabOrder = 1
    OnClick = idokClick
  end
  object idcancel: TButton
    Left = 160
    Top = 104
    Width = 97
    Height = 33
    Caption = #21462#28040
    TabOrder = 2
    OnClick = idcancelClick
  end
end
