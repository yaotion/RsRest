object FrmJWDMgr: TFrmJWDMgr
  Left = 0
  Top = 0
  Align = alClient
  Caption = #20844#23507#31649#29702
  ClientHeight = 266
  ClientWidth = 506
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 19
  object pnl1: TRzPanel
    Left = 0
    Top = 0
    Width = 506
    Height = 41
    Align = alTop
    BorderOuter = fsNone
    TabOrder = 0
    object btnAdd: TButton
      Left = 14
      Top = 8
      Width = 75
      Height = 25
      Caption = #22686#21152
      TabOrder = 0
      OnClick = btnAddClick
    end
    object btnModify: TButton
      Left = 104
      Top = 8
      Width = 75
      Height = 25
      Caption = #20462#25913
      TabOrder = 1
      OnClick = btnModifyClick
    end
    object btnDel: TButton
      Left = 195
      Top = 8
      Width = 75
      Height = 25
      Caption = #21024#38500
      TabOrder = 2
      OnClick = btnDelClick
    end
  end
  object pnl2: TRzPanel
    Left = 0
    Top = 41
    Width = 506
    Height = 225
    Align = alClient
    BorderOuter = fsNone
    TabOrder = 1
    object lv1: TListView
      Left = 0
      Top = 0
      Width = 506
      Height = 225
      Align = alClient
      Columns = <
        item
          Caption = #24207#21495
          Width = 80
        end
        item
          Caption = #20844#23507#32534#21495
          Width = 150
        end
        item
          Caption = #20844#23507#21517#31216
          Width = 250
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
      OnDblClick = lv1DblClick
    end
  end
end
