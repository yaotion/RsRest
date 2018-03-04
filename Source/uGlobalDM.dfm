object GlobalDM: TGlobalDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 550
  Width = 957
  object ADOConnection: TADOConnection
    Left = 96
    Top = 56
  end
  object TFDBAutoConnect: TTFDBAutoConnect
    Connection = ADOConnection
    Enabled = False
    Interval = 1000
    OnConnect = TFDBAutoConnectConnect
    OnDisConnect = TFDBAutoConnectDisConnect
    TimeOut = 3000
    Left = 104
    Top = 8
  end
  object FrameController: TRzFrameController
    Color = clWhite
    FocusColor = clWhite
    FrameColor = 7960953
    FrameHotColor = clGradientActiveCaption
    FrameHotTrack = True
    FrameVisible = True
    FramingPreference = fpCustomFraming
    Left = 256
    Top = 16
  end
  object LocalADOConnection: TADOConnection
    LoginPrompt = False
    Left = 296
    Top = 96
  end
end
