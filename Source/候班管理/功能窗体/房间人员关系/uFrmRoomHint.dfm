object FrmRoomHint: TFrmRoomHint
  Left = 0
  Top = 0
  Caption = #20837#23507#20449#24687
  ClientHeight = 177
  ClientWidth = 308
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 19
  object Label1: TLabel
    Left = 40
    Top = 72
    Width = 67
    Height = 19
    Caption = #25151#38388#21495':'
  end
  object Label2: TLabel
    Left = 40
    Top = 32
    Width = 67
    Height = 19
    Caption = #20056#21153#21592':'
  end
  object lbTrainman: TLabel
    Left = 136
    Top = 32
    Width = 19
    Height = 19
    Caption = #31354
  end
  object edtRoomNumber: TEdit
    Left = 136
    Top = 69
    Width = 121
    Height = 27
    TabOrder = 2
  end
  object btnOk: TButton
    Left = 74
    Top = 120
    Width = 81
    Height = 33
    Caption = #30830#23450
    TabOrder = 0
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 176
    Top = 120
    Width = 81
    Height = 33
    Caption = #21462#28040
    TabOrder = 1
    OnClick = btnCancelClick
  end
end
