unit uRoomCallOp;

interface
uses
  Classes,SysUtils,uCallControl,uRoomCall,uTFSystem,Forms,Windows,uLogs,MMSystem,
  uPubFun,uRoomCallMsgDefine,Messages,uSaftyEnum,uMixerRecord,uAudio,DateUtils;
type

  //////////////////////////////////////////////////////////////////////////////
  ///结构体名:TCallConfig
  ///描述:叫班配置
  //////////////////////////////////////////////////////////////////////////////
  TCallConfig = class
  private
    constructor Create();
    destructor Destroy();override;
  private
    //ini配置文件
    m_strIniFile:string;
    //区段名称
    m_SectionName:string;
    //自己的实体对象
    class var m_Self:TCallConfig;

  public
    {功能:获取实体对象}
    class function GetInstance():TCallConfig;
  private
    {功能:指定配置文件}
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
    //通信端口
    property nPort:Integer read GetPort write SetPort;
    //通信类型
    property nComType:Integer read GetComType write SetComType;
      //拨号音量
    property  nDialVolume:Integer read GetDialVolume write SetDialVolume;
      //白天通话音量
    property nDayTalkVolume:Integer read GetDayTalkVolume write SetDayTalkVolume;
      //拨号间隔
    property nDialInterval:Integer  read GetDialInterval write SetDialInterval;
      //呼叫延迟
    property nCallDelay:Integer read GetCallDelay write SetCallDelay;
      //追叫间隔
    property nReCallInterval:Integer read GetReCallInterval write SetReCallInterval;
    //未离寓提醒间隔
    property nUnOutRoomNotifyInterval:Integer read GetUnOutRoomNotifyInterval write SetUnOutRoomNotifyInterval;
      //自动检测音频线路
    property nAutoCheckAudioLine:Integer read GetAutoCheckAudioLine write SetAutoCheckAudioLine;
      //首叫后等待管理员确认挂断
    property nWaitConfirm:Integer read GetWaitConfirm write SetWaitConfirm;
      //夜班通话音量
    property nNightTalkVolume:Integer read GetNightTalkVolume write SetNightTalkVolume;
      //夜间开始时间
    property dtNightStartTime:TDateTime read GetNightStartTime write SetNightStartTime;
      //夜间结束时间
    property dtNightEndTime:TDateTime read GetNightEndTime write SetNightEndTime;
    //配置文件
    property strIniFile :string  write SetConfigFile;
    //是否久版
    property nOldVersion :Integer read GetOldVersion write SetOldVersion;
    //录音存储天数
    property nVoiceStoreDays:Integer read GetVoiceStoreDays write SetVoiceStoreDays;
  end;


  
  //////////////////////////////////////////////////////////////////////////////
  ///类名:TCallDevThread
  ///描述:叫班操作线程
  //////////////////////////////////////////////////////////////////////////////
  TCallDevThread = class(TThread)
  public
    procedure Execute;override;
  protected
    m_OnExecute : TExecuteEvent;
    m_RoomCallType :TRoomCallType;
    m_RoomCallState:TRoomCallState;
  public
    //回调事件
    property OnExecute : TExecuteEvent read m_OnExecute write m_OnExecute;
    //叫班类型
    property RoomCallType :TRoomCallType read m_RoomCallType write m_RoomCallType;
    //叫班状态
    property RoomCallState:TRoomCallState read m_RoomCallState write m_RoomCallState;
  end;



  //叫班结果
  TFinishCallResult = procedure (bSucess:Boolean; data:TCallDevCallBackData) of object;
  //叫班事件
  TCallDevEvent = procedure (data:TCallDevCallBackData) of object;

  ////////////////////////////////////////////////////////////////////////////////
  ///类名:TCallDevOP
  ///描述:叫班设备操作
  ////////////////////////////////////////////////////////////////////////////////
  TCallDevOP= class
  public
    constructor Create();
    destructor Destroy();override;

  public //----------外部接口函数-------------------//
    {功能:断开设备}
    function DisConDevice(var strMsg:string):Boolean;
    function DisConDeviceAll(CallMultiDevicesArray : RCallMultiDevicesArray;var strMsg:string):Boolean;

    function DisConDeviceMusic(var strMsg:string):Boolean;
    function DisConDeviceRS485(var strMsg:string):Boolean;

    {功能:人工连接设备}
    function MonitorConDevice(var strMsg:string):Boolean;
    {功能:人工连接设备}
    function MunualConDevice(var strMsg:string):Boolean;
    {功能:人工首叫}
    function MunualFirstCallRoom(var strMsg:string):Boolean;
    
    {功能:自动首叫}
    function AutoFirstCall(var strMsg:string):Boolean;
    {功能:自动催叫}
    function AutoReCall(var strMsg:string):Boolean;
    {功能:  自动服务室呼叫}
    function AutoServerRoomCall(var strMsg:string):Boolean;

    {功能:自动首叫多个}
    function AutoFirstCalls(CallMultiDevicesArray : RCallMultiDevicesArray;var strMsg:string):Boolean;
    {功能:自动催叫}
    function AutoReCalls(CallMultiDevicesArray : RCallMultiDevicesArray;var strMsg:string):Boolean;

    {功能:核查上次叫班时间}
    function CheckLastCallTime():Boolean;
    {功能:判断是否正在执行叫班操作}
    function bCalling():Boolean;
    {功能:打开串口}
    function OpenPort():Boolean;
    
    {功能:关闭线程}
    procedure CloseThread();

    //播放语音文件
    procedure PlaySoundFile(SoundFile: string);
    //一直播放声音
    procedure PlaySoundFileLoop(SoundFile: string);
    //停止播放声音
    procedure StopPlaySound();
    //播放首叫
    function   DoFirstCall(var strMsg:string):boolean;

