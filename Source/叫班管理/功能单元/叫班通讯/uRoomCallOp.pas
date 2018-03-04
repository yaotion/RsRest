unit uRoomCallOp;

interface
uses
  Classes,SysUtils,uCallControl,uRoomCall,uTFSystem,Forms,Windows,uLogs,MMSystem,
  uPubFun,uRoomCallMsgDefine,Messages,uSaftyEnum,uMixerRecord,uAudio,DateUtils;
type

  //////////////////////////////////////////////////////////////////////////////
  ///�ṹ����:TCallConfig
  ///����:�а�����
  //////////////////////////////////////////////////////////////////////////////
  TCallConfig = class
  private
    constructor Create();
    destructor Destroy();override;
  private
    //ini�����ļ�
    m_strIniFile:string;
    //��������
    m_SectionName:string;
    //�Լ���ʵ�����
    class var m_Self:TCallConfig;

  public
    {����:��ȡʵ�����}
    class function GetInstance():TCallConfig;
  private
    {����:ָ�������ļ�}
    procedure SetConfigFile(strFilePathName:string);

    function GetPort():Integer;
    procedure SetPort(nPort:Integer);

    function GetComType():Integer;
    procedure SetComType(nComType:Integer);

    function GetDialVolume():Integer;
    procedure SetDialVolume(nDialVolume:Integer);

    function GetDayTalkVolume():Integer;
    procedure SetDayTalkVolume(nDayTalkVolume:Integer);

    function GetDialInterval():Integer;
    procedure SetDialInterval(nDialInterval:Integer);

    function GetCallDelay():Integer;
    procedure SetCallDelay(nCallDelay:Integer);

    function GetReCallInterval():Integer;
    procedure SetReCallInterval(nAfterCallInterval:Integer);

    function GetUnOutRoomNotifyInterval():Integer;
    procedure SetUnOutRoomNotifyInterval(nUnOutRoomNotifyInterval:Integer);

    function GetAutoCheckAudioLine():Integer;
    procedure SetAutoCheckAudioLine(nAutoCheckAudioLine:Integer);

    function GetWaitConfirm():Integer;
    procedure SetWaitConfirm(nWaitConfirm:Integer);

    function GetNightTalkVolume():Integer;
    procedure SetNightTalkVolume(nNightTalkVolume:Integer);

    function GetNightStartTime():TDateTime;
    procedure SetNightStartTime(dtNightStartTime:TDateTime);

    function GetNightEndTime():TDateTime;
    procedure SetNightEndTime(dtNightEndTime:TDateTime);

    function GetOldVersion():Integer;
    procedure SetOldVersion(nOldVersion:Integer);

    function GetVoiceStoreDays():Integer;
    procedure SetVoiceStoreDays(nStoreDays:Integer);
  public
    //ͨ�Ŷ˿�
    property nPort:Integer read GetPort write SetPort;
    //ͨ������
    property nComType:Integer read GetComType write SetComType;
      //��������
    property  nDialVolume:Integer read GetDialVolume write SetDialVolume;
      //����ͨ������
    property nDayTalkVolume:Integer read GetDayTalkVolume write SetDayTalkVolume;
      //���ż��
    property nDialInterval:Integer  read GetDialInterval write SetDialInterval;
      //�����ӳ�
    property nCallDelay:Integer read GetCallDelay write SetCallDelay;
      //׷�м��
    property nReCallInterval:Integer read GetReCallInterval write SetReCallInterval;
    //δ��Ԣ���Ѽ��
    property nUnOutRoomNotifyInterval:Integer read GetUnOutRoomNotifyInterval write SetUnOutRoomNotifyInterval;
      //�Զ������Ƶ��·
    property nAutoCheckAudioLine:Integer read GetAutoCheckAudioLine write SetAutoCheckAudioLine;
      //�׽к�ȴ�����Աȷ�ϹҶ�
    property nWaitConfirm:Integer read GetWaitConfirm write SetWaitConfirm;
      //ҹ��ͨ������
    property nNightTalkVolume:Integer read GetNightTalkVolume write SetNightTalkVolume;
      //ҹ�俪ʼʱ��
    property dtNightStartTime:TDateTime read GetNightStartTime write SetNightStartTime;
      //ҹ�����ʱ��
    property dtNightEndTime:TDateTime read GetNightEndTime write SetNightEndTime;
    //�����ļ�
    property strIniFile :string  write SetConfigFile;
    //�Ƿ�ð�
    property nOldVersion :Integer read GetOldVersion write SetOldVersion;
    //¼���洢����
    property nVoiceStoreDays:Integer read GetVoiceStoreDays write SetVoiceStoreDays;
  end;


  
  //////////////////////////////////////////////////////////////////////////////
  ///����:TCallDevThread
  ///����:�а�����߳�
  //////////////////////////////////////////////////////////////////////////////
  TCallDevThread = class(TThread)
  public
    procedure Execute;override;
  protected
    m_OnExecute : TExecuteEvent;
    m_RoomCallType :TRoomCallType;
    m_RoomCallState:TRoomCallState;
  public
    //�ص��¼�
    property OnExecute : TExecuteEvent read m_OnExecute write m_OnExecute;
    //�а�����
    property RoomCallType :TRoomCallType read m_RoomCallType write m_RoomCallType;
    //�а�״̬
    property RoomCallState:TRoomCallState read m_RoomCallState write m_RoomCallState;
  end;



  //�а���
  TFinishCallResult = procedure (bSucess:Boolean; data:TCallDevCallBackData) of object;
  //�а��¼�
  TCallDevEvent = procedure (data:TCallDevCallBackData) of object;

  ////////////////////////////////////////////////////////////////////////////////
  ///����:TCallDevOP
  ///����:�а��豸����
  ////////////////////////////////////////////////////////////////////////////////
  TCallDevOP= class
  public
    constructor Create();
    destructor Destroy();override;

  public //----------�ⲿ�ӿں���-------------------//
    {����:�Ͽ��豸}
    function DisConDevice(var strMsg:string):Boolean;
    function DisConDeviceAll(CallMultiDevicesArray : RCallMultiDevicesArray;var strMsg:string):Boolean;

    function DisConDeviceMusic(var strMsg:string):Boolean;
    function DisConDeviceRS485(var strMsg:string):Boolean;

    {����:�˹������豸}
    function MonitorConDevice(var strMsg:string):Boolean;
    {����:�˹������豸}
    function MunualConDevice(var strMsg:string):Boolean;
    {����:�˹��׽�}
    function MunualFirstCallRoom(var strMsg:string):Boolean;
    
    {����:�Զ��׽�}
    function AutoFirstCall(var strMsg:string):Boolean;
    {����:�Զ��߽�}
    function AutoReCall(var strMsg:string):Boolean;
    {����:  �Զ������Һ���}
    function AutoServerRoomCall(var strMsg:string):Boolean;

    {����:�Զ��׽ж��}
    function AutoFirstCalls(CallMultiDevicesArray : RCallMultiDevicesArray;var strMsg:string):Boolean;
    {����:�Զ��߽�}
    function AutoReCalls(CallMultiDevicesArray : RCallMultiDevicesArray;var strMsg:string):Boolean;

    {����:�˲��ϴνа�ʱ��}
    function CheckLastCallTime():Boolean;
    {����:�ж��Ƿ�����ִ�на����}
    function bCalling():Boolean;
    {����:�򿪴���}
    function OpenPort():Boolean;
    
    {����:�ر��߳�}
    procedure CloseThread();

    //���������ļ�
    procedure PlaySoundFile(SoundFile: string);
    //һֱ��������
    procedure PlaySoundFileLoop(SoundFile: string);
    //ֹͣ��������
    procedure StopPlaySound();
    //�����׽�
    function   DoFirstCall(var strMsg:string):boolean;

////////////////////////////////////////////////////////////
  public
    //����Ƿ��з�������
    function  HaveReverseCall(out nDevNum:Integer;var strMsg:string):Boolean;
    //��ͨ��������
    function  ConnectReverseCall(nDevNum:Integer;var strMsg:string):Boolean;
    //�ܽӷ�������
    function  RefuseReverseCall(nDevNum:Integer;var strMsg:string):Boolean;
    //���ͷ�������
    function SetRoomCount(const num:Word):Integer;
    //���������ͷ��伯��}
    function SendMultiDeviceInfo(CallDevAry:TCallDevAry):BOOL;
    //�����豸
    function MonitorVoice(var strMsg:string):Boolean;
    {���� �����ж���豸}
    function CallMultiDevices(Src:RCallMultiDevicesArray):Boolean;
    {���ܣ���ѯ�����Ӧ�豸��}
    function FindIDByRoom(RoomNumber:string;out num: word): Boolean;
