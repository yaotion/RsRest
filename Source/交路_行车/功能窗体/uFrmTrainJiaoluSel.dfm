object FrmTrainJiaoSel: TFrmTrainJiaoSel
  Left = 0
  Top = 0
  Caption = #36873#25321#34892#36710#20132#36335
  ClientHeight = 305
  ClientWidth = 531
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
  object chklst1: TCheckListBox
    Left = 0
    Top = 0
    Width = 531
    Height = 264
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ItemHeight = 19
    ParentFont = False
    TabOrder = 0
  end
  object pnl1: TRzPanel
    Left = 0
    Top = 264
    Width = 531
    Height = 41
    Align = alBottom
    BorderOuter = fsNone
    TabOrder = 1
    object btnOK: TButton
      Left = 350
      Top = 6
      Width = 77
      Height = 29
      Caption = #30830#23450
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 439
      Top = 6
      Width = 77
      Height = 29
      Caption = #21462#28040
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
end
