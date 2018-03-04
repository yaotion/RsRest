object FrmRoomSignsSysConfig: TFrmRoomSignsSysConfig
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsDialog
  Caption = #31995#32479#35774#32622
  ClientHeight = 359
  ClientWidth = 438
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object rzpgcntrlPageCtrlMain: TRzPageControl
    Left = 0
    Top = 0
    Width = 438
    Height = 359
    ActivePage = tsConfig
    Align = alClient
    TabIndex = 0
    TabOrder = 0
    FixedDimension = 19
    object tsConfig: TRzTabSheet
      Caption = #31995#32479#35774#32622
    end
  end
end
