object tfPopBox: TtfPopBox
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsNone
  Caption = #25552#31034#20449#24687
  ClientHeight = 175
  ClientWidth = 545
  Color = 9987141
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 16
  object lblMsg1: TLabel
    Left = 150
    Top = 60
    Width = 128
    Height = 16
    Caption = #36825#26159#25552#31034#20449#24687'1'#65281
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = False
  end
  object lblClose: TLabel
    Left = 481
    Top = 8
    Width = 28
    Height = 14
    Caption = #20851#38381
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    OnClick = lblCloseClick
    OnMouseEnter = lblCloseMouseEnter
    OnMouseLeave = lblCloseMouseLeave
  end
  object lblMsg2: TLabel
    Left = 150
    Top = 82
    Width = 128
    Height = 16
    Caption = #36825#26159#25552#31034#20449#24687'2'#65281
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = False
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 416
    Top = 32
  end
end
