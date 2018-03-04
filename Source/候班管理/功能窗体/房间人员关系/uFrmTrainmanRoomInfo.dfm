object FrmTrainmanRoomInfo: TFrmTrainmanRoomInfo
  Left = 0
  Top = 0
  Align = alClient
  BorderStyle = bsNone
  Caption = #25151#38388#25152#20303#20154#21592
  ClientHeight = 381
  ClientWidth = 468
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Visible = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 7
    Top = 7
    Width = 67
    Height = 19
    Caption = #25151#38388#21495':'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object lbRoomNumber: TLabel
    Left = 95
    Top = 7
    Width = 19
    Height = 19
    Caption = #31354
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object lvRecord: TListView
    Left = 7
    Top = 34
    Width = 361
    Height = 337
    Columns = <
      item
        Caption = #24207#21495
        Width = 100
      end
      item
        Caption = #20056#21153#21592
        Width = 200
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
  end
  object btnAdd: TButton
    Left = 382
    Top = 34
    Width = 73
    Height = 33
    Caption = #28155#21152
    TabOrder = 1
    OnClick = btnAddClick
  end
  object btnModify: TButton
    Left = 382
    Top = 146
    Width = 73
    Height = 33
    Caption = #20462#25913
    TabOrder = 2
    Visible = False
  end
  object btnDel: TButton
    Left = 382
    Top = 90
    Width = 73
    Height = 33
    Caption = #21024#38500
    TabOrder = 3
    OnClick = btnDelClick
  end
end
