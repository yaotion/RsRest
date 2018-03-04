object ccmsgd: Tccmsgd
  Left = 331
  Top = 175
  Width = 605
  Height = 446
  Caption = 'cc'#28040#24687
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
    Left = 8
    Top = 296
    Width = 51
    Height = 13
    Caption = #28040#24687#20869#23481':'
  end
  object Label2: TLabel
    Left = 304
    Top = 296
    Width = 41
    Height = 13
    Caption = #30446#26631'CC:'
  end
  object sendmsg: TEdit
    Left = 8
    Top = 320
    Width = 497
    Height = 81
    AutoSize = False
    TabOrder = 0
  end
  object sendmsgbtn: TButton
    Left = 512
    Top = 320
    Width = 81
    Height = 81
    Caption = #21457#36865
    TabOrder = 1
    OnClick = sendmsgbtnClick
  end
  object destcc: TEdit
    Left = 368
    Top = 296
    Width = 137
    Height = 21
    TabOrder = 2
  end
  object recvmsg: TMemo
    Left = 8
    Top = 16
    Width = 577
    Height = 265
    TabOrder = 3
  end
end
