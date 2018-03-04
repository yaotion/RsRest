object FrmJiNingTrainmanEdit: TFrmJiNingTrainmanEdit
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #20154#21592#21019#24314
  ClientHeight = 181
  ClientWidth = 323
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
  object Label2: TLabel
    Left = 34
    Top = 84
    Width = 57
    Height = 19
    Caption = #22995#21517#65306
    Color = clBtnFace
    ParentColor = False
  end
  object lbl5: TLabel
    Left = 24
    Top = 28
    Width = 67
    Height = 19
    Caption = #26426#21153#27573':'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object edtTrainmanName: TEdit
    Left = 97
    Top = 84
    Width = 168
    Height = 27
    TabOrder = 1
  end
  object btnOK: TButton
    Left = 97
    Top = 128
    Width = 80
    Height = 30
    Caption = #30830#23450
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 188
    Top = 128
    Width = 80
    Height = 30
    Cancel = True
    Caption = #20851#38381
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object cbbJWD: TComboBox
    Left = 97
    Top = 27
    Width = 168
    Height = 27
    Style = csDropDownList
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ItemHeight = 0
    TabOrder = 0
  end
end