//////////////////////////////////////////////////////////////
  private //-----���̺߳���-----//
    {���ܣ������豸}
    function ExecuteConDeviceForMonitor():Boolean;
    {����:ִ�������豸}
    function ExecuteConDevice():Boolean;
    {����:ִ���׽�}
    function ExecuteFirstCall():Boolean;
    {����:ִ�д߽�}
    function ExecuteReCall():Boolean;
    {����:ִ�д߽�}
    function ExecuteServerRoomCall():Boolean;
    {����:ִ���Զ��׽�}
    function ExecuteAutoFirstCall():Boolean;
    {����:ִ���Զ��߽�}
    function ExecuteAutoReCall():Boolean;
    {����:ִ�з����Һ���}
    function ExecuteAutoServerRoomCall():Boolean;
  private
      {����:ִ�������豸}
    function ExecuteConDevices():Boolean;
    {����:ִ���׽�}
    function ExecuteFirstCalls():Boolean;
    {����:ִ�д߽�}
    function ExecuteReCalls():Boolean;
      {����:ִ���Զ��׽�s}
    function ExecuteAutoFirstCalls():Boolean;
    {����:ִ���Զ��߽�}
    function ExecuteAutoReCalls():Boolean;

  private  //-------��������--------////
    {����:�Ͽ��豸}
    function DisConDevice_NoCallBack(var strMsg:string):Boolean;
    {����:������Ƶ�����ź�}
    procedure SendVoiceSignal(callCommand:string);
    {����://��������������С����}
    procedure MinWaveOut();
    {����:��ϵͳ�����������������}
    procedure MaxWaveOut(strRoomNo: string);
    {���ܣ���MICROE����}
    procedure SetMicrophoneMute(Value:boolean);
    {����:����ʱ������}
    procedure SetPlaySoundTime(soundString: TStrings; dtTime: TDateTime);
    {����:�жϵ�ǰ�Ƿ�Ϊҹ��}
    function bNight():Boolean;

    {����:�����豸_��Ƶ��ʽ}
    function ConDev_Voice(var strMsg:string):Boolean;
    {����:�����豸_���ڷ�ʽ}
    function ConDev_COM(var strMsg:string):Boolean;
    {����:������ӽ��}
    function CheckConResult(var strMsg:string):Boolean;
    {����:�����н��}
    function QueryConResult(DeviceID:Integer; strMsg:string):Boolean;
    {����:�����н��}
    function QueryConResult485(DeviceID:Integer; strMsg:string):Boolean;
    //��ȡ�µ�Э��ĺ�������
    function GetNewCallCommand(nDeviceID: Integer): string;
    //��ȡ�ɵ�Э���������
    function GetOldCallCommand(nDeviceID:Integer):string;
    {����:����}
    function SaftySleep(nTotalSecondS:Integer;var strMsg:string):Boolean;

  private //---------���߳̽а�״̬֪ͨ���߳�------------//
    {����:��ʼ���ӽа��豸}
    procedure StartConDevEvent(nTryTimes:Integer);
    {����:�������ӽа��豸}
    procedure TryConDevEvent(nTryTimes: Integer; callResult: TRoomCallResult; strMsg: string);
    {����:�а��豸���ӽ���}
    procedure FinishConDevEvent(nTryTimes: Integer; callResult: TRoomCallResult; strMsg: string);

    {����:��ѯ�����豸}
    procedure QueryConDevEvent(nTryTimes: Integer; callResult: TRoomCallResult; strMsg: string);

    {����:��ʼ���Žа�����}
    procedure StartFirstCallPlayEvent();
    {����:�а����ֲ��Ž���}
    procedure FinishFirstCallPlayEvent(callResult: TRoomCallResult;strMsg:string);
    {����:��ʼ���Ŵ߽�����}
    procedure StartReCallPlayEvent();
    {����:�߽����ֲ��Ž���}
    procedure FinishReCallPlayEvent(callResult: TRoomCallResult;strMsg:string);

    {����:��ʼ���ŷ���������}
    procedure StartServerRoomCallPlayEvent();
    {����:�߽����ֲ��Ž���}
    procedure FinishServerRoomCallPlayEvent(callResult: TRoomCallResult;strMsg:string);
  
  private//---------���̴߳���а���------------//
    {����:��ʼ�豸���ӻص�}
    procedure OnDealStartConDev_Msg(msg:TMessage);
    {����:���������豸�ص�}
    procedure OnDealTryConDev_Msg(msg:TMessage);
    {����:�а��豸���ӽ����ص�}
    procedure OnDealFinishConDev_Msg(msg:TMessage);

    {����:��ѯ�豸�ص�}
    procedure OnDealQueryConDev_Msg(msg:TMessage);

    {����:��ʼ�׽лص�}
    procedure OnDealStartFristCall_Msg(msg:TMessage);
    {����:�׽н����ص�}
    procedure OnDealFinishFirstCall_Msg(msg:TMessage);
    {����:��ʼ�߽лص�}
    procedure OnDealStartReCall_Msg(msg:TMessage);
    {����:�߽н����ص�}
    procedure OnDealFinishRecall_Msg(msg:TMessage);


    {����:��ʼ�����һص�}
    procedure OnDealStartServerRoomCall_Msg(msg:TMessage);
    {����:�����ҽ����ص�}
    procedure OnDealFinishServerRoomcall_Msg(msg:TMessage);

    //----------------�ص���Ϣ�����߳�-----------------------
    {����:��Ϣ������}
    procedure WndMethod(var Msg: TMessage);


  public
    {����:��ȡ����ʵ��}
    class function GetInstance():TCallDevOP;
  private
    //��ʼ�����豸�¼�
    m_StartConDevEvent:TCallDevEvent;
    //���������豸ʱ��
    m_TryConDevEvent:TCallDevEvent;
    //��ѯһ�������豸�¼�
    m_QueryConDevEvent:TCallDevEvent;
    //��������豸�¼�
    m_FinishConDevEvent:TCallDevEvent;
    //��ʼ�����׽������¼�
    m_StartFistrCallVoiceEvent:TCallDevEvent;
    //���������׽������¼�
    m_FinishFistCallVoiceEvent:TCallDevEvent;
    //��ʼ���Ŵ߽������¼�
    m_StartReCallVoiceEvent:TCallDevEvent;
    //�������Ŵ߽������¼�
    m_FinishReCallVoiceEvent:TCallDevEvent;

    //��ʼ���ŷ����������¼�
    m_StartServerRoomCallVoiceEvent:TCallDevEvent;
    //�������ŷ����������¼�
    m_FinishServerRoomCallVoiceEvent:TCallDevEvent;
    //�Ҷ��豸�¼�
    m_DisConDevEvent:TCallDevEvent;

    //����ʵ��
    class var m_self:TCallDevOP;
    //�а�����߳�
    m_Thread:TCallDevThread;
    //��Ϣ���
    m_MSGhandle:THandle;
  private
    //�а�ײ����
    m_CallCtl:TCallControl;
    //�а��¼
    m_CallRecord:TCallRoomRecord;
    //�а�����
    m_CallConfig:TCallConfig;
    //�˿��Ƿ��Ѵ�
    m_bPortOpened:Boolean;
    //�رսа�
    m_bCancel:Boolean;
    //¼������
    m_MixerRecord : TMixerRecord;
    //�Ƿ�����ͨ��
    m_bWorking:Boolean;
    //���ͨ��ʱ��
    m_LastTastTime:Integer;
    //���ӷ����豸�Ƿ�ɹ�
    m_bConSucess:Boolean;
    //�а෿����Ϣ
    m_CallMultiDevicesArray : RCallMultiDevicesArray;
  public
    //��ʼ�����豸�¼�
    property OnStartConDevEvent:TCallDevEvent  read m_StartConDevEvent write m_StartConDevEvent ;
    //���������豸�¼�
    property OnTryConDevEvent:TCallDevEvent read m_TryConDevEvent write m_TryConDevEvent ;
    //�����豸�����¼�
    property OnFinishConDevEvent:TCallDevEvent read m_FinishConDevEvent write m_FinishConDevEvent;
    //���Ӳ�ѯ�����¼�
    property OnQueryConDevEvent:TCallDevEvent read  m_QueryConDevEvent write m_QueryConDevEvent;
    //��ʼ���Žа������¼�
    property OnStartFirstCallVoiceEvent:TCallDevEvent read m_StartFistrCallVoiceEvent write m_StartFistrCallVoiceEvent ;
    //�������Žа������¼�
    property OnFinishFistCallVoiceEvent:TCallDevEvent read m_FinishFistCallVoiceEvent write m_FinishFistCallVoiceEvent;
    //��ʼ���Ŵ߽������¼�
    property OnStartReCallVoiceEvent:TCallDevEvent read m_StartReCallVoiceEvent write m_StartReCallVoiceEvent ;
    //�������Ŵ߽������¼�
    property OnFinishReCallVoiceEvent:TCallDevEvent read m_FinishReCallVoiceEvent write m_FinishReCallVoiceEvent ;
    //�һ��¼�
    property OnDisConDevEvent:TCallDevEvent read m_DisConDevEvent write m_DisConDevEvent;

    property OnStartServerRoomCallVoiceEvent:TCallDevEvent read m_StartServerRoomCallVoiceEvent write m_StartServerRoomCallVoiceEvent;
    property OnFinishServerRoomCallVoiceEvent:TCallDevEvent read m_FinishServerRoomCallVoiceEvent write m_FinishServerRoomCallVoiceEvent;

    //�а�ײ����
    property CallCtl:TCallControl read m_CallCtl write m_CallCtl ;
    //�а�ƻ�
    property CallRecord:TCallRoomRecord read m_CallRecord write m_CallRecord;
    //�а�����
    property CallConfig:TCallConfig read m_CallConfig write m_CallConfig;
    //�˿��Ƿ��Ѵ�
    property bPortOpened:Boolean read m_bPortOpened write m_bPortOpened;
    //�رսа�
    property bCancel:Boolean read m_bCancel write m_bCancel;
    //���ӳɹ�
    property bConSucess:Boolean read m_bConSucess write m_bConSucess;
    //¼������
    //property MixerRecord :TMixerRecord read m_MixerRecord write m_MixerRecord ;
  end;


implementation

{$INCLUDE uDebug.inc}

{ TRoomCallFun }
{����:ת��Ϊ�����ַ���}
function ConvertSoundChar(soundChar: string): string;
begin
  Result := soundChar;
  if Result = '*' then
  begin
    Result := 'star';
  end;
end;


function TCallDevOP.AutoFirstCall(var strMsg: string): Boolean;
begin
  result := False;
  m_CallRecord.eCallResult := TR_FAIL;
  if bCalling()= True then
  begin
    strMsg := '�豸ռ����!';
    Exit;
  end;
{$IFNDEF UART_DEBUG}
  if OpenPort()= False then
  begin
    strMsg:= '�˿ڴ�ʧ��!';
    Exit;
  end;
{$ENDIF}
  m_bCancel := False;
  m_Thread := TCallDevThread.Create(true);
  m_Thread.OnExecute := ExecuteAutoFirstCall;
  m_Thread.RoomCallType := TCT_AutoCall;
  m_Thread.RoomCallState := TCS_FIRSTCALL;
  m_Thread.Resume;
  result := True;
end;

function TCallDevOP.AutoFirstCalls(CallMultiDevicesArray : RCallMultiDevicesArray;var strMsg: string): Boolean;
begin
  result := False;
  SetLength(m_CallMultiDevicesArray,0);     //���
  SetLength(m_CallMultiDevicesArray,Length(CallMultiDevicesArray) );   //���ó���
  //����
  Move(CallMultiDevicesArray[0],m_CallMultiDevicesArray[0],  Length(CallMultiDevicesArray)*sizeof(CallMultiDevicesArray[0]));

  m_CallRecord.eCallResult := TR_FAIL;
  if bCalling()= True then
  begin
    strMsg := '�豸ռ����!';
    Exit;
  end;
{$IFNDEF UART_DEBUG}
  if OpenPort()= False then
  begin
    strMsg:= '�˿ڴ�ʧ��!';
    Exit;
  end;
{$ENDIF}
  m_bCancel := False;
  m_Thread := TCallDevThread.Create(true);
  m_Thread.OnExecute := ExecuteAutoFirstCalls;
  m_Thread.RoomCallType := TCT_AutoCall;
  m_Thread.RoomCallState := TCS_FIRSTCALL;
  m_Thread.Resume;
  result := True;
end;

function TCallDevOP.AutoReCall(var strMsg: string): Boolean;
begin
  result := False;
  m_CallRecord.eCallResult := TR_FAIL;
  if bCalling()= True then
  begin
    strMsg := '�豸ռ����!';
    Exit;
  end;
{$IFNDEF UART_DEBUG}
  if OpenPort()= False then
  begin
    strMsg:= '�˿ڴ�ʧ��!';
    Exit;
  end;
{$ENDIF}
  m_bCancel := False;
  m_Thread := TCallDevThread.Create(true);
  m_Thread.OnExecute := ExecuteAutoReCall;
  m_Thread.RoomCallType := TCT_AutoCall;
  m_Thread.RoomCallState := TCS_RECALL;
  m_Thread.Resume;
  result := True;
end;

function TCallDevOP.AutoReCalls(CallMultiDevicesArray : RCallMultiDevicesArray;var strMsg: string): Boolean;
begin
  result := False;
  SetLength(m_CallMultiDevicesArray,0);
  SetLength(m_CallMultiDevicesArray,Length(CallMultiDevicesArray) );
  Move(CallMultiDevicesArray[0],m_CallMultiDevicesArray[0],  Length(CallMultiDevicesArray)*sizeof(CallMultiDevicesArray[0]));

  m_CallRecord.eCallResult := TR_FAIL;
  if bCalling()= True then
  begin
    strMsg := '�豸ռ����!';
    Exit;
  end;
{$IFNDEF UART_DEBUG}
  if OpenPort()= False then
  begin
    strMsg:= '�˿ڴ�ʧ��!';
    Exit;
  end;
{$ENDIF}
  m_bCancel := False;
  m_Thread := TCallDevThread.Create(true);
  m_Thread.OnExecute := ExecuteAutoReCalls;
  m_Thread.RoomCallType := TCT_AutoCall;
  m_Thread.RoomCallState := TCS_RECALL;
  m_Thread.Resume;
  result := True;
end;

function TCallDevOP.AutoServerRoomCall(var strMsg: string): Boolean;
begin
  result := False;
  m_CallRecord.eCallResult := TR_FAIL;
  if bCalling()= True then
  begin
    strMsg := '�豸ռ����!';
    Exit;
  end;

{$IFNDEF UART_DEBUG}
  if OpenPort()= False then
  begin
    strMsg:= '�˿ڴ�ʧ��!';
    Exit;
  end;
{$ENDIF}
  m_bCancel := False;
  m_Thread := TCallDevThread.Create(true);
  m_Thread.OnExecute := ExecuteAutoServerRoomCall;
  m_Thread.RoomCallType := TCT_AutoCall;
  m_Thread.RoomCallState := TCS_SERVER_ROOM_CALL;
  m_Thread.Resume;
  result := True;
end;

function TCallDevOP.bCalling: Boolean;
begin
  result := True;
  //ͨ���߳�������,

  if (m_Thread = nil) and  (m_bWorking = False) then
  begin
    result := False;
    Exit;
  end;

  //û��ͨ���̴߳���,�豸�ᱣ��60���ӵ�����״̬
  {if (GetTickCount - m_dtLastTalk) > 60000 then//����60��������Ϊ���豸�ѶϿ�
    result := False; }

end;

function TCallDevOP.bNight: Boolean;
begin
  Result := TPubFun.CheckInTimeSec(m_CallConfig.dtNightStartTime,
       m_CallConfig.dtNightEndTime,  now);
  
end;

function TCallDevOP.DisConDevice_NoCallBack(var strMsg:string):Boolean;
var
  callCommand: string;
begin
  Result := false;
  try
    if m_CallConfig.nComType> 0 then
    begin
      MinWaveOut;
      try
        if m_CallConfig.nOldVersion = 1 then
          callCommand := Format('***%s#', ['00000'])
        else
          callCommand := Format('***%s#', ['00005']);
       SendVoiceSignal(callCommand);
      finally
        MaxWaveOut('');
      end;
    end;
    m_CallCtl.SetPlayMode(0);
    if m_CallCtl.Hangup(m_CallRecord.nDeviceID) = 1 then
      Result := true;
    m_MixerRecord.Stop;
    m_bWorking := False;
  finally
    m_LastTastTime := GetTickCount;
    TLog.SaveLog(now, '�Ҷ��豸,�޻ص�' + strMsg);
  end;
end;

function TCallDevOP.DoFirstCall(var strMsg:string): boolean;
begin
  result := False;
  m_CallRecord.eCallResult := TR_FAIL;
  {
  if bCalling()= True then
  begin
    TLog.SaveLog(now, 'DoFirstCall_error');
    strMsg := '�豸ռ����!';
    Exit;
  end;
  }

  TLog.SaveLog(now, 'DoFirstCall_ok');
{$IFNDEF UART_DEBUG}
  if OpenPort()= False then
  begin
    strMsg:= '�˿ڴ�ʧ��!';
    Exit;
  end;
{$ENDIF}
  m_bCancel := False;
  m_Thread := TCallDevThread.Create(true);
  m_Thread.OnExecute := ExecuteFirstCall;
  m_Thread.RoomCallType := TCT_AutoCall;
  m_Thread.RoomCallState := TCS_FIRSTCALL;
  m_Thread.Resume;
  result := True;
end;

function TCallDevOP.DisConDevice(var strMsg:string): boolean;
begin
  if m_CallConfig.nComType > 0 then
    result := DisConDeviceMusic(strMsg)
  else
   result := DisConDeviceRS485(strMsg);
end;



function TCallDevOP.DisConDeviceAll(CallMultiDevicesArray : RCallMultiDevicesArray;var strMsg: string): Boolean;
var
  i : Integer ;
  callCommand: string;
  data:TCallDevCallBackData;
begin
  Result := false;
  try
    try
      TLog.SaveLog(now, '¼������');

      m_MixerRecord.Stop;
      data:=TCallDevCallBackData.Create;
      data.callRoomRecord.Clone(Self.m_CallRecord);
      data.callRoomRecord.CallVoice := TCallVoice.Create;
      data.callRoomRecord.CallVoice.vms := m_MixerRecord.GetRecordStream;

      m_bWorking := False;

      {$IFDEF UART_DEBUG}
        Result:= true ;
        exit ;
      {$ENDIF}

      m_CallCtl.SetPlayMode(0);
      //���͹Ҷ�ָ��
      for I := 0 to Length(CallMultiDevicesArray) - 1 do
      begin
        m_CallCtl.HangUp(CallMultiDevicesArray[i].idSrc) ;
      end;
      Result := true;
    except on e:Exception do
      data.callRoomRecord.strMsg := e.Message;
    end;
    //result := True;
  finally
    m_LastTastTime := GetTickCount;
    OnDisConDevEvent(data);
    data.Free;
    TLog.SaveLog(now, '444�а����');
  end;
end;

function TCallDevOP.DisConDeviceMusic(var strMsg: string): Boolean;
var
  callCommand: string;
  data:TCallDevCallBackData;
begin
  Result := false;
  try
    try
      TLog.SaveLog(now, '¼������');

      m_MixerRecord.Stop;
      data:=TCallDevCallBackData.Create;
      data.callRoomRecord.Clone(Self.m_CallRecord);
      data.callRoomRecord.CallVoice := TCallVoice.Create;
      data.callRoomRecord.CallVoice.vms := m_MixerRecord.GetRecordStream;

      m_bWorking := False;

      {$IFDEF UART_DEBUG}
        Result:= true ;
        exit ;
      {$ENDIF}

      if m_CallConfig.nComType> 0 then
      begin
        MinWaveOut;
        try
          if m_CallConfig.nOldVersion = 1 then
            callCommand := Format('***%s#', ['00000'])
          else
            callCommand := Format('***%s#', ['00005']);
         SendVoiceSignal(callCommand);
        finally
          MaxWaveOut('');
        end;
      end;
      m_CallCtl.SetPlayMode(0);
      m_CallCtl.Hangup(m_CallRecord.nDeviceID) ;
      //�ô��ڷ�ʽ�Ҷ�
      //���ô���ģʽ
      m_CallCtl.SetDialType(1);
      m_CallCtl.Hangup(m_CallRecord.nDeviceID) ;
      m_CallCtl.Hangup(m_CallRecord.nDeviceID) ;
      m_CallCtl.Hangup(m_CallRecord.nDeviceID) ;
      //�ָ�����ģʽ
      m_CallCtl.SetDialType(2);

      m_CallCtl.SetPlayMode(0);
      if m_CallCtl.Hangup(m_CallRecord.nDeviceID) = 1 then
        Result := true;
    except on e:Exception do
      data.callRoomRecord.strMsg := e.Message;
    end;
    //result := True;
  finally
    m_LastTastTime := GetTickCount;
    OnDisConDevEvent(data);
    data.Free;
    TLog.SaveLog(now, '444�а����');
  end;
end;

function TCallDevOP.DisConDeviceRS485(var strMsg: string): Boolean;
var
  callCommand: string;
  data:TCallDevCallBackData;
begin
  Result := false;
  try
    try
      TLog.SaveLog(now, '¼������');

      m_MixerRecord.Stop;
      data:=TCallDevCallBackData.Create;
      data.callRoomRecord.Clone(Self.m_CallRecord);
      data.callRoomRecord.CallVoice := TCallVoice.Create;
      data.callRoomRecord.CallVoice.vms := m_MixerRecord.GetRecordStream;

      m_bWorking := False;

      {$IFDEF UART_DEBUG}
        Result:= true ;
        exit ;
      {$ENDIF}

      m_CallCtl.SetPlayMode(0);
      if m_CallCtl.Hangup(m_CallRecord.nDeviceID) = 1 then
        Result := true;
    except on e:Exception do
      data.callRoomRecord.strMsg := e.Message;
    end;
    //result := True;
  finally
    m_LastTastTime := GetTickCount;
    OnDisConDevEvent(data);
    data.Free;
    TLog.SaveLog(now, '444�а����');
  end;
end;

procedure TCallDevOP.MaxWaveOut(strRoomNo: string);
var
  v: Longint;
  sound: Word;
begin
  sound := m_CallConfig.nDayTalkVolume;
  if bNight then
    sound:= m_CallConfig.nNightTalkVolume;
  v := (sound shl 8) or (sound shl 24);
  waveOutSetVolume(0, v);
  TAudio.SetMute(eCapture,False);
end;

procedure TCallDevOP.MinWaveOut;
var
  t, v: Longint;
begin
  t := m_CallConfig.nDialVolume;
  v := (t shl 8) or (t shl 24);
  waveOutSetVolume(0, v);
  TAudio.SetMute(eCapture,True);
end;



function TCallDevOP.MonitorConDevice(var strMsg: string): Boolean;
begin
  result := False;
  m_CallRecord.eCallResult := TR_FAIL;
  if bCalling()= True then
  begin
    strMsg := '�豸ռ����!';
    Exit;
  end;
{$IFNDEF UART_DEBUG}
  if OpenPort()= False then
  begin
    strMsg:= '�˿ڴ�ʧ��!';
    Exit;
  end;
{$ENDIF}
  m_CallCtl.SetDialType(m_CallConfig.nComType+1);
  m_bCancel := False;
  m_Thread := TCallDevThread.Create(true);
  m_Thread.OnExecute := ExecuteConDeviceForMonitor;
  m_Thread.RoomCallType := TCT_MonitorCall;
  m_Thread.Resume;
  result := True;
end;

function TCallDevOP.MonitorVoice(var strMsg: string): Boolean;
begin
  Result := m_CallCtl.MonitorDevice(m_CallRecord.nDeviceID) = 1;
end;

procedure TCallDevOP.SetMicrophoneMute(Value: boolean);
begin
  exit ;
  TAudio.SetMute(eCapture,Value);
end;

procedure TCallDevOP.SetPlaySoundTime(soundString: TStrings; dtTime: TDateTime);
var
  nHour,nMinute,nDiv,nMod: Integer;
begin
  nHour := StrToInt(FormatDateTime('h',dtTime));
  nDiv := nHour div 10;
  nMod := nHour mod 10;
  if nDiv > 0 then
  begin
    if nDiv > 1 then
      SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + IntToStr(nDiv) + '.wav');
    SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + 'ʮ.wav');
  end;
  if nMod > 0 then
  begin
    if nMod = 1 then
      SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + 'һ.wav')
    else
      SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + IntToStr(nMod) + '.wav');
  end
  else
    if nDiv = 0 then
      SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + '0.wav');
  SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + '��.wav');

  nMinute := StrToInt(FormatDateTime('n',dtTime));
  nDiv := nMinute div 10;
  nMod := nMinute mod 10;
  if (nDiv = 0) and (nMod = 0) then Exit;
  if nDiv > 0 then
  begin
    if nDiv > 1 then
      SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + IntToStr(nDiv) + '.wav');
    SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + 'ʮ.wav');
  end;
  if nMod > 0 then
  begin
    if nMod = 1 then
      SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + 'һ.wav')
    else
      SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + IntToStr(nMod) + '.wav');
  end;
  SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + '��.wav');
