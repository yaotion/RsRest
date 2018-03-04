//�ĸ��������ֱ����ڻ�ȡ������GetVolume(DN))����������(SetVolume(DN,Value))��
//��ȡ������GetVolumeMute(DN)�������þ�����SetVolumeMute(DN,Value)����
unit uAudioXP;

interface

uses MMSystem, Dialogs;

type TDeviceName = (Master, Microphone, WaveOut, PCSpeaker, Depth, Synth, UNDEFINED, DIGITAL, LINEIN, CDPlayer, TELEPHONE, AUX);

function GetVolume(DN: TDeviceName): Word;
procedure SetVolume(DN: TDeviceName; Value: Word);
function GetVolumeMute(DN: TDeviceName): Boolean;
procedure SetVolumeMute(DN: TDeviceName; Value: Boolean);

implementation


//��ȡ����

function GetVolume(DN: TDeviceName): Word;
var
  hMix: HMIXER;
  mxlc: MIXERLINECONTROLS;
  mxcd: TMIXERCONTROLDETAILS;
  vol: TMIXERCONTROLDETAILS_UNSIGNED;
  mxc: MIXERCONTROL;
  mxl: TMixerLine;
  intRet: Integer;
  nMixerDevs: Integer;
begin
  Result := 0;
  //   Check   if   Mixer   is   available
  nMixerDevs := mixerGetNumDevs();
  if (nMixerDevs < 1) then
  begin
    Exit;
  end;

  //   open   the   mixer
  intRet := mixerOpen(@hMix, 0, 0, 0, 0);
  if intRet = MMSYSERR_NOERROR then
  begin
    case DN of
      Master: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_DST_SPEAKERS;
      Microphone: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_MICROPHONE;
      WaveOut: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_WAVEOUT;
      Synth: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_SYNTHESIZER;
      PCSpeaker: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_PCSPEAKER;
      Depth: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_LAST;
      UNDEFINED: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_UNDEFINED;
      DIGITAL: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_DIGITAL;
      LINEIN: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_LINE;
      CDPlayer: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_COMPACTDISC;
      TELEPHONE: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_TELEPHONE;
      AUX: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_AUXILIARY;
    end;
    mxl.cbStruct := SizeOf(mxl);

      //   get   line   info
    intRet := mixerGetLineInfo(hMix, @mxl, MIXER_GETLINEINFOF_COMPONENTTYPE);

    if intRet = MMSYSERR_NOERROR then
    begin
      FillChar(mxlc, SizeOf(mxlc), 0);
      mxlc.cbStruct := SizeOf(mxlc);
      mxlc.dwLineID := mxl.dwLineID;
      mxlc.dwControlType := MIXERCONTROL_CONTROLTYPE_VOLUME;
      mxlc.cControls := 1;
      mxlc.cbmxctrl := SizeOf(mxc);

      mxlc.pamxctrl := @mxc;
      intRet := mixerGetLineControls(hMix, @mxlc, MIXER_GETLINECONTROLSF_ONEBYTYPE);

      if intRet = MMSYSERR_NOERROR then
      begin
        FillChar(mxcd, SizeOf(mxcd), 0);
        mxcd.dwControlID := mxc.dwControlID;
        mxcd.cbStruct := SizeOf(mxcd);
        mxcd.cMultipleItems := 0;
        mxcd.cbDetails := SizeOf(Vol);
        mxcd.paDetails := @vol;
        mxcd.cChannels := 1;

        intRet := mixerGetControlDetails(hMix, @mxcd, MIXER_SETCONTROLDETAILSF_VALUE);

        Result := vol.dwValue;

        if intRet <> MMSYSERR_NOERROR then
          ShowMessage('GetControlDetails   Error ');
      end
      else
        ShowMessage('GetLineInfo   Error ');
    end;
    mixerClose(hMix);
  end;
end;

//��������

procedure setVolume(DN: TDeviceName; Value: Word);
var
  hMix: HMIXER;
  mxlc: MIXERLINECONTROLS;
  mxcd: TMIXERCONTROLDETAILS;
  vol: TMIXERCONTROLDETAILS_UNSIGNED;
  mxc: MIXERCONTROL;
  mxl: TMixerLine;
  intRet: Integer;
  nMixerDevs: Integer;
