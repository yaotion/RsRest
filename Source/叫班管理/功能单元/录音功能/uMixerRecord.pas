unit uMixerRecord;

interface
uses
  classes,Windows,messages,MMSystem,IDGlobal,Dialogs,SysUtils;
type
  TArrayBuf = array[0..10239] of byte; //1   KByte
  PArrayBuf = ^TArrayBuf;
  TRecData = array[0..8191] of byte;
  PRecData = ^TRecData;
  //定义一个Wave文件头
  TWaveHeader=record
    RIFF:longint; //固定标记，值为"RIFF"
    nSize:longint; //随后的字节数，值为(wSampleLength+36)
    WAVE:longint; //固定标记，值为"WAVE"
    FMT:longint; //ckID值为"fmt "
    FMTSize:longint; //nChunkSize Wave文件块的大小 16
    wFormatTag:word; //音频数据的编码方式，此值为1，标书PCM方式
    nChannels:word; //声道数
    nSamplesPerSec:longint; //采样频率
    nAvgBytesPerSec:longint; //每秒字节数
    nBlockAlign:word; //一次输出的字节数 值为采样位数×声道数/8
    wBitsPerSample:word; //采样位数，一般为16和8位
    dId:longint; //固定标记，值位"data"
    wSampleLength:longint; //采样数据长度，值为文件大小－文件头大小（44）
  end;   
  //////////////////////////////////////////////////////////////////////////////
  ///录音类
  //////////////////////////////////////////////////////////////////////////////
  TMixerRecord = class
  public
    //开始录音
    procedure Start;
    //停止录音
    procedure Stop;
    //获取带wav头的录音文件流
    function GetRecordStream : TMemoryStream;
    //是否正在录制
    function IsRecording:boolean;
  private
    m_bIsRecording:boolean;
  private
    hWaveIn: HWaveIn;
    fmt: TWaveFormatEx; //Wave_audio数据格式
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

{指定要录制的格式}
  fmt.wFormatTag:=WAVE_FORMAT_PCM;
  fmt.nChannels:=2;
  fmt.nSamplesPerSec:=22050;
  fmt.nAvgBytesPerSec:=88200;
  fmt.nBlockAlign :=4;
  fmt.wBitsPerSample:=16;
  fmt.cbSize:=0;
  //清除已录制的内容
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
       TLog.SaveLog(now,'录音设备->MM_WIM_OPEN');
      end;
    MM_WIM_CLOSE :
      begin
       TLog.SaveLog(now,'录音设备->MM_WIM_CLOSE');
      end;
    MM_WIM_DATA:
      begin
        //TLog.SaveLog(now,'录音设备->MM_WIM_DATA');
        pData := PWaveHdr(Message.LParam);
        data :=  PRecData(PWaveHdr(Message.lParam)^.lpData);
        if data = nil  then exit;
        
        //if pData = nil  then exit;

        {保存录制的数据}
        try
          ordLen := Length(m_SaveBuf);
          newLen :=  ordLen + Integer(pData.dwBytesRecorded);
          SetLength(m_SaveBuf, newLen);
          CopyMemory(Ptr(Integer(DWORD(m_SaveBuf))+ordLen),data,pData.dwBytesRecorded);
          {继续录制}
          waveInAddBuffer(hWaveIn, PWaveHdr(Message.LParam), SizeOf(TWaveHdr)) ;
        except
          on e : Exception do
          begin
            TLog.SaveLog(now,Format('录音异常:%s',[e.Message]));
          end;
        end;
      end;
      MM_WOM_DONE:
      begin
        TLog.SaveLog(now,'录音设备->MM_WOM_DONE');
        {此消息携带了设备句柄和　WaveHdr　指针(dwParam1)}
        waveOutUnprepareHeader(hWaveIn,PWaveHdr(Message.LParam),SizeOf(TWaveHdr));
        waveOutClose(hWaveIn);
      end;
  end;
end;

end.
