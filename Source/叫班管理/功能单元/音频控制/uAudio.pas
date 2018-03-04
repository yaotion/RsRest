unit uAudio;

interface
uses
  uAudioXP,Windows,uMMDevApi,ComObj,ActiveX,Math;
type
  TDevType = (eRender{喇叭},eCapture{麦克});

  //////////////////////////////////////////////////////////////////////////////
  ///类名:TAudio
  ///描述:windows下音频控制
  //////////////////////////////////////////////////////////////////////////////
  TAudio = class
  public
    {功能:设置静音}
    class function SetMute(devType:TDevType;bMute:Boolean):Boolean;
    {功能:获取静音}
    class function GetMute(devType:TDevType;var bMute:Boolean):Boolean;
    {功能:设置音量}
    class function SetVolume( devType:TDevType;nValue:Integer):Boolean;
    {功能:获取喇音量}
    class function  GetVolume(devType:TDevType;var nValue:Integer):Boolean;
    {功能:判断系统版本}
    class function GetSysVersion(var nMainVer,nSubVer:Integer):Boolean;
  end;


  //////////////////////////////////////////////////////////////////////////////
  ///类名:TAudio_Win7
  ///描述:win7下音频控制
  //////////////////////////////////////////////////////////////////////////////
  TAudio_Win7 = class
  public
    {功能:设置静音}
    class function SetMute(devType:TDevType;bMute:Boolean):Boolean;
    {功能:获取静音}
    class function GetMute(devType:TDevType;var bMute:Boolean):Boolean;
    {功能:设置音量}
    class function SetVolume( devType:TDevType;nValue:Integer):Boolean;
    {功能:获取喇音量}
    class function  GetVolume(devType:TDevType;var nValue:Integer):Boolean;

  end;


implementation

{ TAudio }

class function TAudio.GetMute(devType: TDevType; var bMute: Boolean): Boolean;
var
  nMainVer, nSubVer: Integer;
begin
  Result := False;
  if GetSysVersion(nMainVer, nSubVer) = True then
  begin
    if nMainVer = 6 then
    begin
      result := TAudio_Win7.GetMute(devType,bMute)
    end;
    if nMainVer = 5 then
    begin
      case devType of
        eRender:
        begin
          bMute := uAudioXP.GetVolumeMute(Master);
          result := true;
        end;
        eCapture:  {麦克}
        begin
          bMute := uAudioXP.GetVolumeMute(Microphone);
          result:= True;
        end;
      end;
    end;
  end;
end;

class function TAudio.GetSysVersion(var nMainVer, nSubVer: Integer):Boolean;
var
  VerInfo: TOSVersionInfo;
begin
  VerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  result := GetVersionEx(verinfo);
  nMainVer :=verinfo.dwMajorVersion;
  nSubVer := VerInfo.dwMinorVersion;
end;

class function TAudio.GetVolume(devType: TDevType;
  var nValue: Integer): Boolean;
var
  nMainVer, nSubVer: Integer;
begin
  Result := False;
  if GetSysVersion(nMainVer, nSubVer) = True then
  begin
    if nMainVer = 6 then
    begin
      result := TAudio_Win7.GetVolume(devType,nValue)
    end;
    if nMainVer = 5 then
    begin
      case devType of
        eRender://扬声器
        begin
          nValue := uAudioXP.GetVolume(Master);
          result := true;
        end;
        eCapture:  {麦克}
        begin
          nValue := uAudioXP.GetVolume(Microphone);
          result:= True;
        end;
      end;
    end;
  end;
end;

class function TAudio.SetMute(devType: TDevType; bMute: Boolean): Boolean;
var
  nMainVer, nSubVer: Integer;
begin
  Result := False;
  if GetSysVersion(nMainVer, nSubVer) = True then
  begin
    if nMainVer = 6 then
    begin
      result := TAudio_Win7.SetMute(devType,bMute)
    end;
    if nMainVer = 5 then
    begin
      case devType of
        eRender://扬声器
        begin
           uAudioXP.SetVolumeMute(Master,bMute);
          result := true;
        end;
        eCapture:  {麦克}
        begin
          uAudioXP.SetVolumeMute(Microphone,bMute);
          result:= True;
        end;
      end;
    end;
  end;
end;

class function TAudio.SetVolume(devType: TDevType; nValue: Integer): Boolean;
var
  nMainVer, nSubVer: Integer;
begin
  Result := False;
  if GetSysVersion(nMainVer, nSubVer) = True then
  begin
    if nMainVer = 6 then
    begin
      result := TAudio_Win7.SetVolume(devType,nValue)
    end;
    if nMainVer = 5 then
    begin
      case devType of
        eRender://扬声器
        begin
          uAudioXP.SetVolume(Master,nValue);
          result := true;
        end;
        eCapture:  {麦克}
        begin
          uAudioXP.SetVolume(Microphone,nValue);
          result:= True;
        end;
      end;
    end;
  end;
end;


