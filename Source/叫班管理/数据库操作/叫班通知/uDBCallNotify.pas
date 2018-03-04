unit uDBCallNotify;

interface
uses
  uTFSystem,Classes,SysUtils,uCallNotify,uSaftyEnum,ADODB;
type
  //////////////////////////////////////////////////////////////////////////////
  ///类名:TDBCallWork
  ///描述:叫班通知数据库操作
  //////////////////////////////////////////////////////////////////////////////
  TDBCallNotify = class(TDBOperate)
  public
    {功能:查找未取消的记录}
    function FindUnCancel(strTrainmanGUID,strTrainPlanGUID:string;out callNotify:RRsCallNotify):Boolean;
    {功能:增加单条记录}
    procedure Add(callWork:RRsCallNotify);overload;
    {功能:删除}
    function Delete(callWork:RRsCallNotify):Boolean;
    {功能:设置取消标识}
    procedure SetCancel(strGUID,strUser: string; dtCancelTime: TDateTime;
                  strReason: string);
    {功能:获取通知,按照状态范围}
    procedure GetByStateSec(out callWorkAry:TRSCallNotifyAry;
          startState,endState:TRsCallWorkState;dtStartSendTime:TDateTime;NotCancel:Boolean = True);
    {功能:接收通知}
    procedure SetRecv(GUIDAry: TStringArray;strUser:string;dtRecvTime:TDateTime);
  private
    procedure Obj2Qry(obj:RRsCallNotify;qry:TADOquery);
    procedure Qry2Obj(qry:TADOQuery;out obj:RRsCallNotify);

  end;
implementation
{ TDBCallWork }

procedure TDBCallNotify.Add(callWork: RRsCallNotify);
var
  qry:TADOQuery;
begin
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_MsgCallWork where strMsgGUID =:strMsgGUID';
    qry.Parameters.ParamByName('strMsgGUID').Value := callWork.strMsgGUID;
    qry.Open;
    qry.Append;
    self.Obj2Qry(callWork,qry);
    qry.Post;
  finally
    qry.Free;
  end;
end;


function TDBCallNotify.Delete(callWork: RRsCallNotify): Boolean;
var
  qry:TADOQuery;
begin
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'delete  from tab_MsgCallWork where strMsgGUID =:strMsgGUID';
    qry.Parameters.ParamByName('strMsgGUID').Value := callWork.strMsgGUID;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

function TDBCallNotify.FindUnCancel(strTrainmanGUID, strTrainPlanGUID: string;
  out callNotify: RRsCallNotify): Boolean;
var
  qry:TADOQuery;
begin
  result := False;
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from view_msgCallWork where strTrainmanGUID =:strTrainmanGUID '
      + ' and strTrainPlanGUID =:strTrainPlanGUID and nCancel = 0';
    qry.Parameters.ParamByName('strTrainmanGUID').Value := strTrainmanGUID;
    qry.Parameters.ParamByName('strTrainPlanGUID').Value := strTrainPlanGUID;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    Self.Qry2Obj(qry,callNotify);
    Result := True;
  finally
    qry.Free;
  end;
end;

procedure TDBCallNotify.GetByStateSec(out callWorkAry: TRSCallNotifyAry; startState,
  endState: TRsCallWorkState;dtStartSendTime:TDateTime;NotCancel:Boolean = True);
var
  qry:TADOQuery;
  i:Integer;
  strsql:string;
begin
  qry := NewADOQuery;
  try
    strsql := 'select * from View_msgCallWork where eCallState >=:startState '
      + ' and eCallState <=:endState and dtSendTime >= :dtStartSendTime ';
    if NotCancel = True then
      strsql := strsql + ' and nCancel = 0 ';
    strsql := strsql + '  order by eCallState,dtSendTime';
    qry.SQL.Text := strsql;
    qry.Parameters.ParamByName('startState').Value := startState;
    qry.Parameters.ParamByName('endState').Value := endState;
    qry.Parameters.ParamByName('dtStartSendTime').Value := dtStartSendTime;
    qry.Open;
    SetLength(callWorkAry,qry.RecordCount);
    for i := 0 to qry.RecordCount - 1 do
    begin
      Self.Qry2Obj(qry,callworkAry[i]);
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;


