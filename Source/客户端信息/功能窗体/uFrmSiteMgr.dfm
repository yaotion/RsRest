object FrmSiteMgr: TFrmSiteMgr
  Left = 0
  Top = 0
  Caption = #23458#25143#31471#31649#29702
  ClientHeight = 362
  ClientWidth = 608
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TRzPanel
    Left = 0
    Top = 0
    Width = 608
    Height = 41
    Align = alTop
    BorderOuter = fsNone
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
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
    object btnTrainJiaolu: TButton
      Left = 285
      Top = 8
      Width = 108
      Height = 25
      Caption = #34892#36710#20132#36335
      TabOrder = 3
      OnClick = btnTrainJiaoluClick
    end
  end
  object pnl2: TRzPanel
    Left = 0
    Top = 41
    Width = 608
    Height = 321
    Align = alClient
    BorderOuter = fsNone
    TabOrder = 1
    object lv1: TListView
      Left = 0
      Top = 0
      Width = 608
      Height = 321
      Align = alClient
      Columns = <
        item
          Caption = #24207#21495
        end
        item
          Caption = #23458#25143#31471#32534#21495
          Width = 150
        end
        item
          Caption = #23458#25143#31471#21517#31216
          Width = 120
        end
        item
          Caption = #20844#23507
          Width = 120
        end
        item
          Caption = #36710#38388
          Width = 120
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