////////////////////////////////////////////////////////////
  public
    //检查是否有反呼房间
    function  HaveReverseCall(out nDevNum:Integer;var strMsg:string):Boolean;
    //联通反呼房间
    function  ConnectReverseCall(nDevNum:Integer;var strMsg:string):Boolean;
    //拒接反呼房间
    function  RefuseReverseCall(nDevNum:Integer;var strMsg:string):Boolean;
    //发送房间数量
    function SetRoomCount(const num:Word):Integer;
    //向主机发送房间集合}
    function SendMultiDeviceInfo(CallDevAry:TCallDevAry):BOOL;
    //监听设备
    function MonitorVoice(var strMsg:string):Boolean;
    {功能 ：呼叫多个设备}
    function CallMultiDevices(Src:RCallMultiDevicesArray):Boolean;
    {功能：查询房间对应设备号}
    function FindIDByRoom(RoomNumber:string;out num: word): Boolean;
//////////////////////////////////////////////////////////////
  private //-----子线程函数-----//
    {共能：连接设备}
    function ExecuteConDeviceForMonitor():Boolean;
    {功能:执行连接设备}
    function ExecuteConDevice():Boolean;
    {功能:执行首叫}
    function ExecuteFirstCall():Boolean;
    {功能:执行催叫}
    function ExecuteReCall():Boolean;
    {功能:执行催叫}
    function ExecuteServerRoomCall():Boolean;
    {功能:执行自动首叫}
    function ExecuteAutoFirstCall():Boolean;
    {功能:执行自动催叫}
    function ExecuteAutoReCall():Boolean;
    {功能:执行服务室呼叫}
    function ExecuteAutoServerRoomCall():Boolean;
  private
      {功能:执行连接设备}
    function ExecuteConDevices():Boolean;
    {功能:执行首叫}
    function ExecuteFirstCalls():Boolean;
    {功能:执行催叫}
    function ExecuteReCalls():Boolean;
      {功能:执行自动首叫s}
    function ExecuteAutoFirstCalls():Boolean;
    {功能:执行自动催叫}
    function ExecuteAutoReCalls():Boolean;

  private  //-------公共方法--------////
    {功能:断开设备}
    function DisConDevice_NoCallBack(var strMsg:string):Boolean;
    {功能:发送音频命令信号}
    procedure SendVoiceSignal(callCommand:string);
    {功能://将音量调整到最小音量}
    procedure MinWaveOut();
    {功能:将系统音量调整到最大音量}
    procedure MaxWaveOut(strRoomNo: string);
    {功能：将MICROE静音}
    procedure SetMicrophoneMute(Value:boolean);
    {功能:设置时间声音}
    procedure SetPlaySoundTime(soundString: TStrings; dtTime: TDateTime);
    {功能:判断当前是否为夜班}
    function bNight():Boolean;

    {功能:连接设备_音频方式}
    function ConDev_Voice(var strMsg:string):Boolean;
    {功能:连接设备_串口方式}
    function ConDev_COM(var strMsg:string):Boolean;
    {功能:检测连接结果}
    function CheckConResult(var strMsg:string):Boolean;
    {功能:检测呼叫结果}
    function QueryConResult(DeviceID:Integer; strMsg:string):Boolean;
    {功能:检测呼叫结果}
    function QueryConResult485(DeviceID:Integer; strMsg:string):Boolean;
    //获取新的协议的呼叫命令
    function GetNewCallCommand(nDeviceID: Integer): string;
    //获取旧的协议呼叫命令
    function GetOldCallCommand(nDeviceID:Integer):string;
    {功能:休眠}
    function SaftySleep(nTotalSecondS:Integer;var strMsg:string):Boolean;

  private //---------子线程叫班状态通知主线程------------//
    {功能:开始连接叫班设备}
    procedure StartConDevEvent(nTryTimes:Integer);
    {功能:尝试连接叫班设备}
    procedure TryConDevEvent(nTryTimes: Integer; callResult: TRoomCallResult; strMsg: string);
    {功能:叫班设备连接结束}
    procedure FinishConDevEvent(nTryTimes: Integer; callResult: TRoomCallResult; strMsg: string);

    {功能:查询呼叫设备}
    procedure QueryConDevEvent(nTryTimes: Integer; callResult: TRoomCallResult; strMsg: string);

    {功能:开始播放叫班音乐}
    procedure StartFirstCallPlayEvent();
    {功能:叫班音乐播放结束}
    procedure FinishFirstCallPlayEvent(callResult: TRoomCallResult;strMsg:string);
    {功能:开始播放催叫音乐}
    procedure StartReCallPlayEvent();
    {功能:催叫音乐播放结束}
    procedure FinishReCallPlayEvent(callResult: TRoomCallResult;strMsg:string);

    {功能:开始播放服务室音乐}
    procedure StartServerRoomCallPlayEvent();
    {功能:催叫音乐播放结束}
    procedure FinishServerRoomCallPlayEvent(callResult: TRoomCallResult;strMsg:string);
  
  private//---------主线程处理叫班结果------------//
    {功能:开始设备连接回调}
    procedure OnDealStartConDev_Msg(msg:TMessage);
    {功能:尝试连接设备回调}
    procedure OnDealTryConDev_Msg(msg:TMessage);
    {功能:叫班设备连接结束回调}
    procedure OnDealFinishConDev_Msg(msg:TMessage);

    {功能:查询设备回调}
    procedure OnDealQueryConDev_Msg(msg:TMessage);

    {功能:开始首叫回调}
    procedure OnDealStartFristCall_Msg(msg:TMessage);
    {功能:首叫结束回调}
    procedure OnDealFinishFirstCall_Msg(msg:TMessage);
    {功能:开始催叫回调}
    procedure OnDealStartReCall_Msg(msg:TMessage);
    {功能:催叫结束回调}
    procedure OnDealFinishRecall_Msg(msg:TMessage);


    {功能:开始服务室回调}
    procedure OnDealStartServerRoomCall_Msg(msg:TMessage);
    {功能:服务室结束回调}
    procedure OnDealFinishServerRoomcall_Msg(msg:TMessage);

    //----------------回调信息给主线程-----------------------
    {功能:消息处理函数}
    procedure WndMethod(var Msg: TMessage);


  public
    {功能:获取自身实例}
    class function GetInstance():TCallDevOP;
  private
    //开始连接设备事件
    m_StartConDevEvent:TCallDevEvent;
    //尝试连接设备时间
    m_TryConDevEvent:TCallDevEvent;
    //查询一次连接设备事件
    m_QueryConDevEvent:TCallDevEvent;
    //完成连接设备事件
    m_FinishConDevEvent:TCallDevEvent;
    //开始播放首叫语音事件
    m_StartFistrCallVoiceEvent:TCallDevEvent;
    //结束播放首叫语音事件
    m_FinishFistCallVoiceEvent:TCallDevEvent;
    //开始播放催叫语音事件
    m_StartReCallVoiceEvent:TCallDevEvent;
    //结束播放催叫语音事件
    m_FinishReCallVoiceEvent:TCallDevEvent;

    //开始播放服务室语音事件
    m_StartServerRoomCallVoiceEvent:TCallDevEvent;
    //结束播放服务室语音事件
    m_FinishServerRoomCallVoiceEvent:TCallDevEvent;
    //挂断设备事件
    m_DisConDevEvent:TCallDevEvent;

    //自身实例
    class var m_self:TCallDevOP;
    //叫班操作线程
    m_Thread:TCallDevThread;
    //消息句柄
    m_MSGhandle:THandle;
  private
    //叫班底层操作
    m_CallCtl:TCallControl;
    //叫班记录
    m_CallRecord:TCallRoomRecord;
    //叫班配置
    m_CallConfig:TCallConfig;
    //端口是否已打开
    m_bPortOpened:Boolean;
    //关闭叫班
    m_bCancel:Boolean;
    //录音功能
    m_MixerRecord : TMixerRecord;
    //是否正在通话
    m_bWorking:Boolean;
    //最后通话时间
    m_LastTastTime:Integer;
    //连接房间设备是否成功
    m_bConSucess:Boolean;
    //叫班房间信息
    m_CallMultiDevicesArray : RCallMultiDevicesArray;
  public
    //开始连接设备事件
    property OnStartConDevEvent:TCallDevEvent  read m_StartConDevEvent write m_StartConDevEvent ;
    //尝试连接设备事件
    property OnTryConDevEvent:TCallDevEvent read m_TryConDevEvent write m_TryConDevEvent ;
    //连接设备结束事件
    property OnFinishConDevEvent:TCallDevEvent read m_FinishConDevEvent write m_FinishConDevEvent;
    //连接查询结束事件
    property OnQueryConDevEvent:TCallDevEvent read  m_QueryConDevEvent write m_QueryConDevEvent;
    //开始播放叫班语音事件
    property OnStartFirstCallVoiceEvent:TCallDevEvent read m_StartFistrCallVoiceEvent write m_StartFistrCallVoiceEvent ;
    //结束播放叫班语音事件
    property OnFinishFistCallVoiceEvent:TCallDevEvent read m_FinishFistCallVoiceEvent write m_FinishFistCallVoiceEvent;
    //开始播放催叫语音事件
    property OnStartReCallVoiceEvent:TCallDevEvent read m_StartReCallVoiceEvent write m_StartReCallVoiceEvent ;
    //结束播放催叫语音事件
    property OnFinishReCallVoiceEvent:TCallDevEvent read m_FinishReCallVoiceEvent write m_FinishReCallVoiceEvent ;
    //挂机事件
    property OnDisConDevEvent:TCallDevEvent read m_DisConDevEvent write m_DisConDevEvent;

    property OnStartServerRoomCallVoiceEvent:TCallDevEvent read m_StartServerRoomCallVoiceEvent write m_StartServerRoomCallVoiceEvent;
    property OnFinishServerRoomCallVoiceEvent:TCallDevEvent read m_FinishServerRoomCallVoiceEvent write m_FinishServerRoomCallVoiceEvent;

    //叫班底层操作
    property CallCtl:TCallControl read m_CallCtl write m_CallCtl ;
    //叫班计划
    property CallRecord:TCallRoomRecord read m_CallRecord write m_CallRecord;
    //叫班配置
    property CallConfig:TCallConfig read m_CallConfig write m_CallConfig;
    //端口是否已打开
    property bPortOpened:Boolean read m_bPortOpened write m_bPortOpened;
    //关闭叫班
    property bCancel:Boolean read m_bCancel write m_bCancel;
    //连接成功
    property bConSucess:Boolean read m_bConSucess write m_bConSucess;
    //录音功能
    //property MixerRecord :TMixerRecord read m_MixerRecord write m_MixerRecord ;
  end;


implementation

{$INCLUDE uDebug.inc}

{ TRoomCallFun }
{功能:转换为声音字符串}
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
    strMsg := '设备占用中!';
    Exit;
  end;
{$IFNDEF UART_DEBUG}
  if OpenPort()= False then
  begin
    strMsg:= '端口打开失败!';
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
  SetLength(m_CallMultiDevicesArray,0);     //清空
  SetLength(m_CallMultiDevicesArray,Length(CallMultiDevicesArray) );   //设置长度
  //复制
  Move(CallMultiDevicesArray[0],m_CallMultiDevicesArray[0],  Length(CallMultiDevicesArray)*sizeof(CallMultiDevicesArray[0]));

  m_CallRecord.eCallResult := TR_FAIL;
  if bCalling()= True then
  begin
    strMsg := '设备占用中!';
    Exit;
  end;
{$IFNDEF UART_DEBUG}
  if OpenPort()= False then
  begin
    strMsg:= '端口打开失败!';
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
    strMsg := '设备占用中!';
    Exit;
  end;
{$IFNDEF UART_DEBUG}
  if OpenPort()= False then
  begin
    strMsg:= '端口打开失败!';
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
    strMsg := '设备占用中!';
    Exit;
  end;
{$IFNDEF UART_DEBUG}
  if OpenPort()= False then
  begin
    strMsg:= '端口打开失败!';
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
    strMsg := '设备占用中!';
    Exit;
  end;

{$IFNDEF UART_DEBUG}
  if OpenPort()= False then
  begin
    strMsg:= '端口打开失败!';
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
  //通信线程在运行,

  if (m_Thread = nil) and  (m_bWorking = False) then
  begin
    result := False;
    Exit;
  end;

  //没有通信线程存在,设备会保持60秒钟的连接状态
  {if (GetTickCount - m_dtLastTalk) > 60000 then//超过60秒钟则认为是设备已断开
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
    TLog.SaveLog(now, '挂断设备,无回调' + strMsg);
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
    strMsg := '设备占用中!';
    Exit;
  end;
  }

  TLog.SaveLog(now, 'DoFirstCall_ok');
{$IFNDEF UART_DEBUG}
  if OpenPort()= False then
  begin
    strMsg:= '端口打开失败!';
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
      TLog.SaveLog(now, '录音结束');

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
      //发送挂断指令
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
    TLog.SaveLog(now, '444叫班结束');
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
      TLog.SaveLog(now, '录音结束');

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
      //用串口方式挂断
      //设置串口模式
      m_CallCtl.SetDialType(1);
      m_CallCtl.Hangup(m_CallRecord.nDeviceID) ;
      m_CallCtl.Hangup(m_CallRecord.nDeviceID) ;
      m_CallCtl.Hangup(m_CallRecord.nDeviceID) ;
      //恢复音乐模式
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
    TLog.SaveLog(now, '444叫班结束');
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
      TLog.SaveLog(now, '录音结束');

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
    TLog.SaveLog(now, '444叫班结束');
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
    strMsg := '设备占用中!';
    Exit;
  end;
{$IFNDEF UART_DEBUG}
  if OpenPort()= False then
  begin
    strMsg:= '端口打开失败!';
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
    SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + '十.wav');
  end;
  if nMod > 0 then
  begin
    if nMod = 1 then
      SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + '一.wav')
    else
      SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + IntToStr(nMod) + '.wav');
  end
  else
    if nDiv = 0 then
      SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + '0.wav');
  SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + '点.wav');

  nMinute := StrToInt(FormatDateTime('n',dtTime));
  nDiv := nMinute div 10;
  nMod := nMinute mod 10;
  if (nDiv = 0) and (nMod = 0) then Exit;
  if nDiv > 0 then
  begin
    if nDiv > 1 then
      SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + IntToStr(nDiv) + '.wav');
    SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + '十.wav');
  end;
  if nMod > 0 then
  begin
    if nMod = 1 then
      SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + '一.wav')
    else
      SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + IntToStr(nMod) + '.wav');
  end;
  SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + '分.wav');
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
  m_CallRecord.strMsg := '开始连接设备';
  data.callRoomRecord.Clone(m_CallRecord);
  PostMessage(m_MSGhandle, WM_MSG_STARTCONDEV,0,Integer(data));
