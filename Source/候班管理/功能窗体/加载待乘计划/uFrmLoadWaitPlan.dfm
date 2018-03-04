object FrmLoadWaitPlan: TFrmLoadWaitPlan
  Left = 0
  Top = 0
  Caption = #21152#36733#20505#29677#35745#21010
  ClientHeight = 394
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object rzpnl1: TRzPanel
    Left = 0
    Top = 349
    Width = 900
    Height = 45
    Align = alBottom
    BorderOuter = fsNone
    TabOrder = 0
    DesignSize = (
      900
      45)
    object btnOK: TButton
      Left = 680
      Top = 6
      Width = 97
      Height = 31
      Anchors = [akTop, akRight]
      Caption = #30830'    '#23450
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
      Left = 790
      Top = 6
      Width = 97
      Height = 31
      Anchors = [akTop, akRight]
      Caption = #21462'    '#28040
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object chkCreateCallPlan: TCheckBox
      Left = 11
      Top = 6
      Width = 121
      Height = 17
      Caption = #26159#21542#20135#29983#21483#29677#35745#21010
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
  end
  object lvWaitPlan: TListView
    Left = 0
    Top = 49
    Width = 900
    Height = 300
    Align = alClient
    Columns = <
      item
        Caption = #24207#21495
      end
      item
        Caption = #36710#27425
        Width = 100
      end
      item
        Caption = #25151#38388
        Width = 60
      end
      item
        Caption = #20505#29677#26102#38388
        Width = 170
      end
      item
        Caption = #21483#29677#26102#38388
        Width = 170
      end
      item
        Caption = #24320#36710#26102#38388
        Width = 170
      end
      item
        Caption = #21152#36733#32467#26524
        Width = 150
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    GridLines = True
    RowSelect = True
    ParentFont = False
    TabOrder = 1
    ViewStyle = vsReport
  end
  object rzpnl2: TRzPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 49
    Align = alTop
    BorderOuter = fsFlat
    TabOrder = 2
    object lbl1: TLabel
      Left = 11
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
    object btnCreate: TButton
      Left = 682
      Top = 9
      Width = 102
      Height = 31
      Caption = #29983#25104#35745#21010
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnCreateClick
    end
    object dtpStart: TAdvDateTimePicker
      Left = 136
      Top = 12
      Width = 209
      Height = 27
      Date = 42009.500000000000000000
      Format = 'yyyy-MM-dd HH:mm'
      Time = 42009.500000000000000000
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
      DateTime = 42009.500000000000000000
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
      Date = 42009.500000000000000000
      Format = 'yyyy-MM-dd HH:mm'
      Time = 42009.500000000000000000
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
      DateTime = 42009.500000000000000000
      Version = '1.1.0.0'
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
    end
  end
end