class function TAudio_Win7.GetMute(devType: TDevType;
  var bMute: Boolean): Boolean;
var
  deviceEnumerator: IMMDeviceEnumerator;
  defaultDevice: IMMDevice;
  EndpointVolume:IAudioEndpointVolume;
begin
  result := False;
  deviceEnumerator:= nil;
  defaultDevice := nil;
  EndpointVolume := nil;

  try
    CoCreateInstance(CLASS_IMMDeviceEnumerator, nil, CLSCTX_INPROC_SERVER, IID_IMMDeviceEnumerator, deviceEnumerator);
    if deviceEnumerator = nil then Exit;
    deviceEnumerator.GetDefaultAudioEndpoint(Ord(devType), eConsole, defaultDevice);
    if defaultDevice = nil then Exit;
    defaultDevice.Activate(IID_IAudioEndpointVolume, CLSCTX_INPROC_SERVER, nil, endpointVolume);
    if endpointVolume =nil then Exit;
    if endpointVolume.GetMute(bMute) = 0 then
      result := true;
  finally
    EndpointVolume := nil;
    defaultDevice:= nil; ;
    deviceEnumerator:= nil;
  end;
end;


class function TAudio_Win7.GetVolume(devType: TDevType;
  var nValue: Integer): Boolean;
var
  deviceEnumerator: IMMDeviceEnumerator;
  defaultDevice: IMMDevice;
  VolumeLevel: Single;
  EndpointVolume:IAudioEndpointVolume;
begin
  result := False;
  deviceEnumerator:= nil;
  defaultDevice := nil;
  EndpointVolume := nil;

  try
    CoCreateInstance(CLASS_IMMDeviceEnumerator, nil, CLSCTX_INPROC_SERVER, IID_IMMDeviceEnumerator, deviceEnumerator);
    if deviceEnumerator = nil then Exit;
    deviceEnumerator.GetDefaultAudioEndpoint(Ord(devType), eConsole, defaultDevice);
    if defaultDevice = nil then Exit;
    defaultDevice.Activate(IID_IAudioEndpointVolume, CLSCTX_INPROC_SERVER, nil, endpointVolume);
    if endpointVolume =nil then Exit;
    if endpointVolume.GetMasterVolumeLevel(VolumeLevel) = 0 then
    begin
      nValue := Math.Ceil(100 * VolumeLevel);
      result := true;
    end;
  finally
    EndpointVolume := nil;
    defaultDevice:= nil; ;
    deviceEnumerator:= nil;
  end;
end;


class function TAudio_Win7.SetMute(devType: TDevType; bMute: Boolean): Boolean;
var
  deviceEnumerator: IMMDeviceEnumerator;
  defaultDevice: IMMDevice;
  EndpointVolume:IAudioEndpointVolume;
begin
  result := False;
  deviceEnumerator:= nil;
  defaultDevice := nil;
  EndpointVolume := nil;

  try
    CoCreateInstance(CLASS_IMMDeviceEnumerator, nil, CLSCTX_INPROC_SERVER, IID_IMMDeviceEnumerator, deviceEnumerator);
    if deviceEnumerator = nil then Exit;
    deviceEnumerator.GetDefaultAudioEndpoint(Ord(devType), eConsole, defaultDevice);
    if defaultDevice = nil then Exit;
    defaultDevice.Activate(IID_IAudioEndpointVolume, CLSCTX_INPROC_SERVER, nil, endpointVolume);
    if endpointVolume =nil then Exit;
    //endpointVolume.SetMasterVolumeLevelScalar(nValue/100, nil);
    if endpointVolume.SetMute(bMute,nil) = 0  then
      result := true;
  finally
    EndpointVolume := nil;
    defaultDevice:= nil; ;
    deviceEnumerator:= nil;
  end;
end;


class function TAudio_Win7.SetVolume(devType: TDevType;
  nValue: Integer): Boolean;
var
  deviceEnumerator: IMMDeviceEnumerator;
  defaultDevice: IMMDevice;
  EndpointVolume:IAudioEndpointVolume;
begin
  result := False;
  deviceEnumerator:= nil;
  defaultDevice := nil;
  EndpointVolume := nil;
  try
    CoCreateInstance(CLASS_IMMDeviceEnumerator, nil, CLSCTX_INPROC_SERVER, IID_IMMDeviceEnumerator, deviceEnumerator);
    if deviceEnumerator = nil then Exit;
    deviceEnumerator.GetDefaultAudioEndpoint(Ord(devType), eConsole, defaultDevice);
    if defaultDevice = nil then Exit;
    defaultDevice.Activate(IID_IAudioEndpointVolume, CLSCTX_INPROC_SERVER, nil, endpointVolume);
    if endpointVolume =nil then Exit;
    if endpointVolume.SetMasterVolumeLevelScalar(nValue/100, nil) = 0 then
      result := true;
  finally
    EndpointVolume := nil;
    defaultDevice:= nil; ;
    deviceEnumerator:= nil;
  end;
end;

end.