end;

function TCallDevOP.SetRoomCount(const num: Word): Integer;
begin
  Result := m_CallCtl.SetRoomCount(num);
end;

procedure TCallDevOP.StartConDevEvent(nTryTimes:Integer);
var
  data:TCallDevCallBackData;
begin
  data := TCallDevCallBackData.Create;
  m_CallRecord.nConTryTimes := nTryTimes;
  m_CallRecord.strMsg := '��ʼ�����豸';
  data.callRoomRecord.Clone(m_CallRecord);
  PostMessage(m_MSGhandle, WM_MSG_STARTCONDEV,0,Integer(data));
end;

procedure TCallDevOP.StartFirstCallPlayEvent();
var
  data:TCallDevCallBackData;
begin
  m_CallRecord.strMsg := '��ʼ�����׽�����';
  data := TCallDevCallBackData.Create;
  data.callRoomRecord.Clone(m_CallRecord);
  PostMessage(m_MSGhandle, WM_MSG_START_FIRSTCALLPLAY,0,Integer(data));
end;


procedure TCallDevOP.StartReCallPlayEvent();
var
  data:TCallDevCallBackData;
begin
  m_CallRecord.strMsg := '��ʼ���Ŵ߽�����';
  data := TCallDevCallBackData.Create;
  data.callRoomRecord.Clone(m_CallRecord);
  PostMessage(m_MSGhandle, WM_MSG_START_RECALLPLAY,0,Integer(data));
