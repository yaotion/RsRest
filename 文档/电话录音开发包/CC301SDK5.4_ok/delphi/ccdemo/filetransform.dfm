object filetransd: Tfiletransd
  Left = 830
  Top = 131
  Width = 566
  Height = 510
  Caption = #25991#20214#20256#36755
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
  object translist: TListView
    Left = 8
    Top = 8
    Width = 537
    Height = 281
    Columns = <>
    FullDrag = True
    GridLines = True
    TabOrder = 0
  end
  object savetrans: TButton
    Left = 16
    Top = 312
    Width = 113
    Height = 41
    Caption = #25509#25910#20445#23384
    TabOrder = 1
    OnClick = savetransClick
  end
  object refusetrans: TButton
    Left = 16
    Top = 368
    Width = 113
    Height = 41
    Caption = #25298#32477#25509#25910
    TabOrder = 2
    OnClick = refusetransClick
  end
  object stoptrans: TButton
    Left = 16
    Top = 424
    Width = 113
    Height = 41
    Caption = #20572#27490#20256#36755
    TabOrder = 3
    OnClick = stoptransClick
  end
  object showwin: TButton
    Left = 408
    Top = 312
    Width = 129
    Height = 41
    Caption = #26174#31034#31383#21475
    TabOrder = 4
    OnClick = showwinClick
  end
  object hidewin: TButton
    Left = 408
    Top = 368
    Width = 129
    Height = 41
    Caption = #38544#34255#31383#21475
    TabOrder = 5
    OnClick = hidewinClick
  end
  object SavetransDialog: TSaveDialog
    Left = 136
    Top = 320
  end
end