begin
  //   Check   if   Mixer   is   available
  nMixerDevs := mixerGetNumDevs();
  if (nMixerDevs < 1) then
  begin
    Exit;
  end;

  //   open   the   mixer
  intRet := mixerOpen(@hMix, 0, 0, 0, 0);
  if intRet = MMSYSERR_NOERROR then
  begin
    case DN of
      Master: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_DST_SPEAKERS;
      Microphone:
        mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_MICROPHONE;
      WaveOut: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_WAVEOUT;
      Synth: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_SYNTHESIZER;
      PCSpeaker: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_PCSPEAKER;
      Depth: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_LAST;
      UNDEFINED: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_UNDEFINED;
      DIGITAL: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_DIGITAL;
      LINEIN: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_LINE;
      CDPlayer: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_COMPACTDISC;
      TELEPHONE: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_TELEPHONE;
      AUX: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_AUXILIARY;
    end;
    mxl.cbStruct := SizeOf(mxl);

      //   get   line   info
    intRet := mixerGetLineInfo(hMix, @mxl, MIXER_GETLINEINFOF_COMPONENTTYPE);

    if intRet = MMSYSERR_NOERROR then
    begin
      FillChar(mxlc, SizeOf(mxlc), 0);
      mxlc.cbStruct := SizeOf(mxlc);
      mxlc.dwLineID := mxl.dwLineID;
      mxlc.dwControlType := MIXERCONTROL_CONTROLTYPE_VOLUME;
      mxlc.cControls := 1;
      mxlc.cbmxctrl := SizeOf(mxc);

      mxlc.pamxctrl := @mxc;
      intRet := mixerGetLineControls(hMix, @mxlc, MIXER_GETLINECONTROLSF_ONEBYTYPE);

      if intRet = MMSYSERR_NOERROR then
      begin
        FillChar(mxcd, SizeOf(mxcd), 0);
        mxcd.dwControlID := mxc.dwControlID;
        mxcd.cbStruct := SizeOf(mxcd);
        mxcd.cMultipleItems := 0;
        mxcd.cbDetails := SizeOf(Vol);
        mxcd.paDetails := @vol;
        mxcd.cChannels := 1;

        vol.dwValue := Value;

        intRet := mixerSetControlDetails(hMix, @mxcd, MIXER_SETCONTROLDETAILSF_VALUE);

        if intRet <> MMSYSERR_NOERROR then
          ShowMessage('SetControlDetails   Error ');
      end
      else
        ShowMessage('GetLineInfo   Error ');
    end;
    mixerClose(hMix);
  end;
end;




//��ȡ����

function GetVolumeMute(DN: TDeviceName): Boolean;
var
  hMix: HMIXER;
  mxlc: MIXERLINECONTROLS;
  mxcd: TMIXERCONTROLDETAILS;
  mxc: MIXERCONTROL;
  mxl: TMixerLine;
  intRet: Integer;
  nMixerDevs: Integer;
  mcdMute: MIXERCONTROLDETAILS_BOOLEAN;
begin
  Result := false;
  //   Check   if   Mixer   is   available
  nMixerDevs := mixerGetNumDevs();
  if (nMixerDevs < 1) then
  begin
    Exit;
  end;

  //   open   the   mixer
  intRet := mixerOpen(@hMix, 0, 0, 0, 0);
  if intRet = MMSYSERR_NOERROR then
  begin
    case DN of
      Master: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_DST_SPEAKERS;
      Microphone:
        mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_MICROPHONE;
      WaveOut: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_WAVEOUT;
      Synth: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_SYNTHESIZER;
      PCSpeaker: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_PCSPEAKER;
      Depth: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_LAST;
      UNDEFINED: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_UNDEFINED;
      DIGITAL: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_DIGITAL;
      LINEIN: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_LINE;
      CDPlayer: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_COMPACTDISC;
      TELEPHONE: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_TELEPHONE;
      AUX: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_AUXILIARY;
    end;
    mxl.cbStruct := SizeOf(mxl);

      //   mixerline   info
    intRet := mixerGetLineInfo(hMix, @mxl, MIXER_GETLINEINFOF_COMPONENTTYPE);

    if intRet = MMSYSERR_NOERROR then
    begin
      FillChar(mxlc, SizeOf(mxlc), 0);
      mxlc.cbStruct := SizeOf(mxlc);
      mxlc.dwLineID := mxl.dwLineID;
      mxlc.dwControlType := MIXERCONTROL_CONTROLTYPE_MUTE;
      mxlc.cControls := 1;
      mxlc.cbmxctrl := SizeOf(mxc);
      mxlc.pamxctrl := @mxc;

          //   Get   the   mute   control
      intRet := mixerGetLineControls(hMix, @mxlc, MIXER_GETLINECONTROLSF_ONEBYTYPE);

      if intRet = MMSYSERR_NOERROR then
      begin
        FillChar(mxcd, SizeOf(mxcd), 0);
        mxcd.cbStruct := SizeOf(TMIXERCONTROLDETAILS);
        mxcd.dwControlID := mxc.dwControlID;
        mxcd.cChannels := 1;
        mxcd.cbDetails := SizeOf(MIXERCONTROLDETAILS_BOOLEAN);
        mxcd.paDetails := @mcdMute;

              //   Get     mute
        intRet := mixerGetControlDetails(hMix, @mxcd, MIXER_SETCONTROLDETAILSF_VALUE);

        if mcdMute.fValue = 0 then Result := false
        else Result := True;

        if intRet <> MMSYSERR_NOERROR then
          ShowMessage('SetControlDetails   Error ');
      end
      else
        ShowMessage('GetLineInfo   Error ');
    end;
    mixerClose(hMix);
  end;