end;


procedure TCallDevOP.StartServerRoomCallPlayEvent;
var
  data:TCallDevCallBackData;
begin
  m_CallRecord.strMsg := '��ʼ���ŷ����Һ�������';
  data := TCallDevCallBackData.Create;
  data.callRoomRecord.Clone(m_CallRecord);
  PostMessage(m_MSGhandle, WM_MSG_START_SERVERROOM_CALLPLAY,0,Integer(data));
end;

procedure TCallDevOP.StopPlaySound;
begin
  if Self.bCalling then Exit;
  //m_CallCtl.SetPlayMode(2);


  MMSystem.PlaySound(nil, 0,0 );
end;

procedure TCallDevOP.WndMethod(var Msg: TMessage);
begin
  case  Msg.Msg  of
    WM_MSG_STARTCONDEV:OnDealStartConDev_Msg(Msg);
    WM_MSG_TRYCONDEV:OnDealTryConDev_Msg(Msg);
    WM_MSG_FINISHCONDEV :OnDealFinishConDev_Msg(Msg);
    WM_MSG_QUERY_CONDEV : OnDealQueryConDev_Msg(msg);
    WM_MSG_START_FIRSTCALLPLAY :OnDealStartFristCall_Msg(Msg);
    WM_MSG_FINISH_FIRSTCALLPLAY:OnDealFinishFirstCall_Msg(Msg);
    WM_MSG_START_RECALLPLAY :OnDealStartReCall_Msg(Msg);
    WM_MSG_FINISH_RECALLPLAY :OnDealFinishRecall_Msg(Msg);

    WM_MSG_START_SERVERROOM_CALLPLAY :OnDealStartServerRoomCall_Msg(Msg);
    WM_MSG_FINISH_SERVERROOM_CALLPLAY :OnDealFinishServerRoomcall_Msg(Msg);
    else
    Msg.Result := DefWindowProc(m_MSGhandle, Msg.Msg, Msg.wParam, Msg.lParam);
  end;
  
end;


function TCallDevOP.MunualFirstCallRoom(var strMsg:string):Boolean;
begin
  result := False;
  m_CallRecord.eCallResult := TR_FAIL;
{$IFNDEF UART_DEBUG}
  if OpenPort()= False then
  begin
    strMsg:= '�˿ڴ�ʧ��!';
    Exit;
  end;
{$ENDIF}
  m_Thread := TCallDevThread.Create(true);
  m_Thread.OnExecute := ExecuteFirstCall;
  m_Thread.Resume;
  result := True;
end;

function TCallDevOP.SendMultiDeviceInfo(CallDevAry: TCallDevAry): BOOL;
begin
  Result := m_CallCtl.SendRoomDeviceInfoList(CallDevAry) ;
end;

procedure TCallDevOP.SendVoiceSignal(callCommand:string);
var
  sound:string;
  i:Integer;
begin
  OutputDebugString('--------------------------------------���÷���ģʽ');
  m_CallCtl.SetPlayMode(1);
  for i := 1 to Length(callCommand) do
  begin
    sound := TPubFun.AppPath + 'Sounds\' + Format('%s.wav', [ConvertSoundChar(callCommand[i])]);
    PlaySound(PChar(Sound), 0, SND_FILENAME or SND_SYNC);
    //Application.ProcessMessages;
    Sleep(m_CallConfig.nDialInterval);
  end;
  //Application.ProcessMessages;
end;

{ TCallConfig }

constructor TCallConfig.Create;
begin
  m_SectionName := 'RoomCallConfig'
end;
destructor TCallConfig.Destroy;
begin

  inherited;
end;
function TCallConfig.GetReCallInterval: Integer;
var
  strTemp:string;
begin
  strTemp :=ReadIniFile(m_strIniFile,m_SectionName,'ReCallInterval');
  if strTemp <> '' then
    TryStrToInt(strTemp,result);
end;

function  TCallConfig.GetUnOutRoomNotifyInterval(): Integer;
var
  strTemp:string;
begin
  result := 20;
  strTemp :=ReadIniFile(m_strIniFile,m_SectionName,'UnOutRoomNotifyInterval');
  if strTemp <> '' then
    TryStrToInt(strTemp,result);
end;

function TCallConfig.GetAutoCheckAudioLine: Integer;
var
  strTemp:string;
begin
  strTemp :=ReadIniFile(m_strIniFile,m_SectionName,'AutoCheckAudioLine');
  if strTemp <> '' then
    TryStrToInt(strTemp,result);
end;
function TCallConfig.GetCallDelay: Integer;
var
  strTemp:string;
begin
  strTemp :=ReadIniFile(m_strIniFile,m_SectionName,'CallDelay');
  if strTemp <> '' then
    TryStrToInt(strTemp,result);
end;
function TCallConfig.GetComType: Integer;
var
  strTemp:string;
begin
  strTemp :=ReadIniFile(m_strIniFile,m_SectionName,'ComType');
  if strTemp <> '' then
    TryStrToInt(strTemp,result);
end;
function TCallConfig.GetDayTalkVolume: Integer;
var
  strTemp:string;
begin
  strTemp :=ReadIniFile(m_strIniFile,m_SectionName,'DayTalkVolume');
  if strTemp <> '' then
    TryStrToInt(strTemp,result);
end;
function TCallConfig.GetDialInterval: Integer;
var
  strTemp:string;
begin
  strTemp :=ReadIniFile(m_strIniFile,m_SectionName,'DialInterval');
  if strTemp <> '' then
    TryStrToInt(strTemp,result);
end;
function TCallConfig.GetDialVolume: Integer;
var
  strTemp:string;
begin
  strTemp :=ReadIniFile(m_strIniFile,m_SectionName,'DialVolume');
  if strTemp <> '' then
    TryStrToInt(strTemp,result);
end;
class function TCallConfig.GetInstance: TCallConfig;
begin
  if m_Self = nil then
    m_Self := TCallConfig.Create;
  result := m_Self;
end;
function TCallConfig.GetNightEndTime: TDateTime;
var
  strTemp:string;
begin
  strTemp :=ReadIniFile(m_strIniFile,m_SectionName,'NightEndTime');
  if strTemp <> '' then
    TryStrToDateTime(strTemp,result);
end;
function TCallConfig.GetOldVersion():Integer;
var
  strTemp:string;
begin
  strTemp :=ReadIniFile(m_strIniFile,m_SectionName,'OldVersion');
  if strTemp <> '' then
    TryStrToint(strTemp,result);
end;

function TCallConfig.GetVoiceStoreDays():Integer;
var
  strTemp:string;
begin
  result := 30;
  strTemp :=ReadIniFile(m_strIniFile,m_SectionName,'VoiceStoreDays');
  if strTemp <> '' then
    TryStrToint(strTemp,result);
end;

function TCallConfig.GetNightStartTime: TDateTime;
var
  strTemp:string;
begin
  strTemp :=ReadIniFile(m_strIniFile,m_SectionName,'NightStartTime');
  if strTemp <> '' then
    TryStrToDateTime(strTemp,result);
end;
function TCallConfig.GetNightTalkVolume: Integer;
var
  strTemp:string;
begin
  strTemp :=ReadIniFile(m_strIniFile,m_SectionName,'NightTalkVolume');
  if strTemp <> '' then
    TryStrToint(strTemp,result);
end;
function TCallConfig.GetPort: Integer;
var
  strTemp:string;
begin
  strTemp :=ReadIniFile(m_strIniFile,m_SectionName,'Port');
  if strTemp <> '' then
    TryStrToint(strTemp,result);
end;
function TCallConfig.GetWaitConfirm: Integer;
var
  strTemp:string;
begin
  strTemp :=ReadIniFile(m_strIniFile,m_SectionName,'WaitConfirm');
  if strTemp <> '' then
    TryStrToint(strTemp,result);
end;
procedure TCallConfig.SetReCallInterval(nAfterCallInterval: Integer);
var
  strTemp:string;
begin
  strTemp := IntToStr(nAfterCallInterval);
  WriteIniFile(m_strIniFile,m_SectionName,'ReCallInterval',strTemp);
end;

procedure TCallConfig.SetUnOutRoomNotifyInterval(nUnOutRoomNotifyInterval:Integer);
var
  strTemp:string;
begin
  strTemp := IntToStr(nUnOutRoomNotifyInterval);
  WriteIniFile(m_strIniFile,m_SectionName,'UnOutRoomNotifyInterval',strTemp);
end;

procedure TCallConfig.SetAutoCheckAudioLine(nAutoCheckAudioLine: Integer);
var
  strTemp:string;
begin
  strTemp := IntToStr(nAutoCheckAudioLine);
  WriteIniFile(m_strIniFile,m_SectionName,'AutoCheckAudioLine',strTemp);
end;
procedure TCallConfig.SetCallDelay(nCallDelay: Integer);
var
  strTemp:string;
begin
  strTemp := IntToStr(nCallDelay);
  WriteIniFile(m_strIniFile,m_SectionName,'CallDelay',strTemp);
end;
procedure TCallConfig.SetComType(nComType: Integer);
var
  strTemp:string;
begin
  strTemp := IntToStr(nComType);
  WriteIniFile(m_strIniFile,m_SectionName,'ComType',strTemp);
end;
procedure TCallConfig.SetConfigFile(strFilePathName: string);
begin
  m_strIniFile := strFilePathName ;
end;
procedure TCallConfig.SetDayTalkVolume(nDayTalkVolume: Integer);
var
  strTemp:string;
begin
  strTemp := IntToStr(nDayTalkVolume);
  WriteIniFile(m_strIniFile,m_SectionName,'DayTalkVolume',strTemp);
end;
procedure TCallConfig.SetDialInterval(nDialInterval: Integer);
var
  strTemp:string;
begin
  strTemp := IntToStr(nDialInterval);
  WriteIniFile(m_strIniFile,m_SectionName,'DialInterval',strTemp);
end;
procedure TCallConfig.SetDialVolume(nDialVolume: Integer);
var
  strTemp:string;
begin
  strTemp := IntToStr(nDialVolume);
  WriteIniFile(m_strIniFile,m_SectionName,'DialVolume',strTemp);
end;
procedure TCallConfig.SetNightEndTime(dtNightEndTime: TDateTime);
var
  strTemp:string;
begin
  strTemp := DateTimeToStr(dtNightEndTime);
  WriteIniFile(m_strIniFile,m_SectionName,'NightEndTime',strTemp);
