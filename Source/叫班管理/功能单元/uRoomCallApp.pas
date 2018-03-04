unit uRoomCallApp;

interface
uses
  Classes,SysUtils,DateUtils,uDBRoomCall,ADODB,uRoomCallOp,uCallUtils,uCallControl,
  uPubFun,uRoomCall,uMixerRecord,uSaftyEnum;
type
////////////////////////////////////////////////////////////////////////////////
///����  TRoomCallApp
///����:��Ԣ�а��߼�
////////////////////////////////////////////////////////////////////////////////
  TRoomCallApp = class
  public
    constructor Create();
    destructor Destroy();override;
  private
    //����ʵ��
    class var m_Self:TRoomCallApp;
    //���ݿ����
    m_Adocon:TADOConnection;
  public
    {����:��ʼ������}
    procedure InitInstance(adoCon:TADOConnection);
    {����:��ȡʵ��}
    class function GetInstance():TRoomCallApp;
    {����:�ͷ�ʵ��}
    class procedure FreeInstance();
  public
    //����а�ƻ����ݿ����
    DBCallPlan:TDBCallmanPlan;
    //�а�����
    CallConfig:TCallConfig;
    //�豸��Ϣ���ݿ����
    DBCallDev:TDBCallDev;
    //�豸��Ϣ���ݿ����
    DBServerRoomDev:TDBServerRomDev;
    //�а��¼���ݿ����
    DBCallRecord:TDBCallRecord;
    //�а��������ݿ����
    DBCallVoice:TDBCallVoice;
    //�а����
    CallDevOp:TCallDevOP;


  public
    //����а���
    procedure SaveCallResult(CallRoomRecord :TCallRoomRecord);
  end;

implementation

{ TCallWorkApp }
procedure TRoomCallApp.InitInstance(adoCon:TADOConnection);
begin
  m_Adocon := adoCon;
  DBCallPlan:=TDBCallmanPlan.Create(adoCon);
  DBCallDev:=TDBCallDev.Create(adoCon);
  DBServerRoomDev:=TDBServerRomDev.Create(adoCon);
  DBCallRecord := TDBCallRecord.Create(adoCon);
  DBCallVoice:=TDBCallVoice.Create(adoCon);
  CallConfig:=TCallConfig.GetInstance;
  CallConfig.strIniFile := TPubfun.AppPath + 'config.ini';

  CallDevOp:=TCallDevOP.GetInstance;
  CallDevOp.CallConfig := CallConfig;

end;

procedure TRoomCallApp.SaveCallResult(CallRoomRecord :TCallRoomRecord);
var
  i:Integer;
  callManRecord:TCallManRecord;
begin
  m_Adocon.BeginTrans;
  //dbCallVoice := TDBCallVoice.Create(Self.GetADOConnection);
  //dbCallPlan := TDBCallManPlan.Create(self.GetADOConnection);
  try
    for I := 0 to CallRoomRecord.CallManRecordList.Count - 1 do
    begin
      callManRecord :=  CallRoomRecord.CallManRecordList.Items[i];
      DBCallRecord.Add(callManRecord);
      if callManRecord.eCallState = TCS_FIRSTCALL  then
        //dbCallPlan.UpdateFirstCallTime(callManRecord.strCallManPlanGUID,callManRecord.dtCreateTime);
        DBCallPlan.UpdateFirstCallResult(callManRecord);
      if callManRecord.eCallState = TCS_RECALL then
        //dbCallPlan.UpdateReCallTime(callManRecord.strCallManPlanGUID,callManRecord.dtCreateTime);
        DBCallPlan.UpdateReCallResult(callManRecord);

      if callManRecord.eCallState = TCS_SERVER_ROOM_CALL then
        //dbCallPlan.UpdateReCallTime(callManRecord.strCallManPlanGUID,callManRecord.dtCreateTime);
        DBCallPlan.UpdateServerRoomCallResult(callManRecord);
    end;
    dbCallVoice.Add(CallRoomRecord.CallVoice);
    Self.m_Adocon.CommitTrans;
  except on e:Exception do
    begin
      m_Adocon.RollbackTrans;
      RaiseLastWin32Error;
    end;
  end;
end;

constructor TRoomCallApp.Create();
begin

end;

destructor TRoomCallApp.Destroy;
begin
  DBCallRecord.Free;
  DBCallPlan.Free;
  DBCallDev.Free;
  DBServerRoomDev.Free;
  CallDevOp.Free;
  CallConfig.Free;
  DBCallVoice.Free;
end;

class procedure TRoomCallApp.FreeInstance;
begin
  if m_Self <> nil then
    FreeAndNil(m_Self);
end;

class function TRoomCallApp.GetInstance: TRoomCallApp;
begin
  if m_Self = nil then
    m_Self:=TRoomCallApp.Create;
  result := m_self;
end;

end.
