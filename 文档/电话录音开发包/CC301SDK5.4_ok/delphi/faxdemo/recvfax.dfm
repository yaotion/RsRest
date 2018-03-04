object recvfaxform: Trecvfaxform
  Left = 678
  Top = 148
  Width = 437
  Height = 247
  Caption = #25509#25910#20256#30495
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
  object recvpath: TLabel
    Left = 8
    Top = 16
    Width = 75
    Height = 13
    Caption = #25509#25910#20256#30495#36335#24452':'
  end
  object recvstate: TLabel
    Left = 112
    Top = 184
    Width = 9
    Height = 13
    Caption = '...'
  end
  object faxpath: TEdit
    Left = 112
    Top = 16
    Width = 305
    Height = 21
    TabOrder = 0
    Text = 'c:\recvfax.tif'
  end
  object opendoplay: TCheckBox
    Left = 16
    Top = 176
    Width = 81
    Height = 25
    Caption = #25171#24320#21895#21485
    TabOrder = 1
    OnClick = opendoplayClick
  end
  object closerecvfax: TButton
    Left = 352
    Top = 168
    Width = 73
    Height = 33
    Caption = #20851#38381
    TabOrder = 2
    OnClick = closerecvfaxClick
  end
  object startrecv: TButton
    Left = 72
    Top = 104
    Width = 89
    Height = 33
    Caption = #24320#22987#25509#25910
    TabOrder = 3
    OnClick = startrecvClick
  end
  object stoprecv: TButton
    Left = 240
    Top = 104
    Width = 97
    Height = 33
    Caption = #20572#27490#25509#25910
    TabOrder = 4
    OnClick = stoprecvClick
  end
  object browerfile: TButton
    Left = 112
    Top = 48
    Width = 81
    Height = 33
    Caption = #26597#30475
    TabOrder = 5
    OnClick = browerfileClick
  end
end
