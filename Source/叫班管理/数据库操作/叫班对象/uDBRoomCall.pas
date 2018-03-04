unit uDBRoomCall;

interface
uses
  Classes,uTFSystem,ADODB,SysUtils,uRoomCall,uSaftyEnum,DB,StrUtils,Variants;
type
  //////////////////////////////////////////////////////////////////////////////
  /// ����:TDBRoomDev
  /// ����:��Ԣ�а��豸����
  //////////////////////////////////////////////////////////////////////////////
  TDBCallDev = class(TDBOperate)
  public
    {����:�����豸}
    procedure Add(dev:RCallDev);
    {����:�޸��豸}
    procedure Modify(dev:RCallDev);
    {����:ɾ���豸}
    procedure Delete(strGUID:string);
    {����:��ȡ�����豸}
    procedure GetAll(out devAry:TCallDevAry);
    {����:���ݷ����Ų���}
    function FindByRoom(strRoomNum :string;out dev:RCallDev):Boolean;
    {����:���ݷ����Ų���}
    function QueryRooms(strRoomNum :string;out devAry:TCallDevAry):Boolean;
    {����:�����豸��Ų���}
    function FindByDev(nDevNum:Integer;out dev:RCallDev):Boolean;
  private
    {����:����query}
    procedure Obj2Query(dev:RCallDev;query:TADOQuery);
    {����:query������}
    procedure Query2Obj(query:TADOQuery;var dev:RCallDev);
  end;



  //////////////////////////////////////////////////////////////////////////////
  /// ����:TDBServerRomDev
  /// ����:�������豸�������
  //////////////////////////////////////////////////////////////////////////////
  TDBServerRomDev = class(TDBOperate)
  public
    {����:�����豸}
    procedure Add(dev:RCallDev);
    {����:�޸��豸}
    procedure Modify(dev:RCallDev);
    {����:ɾ���豸}
    procedure Delete(strGUID:string);
    {����:��ȡ�����豸}
    procedure GetAll(out devAry:TCallDevAry);
    {����:���ݷ����Ų���}
    function FindByRoom(strRoomNum :string;out dev:RCallDev):Boolean;
    {����:���ݷ����Ų���}
    function QueryRooms(strRoomNum :string;out devAry:TCallDevAry):Boolean;
    {����:�����豸��Ų���}
    function FindByDev(nDevNum:Integer;out dev:RCallDev):Boolean;
  public
    {����:����һ������}
    procedure AddSleepRoom(ServerRoomRelation:RServerRoomRelation);
    {����:�޸�����}
    procedure ModifySleepRoom(ServerRoomRelation:RServerRoomRelation);
    {����:ɾ������}
    procedure DeleteSleepRoom(strGUID:string);
    {���ܣ�����Ƿ���ڸ�����}
    function IsExistSleepRoom(SleepRoomNumber:string;out Number:string):boolean;
    {����:����һ������ķ�����}
    function  QueryServerNumber(RoomNumber:string;out ServerRoomNumber:string):boolean;
    {����:��ȡ���������豸}
    procedure GetAllSleepRoom(Number:string;out ServerRoomRelationAry:TServerRoomRelationAry);
  private
    {����:����query}
    procedure Obj2Query_2(ServerRoomRelation:RServerRoomRelation;query:TADOQuery);
    {����:query������}
    procedure Query2Obj_2(query:TADOQuery;var ServerRoomRelation:RServerRoomRelation);
  private
    {����:����query}
    procedure Obj2Query(dev:RCallDev;query:TADOQuery);
    {����:query������}
    procedure Query2Obj(query:TADOQuery;var dev:RCallDev);
  end;
  
  //////////////////////////////////////////////////////////////////////////////
  /// ����:TDBCallVoice
  /// ����:��Ԣ�а��������ݿ����
  //////////////////////////////////////////////////////////////////////////////
  TDBCallVoice = class(TDBOperate)
  public
    {����:����}
    procedure Add(CallVoice:TCallVoice);
    {����:����������¼}
    function Find(strCallVoiceGUID:string;var CallVoice:TCallVoice ) :Boolean;
    {����:��ȡ¼���ļ�}
    //function GetVoiceFile(strGUID,strFilePathName:string):Boolean;
    function ModifyVicePath(strCallVoiceGUID,FilePath:string):Boolean;
  public
    {���ݼ�������}
    procedure Qry2Obj(qry:TADOQuery;var obj:TCallVoice);
    {�������ݼ�}
    procedure Obj2Qry(Obj:TCallVoice;qry:TADOQuery);
  end;


  //////////////////////////////////////////////////////////////////////////////
  /// ����:TDBCallRecord
  /// ����:��Ԣ�а��¼���ݿ����
  //////////////////////////////////////////////////////////////////////////////
  TDBCallRecord = class(TDBOperate)
  public

    {����:����}
    procedure Add(callRecord:TCallManRecord) ; overload;
    {����:���ӷ���а��¼}
    procedure Add(CallRoomRecord:TCallRoomRecord); overload;
    {����:��ѯ�а��¼}
    procedure qryCallRecord(params:RCallQryParams;var CallManRecordList:TCallManRecordList);

  private
    {�����ѯ����}
    procedure SetSearchQry(qry:TADOQuery;params:RCallQryParams);
    {���ݼ� ��ֵ�� ����}
    procedure Query2Obj(qry:TADOQuery;var callRecord:TCallManRecord);
    {���� ��ֵ�� ���ݼ�}
    procedure Obj2Query(callRecord:TCallManRecord;qry:TADOQuery);
  end;


  //////////////////////////////////////////////////////////////////////////////
  ///����:TDBCallManPlan
  ///����:��Ա�а�ƻ�
  //////////////////////////////////////////////////////////////////////////////
  TDBCallManPlan = class(TDBOperate)
  public
    {����:�����г��ƻ�����Ա����}
    function FindUnCall(strTrainPlanGUID,strTrainmanGUID:string;var callManPlan:TCallManPlan):Boolean;
    {����:���Ӽ�¼}
    procedure Add(manPlan:TCallManPlan);overload;
    {����:���Ӷ����¼}
    procedure Add(manPlanList:TCallManPlanList);overload;

    {����:�޸ķ���а�ƻ�}
    function ModifyRoomPlan(RoomPlan:TCallRoomPlan):Boolean;
    {����:�޸ļ�¼}
    function ModifyManPlan(manPlan:TCallManPlan):Boolean;overload;
    {����:�޸ļ�¼}
    function ModifyManPlan(manPlan:TCallManPlan;strWaitPlanGUID,strRoomNumber:string):Boolean;overload;
    {����:�޸ķ���}
    procedure ModifyRoom(strWaitPlanGUID,strTrainmanGUID,strRoomNumber:string);
    {����:ɾ����¼}
    procedure Del(manPlanGUID:string);
    {����:���ݴ��˼ƻ�ɾ�������¼}
    procedure DelByWaitPlan(WaitPlanGUID:string);
    {����:ɾ������Ա�Ľа�ƻ�}
    procedure Del_PlanAndRoomNumber(strWaitPlanGUID,strRoomNumber:string);
    {����:ɾ���а�ƻ�}
    procedure Del_PlanAndTMGUID(strWaitPlanGUID,strTrainmanGUID:string);
    {����:��ȡ������а�ƻ��б�}
    procedure GetRoomCallPlanList(var roomPlanList:TCallRoomPlanList;eStartState,eEndState:TRoomCallState);

    {����:��ȡ��Ա�ƻ�����״̬}
    procedure GetManPlanOfState(var manPlanList:TCallManPlanList;ePlanState:TRoomCallState);
    {����:�����׽�ʱ��}
    procedure UpdateFirstCallTime(strCallPlanGUID:string; dtTime:TDateTime);
    {����:�����׽н��}
    procedure UpdateFirstCallResult(callmanRecord:TCallManRecord);
    {����:���´߽�ʱ��}
    procedure UpdateReCallTime(strCallPlanGUID:string;dtTime:TDateTime);
    {����:���Ĵ߽н��}
    procedure UpdateReCallResult(callmanRecord:TCallManRecord);
    {����:���ķ����ҽн��}
    procedure UpdateServerRoomCallResult(callmanRecord:TCallManRecord);
    {����:���ҽа�ƻ�}
    function Find(strWaitPlanGUID,strTrainmanGUID:string;callManPlan:TCallManPlan):Boolean;
    {����:�޸ķ���}
    procedure ChangeRoom(strWaitPlanGUID,strTrainmanGUID,strRoomNum:string);
    {����:����ת��Ϊ���ݼ�}
    class procedure Obj2Qry(obj:TCallManPlan;qry:TADOQuery);
    class procedure Qry2Obj(qry:TADOQuery;var obj :TCallManPlan);
  end;