end;
procedure TCallConfig.SetOldVersion(nOldVersion:Integer);
var
  strTemp:string;
begin
  strTemp := intToStr(nOldVersion);
  WriteIniFile(m_strIniFile,m_SectionName,'OldVersion',strTemp);
end;

procedure TCallConfig.SetVoiceStoreDays(nStoreDays:Integer);
var
  strTemp:string;
begin
  strTemp := intToStr(nStoreDays);
  WriteIniFile(m_strIniFile,m_SectionName,'nStoreDays',strTemp);
end;

procedure TCallConfig.SetNightStartTime(dtNightStartTime: TDateTime);
var
  strTemp:string;
begin
  strTemp := DateTimeToStr(dtNightStartTime);
  WriteIniFile(m_strIniFile,m_SectionName,'NightStartTime',strTemp);
end;
procedure TCallConfig.SetNightTalkVolume(nNightTalkVolume: Integer);
var
  strTemp:string;
begin
  strTemp := IntToStr(nNightTalkVolume);
  WriteIniFile(m_strIniFile,m_SectionName,'NightTalkVolume',strTemp);
end;
procedure TCallConfig.SetPort(nPort: Integer);
var
  strTemp:string;
begin
  strTemp := IntToStr(nPort);
  WriteIniFile(m_strIniFile,m_SectionName,'Port',strTemp);
end;
procedure TCallConfig.SetWaitConfirm(nWaitConfirm: Integer);
var
  strTemp:string;
begin
  strTemp := IntToStr(nWaitConfirm);
  WriteIniFile(m_strIniFile,m_SectionName,'WaitConfirm',strTemp);
end;

{ TCallDevOP }

function TCallDevOP.GetNewCallCommand(nDeviceID: Integer): string;
var
  roomString: string;
  buffer: array[0..5] of byte;
  jyc: byte;
  strjyc: string;
begin
  roomString := IntToStr(nDeviceID);
  if Length(roomString) = 3 then
    roomString := '0' + roomString;
  if Length(roomString) = 2 then
    roomString := '00' + roomString;
  if Length(roomString) = 1 then
    roomString := '000' + roomString;
  buffer[0] := $F;
  buffer[1] := StrToInt(roomString[1]);
  buffer[2] := StrToInt(roomString[2]);
  buffer[3] := StrToInt(roomString[3]);
  buffer[4] := StrToInt(roomString[4]);
  jyc := buffer[0];
  jyc := jyc xor buffer[1];
  jyc := jyc xor buffer[2];
  jyc := jyc xor buffer[3];
  jyc := jyc xor buffer[4];
  strjyc := inttostr(Integer(jyc));
  strjyc := (strjyc[length(strjyc)]);
  Result := Format('*%s%s#', [roomString, strjyc]);
end;

function TCallDevOP.GetOldCallCommand(nDeviceID: Integer): string;
var
  roomString: string;
begin
  roomString := IntToStr(nDeviceID);
  if Length(roomString) = 4 then
    roomString := '0' + roomString;
  if Length(roomString) = 3 then
    roomString := '00' + roomString;
  if Length(roomString) = 2 then
    roomString := '000' + roomString;
  if Length(roomString) = 1 then
    roomString := '0000' + roomString;
  Result := Format('***%s#', [roomString]);
end;

function TCallDevOP.HaveReverseCall(out nDevNum: Integer;var strMsg:string): Boolean;
var
  nDev:Word ;
begin
  result := False;
  if bCalling()= True then
  begin
    strMsg := '�豸ռ����!';
    Exit;
  end;
{$IFNDEF UART_DEBUG}
  if OpenPort()= False then
  begin
    strMsg:= '�˿ڴ�ʧ��!';
    Exit;
  end;
{$ENDIF}


  if m_CallCtl.ReverseCallDevice(nDev)  then
  begin
    nDevNum := nDev;
    result := True;
    exit;
  end;

end;

procedure TCallDevOP.TryConDevEvent(nTryTimes: Integer; callResult: TRoomCallResult; strMsg: string);
var
  data:TCallDevCallBackData;
begin
  m_CallRecord.nConTryTimes := nTryTimes;
  m_CallRecord.eCallResult := callResult;
  m_CallRecord.strMsg := strMsg;

  data := TCallDevCallBackData.Create;
  data.callRoomRecord.Clone(m_CallRecord);
  PostMessage(m_MSGhandle, WM_MSG_TRYCONDEV,0,Integer(data));
end;

function TCallDevOP.FindIDByRoom(RoomNumber: string; out num: word): Boolean;
begin
  Result := m_CallCtl.FindIDByRoom(RoomNumber,num);
end;

procedure TCallDevOP.FinishConDevEvent(nTryTimes: Integer; callResult: TRoomCallResult;
  strMsg: string);
var
  data:TCallDevCallBackData;
begin
  m_CallRecord.nConTryTimes := nTryTimes;
  m_CallRecord.eCallResult := callResult;
  m_CallRecord.strMsg := strMsg;

  TLog.SaveLog(Now,  Format('��%d�κ��з����豸,���:%s',[nTryTimes,TRoomCallResultNameAry[callResult]]));
  data := TCallDevCallBackData.Create;
  data.callRoomRecord.Clone(m_CallRecord);
  PostMessage(m_MSGhandle, WM_MSG_FINISHCONDEV,0,Integer(data));
end;

procedure TCallDevOP.FinishFirstCallPlayEvent(callResult: TRoomCallResult;strMsg:string);
var
  data:TCallDevCallBackData;
begin
  m_CallRecord.eCallResult := callResult;
  m_CallRecord.strMsg := strMsg;
  
  data := TCallDevCallBackData.Create;
  data.callRoomRecord.Clone(m_CallRecord);

  PostMessage(m_MSGhandle, WM_MSG_FINISH_FIRSTCALLPLAY,0,Integer(data));
end;

procedure TCallDevOP.FinishReCallPlayEvent(callResult: TRoomCallResult;strMsg:string);
var
  data:TCallDevCallBackData;
begin
  m_CallRecord.eCallResult := callResult;
  m_CallRecord.strMsg := strMsg;

  data := TCallDevCallBackData.Create;
  data.callRoomRecord.Clone(m_CallRecord);

  PostMessage(m_MSGhandle, WM_MSG_FINISH_RECALLPLAY,0,Integer(data));
end;




procedure TCallDevOP.FinishServerRoomCallPlayEvent(callResult: TRoomCallResult;
  strMsg: string);
var
  data:TCallDevCallBackData;
begin
  m_CallRecord.eCallResult := callResult;
  m_CallRecord.strMsg := strMsg;

  data := TCallDevCallBackData.Create;
  data.callRoomRecord.Clone(m_CallRecord);

  PostMessage(m_MSGhandle, WM_MSG_FINISH_SERVERROOM_CALLPLAY,0,Integer(data));
end;

procedure TCallDevOP.OnDealStartConDev_Msg(msg: TMessage);
var
  data:TCallDevCallBackData;
begin
  data := TCallDevCallBackData(msg.LParam);
  try
    if Assigned(m_StartConDevEvent) then
      m_StartConDevEvent(data);
  finally
    data.Free;
  end;
end;

procedure TCallDevOP.OnDealStartFristCall_Msg(msg:TMessage);
var
  data:TCallDevCallBackData;
begin
  data := TCallDevCallBackData(msg.LParam);
  try
    if Assigned(m_StartFistrCallVoiceEvent) then
    begin
      m_StartFistrCallVoiceEvent(data);
    end;
  finally
    data.Free;
  end;
end;
procedure TCallDevOP.OnDealStartReCall_Msg(msg:TMessage);
var
  data:TCallDevCallBackData;
begin
  data := TCallDevCallBackData(msg.LParam);
  try
    if Assigned(m_StartReCallVoiceEvent) then
    begin

      m_StartReCallVoiceEvent(data);
    end;
  finally
    data.Free;
  end;
end;
procedure TCallDevOP.OnDealStartServerRoomCall_Msg(msg: TMessage);
var
  data:TCallDevCallBackData;
begin
  data := TCallDevCallBackData(msg.LParam);
  try
    if Assigned(m_StartServerRoomCallVoiceEvent) then
    begin

      m_StartServerRoomCallVoiceEvent(data);
    end;
  finally
    data.Free;
  end;
end;

function TCallDevOP.CallMultiDevices(Src: RCallMultiDevicesArray): Boolean;
begin
  Result := m_CallCtl.CallMultiDevices(Src) ;
end;

function TCallDevOP.CheckConResult(var strMsg:string): Boolean;
var
  i:Integer;
begin
  result := False;
  for i := 0 to 5 do
  begin
    if SaftySleep(1000,strMsg) = False then  Exit;

    if m_CallCtl.QueryDeviceState(m_CallRecord.nDeviceID) then
    begin
      strMsg := format('����豸״̬�ɹ�,��[%d]��!',[i+1]);
      TLog.SaveLog(now, '����豸״̬�ɹ�!');
      Result := True;
      break;
    end else begin
      strMsg := format('����豸״̬ʧ��,��[%d]��!',[i+1]);
      TLog.SaveLog(now, strMsg);
    end;
  end;
end;

function TCallDevOP.CheckLastCallTime(): Boolean;
begin
  result := False;
  if (GetTickCount- m_LastTastTime) > (m_CallConfig.nCallDelay *1000) then
    result := True;
  
end;

procedure TCallDevOP.CloseThread;
begin
  if Assigned(m_Thread) then
  begin
    m_Thread.WaitFor;
    FreeAndNil(m_Thread);
  end;
end;

function TCallDevOP.MunualConDevice(var strMsg:string): Boolean;
begin
  result := False;
  m_CallRecord.eCallResult := TR_FAIL;
  if bCalling()= True then
  begin
    strMsg := '�豸ռ����!';
    Exit;
  end;
{$IFNDEF UART_DEBUG}
  if OpenPort()= False then
  begin
    strMsg:= '�˿ڴ�ʧ��!';
    Exit;
  end;
{$ENDIF}
  m_CallCtl.SetDialType(m_CallConfig.nComType+1);
  m_bCancel := False;
  m_Thread := TCallDevThread.Create(true);
  m_Thread.OnExecute := ExecuteConDevice;
  m_Thread.RoomCallType := TCT_MunualCall;
  m_Thread.Resume;
  result := True;
end;

function TCallDevOP.ConDev_COM(var strMsg:string): Boolean;
begin
  result := False ;
  if m_CallCtl.CallDevice(m_CallRecord.nDeviceID) <> 1 then
  begin
    strMsg := '�����豸��' + IntToStr(m_CallRecord.nDeviceID) + ' ʧ�ܣ�';
    exit;
  end;
  strMsg:= '�����豸��' + IntToStr(m_CallRecord.nDeviceID) + ' �ɹ���' ;
  if saftySleep(500,strMsg) = False then Exit;
  result :=CheckConResult(strMsg);
end;

function TCallDevOP.ConDev_Voice(var strMsg:string): Boolean;
var
  callCommand:string;
begin
  result := False;
  if m_CallCtl.CallDevice(m_CallRecord.nDeviceID) <> 1 then
  begin
    strMsg := '�����豸��' + IntToStr(m_CallRecord.nDeviceID) + ' ʧ�ܣ�';
    exit;
  end;
  if SaftySleep(300,strMsg) then
  begin
    strMsg := '��ͣ0.3s:' +  IntToStr(m_CallRecord.nDeviceID);
  end;
  
  callCommand := GetNewCallCommand(m_CallRecord.nDeviceID);
  //callCommand := GetOldCallCommand(m_CallData.nDeviceID);
  MinWaveOut;
  try
    SendVoiceSignal(callCommand);
    Result := CheckConResult(strMsg) ;
  finally
    if Result =False then
    begin
      //DisConDevice_NoCallBack(strMsg);
    end;
    MaxWaveOut('');
  end;