end;

procedure TCallDevOP.StartFirstCallPlayEvent();
var
  data:TCallDevCallBackData;
begin
  m_CallRecord.strMsg := '开始播放首叫语音';
  data := TCallDevCallBackData.Create;
  data.callRoomRecord.Clone(m_CallRecord);
  PostMessage(m_MSGhandle, WM_MSG_START_FIRSTCALLPLAY,0,Integer(data));
end;


procedure TCallDevOP.StartReCallPlayEvent();
var
  data:TCallDevCallBackData;
begin
  m_CallRecord.strMsg := '开始播放催叫语音';
  data := TCallDevCallBackData.Create;
  data.callRoomRecord.Clone(m_CallRecord);
  PostMessage(m_MSGhandle, WM_MSG_START_RECALLPLAY,0,Integer(data));
end;


procedure TCallDevOP.StartServerRoomCallPlayEvent;
var
  data:TCallDevCallBackData;
begin
  m_CallRecord.strMsg := '开始播放服务室呼叫语音';
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
    strMsg:= '端口打开失败!';
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
  OutputDebugString('--------------------------------------设置放音模式');
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
    strMsg := '设备占用中!';
    Exit;
  end;
{$IFNDEF UART_DEBUG}
  if OpenPort()= False then
  begin
    strMsg:= '端口打开失败!';
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

  TLog.SaveLog(Now,  Format('第%d次呼叫房间设备,结果:%s',[nTryTimes,TRoomCallResultNameAry[callResult]]));
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
      strMsg := format('检测设备状态成功,第[%d]次!',[i+1]);
      TLog.SaveLog(now, '检测设备状态成功!');
      Result := True;
      break;
    end else begin
      strMsg := format('检测设备状态失败,第[%d]次!',[i+1]);
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
    strMsg := '设备占用中!';
    Exit;
  end;
{$IFNDEF UART_DEBUG}
  if OpenPort()= False then
  begin
    strMsg:= '端口打开失败!';
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
    strMsg := '呼叫设备：' + IntToStr(m_CallRecord.nDeviceID) + ' 失败！';
    exit;
  end;
  strMsg:= '呼叫设备：' + IntToStr(m_CallRecord.nDeviceID) + ' 成功！' ;
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
    strMsg := '呼叫设备：' + IntToStr(m_CallRecord.nDeviceID) + ' 失败！';
    exit;
  end;
  if SaftySleep(300,strMsg) then
  begin
    strMsg := '暂停0.3s:' +  IntToStr(m_CallRecord.nDeviceID);
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
    strMsg := '设备占用中!';
    Exit;
  end;
{$IFNDEF UART_DEBUG}
  if OpenPort()= False then
  begin
    strMsg:= '端口打开失败!';
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
  //端口是否已打开
  m_bPortOpened:= False;
  //关闭叫班
  m_bCancel:=False;
  m_MSGhandle := AllocateHWnd(WndMethod);
  m_MixerRecord := TMixerRecord.Create;
  m_CallRecord:=TCallRoomRecord.Create;
