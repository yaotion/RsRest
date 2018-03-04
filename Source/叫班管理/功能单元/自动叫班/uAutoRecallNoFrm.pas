unit uAutoRecallNoFrm;

interface
uses
  Classes,SysUtils,uWaitWorkMgr,uWaitWork,uRoomCallApp,uRoomCall,uTFSystem,uSaftyEnum,uRoomCallOp;
type
  //�Զ��ؽ�
  TAutoRecallNoFrm = class
  public
    constructor Create();
    destructor Destroy();override;
  private
    {����:��ʼ�����豸�ص�}
    procedure OnStartConDev(data:TCallDevCallBackData);
    {����:�����豸�����ص�}
    procedure OnFinishConDev(data:TCallDevCallBackData);
    {����:��ʼ�߽лص�����}
    procedure OnStartReCallVoice(data:TCallDevCallBackData);
    {����:�߽н����ص�����}
    procedure OnFinishReCallVoice(data:TCallDevCallBackData);
    {����:�Ҷ��豸�ص�����}
    procedure OnDisConDevEvent(data:TCallDevCallBackData);
    {����:���ûص�����}
    function SetEventFun():Boolean;
    {����:����ص�����}
    procedure ClearEventFun();
  public
    procedure AutoRecall(callRecord :TCallRoomRecord;callRoomPlan:TCallRoomPlan;FinishCallResult:TFinishCallResult);
  private
    //�а����
    m_RoomCallApp:TRoomCallApp;
    //�Ƿ����ӳɹ�
    m_bConSucess:Boolean;
    //��ɽа��¼�
    m_FinishCallResult: TFinishCallResult;
  end;

implementation
uses uGlobalDM;

{ TAotoRecallNoFrm }

procedure TAutoRecallNoFrm.AutoRecall(callRecord: TCallRoomRecord;
  callRoomPlan: TCallRoomPlan; FinishCallResult: TFinishCallResult);
var
  strMsg:string;
begin
  m_RoomCallApp.CallDevOp.CallRecord.Clone(callRecord);
  m_RoomCallApp.CallDevOp.AutoReCall(strMsg);
  m_FinishCallResult := FinishCallResult;
end;

procedure TAutoRecallNoFrm.ClearEventFun;
begin
  m_RoomCallApp.CallDevOp.OnStartConDevEvent := nil;
  m_RoomCallApp.CallDevOp.OnFinishConDevEvent := nil;
  m_RoomCallApp.CallDevOp.OnFinishReCallVoiceEvent:=nil;
  m_RoomCallApp.CallDevOp.OnStartReCallVoiceEvent := nil;
  m_RoomCallApp.CallDevOp.OnDisConDevEvent := nil;
end;

function TAutoRecallNoFrm.SetEventFun: Boolean;
begin
  result := False;
  if m_RoomCallApp.CallDevOp.bCalling then Exit;

  m_RoomCallApp.CallDevOp.OnStartConDevEvent := Self.OnStartConDev;
  m_RoomCallApp.CallDevOp.OnFinishConDevEvent := Self.OnFinishConDev;
  m_RoomCallApp.CallDevOp.OnFinishReCallVoiceEvent:= Self.OnFinishReCallVoice;
  m_RoomCallApp.CallDevOp.OnStartReCallVoiceEvent := Self.OnStartReCallVoice;
  m_RoomCallApp.CallDevOp.OnDisConDevEvent := Self.OnDisConDevEvent;
  result := True;
end;

constructor TAutoRecallNoFrm.Create;
begin
  m_RoomCallApp:=TRoomCallApp.GetInstance;
  SetEventFun;
end;

destructor TAutoRecallNoFrm.Destroy;
begin
  ClearEventFun;
  inherited;
end;

procedure TAutoRecallNoFrm.OnDisConDevEvent(data: TCallDevCallBackData);
begin
  m_RoomCallApp.CallDevOp.CloseThread();
  if Assigned(m_FinishCallResult) then
    m_FinishCallResult(m_bConSucess,data);
end;

procedure TAutoRecallNoFrm.OnFinishConDev(data: TCallDevCallBackData);
var
  strMsg:string;
begin
  m_bConSucess := False;
  case data.callRoomRecord.eCallResult of
    TR_SUCESS:
    begin
      strMsg := Format('��%d�κ��з����豸,���:�ɹ�!',[data.callRoomRecord.nConTryTimes]) ;
      m_bConSucess:= True;
    end ;
    TR_FAIL:
    begin
      strMsg := Format('��%d�κ��з����豸,���:ʧ��,ԭ��:%s',[data.callRoomRecord.nConTryTimes,data.callRoomRecord.strMsg]);
    end;
    TR_CANCEL:
    begin
      strMsg := Format('��%d�κ��з����豸,���:ʧ��,ԭ��:%s',[data.callRoomRecord.nConTryTimes,'�û�ȡ��']);
    end;
    TR_TIMEOUT:
    begin
      strMsg := Format('��%d�κ��з����豸,���:ʧ��,ԭ��:%s',[data.callRoomRecord.nConTryTimes,'���г�ʱ']);
    end;
  else ;
  end;
  if data.callRoomRecord.eCallResult <> TR_SUCESS then
  begin
    m_RoomCallApp.CallDevOp.DisConDevice(strMsg);
  end;

end;

procedure TAutoRecallNoFrm.OnFinishReCallVoice(data: TCallDevCallBackData);
var
  strMsg:string;
begin
  m_RoomCallApp.CallDevOp.DisConDevice(strMsg);
end;

procedure TAutoRecallNoFrm.OnStartConDev(data: TCallDevCallBackData);
begin

end;

procedure TAutoRecallNoFrm.OnStartReCallVoice(data: TCallDevCallBackData);
begin

end;


end.
