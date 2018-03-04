unit uLCSignPlan;

interface

uses
  SysUtils,Classes,uTrainman,superobject,uBaseWebInterface,uSaftyEnum,
    uApparatusCommon,uTrainmanJiaolu,uSignPlan;

type

  TRSLCSignPlan = class(TBaseWebInterface)
  {功能:增加签点计划}
  function AddSignPlan(signPlan:TSignPlan;var strErrMsg:string):Boolean;
  {功能:修改签点计划}
  function ModifySignPlan(signPlan:TSignPlan;var strErrMsg:string):Boolean;
  {功能:删除签点计划}
  function DelSignPlan(signPlan:TSignPlan;var strErrMsg:string):Boolean;
  {功能:获取签点计划}
  function GetSignPlan(dtStart,dtEnd:TDateTime;var signPlanJiaolu:TSignPlanJiaoLu;var strErrMsg:string):Boolean;
  {功能:签点}
  function Sign(signPlan:TSignPlan;var strErrMsg:string):Boolean;
  {功能:修改人员}
  function ModifyTrainman(signModifyTrainman:TSignModifyTrainman;var strErrMsg:string):Boolean;
  {功能:获取签点计划,根据交路GUID列表}
  function GetSignPlan_ByJiaoLuAry(dtStart,dtEnd:TDateTime;jiaoluGUIDList:TStringList;var signPlanList:TSignPlanList;var strErrMsg:string):Boolean;


  end;

implementation

{ TRSLCSignPlan }

function TRSLCSignPlan.AddSignPlan(signPlan: TSignPlan;
  var strErrMsg: string): Boolean;
var
  json,iJsonPlan: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;

  iJsonPlan := SO('{}');
  signPlan.ToJson(iJsonPlan);
  json.o['data.SignPlan'] := iJsonPlan;
  strResult := Post('AddSignPlan',json.AsString,strErrMsg);
  json.Clear();
  if not GetJsonResult(strResult,json,strErrMsg) then Exit;
  Result := True;
end;

function TRSLCSignPlan.DelSignPlan(signPlan: TSignPlan;
  var strErrMsg: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['data.strGUID'] := signPlan.strGUID;
  strResult := Post('delsignplan',json.AsString,strErrMsg);
  json.Clear();
  if not GetJsonResult(strResult,json,strErrMsg) then Exit;
  Result := True;
end;

function TRSLCSignPlan.GetSignPlan(dtStart, dtEnd: TDateTime;
  var signPlanJiaolu: TSignPlanJiaoLu;var strErrMsg:string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;

  json := CreateInputJson;
  json.s['data.dtStartTime'] := FormatDateTime('yyyy-mm-dd hh:mm:ss',dtStart);
  json.S['data.dtEndTime'] := FormatDateTime('yyyy-mm-dd hh:mm:ss',dtEnd);
  json.S['data.strJiaoluGUID'] := signPlanJiaolu.strTrainJiaoLuGUID;
  strResult := Post('GetSignPlanList',json.AsString,strErrMsg);
  json.Clear();
  if not GetJsonResult(strResult,json,strErrMsg) then Exit;

  signPlanJiaolu.FromJson(json);
  Result := True;
end;


function TRSLCSignPlan.GetSignPlan_ByJiaoLuAry(dtStart, dtEnd: TDateTime;
  jiaoluGUIDList: TStringList; var signPlanList: TSignPlanList;var strErrMsg:string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
  jsJiaoLu:ISuperObject;
  i:Integer;
begin
  Result := False ;

  json := CreateInputJson;
  json.o['JiaoLuAry'] := so('[]');
  for i := 0 to jiaoluGUIDList.Count - 1 do
  begin
    jsJiaoLu := so('{}');
    jsJiaoLu.S['strTrainJiaoLuGUID']:= jiaoluGUIDList.Strings[i];
    json.A['JiaoLuAry'].Add(jsJiaoLu);
  end;
  json.s['dtStartTime'] := FormatDateTime('yyyy-mm-dd hh:mm:ss',dtStart);
  json.S['dtEndTime'] := FormatDateTime('yyyy-mm-dd hh:mm:ss',dtEnd);
  
  strResult := Post('TF.RunSafty.bll.SignPlan.Getsignplanlistbyjiaoluary',json.AsString,strErrMsg);
  if strErrMsg <> ''  then
  begin
    Exit;
  end;
  json.Clear();
//  stringList := TStringList.Create;
//  stringList.Add(strResult);
//  stringList.SaveToFile('d:\jsonTxt.txt');

  if not GetJsonResult(strResult,json,strErrMsg) then Exit;

  signPlanList.FromJson(json.O['signplanary']);
  Result := True;
end;

function TRSLCSignPlan.ModifySignPlan(signPlan: TSignPlan;
  var strErrMsg: string): Boolean;
var
  json,iJsonPlan: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  iJsonPlan := SO('{}');
  signPlan.ToJson(iJsonPlan);
  json.o['data.SignPlan'] := iJsonPlan;
  strResult := Post('EditSignPlan',json.AsString,strErrMsg);
  json.Clear();
  if not GetJsonResult(strResult,json,strErrMsg) then Exit;
  Result := True;
end;

function TRSLCSignPlan.ModifyTrainman( signModifyTrainman:TSignModifyTrainman;var strErrMsg:string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
  iJson:ISuperObject;
begin
  Result := False ;
  json := CreateInputJson;
  iJson := so();
  signModifyTrainman.ToJson(iJson);
  json.O['data'] := iJson;
  strResult := Post('ModifySignPlanTrainman',json.AsString,strErrMsg);
  json.Clear();
  iJson := nil;
  if not GetJsonResult(strResult,json,strErrMsg) then Exit;
  Result := True;
end;

function TRSLCSignPlan.Sign(signPlan: TSignPlan;var strErrMsg:string): Boolean;
var
  json: ISuperObject;
  strResult: string ;
  iJson:ISuperObject;
begin
  Result := False ;
  json := CreateInputJson;
  iJson :=so();
  signPlan.ToJson(iJson);
  json.O['data'] := iJson;
  strResult := Post('ModifySignPlan',json.AsString,strErrMsg);
  json.Clear();
  iJson :=nil;
  if not GetJsonResult(strResult,json,strErrMsg) then Exit;
  Result := True;
end;

end.
