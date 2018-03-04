object cccalld: Tcccalld
  Left = 522
  Top = 202
  Width = 573
  Height = 396
  Caption = 'cc'#35821#38899
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
  object calllist: TListView
    Left = 16
    Top = 16
    Width = 521
    Height = 281
    Columns = <>
    FullDrag = True
    GridLines = True
    TabOrder = 0
  end
  object answer: TButton
    Left = 16
    Top = 312
    Width = 81
    Height = 33
    Caption = #25509#21548
    TabOrder = 1
    OnClick = answerClick
  end
  object refuse: TButton
    Left = 104
    Top = 312
    Width = 81
    Height = 33
    Caption = #25298#25509
    TabOrder = 2
    OnClick = refuseClick
  end
  object replybusy: TButton
    Left = 192
    Top = 312
    Width = 81
    Height = 33
    Caption = #22238#22797#24537
    TabOrder = 3
    OnClick = replybusyClick
  end
  object stop: TButton
    Left = 288
    Top = 312
    Width = 81
    Height = 33
    Caption = #20572#27490
    TabOrder = 4
    OnClick = stopClick
  end
end