procedure TDBCallNotify.Obj2Qry(obj: RRsCallNotify; qry: TADOquery);
begin

  with obj do
  begin
    qry.FieldByName('strTrainPlanGUID').Value:= strTrainPlanGUID ;
    qry.FieldByName('strMsgGUID').Value:= strMsgGUID;
    qry.FieldByName('strTrainmanGUID').Value:= strTrainmanGUID;
    qry.FieldByName('strSendMsgContent').Value:= strSendMsgContent;
    qry.FieldByName('strRecvMsgContent').Value:= strRecvMsgContent;
    qry.FieldByName('dtSendTime').Value:= dtSendTime;
    qry.FieldByName('strSendUser').Value:= strSendUser;
    qry.FieldByName('dtRecvTime').Value:= dtRecvTime;
    qry.FieldByName('strRecvUser').Value:= strRecvUser ;
    qry.FieldByName('eCallState').Value:= ord(eCallState);
    qry.FieldByName('eCallType').Value:= Ord(eCallType) ;
    qry.FieldByName('nCancel').Value:= nCancel;
    qry.FieldByName('strCancelReason').Value:= strCancelReason;
    qry.FieldByName('dtCancelTime').Value:= dtCancelTime;
    qry.FieldByName('strCancelUser').Value:= strCancelUser ;
  end;


end;

procedure TDBCallNotify.Qry2Obj(qry: TADOQuery; out obj: RRsCallNotify);
begin
  with obj do
  begin
    strTrainPlanGUID:= qry.FieldByName('strTrainPlanGUID').Value ;
    strTrainNo:= qry.FieldByName('strTrainNo').Value;
    dtCallTime := qry.FieldByName('dtCallTime').Value;
    dtChuQinTime:= qry.FieldByName('dtStartTime').Value;
    dtStartTime:= qry.FieldByName('dtChuQinTime').Value ;
    strMsgGUID:= qry.FieldByName('strMsgGUID').Value;
    strSendMsgContent:= qry.FieldByName('strSendMsgContent').Value;
    strRecvMsgContent:= qry.FieldByName('strRecvMsgContent').Value;
    dtSendTime:= qry.FieldByName('dtSendTime').Value;
    strSendUser:= qry.FieldByName('strSendUser').Value;
    dtRecvTime:= qry.FieldByName('dtRecvTime').Value;
    strRecvUser:= qry.FieldByName('strRecvUser').Value ;
    eCallState:= TRSCallworkState(qry.FieldByName('eCallState').Value);
    eCallType:= TCallType(qry.FieldByName('eCallType').Value) ;
    nCancel:= qry.FieldByName('nCancel').Value;
    strCancelReason:= qry.FieldByName('strCancelReason').Value;
    dtCancelTime:= qry.FieldByName('dtCancelTime').Value;
    strCancelUser:= qry.FieldByName('strCancelUser').Value ;
    strTrainmanGUID:= qry.FieldByName('strTrainmanGUID').Value;
    strTrainmanNumber:= qry.FieldByName('strTrainmanNumber').Value;
    strTrainmanName:= qry.FieldByName('strTrainmanName').Value;
    strMobileNumber:= qry.FieldByName('strMobileNumber').Value;
  end;


  
end;

procedure TDBCallNotify.SetCancel(strGUID,strUser: string; dtCancelTime: TDateTime;
  strReason: string);
var
  qry:TADOQuery;
begin
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_MsgCallWork where strMsgGUID =:strMsgGUID';
    qry.Parameters.ParamByName('strMsgGUID').Value := strGUID;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    qry.Edit;
    qry.FieldByName('nCancel').Value := 1;
    qry.FieldByName('strCancelUser').Value := strUser;
    qry.FieldByName('dtCancelTime').Value := dtCancelTime;
    qry.FieldByName('strCancelReason').Value := strReason;
    qry.Post;
  finally
    qry.Free;
  end;
end;

procedure TDBCallNotify.SetRecv(GUIDAry: TStringArray; strUser: string;
  dtRecvTime: TDateTime);
var
  i:integer;
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    for i := 0 to Length(GUIDAry) -1 do
    begin
      qry.SQL.Text := 'select * from tab_msgCallWork where strMsgGUID =:strMsgGUID';
      qry.Parameters.ParamByName('strMsgGUID').Value := GUIDAry[i];
      qry.Open;
      if qry.RecordCount = 0 then Continue;
      qry.Edit;
      qry.fieldByName('eCallState').Value := cwsRecv;
      qry.FieldByName('strRecvUser').Value := strUser;
      qry.FieldByName('dtRecvTime').Value := dtRecvTime;
      qry.Post;
    end;
  finally
    qry.Free;
  end;
end;

end.
