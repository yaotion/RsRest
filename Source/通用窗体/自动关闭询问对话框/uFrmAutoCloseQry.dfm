object FrmAutoCloseQry: TFrmAutoCloseQry
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #35810#38382#31383#20307
  ClientHeight = 155
  ClientWidth = 457
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnOk: TButton
    Left = 257
    Top = 116
    Width = 84
    Height = 30
    Caption = #26159
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 355
    Top = 116
    Width = 84
    Height = 30
    Caption = #21542
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object mmo1: TMemo
    Left = 17
    Top = 18
    Width = 416
    Height = 81
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    Lines.Strings = (
      'mmo1')
    ParentFont = False
    TabOrder = 2
  end
  object tmr1: TTimer
    OnTimer = tmr1Timer
    Left = 324
    Top = 65534
  end
end
