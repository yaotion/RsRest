object FrmRoomInfo: TFrmRoomInfo
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #25151#38388
  ClientHeight = 499
  ClientWidth = 792
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
    Top = 24
    Width = 48
    Height = 19
    Caption = #24037#21495':'
  end
  object Label2: TLabel
    Left = 248
    Top = 24
    Width = 48
    Height = 19
    Caption = #22995#21517':'
  end
  object lvRecord: TListView
    Left = 32
    Top = 72
    Width = 217
    Height = 385
    Columns = <
      item
        Caption = #24207#21495
      end
      item
        Caption = #25151#38388#21495
        Width = 150
      end>
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    GridLines = True
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    TabOrder = 0
    ViewStyle = vsReport
    OnClick = lvRecordClick
  end
  object edtTrainmanNumber: TEdit
    Left = 106
    Top = 21
    Width = 121
    Height = 27
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 1
  end
  object edtTrainmanName: TEdit
    Left = 314
    Top = 21
    Width = 121
    Height = 27
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 2
  end
  object btnFind: TButton
    Left = 456
    Top = 21
    Width = 75
    Height = 27
    Caption = #26597#25214' '
    TabOrder = 3
    OnClick = btnFindClick
  end
  object PageCtrlMain: TRzPageControl
    Left = 280
    Top = 72
    Width = 473
    Height = 387
    ActivePage = tsTrainman
    TabIndex = 0
    TabOrder = 4
    FixedDimension = 25
    object tsTrainman: TRzTabSheet
      Caption = #24120#20303#20154#21592
    end
  end
end
