object sendfaxform: Tsendfaxform
  Left = 305
  Top = 481
  Width = 437
  Height = 261
  Caption = #21457#36865#20256#30495
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object sendpath: TLabel
    Left = 16
    Top = 56
    Width = 75
    Height = 13
    Caption = #21457#36865#25991#20214#36335#24452':'
  end
  object sendstate: TLabel
    Left = 104
    Top = 192
    Width = 9
    Height = 13
    Caption = '...'
  end
  object channelid: TLabel
    Left = 64
    Top = 16
    Width = 27
    Height = 13
    Caption = #36890#36947':'
  end
  object faxpath: TEdit
    Left = 120
    Top = 48
    Width = 297
    Height = 21
    TabOrder = 0
    Text = 'c:\recvfax.tif'
  end
  object closesendfax: TButton
    Left = 344
    Top = 192
    Width = 81
    Height = 25
    Caption = #20851#38381
    TabOrder = 1
    OnClick = closesendfaxClick
  end
  object opendoplay: TCheckBox
    Left = 8
    Top = 192
    Width = 89
    Height = 25
    Caption = #25171#24320#21895#21485
    TabOrder = 2
    OnClick = opendoplayClick
  end
  object selectfile: TButton
    Left = 120
    Top = 80
    Width = 89
    Height = 25
    Caption = #36873#25321#25991#20214
    TabOrder = 3
    OnClick = selectfileClick
  end
  object browerfile: TButton
    Left = 224
    Top = 80
    Width = 81
    Height = 25
    Caption = #26597#30475
    TabOrder = 4
    OnClick = browerfileClick
  end
  object startsend: TButton
    Left = 72
    Top = 120
    Width = 105
    Height = 33
    Caption = #24320#22987#21457#36865
    TabOrder = 5
    OnClick = startsendClick
  end
  object stopsend: TButton
    Left = 272
    Top = 120
    Width = 105
    Height = 33
    Caption = #20572#27490#21457#36865
    TabOrder = 6
  end
  object channellist: TComboBox
    Left = 120
    Top = 8
    Width = 105
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 7
  end
  object selectsendfile: TOpenDialog
    Filter = 
      'image files|*.png;*.jpg;*.gif;*.jpeg;*.bmp;*.tif|word files|*.do' +
      'c|web files|*.htm;*.html;*.mht'
    Left = 88
    Top = 80
  end
end