end;


destructor TCallDevOP.Destroy;
begin
  DeallocateHWnd(m_MSGhandle);
  m_CallCtl.Free;
  TLog.SaveLog(now, '录音退出了');
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
  //连接设备 失败直接退出
  if ExecuteConDevice = False then
  begin
    TLog.SaveLog(now,'首叫->连接设备->error');
    Exit;
  end;

  //首叫失败,直接退出
  if ExecuteFirstCall = False then
  begin
    TLog.SaveLog(now,'首叫->执行呼叫->error');
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
  //连接设备 失败直接退出
  if ExecuteConDevices = False then
  begin
    TLog.SaveLog(now,'首叫->连接设备->error');
    Exit;
  end;

  //首叫失败,直接退出
  if ExecuteFirstCalls = False then
  begin
    TLog.SaveLog(now,'首叫->执行呼叫->error');
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
    //连接设备 失败直接退出
    if ExecuteConDevice = False then
    begin
      TLog.SaveLog(now,'催叫->连接设备->error');
      Exit;
    end;
    //催叫失败,直接退出
    if ExecuteReCall = False then
    begin
      TLog.SaveLog(now,'催叫->开始催叫->error');
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
    //连接设备 失败直接退出
    if ExecuteConDevices = False then
    begin
      TLog.SaveLog(now,'催叫->连接设备->error');
      Exit;
    end;
    //催叫失败,直接退出
    if ExecuteReCalls = False then
    begin
      TLog.SaveLog(now,'催叫->开始催叫->error');
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
    //连接设备 失败直接退出
    if ExecuteConDevice = False then
    begin
      TLog.SaveLog(now,'服务呼叫->连接设备->error');
      Exit;
    end;

    //,直接退出
    if ExecuteServerRoomCall = False then
    begin
      TLog.SaveLog(now,'服务呼叫->执行呼叫->error');
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
  
    //发送挂断音频信号
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
          strMsg:= '串口方式:' + strMsg;
        end
        else
        begin
          bCon := ConDev_Voice(strMsg);
          strMsg:= '音频方式:' + strMsg;
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
          TryConDevEvent(maxCallCount+1,TR_FAIL,'设备异常');
          Exit;
        end;
      end;
    until (maxCallCount >= 5);

    m_LastTastTime := GetTickCount;
    FinishConDevEvent(maxCallCount+1,TR_TIMEOUT,'无法连接');


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
          strMsg:= '串口方式:' + strMsg;
        end
        else
        begin
          bCon := ConDev_Voice(strMsg);
          strMsg:= '音频方式:' + strMsg;
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
          TryConDevEvent(maxCallCount+1,TR_FAIL,'设备异常');
          Exit;
        end;
      end;
    until (maxCallCount >= 5);

    m_LastTastTime := GetTickCount;
    FinishConDevEvent(maxCallCount+1,TR_TIMEOUT,'无法连接');


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
  
  //发送呼叫指令
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

        //获取各个设备的状态
        for I := 0 to Length(m_CallMultiDevicesArray) - 1 do
        begin
          bCon := QueryConResult485(m_CallMultiDevicesArray[i].idSrc,strMsg);
          if not bCon then
          begin
              strMsg := Format('房间[%s]连接失败',[m_CallMultiDevicesArray[i].roomnumber]);
             QueryConDevEvent(maxCallCount+1,TR_FAIL,strMsg);
          end
          else
          begin
            strMsg := Format('房间[%s]连接成功',[m_CallMultiDevicesArray[i].roomnumber]);
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
          TryConDevEvent(maxCallCount+1,TR_FAIL,'设备异常');
          Exit;
        end;
      end;
    until (maxCallCount >= 5);

    m_LastTastTime := GetTickCount;
    FinishConDevEvent(maxCallCount+1,TR_TIMEOUT,'无法连接');


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
  bHZroomnumber: Boolean; //是否为汉字房间号
  strHZroomnumber: string; //汉字房间播放的语音文件
  roomNumber, trainNo, strTime: string;
