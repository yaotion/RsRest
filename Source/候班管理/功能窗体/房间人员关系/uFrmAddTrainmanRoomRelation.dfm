object FrmAddTrainmanRoomRelation: TFrmAddTrainmanRoomRelation
  Left = 0
  Top = 0
  Caption = #20154#21592#28155#21152
  ClientHeight = 183
  ClientWidth = 310
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
    Left = 32
    Top = 86
    Width = 48
    Height = 19
    Caption = #24202#21495':'
  end
  object Label2: TLabel
    Left = 32
    Top = 32
    Width = 48
    Height = 19
    Caption = #24037#21495':'
  end
  object cmbBedNumber: TComboBox
    Left = 104
    Top = 83
    Width = 145
    Height = 27
    Style = csDropDownList
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ItemHeight = 19
    ItemIndex = 0
    TabOrder = 1
    Text = '1'
    Items.Strings = (
      '1'
      '2'
      '3')
  end
  object edtTrainmanNumber: TEdit
    Left = 104
    Top = 29
    Width = 145
    Height = 27
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 88
    Top = 128
    Width = 75
    Height = 33
    Caption = #30830#23450
    TabOrder = 2
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 169
    Top = 128
    Width = 80
    Height = 33
    Caption = #21462#28040
    TabOrder = 3
    OnClick = btnCancelClick
  end
end
