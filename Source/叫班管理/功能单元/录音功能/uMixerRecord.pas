unit uMixerRecord;

interface
uses
  classes,Windows,messages,MMSystem,IDGlobal,Dialogs,SysUtils;
type
  TArrayBuf = array[0..10239] of byte; //1   KByte
  PArrayBuf = ^TArrayBuf;
  TRecData = array[0..8191] of byte;
  PRecData = ^TRecData;
  //����һ��Wave�ļ�ͷ
  TWaveHeader=record
    RIFF:longint; //�̶���ǣ�ֵΪ"RIFF"
    nSize:longint; //�����ֽ�����ֵΪ(wSampleLength+36)
    WAVE:longint; //�̶���ǣ�ֵΪ"WAVE"
    FMT:longint; //ckIDֵΪ"fmt "
    FMTSize:longint; //nChunkSize Wave�ļ���Ĵ�С 16
    wFormatTag:word; //��Ƶ���ݵı��뷽ʽ����ֵΪ1������PCM��ʽ
    nChannels:word; //������
    nSamplesPerSec:longint; //����Ƶ��
    nAvgBytesPerSec:longint; //ÿ���ֽ���
    nBlockAlign:word; //һ��������ֽ��� ֵΪ����λ����������/8
    wBitsPerSample:word; //����λ����һ��Ϊ16��8λ
    dId:longint; //�̶���ǣ�ֵλ"data"
    wSampleLength:longint; //�������ݳ��ȣ�ֵΪ�ļ���С���ļ�ͷ��С��44��
  end;   
  //////////////////////////////////////////////////////////////////////////////
  ///¼����
  //////////////////////////////////////////////////////////////////////////////
  TMixerRecord = class
  public
    //��ʼ¼��
    procedure Start;
    //ֹͣ¼��
    procedure Stop;
    //��ȡ��wavͷ��¼���ļ���
    function GetRecordStream : TMemoryStream;
    //�Ƿ�����¼��
    function IsRecording:boolean;
  private
    m_bIsRecording:boolean;
  private
    hWaveIn: HWaveIn;
    fmt: TWaveFormatEx; //Wave_audio���ݸ�ʽ
    m_SaveBuf : TBytes;
    whIn1,whIn2:TWaveHdr;
    buf1, buf2:TBytes;
    procedure WMWIMReceive(var Message: TMessage);
  public
    property SaveBuf : TBytes read m_SaveBuf write m_SaveBuf;
  end;
implementation
uses
  uLogs;
{ TMixerRecord }

function TMixerRecord.GetRecordStream  : TMemoryStream;
var
  waveHead : TWaveHeader;
  i,bufCount,bufLeft : Integer;
  buf : array[0..1023] of byte;
begin
  waveHead.RIFF := FOURCC_RIFF;
  waveHead.nSize := Length(m_SaveBuf) + 36 ;
  waveHead.WAVE := $45564157;
  waveHead.FMT := $20746d66;
  waveHead.FMTSize := 16;
  waveHead.wFormatTag := WAVE_FORMAT_PCM;
  waveHead.nChannels := 2;
  waveHead.nSamplesPerSec:= 22050;
  waveHead.nAvgBytesPerSec := 88200;
  waveHead.nBlockAlign:= 4;
  waveHead.wBitsPerSample:= 16;
  waveHead.dId := $61746164;
  waveHead.wSampleLength:= Length(m_SaveBuf) ;
  Result := TMemoryStream.Create;
  Result.Seek(0,soBeginning);
  Result.Write(waveHead,SizeOf(waveHead));

  bufCount := Length(m_SaveBuf) div 1024;
  bufLeft := Length(m_SaveBuf) mod 1024;

  for i := 0 to bufCount - 1 do
  begin
    Move(m_SaveBuf[1024*i],Buf[0],1024);
    Result.WriteBuffer(Buf,Length(Buf));
  end;
  
  if bufLeft > 0 then
  begin
    Move(m_SaveBuf[bufCount*1024],Buf[0],bufLeft);
    Result.WriteBuffer(Buf,bufLeft);
  end;
end;

function TMixerRecord.IsRecording: boolean;
begin
  result := m_bIsRecording ;
end;

procedure TMixerRecord.Start;
var
  nRet : MMRESULT ;
  strMessage:string;
begin
  m_bIsRecording := true ;

