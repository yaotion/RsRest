object frmFingerRegister: TfrmFingerRegister
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #25351#32441#30331#35760
  ClientHeight = 285
  ClientWidth = 432
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object labText: TLabel
    Left = 242
    Top = 25
    Width = 158
    Height = 25
    AutoSize = False
    Caption = #25351#32441#30331#35760#24320#22987
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Bevel1: TBevel
    Left = 25
    Top = 229
    Width = 382
    Height = 2
    Shape = bsBottomLine
  end
  object btnFinger1: TSpeedButton
    Tag = 1
    Left = 242
    Top = 160
    Width = 75
    Height = 22
    AllowAllUp = True
    Caption = #30331#35760#25351#32441'1'
    Flat = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    OnClick = btnFingerClick
  end
  object btnFinger2: TSpeedButton
    Tag = 2
    Left = 242
    Top = 188
    Width = 75
    Height = 22
    Caption = #30331#35760#25351#32441'2'
    Flat = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    OnClick = btnFingerClick
  end
  object imgLog: TImage
    Left = 340
    Top = 95
    Width = 16
    Height = 16
    AutoSize = True
    Transparent = True
    Visible = False
  end
  object labEnrollState: TLabel
    Left = 252
    Top = 97
    Width = 78
    Height = 12
    Caption = #25351#32441#30331#35760#24320#22987
    Font.Charset = GB2312_CHARSET
    Font.Color = clNavy
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object Image1: TImage
    Left = 317
    Top = 162
    Width = 16
    Height = 16
    AutoSize = True
    Picture.Data = {
      07544269746D617036030000424D360300000000000036000000280000001000
      000010000000010018000000000000030000120B0000120B0000000000000000
      0000FB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FF
      FB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00
      FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB
      00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FF
      FB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00
      FF64B89C64B89CFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB
      00FFFB00FFFB00FFFB00FFFB00FF64B89C98EECA98EECA64B89CFB00FFFB00FF
      FB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FF64B89C9CF1
      CD60E3A560E3A59CF1CD64B89CFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB
      00FFFB00FFFB00FF64B89CA1F3D166E8AB66E8AB66E8AB66E8ABA1F3D164B89C
      FB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FF64B89C6DEDB26DED
      B264B89C64B89C6DEDB26DEDB2A7F6D564B89CFB00FFFB00FFFB00FFFB00FFFB
      00FFFB00FFFB00FFFB00FF64B89C64B89CFB00FFFB00FF64B89C73F3B973F3B9
      ABF9D964B89CFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00
      FFFB00FFFB00FFFB00FF64B89C79F8BF79F8BFB0FBDD64B89CFB00FFFB00FFFB
      00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FF64B89C
      7EFCC47EFCC4B3FDE064B89CFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00
      FFFB00FFFB00FFFB00FFFB00FFFB00FF64B89C81FFC881FFC864B89CFB00FFFB
      00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FF
      FB00FF64B89C64B89CFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00
      FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB
      00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FF
      FB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00
      FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB
      00FF}
    Transparent = True
    Visible = False
  end
  object Image2: TImage
    Left = 317
    Top = 190
    Width = 16
    Height = 16
    AutoSize = True
    Picture.Data = {
      07544269746D617036030000424D360300000000000036000000280000001000
      000010000000010018000000000000030000120B0000120B0000000000000000
      0000FB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FF
      FB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00
      FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB
      00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FF
      FB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00
      FF64B89C64B89CFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB
      00FFFB00FFFB00FFFB00FFFB00FF64B89C98EECA98EECA64B89CFB00FFFB00FF
      FB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FF64B89C9CF1
      CD60E3A560E3A59CF1CD64B89CFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB
      00FFFB00FFFB00FF64B89CA1F3D166E8AB66E8AB66E8AB66E8ABA1F3D164B89C
      FB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FF64B89C6DEDB26DED
      B264B89C64B89C6DEDB26DEDB2A7F6D564B89CFB00FFFB00FFFB00FFFB00FFFB
      00FFFB00FFFB00FFFB00FF64B89C64B89CFB00FFFB00FF64B89C73F3B973F3B9
      ABF9D964B89CFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00
      FFFB00FFFB00FFFB00FF64B89C79F8BF79F8BFB0FBDD64B89CFB00FFFB00FFFB
      00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FF64B89C
      7EFCC47EFCC4B3FDE064B89CFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00
      FFFB00FFFB00FFFB00FFFB00FFFB00FF64B89C81FFC881FFC864B89CFB00FFFB
      00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FF
      FB00FF64B89C64B89CFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00
      FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB
      00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FF
      FB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00
      FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB00FFFB
      00FF}
    Transparent = True
    Visible = False
  end
  object ImgLabelArrow: TImage
    Left = 238
    Top = 97
    Width = 5
    Height = 11
    AutoSize = True
    Picture.Data = {
      07544269746D6170E6000000424DE60000000000000036000000280000000500
      00000B0000000100180000000000B00000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00393939FFFFFFFFFFFFFFFFFFFFFF
      FF00393939393939FFFFFFFFFFFFFFFFFF00393939393939393939FFFFFFFFFF
      FF00393939393939393939393939FFFFFF003939393939393939393939393939
      3900393939393939393939393939FFFFFF00393939393939393939FFFFFFFFFF
      FF00393939393939FFFFFFFFFFFFFFFFFF00393939FFFFFFFFFFFFFFFFFFFFFF
      FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00}
    Transparent = True
    Visible = False
  end
  object ImgbuttonArrow: TImage
    Left = 238
    Top = 193
    Width = 5
    Height = 11
    AutoSize = True
    Picture.Data = {
      07544269746D6170E6000000424DE60000000000000036000000280000000500
      00000B0000000100180000000000B00000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00393939FFFFFFFFFFFFFFFFFFFFFF
      FF00393939393939FFFFFFFFFFFFFFFFFF00393939393939393939FFFFFFFFFF
      FF00393939393939393939393939FFFFFF003939393939393939393939393939
      3900393939393939393939393939FFFFFF00393939393939393939FFFFFFFFFF
      FF00393939393939FFFFFFFFFFFFFFFFFF00393939FFFFFFFFFFFFFFFFFFFFFF
      FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00}
    Transparent = True
    Visible = False
  end
  object btnClose: TButton
    Left = 317
    Top = 247
    Width = 75
    Height = 22
    Caption = #20851#38381
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object btnSave: TButton
    Left = 236
    Top = 247
    Width = 75
    Height = 22
    Caption = #30830#23450
    TabOrder = 0
    OnClick = btnSaveClick
  end
  object RzPanel1: TRzPanel
    Left = 24
    Top = 24
    Width = 193
    Height = 185
    BorderOuter = fsStatus
    Color = clWhite
    TabOrder = 2
    object ImgFinger: TImage
      Left = 1
      Top = 1
      Width = 191
      Height = 183
      Align = alClient
      Stretch = True
      Transparent = True
      ExplicitLeft = -4
      ExplicitTop = 0
      ExplicitWidth = 156
      ExplicitHeight = 144
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = TimerTimer
    Left = 120
    Top = 248
  end
  object ImageList: TImageList
    Left = 72
    Top = 192
    Bitmap = {
      494C010102000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00006464B8006464B800000000000000000000000000000000006464B8006464
      B800000000000000000000000000000000000000000000000000000000000000
      00000000000064B89C0064B89C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006464
      B8009898EE009898EE006464B80000000000000000006464B8009898EE009898
      EE006464B8000000000000000000000000000000000000000000000000000000
      000064B89C0098EECA0098EECA0064B89C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006464
      B8006060E3006060E3009C9CF1006464B8006464B8009C9CF1006060E3006060
      E3006464B80000000000000000000000000000000000000000000000000064B8
      9C009CF1CD0060E3A50060E3A5009CF1CD0064B89C0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00006464B8006666E8006666E800A1A1F300A1A1F3006666E8006666E8006464
      B80000000000000000000000000000000000000000000000000064B89C00A1F3
      D10066E8AB0066E8AB0066E8AB0066E8AB00A1F3D10064B89C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006464B8006D6DED006D6DED006D6DED006D6DED006464B8000000
      000000000000000000000000000000000000000000000000000064B89C006DED
      B2006DEDB20064B89C0064B89C006DEDB2006DEDB200A7F6D50064B89C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006464B8007373F3007373F3007373F3007373F3006464B8000000
      00000000000000000000000000000000000000000000000000000000000064B8
      9C0064B89C00000000000000000064B89C0073F3B90073F3B900ABF9D90064B8
      9C00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00006464B800B0B0FB007979F8007979F8007979F8007979F800B0B0FB006464
      B800000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000064B89C0079F8BF0079F8BF00B0FB
      DD0064B89C000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006464
      B800B3B3FD007E7EFC007E7EFC006464B8006464B8007E7EFC007E7EFC00B3B3
      FD006464B8000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000064B89C007EFCC4007EFC
      C400B3FDE00064B89C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006464
      B8008181FF008181FF006464B80000000000000000006464B8008181FF008181
      FF006464B8000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000064B89C0081FF
      C80081FFC80064B89C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00006464B8006464B800000000000000000000000000000000006464B8006464
      B800000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000064B8
      9C0064B89C000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF00000000FFFFFFFF00000000
      FFFFFFFF00000000F3CFF9FF00000000E187F0FF00000000E007E07F00000000
      F00FC03F00000000F81FC01F00000000F81FE60F00000000F00FFF0700000000
      E007FF8300000000E187FFC300000000F3CFFFE700000000FFFFFFFF00000000
      FFFFFFFF00000000FFFFFFFF0000000000000000000000000000000000000000
      000000000000}
  end
end