end;

//���þ���

procedure SetVolumeMute(DN: TDeviceName; Value: Boolean);
var
  hMix: HMIXER;
  mxlc: MIXERLINECONTROLS;
  mxcd: TMIXERCONTROLDETAILS;
  mxc: MIXERCONTROL;
  mxl: TMixerLine;
  intRet: Integer;
  nMixerDevs: Integer;
  mcdMute: MIXERCONTROLDETAILS_BOOLEAN;
begin
  //   Check   if   Mixer   is   available
  nMixerDevs := mixerGetNumDevs();
  if (nMixerDevs < 1) then
  begin
    Exit;
  end;

  //   open   the   mixer
  intRet := mixerOpen(@hMix, 0, 0, 0, 0);
  if intRet = MMSYSERR_NOERROR then
  begin
    case DN of
      Master: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_DST_SPEAKERS;
      Microphone:
        mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_MICROPHONE;
      WaveOut: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_WAVEOUT;
      Synth: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_SYNTHESIZER;
      PCSpeaker: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_PCSPEAKER;
      Depth: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_LAST;
      UNDEFINED: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_UNDEFINED;
      DIGITAL: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_DIGITAL;
      LINEIN: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_LINE;
      CDPlayer: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_COMPACTDISC;
      TELEPHONE: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_TELEPHONE;
      AUX: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_AUXILIARY;
    end;
    mxl.cbStruct := SizeOf(mxl);

      //   mixerline   info
    intRet := mixerGetLineInfo(hMix, @mxl, MIXER_GETLINEINFOF_COMPONENTTYPE);

    if intRet = MMSYSERR_NOERROR then
    begin
      FillChar(mxlc, SizeOf(mxlc), 0);
      mxlc.cbStruct := SizeOf(mxlc);
      mxlc.dwLineID := mxl.dwLineID;
      mxlc.dwControlType := MIXERCONTROL_CONTROLTYPE_MUTE;
      mxlc.cControls := 1;
      mxlc.cbmxctrl := SizeOf(mxc);
      mxlc.pamxctrl := @mxc;

          //   Get   the   mute   control
      intRet := mixerGetLineControls(hMix, @mxlc, MIXER_GETLINECONTROLSF_ONEBYTYPE);

      if intRet = MMSYSERR_NOERROR then
      begin
        FillChar(mxcd, SizeOf(mxcd), 0);
        mxcd.cbStruct := SizeOf(TMIXERCONTROLDETAILS);
        mxcd.dwControlID := mxc.dwControlID;
        mxcd.cChannels := 1;
        mxcd.cbDetails := SizeOf(MIXERCONTROLDETAILS_BOOLEAN);
        mxcd.paDetails := @mcdMute;

              //   Set   and   UnSet     mute
        mcdMute.fValue := Ord(Value);
        intRet := mixerSetControlDetails(hMix, @mxcd, MIXER_SETCONTROLDETAILSF_VALUE);

        if intRet <> MMSYSERR_NOERROR then
          ShowMessage('SetControlDetails   Error ');
      end
      else
        ShowMessage('GetLineInfo   Error ');
    end;

    mixerClose(hMix);
  end;
end;

end.

