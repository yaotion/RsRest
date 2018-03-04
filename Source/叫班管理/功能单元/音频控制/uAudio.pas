unit uAudio;

interface
uses
  uAudioXP,Windows,uMMDevApi,ComObj,ActiveX,Math;
type
  TDevType = (eRender{����},eCapture{���});

  //////////////////////////////////////////////////////////////////////////////
  ///����:TAudio
  ///����:windows����Ƶ����
  //////////////////////////////////////////////////////////////////////////////
  TAudio = class
  public
    {����:���þ���}
    class function SetMute(devType:TDevType;bMute:Boolean):Boolean;
    {����:��ȡ����}
    class function GetMute(devType:TDevType;var bMute:Boolean):Boolean;
    {����:��������}
    class function SetVolume( devType:TDevType;nValue:Integer):Boolean;
    {����:��ȡ������}
    class function  GetVolume(devType:TDevType;var nValue:Integer):Boolean;
    {����:�ж�ϵͳ�汾}
    class function GetSysVersion(var nMainVer,nSubVer:Integer):Boolean;
  end;


  //////////////////////////////////////////////////////////////////////////////
  ///����:TAudio_Win7
  ///����:win7����Ƶ����
  //////////////////////////////////////////////////////////////////////////////
  TAudio_Win7 = class
  public
    {����:���þ���}
    class function SetMute(devType:TDevType;bMute:Boolean):Boolean;
    {����:��ȡ����}
    class function GetMute(devType:TDevType;var bMute:Boolean):Boolean;
    {����:��������}
    class function SetVolume( devType:TDevType;nValue:Integer):Boolean;
    {����:��ȡ������}
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
        eCapture:  {���}
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
        eRender://������
        begin
          nValue := uAudioXP.GetVolume(Master);
          result := true;
        end;
        eCapture:  {���}
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
        eRender://������
        begin
           uAudioXP.SetVolumeMute(Master,bMute);
          result := true;
        end;
        eCapture:  {���}
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
        eRender://������
        begin
          uAudioXP.SetVolume(Master,nValue);
          result := true;
        end;
        eCapture:  {���}
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
