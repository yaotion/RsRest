object FrmBaseDataConfig: TFrmBaseDataConfig
  Left = 0
  Top = 0
  Caption = #22522#30784#25968#25454#37197#32622
  ClientHeight = 488
  ClientWidth = 844
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object pnl1: TRzPanel
    Left = 0
    Top = 0
    Width = 169
    Height = 488
    Align = alLeft
    BorderOuter = fsNone
    TabOrder = 0
    object tv1: TTreeView
      Left = 0
      Top = 0
      Width = 169
      Height = 488
      Align = alClient
      Indent = 19
      ReadOnly = True
      TabOrder = 0
      OnClick = tv1Click
    end
  end
  object pnl2: TRzPanel
    Left = 169
    Top = 0
    Width = 675
    Height = 488
    Align = alClient
    BorderOuter = fsNone
    TabOrder = 1
    object pgc1: TPageControl
      Left = 0
      Top = 0
      Width = 675
      Height = 488
      Align = alClient
      TabOrder = 0
    end
  end
end