end;

function TCallDevOP.ConnectReverseCall(nDevNum: Integer;var strMsg:string): Boolean;
begin
  result := False;
  m_CallRecord.eCallResult := TR_FAIL;
  if bCalling()= True then
  begin
    strMsg := '�豸ռ����!';
    Exit;
  end;
{$IFNDEF UART_DEBUG}
  if OpenPort()= False then
  begin
    strMsg:= '�˿ڴ�ʧ��!';
    Exit;
  end;
{$ENDIF}



  if m_CallCtl.ConnectReverseCallDevice(nDevNum) <> 1 then
  begin
    exit;
  end;
  result := True ;
end;

constructor TCallDevOP.Create();
begin
  m_bWorking:= False;
  m_LastTastTime:=0;

{$IFDEF RS485}
  m_CallCtl := TCallControl.Create;
{$else}
  m_CallCtl := TCallControl.Create(cpRS232);
{$endif}
  //�˿��Ƿ��Ѵ�
  m_bPortOpened:= False;
  //�رսа�
  m_bCancel:=False;
  m_MSGhandle := AllocateHWnd(WndMethod);
  m_MixerRecord := TMixerRecord.Create;
  m_CallRecord:=TCallRoomRecord.Create;
end;


destructor TCallDevOP.Destroy;
begin
  DeallocateHWnd(m_MSGhandle);
  m_CallCtl.Free;
  TLog.SaveLog(now, '¼���˳���');
  m_MixerRecord.Stop;
  m_MixerRecord.Free;
  m_CallRecord.Free;
  inherited;
end;

function TCallDevOP.ExecuteAutoFirstCall():Boolean;
begin
  result := False;
{$IFNDEF UART_DEBUG}
  m_CallCtl.SetDialType(2);
{$ENDIF}
  //�����豸 ʧ��ֱ���˳�
  if ExecuteConDevice = False then
  begin
    TLog.SaveLog(now,'�׽�->�����豸->error');
    Exit;
  end;

  //�׽�ʧ��,ֱ���˳�
  if ExecuteFirstCall = False then
  begin
    TLog.SaveLog(now,'�׽�->ִ�к���->error');
    Exit;
  end;
  result := True;

end;

function TCallDevOP.ExecuteAutoFirstCalls: Boolean;
begin
  result := False;
{$IFNDEF UART_DEBUG}
  m_CallCtl.SetDialType(2);
{$ENDIF}
  //�����豸 ʧ��ֱ���˳�
  if ExecuteConDevices = False then
  begin
    TLog.SaveLog(now,'�׽�->�����豸->error');
    Exit;
  end;

  //�׽�ʧ��,ֱ���˳�
  if ExecuteFirstCalls = False then
  begin
    TLog.SaveLog(now,'�׽�->ִ�к���->error');
    Exit;
  end;
  result := True;
end;

function TCallDevOP.ExecuteAutoReCall():Boolean;
begin
  result := False;
  try
{$IFNDEF UART_DEBUG}
    m_CallCtl.SetDialType(2);
{$ENDIF}
    //�����豸 ʧ��ֱ���˳�
    if ExecuteConDevice = False then
    begin
      TLog.SaveLog(now,'�߽�->�����豸->error');
      Exit;
    end;
    //�߽�ʧ��,ֱ���˳�
    if ExecuteReCall = False then
    begin
      TLog.SaveLog(now,'�߽�->��ʼ�߽�->error');
      Exit;
    end;
  finally
    //Self.DisConDevice(strMsg);
  end;
  result := True;
end;

function TCallDevOP.ExecuteAutoReCalls: Boolean;
begin
  result := False;
  try
{$IFNDEF UART_DEBUG}
    m_CallCtl.SetDialType(2);
{$ENDIF}
    //�����豸 ʧ��ֱ���˳�
    if ExecuteConDevices = False then
    begin
      TLog.SaveLog(now,'�߽�->�����豸->error');
      Exit;
    end;
    //�߽�ʧ��,ֱ���˳�
    if ExecuteReCalls = False then
    begin
      TLog.SaveLog(now,'�߽�->��ʼ�߽�->error');
      Exit;
    end;
  finally
    //Self.DisConDevice(strMsg);
  end;
  result := True;
end;

function TCallDevOP.ExecuteAutoServerRoomCall: Boolean;
begin
  result := False;
  try
{$IFNDEF UART_DEBUG}
    m_CallCtl.SetDialType(2);
{$ENDIF}
    //�����豸 ʧ��ֱ���˳�
    if ExecuteConDevice = False then
    begin
      TLog.SaveLog(now,'�������->�����豸->error');
      Exit;
    end;

    //,ֱ���˳�
    if ExecuteServerRoomCall = False then
    begin
      TLog.SaveLog(now,'�������->ִ�к���->error');
      Exit;
    end;
  finally
    //Self.DisConDevice(strMsg);
  end;
  result := True;
end;

function TCallDevOP.ExecuteConDevice():Boolean;
var
  callCommand: string;
  nDevID: Integer;
  bCon:Boolean;
  maxCallCount:Integer;
  strMsg:string;
begin
{$IFDEF UART_DEBUG}
  StartConDevEvent(1);
  Sleep(10);
  FinishConDevEvent(1,TR_SUCESS,strMsg);
  Result:= true ;
  exit ;
{$ENDIF}
  m_bConSucess := False;
  result := False;
  maxCallCount := 0;
  m_bWorking := True;
  nDevID := m_CallRecord.nDeviceID;
  
    //���͹Ҷ���Ƶ�ź�
    if m_CallConfig.nComType> 0 then
    begin
      MinWaveOut;
      try
        if m_CallConfig.nOldVersion = 1 then
          callCommand := Format('***%s#', ['00000'])
        else
          callCommand := Format('***%s#', ['00005']);
       SendVoiceSignal(callCommand);
      finally
        MaxWaveOut('');
      end;
    end;

    repeat
      try
        if SaftySleep(500,strMsg) = False  then
        begin
          FinishConDevEvent(maxCallCount + 1,TR_CANCEL,strMsg);
          Exit;
        end;
        StartConDevEvent(maxCallCount+1);

        if m_CallConfig.nComType = 0 then
        begin
          bCon := ConDev_COM(strMsg);
          strMsg:= '���ڷ�ʽ:' + strMsg;
        end
        else
        begin
          bCon := ConDev_Voice(strMsg);
          strMsg:= '��Ƶ��ʽ:' + strMsg;
        end;

        if bCon = False then
        begin
          TryConDevEvent(maxCallCount+1,TR_FAIL,strMsg);

          if Self.m_bCancel then
          begin
            FinishConDevEvent(maxCallCount + 1,TR_CANCEL,strMsg);
            Exit;
          end;
      
          Inc(maxCallCount);
        end
        else begin
          FinishConDevEvent(maxCallCount+1,TR_SUCESS,strMsg);
          result := True;
          Exit;
        end;
      except on e:Exception do
        begin
          TryConDevEvent(maxCallCount+1,TR_FAIL,'�豸�쳣');
          Exit;
        end;
      end;
    until (maxCallCount >= 5);

    m_LastTastTime := GetTickCount;
    FinishConDevEvent(maxCallCount+1,TR_TIMEOUT,'�޷�����');


end;

function TCallDevOP.ExecuteConDeviceForMonitor: Boolean;
var
  callCommand: string;
  nDevID: Integer;
  bCon:Boolean;
  maxCallCount:Integer;
  strMsg:string;
begin
{$IFDEF UART_DEBUG}
  StartConDevEvent(1);
  Sleep(10);
  FinishConDevEvent(1,TR_SUCESS,strMsg);
  Result:= true ;
  exit ;
{$ENDIF}
  m_bConSucess := False;
  result := False;
  maxCallCount := 0;
  m_bWorking := True;
  nDevID := m_CallRecord.nDeviceID;
  


    repeat
      try
        if SaftySleep(500,strMsg) = False  then
        begin
          FinishConDevEvent(maxCallCount + 1,TR_CANCEL,strMsg);
          Exit;
        end;
        StartConDevEvent(maxCallCount+1);

        if m_CallConfig.nComType = 0 then
        begin
          bCon := MonitorVoice(strMsg);
          strMsg:= '���ڷ�ʽ:' + strMsg;
        end
        else
        begin
          bCon := ConDev_Voice(strMsg);
          strMsg:= '��Ƶ��ʽ:' + strMsg;
        end;

        if bCon = False then
        begin
          TryConDevEvent(maxCallCount+1,TR_FAIL,strMsg);

          if Self.m_bCancel then
          begin
            FinishConDevEvent(maxCallCount + 1,TR_CANCEL,strMsg);
            Exit;
          end;
      
          Inc(maxCallCount);
        end
        else begin
          FinishConDevEvent(maxCallCount+1,TR_SUCESS,strMsg);
          result := True;
          Exit;
        end;
      except on e:Exception do
        begin
          TryConDevEvent(maxCallCount+1,TR_FAIL,'�豸�쳣');
          Exit;
        end;
      end;
    until (maxCallCount >= 5);

    m_LastTastTime := GetTickCount;
    FinishConDevEvent(maxCallCount+1,TR_TIMEOUT,'�޷�����');


end;

function TCallDevOP.ExecuteConDevices: Boolean;
var
  i : Integer ;
  callCommand: string;
  nDevID: Integer;
  bCon:Boolean;
  maxCallCount:Integer;
  strMsg:string;
begin
{$IFDEF UART_DEBUG}
  StartConDevEvent(1);
  Sleep(10);
  FinishConDevEvent(1,TR_SUCESS,strMsg);
  Result:= true ;
  exit ;
{$ENDIF}
  m_bConSucess := False;
  result := False;
  maxCallCount := 0;
  m_bWorking := True;
  nDevID := m_CallRecord.nDeviceID;
  
  //���ͺ���ָ��
  if  not  CallMultiDevices(m_CallMultiDevicesArray) then
      exit ;

    repeat
      try
        if SaftySleep(500,strMsg) = False  then
        begin
          FinishConDevEvent(maxCallCount + 1,TR_CANCEL,strMsg);
          Exit;
        end;
        StartConDevEvent(maxCallCount+1);

        //��ȡ�����豸��״̬
        for I := 0 to Length(m_CallMultiDevicesArray) - 1 do
        begin
          bCon := QueryConResult485(m_CallMultiDevicesArray[i].idSrc,strMsg);
          if not bCon then
          begin
              strMsg := Format('����[%s]����ʧ��',[m_CallMultiDevicesArray[i].roomnumber]);
             QueryConDevEvent(maxCallCount+1,TR_FAIL,strMsg);
          end
          else
          begin
            strMsg := Format('����[%s]���ӳɹ�',[m_CallMultiDevicesArray[i].roomnumber]);
            QueryConDevEvent(maxCallCount+1,TR_SUCESS,strMsg);
          end;
        end;

        bCon := True ;
        if bCon = False then
        begin
          TryConDevEvent(maxCallCount+1,TR_FAIL,strMsg);

          if Self.m_bCancel then
          begin
            FinishConDevEvent(maxCallCount + 1,TR_CANCEL,strMsg);
            Exit;
          end;
      
          Inc(maxCallCount);
        end
        else
        begin
          FinishConDevEvent(maxCallCount+1,TR_SUCESS,strMsg);
          result := True;
          Exit;
        end;
      except on e:Exception do
        begin
          TryConDevEvent(maxCallCount+1,TR_FAIL,'�豸�쳣');
          Exit;
        end;
      end;
    until (maxCallCount >= 5);

    m_LastTastTime := GetTickCount;
    FinishConDevEvent(maxCallCount+1,TR_TIMEOUT,'�޷�����');