implementation



procedure TDBCallRecord.Add(callRecord: TCallManRecord);
var
  qry:TADOQuery;
begin
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Record_CallMan where 1<>1';
    qry.Open;
    qry.Append;
    self.Obj2Query(callRecord,qry);
    qry.Post;
  finally
    qry.free;
  end;
end;
procedure TDBCallRecord.Add(CallRoomRecord:TCallRoomRecord);
var
  i:Integer;
  dbCallVoice:TDBCallVoice;
  dbCallPlan:TDBCallManPlan;
  callManRecord:TCallManRecord;
begin
  dbCallVoice := TDBCallVoice.Create(Self.GetADOConnection);
  dbCallPlan := TDBCallManPlan.Create(self.GetADOConnection);
  Self.GetADOConnection.BeginTrans;
  try
    try
      for I := 0 to CallRoomRecord.CallManRecordList.Count - 1 do
      begin
        callManRecord :=  CallRoomRecord.CallManRecordList.Items[i];
        Add(callManRecord);
        if callManRecord.eCallState = TCS_FIRSTCALL then
          dbCallPlan.UpdateFirstCallTime(callManRecord.strCallManPlanGUID,callManRecord.dtCreateTime);
        if callManRecord.eCallState = TCS_RECALL then
          dbCallPlan.UpdateReCallTime(callManRecord.strCallManPlanGUID,callManRecord.dtCreateTime);
      end;
      dbCallVoice.Add(CallRoomRecord.CallVoice);
      Self.GetADOConnection.CommitTrans;
    except on e:Exception do
      begin
        GetADOConnection.RollbackTrans;
        RaiseLastWin32Error;
      end;
    end;
  finally
    dbCallPlan.Free;
    dbCallVoice.Free;
  end;
end;

{function TDBCallVoice.GetVoiceFile(strGUID, strFilePathName:string): Boolean;
var
  qry:TADOQuery;
begin
  result := False;
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select msVoice from Tab_Record_CallVoice where strCallVoiceGUID=:strCallVoiceGUID';
    qry.Parameters.ParamByName('strCallVoiceGUID').Value := strGUID;
    qry.Open;
    if qry.RecordCount = 0  then Exit;
    if not qry.FieldByName('msVoice').IsNull then
    begin
      TBlobField(qry.FieldByName('msVoice')).SaveToFile(strFilePathName);
      result := True;
    end;
  finally
    qry.Free;
  end;
end; }

procedure TDBCallRecord.Obj2Query(callRecord: TCallManRecord; qry: TADOQuery);
begin
  qry.FieldByName('strGUID').Value := callRecord.strGUID;
  qry.FieldByName('strPlanGUID').Value := callRecord.strWaitPlanGUID;
  qry.FieldByName('strTrainNo').Value := callRecord.strTrainNo;
  qry.FieldByName('strRoomNum').Value := callRecord.strRoomNum;
  qry.FieldByName('dtCallTime').Value := callRecord.dtCallTime;
  qry.FieldByName('eCallType').Value := callRecord.eCallType;
  qry.FieldByName('eCallState').Value := callRecord.eCallState;
  qry.FieldByName('strDutyUser').Value := callRecord.strDutyUser;
  qry.FieldByName('eCallResult').Value := callRecord.eCallResult;
  qry.FieldByName('strmsg').Value := callRecord.strMsg;
  //TBlobField(qry.FieldByName('msVoice')).LoadFromStream(callRecord msVoice);
  
  qry.FieldByName('dtCreateTime').Value := callRecord.dtCreateTime;
  qry.FieldByName('nDeviceID').Value := callRecord.nDeviceID;
  qry.FieldByName('nConTryTimes').Value := callRecord.nConTryTimes;
  qry.FieldByName('dtChuQinTime').Value := callRecord.dtChuQinTime;
  qry.FieldByName('strCallVoiceGUID').Value := callRecord.strCallVoiceGUID;
  qry.FieldByName('strTrainmanGUID').Value := callRecord.strTrainmanGUID;
  qry.FieldByName('strTrainmanNumber').Value := callRecord.strTrainmanNumber;
  qry.FieldByName('strTrainmanName').Value := callRecord.strTrainmanName;
  qry.FieldByName('strVoiceTxt').Value := callRecord.strVoiceTxt;
