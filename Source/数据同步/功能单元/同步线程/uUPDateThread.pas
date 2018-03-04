unit uUPDateThread;

interface

uses
  Classes,ACTIVEX,SysUtils,ADODB,windows,uTFSystem,forms,Messages, StrUtils
  , uHttpDataUpdateMgr,uWebIF,uWebJob_InOutRoom,uWebJob_TrainmanSync
  ;
const
  {十分钟}
  DATACLEAR_PERIOD = 600000;
  {日志消息}
  WM_MSG_LOG = WM_USER + 7788;

type
  //////////////////////////////////////////////////////////////////////////////
  ///  TUPDateThread 数据更新线程
  //////////////////////////////////////////////////////////////////////////////
  TUPDateThread = class(TThread)
  public
    constructor Create(CreateSuspended: Boolean);overload;
    destructor Destroy(); override;
  private
    {是否开始更新}
    //m_Active : Boolean;
    //同步管理器
    m_HttpUpdateMgr: TDataUpdateManager;
    //日志字符串
    //m_LogStr: string;
    //间隔
    m_WaitInterval: DWORD;
    {消息窗体}
    m_msgWnd:HWND;
  private
    //休眠
    procedure DoSafeSleep();
    {功能:消息处理函数}
    procedure MsgFun(var Msg:TMessage);
    
  protected
    procedure Execute; override;
    {功能:日志输出}
    procedure InsertLogs(strLog : String);
    {功能：输出上传进度信息}
    procedure SynchronizeOutProcessing();

  public
    {功能:日志事件}
    OnLogEvent: TOnEventByString ;

  public
    
    {更新数据库}
    function SetDB(adoCon:TADOConnection): Boolean;
    {更新web接地}
    function SetWebConfig(webConfig:RWebConfig):Boolean;
    {更新频率}
    function SetPeriod(nSecond:Integer):Boolean;
    {功能:停止}
    procedure Stop();
    {功能:暂停}
    procedure Pause();
    {功能:继续}
    procedure Continue();

    property WaitInterval: DWORD read m_WaitInterval;

  end;

implementation


{ TUPDateThread }
procedure TUPDateThread.Continue;
begin
  if self.Suspended then
  begin
    self.Resume();
  end;
end;

constructor TUPDateThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  m_msgWnd := allocateHwnd(MsgFun);
  m_HttpUpdateMgr := TDataUpdateManager.Create();
  m_HttpUpdateMgr.OnInsertLogs := self.InsertLogs;
  m_HttpUpdateMgr.AddUpdateJob(TWebJob_TrainmanSync.Create('人员信息'));
  m_HttpUpdateMgr.AddUpdateJob(TWebJob_InOutRoom.Create('出入公寓'));

  //m_HttpUpdateMgr.AddUpdateJob(TWebJob_WaitWorkPlan.Create('待乘计划'));

end;


destructor TUPDateThread.Destroy;
begin
  //self.Stop();
  DeallocateHwnd(m_MsgWnd);
  m_HttpUpdateMgr.Free;
  inherited;
end;


procedure TUPDateThread.DoSafeSleep;
var
  s: DWORD;
begin
  s := 0;
  while (s<m_WaitInterval) and (not self.Terminated) do
  begin
    Sleep(50);
    Inc(s, 50);
  end;
end;

procedure TUPDateThread.Execute;
begin
  FreeOnTerminate := False;
  CoInitialize(nil);
  try
    InsertLogs('数据更新线程已启动。');
    While Terminated = False do
    begin
      InsertLogs(DupeString('----------', 10));

      //顺序执行更新任务
      m_HttpUpdateMgr.DoUpdate();

      //休息片刻
      DoSafeSleep();
    end;

  finally
    InsertLogs('数据更新线程已结束。');
    CoUninitialize;
  end;
end;


procedure TUPDateThread.InsertLogs(strLog: String);
{日志输出}
begin
  SendMessage(m_msgWnd,WM_MSG_LOG,Integer(@strLog),0)
  //Synchronize(SynchronizeOutPutLog);
end;

procedure TUPDateThread.MsgFun(var Msg: TMessage);
var
  strLog:string;
begin
  if Msg.Msg = WM_MSG_LOG then
  begin
    if Assigned(OnLogEvent) then
    begin
      strLog := string(Pointer(Msg.wParam)^);
      OnLogEvent(strLog);
    end;
  end;
end;

procedure TUPDateThread.Pause;
begin
  if not self.Suspended then
  begin
    self.Suspend();
  end;
end;

procedure TUPDateThread.Stop;
begin
  Self.Terminate;

  m_HttpUpdateMgr.Stop();
end;


procedure TUPDateThread.SynchronizeOutProcessing;
begin

end;


function TUPDateThread.SetDB(adocon:TADOConnection): Boolean;
var
  strMsg:string;
begin
  Result := False;
 // m_WaitInterval := SystemConfig.Config.UploadingFrequency*1000;

  if m_HttpUpdateMgr.InitDB(adocon.ConnectionString,strMsg) = False then
  begin
    InsertLogs('连接本地数据库失败:' + strMsg);
    Exit;
  end;

  Result := True;
end;

function TUPDateThread.SetPeriod(nSecond: Integer): Boolean;
begin
  m_WaitInterval := nSecond * 1000;
end;

function TUPDateThread.SetWebConfig(webConfig: RWebConfig): Boolean;
begin
  m_HttpUpdateMgr.SetWebConfig(webConfig);
end;

end.
