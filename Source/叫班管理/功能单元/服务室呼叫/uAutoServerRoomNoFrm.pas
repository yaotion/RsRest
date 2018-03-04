unit uAutoServerRoomNoFrm;

interface
uses
  Classes,SysUtils,uWaitWorkMgr,uWaitWork,uRoomCallApp,uRoomCall,uTFSystem,uSaftyEnum,uRoomCallOp;
type
  //服务室呼叫
  TAutoServerRoomNoFrm = class
  public
    constructor Create();
    destructor Destroy();override;
  private
    {功能:开始连接设备回调}
    procedure OnStartConDev(data:TCallDevCallBackData);
    {功能:连接设备结束回调}
    procedure OnFinishConDev(data:TCallDevCallBackData);
    {功能:开始催叫回调函数}
    procedure OnStartReCallVoice(data:TCallDevCallBackData);
    {功能:催叫结束回调函数}
    procedure OnFinishReCallVoice(data:TCallDevCallBackData);

    {功能:开始催叫回调函数}
    procedure OnStartServerRoomCallVoice(data:TCallDevCallBackData);
    {功能:催叫结束回调函数}
    procedure OnFinishServerRoomCallVoice(data:TCallDevCallBackData);
    {功能:挂断设备回调函数}
    procedure OnDisConDevEvent(data:TCallDevCallBackData);
    {功能:设置回调函数}
    function SetEventFun():Boolean;
    {功能:清除回调函数}
    procedure ClearEventFun();
  public
    procedure AutoCall(callRecord :TCallRoomRecord;callRoomPlan:TCallRoomPlan;FinishCallResult:TFinishCallResult);
  private
    //叫班管理
    m_RoomCallApp:TRoomCallApp;
    //是否连接成功
    m_bConSucess:Boolean;
    //完成叫班事件
    m_FinishCallResult: TFinishCallResult;
  end;

implementation
uses uGlobalDM;

{ TAotoRecallNoFrm }

procedure TAutoServerRoomNoFrm.AutoCall(callRecord: TCallRoomRecord;
  callRoomPlan: TCallRoomPlan; FinishCallResult: TFinishCallResult);
var
  strMsg:string;
begin
  m_RoomCallApp.CallDevOp.CallRecord.Clone(callRecord);
  m_RoomCallApp.CallDevOp.AutoServerRoomCall(strMsg);
  m_FinishCallResult := FinishCallResult;
end;

procedure TAutoServerRoomNoFrm.ClearEventFun;
begin
  m_RoomCallApp.CallDevOp.OnStartConDevEvent := nil;
  m_RoomCallApp.CallDevOp.OnFinishConDevEvent := nil;
  m_RoomCallApp.CallDevOp.OnFinishReCallVoiceEvent:=nil;
  m_RoomCallApp.CallDevOp.OnStartReCallVoiceEvent := nil;
  m_RoomCallApp.CallDevOp.OnDisConDevEvent := nil;

  m_RoomCallApp.CallDevOp.OnStartServerRoomCallVoiceEvent := nil ;
  m_RoomCallApp.CallDevOp.OnFinishServerRoomCallVoiceEvent := nil ;
end;

function TAutoServerRoomNoFrm.SetEventFun: Boolean;
begin
  result := False;
  if m_RoomCallApp.CallDevOp.bCalling then Exit;

  m_RoomCallApp.CallDevOp.OnStartConDevEvent := Self.OnStartConDev;
  m_RoomCallApp.CallDevOp.OnFinishConDevEvent := Self.OnFinishConDev;
  m_RoomCallApp.CallDevOp.OnFinishReCallVoiceEvent:= Self.OnFinishReCallVoice;
  m_RoomCallApp.CallDevOp.OnStartReCallVoiceEvent := Self.OnStartReCallVoice;
  m_RoomCallApp.CallDevOp.OnDisConDevEvent := Self.OnDisConDevEvent;

  m_RoomCallApp.CallDevOp.OnStartServerRoomCallVoiceEvent := self.OnStartServerRoomCallVoice ;
  m_RoomCallApp.CallDevOp.OnFinishServerRoomCallVoiceEvent := self.OnFinishServerRoomCallVoice;
  result := True;
end;

constructor TAutoServerRoomNoFrm.Create;
begin
  m_RoomCallApp:=TRoomCallApp.GetInstance;
  SetEventFun;
end;

destructor TAutoServerRoomNoFrm.Destroy;
begin
  ClearEventFun;
  inherited;
end;

procedure TAutoServerRoomNoFrm.OnDisConDevEvent(data: TCallDevCallBackData);
begin
  m_RoomCallApp.CallDevOp.CloseThread();
  if Assigned(m_FinishCallResult) then
    m_FinishCallResult(m_bConSucess,data);
end;

procedure TAutoServerRoomNoFrm.OnFinishConDev(data: TCallDevCallBackData);
var
  strMsg:string;
begin
  m_bConSucess := False;
  case data.callRoomRecord.eCallResult of
    TR_SUCESS:
    begin
      strMsg := Format('第%d次呼叫房间设备,结果:成功!',[data.callRoomRecord.nConTryTimes]) ;
      m_bConSucess:= True;
    end ;
    TR_FAIL:
    begin
      strMsg := Format('第%d次呼叫房间设备,结果:失败,原因:%s',[data.callRoomRecord.nConTryTimes,data.callRoomRecord.strMsg]);
    end;
    TR_CANCEL:
    begin
      strMsg := Format('第%d次呼叫房间设备,结果:失败,原因:%s',[data.callRoomRecord.nConTryTimes,'用户取消']);
    end;
    TR_TIMEOUT:
    begin
      strMsg := Format('第%d次呼叫房间设备,结果:失败,原因:%s',[data.callRoomRecord.nConTryTimes,'呼叫超时']);
    end;
  else ;
  end;
  if data.callRoomRecord.eCallResult <> TR_SUCESS then
  begin
    m_RoomCallApp.CallDevOp.DisConDevice(strMsg);
  end;

end;

procedure TAutoServerRoomNoFrm.OnFinishReCallVoice(data: TCallDevCallBackData);
var
  strMsg:string;
begin

end;

procedure TAutoServerRoomNoFrm.OnFinishServerRoomCallVoice(
  data: TCallDevCallBackData);
var
  strMsg:string;
begin
  m_RoomCallApp.CallDevOp.DisConDevice(strMsg);
end;

procedure TAutoServerRoomNoFrm.OnStartConDev(data: TCallDevCallBackData);
begin

end;

procedure TAutoServerRoomNoFrm.OnStartReCallVoice(data: TCallDevCallBackData);
begin

end;


procedure TAutoServerRoomNoFrm.OnStartServerRoomCallVoice(
  data: TCallDevCallBackData);
begin
  ;
end;

end.