end;

procedure TDBCallRecord.qryCallRecord(params: RCallQryParams;
  var CallManRecordList:TCallManRecordList);
var
  qry:TADOQuery;
  i:Integer;
  CallManRecord:TCallManRecord;
begin
  qry := NewADOQuery;
  try
    self.SetSearchQry(qry,params);
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    for i := 0 to qry.RecordCount - 1 do
    begin
      CallManRecord:=TCallManRecord.Create;
      Self.Query2Obj(qry,CallManRecord);
      CallManRecordList.Add(CallManRecord) ;
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;


procedure TDBCallRecord.Query2Obj(qry: TADOQuery; var callRecord:TCallManRecord);
begin
  callRecord.strGUID := qry.FieldByName('strGUID').Value;
  callRecord.strWaitPlanGUID := qry.FieldByName('strPlanGUID').Value;
  callRecord.strTrainNo := qry.FieldByName('strTrainNo').Value;
  callRecord.strRoomNum := qry.FieldByName('strRoomNum').Value;
  callRecord.dtCallTime := qry.FieldByName('dtCallTime').Value;
  callRecord.eCallType := qry.FieldByName('eCallType').Value;
   callRecord.eCallState :=qry.FieldByName('eCallState').Value;
  callRecord.strDutyUser := qry.FieldByName('strDutyUser').Value;
  callRecord.eCallResult := qry.FieldByName('eCallResult').Value;
  callRecord.strMsg := qry.FieldByName('strMsg').Value;

  callRecord.dtCreateTime := qry.FieldByName('dtCreateTime').Value;
  callRecord.nDeviceID := qry.FieldByName('nDeviceID').Value;
  callRecord.nConTryTimes := qry.FieldByName('nConTryTimes').Value;
  callRecord.dtChuQinTime := qry.FieldByName('dtChuQinTime').Value;
  callRecord.strCallVoiceGUID := qry.FieldByName('strCallVoiceGUID').Value;
  callRecord.strTrainmanGUID := qry.FieldByName('strTrainmanGUID').Value;
  callRecord.strTrainmanNumber := qry.FieldByName('strTrainmanNumber').Value;
  callRecord.strTrainmanName := qry.FieldByName('strTrainmanName').Value;
  callRecord.strVoiceTxt :=qry.FieldByName('strVoiceTxt').Value; 

end;

procedure TDBCallRecord.SetSearchQry(qry: TADOQuery; params: RCallQryParams);
var
  strSql:string;
begin
  strSql := 'select * from tab_Record_CallMan where dtCallTime >=:dtStart and '
    + ' dtCallTime <= :dtEnd ';
  if params.strTrainNo <> '' then
    strSql := strSql + ' and strTrainNo =:strTrainNo';
  if params.strRoomNum <> '' then
    strSql := strSql + ' and strRoomNum =:strRoomNum';
  strSql := strSql + ' order by dtCallTime ' ;
  qry.SQL.Text := strSql;
  qry.Parameters.ParamByName('dtStart').Value := params.dtStartCallTime;
  qry.Parameters.ParamByName('dtEnd').Value := params.dtEndCallTime;
  if qry.Parameters.FindParam('strTrainNo') <> nil then
    qry.Parameters.ParamByName('strTrainNo').Value := params.strTrainNo;
  if qry.Parameters.FindParam('strRoomNum') <> nil then
    qry.Parameters.ParamByName('strRoomNum').Value := params.strRoomNum;

end;

{ TDBRoomDev }

procedure TDBCallDev.Add(dev: RCallDev);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Base_RoomCallDev';
    qry.Open;
    qry.Append;
    self.Obj2Query(dev,qry);
    qry.Post;
  finally
    qry.free;
  end;
end;

procedure TDBCallDev.Delete(strGUID: string);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'delete  from tab_Base_RoomCallDev where strGUID =:strGUID';
    qry.Parameters.ParamByName('strGUID').Value := strGUID;
    qry.ExecSQL;
  finally
    qry.free;
  end;
end;

function TDBCallDev.FindByDev(nDevNum:Integer;out dev: RCallDev): Boolean;
var
  qry:TADOQuery;
begin
  Result := False;
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Base_RoomCallDev where nDevNum =:nDevNum';
    qry.Parameters.ParamByName('nDevNum').Value := nDevNum;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    self.Query2Obj(qry,dev);
    Result := True;
  finally
    qry.Free;
  end;
end;

function TDBCallDev.FindByRoom(strRoomNum:string;out dev: RCallDev): Boolean;
var
  qry:TADOQuery;
begin
  Result := False;
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Base_RoomCallDev where strRoomNum =:strRoomNum';
    qry.Parameters.ParamByName('strRoomNum').Value := strRoomNum;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    self.Query2Obj(qry,dev);
    Result := True;
  finally
    qry.Free;
  end;
end;

function TDBCallDev.QueryRooms(strRoomNum: string; out devAry:TCallDevAry): Boolean;
var
  qry:TADOQuery;
  i : integer ;
begin
  Result := False;
  qry:= NewADOQuery;
  try
    if strRoomNum = '' then
      qry.SQL.Text := 'select * from tab_Base_RoomCallDev ORDER BY strRoomNum'
    else
      qry.SQL.Text := 'select * from tab_Base_RoomCallDev where strRoomNum  like ' + QuotedStr(strRoomNum + '%') +' ORDER BY strRoomNum';
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    SetLength(devAry,qry.RecordCount);
    for i := 0 to qry.RecordCount - 1 do
    begin
      Self.Query2Obj(qry,devAry[i]);
      qry.Next;
    end;

    Result := True;
  finally
    qry.Free;
  end;
