unit uDBSignPlan;

interface
uses
  Classes,SysUtils,uTFSystem,ADODB,uSignPlan,uSaftyEnum;
type
  TDBSignPlan = class(TDBOperate)
    //��ȡǩ��ƻ�
    function GetSignPlan(strPlanGUID:string;signPlan:TSignPlan):Boolean;
    //ado2����
    procedure Ado2Obj(qry:TADOQuery;signPlan:TSignPlan);
  end;

implementation

{ TDBSignPlan }

procedure TDBSignPlan.Ado2Obj(qry: TADOQuery; signPlan: TSignPlan);
begin
  with signPlan do
  begin
    strGUID:= qry.FieldByName('strGUID').Value;
    //�ƻ�״̬
    eState:= TRsPlanState(qry.FieldByName('eState').Value);
    //ǩ��ʱ��
    dtSignTime:= qry.FieldByName('dtSignTime').Value;
    //��·GUID
    strTrainJiaoLuGUID:= qry.FieldByName('strTrainJiaoLuGUID').Value;
    strTrainJiaoLuName := qry.FieldByName('strTrainJiaoLuName').Value;
    //�Ƿ�ǩ��
    nNeedRest := qry.FieldByName('nNeedRest').Value;
    //����ʱ��
    dtArriveTime:= qry.FieldByName('dtArriveTime').Value;
    //�а�ʱ��
    dtCallTime:= qry.FieldByName('dtCallTime').Value;
    //����
    strTrainNo:= qry.FieldByName('strTrainNo').Value;
    //  �ƻ�����ʱ��
    dtChuQinTime:= qry.FieldByName('dtChuQinTime').Value;
    // �ƻ�����ʱ��
    dtStartTrainTime:= qry.FieldByName('dtStartTrainTime').Value;
    //ͼ������id
    strTrainNoGUID:= qry.FieldByName('strTrainNoGUID').Value;
    //����GUID
    strWorkGrouGUID:= qry.FieldByName('strWorkGrouGUID').Value;
    //˾��1
    strTrainmanGUID1:= qry.FieldByName('strTrainmanGUID1').Value;
    strTrainmanName1:= qry.FieldByName('strTrainmanName1').Value;
    strTrainmanNumber1:= qry.FieldByName('strTrainmanNumber1').Value;
    //˾��2
    strTrainmanGUID2:= qry.FieldByName('strTrainmanGUID2').Value;
    strTrainmanName2:= qry.FieldByName('strTrainmanName2').Value;
    strTrainmanNumber2:= qry.FieldByName('strTrainmanNumber2').Value;
    //˾��3
    strTrainmanGUID3:= qry.FieldByName('strTrainmanGUID3').Value;
    strTrainmanName3:= qry.FieldByName('strTrainmanName3').Value;
    strTrainmanNumber3:= qry.FieldByName('strTrainmanNumber3').Value;
    //˾��4
    strTrainmanGUID4:= qry.FieldByName('strTrainmanGUID4').Value;
    strTrainmanName4:= qry.FieldByName('strTrainmanName4').Value;
    strTrainmanNumber4:= qry.FieldByName('strTrainmanNumber4').Value;
    //�ɰ����
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
