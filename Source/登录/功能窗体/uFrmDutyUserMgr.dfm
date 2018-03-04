object FrmDutyUserMgr: TFrmDutyUserMgr
  Left = 0
  Top = 0
  Caption = #31649#29702#21592#31649#29702
  ClientHeight = 397
  ClientWidth = 719
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object pnl1: TRzPanel
    Left = 0
    Top = 0
    Width = 719
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
  end
  object pnl2: TRzPanel
    Left = 0
    Top = 41
    Width = 719
    Height = 356
    Align = alClient
    BorderOuter = fsNone
    TabOrder = 1
    object lv1: TListView
      Left = 0
      Top = 0
      Width = 719
      Height = 356
      Align = alClient
      Columns = <
        item
          Caption = #24207#21495
        end
        item
          Caption = #24037#21495
          Width = 200
        end
        item
          Caption = #22995#21517
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
      OnDblClick = lv1DblClick
    end
  end
end