end;

procedure TDBCallDev.GetAll(out devAry: TCallDevAry);
var
  qry:TADOQuery;
  i:Integer;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select *  from tab_Base_RoomCallDev ORDER BY strRoomNum';
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    SetLength(devAry,qry.RecordCount);
    for i := 0 to qry.RecordCount - 1 do
    begin
      Self.Query2Obj(qry,devAry[i]);
      qry.Next;
    end;
  finally
    qry.free;
  end;
end;

procedure TDBCallDev.Modify(dev: RCallDev);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select *  from tab_Base_RoomCallDev where strGUID =:strGUID';
    qry.Parameters.ParamByName('strGUID').Value := dev.strGUID;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    qry.Edit;
    self.Obj2Query(dev,qry);
    qry.Post;
  finally
    qry.free;
  end;
end;

procedure TDBCallDev.Obj2Query(dev: RCallDev; query: TADOQuery);
begin
  query.FieldByName('strGUID').value := dev.strGUID;
  query.FieldByName('strRoomNum').value := dev.strRoomNum;
  query.FieldByName('nDevNum').value := dev.nDevNum;
end;

procedure TDBCallDev.Query2Obj(query: TADOQuery;var dev: RCallDev);
begin
  dev.strGUID := query.FieldByName('strGUID').value;
  dev.strRoomNum := query.FieldByName('strRoomNum').value;
  dev.nDevNum := query.FieldByName('nDevNum').value;
end;

{ TDBManCallPlan }

procedure TDBCallManPlan.Add(manPlan: TCallManPlan);
var
  qry:TADOQuery;
begin
  qry:=NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_plan_CallMan where strCallPlanGUID =:strGUID';
    qry.Parameters.ParamByName('strGUID').Value := manPlan.strGUID;
    qry.Open;
    if qry.RecordCount=0 then
      qry.Append
    else
      qry.Edit;
    self.Obj2Qry(manPlan,qry);
    qry.Post;
  finally
    qry.Free;
  end;
end;


procedure TDBCallManPlan.Add(manPlanList: TCallManPlanList);
var
  i:Integer;
  manPlan:TCallManPlan;
begin
  Self.GetADOConnection.BeginTrans;
  try
    for i := 0 to manPlanList.Count - 1 do
    begin
      manPlan := manPlanList.Items[i];
      Self.Add(manPlan);
    end;
    GetADOConnection.CommitTrans;
  except on e:Exception do
    GetADOConnection.RollbackTrans;
  end;
    
end;

procedure TDBCallManPlan.ChangeRoom(strWaitPlanGUID, strTrainmanGUID,
  strRoomNum: string);
var
  qry:TADOQuery;
begin
  qry:= NewADOQuery;
  qry.SQL.Text := 'update tab_plan_CallMan set strRoomNum = :strRoomNum where'
    + ' strWaitPlanGUID = :strWaitPlanGUID and strTrainmanGUID = :strTrainmanGUID';
  try
    qry.Parameters.ParamByName('strRoomNum').Value := strRoomNum;
    qry.Parameters.ParamByName('strWaitPlanGUID').Value := strWaitPlanGUID;
    qry.Parameters.ParamByName('strTrainmanGUID').Value := strTrainmanGUID;
    qry.ExecSQL;
  finally
    qry.Free;
  end;

end;

procedure TDBCallManPlan.Del(manPlanGUID: string);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'delete From tab_plan_CallMan where strCallPlanGUID =:strGUID';
    qry.Parameters.ParamByName('strGUID').Value := manPlanGUID;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

procedure TDBCallManPlan.DelByWaitPlan(WaitPlanGUID: string);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'delete from tab_Plan_CallMan where strWaitPlanGUID = :strWaitPlanGUID' ;
    qry.Parameters.ParamByName('strWaitPlanGUID').Value :=  WaitPlanGUID;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

procedure TDBCallManPlan.Del_PlanAndRoomNumber(strWaitPlanGUID,
  strRoomNumber: string);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'delete from tab_Plan_CallMan where strWaitPlanGUID = :strWaitPlanGUID'
      + ' and strRoomNum = :strRoomNum';
    qry.Parameters.ParamByName('strWaitPlanGUID').Value :=  strWaitPlanGUID;
    qry.Parameters.ParamByName('strRoomNum').Value := strRoomNumber;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

procedure TDBCallManPlan.Del_PlanAndTMGUID(strWaitPlanGUID,
  strTrainmanGUID: string);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'delete from tab_Plan_CallMan where strWaitPlanGUID = :strWaitPlanGUID'
      + ' and strTrainmanGUID = :strTrainmanGUID';
    qry.Parameters.ParamByName('strWaitPlanGUID').Value :=  strWaitPlanGUID;
    qry.Parameters.ParamByName('strTrainmanGUID').Value := strTrainmanGUID;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

function TDBCallManPlan.Find(strWaitPlanGUID, strTrainmanGUID: string;
  callManPlan: TCallManPlan): Boolean;
var
  qry:TADOQuery;
begin
  result := False;
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_plan_CallMan where strWaitPlanGUID = :strWaitPlanGUID'
      + ' and strTrainmanGUID = :strTrainmanGUID ';
    qry.Parameters.ParamByName('strWaitPlanGUID').Value := strWaitPlanGUID;
    qry.Parameters.ParamByName('strTrainmanGUID').Value := strTrainmanGUID;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    self.Qry2Obj(qry,callManPlan);
    result := True;
  finally
    qry.Free;
  end;
end;

function TDBCallManPlan.FindUnCall(strTrainPlanGUID, strTrainmanGUID: string;
  var callManPlan: TCallManPlan): Boolean;
var
  qry:TADOQuery;
begin
  result:= False;
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_plan_CallMan where strTrainPlanGUID =:strTrainPlanGUID'
      + ' and strTrainmanGUID =:strTrainmanGUID and eCallPlanState =:eCallPlanState ';
    qry.Parameters.ParamByName('strTrainPlanGUID').Value := strTrainPlanGUID;
    qry.Parameters.ParamByName('strTrainmanGUID').Value := strTrainmanGUID;
    qry.Parameters.ParamByName('eCallPlanState').Value := TCS_Publish;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    self.Qry2Obj(qry,callManPlan);
  finally
    qry.Free;
  end;
