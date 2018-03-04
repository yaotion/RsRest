unit uDBSignPlan;

interface
uses
  Classes,SysUtils,uTFSystem,ADODB,uSignPlan,uSaftyEnum;
type
  TDBSignPlan = class(TDBOperate)
    //获取签点计划
    function GetSignPlan(strPlanGUID:string;signPlan:TSignPlan):Boolean;
    //ado2对象
    procedure Ado2Obj(qry:TADOQuery;signPlan:TSignPlan);
  end;

implementation

{ TDBSignPlan }

procedure TDBSignPlan.Ado2Obj(qry: TADOQuery; signPlan: TSignPlan);
begin
  with signPlan do
  begin
    strGUID:= qry.FieldByName('strGUID').Value;
    //计划状态
    eState:= TRsPlanState(qry.FieldByName('eState').Value);
    //签点时间
    dtSignTime:= qry.FieldByName('dtSignTime').Value;
    //交路GUID
    strTrainJiaoLuGUID:= qry.FieldByName('strTrainJiaoLuGUID').Value;
    strTrainJiaoLuName := qry.FieldByName('strTrainJiaoLuName').Value;
    //是否签点
    nNeedRest := qry.FieldByName('nNeedRest').Value;
    //待乘时间
    dtArriveTime:= qry.FieldByName('dtArriveTime').Value;
    //叫班时间
    dtCallTime:= qry.FieldByName('dtCallTime').Value;
    //车次
    strTrainNo:= qry.FieldByName('strTrainNo').Value;
    //  计划出勤时间
    dtChuQinTime:= qry.FieldByName('dtChuQinTime').Value;
    // 计划开车时间
    dtStartTrainTime:= qry.FieldByName('dtStartTrainTime').Value;
    //图钉车次id
    strTrainNoGUID:= qry.FieldByName('strTrainNoGUID').Value;
    //机组GUID
    strWorkGrouGUID:= qry.FieldByName('strWorkGrouGUID').Value;
    //司机1
    strTrainmanGUID1:= qry.FieldByName('strTrainmanGUID1').Value;
    strTrainmanName1:= qry.FieldByName('strTrainmanName1').Value;
    strTrainmanNumber1:= qry.FieldByName('strTrainmanNumber1').Value;
    //司机2
    strTrainmanGUID2:= qry.FieldByName('strTrainmanGUID2').Value;
    strTrainmanName2:= qry.FieldByName('strTrainmanName2').Value;
    strTrainmanNumber2:= qry.FieldByName('strTrainmanNumber2').Value;
    //司机3
    strTrainmanGUID3:= qry.FieldByName('strTrainmanGUID3').Value;
    strTrainmanName3:= qry.FieldByName('strTrainmanName3').Value;
    strTrainmanNumber3:= qry.FieldByName('strTrainmanNumber3').Value;
    //司机4
    strTrainmanGUID4:= qry.FieldByName('strTrainmanGUID4').Value;
    strTrainmanName4:= qry.FieldByName('strTrainmanName4').Value;
    strTrainmanNumber4:= qry.FieldByName('strTrainmanNumber4').Value;
    //派班结束
    nFinished:= qry.FieldByName('nFinished').Value;
  end;
end;

function TDBSignPlan.GetSignPlan(strPlanGUID: string;
  signPlan: TSignPlan): Boolean;
var
  qry:TADOQuery;
begin
  result := False;
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from   VIEW_Plan_Sign where strGUID = :strGUID';
    qry.Parameters.ParamByName('strGUID').Value := strPlanGUID;
    qry.Open;
    if qry.Eof then Exit;
    self.Ado2Obj(qry,signPlan);
    result := True;
  finally
    qry.Free;
  end;
end;

end.
