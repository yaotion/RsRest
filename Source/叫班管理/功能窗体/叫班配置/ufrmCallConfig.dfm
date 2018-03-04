object frmCallConfig: TfrmCallConfig
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #21483#29677#35774#32622
  ClientHeight = 375
  ClientWidth = 648
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object btnClose: TSpeedButton
    Left = 564
    Top = 331
    Width = 70
    Height = 30
    Caption = #20851#38381
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000120B0000120B00000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFBFDFB7AB580FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6DB67453A45BD7E9D8FFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      7BC58471BE7B7AC1835BAA6447994F4191493B884235803B2F78352A702F2569
      292163241D5E20FFFFFFFFFFFF89D1927BC8869CD5A598D3A194D09D90CE988B
      CB9387C98E82C6897EC3847AC18076BE7C72BD78216324FFFFFFFFFFFF88D391
      7FCC8AA2D8AB9ED6A79AD4A396D29F93CF9A8ECC9589CA9085C78B81C5877DC2
      8278C07E256929FFFFFFFFFFFFFFFFFF83D18D80CD8B7CC9875DB86858B16253
      A95C4DA15647994F4191493B884235803B2F78352A702FFFFFFFFFFFFFFFFFFF
      FFFFFF7DCF886AC575FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFEFC90D699FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    Margin = 5
    OnClick = btnCloseClick
  end
  object btnSave: TSpeedButton
    Left = 488
    Top = 331
    Width = 70
    Height = 30
    Caption = #20445#23384
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000120B0000120B00000000000000000000F4F4F4DDDDDD
      D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2
      D2DDDDDDF4F4F4FFFFFFD3B278CF9835CF9835CF9835CF9835CF9835CF9835CF
      9835CF9835CF9835CF9835CF9835CF9835CF9835D3B278FFFFFFCF9835F5D29A
      CF9835FFFFFFCF9835EABC72CF9835FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCF98
      35F5D29ACF9835FFFFFFCF9835EEBF76CF9835FFFFFFCF9835E0A341CF9835FF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCF9835EEBF76CF9835FFFFFFCF9835F0C279
      CF9835FFFFFFCF9835CF9835CF9835FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCF98
      35F0C279CF9835FFFFFFCF9835F3C780CF9835FFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCF9835F3C780CF9835FFFFFFCF9835F6CC83
      CF9835FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCF98
      35F6CC83CF9835FFFFFFCF9835FAD089DEA645CF9835CF9835CF9835CF9835CF
      9835CF9835CF9835CF9835CF9835DEA645FAD089CF9835FFFFFFCF9835FED48E
      F6BF62F6BF62F6BF62F6BF62F6BF62F6BF62F6BF62F6BF62F6BF62F6BF62F6BF
      62FED48ECF9835FFFFFFCF9835FFDE9AFFCC72E4AD4ECF9835CF9835CF9835CF
      9835CF9835CF9835CF9835E4AD4EFFCC72FFDE9ACF9835FFFFFFCF9835FFE39F
      FFD278CF9835FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCF9835FFD2
      78FFE39FCF9835FFFFFFCF9835FFE6A4FFD87ECF9835FFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFCF9835FFD87EFFE6A4CF9835FFFFFFCF9835FFEAA8
      FFDD84CF9835FFFFFFCF9835CF9835FFFFFFFFFFFFFFFFFFFFFFFFCF9835FFDD
      84FFEAA8CF9835FFFFFFCF9835FFEEACFFE089CF9835FFFFFFCF9835CF9835FF
      FFFFFFFFFFFFFFFFFFFFFFCF9835FFE089FFEEACCF9835FFFFFFCF9835FFF8C8
      FFEFAFCF9835FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCF9835FFEF
      AFFFF8C8CF9835FFFFFFE3C288CF9835CF9835CF9835CF9835CF9835CF9835CF
      9835CF9835CF9835CF9835CF9835CF9835CF9835E3C288FFFFFF}
    Margin = 5
    OnClick = btnSaveClick
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 625
    Height = 317
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #36890#35759#35774#32622
      OnShow = TabSheet1Show
      object Label1: TLabel
        Left = 31
        Top = 7
        Width = 104
        Height = 16
        Caption = #31471#21475#21495'(COM)'#65306
      end
      object Label2: TLabel
        Left = 55
        Top = 186
        Width = 80
        Height = 16
        Caption = #21628#21483#24310#36831#65306
      end
      object Label3: TLabel
        Left = 55
        Top = 222
        Width = 80
        Height = 16
        Caption = #36861#21483#38388#38548#65306
      end
      object Label4: TLabel
        Left = 218
        Top = 224
        Width = 16
        Height = 16
        Caption = #20998
      end
      object Label5: TLabel
        Left = 218
        Top = 186
        Width = 16
        Height = 16
        Caption = #31186
      end
      object Label6: TLabel
        Left = 71
        Top = 80
        Width = 64
        Height = 16
        Caption = #25320#21495#38899#65306
      end
      object Label7: TLabel
        Left = 218
        Top = 80
        Width = 48
        Height = 16
        Caption = '1-1023'
      end
      object Label8: TLabel
        Left = 55
        Top = 151
        Width = 80
        Height = 16
        Caption = #25320#21495#38388#38548#65306
      end
      object Label9: TLabel
        Left = 218
        Top = 151
        Width = 32
        Height = 16
        Caption = #27627#31186
      end
      object Label10: TLabel
        Left = 55
        Top = 43
        Width = 80
        Height = 16
        Caption = #36890#35759#31867#22411#65306
      end
      object Label11: TLabel
        Left = 39
        Top = 114
        Width = 96
        Height = 16
        Caption = #30333#22825#36890#35805#38899#65306
      end
      object Label12: TLabel
        Left = 218
        Top = 115
        Width = 48
        Height = 16
        Caption = '1-1023'
      end
      object Label15: TLabel
        Left = 311
        Top = 180
        Width = 112
        Height = 16
        Caption = #21551#21160#20445#25252#38388#38548#65306
      end
      object Label16: TLabel
        Left = 508
        Top = 180
        Width = 16
        Height = 16
        Caption = #20998
      end
      object Label18: TLabel
        Left = 311
        Top = 231
        Width = 272
        Height = 32
        Caption = #22312#31243#24207#21551#21160#21069#24050#36807#26399#30340#21483#29677#22312#38388#38548#33539#22260#13#20869#20381#28982#26377#25928
        Font.Charset = GB2312_CHARSET
        Font.Color = clMaroon
        Font.Height = -16
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label22: TLabel
        Left = 508
        Top = 145
        Width = 48
        Height = 16
        Caption = '1-1023'
      end
      object Label23: TLabel
        Left = 311
        Top = 145
        Width = 96
        Height = 16
        Caption = #22812#38388#36890#35805#38899#65306
      end
      object Label24: TLabel
        Left = 311
        Top = 78
        Width = 144
        Height = 16
        Caption = #22812#38388#26102#38388#33539#22260#35774#23450#65306
      end
      object Label25: TLabel
        Left = 438
        Top = 111
        Width = 48
        Height = 16
        Caption = #21040#20940#26216
      end
      object Label26: TLabel
        Left = 311
        Top = 111
        Width = 32
        Height = 16
        Caption = #26202#19978
      end
      object lbl1: TLabel
        Left = 311
        Top = 210
        Width = 112
        Height = 16
        Caption = #31163#23507#25552#37266#38388#38548#65306
      end
      object lbl2: TLabel
        Left = 508
        Top = 208
        Width = 16
        Height = 16
        Caption = #20998
      end
      object lbl3: TLabel
        Left = 55
        Top = 257
        Width = 80
        Height = 16
        Caption = #24405#38899#20445#23384#65306
      end
      object lbl4: TLabel
        Left = 218
        Top = 259
        Width = 16
        Height = 16
        Caption = #22825
      end
      object ComboBox1: TComboBox
        Left = 136
        Top = 38
        Width = 76
        Height = 24
        Style = csDropDownList
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 16
        TabOrder = 0
        Items.Strings = (
          #20018#21475
          #38899#20048)
      end
      object edtNightEnd: TRzDateTimeEdit
        Left = 492
        Top = 108
        Width = 78
        Height = 24
        CalendarElements = [ceWeekNumbers]
        Time = 0.250000000000000000
        EditType = etTime
        Format = 'hh:nn'
        DropButtonVisible = False
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        TabOrder = 1
      end
      object edtNightBegin: TRzDateTimeEdit
        Left = 349
        Top = 108
        Width = 78
        Height = 24
        CalendarElements = [ceWeekNumbers]
        Time = 0.833333333333333400
        EditType = etTime
        Format = 'hh:nn'
        DropButtonVisible = False
        HideSelection = False
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        TabOrder = 2
      end
      object btnTestLine: TButton
        Left = 468
        Top = 4
        Width = 106
        Height = 25
        Caption = #26816#26597#38899#39057#32447#36335
        TabOrder = 3
      end
      object checkCheckAudioLine: TCheckBox
        Left = 311
        Top = 8
        Width = 155
        Height = 17
        Caption = #33258#21160#26816#27979#38899#39057#32447#36335
        TabOrder = 4
      end
      object CheckWaitforConfirm: TCheckBox
        Left = 311
        Top = 42
        Width = 263
        Height = 17
        Caption = #39318#21483#21518#31561#24453#20844#23507#31649#29702#21592#30830#35748#25346#26029
        TabOrder = 5
      end
      object sedtDialVolume: TSpinEdit
        Left = 136
        Top = 72
        Width = 76
        Height = 26
        MaxValue = 1023
        MinValue = 1
        TabOrder = 6
        Value = 1
      end
      object sedtDayTalkVolume: TSpinEdit
        Left = 136
        Top = 109
        Width = 76
        Height = 26
        MaxValue = 1023
        MinValue = 1
        TabOrder = 7
        Value = 1
      end
      object sEdtDialIntervel: TSpinEdit
        Left = 136
        Top = 145
        Width = 76
        Height = 26
        MaxValue = 9999
        MinValue = 1
        TabOrder = 8
        Value = 1
      end
      object sEdtCallDelay: TSpinEdit
        Left = 136
        Top = 181
        Width = 76
        Height = 26
        MaxValue = 0
        MinValue = 0
        TabOrder = 9
        Value = 0
      end
      object sEdtRecallIntervel: TSpinEdit
        Left = 136
        Top = 217
        Width = 76
        Height = 26
        MaxValue = 0
        MinValue = 0
        TabOrder = 10
        Value = 0
      end
      object SpinEdit4: TSpinEdit
        Left = 429
        Top = 175
        Width = 76
        Height = 26
        MaxValue = 0
        MinValue = 0
        TabOrder = 11
        Value = 0
      end
      object sEdtNightTalkVolume: TSpinEdit
        Left = 429
        Top = 140
        Width = 76
        Height = 26
        MaxValue = 1023
        MinValue = 1
        TabOrder = 12
        Value = 1
      end
      object sEdtPortNum: TSpinEdit
        Left = 136
        Top = 2
        Width = 76
        Height = 26
        MaxValue = 1023
        MinValue = 1
        TabOrder = 13
        Value = 1
      end
      object seUnOutRoomNotify: TSpinEdit
        Left = 430
        Top = 205
        Width = 76
        Height = 26
        MaxValue = 0
        MinValue = 0
        TabOrder = 14
        Value = 0
      end
      object seVoiceStoreDays: TSpinEdit
        Left = 135
        Top = 251
        Width = 76
        Height = 26
        MaxValue = 0
        MinValue = 0
        TabOrder = 15
        Value = 0
      end
    end
  end
  object ColorDialog1: TColorDialog
    Left = 520
    Top = 16
  end
  object timerTestLine: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = timerTestLineTimer
    Left = 384
    Top = 24
  end
end