begin
  StartFirstCallPlayEvent();//开始播放首叫语音
  roomNumber := m_CallRecord.strRoomNum;
  strName := m_CallRecord.CallManRecordList[0].strTrainmanName;

  trainNo := m_CallRecord.strTrainNo;
  strTime := TPubFun.DateTime2Str(m_CallRecord.dtCallTime);
  bHZroomnumber := False;
  MaxWaveOut(roomNumber);
  SetMicrophoneMute(False);   //关闭麦克风

  soundString := TStringList.Create;
  try
    //背景音
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\Gmrhy14a.wav');

    try
      StrToInt(roomNumber);
      for i := 1 to Length(roomNumber) do
      begin
        soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + roomNumber[i] + '.wav');
      end;
    except
      bHZroomnumber := True;
      strHZroomnumber := ExtractFilePath(Application.ExeName) + 'CallMusic\' + '广播找人.wav';
    end;

    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\房间.wav');
    for i := 1 to Length(trainNo) do
    begin
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + trainNo[i] + '.wav')
    end;
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\次列车现在叫班.wav');

    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\姓氏\'+ Copy(strName,1,2) + '.wav');
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\师傅请回答.wav');
    TLog.SaveLog(now, '设置播放模式');
    SetMicrophoneMute(True); //打开麦克风
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
          Self.FinishFirstCallPlayEvent(TR_CANCEL,'取消播放');
          Exit;
        end;

        TLog.SaveLog(now, '播放字符' + soundString[i]);
        PlaySound(PChar(soundString[i]), 0, SND_FILENAME or SND_SYNC);
        TLog.SaveLog(now, '播放字符完成' + soundString[i]);
      end;
    end;

    Self.FinishFirstCallPlayEvent(TR_SUCESS,'完成播放');
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
  bHZroomnumber: Boolean; //是否为汉字房间号
  strHZroomnumber: string; //汉字房间播放的语音文件
  strJoinRoomNumber,roomNumber, trainNo, strTime: string;
  joinRooms : TStringList ;
