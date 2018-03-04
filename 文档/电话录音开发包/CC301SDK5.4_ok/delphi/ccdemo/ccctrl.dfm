object Form1: TForm1
  Left = 264
  Top = 189
  Width = 584
  Height = 419
  Caption = 'cc'#32593#32476#21363#26102#28040#24687'/'#25991#20214#20256#36755'/P2P'#35821#38899' delphi'#24320#21457#28436#31034' 1.2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lbmsg: TListBox
    Left = 8
    Top = 8
    Width = 561
    Height = 305
    ItemHeight = 13
    TabOrder = 0
  end
  object close: TButton
    Left = 464
    Top = 328
    Width = 105
    Height = 33
    Caption = #36864#20986
    TabOrder = 1
    OnClick = closeClick
  end
  object MainMenu1: TMainMenu
    Left = 8
    Top = 320
    object N1: TMenuItem
      Caption = #25991#20214
      object logoncc: TMenuItem
        Caption = #30331#38470'CC'
        OnClick = logonccClick
      end
      object offline: TMenuItem
        Caption = #31163#32447
        OnClick = offlineClick
      end
      object regcc: TMenuItem
        Caption = #27880#20876'CC'
        OnClick = regccClick
      end
    end
    object N2: TMenuItem
      Caption = #25805#20316
      object ccmsg: TMenuItem
        Caption = #21457#36865#28040#24687
        OnClick = ccmsgClick
      end
      object cccmd: TMenuItem
        Caption = #21457#36865#21629#20196
        OnClick = cccmdClick
      end
      object cccall: TMenuItem
        Caption = #21457#36865#35821#38899#21628#21483
        OnClick = cccallClick
      end
      object sendppfile: TMenuItem
        Caption = #21457#36865'P2P'#25991#20214
        OnClick = sendppfileClick
      end
    end
    object N3: TMenuItem
      Caption = #21442#25968
      object setserveraddr: TMenuItem
        Caption = #35774#32622#26381#21153#22120#22320#22336
        OnClick = setserveraddrClick
      end
    end
  end
end
