object FrmSendNotifyCall: TFrmSendNotifyCall
  Left = 0
  Top = 0
  Align = alCustom
  Caption = #21457#36865#21483#29677#36890#30693
  ClientHeight = 392
  ClientWidth = 1137
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMode = pmAuto
  Position = poDesktopCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 320
  ExplicitHeight = 240
  PixelsPerInch = 96
  TextHeight = 13
  object rzpnl2: TRzPanel
    Left = 0
    Top = 40
    Width = 1137
    Height = 352
    Align = alClient
    BorderOuter = fsBump
    TabOrder = 0
    object GridNotifyCall: TAdvStringGrid
      Left = 2
      Top = 2
      Width = 1133
      Height = 348
      Cursor = crDefault
      Align = alClient
      BorderStyle = bsNone
      Color = clWhite
      ColCount = 15
      Ctl3D = False
      FixedColor = 16448250
      RowCount = 2
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
      ActiveCellFont.Charset = DEFAULT_CHARSET
      ActiveCellFont.Color = clWindowText
      ActiveCellFont.Height = -11
      ActiveCellFont.Name = 'Tahoma'
      ActiveCellFont.Style = [fsBold]
      ColumnHeaders.Strings = (
        #24207#21495
        #29366#24577
        #21462#28040
        #36710#27425
        #21483#29677#26102#38388
        #20986#21220#26102#38388
        #21496#26426
        #36890#30693#20869#23481
        #36890#30693#20154
        #36890#30693#26102#38388
        #25509#25910#20154
        #25509#25910#26102#38388
        #21462#28040#20154
        #21462#28040#26102#38388
        #21462#28040#21407#22240)
      ColumnSize.Save = True
      ColumnSize.Key = 'FormColWidths.ini'
      ColumnSize.Section = 'SignPlan'
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
        60
        72
        100
        113
        63
        104
        75
        194
        64
        64
        64
        64
        64
        64)
      RowHeights = (
        25
        27)
    end
  end
  object rzpnl3: TRzPanel
    Left = 0
    Top = 0
    Width = 1137
    Height = 40
    Align = alTop
    BorderOuter = fsNone
    TabOrder = 1
    DesignSize = (
      1137
      40)
    object btnRefreshPaln: TPngSpeedButton
      Left = 278
      Top = 4
      Width = 106
      Height = 33
      Caption = #21047#26032
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = btnRefreshPalnClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C0000016D4944415478DA95933F28C55114C7EFD3AF37480683DE
        20C9A048CAF25264900CA478912CCAF092C5C06233582C6233F8B31824CBF367
        906478615332480649261924935EF239BDEFE376FB21A73EF5FBDD7BCFF79C7B
        CEB989743AED62AC126AA00E2278807B78D1FE96FEE7128140398CC10434CBD9
        AC00B7B00A1BB00E03D0EF0B54C3267443999CDEB59794D8079C6AAF0B864B02
        15B0AB45DB3C50B44B8935401686BCAC9C2F30054B8A300F0B5E74CBA84A8E93
        D0110A58C1CE74E71C8C78CE4E0EDB9052362E1468E1E3420B834A3FB44E458F
        82F5451348298AA57F046FEE1F96F8610E7E332B788FAE933781363E66824305
        75E12446A0571D336B35016BCD4E70C8AEF30CA38148A48266E01ADAE304CE61
        459D788543CF79DA15DB1C29EBE538017F90AEF4DFE48AE39D91731EFAACE0BE
        C0B152FF6B94CDD966E5A9D405ABE83EECC1B82B3EA6ACA226BD9ADC28AB35BF
        D526608766A151452BB5AA16EA95CD23DCB9EFE7FC659F5B535D594C0F12B400
        00000049454E44AE426082}
    end
    object btnCancel: TPngSpeedButton
      Left = 390
      Top = 4
      Width = 106
      Height = 33
      Caption = #21462#28040#36890#30693
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = btnCancelClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C0000016D4944415478DA95933F28C55114C7EFD3AF37480683DE
        20C9A048CAF25264900CA478912CCAF092C5C06233582C6233F8B31824CBF367
        906478615332480649261924935EF239BDEFE376FB21A73EF5FBDD7BCFF79C7B
        CEB989743AED62AC126AA00E2278807B78D1FE96FEE7128140398CC10434CBD9
        AC00B7B00A1BB00E03D0EF0B54C3267443999CDEB59794D8079C6AAF0B864B02
        15B0AB45DB3C50B44B8935401686BCAC9C2F30054B8A300F0B5E74CBA84A8E93
        D0110A58C1CE74E71C8C78CE4E0EDB9052362E1468E1E3420B834A3FB44E458F
        82F5451348298AA57F046FEE1F96F8610E7E332B788FAE933781363E66824305
        75E12446A0571D336B35016BCD4E70C8AEF30CA38148A48266E01ADAE304CE61
        459D788543CF79DA15DB1C29EBE538017F90AEF4DFE48AE39D91731EFAACE0BE
        C0B152FF6B94CDD966E5A9D405ABE83EECC1B82B3EA6ACA226BD9ADC28AB35BF
        D526608766A151452BB5AA16EA95CD23DCB9EFE7FC659F5B535D594C0F12B400
        00000049454E44AE426082}
    end
    object lbl1: TLabel
      Left = 8
      Top = 10
      Width = 61
      Height = 17
      Caption = #36215#22987#26102#38388':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object dtpStart: TAdvDateTimePicker
      Left = 75
      Top = 7
      Width = 192
      Height = 25
      Date = 42017.519872685190000000
      Time = 42017.519872685190000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Tahoma'
      Font.Style = []
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      Kind = dkDateTime
      ParentFont = False
      TabOrder = 0
      BorderStyle = bsSingle
      Ctl3D = True
      DateTime = 42017.519872685190000000
      Version = '1.1.0.0'
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
    end
    object chkHideCancel: TCheckBox
      Left = 520
      Top = 10
      Width = 137
      Height = 17
      Anchors = [akTop, akRight]
      Caption = #38544#34255#24050#21462#28040#36890#30693
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 1
      OnClick = chkHideCancelClick
    end
  end
end