end;



procedure TDBCallManPlan.GetManPlanOfState(var manPlanList:TCallManPlanList;
            ePlanState:TRoomCallState);
var
  qry:TADOQuery;
  i:Integer;
  manPlan:TCallManPlan;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_plan_CallMan where ePlanState = :state '
      + ' order by dtCallTime';
    qry.Parameters.ParamByName('state').Value := ePlanState;
    qry.Open;

    for i := 0 to qry.RecordCount - 1 do
    begin
      manPlan:=TCallManPlan.Create;
      Self.Qry2Obj(qry,manPlan);
      manPlanList.Add(manPlan);
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

procedure TDBCallManPlan.GetRoomCallPlanList(var roomPlanList: TCallRoomPlanList;
  eStartState, eEndState: TRoomCallState);
{����ʱ�䣬����ȥ����Ա������Ƿ���}
var
  qry:TADOQuery;
  roomPlan:TCallRoomPlan;
  manPlan:TCallManPlan;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Plan_CallMan where eCallPlanState >= :eStartState'
      + ' and eCallPlanState <= :eEndState order by dtCallTime ASC, strTrainmanGUID DESC,strRoomNum asc';
    qry.Parameters.ParamByName('eStartState').value := eStartState;
    qry.Parameters.ParamByName('eEndState').value := eEndState;
    qry.Open;
    while not qry.Eof do
    begin
      manPlan := TCallManPlan.Create;
      Self.Qry2Obj(qry,manPlan);
      roomPlan := roomPlanList.FindByRoomTrainNo(manPlan.strRoomNum,manPlan.strTrainNo);
      if roomPlan = nil then
      begin
        roomPlan := TCallRoomPlan.Create;
        roomPlan.Init(manPlan);
        roomPlanList.Add(roomPlan);
      end;
      roomPlan.manList.Add(manPlan);
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

function TDBCallManPlan.ModifyManPlan(manPlan: TCallManPlan): Boolean;
var
  qry:TADOQuery;
begin
  result := False;
  qry:=NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_plan_CallMan where strCallPlanGUID =:strGUID';
    qry.Parameters.ParamByName('strGUID').Value := manPlan.strGUID;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    qry.Edit;
    self.Obj2Qry(manPlan,qry);
    qry.Post;
  finally
    qry.Free;
  end;
end;

function TDBCallManPlan.ModifyManPlan(manPlan: TCallManPlan;
  strWaitPlanGUID,strRoomNumber:string): Boolean;
var
  qry:TADOQuery;
begin
  result := False;
  qry:=NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_plan_CallMan where '+
      'strWaitPlanGUID =:strWaitPlanGUID and strRoomNum=:strRoomNum';
    qry.Parameters.ParamByName('strWaitPlanGUID').Value := strWaitPlanGUID;
    qry.Parameters.ParamByName('strRoomNum').Value := strRoomNumber;
    qry.Open;
    if qry.RecordCount = 0 then
    begin
      qry.Append ;
      manPlan.strGUID := NewGUID ;
    end
    else
    begin
      manPlan.strGUID := qry.FieldByName('strCallPlanGUID').AsString;
      qry.Edit;
    end;
    self.Obj2Qry(manPlan,qry);
    qry.Post;
  finally
    qry.Free;
  end;
end;

procedure TDBCallManPlan.ModifyRoom(strWaitPlanGUID, strTrainmanGUID,
  strRoomNumber: string);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_plan_Callman where strWaitPlanGUID = :strWaitPlanGUID'
      + ' and strTrainmanGUID = :strTrainmanGUID';
    qry.Parameters.ParamByName('strWaitPlanGUID').Value := strWaitPlanGUID;
    qry.Parameters.ParamByName('strTrainmanGUID').Value := strTrainmanGUID;
    qry.Open;
    if qry.RecordCount >0 then
    begin
      qry.Edit;
      qry.FieldByName('strRoomNum').Value := strRoomNumber;
      qry.Post;
    end;

  finally
    qry.Free;
  end;
end;

function TDBCallManPlan.ModifyRoomPlan(RoomPlan: TCallRoomPlan): Boolean;
var
  i:Integer;
  qry:TADOQuery;
begin
  result := false ;
  qry := NewADOQuery;
  Self.GetADOConnection.BeginTrans;
  try
    try
      for i := 0 to RoomPlan.manList.Count - 1 do
      begin
        ModifyManPlan(RoomPlan.manList.Items[i]);
      end;
      self.GetADOConnection.CommitTrans;
      result := true;
    except on e:Exception do
      self.GetADOConnection.RollbackTrans;
    end;
  finally
    qry.Free;
  end ;
end;

class procedure TDBCallManPlan.Obj2Qry(obj: TCallManPlan; qry: TADOQuery);
begin
  qry.FieldByName('strCallPlanGUID').Value := obj.strGUID;
  qry.FieldByName('strWaitPlanGUID').Value := obj.strWaitPlanGUID;
  qry.FieldByName('strTrainPlanGUID').Value := obj.strTrainPlanGUID;
  qry.FieldByName('strTrainNo').Value := obj.strTrainNo;
  qry.FieldByName('dtCallTime').Value := obj.dtCallTime;
  qry.FieldByName('dtChuQinTime').Value := obj.dtChuQinTime;
  qry.FieldByName('strTrainmanGUID').Value := obj.strTrainmanGUID;
  qry.FieldByName('strTrainmanNumber').Value := obj.strTrainmanNumber;
  qry.FieldByName('strTrainmanName').Value := obj.strTrainmanName;
  qry.FieldByName('strRoomNum').Value := obj.strRoomNum;

  qry.FieldByName('dtFirstCallTime').Value := obj.dtFirstCallTime;
  qry.FieldByName('dtRecallTime').Value := obj.dtRecallTime;

  qry.FieldByName('eCallPlanState').Value := obj.ePlanState;

  qry.FieldByName('eFirstCallResult').Value := Ord(obj.eFirstCallResult);
  qry.FieldByName('nFirstCallTryTimes').Value := obj.nFirstCallTimes;

  qry.FieldByName('eReCallResult').Value := Ord( obj.eReCallResult);
  qry.FieldByName('nReCallTryTimes').Value := obj.nReCallTimes;


  qry.FieldByName('dtServerRoomCallTime').Value := obj.dtServerRoomCallTime;
  qry.FieldByName('nServerRoomCallTryTimes').Value := obj.nServerRoomCallTryTimes;
  qry.FieldByName('eServerRoomCallResult').Value := Ord(  obj.eServerRoomCallResult );

  //���з���
  qry.FieldByName('strJoinRooms').Value := obj.JoinRoomList.CommaText;
