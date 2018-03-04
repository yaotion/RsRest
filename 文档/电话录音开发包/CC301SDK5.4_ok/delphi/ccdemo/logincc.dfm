object Loginwin: TLoginwin
  Left = 807
  Top = 199
  Width = 370
  Height = 251
  Caption = #30331#38470'CC'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object logon: TGroupBox
    Left = 56
    Top = 16
    Width = 257
    Height = 121
    Caption = #30331#38470
    TabOrder = 0
    object Label1: TLabel
      Left = 32
      Top = 32
      Width = 29
      Height = 13
      Caption = 'CC'#21495':'
    end
    object Label2: TLabel
      Left = 32
      Top = 72
      Width = 27
      Height = 13
      Caption = #23494#30721':'
    end
    object cccode: TEdit
      Left = 72
      Top = 32
      Width = 145
      Height = 21
      TabOrder = 0
    end
    object ccpwd: TEdit
      Left = 72
      Top = 72
      Width = 145
      Height = 21
      PasswordChar = '*'
      TabOrder = 1
    end
  end
  object idok: TButton
    Left = 56
    Top = 160
    Width = 105
    Height = 41
    Caption = #30331#38470
    TabOrder = 1
    OnClick = idokClick
  end
  object idcancel: TButton
    Left = 192
    Top = 160
    Width = 121
    Height = 41
    Caption = #21462#28040
    TabOrder = 2
    OnClick = idcancelClick
  end
end