begin
  StartFirstCallPlayEvent();//开始播放首叫语音
  roomNumber := m_CallRecord.strRoomNum;
  strName := m_CallRecord.CallManRecordList[0].strTrainmanName;

  trainNo := m_CallRecord.strTrainNo;
  strTime := TPubFun.DateTime2Str(m_CallRecord.dtCallTime);
  bHZroomnumber := False;
  MaxWaveOut(roomNumber);
  SetMicrophoneMute(False);   //关闭麦克风

  joinRooms := TStringList.Create;
  soundString := TStringList.Create;
  try
    //背景音
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\Gmrhy14a.wav');

    try
      //主叫房间
      StrToInt(roomNumber);
      for i := 1 to Length(roomNumber) do
      begin
        soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + roomNumber[i] + '.wav');
      end;
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\房间.wav');

      CallRecord.GetJoinRooms(joinRooms);
      //产生联交房间
      for I := 0 to joinRooms.Count - 1 do
      begin
        strJoinRoomNumber := joinRooms.Strings[i];
        StrToInt(strJoinRoomNumber);
        for k := 1 to Length(strJoinRoomNumber) do
        begin
          soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + strJoinRoomNumber[k] + '.wav');
        end;
        soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\房间.wav');
      end;

    except
      bHZroomnumber := True;
      strHZroomnumber := ExtractFilePath(Application.ExeName) + 'CallMusic\' + '广播找人.wav';
    end;

    //soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\房间.wav');
    for i := 1 to Length(trainNo) do
    begin
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + trainNo[i] + '.wav')
    end;
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\次列车现在叫班.wav');

    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\姓氏\'+ Copy(strName,1,2) + '.wav');
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\师傅请回答.wav');
    TLog.SaveLog(now, '设置播放模式');
    SetMicrophoneMute(True); //打开麦克风
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
          Self.FinishFirstCallPlayEvent(TR_CANCEL,'取消播放');
          Exit;
        end;

        TLog.SaveLog(now, '播放字符' + soundString[i]);
        PlaySound(PChar(soundString[i]), 0, SND_FILENAME or SND_SYNC);
        TLog.SaveLog(now, '播放字符完成' + soundString[i]);
      end;
    end;

    Self.FinishFirstCallPlayEvent(TR_SUCESS,'完成播放');
  finally
    joinRooms.Free;
    soundString.Free;
  end;