{ָ��Ҫ¼�Ƶĸ�ʽ}
  fmt.wFormatTag:=WAVE_FORMAT_PCM;
  fmt.nChannels:=2;
  fmt.nSamplesPerSec:=22050;
  fmt.nAvgBytesPerSec:=88200;
  fmt.nBlockAlign :=4;
  fmt.wBitsPerSample:=16;
  fmt.cbSize:=0;
  //�����¼�Ƶ�����
  SetLength(m_SaveBuf,0);
  m_SaveBuf:=nil;
  if hwaveIn <> 0 then
  begin
    nRet := waveInReset(hWaveIn);
    if nRet <> MMSYSERR_NOERROR then
    begin
      strMessage := format('TMixerRecord.Start->waveInReset_error: [%d]',[nRet]);
      TLog.SaveLog(now,strMessage );
    end;
  end;


  nRet := waveInOpen(@hWaveIn,WAVE_MAPPER,@fmt,AllocateHWnd(WMWIMReceive),0,CALLBACK_WINDOW) ;
  if nRet = 0 then
  begin
    SetLength(buf1, 1024 * 8);
    SetLength(buf2, 1024 * 8);

    whIn1.lpData:= PAnsiChar(buf1);
    whIn1.dwBufferLength := Length(buf1);
    whIn1.dwBytesRecorded:= 0;
    whIn1.dwUser:= 0;
    whIn1.dwFlags:=0;
    whIn1.dwLoops :=0;
    whIn1.lpNext:= nil;
    whIn1.reserved:= 0;

    whIn2.lpData := PAnsiChar(buf2);
    whIn2.dwBufferLength:= Length(buf2);
    whIn2.dwBytesRecorded := 0;
    whIn2.dwUser:= 0;
    whIn2.dwFlags:= 0;
    whIn2.dwLoops:= 0;
    whIn2.lpNext:= nil;
    whIn2.reserved:= 0;

    waveInPrepareHeader(hWaveIn, @whIn1, SizeOf(TWaveHdr));
    waveInPrepareHeader(hWaveIn, @whIn2, SizeOf(TWaveHdr));
    waveInAddBuffer(hWaveIn, @whIn1, SizeOf(TWaveHdr));
    waveInAddBuffer(hWaveIn, @whIn2, SizeOf(TWaveHdr));
    waveInStart(hWaveIn);
  end
  else
  begin
    strMessage := format('TMixerRecord.Start->waveInOpen_error: [%d]',[nRet]);
    TLog.SaveLog(now,strMessage );
  end;
end;

procedure TMixerRecord.Stop;
//begin
//
//  m_bIsRecording := false ;
//
//  WaveInStop(hWaveIn);
//  waveInUnprepareHeader(hWaveIn, @whIn1, SizeOf(TWaveHdr));
//  waveInUnprepareHeader(hWaveIn, @whIn2, SizeOf(TWaveHdr));
//  waveInClose(hWaveIn);
//  waveInReset(hWaveIn);
//end;
var
  nRet : MMRESULT ;
  strMessage:string;
begin

  m_bIsRecording := false ;

  nRet := WaveInStop(hWaveIn);
  if nRet <> MMSYSERR_NOERROR then
  begin
    strMessage := format('TMixerRecord.Stop->WaveInStop_error: [%d]',[nRet]);
    TLog.SaveLog(now,strMessage );
  end;

  nRet := waveInReset(hWaveIn);
  if nRet <> MMSYSERR_NOERROR then
  begin
    strMessage := format('TMixerRecord.Stop->waveInReset_error: [%d]',[nRet]);
    TLog.SaveLog(now,strMessage );
  end;

  nRet := waveInUnprepareHeader(hWaveIn, @whIn1, SizeOf(TWaveHdr));
  if nRet <> MMSYSERR_NOERROR then
  begin
    strMessage := format('TMixerRecord.Stop->waveInUnprepareHeader1_error: [%d]',[nRet]);
    TLog.SaveLog(now,strMessage );
  end;


  nRet := waveInUnprepareHeader(hWaveIn, @whIn2, SizeOf(TWaveHdr));
  if nRet <> MMSYSERR_NOERROR then
  begin
    strMessage := format('TMixerRecord.Stop->waveInUnprepareHeader2_error: [%d]',[nRet]);
    TLog.SaveLog(now,strMessage );
  end;

  nRet := waveInClose(hWaveIn);
  if nRet <> MMSYSERR_NOERROR then
  begin
    strMessage := format('TMixerRecord.Stop->waveInClose_error: [%d]',[nRet]);
    TLog.SaveLog(now,strMessage );
  end;
end;

procedure TMixerRecord.WMWIMReceive(var Message: TMessage);
var
  ordLen,newLen: integer;
  pData : PWaveHdr;
  data : PRecData;
begin
  case Message.Msg of
    MM_WIM_OPEN :
      begin
       TLog.SaveLog(now,'¼���豸->MM_WIM_OPEN');
      end;
    MM_WIM_CLOSE :
      begin
       TLog.SaveLog(now,'¼���豸->MM_WIM_CLOSE');
      end;
    MM_WIM_DATA:
      begin
        //TLog.SaveLog(now,'¼���豸->MM_WIM_DATA');
        pData := PWaveHdr(Message.LParam);
        data :=  PRecData(PWaveHdr(Message.lParam)^.lpData);
        if data = nil  then exit;
        
        //if pData = nil  then exit;

        {����¼�Ƶ�����}
        try
          ordLen := Length(m_SaveBuf);
          newLen :=  ordLen + Integer(pData.dwBytesRecorded);
          SetLength(m_SaveBuf, newLen);
          CopyMemory(Ptr(Integer(DWORD(m_SaveBuf))+ordLen),data,pData.dwBytesRecorded);
          {����¼��}
          waveInAddBuffer(hWaveIn, PWaveHdr(Message.LParam), SizeOf(TWaveHdr)) ;
        except
          on e : Exception do
          begin
            TLog.SaveLog(now,Format('¼���쳣:%s',[e.Message]));
          end;
        end;
      end;
      MM_WOM_DONE:
      begin
        TLog.SaveLog(now,'¼���豸->MM_WOM_DONE');
        {����ϢЯ�����豸����͡�WaveHdr��ָ��(dwParam1)}
        waveOutUnprepareHeader(hWaveIn,PWaveHdr(Message.LParam),SizeOf(TWaveHdr));
        waveOutClose(hWaveIn);
      end;
  end;
end;

end.
