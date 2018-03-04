object FrmTrainJiaoLuMgr: TFrmTrainJiaoLuMgr
  Left = 0
  Top = 0
  Caption = #34892#36710#20132#36335#31649#29702
  ClientHeight = 290
  ClientWidth = 547
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
    Width = 547
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
    Width = 547
    Height = 249
    Align = alClient
    BorderOuter = fsNone
    TabOrder = 1
    object lv1: TListView
      Left = 0
      Top = 0
      Width = 547
      Height = 249
      Align = alClient
      Columns = <
        item
          Caption = #24207#21495
        end
        item
          Caption = #26426#21153#27573#21517#31216
          Width = 200
        end
        item
          Caption = #20132#36335#21517#31216
          Width = 200
        end>
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnDblClick = lv1DblClick
    end
  end
end