end;

function TCallDevOP.ExecuteFirstCall():Boolean;
const
  MAX_CALL_COUNT : INTEGER = 3;
  ELAPSE_SECOND  : INTEGER = 10 ;
var
  strBkMuisc:string;
  soundString: TStrings;
  i,j: Integer;
  strName:string;
  bHZroomnumber: Boolean; //�Ƿ�Ϊ���ַ����
  strHZroomnumber: string; //���ַ��䲥�ŵ������ļ�
  roomNumber, trainNo, strTime: string;
begin
  StartFirstCallPlayEvent();//��ʼ�����׽�����
  roomNumber := m_CallRecord.strRoomNum;
  strName := m_CallRecord.CallManRecordList[0].strTrainmanName;

  trainNo := m_CallRecord.strTrainNo;
  strTime := TPubFun.DateTime2Str(m_CallRecord.dtCallTime);
  bHZroomnumber := False;
  MaxWaveOut(roomNumber);
  SetMicrophoneMute(False);   //�ر���˷�

  soundString := TStringList.Create;
  try
    //������
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\Gmrhy14a.wav');

    try
      StrToInt(roomNumber);
      for i := 1 to Length(roomNumber) do
      begin
        soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + roomNumber[i] + '.wav');
      end;
    except
      bHZroomnumber := True;
      strHZroomnumber := ExtractFilePath(Application.ExeName) + 'CallMusic\' + '�㲥����.wav';
    end;

    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\����.wav');
    for i := 1 to Length(trainNo) do
    begin
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + trainNo[i] + '.wav')
    end;
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\���г����ڽа�.wav');

    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\����\'+ Copy(strName,1,2) + '.wav');
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\ʦ����ش�.wav');
    TLog.SaveLog(now, '���ò���ģʽ');
    SetMicrophoneMute(True); //����˷�
    m_CallCtl.SetPlayMode(1);

    if bHZroomnumber then
    begin
      PlaySound(PChar(strHZroomnumber), 0, SND_FILENAME or SND_ASYNC);
    end
    else
    begin
      for i := 0 to soundString.Count - 1 do
      begin
        if m_bCancel then
        begin
          Self.FinishFirstCallPlayEvent(TR_CANCEL,'ȡ������');
          Exit;
        end;

        TLog.SaveLog(now, '�����ַ�' + soundString[i]);
        PlaySound(PChar(soundString[i]), 0, SND_FILENAME or SND_SYNC);
        TLog.SaveLog(now, '�����ַ����' + soundString[i]);
      end;
    end;

    Self.FinishFirstCallPlayEvent(TR_SUCESS,'��ɲ���');
  finally
    soundString.Free;
  end;
end;

function TCallDevOP.ExecuteFirstCalls: Boolean;
const
  MAX_CALL_COUNT : INTEGER = 3;
  ELAPSE_SECOND  : INTEGER = 10 ;
var
  strBkMuisc:string;
  soundString: TStrings;
  i,j,k: Integer;
  strName:string;
  bHZroomnumber: Boolean; //�Ƿ�Ϊ���ַ����
  strHZroomnumber: string; //���ַ��䲥�ŵ������ļ�
  strJoinRoomNumber,roomNumber, trainNo, strTime: string;
  joinRooms : TStringList ;
begin
  StartFirstCallPlayEvent();//��ʼ�����׽�����
  roomNumber := m_CallRecord.strRoomNum;
  strName := m_CallRecord.CallManRecordList[0].strTrainmanName;

  trainNo := m_CallRecord.strTrainNo;
  strTime := TPubFun.DateTime2Str(m_CallRecord.dtCallTime);
  bHZroomnumber := False;
  MaxWaveOut(roomNumber);
  SetMicrophoneMute(False);   //�ر���˷�

  joinRooms := TStringList.Create;
  soundString := TStringList.Create;
  try
    //������
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\Gmrhy14a.wav');

    try
      //���з���
      StrToInt(roomNumber);
      for i := 1 to Length(roomNumber) do
      begin
        soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + roomNumber[i] + '.wav');
      end;
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\����.wav');

      CallRecord.GetJoinRooms(joinRooms);
      //������������
      for I := 0 to joinRooms.Count - 1 do
      begin
        strJoinRoomNumber := joinRooms.Strings[i];
        StrToInt(strJoinRoomNumber);
        for k := 1 to Length(strJoinRoomNumber) do
        begin
          soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + strJoinRoomNumber[k] + '.wav');
        end;
        soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\����.wav');
      end;

    except
      bHZroomnumber := True;
      strHZroomnumber := ExtractFilePath(Application.ExeName) + 'CallMusic\' + '�㲥����.wav';
    end;

    //soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\����.wav');
    for i := 1 to Length(trainNo) do
    begin
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + trainNo[i] + '.wav')
    end;
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\���г����ڽа�.wav');

    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\����\'+ Copy(strName,1,2) + '.wav');
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\ʦ����ش�.wav');
    TLog.SaveLog(now, '���ò���ģʽ');
    SetMicrophoneMute(True); //����˷�
    m_CallCtl.SetPlayMode(1);

    if bHZroomnumber then
    begin
      PlaySound(PChar(strHZroomnumber), 0, SND_FILENAME or SND_ASYNC);
    end
    else
    begin
      for i := 0 to soundString.Count - 1 do
      begin
        if m_bCancel then
        begin
          Self.FinishFirstCallPlayEvent(TR_CANCEL,'ȡ������');
          Exit;
        end;

        TLog.SaveLog(now, '�����ַ�' + soundString[i]);
        PlaySound(PChar(soundString[i]), 0, SND_FILENAME or SND_SYNC);
        TLog.SaveLog(now, '�����ַ����' + soundString[i]);
      end;
    end;

    Self.FinishFirstCallPlayEvent(TR_SUCESS,'��ɲ���');
  finally
    joinRooms.Free;
    soundString.Free;
  end;
end;

function TCallDevOP.ExecuteReCall: Boolean;
var
  soundString: TStrings;
  i: Integer;
  bHZroomnumber: Boolean; //�Ƿ�Ϊ���ַ����
  strHZroomnumber: string; //���ַ��䲥�ŵ������ļ�
begin
  StartReCallPlayEvent();//��ʼ�����׽�����
  bHZroomnumber := False;
  MaxWaveOut(m_CallRecord.strRoomNum);
  SetMicrophoneMute(False);   //�ر���˷�
  TLog.SaveLog(now, 'TCallDevOP.ExecuteReCall::�ر���˷�');

  soundString := TStringList.Create;
  try
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\Gmrhy14a.wav');

    for i := 1 to Length(m_CallRecord.strTrainNo) do
    begin
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + m_CallRecord.strTrainNo[i] + '.wav')
    end;
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\���ѽа���ץ��ʱ�����.wav');
    try
      StrToInt(m_CallRecord.strRoomNum);
      for i := 1 to Length(m_CallRecord.strRoomNum) do
      begin
        soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + m_CallRecord.strRoomNum[i] + '.wav');
      end;
    except
      bHZroomnumber := True;
      strHZroomnumber := ExtractFilePath(Application.ExeName) + 'CallMusic\' + '�㲥����.wav';
    end;
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\����.wav');

    for i := 1 to Length(m_CallRecord.strTrainNo) do
    begin
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + m_CallRecord.strTrainNo[i] + '.wav')
    end;
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\���ѽа���ץ��ʱ�����.wav');
    TLog.SaveLog(now, '���ò���ģʽ');
    SetMicrophoneMute(True);   //�ر���˷�
    TLog.SaveLog(now, 'TCallDevOP.ExecuteReCall::������˷�');

    m_CallCtl.SetPlayMode(1);
    if bHZroomnumber then
    begin
      PlaySound(PChar(strHZroomnumber), 0, SND_FILENAME or SND_SYNC);
    end
    else
    begin
      for i := 0 to soundString.Count - 1 do
      begin
        if m_bCancel then
        begin
          Self.FinishReCallPlayEvent(TR_CANCEL,'ȡ������');
          Exit;
        end;
        TLog.SaveLog(now, '�����ַ�' + soundString[i]);
        PlaySound(PChar(soundString[i]), 0, SND_FILENAME or SND_SYNC);
        TLog.SaveLog(now, '�����ַ����' + soundString[i]);
      end;
    end;
  Self.FinishReCallPlayEvent(TR_SUCESS,'��ɲ���');
  finally
    soundString.Free;
  end;
end;


function TCallDevOP.ExecuteReCalls: Boolean;
var
  soundString: TStrings;
  i,j: Integer;
  bHZroomnumber: Boolean; //�Ƿ�Ϊ���ַ����
  strJoinRoomNumber,strHZroomnumber: string; //���ַ��䲥�ŵ������ļ�
  joinRooms : TStringList ;
begin
  StartReCallPlayEvent();//��ʼ�����׽�����
  bHZroomnumber := False;
  MaxWaveOut(m_CallRecord.strRoomNum);
  SetMicrophoneMute(False);   //�ر���˷�
  TLog.SaveLog(now, 'TCallDevOP.ExecuteReCall::�ر���˷�');

  joinRooms := TStringList.Create ;
  soundString := TStringList.Create;
  try
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\Gmrhy14a.wav');

    for i := 1 to Length(m_CallRecord.strTrainNo) do
    begin
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + m_CallRecord.strTrainNo[i] + '.wav')
    end;
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\���ѽа���ץ��ʱ�����.wav');
    try
      StrToInt(m_CallRecord.strRoomNum);
      for i := 1 to Length(m_CallRecord.strRoomNum) do
      begin
        soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + m_CallRecord.strRoomNum[i] + '.wav');
      end;
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\����.wav');


      CallRecord.GetJoinRooms(joinRooms);
      //������������
      for I := 0 to joinRooms.Count - 1 do
      begin
        strJoinRoomNumber := joinRooms.Strings[i];
        StrToInt(strJoinRoomNumber);
        for j := 1 to Length(strJoinRoomNumber) do
        begin
          soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + strJoinRoomNumber[j] + '.wav');
        end;
        soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\����.wav');
      end;


    except
      bHZroomnumber := True;
      strHZroomnumber := ExtractFilePath(Application.ExeName) + 'CallMusic\' + '�㲥����.wav';
    end;


    for i := 1 to Length(m_CallRecord.strTrainNo) do
    begin
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + m_CallRecord.strTrainNo[i] + '.wav')
    end;
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\���ѽа���ץ��ʱ�����.wav');
    TLog.SaveLog(now, '���ò���ģʽ');
    SetMicrophoneMute(True);   //�ر���˷�
    TLog.SaveLog(now, 'TCallDevOP.ExecuteReCall::������˷�');

    m_CallCtl.SetPlayMode(1);
    if bHZroomnumber then
    begin
      PlaySound(PChar(strHZroomnumber), 0, SND_FILENAME or SND_SYNC);
    end
    else
    begin
      for i := 0 to soundString.Count - 1 do
      begin
        if m_bCancel then
        begin
          Self.FinishReCallPlayEvent(TR_CANCEL,'ȡ������');
          Exit;
        end;
        TLog.SaveLog(now, '�����ַ�' + soundString[i]);
        PlaySound(PChar(soundString[i]), 0, SND_FILENAME or SND_SYNC);
        TLog.SaveLog(now, '�����ַ����' + soundString[i]);
      end;
    end;
  Self.FinishReCallPlayEvent(TR_SUCESS,'��ɲ���');
  finally
    joinRooms.Free;
    soundString.Free;
  end;