end;

function TCallDevOP.ExecuteReCall: Boolean;
var
  soundString: TStrings;
  i: Integer;
  bHZroomnumber: Boolean; //是否为汉字房间号
  strHZroomnumber: string; //汉字房间播放的语音文件
begin
  StartReCallPlayEvent();//开始播放首叫语音
  bHZroomnumber := False;
  MaxWaveOut(m_CallRecord.strRoomNum);
  SetMicrophoneMute(False);   //关闭麦克风
  TLog.SaveLog(now, 'TCallDevOP.ExecuteReCall::关闭麦克风');

  soundString := TStringList.Create;
  try
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\Gmrhy14a.wav');

    for i := 1 to Length(m_CallRecord.strTrainNo) do
    begin
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + m_CallRecord.strTrainNo[i] + '.wav')
    end;
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\现已叫班请抓紧时间出乘.wav');
    try
      StrToInt(m_CallRecord.strRoomNum);
      for i := 1 to Length(m_CallRecord.strRoomNum) do
      begin
        soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + m_CallRecord.strRoomNum[i] + '.wav');
      end;
    except
      bHZroomnumber := True;
      strHZroomnumber := ExtractFilePath(Application.ExeName) + 'CallMusic\' + '广播找人.wav';
    end;
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\房间.wav');

    for i := 1 to Length(m_CallRecord.strTrainNo) do
    begin
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + m_CallRecord.strTrainNo[i] + '.wav')
    end;
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\现已叫班请抓紧时间出乘.wav');
    TLog.SaveLog(now, '设置播放模式');
    SetMicrophoneMute(True);   //关闭麦克风
    TLog.SaveLog(now, 'TCallDevOP.ExecuteReCall::开启麦克风');

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
          Self.FinishReCallPlayEvent(TR_CANCEL,'取消播放');
          Exit;
        end;
        TLog.SaveLog(now, '播放字符' + soundString[i]);
        PlaySound(PChar(soundString[i]), 0, SND_FILENAME or SND_SYNC);
        TLog.SaveLog(now, '播放字符完成' + soundString[i]);
      end;
    end;
  Self.FinishReCallPlayEvent(TR_SUCESS,'完成播放');
  finally
    soundString.Free;
  end;
end;


function TCallDevOP.ExecuteReCalls: Boolean;
var
  soundString: TStrings;
  i,j: Integer;
  bHZroomnumber: Boolean; //是否为汉字房间号
  strJoinRoomNumber,strHZroomnumber: string; //汉字房间播放的语音文件
  joinRooms : TStringList ;
begin
  StartReCallPlayEvent();//开始播放首叫语音
  bHZroomnumber := False;
  MaxWaveOut(m_CallRecord.strRoomNum);
  SetMicrophoneMute(False);   //关闭麦克风
  TLog.SaveLog(now, 'TCallDevOP.ExecuteReCall::关闭麦克风');

  joinRooms := TStringList.Create ;
  soundString := TStringList.Create;
  try
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\Gmrhy14a.wav');

    for i := 1 to Length(m_CallRecord.strTrainNo) do
    begin
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + m_CallRecord.strTrainNo[i] + '.wav')
    end;
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\现已叫班请抓紧时间出乘.wav');
    try
      StrToInt(m_CallRecord.strRoomNum);
      for i := 1 to Length(m_CallRecord.strRoomNum) do
      begin
        soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + m_CallRecord.strRoomNum[i] + '.wav');
      end;
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\房间.wav');


      CallRecord.GetJoinRooms(joinRooms);
      //产生联交房间
      for I := 0 to joinRooms.Count - 1 do
      begin
        strJoinRoomNumber := joinRooms.Strings[i];
        StrToInt(strJoinRoomNumber);
        for j := 1 to Length(strJoinRoomNumber) do
        begin
          soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + strJoinRoomNumber[j] + '.wav');
        end;
        soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\房间.wav');
      end;


    except
      bHZroomnumber := True;
      strHZroomnumber := ExtractFilePath(Application.ExeName) + 'CallMusic\' + '广播找人.wav';
    end;


    for i := 1 to Length(m_CallRecord.strTrainNo) do
    begin
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + m_CallRecord.strTrainNo[i] + '.wav')
    end;
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\现已叫班请抓紧时间出乘.wav');
    TLog.SaveLog(now, '设置播放模式');
    SetMicrophoneMute(True);   //关闭麦克风
    TLog.SaveLog(now, 'TCallDevOP.ExecuteReCall::开启麦克风');

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
          Self.FinishReCallPlayEvent(TR_CANCEL,'取消播放');
          Exit;
        end;
        TLog.SaveLog(now, '播放字符' + soundString[i]);
        PlaySound(PChar(soundString[i]), 0, SND_FILENAME or SND_SYNC);
        TLog.SaveLog(now, '播放字符完成' + soundString[i]);
      end;
    end;
  Self.FinishReCallPlayEvent(TR_SUCESS,'完成播放');
  finally
    joinRooms.Free;
    soundString.Free;
  end;
