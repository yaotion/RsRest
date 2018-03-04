unit uDBRoomCall;

interface
uses
  Classes,uTFSystem,ADODB,SysUtils,uRoomCall,uSaftyEnum,DB,StrUtils,Variants;
type
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TDBRoomDev
  /// 描述:公寓叫班设备操作
  //////////////////////////////////////////////////////////////////////////////
  TDBCallDev = class(TDBOperate)
  public
    {功能:增加设备}
    procedure Add(dev:RCallDev);
    {功能:修改设备}
    procedure Modify(dev:RCallDev);
    {功能:删除设备}
    procedure Delete(strGUID:string);
    {功能:获取所有设备}
    procedure GetAll(out devAry:TCallDevAry);
    {功能:根据房间编号查找}
    function FindByRoom(strRoomNum :string;out dev:RCallDev):Boolean;
    {功能:根据房间编号查找}
    function QueryRooms(strRoomNum :string;out devAry:TCallDevAry):Boolean;
    {功能:根据设备编号查找}
    function FindByDev(nDevNum:Integer;out dev:RCallDev):Boolean;
  private
    {功能:对象到query}
    procedure Obj2Query(dev:RCallDev;query:TADOQuery);
    {功能:query到对象}
    procedure Query2Obj(query:TADOQuery;var dev:RCallDev);
  end;



  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TDBServerRomDev
  /// 描述:服务室设备管理操作
  //////////////////////////////////////////////////////////////////////////////
  TDBServerRomDev = class(TDBOperate)
  public
    {功能:增加设备}
    procedure Add(dev:RCallDev);
    {功能:修改设备}
    procedure Modify(dev:RCallDev);
    {功能:删除设备}
    procedure Delete(strGUID:string);
    {功能:获取所有设备}
    procedure GetAll(out devAry:TCallDevAry);
    {功能:根据房间编号查找}
    function FindByRoom(strRoomNum :string;out dev:RCallDev):Boolean;
    {功能:根据房间编号查找}
    function QueryRooms(strRoomNum :string;out devAry:TCallDevAry):Boolean;
    {功能:根据设备编号查找}
    function FindByDev(nDevNum:Integer;out dev:RCallDev):Boolean;
  public
    {功能:增加一个下属}
    procedure AddSleepRoom(ServerRoomRelation:RServerRoomRelation);
    {功能:修改下属}
    procedure ModifySleepRoom(ServerRoomRelation:RServerRoomRelation);
    {功能:删除下属}
    procedure DeleteSleepRoom(strGUID:string);
    {功能：检查是否存在该下属}
    function IsExistSleepRoom(SleepRoomNumber:string;out Number:string):boolean;
    {功能:查找一个房间的服务室}
    function  QueryServerNumber(RoomNumber:string;out ServerRoomNumber:string):boolean;
    {功能:获取所有下属设备}
    procedure GetAllSleepRoom(Number:string;out ServerRoomRelationAry:TServerRoomRelationAry);
  private
    {功能:对象到query}
    procedure Obj2Query_2(ServerRoomRelation:RServerRoomRelation;query:TADOQuery);
    {功能:query到对象}
    procedure Query2Obj_2(query:TADOQuery;var ServerRoomRelation:RServerRoomRelation);
  private
    {功能:对象到query}
    procedure Obj2Query(dev:RCallDev;query:TADOQuery);
    {功能:query到对象}
    procedure Query2Obj(query:TADOQuery;var dev:RCallDev);
  end;
  
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TDBCallVoice
  /// 描述:公寓叫班语音数据库操作
  //////////////////////////////////////////////////////////////////////////////
  TDBCallVoice = class(TDBOperate)
  public
    {功能:增加}
    procedure Add(CallVoice:TCallVoice);
    {功能:查找语音记录}
    function Find(strCallVoiceGUID:string;var CallVoice:TCallVoice ) :Boolean;
    {功能:获取录音文件}
    //function GetVoiceFile(strGUID,strFilePathName:string):Boolean;
    function ModifyVicePath(strCallVoiceGUID,FilePath:string):Boolean;
  public
    {数据集到对象}
    procedure Qry2Obj(qry:TADOQuery;var obj:TCallVoice);
    {对象到数据集}
    procedure Obj2Qry(Obj:TCallVoice;qry:TADOQuery);
  end;


  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TDBCallRecord
  /// 描述:公寓叫班记录数据库操作
  //////////////////////////////////////////////////////////////////////////////
  TDBCallRecord = class(TDBOperate)
  public

    {功能:增加}
    procedure Add(callRecord:TCallManRecord) ; overload;
    {功能:增加房间叫班记录}
    procedure Add(CallRoomRecord:TCallRoomRecord); overload;
    {功能:查询叫班记录}
    procedure qryCallRecord(params:RCallQryParams;var CallManRecordList:TCallManRecordList);

  private
    {构造查询条件}
    procedure SetSearchQry(qry:TADOQuery;params:RCallQryParams);
    {数据集 赋值给 对象}
    procedure Query2Obj(qry:TADOQuery;var callRecord:TCallManRecord);
    {对象 赋值给 数据集}
    procedure Obj2Query(callRecord:TCallManRecord;qry:TADOQuery);
  end;


  //////////////////////////////////////////////////////////////////////////////
  ///类名:TDBCallManPlan
  ///描述:人员叫班计划
  //////////////////////////////////////////////////////////////////////////////
  TDBCallManPlan = class(TDBOperate)
  public
    {功能:按照行车计划和人员查找}
    function FindUnCall(strTrainPlanGUID,strTrainmanGUID:string;var callManPlan:TCallManPlan):Boolean;
    {功能:增加记录}
    procedure Add(manPlan:TCallManPlan);overload;
    {功能:增加多个记录}
    procedure Add(manPlanList:TCallManPlanList);overload;

    {功能:修改房间叫班计划}
    function ModifyRoomPlan(RoomPlan:TCallRoomPlan):Boolean;
    {功能:修改记录}
    function ModifyManPlan(manPlan:TCallManPlan):Boolean;overload;
    {功能:修改记录}
    function ModifyManPlan(manPlan:TCallManPlan;strWaitPlanGUID,strRoomNumber:string):Boolean;overload;
    {功能:修改房间}
    procedure ModifyRoom(strWaitPlanGUID,strTrainmanGUID,strRoomNumber:string);
    {功能:删除记录}
    procedure Del(manPlanGUID:string);
    {功能:根据待乘计划删除交班记录}
    procedure DelByWaitPlan(WaitPlanGUID:string);
    {功能:删除无人员的叫班计划}
    procedure Del_PlanAndRoomNumber(strWaitPlanGUID,strRoomNumber:string);
    {功能:删除叫班计划}
    procedure Del_PlanAndTMGUID(strWaitPlanGUID,strTrainmanGUID:string);
    {功能:获取房间待叫班计划列表}
    procedure GetRoomCallPlanList(var roomPlanList:TCallRoomPlanList;eStartState,eEndState:TRoomCallState);

    {功能:获取人员计划按照状态}
    procedure GetManPlanOfState(var manPlanList:TCallManPlanList;ePlanState:TRoomCallState);
    {功能:更新首叫时间}
    procedure UpdateFirstCallTime(strCallPlanGUID:string; dtTime:TDateTime);
    {功能:更改首叫结果}
    procedure UpdateFirstCallResult(callmanRecord:TCallManRecord);
    {功能:更新催叫时间}
    procedure UpdateReCallTime(strCallPlanGUID:string;dtTime:TDateTime);
    {功能:更改催叫结果}
    procedure UpdateReCallResult(callmanRecord:TCallManRecord);
    {功能:更改服务室叫结果}
    procedure UpdateServerRoomCallResult(callmanRecord:TCallManRecord);
    {功能:查找叫班计划}
    function Find(strWaitPlanGUID,strTrainmanGUID:string;callManPlan:TCallManPlan):Boolean;
    {功能:修改房间}
    procedure ChangeRoom(strWaitPlanGUID,strTrainmanGUID,strRoomNum:string);
    {功能:对象转换为数据集}
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
{按照时间，接下去是人员，最后是房间}
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

  //联叫房间
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


  //新增的服务室呼叫部分
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
