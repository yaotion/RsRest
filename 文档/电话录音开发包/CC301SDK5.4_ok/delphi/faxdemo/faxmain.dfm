object Form1: TForm1
  Left = 254
  Top = 308
  Width = 477
  Height = 365
  Caption = 'cc301'#20256#30495#25910#21457#28436#31034'1.2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 51
    Height = 13
    Caption = #29366#24577#25552#31034':'
  end
  object Label2: TLabel
    Left = 16
    Top = 248
    Width = 278
    Height = 13
    Caption = '1.'#20351#29992#35805#26426#25320#36890#30005#35805#65292#23545#26041#25509#21548#21518#21551#21160#25509#25910'/'#21457#36865#20256#30495
  end
  object lbmsg: TListBox
    Left = 8
    Top = 32
    Width = 449
    Height = 201
    ItemHeight = 13
    TabOrder = 0
  end
  object recvfax: TButton
    Left = 8
    Top = 288
    Width = 89
    Height = 33
    Caption = #25509#25910#20256#30495
    TabOrder = 1
    OnClick = recvfaxClick
  end
  object sendfax: TButton
    Left = 112
    Top = 288
    Width = 89
    Height = 33
    Caption = #21457#36865#20256#30495
    TabOrder = 2
    OnClick = sendfaxClick
  end
end
