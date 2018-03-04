object FrmSyncBaseData: TFrmSyncBaseData
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #21152#36733#22522#30784#25968#25454
  ClientHeight = 287
  ClientWidth = 562
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object mmoLogs: TMemo
    Left = 0
    Top = 0
    Width = 562
    Height = 250
    Align = alClient
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object pnl1: TRzPanel
    Left = 0
    Top = 250
    Width = 562
    Height = 37
    Align = alBottom
    BorderOuter = fsNone
    TabOrder = 1
    object btnCancel: TButton
      Left = 476
      Top = 6
      Width = 75
      Height = 25
      Caption = #20851#38381
      TabOrder = 0
      Visible = False
      OnClick = btnCancelClick
    end
  end
end