end;

function TCallDevOP.ExecuteServerRoomCall: Boolean;
{
�����ҷ����XXX��ע�⣬�����XXX�ѽа࣬�����XXX�ѽаࣨ�������飩���������䡣
}
var
  soundString: TStrings;
  i: Integer;
  bHZroomnumber: Boolean; //�Ƿ�Ϊ���ַ����
  strHZroomnumber: string; //���ַ��䲥�ŵ������ļ�
begin
  StartServerRoomCallPlayEvent();//��ʼ�����׽�����
  bHZroomnumber := False;
  MaxWaveOut(m_CallRecord.strRoomNum);
  SetMicrophoneMute(False);   //�ر���˷�
  TLog.SaveLog(now, 'TCallDevOP.ExecuteReCall::�ر���˷�');

  soundString := TStringList.Create;
  try
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\Gmrhy14a.wav');
//    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\�����ҷ����.wav');
//
//    for i := 1 to Length(m_CallRecord.strRoomNum) do
//    begin
//      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + m_CallRecord.strExternalRoomNumber[i] + '.wav');
//    end;
//    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\��ע��.wav');

    //��һ��
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\�����.wav');
    for i := 1 to Length(m_CallRecord.strRoomNum) do
    begin
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + m_CallRecord.strRoomNum[i] + '.wav');
    end;
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\�ѽа�.wav');
    //�ڶ���
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\�����.wav');
    for i := 1 to Length(m_CallRecord.strRoomNum) do
    begin
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + m_CallRecord.strRoomNum[i] + '.wav');
    end;
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\���ѽа���������.wav');

    TLog.SaveLog(now, '���ò���ģʽ');

    m_CallCtl.SetPlayMode(1);
    if bHZroomnumber then
    begin
      PlaySound(PChar(strHZroomnumber), 0, SND_FILENAME or SND_SYNC);
    end
    else
    begin
      for i := 0 to soundString.Count - 1 do
      begin
        if m_bCancel then
        begin
          Self.FinishServerRoomCallPlayEvent(TR_CANCEL,'ȡ������');
          Exit;
        end;
        TLog.SaveLog(now, '�����ַ�' + soundString[i]);
        PlaySound(PChar(soundString[i]), 0, SND_FILENAME or SND_SYNC);
        TLog.SaveLog(now, '�����ַ����' + soundString[i]);
      end;
    end;
    Self.FinishServerRoomCallPlayEvent(TR_SUCESS,'��ɲ���');
  finally
    soundString.Free;
  end;
end;

class function TCallDevOP.GetInstance: TCallDevOP;
begin
  if m_self = nil then
  begin
    m_self := TCallDevOP.Create();
  end;
  result := m_self;
end;

procedure TCallDevOP.OnDealTryConDev_Msg(msg:TMessage);
var
  data:TCallDevCallBackData;
begin
  data := TCallDevCallBackData(msg.LParam);
  try
    if Assigned(m_TryConDevEvent) then
    begin
      m_TryConDevEvent(data);
    end;
  finally
    data.Free;
  end;

end;

procedure TCallDevOP.OnDealFinishConDev_Msg(msg: TMessage);
var
  data:TCallDevCallBackData;
begin
  data := TCallDevCallBackData(msg.LParam);

    //��ʼ¼��
  TLog.SaveLog(now, '��ʼ¼��');
  m_MixerRecord.Start;
  if data.callRoomRecord.eCallResult = TR_SUCESS  then
  begin
    //m_MixerRecord.Start;
    m_bConSucess := True;
  end
  else
  begin
    m_bConSucess := False;
  end;
  try
    if Assigned(m_FinishConDevEvent) then
    begin
      m_FinishConDevEvent(data);
    end;
  finally
    data.Free;
  end;
end;

procedure TCallDevOP.OnDealFinishFirstCall_Msg(msg:TMessage);
var
  data:TCallDevCallBackData;
begin
  data := TCallDevCallBackData(msg.LParam);
  try
    if Assigned(m_FinishFistCallVoiceEvent) then
      m_FinishFistCallVoiceEvent(data);
  finally
    data.Free;
  end;
end;
procedure TCallDevOP.OnDealFinishRecall_Msg(msg:TMessage);
var
  data:TCallDevCallBackData;
begin
  data := TCallDevCallBackData(msg.LParam);
  try
    if Assigned(m_FinishReCallVoiceEvent) then
      m_FinishReCallVoiceEvent(data);
  finally
    data.Free;
  end;
end;

procedure TCallDevOP.OnDealFinishServerRoomcall_Msg(msg: TMessage);
var
  data:TCallDevCallBackData;
begin
  data := TCallDevCallBackData(msg.LParam);
  try
    if Assigned(m_FinishServerRoomCallVoiceEvent) then
      m_FinishServerRoomCallVoiceEvent(data);
  finally
    data.Free;
  end;
end;

procedure TCallDevOP.OnDealQueryConDev_Msg(msg: TMessage);
var
  data:TCallDevCallBackData;
begin
  data := TCallDevCallBackData(msg.LParam);
  try
    if Assigned(m_QueryConDevEvent) then
      m_QueryConDevEvent(data);
  finally
    data.Free;
  end;
end;

function TCallDevOP.OpenPort: Boolean;
var
  nResult :Integer;
begin
  result := false;
  TLog.SaveLog(now, '�򿪴���  '+ IntToStr(m_CallConfig.nPort));
  if not m_bPortOpened then
  begin
    nResult := m_CallCtl.OpenPort(m_CallConfig.nPort);
    if nResult = 1 then
    begin
      m_bPortOpened := true;
      result := True;
      TLog.SaveLog(now, '�򿪴��ڳɹ�');
    end
    else
    begin
      m_bPortOpened := false;
      TLog.SaveLog(now, '�򿪴���ʧ�ܣ�������:' +  IntToStr(nResult));
      raise Exception.Create('�򿪴���ʧ�ܣ�������:' +  IntToStr(nResult));
    end;
  end
  else
  begin
    TLog.SaveLog(now, '�����Ѵ�.') ;
    result := True;
  end;
end;

procedure TCallDevOP.PlaySoundFile(SoundFile: string);
begin
  if Self.bCalling then Exit;
  m_CallCtl.SetPlayMode(2);

  {if m_CallCtl.SetPlayMode(2) = False then
  begin
    TLog.SaveLog(now, 'PlaySoundFile_SetPlayMode 2 fail') ;
    //Box('���ù���ģʽʧ��!');
  end
  else
  begin
    TLog.SaveLog(now, 'PlaySoundFile_SetPlayMode 2 ok') ;
  end;}

 if FileExists( SoundFile) then
    MMSystem.PlaySound(Pchar(SoundFile), 0,SND_FILENAME or SND_ASYNC);
end;

procedure TCallDevOP.PlaySoundFileLoop(SoundFile: string);
begin
  if Self.bCalling then Exit;
  m_CallCtl.SetPlayMode(2);
//  if m_CallCtl.SetPlayMode(2) = False then
//  begin
//    TLog.SaveLog(now, 'PlaySoundFile_SetPlayMode 2 fail') ;
//    //Box('���ù���ģʽʧ��!');
//
//  end;
  if FileExists(SoundFile) then
    MMSystem.PlaySound(Pchar(SoundFile), 0,SND_FILENAME or SND_ASYNC or SND_LOOP );
end;

procedure TCallDevOP.QueryConDevEvent(nTryTimes: Integer;
  callResult: TRoomCallResult; strMsg: string);
var
  data:TCallDevCallBackData;
begin
  m_CallRecord.nConTryTimes := nTryTimes;
  m_CallRecord.eCallResult := callResult;
  m_CallRecord.strMsg := strMsg;

  TLog.SaveLog(Now,  Format('��%d�κ��з����豸,���:%s,��ע%s',[nTryTimes,TRoomCallResultNameAry[callResult],strMsg]));
  data := TCallDevCallBackData.Create;
  data.callRoomRecord.Clone(m_CallRecord);
  PostMessage(m_MSGhandle, WM_MSG_QUERY_CONDEV,0,Integer(data));
end;

function TCallDevOP.QueryConResult(DeviceID: Integer; strMsg: string): Boolean;
var
  i:Integer;
  bRet : Boolean ;
begin
  result := False;
  for i := 0 to 5 do
  begin
    if SaftySleep(1000,strMsg) = False then  Exit;

    if m_CallCtl.ConfirmDeviceState(DeviceID,bRet) then
    begin
      strMsg := format('����豸״̬�ɹ�,��[%d]��!',[i+1]);
      TLog.SaveLog(now, '����豸״̬�ɹ�!');
      Result := True;
      break;
    end else begin
      strMsg := format('����豸״̬ʧ��,��[%d]��!',[i+1]);
      TLog.SaveLog(now, strMsg);
    end;
  end;
end;

function TCallDevOP.QueryConResult485(DeviceID: Integer;
  strMsg: string): Boolean;
var
  i:Integer;
  bRet : Boolean ;
begin
  result := False;
  for i := 0 to 3 do
  begin
    if SaftySleep(1000,strMsg) = False then  Exit;

    if m_CallCtl.ConfirmDeviceState(DeviceID,bRet) then
    begin
      if bRet then
      begin
        strMsg := format('����豸״̬�ɹ�,��[%d]��!', [i + 1]);
        TLog.SaveLog(now, '����豸״̬�ɹ�!');
        Result := True;
        break;
      end
      else
      begin
        strMsg := format('����豸״̬ʧ��,��[%d]��!', [i + 1]);
        TLog.SaveLog(now, strMsg);
      end;
    end;
  end;
end;

function TCallDevOP.RefuseReverseCall(nDevNum: Integer;
  var strMsg: string): Boolean;
var
  data:TCallDevCallBackData;
begin
  data:=TCallDevCallBackData.Create;

  result := False;
  m_CallRecord.eCallResult := TR_FAIL;
  if bCalling()= True then
  begin
    strMsg := '�豸ռ����!';
    Exit;
  end;
{$IFNDEF UART_DEBUG}
  if OpenPort()= False then
  begin
    strMsg:= '�˿ڴ�ʧ��!';
    Exit;
  end;
{$ENDIF}


  if m_CallCtl.RefuseReverseCallDevice(nDevNum) <> 1 then
  begin
    OnDisConDevEvent(data);
    data.Free;
    exit;
  end;
  OnDisConDevEvent(data);
  data.Free;
  result := True ;
end;

function TCallDevOP.SaftySleep(nTotalSecondS: Integer;var strMsg:string): Boolean;
var
  nstart:DWORD;
begin
  nstart := GetTickCount();
  result := False;
  while not m_bCancel do
  begin
    if (GetTickCount() - nstart) > nTotalSecondS  then
    begin
      strMsg := '����:��ʱ';
      result := True;
      Exit;
    end;
    Sleep(10);
  end;
  strMsg := '����:ȡ��';
end;

{ TCallDevThread }

procedure TCallDevThread.Execute;
begin
  inherited;
  if Assigned(m_OnExecute) then
    m_OnExecute();
end;

end.