end;

function TCallDevOP.ExecuteServerRoomCall: Boolean;
{
服务室房间号XXX请注意，房间号XXX已叫班，房间号XXX已叫班（播放两遍），请整理房间。
}
var
  soundString: TStrings;
  i: Integer;
  bHZroomnumber: Boolean; //是否为汉字房间号
  strHZroomnumber: string; //汉字房间播放的语音文件
begin
  StartServerRoomCallPlayEvent();//开始播放首叫语音
  bHZroomnumber := False;
  MaxWaveOut(m_CallRecord.strRoomNum);
  SetMicrophoneMute(False);   //关闭麦克风
  TLog.SaveLog(now, 'TCallDevOP.ExecuteReCall::关闭麦克风');

  soundString := TStringList.Create;
  try
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\Gmrhy14a.wav');
//    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\服务室房间号.wav');
//
//    for i := 1 to Length(m_CallRecord.strRoomNum) do
//    begin
//      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + m_CallRecord.strExternalRoomNumber[i] + '.wav');
//    end;
//    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\请注意.wav');

    //第一遍
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\房间号.wav');
    for i := 1 to Length(m_CallRecord.strRoomNum) do
    begin
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + m_CallRecord.strRoomNum[i] + '.wav');
    end;
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\已叫班.wav');
    //第二遍
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\房间号.wav');
    for i := 1 to Length(m_CallRecord.strRoomNum) do
    begin
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + m_CallRecord.strRoomNum[i] + '.wav');
    end;
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\现已叫班请整理房间.wav');

    TLog.SaveLog(now, '设置播放模式');

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
          Self.FinishServerRoomCallPlayEvent(TR_CANCEL,'取消播放');
          Exit;
        end;
        TLog.SaveLog(now, '播放字符' + soundString[i]);
        PlaySound(PChar(soundString[i]), 0, SND_FILENAME or SND_SYNC);
        TLog.SaveLog(now, '播放字符完成' + soundString[i]);
      end;
    end;
    Self.FinishServerRoomCallPlayEvent(TR_SUCESS,'完成播放');
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

    //开始录音
  TLog.SaveLog(now, '开始录音');
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
  TLog.SaveLog(now, '打开串口  '+ IntToStr(m_CallConfig.nPort));
  if not m_bPortOpened then
  begin
    nResult := m_CallCtl.OpenPort(m_CallConfig.nPort);
    if nResult = 1 then
    begin
      m_bPortOpened := true;
      result := True;
      TLog.SaveLog(now, '打开串口成功');
    end
    else
    begin
      m_bPortOpened := false;
      TLog.SaveLog(now, '打开串口失败，错误码:' +  IntToStr(nResult));
      raise Exception.Create('打开串口失败，错误码:' +  IntToStr(nResult));
    end;
  end
  else
  begin
    TLog.SaveLog(now, '串口已打开.') ;
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
    //Box('设置功放模式失败!');
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
//    //Box('设置功放模式失败!');
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

  TLog.SaveLog(Now,  Format('第%d次呼叫房间设备,结果:%s,备注%s',[nTryTimes,TRoomCallResultNameAry[callResult],strMsg]));
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
      strMsg := format('检测设备状态成功,第[%d]次!',[i+1]);
      TLog.SaveLog(now, '检测设备状态成功!');
      Result := True;
      break;
    end else begin
      strMsg := format('检测设备状态失败,第[%d]次!',[i+1]);
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
        strMsg := format('检测设备状态成功,第[%d]次!', [i + 1]);
        TLog.SaveLog(now, '检测设备状态成功!');
        Result := True;
        break;
      end
      else
      begin
        strMsg := format('检测设备状态失败,第[%d]次!', [i + 1]);
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
    strMsg := '设备占用中!';
    Exit;
  end;
{$IFNDEF UART_DEBUG}
  if OpenPort()= False then
  begin
    strMsg:= '端口打开失败!';
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
      strMsg := '休眠:到时';
      result := True;
      Exit;
    end;
    Sleep(10);
  end;
  strMsg := '休眠:取消';
end;

{ TCallDevThread }

procedure TCallDevThread.Execute;
begin
  inherited;
  if Assigned(m_OnExecute) then
    m_OnExecute();
end;

end.
