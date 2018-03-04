object cccontactd: Tcccontactd
  Left = 605
  Top = 213
  Width = 373
  Height = 228
  Caption = #22909#21451
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
    Width = 39
    Height = 13
    Caption = 'cc'#21495#30721':'
  end
  object CCCode: TEdit
    Left = 96
    Top = 24
    Width = 201
    Height = 21
    TabOrder = 0
  end
  object add: TButton
    Left = 96
    Top = 64
    Width = 73
    Height = 25
    Caption = #28155#21152
    TabOrder = 1
    OnClick = addClick
  end
  object del: TButton
    Left = 208
    Top = 64
    Width = 81
    Height = 25
    Caption = #21024#38500
    TabOrder = 2
    OnClick = delClick
  end
  object closeform: TButton
    Left = 232
    Top = 136
    Width = 121
    Height = 41
    Caption = #20851#38381
    TabOrder = 3
    OnClick = closeformClick
  end
end
