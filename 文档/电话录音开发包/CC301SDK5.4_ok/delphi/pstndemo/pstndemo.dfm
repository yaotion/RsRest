object Form1: TForm1
  Left = 480
  Top = 141
  Width = 605
  Height = 620
  Caption = 'CC301'#24320#21457#28436#31034#31243#24207' 1.71'
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
    Left = 16
    Top = 240
    Width = 27
    Height = 13
    Caption = #36890#36947':'
  end
  object dialcode: TLabel
    Left = 16
    Top = 296
    Width = 27
    Height = 13
    Caption = #21495#30721':'
  end
  object Label2: TLabel
    Left = 16
    Top = 392
    Width = 75
    Height = 13
    Caption = #25991#20214#21387#32553#26684#24335':'
  end
  object opendev: TButton
    Left = 8
    Top = 192
    Width = 89
    Height = 33
    Caption = #25171#24320#35774#22791
    TabOrder = 0
    OnClick = opendevClick
  end
  object closedev: TButton
    Left = 104
    Top = 192
    Width = 89
    Height = 33
    Caption = #20851#38381#35774#22791
    TabOrder = 1
    OnClick = closedevClick
  end
  object dial: TButton
    Left = 168
    Top = 288
    Width = 81
    Height = 25
    Caption = #25320#21495
    TabOrder = 2
    OnClick = dialClick
  end
  object playfile: TButton
    Left = 16
    Top = 336
    Width = 97
    Height = 33
    Caption = #25773#25918#25991#20214
    TabOrder = 3
    OnClick = playfileClick
  end
  object GroupBox1: TGroupBox
    Left = 304
    Top = 240
    Width = 273
    Height = 209
    Caption = #25511#21046
    TabOrder = 4
    object dohook: TCheckBox
      Left = 16
      Top = 24
      Width = 97
      Height = 25
      Caption = #25688#26426'/'#25509#21548
      TabOrder = 0
      OnClick = dohookClick
    end
    object dophone: TCheckBox
      Left = 16
      Top = 48
      Width = 113
      Height = 25
      Caption = #26029#24320#30005#35805#26426
      TabOrder = 1
      OnClick = dophoneClick
    end
    object linetospk: TCheckBox
      Left = 16
      Top = 72
      Width = 161
      Height = 25
      Caption = #25171#24320#32447#36335#22768#38899#21040#32819#26426
      TabOrder = 2
      OnClick = linetospkClick
    end
    object playtospk: TCheckBox
      Left = 16
      Top = 96
      Width = 145
      Height = 25
      Caption = #25773#25918#30340#22768#38899#21040#32819#26426
      TabOrder = 3
      OnClick = playtospkClick
    end
    object mictoline: TCheckBox
      Left = 16
      Top = 120
      Width = 161
      Height = 25
      Caption = #25171#24320'mic'#22768#38899#21040#32447#36335
      TabOrder = 4
      OnClick = mictolineClick
    end
    object opendoplay: TCheckBox
      Left = 16
      Top = 152
      Width = 89
      Height = 25
      Caption = #25171#24320#21895#21485
      TabOrder = 5
      OnClick = opendoplayClick
    end
    object doplaymux: TComboBox
      Left = 104
      Top = 152
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 6
      OnChange = doplaymuxChange
    end
  end
  object recfile: TButton
    Left = 16
    Top = 472
    Width = 97
    Height = 33
    Caption = #25991#20214#24405#38899
    TabOrder = 5
    OnClick = recfileClick
  end
  object channellist: TComboBox
    Left = 64
    Top = 240
    Width = 105
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
  end
  object refusecallin: TButton
    Left = 16
    Top = 536
    Width = 97
    Height = 33
    Caption = #25298#25509#26469#30005
    TabOrder = 7
    OnClick = refusecallinClick
  end
  object startflash: TButton
    Left = 152
    Top = 536
    Width = 97
    Height = 33
    Caption = #25293#25554#31783
    TabOrder = 8
    OnClick = startflashClick
  end
  object lbmsg: TListBox
    Left = 8
    Top = 8
    Width = 577
    Height = 177
    ItemHeight = 13
    TabOrder = 9
  end
  object pstncode: TEdit
    Left = 64
    Top = 288
    Width = 97
    Height = 21
    TabOrder = 10
  end
  object stopplayfile: TButton
    Left = 152
    Top = 336
    Width = 97
    Height = 33
    Caption = #20572#27490#25773#25918
    TabOrder = 11
    OnClick = stopplayfileClick
  end
  object stoprecfile: TButton
    Left = 152
    Top = 472
    Width = 97
    Height = 33
    Caption = #20572#27490#24405#38899
    TabOrder = 12
    OnClick = stoprecfileClick
  end
  object fileecho: TCheckBox
    Left = 16
    Top = 440
    Width = 81
    Height = 25
    Caption = #22238#38899#25269#28040
    TabOrder = 13
  end
  object fileagc: TCheckBox
    Left = 112
    Top = 440
    Width = 81
    Height = 25
    Caption = #33258#21160#22686#30410
    TabOrder = 14
  end
  object recfileformat: TComboBox
    Left = 16
    Top = 416
    Width = 265
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 15
  end
  object amGroupBox: TGroupBox
    Left = 304
    Top = 464
    Width = 273
    Height = 89
    Caption = #22686#30410
    TabOrder = 16
    object Label3: TLabel
      Left = 16
      Top = 24
      Width = 51
      Height = 13
      Caption = #32819#26426#22686#30410':'
    end
    object Label4: TLabel
      Left = 16
      Top = 56
      Width = 43
      Height = 13
      Caption = 'mic'#22686#30410':'
    end
    object spkam: TComboBox
      Left = 88
      Top = 24
      Width = 121
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = spkamChange
    end
    object micam: TComboBox
      Left = 88
      Top = 56
      Width = 121
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      OnChange = micamChange
    end
  end
  object startspeech: TButton
    Left = 304
    Top = 560
    Width = 129
    Height = 25
    Caption = #24320#22987#20869#32447#35821#38899#35782#21035
    TabOrder = 17
    OnClick = startspeechClick
  end
  object Button2: TButton
    Left = 448
    Top = 560
    Width = 113
    Height = 25
    Caption = #20572#27490#35782#21035
    TabOrder = 18
    OnClick = Button2Click
  end
  object playfiledialog: TOpenDialog
    Filter = 'wave|*.wav;*.wave;*.pcm|all files|*.*'
    Left = 120
    Top = 336
  end
  object recfiledialog: TSaveDialog
    Filter = 'wave files|*.wav|all files|*.*'
    Left = 120
    Top = 480
  end
end
