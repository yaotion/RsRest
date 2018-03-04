unit uUPDateThread;

interface

uses
  Classes,ACTIVEX,SysUtils,ADODB,windows,uTFSystem,forms,Messages, StrUtils
  , uHttpDataUpdateMgr,uWebIF,uWebJob_InOutRoom,uWebJob_TrainmanSync
  ;
const
  {ʮ����}
  DATACLEAR_PERIOD = 600000;
  {��־��Ϣ}
  WM_MSG_LOG = WM_USER + 7788;

type
  //////////////////////////////////////////////////////////////////////////////
  ///  TUPDateThread ���ݸ����߳�
  //////////////////////////////////////////////////////////////////////////////
  TUPDateThread = class(TThread)
  public
    constructor Create(CreateSuspended: Boolean);overload;
    destructor Destroy(); override;
  private
    {�Ƿ�ʼ����}
    //m_Active : Boolean;
    //ͬ��������
    m_HttpUpdateMgr: TDataUpdateManager;
    //��־�ַ���
    //m_LogStr: string;
    //���
    m_WaitInterval: DWORD;
    {��Ϣ����}
    m_msgWnd:HWND;
  private
    //����
    procedure DoSafeSleep();
    {����:��Ϣ������}
    procedure MsgFun(var Msg:TMessage);
    
  protected
    procedure Execute; override;
    {����:��־���}
    procedure InsertLogs(strLog : String);
    {���ܣ�����ϴ�������Ϣ}
    procedure SynchronizeOutProcessing();

  public
    {����:��־�¼�}
    OnLogEvent: TOnEventByString ;

  public
    
    {�������ݿ�}
    function SetDB(adoCon:TADOConnection): Boolean;
    {����web�ӵ�}
    function SetWebConfig(webConfig:RWebConfig):Boolean;
    {����Ƶ��}
    function SetPeriod(nSecond:Integer):Boolean;
    {����:ֹͣ}
    procedure Stop();
    {����:��ͣ}
    procedure Pause();
    {����:����}
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
  m_HttpUpdateMgr.AddUpdateJob(TWebJob_TrainmanSync.Create('��Ա��Ϣ'));
  m_HttpUpdateMgr.AddUpdateJob(TWebJob_InOutRoom.Create('���빫Ԣ'));

  //m_HttpUpdateMgr.AddUpdateJob(TWebJob_WaitWorkPlan.Create('���˼ƻ�'));

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
    InsertLogs('���ݸ����߳���������');
    While Terminated = False do
    begin
      InsertLogs(DupeString('----------', 10));

      //˳��ִ�и�������
      m_HttpUpdateMgr.DoUpdate();

      //��ϢƬ��
      DoSafeSleep();
    end;

  finally
    InsertLogs('���ݸ����߳��ѽ�����');
    CoUninitialize;
  end;
end;


procedure TUPDateThread.InsertLogs(strLog: String);
{��־���}
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
    InsertLogs('���ӱ������ݿ�ʧ��:' + strMsg);
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