end;

class procedure TDBCallManPlan.Qry2Obj(qry: TADOQuery; var obj: TCallManPlan);
begin
  obj.strGUID := qry.FieldByName('strCallPlanGUID').Value;
  obj.strWaitPlanGUID := qry.FieldByName('strWaitPlanGUID').Value;
  obj.strTrainPlanGUID := qry.FieldByName('strTrainPlanGUID').Value;
  obj.strTrainNo := qry.FieldByName('strTrainNo').Value;
  obj.dtCallTime := qry.FieldByName('dtCallTime').Value;
  obj.dtChuQinTime := qry.FieldByName('dtChuQinTime').Value;
  obj.strTrainmanGUID := qry.FieldByName('strTrainmanGUID').Value;
  obj.strTrainmanNumber := qry.FieldByName('strTrainmanNumber').Value;
  obj.strTrainmanName := qry.FieldByName('strTrainmanName').Value;
  obj.strRoomNum := qry.FieldByName('strRoomNum').Value;
  obj.dtFirstCallTime := qry.FieldByName('dtFirstCallTime').Value;
  obj.dtRecallTime := qry.FieldByName('dtRecallTime').Value;


  if VarIsNull( qry.FieldByName('eCallPlanState').Value ) then
    obj.ePlanState := TCS_Publish
  else
    obj.ePlanState := qry.FieldByName('eCallPlanState').Value;


  if VarIsNull( qry.FieldByName('eFirstCallResult').Value ) then
    obj.eFirstCallResult := TR_NONE
  else
    obj.eFirstCallResult := TRoomCallResult(qry.FieldByName('eFirstCallResult').Value);


  if VarIsNull( qry.FieldByName('nFirstCallTryTimes').Value ) then
    obj.nFirstCallTimes :=  0
  else
    obj.nFirstCallTimes := qry.FieldByName('nFirstCallTryTimes').Value;

  if VarIsNull( qry.FieldByName('eReCallResult').Value ) then
    obj.eReCallResult := TR_NONE
  else
    obj.eReCallResult := TRoomCallResult(qry.FieldByName('eReCallResult').Value);


  if VarIsNull( qry.FieldByName('nReCallTryTimes').Value ) then
    obj.nReCallTimes := 0
  else
    obj.nReCallTimes := qry.FieldByName('nReCallTryTimes').Value;


  //�����ķ����Һ��в���
  if VarIsNull( qry.FieldByName('dtServerRoomCallTime').Value ) then
    obj.dtServerRoomCallTime := 0
  else
    obj.dtServerRoomCallTime := qry.FieldByName('dtServerRoomCallTime').Value;

  if VarIsNull( qry.FieldByName('nServerRoomCallTryTimes').Value ) then
    obj.nServerRoomCallTryTimes := 0
  else
    obj.nServerRoomCallTryTimes := qry.FieldByName('nServerRoomCallTryTimes').Value;


  if VarIsNull( qry.FieldByName('eServerRoomCallResult').Value ) then
    obj.eServerRoomCallResult := TR_NONE
  else
    obj.eServerRoomCallResult := TRoomCallResult(qry.FieldByName('eServerRoomCallResult').Value);



  obj.JoinRoomList.CommaText := qry.FieldByName('strJoinRooms').Value;

end;

procedure TDBCallManPlan.UpdateFirstCallTime(strCallPlanGUID:string;dtTime: TDateTime);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Plan_Callman where strCallPlanGUID =:strCallPlanGUID';
    qry.Parameters.ParamByName('strCallPlanGUID').Value := strCallPlanGUID;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    qry.Edit;
    qry.FieldByName('eCallPlanState').Value := TCS_FIRSTCALL ;
    qry.FieldByName('dtFirstCallTime').Value := dtTime;
    qry.Post;
  finally
    qry.Free;
  end;
end;
procedure TDBCallManPlan.UpdateFirstCallResult(callmanRecord:TCallManRecord);
var
  qry:TADOQuery;
  nTryTimes:Integer;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Plan_Callman where strCallPlanGUID =:strCallPlanGUID';
    qry.Parameters.ParamByName('strCallPlanGUID').Value := callmanRecord.strCallManPlanGUID;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    nTryTimes := qry.FieldByName('nFirstCallTryTimes').AsInteger;
    Inc(nTryTimes);
    qry.Edit;
    qry.FieldByName('eCallPlanState').Value := TCS_FIRSTCALL ;
    qry.FieldByName('dtFirstCallTime').Value := callmanRecord.dtCreateTime;
    qry.FieldByName('nFirstCallTryTimes').Value := nTryTimes;
    qry.FieldByName('eFirstCallResult').Value := callmanRecord.eCallResult ;
    qry.Post;
  finally
    qry.Free;
  end;
end;
procedure TDBCallManPlan.UpdateReCallResult(callmanRecord:TCallManRecord);
var
  qry:TADOQuery;
  nTryTimes:Integer;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Plan_Callman where strCallPlanGUID =:strCallPlanGUID';
    qry.Parameters.ParamByName('strCallPlanGUID').Value := callmanRecord.strCallManPlanGUID;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    nTryTimes := qry.FieldByName('nReCallTryTimes').AsInteger;
    Inc(nTryTimes);
    qry.Edit;
    qry.FieldByName('eCallPlanState').Value := TCS_RECALL ;
    qry.FieldByName('dtRecallTime').Value := callmanRecord.dtCreateTime;
    qry.FieldByName('nReCallTryTimes').Value := nTryTimes;
    qry.FieldByName('eReCallResult').Value := callmanRecord.eCallResult ;
    qry.Post;
  finally
    qry.Free;
  end;
