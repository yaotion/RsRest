object FrmMatchWaitMan: TFrmMatchWaitMan
  Left = 0
  Top = 0
  Caption = #21152#36733#31614#28857#20505#29677#20154#21592
  ClientHeight = 328
  ClientWidth = 992
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object rzpnl1: TRzPanel
    Left = 0
    Top = 0
    Width = 992
    Height = 49
    Align = alTop
    BorderOuter = fsNone
    TabOrder = 0
    object lbl1: TLabel
      Left = 24
      Top = 16
      Width = 102
      Height = 19
      Caption = #20505#29677#36215#22987#26102#38388':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbl2: TLabel
      Left = 360
      Top = 16
      Width = 102
      Height = 19
      Caption = #20505#29677#25130#27490#26102#38388':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object btnMatch: TButton
      Left = 704
      Top = 10
      Width = 137
      Height = 33
      Caption = #21305#37197#31614#28857#20154#21592
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnMatchClick
    end
    object dtpStart: TAdvDateTimePicker
      Left = 132
      Top = 12
      Width = 213
      Height = 27
      Date = 42009.771967592590000000
      Format = 'yyyy-MM-dd HH:mm'
      Time = 42009.771967592590000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      Kind = dkDateTime
      ParentFont = False
      TabOrder = 1
      BorderStyle = bsSingle
      Ctl3D = True
      DateTime = 42009.771967592590000000
      Version = '1.1.0.0'
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
    end
    object dtpEnd: TAdvDateTimePicker
      Left = 468
      Top = 12
      Width = 205
      Height = 27
      Date = 42009.771967592590000000
      Format = 'yyyy-MM-dd HH:mm'
      Time = 42009.771967592590000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      Kind = dkDateTime
      ParentFont = False
      TabOrder = 2
      BorderStyle = bsSingle
      Ctl3D = True
      DateTime = 42009.771967592590000000
      Version = '1.1.0.0'
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
    end
  end
  object rzpnl2: TRzPanel
    Left = 0
    Top = 49
    Width = 992
    Height = 238
    Align = alClient
    BorderOuter = fsBump
    TabOrder = 1
    object GridMatchWaitMan: TAdvStringGrid
      Left = 2
      Top = 2
      Width = 988
      Height = 234
      Cursor = crDefault
      Align = alClient
      BorderStyle = bsNone
      Color = clWhite
      ColCount = 15
      Constraints.MinHeight = 180
      Ctl3D = False
      FixedColor = 16448250
      RowCount = 3
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing]
      ParentCtl3D = False
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
      ActiveRowColor = clWhite
      HoverRowColor = clWhite
      OnGetCellColor = GridMatchWaitManGetCellColor
      ActiveCellFont.Charset = DEFAULT_CHARSET
      ActiveCellFont.Color = clWindowText
      ActiveCellFont.Height = -11
      ActiveCellFont.Name = 'Tahoma'
      ActiveCellFont.Style = [fsBold]
      ColumnHeaders.Strings = (
        #24207#21495
        #21305#37197#32467#26524
        #36710#27425
        #25151#38388
        #20505#29677#26102#38388
        #36710#27425
        #20505#29677#26102#38388
        #20056#21153#21592'1'
        #20056#21153#21592'2'
        #20056#21153#21592'3'
        #20056#21153#21592'4'
        '')
      ColumnSize.Save = True
      ColumnSize.Key = 'FormColWidths.ini'
      ColumnSize.Section = 'WaiWorkPlan'
      ColumnSize.Location = clIniFile
      ControlLook.FixedGradientHoverFrom = 16775139
      ControlLook.FixedGradientHoverTo = 16775139
      ControlLook.FixedGradientHoverMirrorFrom = 16772541
      ControlLook.FixedGradientHoverMirrorTo = 16508855
      ControlLook.FixedGradientHoverBorder = 12033927
      ControlLook.FixedGradientDownFrom = 16377020
      ControlLook.FixedGradientDownTo = 16377020
      ControlLook.FixedGradientDownMirrorFrom = 16242317
      ControlLook.FixedGradientDownMirrorTo = 16109962
      ControlLook.FixedGradientDownBorder = 11440207
      ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
      ControlLook.DropDownHeader.Font.Color = clWindowText
      ControlLook.DropDownHeader.Font.Height = -11
      ControlLook.DropDownHeader.Font.Name = 'Tahoma'
      ControlLook.DropDownHeader.Font.Style = []
      ControlLook.DropDownHeader.Visible = True
      ControlLook.DropDownHeader.Buttons = <>
      ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
      ControlLook.DropDownFooter.Font.Color = clWindowText
      ControlLook.DropDownFooter.Font.Height = -11
      ControlLook.DropDownFooter.Font.Name = 'Tahoma'
      ControlLook.DropDownFooter.Font.Style = []
      ControlLook.DropDownFooter.Visible = True
      ControlLook.DropDownFooter.Buttons = <>
      EnableHTML = False
      EnhRowColMove = False
      Filter = <>
      FilterDropDown.Font.Charset = DEFAULT_CHARSET
      FilterDropDown.Font.Color = clWindowText
      FilterDropDown.Font.Height = -11
      FilterDropDown.Font.Name = 'Tahoma'
      FilterDropDown.Font.Style = []
      FilterDropDownClear = '(All)'
      FixedColWidth = 40
      FixedRowHeight = 25
      FixedFont.Charset = GB2312_CHARSET
      FixedFont.Color = 3355443
      FixedFont.Height = -16
      FixedFont.Name = #23435#20307
      FixedFont.Style = [fsBold]
      Flat = True
      FloatFormat = '%.2f'
      Look = glClassic
      MouseActions.SelectOnRightClick = True
      PrintSettings.DateFormat = 'dd/mm/yyyy'
      PrintSettings.Font.Charset = DEFAULT_CHARSET
      PrintSettings.Font.Color = clWindowText
      PrintSettings.Font.Height = -11
      PrintSettings.Font.Name = 'Tahoma'
      PrintSettings.Font.Style = []
      PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
      PrintSettings.FixedFont.Color = clWindowText
      PrintSettings.FixedFont.Height = -11
      PrintSettings.FixedFont.Name = 'Tahoma'
      PrintSettings.FixedFont.Style = []
      PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
      PrintSettings.HeaderFont.Color = clWindowText
      PrintSettings.HeaderFont.Height = -11
      PrintSettings.HeaderFont.Name = 'Tahoma'
      PrintSettings.HeaderFont.Style = []
      PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
      PrintSettings.FooterFont.Color = clWindowText
      PrintSettings.FooterFont.Height = -11
      PrintSettings.FooterFont.Name = 'Tahoma'
      PrintSettings.FooterFont.Style = []
      PrintSettings.PageNumSep = '/'
      ScrollType = ssFlat
      ScrollWidth = 16
      SearchFooter.Color = clBtnFace
      SearchFooter.FindNextCaption = 'Find &next'
      SearchFooter.FindPrevCaption = 'Find &previous'
      SearchFooter.Font.Charset = DEFAULT_CHARSET
      SearchFooter.Font.Color = clWindowText
      SearchFooter.Font.Height = -11
      SearchFooter.Font.Name = 'Tahoma'
      SearchFooter.Font.Style = []
      SearchFooter.HighLightCaption = 'Highlight'
      SearchFooter.HintClose = 'Close'
      SearchFooter.HintFindNext = 'Find next occurence'
      SearchFooter.HintFindPrev = 'Find previous occurence'
      SearchFooter.HintHighlight = 'Highlight occurences'
      SearchFooter.MatchCaseCaption = 'Match case'
      SelectionColor = clHighlight
      SelectionColorTo = clHighlight
      SelectionTextColor = clHighlightText
      ShowModified.Color = clWhite
      ShowDesignHelper = False
      SortSettings.AutoSortForGrouping = False
      SortSettings.Full = False
      SortSettings.AutoFormat = False
      SortSettings.SortOnVirtualCells = False
      SortSettings.HeaderColorTo = 16579058
      SortSettings.HeaderMirrorColor = 16380385
      SortSettings.HeaderMirrorColorTo = 16182488
      Version = '5.6.0.0'
      ColWidths = (
        40
        118
        92
        81
        126
        62
        93
        101
        107
        104
        88
        64
        64
        64
        64)
      RowHeights = (
        25
        27
        22)
    end
  end
  object rzpnl3: TRzPanel
    Left = 0
    Top = 287
    Width = 992
    Height = 41
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      992
      41)
    object btnOK: TButton
      Left = 777
      Top = 6
      Width = 90
      Height = 29
      Anchors = [akTop, akRight]
      Caption = #30830#23450
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 889
      Top = 6
      Width = 90
      Height = 29
      Anchors = [akTop, akRight]
      Caption = #21462#28040
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
end
