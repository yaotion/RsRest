object regccd: Tregccd
  Left = 226
  Top = 138
  Width = 485
  Height = 452
  Caption = #27880#20876'CC'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object recbox: TGroupBox
    Left = 32
    Top = 16
    Width = 417
    Height = 329
    Caption = #27880#20876'CC'
    TabOrder = 0
    object cccode: TLabel
      Left = 32
      Top = 32
      Width = 41
      Height = 13
      Caption = 'CC'#21495#30721':'
    end
    object Label1: TLabel
      Left = 40
      Top = 72
      Width = 27
      Height = 13
      Caption = #23494#30721':'
    end
    object Label2: TLabel
      Left = 40
      Top = 112
      Width = 27
      Height = 13
      Caption = #21602#31216':'
    end
    object Label3: TLabel
      Left = 16
      Top = 152
      Width = 50
      Height = 13
      Caption = #26381#21153#22120'ID:'
    end
    object Label4: TLabel
      Left = 8
      Top = 200
      Width = 98
      Height = 13
      Caption = #22914#20309#33719#21462#26381#21153#22120'ID:'
    end
    object Label5: TLabel
      Left = 8
      Top = 224
      Width = 257
      Height = 13
      Caption = '1.'#20808#30693#36947#35774#22791#30340'IP'
    end
    object Label6: TLabel
      Left = 8
      Top = 248
      Width = 305
      Height = 13
      Caption = '2.'#22312'IE'#36755#20837'http://'#35774#22791#30340'IP:8000'
    end
    object Label7: TLabel
      Left = 8
      Top = 272
      Width = 281
      Height = 13
      Caption = '3.'#30331#24405#31649#29702#30028#38754
    end
    object Label8: TLabel
      Left = 8
      Top = 296
      Width = 401
      Height = 13
      Caption = '4.'#25214#21040#36816#34892#21442#25968#35774#32622#30028#38754#65292#22312#36825#37324#25214#21040'"'#26381#21153#22120#27880#20876#26657#39564'ID"'#35774#32622
    end
    object cc: TEdit
      Left = 104
      Top = 32
      Width = 193
      Height = 21
      TabOrder = 0
    end
    object pwd: TEdit
      Left = 104
      Top = 72
      Width = 193
      Height = 21
      TabOrder = 1
    end
    object nick: TEdit
      Left = 104
      Top = 112
      Width = 193
      Height = 21
      TabOrder = 2
    end
    object serverid: TEdit
      Left = 104
      Top = 152
      Width = 193
      Height = 21
      TabOrder = 3
    end
  end
  object regcc: TButton
    Left = 32
    Top = 360
    Width = 113
    Height = 41
    Caption = #27880#20876
    TabOrder = 1
    OnClick = regccClick
  end
  object idcancel: TButton
    Left = 336
    Top = 360
    Width = 113
    Height = 41
    Caption = #21462#28040
    TabOrder = 2
    OnClick = idcancelClick
  end
end