end;

procedure TDBCallManPlan.UpdateReCallTime(strCallPlanGUID:string;dtTime: TDateTime);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Plan_Callman where strCallPlanGUID =:strCallPlanGUID';
    qry.Parameters.ParamByName('strCallPlanGUID').Value := strCallPlanGUID;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    qry.Edit;
    qry.FieldByName('eCallPlanState').Value := TCS_RECALL ;
    qry.FieldByName('dtRecallTime').Value := dtTime;
    qry.Post;
  finally
    qry.Free;
  end; 
end;

procedure TDBCallManPlan.UpdateServerRoomCallResult(
  callmanRecord: TCallManRecord);
var
  qry:TADOQuery;
  nTryTimes:Integer;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Plan_Callman where strCallPlanGUID =:strCallPlanGUID';
    qry.Parameters.ParamByName('strCallPlanGUID').Value := callmanRecord.strCallManPlanGUID;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    nTryTimes := qry.FieldByName('nServerRoomCallTryTimes').AsInteger;
    Inc(nTryTimes);
    qry.Edit;
    qry.FieldByName('eCallPlanState').Value := TCS_SERVER_ROOM_CALL ;
    qry.FieldByName('dtServerRoomCallTime').Value := callmanRecord.dtCreateTime;
    qry.FieldByName('nServerRoomCallTryTimes').Value := nTryTimes;
    qry.FieldByName('eServerRoomCallResult').Value := callmanRecord.eCallResult ;
    qry.Post;
  finally
    qry.Free;
  end;
end;

{ TDBCallVoice }

procedure TDBCallVoice.Add(CallVoice: TCallVoice);
var
  qry:TADOQuery;
begin
  qry:= NewADOQuery;
  qry.SQL.Text := 'select * from Tab_Record_CallVoice where 1<>1';
  try
    qry.Open;
    qry.Append;
    self.Obj2Qry(CallVoice,qry);
    qry.Post;
  finally
    qry.Free;
  end;

end;

function TDBCallVoice.Find(strCallVoiceGUID: string;
  var CallVoice: TCallVoice): Boolean;
var
  qry:TADOQuery;
begin
  result := False;
  qry:= NewADOQuery;
  qry.SQL.Text := 'select * from Tab_Record_CallVoice where strCallVoiceGUID =:strCallVoiceGUID';
  try
    qry.Parameters.ParamByName('strCallVoiceGUID').Value := strCallVoiceGUID;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    self.Qry2Obj(qry,CallVoice);
    result := True;
  finally
    qry.Free;
  end;


end;



function TDBCallVoice.ModifyVicePath(strCallVoiceGUID,
  FilePath: string): Boolean;
var
  n : Integer ;
  strFilePath:string;
  strFilePathName:string;
  qry:TADOQuery;
begin
  result := False;
  qry:= NewADOQuery;
  qry.SQL.Text := 'select strFilePathName from Tab_Record_CallVoice where strCallVoiceGUID =:strCallVoiceGUID';
  try
    qry.Parameters.ParamByName('strCallVoiceGUID').Value := strCallVoiceGUID;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    strFilePathName := qry.FieldByName('strFilePathName').AsString;
    n := Pos('CallVoice\',strFilePathName);
    strFilePath := Copy(strFilePathName,n,Length(strFilePathName)-n+1 );
    qry.Edit;
    qry.FieldByName('strFilePathName').AsString := FilePath + strFilePath ;
    qry.Post;
    result := True;
  finally
    qry.Free;
  end;
end;

procedure TDBCallVoice.Obj2Qry(Obj: TCallVoice; qry: TADOQuery);
begin
   qry.FieldByName('strCallVoiceGUID').Value := Obj.strCallVoiceGUID;
   qry.FieldByName('strFilePathName').Value := Obj.strFilePathName;
   Obj.vms.SaveToFile(Obj.strFilePathName);
   //Obj.vms.SaveToFile('d:\1.wav');
   //TBlobField(qry.FieldByName('msVoice')).LoadFromStream(Obj.vms);
   qry.FieldByName('dtCreateTime').Value := Obj.dtCreateTime;

end;

procedure TDBCallVoice.Qry2Obj(qry: TADOQuery; var obj: TCallVoice);
begin
  Obj.strCallVoiceGUID := qry.FieldByName('strCallVoiceGUID').Value;
  Obj.dtCreateTime := qry.FieldByName('dtCreateTime').Value ;
  obj.strFilePathName := qry.FieldByName('strFilePathName').Value;
  if FileExists(obj.strFilePathName) then
  begin
    if not Assigned(obj.vms)  then
      obj.vms := TMemoryStream.Create;
    obj.vms.LoadFromFile(obj.strFilePathName);
  end;
  
  {if not qry.FieldByName('msVoice').IsNull then
  begin
    TBlobField(qry.FieldByName('msVoice')).SaveToStream(Obj.vms);
  end; }
end;

{ TDBServerRomDev }

procedure TDBServerRomDev.Add(dev: RCallDev);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from Tab_Base_ServerRoom';
    qry.Open;
    qry.Append;
    self.Obj2Query(dev,qry);
    qry.Post;
  finally
    qry.free;
  end;
end;

procedure TDBServerRomDev.AddSleepRoom(ServerRoomRelation: RServerRoomRelation);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from Tab_ServerRoom_Relation';
    qry.Open;
    qry.Append;
    self.Obj2Query_2(ServerRoomRelation,qry);
    qry.Post;
  finally
    qry.free;
  end;
end;

procedure TDBServerRomDev.Delete(strGUID: string);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'delete  from Tab_Base_ServerRoom where strGUID =:strGUID';
    qry.Parameters.ParamByName('strGUID').Value := strGUID;
    qry.ExecSQL;
  finally
    qry.free;
  end;
end;

procedure TDBServerRomDev.DeleteSleepRoom(strGUID: string);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'delete  from Tab_ServerRoom_Relation where strGUID =:strGUID';
    qry.Parameters.ParamByName('strGUID').Value := strGUID;
    qry.ExecSQL;
  finally
    qry.free;
  end;
end;

function TDBServerRomDev.FindByDev(nDevNum: Integer;
  out dev: RCallDev): Boolean;
var
  qry:TADOQuery;
begin
  Result := False;
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'select * from Tab_Base_ServerRoom where nDevNum =:nDevNum';
    qry.Parameters.ParamByName('nDevNum').Value := nDevNum;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    self.Query2Obj(qry,dev);
    Result := True;
  finally
    qry.Free;
  end;
end;

function TDBServerRomDev.FindByRoom(strRoomNum: string;
  out dev: RCallDev): Boolean;
var
  qry:TADOQuery;
begin
  Result := False;
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'select * from Tab_Base_ServerRoom where strRoomNum =:strRoomNum';
    qry.Parameters.ParamByName('strRoomNum').Value := strRoomNum;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    self.Query2Obj(qry,dev);
    Result := True;
  finally
    qry.Free;
  end;
end;

procedure TDBServerRomDev.GetAll(out devAry: TCallDevAry);
var
  qry:TADOQuery;
  i:Integer;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select *  from Tab_Base_ServerRoom ORDER BY strRoomNum';
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    SetLength(devAry,qry.RecordCount);
    for i := 0 to qry.RecordCount - 1 do
    begin
      Self.Query2Obj(qry,devAry[i]);
      qry.Next;
    end;
  finally
    qry.free;
  end;
end;

procedure TDBServerRomDev.GetAllSleepRoom(Number:string;
  out ServerRoomRelationAry: TServerRoomRelationAry);
var
  qry:TADOQuery;
  i:Integer;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select *  from Tab_ServerRoom_Relation where strNumber =:strNumber ORDER BY strRoomNum';
    qry.Parameters.ParamByName('strNumber').Value := Number;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    SetLength(ServerRoomRelationAry,qry.RecordCount);
    for i := 0 to qry.RecordCount - 1 do
    begin
      Self.Query2Obj_2(qry,ServerRoomRelationAry[i]);
      qry.Next;
    end;
  finally
    qry.free;
  end;
end;

function TDBServerRomDev.IsExistSleepRoom(SleepRoomNumber: string;out Number:string): boolean;
var
  qry:TADOQuery;
begin
  Result := False;
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'select top 1 * from Tab_ServerRoom_Relation where  strRoomNum =:strRoomNum  ';
    qry.Parameters.ParamByName('strRoomNum').Value := SleepRoomNumber;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    Number := qry.FieldByName('strNumber').AsString;
    Result := True ;
  finally
    qry.Free;
  end;
end;

procedure TDBServerRomDev.Modify(dev: RCallDev);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select *  from Tab_Base_ServerRoom where strGUID =:strGUID';
    qry.Parameters.ParamByName('strGUID').Value := dev.strGUID;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    qry.Edit;
    self.Obj2Query(dev,qry);
    qry.Post;
  finally
    qry.free;
  end;
end;

procedure TDBServerRomDev.ModifySleepRoom(
  ServerRoomRelation: RServerRoomRelation);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select *  from Tab_ServerRoom_Relation where strGUID =:strGUID';
    qry.Parameters.ParamByName('strGUID').Value := ServerRoomRelation.strGUID;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    qry.Edit;
    self.Obj2Query_2(ServerRoomRelation,qry);
    qry.Post;
  finally
    qry.free;
  end;
end;

procedure TDBServerRomDev.Obj2Query(dev: RCallDev; query: TADOQuery);
begin
  query.FieldByName('strGUID').value := dev.strGUID;
  query.FieldByName('strRoomNum').value := dev.strRoomNum;
  query.FieldByName('nDevNum').value := dev.nDevNum;
end;

procedure TDBServerRomDev.Obj2Query_2(ServerRoomRelation:RServerRoomRelation; query: TADOQuery);
begin
  query.FieldByName('strGUID').value := ServerRoomRelation.strGUID;
  query.FieldByName('strRoomNum').value := ServerRoomRelation.strRoomNum;
  query.FieldByName('strNumber').value := ServerRoomRelation.strNumber;
end;

procedure TDBServerRomDev.Query2Obj(query: TADOQuery; var dev: RCallDev);
begin
  dev.strGUID := query.FieldByName('strGUID').value;
  dev.strRoomNum := query.FieldByName('strRoomNum').value;
  dev.nDevNum := query.FieldByName('nDevNum').value;
end;

procedure TDBServerRomDev.Query2Obj_2(query: TADOQuery; var ServerRoomRelation:RServerRoomRelation);
begin
  ServerRoomRelation.strGUID := query.FieldByName('strGUID').value;
  ServerRoomRelation.strRoomNum := query.FieldByName('strRoomNum').value;
  ServerRoomRelation.strNumber := query.FieldByName('strNumber').value;
end;

function TDBServerRomDev.QueryRooms(strRoomNum: string;
  out devAry: TCallDevAry): Boolean;
var
  qry:TADOQuery;
  i : integer ;
begin
  Result := False;
  qry:= NewADOQuery;
  try
    if strRoomNum = '' then
      qry.SQL.Text := 'select * from Tab_Base_ServerRoom ORDER BY strRoomNum'
    else
      qry.SQL.Text := 'select * from Tab_Base_ServerRoom where strRoomNum  like ' + QuotedStr(strRoomNum + '%') +' ORDER BY strRoomNum';
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    SetLength(devAry,qry.RecordCount);
    for i := 0 to qry.RecordCount - 1 do
    begin
      Self.Query2Obj(qry,devAry[i]);
      qry.Next;
    end;

    Result := True;
  finally
    qry.Free;
  end;
end;

function TDBServerRomDev.QueryServerNumber(RoomNumber: string;
  out ServerRoomNumber: string): boolean;
var
  qry:TADOQuery;
begin
  Result := False;
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'select top 1 * from Tab_ServerRoom_Relation where strRoomNum =:strRoomNum';
    qry.Parameters.ParamByName('strRoomNum').Value := RoomNumber;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    ServerRoomNumber := qry.FieldByName('strNumber').AsString;
    Result := True;
  finally
    qry.Free;
  end;
end;

end.
