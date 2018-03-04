unit uLCTrainPlan;

interface

uses
  SysUtils,Dialogs,Windows,Classes,uTrainman,uTrainPlan,superobject,
  uBaseWebInterface,uSaftyEnum,uApparatusCommon,uTrainmanJiaolu;

type

  //JSON结构体
  RJsonObject = record
    strName : string ;
    strValue:string  ;
  end;

  TJsonObjectArray = array of  RJsonObject ;

  {
    //此部分JSON字符串由 左东亮定义
    }
  TRsLCTrainPlan = class(TBaseWebInterface)
  public
    //3.1.1	新建已编辑机车计划
    function AddTrainPlan(var ReceiveTrainPlan:RRsReceiveTrainPlan;out ErrStr:string):Boolean;
    //3.1.2	新建已接收机车计划
    function RecieveTrainPlan(var ReceiveTrainPlan:RRsReceiveTrainPlan;out ErrStr:string):Boolean;
    // 接收机车计划
    function RecvPlan(DutyUserGUID:string;out PlanList:TStrings;out ErrStr:string):Boolean;
  public
     //3.1.3	获取指定客户端在指定时间范围下的指定区段的人员计划
    function GetTrainmanPlanByJiaoLu(TrainjiaoluID:string;BeginTime,EndTime:TDateTime;out TrainmanPlanArray:TRsTrainmanPlanArray;out ErrStr:string):Boolean;
    //3.1.4	获取指定客户端在指定时间范围下的指定区段的已下发的人员计划
    function GetTrainmanPlanFromSent(TrainjiaoluID:string;BeginTime,EndTime:TDateTime;out TrainmanPlanArray:TRsTrainmanPlanArray;out ErrStr:string):Boolean;
    //3.1.6	获取指定客户端的出勤计划列表
    function  GetChuQinPlanByClient(BeginDate,EndDate:TDateTime;out ChuQinPlanArray:TRsChuQinPlanArray;out ErrStr:string):Boolean;
    //3.1.7	获取指定客户端的退勤计划列表
    function  GetTuiQinPlanByClient(BeginDate,EndDate:TDateTime; ShowAll : Integer;out TuiQinPlanArray:TRsTuiQinPlanArray;out ErrStr:string):Boolean;
    //3.1.8	获取指定人员在指定客户端下的出勤计划
    function  GetChuQinPlanByTrainman(TrainmanID:string;out ChuQinPlan:RRsChuQinPlan;out ErrStr:string):Boolean;
    //3.1.9	获取指定人员在指定客户端下的退勤计划
    function  GetTuiQinPlanByTrainman(TrainmanID:string;out TuiQinPlan:RRsTuiQinPlan;out ErrStr:string):Boolean;
   

    
    //删除计划
    function  DeleteTrainPlan(TrainPlan:string;out ErrStr:string):Boolean;
    //下发计划
    function  SendTrainPlan(PlanList:TStrings;DutyUserGUID:string;out ErrStr:string):Boolean;
    //撤销计划  IsSubPlan 是否是子计划
    function  CancelTrainPlan(PlanList:TStrings;DutyUserGUID:string;CanDeleteMainPlan:Integer;out ErrStr:string):Boolean;
    //编辑计划
    function  UpdateTrainPlan(ReceiveTrainPlan:RRsReceiveTrainPlan;JsonObjectArray:TJsonObjectArray;out ErrStr:string):Boolean;
    //从计划里面移除人员
    function  RemoveTrainman(TrainmanGUID:string;TrainmanPlanGUID:string;GroupGUID:string;TrainmanIndex:Integer;out ErrStr:string):Boolean;
    //从计划里面移除机组
    function  RemoveGroup(GroupGUID:string;TrainmanPlanGUID:string;out ErrStr:string):Boolean;
    //根据计划ID获取人员计划
    function GetTrainmanPlanByGUID(TrainPlanGUID:string;out TrainmanPlan:RRsTrainmanPlan;out ErrStr:string):Boolean;
    //根据计划ID获取人员计划
    function GetTrainmanPlanOfNeedRest(TrainPlanGUIDS:TStrings;out TrainmanPlanArray:TRsTrainmanPlanArray;out ErrStr:string):Boolean;
  private
    //公共部分
    function EditTrainPlan(var ReceiveTrainPlan:RRsReceiveTrainPlan;DataType:string;out ErrStr:string):Boolean;
    //获取TARINMANPLAN
    function GetTrainmanPlan(TrainjiaoluID:string;BeginTime,EndTime:TDateTime;out TrainmanPlanArray:TRsTrainmanPlanArray;DataType:string;out ErrStr:string):Boolean;
    //接受计划->json
    procedure ReceiveTrainPlanToJson(ReceiveTrainPlan:RRsReceiveTrainPlan;Json: ISuperObject);

    procedure JsonToChuQinData(var ChuQinPlan:RRsChuQinPlan;Json: ISuperObject);
    procedure JsonToTuiQinData(var TuiQinPlan:RRsTuiQinPlan;Json: ISuperObject);

    procedure JsonToAlcohol(var TestAlcoholInfo: RTestAlcoholInfo;Json: ISuperObject);
    //json->trainmanplan
    procedure JsonToTrainmanPlan(var TrainmanPlan:RRsTrainmanPlan;Json: ISuperObject);
    //json->trainplan
    procedure JsonToTrainPlan(var TrainPlan:RRsTrainPlan;Json: ISuperObject);
    //

    //planlist -> json
    procedure PlanListToJson(PlanList:TStrings;Json: ISuperObject);
  end;

implementation

{ TRsLCTrainPlans }



function TRsLCTrainPlan.AddTrainPlan(var ReceiveTrainPlan: RRsReceiveTrainPlan;
  out ErrStr: string): Boolean;
begin
  Result := EditTrainPlan(ReceiveTrainPlan,'TF.Runsafty.Plan.Train.Editable.Add',ErrStr);
end;


function TRsLCTrainPlan.CancelTrainPlan(PlanList: TStrings;DutyUserGUID:string;CanDeleteMainPlan:Integer;
  out ErrStr: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['DutyUserGUID'] := DutyUserGUID ;
  json.S['SiteGUID'] :=  m_strSiteID ;
  json.i['CanDeleteMainPlan'] := CanDeleteMainPlan ;
  PlanListToJson(PlanList,json);
  try
    strResult := Post('TF.Runsafty.Plan.LCTrainPlan.Cancel',json.AsString,ErrStr);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCTrainPlan.DeleteTrainPlan(TrainPlan: string;
  out ErrStr: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['strTrainPlanGUID'] := TrainPlan ;
  try
    strResult := Post('TF.Runsafty.Plan.LCTrainPlan.Delete',json.AsString,ErrStr);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCTrainPlan.UpdateTrainPlan(ReceiveTrainPlan:RRsReceiveTrainPlan;JsonObjectArray:TJsonObjectArray;out ErrStr:string):Boolean;
var
  json: ISuperObject;
  strResult : string ;
  strText:string;
  I: Integer;
begin
  Result := False ;
  json := CreateInputJson;
  Json.S['trainPlan.trainPlanGUID'] := ReceiveTrainPlan.TrainPlan.strTrainPlanGUID ;
  for I := 0 to Length(JsonObjectArray)- 1 do
  begin
    strText := Format('trainPlan.%s',[JsonObjectArray[i].strName]);
    json.S[strText] := JsonObjectArray[i].strValue ;
  end;

  with ReceiveTrainPlan do
  begin
    Json.S['user.userID'] := strUserID ;
    Json.S['user.userName'] := strUserName ;

    Json.S['site.siteID'] := strSiteID ;
    Json.S['site.siteName'] := strSiteName ;
  end;

  try
    strResult := Post('TF.Runsafty.Plan.LCTrainPlan.Update',json.AsString,ErrStr);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCTrainPlan.EditTrainPlan(var ReceiveTrainPlan: RRsReceiveTrainPlan;
  DataType: string; out ErrStr: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  ReceiveTrainPlanToJson(ReceiveTrainPlan,json);
  try
    strResult := Post(DataType,json.AsString,ErrStr);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;
    ReceiveTrainPlan.strPlanID := json.S['planID'] ;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;


function TRsLCTrainPlan.GetChuQinPlanByClient(BeginDate, EndDate: TDateTime;
  out ChuQinPlanArray:TRsChuQinPlanArray; out ErrStr: string): Boolean;
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['siteID'] := m_strSiteID ;
  json.S['begintime'] := FormatDateTime('yyyy-MM-dd HH:mm:ss',BeginDate) ;
  json.S['endtime'] := FormatDateTime('yyyy-MM-dd HH:mm:ss',EndDate) ;
  try
    strResult := Post('TF.Runsafty.Plan.Site.ChuQin.Get',json.AsString,ErrStr);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    jsonArray := json.AsArray;
    SetLength(ChuQinPlanArray,jsonArray.Length );

    for I := 0 to jsonArray.Length - 1 do
      JsonToChuQinData(ChuQinPlanArray[i],jsonArray[i]);
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCTrainPlan.GetChuQinPlanByTrainman(TrainmanID: string;
  out ChuQinPlan:RRsChuQinPlan; out ErrStr: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['siteID'] := m_strSiteID ;
  json.S['trainmanID'] := TrainmanID ;

  try
    strResult := Post('TF.Runsafty.Plan.Site.Trainman.ChuQin.Get',json.AsString,ErrStr);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    JsonToChuQinData(ChuQinPlan,json) ;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;


function TRsLCTrainPlan.GetTrainmanPlanFromSent(TrainjiaoluID: string; BeginTime,
  EndTime: TDateTime; out TrainmanPlanArray: TRsTrainmanPlanArray;
  out ErrStr: string): Boolean;
begin
  Result := GetTrainmanPlan(TrainjiaoluID,BeginTime,EndTime,
    TrainmanPlanArray,'TF.Runsafty.Plan.Site.Trainman.Sent.Get',ErrStr) ;
end;

function TRsLCTrainPlan.GetTrainmanPlan(TrainjiaoluID: string; BeginTime,
  EndTime: TDateTime; out TrainmanPlanArray: TRsTrainmanPlanArray;
  DataType: string; out ErrStr: string): Boolean;
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['siteID'] := m_strSiteID ;
  json.S['trainjiaoluID'] := trainjiaoluID;
  json.S['begintime'] := FormatDateTime('yyyy-MM-dd HH:mm:ss',BeginTime) ;
  json.S['endtime'] := FormatDateTime('yyyy-MM-dd HH:mm:ss',EndTime) ;

  try
    strResult := Post(DataType,json.AsString,ErrStr);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    jsonArray := json.AsArray;
    SetLength(TrainmanPlanArray,jsonArray.Length );
    for I := 0 to jsonArray.Length - 1 do
    begin
      JsonToTrainmanPlan(TrainmanPlanArray[i],jsonArray[i]);
    end;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCTrainPlan.GetTrainmanPlanByGUID(TrainPlanGUID: string;
  out TrainmanPlan: RRsTrainmanPlan; out ErrStr: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['TrainPlanGUID'] := TrainPlanGUID;

  try
    strResult := Post('TF.Runsafty.Plan.RCTrainmanplan.GetTrainmanPlanByGUID',json.AsString,ErrStr);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    JsonToTrainmanPlan(TrainmanPlan,json);
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCTrainPlan.GetTrainmanPlanOfNeedRest(TrainPlanGUIDS: TStrings;
  out TrainmanPlanArray: TRsTrainmanPlanArray; out ErrStr: string): Boolean;
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;

begin
  Result := False ;
  json := CreateInputJson;
  for I := 0 to TrainPlanGUIDS.Count - 1 do
  begin
      strResult :=  strResult + TrainPlanGUIDS.Strings[i] + ',' ;
  end;
  json.S['TrainPlanGUIDList'] := strResult ;
  strResult := ''  ;
  try
    strResult := Post('TF.Runsafty.Plan.RCTrainmanplan.GetTrainmanPlanOfNeedRest',json.AsString,ErrStr);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    jsonArray := json.AsArray;
    SetLength(TrainmanPlanArray,jsonArray.Length );
    for I := 0 to jsonArray.Length - 1 do
    begin
      JsonToTrainmanPlan(TrainmanPlanArray[i],jsonArray[i]);
    end;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCTrainPlan.GetTrainmanPlanByJiaoLu(TrainjiaoluID: string; BeginTime,
  EndTime: TDateTime; out TrainmanPlanArray: TRsTrainmanPlanArray;
  out ErrStr: string): Boolean;
begin
  Result := GetTrainmanPlan(TrainjiaoluID,BeginTime,EndTime,
    TrainmanPlanArray,'TF.Runsafty.Plan.Site.Trainmanplan.Get',ErrStr) ;
end;

function TRsLCTrainPlan.GetTuiQinPlanByClient(BeginDate, EndDate: TDateTime; ShowAll : Integer;
  out  TuiQinPlanArray:TRsTuiQinPlanArray; out ErrStr: string): Boolean;
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['siteID'] := m_strSiteID ;
  json.S['begintime'] := FormatDateTime('yyyy-MM-dd HH:mm:ss',BeginDate) ;
  json.S['endtime'] := FormatDateTime('yyyy-MM-dd HH:mm:ss',EndDate) ;
  json.I['showAll'] :=  ShowAll ;
  try
    strResult := Post('TF.Runsafty.Plan.Site.TuiQin.Get',json.AsString,ErrStr);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    jsonArray := json.AsArray;
    SetLength(TuiQinPlanArray,jsonArray.Length );
    for I := 0 to jsonArray.Length - 1 do
      JsonToTuiQinData(TuiQinPlanArray[i],jsonArray[i]);
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCTrainPlan.GetTuiQinPlanByTrainman(TrainmanID: string;
  out TuiQinPlan:RRsTuiQinPlan; out ErrStr: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['siteID'] := m_strSiteID ;
  json.S['trainmanID'] := TrainmanID ;
  try
    strResult := Post('TF.Runsafty.Plan.Site.Trainman.TuiQin.Get',json.AsString,ErrStr);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    JsonToTuiQinData(TuiQinPlan,json) ;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;


procedure TRsLCTrainPlan.JsonToChuQinData(var ChuQinPlan:RRsChuQinPlan;Json: ISuperObject);
var
  jsonChuQinGroup : ISuperObject ;
begin
  JsonToTrainPlan(ChuQinPlan.TrainPlan,Json.O['trainPlan']);

  jsonChuQinGroup := Json.O['chuqinGroup'];
  JsonToGroup(ChuQinPlan.ChuQinGroup.Group,jsonChuQinGroup.O['group']);

  with ChuQinPlan.ChuQinGroup do
  begin
    nVerifyID1 := TRsRegisterFlag ( strtoint ( jsonChuQinGroup.S['verifyID1'] ) );
    JsonToAlcohol(testAlcoholInfo1,jsonChuQinGroup.O['testAlcoholInfo1']);

    nVerifyID2 := TRsRegisterFlag ( strtoint ( jsonChuQinGroup.S['verifyID2'] ) );
    JsonToAlcohol(testAlcoholInfo2,jsonChuQinGroup.O['testAlcoholInfo2']);

    nVerifyID3 := TRsRegisterFlag ( strtoint (jsonChuQinGroup.S['verifyID3'] ) );
    JsonToAlcohol(testAlcoholInfo3,jsonChuQinGroup.O['testAlcoholInfo3']);

    nVerifyID4 := TRsRegisterFlag ( StrToInt(  jsonChuQinGroup.S['verifyID4'] ) ) ;
    JsonToAlcohol(testAlcoholInfo4,jsonChuQinGroup.O['testAlcoholInfo4']);

    strChuQinMemo := jsonChuQinGroup.S['chuQinMemo'];
  end;

  with ChuQinPlan do
  begin
    if Json.S['beginWorkTime'] <> ''  then
      dtBeginWorkTime := StrToDateTime(Json.S['beginWorkTime']);
    strICCheckResult := Json.S['icCheckResult'] ;
  end;
end;



procedure  TRsLCTrainPlan.JsonToAlcohol(var TestAlcoholInfo: RTestAlcoholInfo;Json: ISuperObject);
begin
  with TestAlcoholInfo do
  begin
    taTestAlcoholResult :=  TTestAlcoholResult ( StrToInt( Json.S['testAlcoholResult'] ) ) ;
    picture := Json.S['picture'] ;

    if Json.S['testTime'] <> '' then
      dtTestTime := StrToDateTime( Json.S['testTime'] ) ;
  end;
end;


procedure TRsLCTrainPlan.JsonToTrainmanPlan(var TrainmanPlan: RRsTrainmanPlan;Json: ISuperObject);
begin
  JsonToTrainPlan(TrainmanPlan.TrainPlan,Json.O['trainPlan']);
  JsonToGroup(TrainmanPlan.Group,Json.O['group']);

end;

procedure TRsLCTrainPlan.JsonToTrainPlan(var TrainPlan:RRsTrainPlan;
  Json: ISuperObject);
begin
  with TrainPlan do
  begin
    nPlanState := TRsPlanState ( strtoint( json.S['planStateID'] )) ;
    strPlanStateName := json.S['planStateName'] ;
    strPlaceID := json.S['placeID'] ;
    strPlaceName := json.S['placeName'] ;

    strTrainJiaoluGUID := json.S['trainJiaoluGUID'] ;
    strTrainJiaoluName :=  json.S['trainJiaoluName'] ;

    strTrainTypeName := json.S['trainTypeName'] ;
    strTrainNumber := json.S['trainNumber'] ;
    strTrainNo := json.S['trainNo'] ;

    if json.S['startTime'] <> '' then
      dtStartTime := StrToDateTime(json.S['startTime']) ;
    if json.S['realStartTime'] <> '' then
      dtRealStartTime := StrToDateTime(json.S['realStartTime']) ;
    if json.S['firstStartTime'] <> '' then
      dtFirstStartTime := StrToDateTime(json.S['firstStartTime']) ;
    if Json.S['kaiCheTime']  <>  '' then
      dtChuQinTime :=   StrToDateTime(json.S['kaiCheTime']) ;

    if Json.S['beginWorkTime'] <> '' then
      dtRealBeginWorkTime :=  StrToDateTime(json.S['beginWorkTime']) ;

    strStartStation := json.S['startStationID'] ;
    strStartStationName := json.S['startStationName'] ;
    strEndStation := json.S['endStationID'] ;
    strEndStationName := json.S['endStationName'] ;


    if json.S['trainmanTypeID '] <> '' then
      nTrainmanTypeID := trstrainmantype ( strtoint( json.S['trainmanTypeID '] ) );
    strTrainmanTypeName := json.S['trainmanTypeName'] ;

    if json.S['planTypeID'] <> '' then
      nPlanType :=   trsplantype ( strtoint(json.S['planTypeID']) ) ;
    strPlanTypeName := json.S['planTypeName'] ;

    if json.S['dragTypeID'] <> '' then
      nDragType := trsdragtype ( strtoint(json.S['dragTypeID']) ) ;
    strDragTypeName := json.S['dragTypeName'] ;

    if json.S['kehuoID'] <> '' then
      nKeHuoID := TRsKeHuo ( strtoint( json.S['kehuoID'] ) ) ;
    strKehuoName := json.S['kehuoName'] ;

    if json.S['remarkTypeID'] <> '' then
      nRemarkType := trsplanremarktype ( strtoint( json.S['remarkTypeID'] ) );
    strRemarkTypeName := json.S['remarkTypeName'] ;
    strRemark := json.S['strRemark'] ;


    if json.S['lastArriveTime'] <> '' then
      dtLastArriveTime := StrToDateTime( json.S['lastArriveTime'] );

    strTrainPlanGUID := Json.S['planID'];
    if json.S['createTime'] <> '' then
      dtCreateTime := StrToDateTime( json.S['createTime'] );


    nNeedRest :=  json.I['nNeedRest'] ;
    if Json.S['dtArriveTime'] <> '' then
      dtArriveTime := StrToDateTime( json.S['dtArriveTime']) ;

    if Json.S['dtCallTime'] <> '' then
      dtCallTime :=  StrToDateTime( json.S['dtCallTime'] ) ;


    strCreateSiteGUID := json.S['createSiteGUID']  ;
    strCreateSiteName := json.S['createSiteName'] ;
    strCreateUserGUID := json.S['createUserGUID'] ;
    strCreateUserName:= json.S['createUserName'] ;
    strMainPlanGUID := json.S['mainPlanGUID'] ;

    strTrackNumber := json.S['strTrackNumber'] ;
    strWaiQinClientGUID := json.S['strWaiQinClientGUID'] ;
    strWaiQinClientNumber := json.S['strWaiQinClientNumber'] ;
    strWaiQinClientName := json.S['strWaiQinClientName'] ;

    if Json.S['sendPlanTime'] <> '' then
      dtSendPlanTime :=  StrToDateTime( json.S['sendPlanTime'] ) ;

    if Json.S['recvPlanTime'] <> '' then
      dtRecvPlanTime :=  StrToDateTime( json.S['recvPlanTime'] ) ;

  end;
end;

procedure TRsLCTrainPlan.JsonToTuiQinData(var TuiQinPlan:RRsTuiQinPlan;
  Json: ISuperObject);
var
  jsonTuiQinGroup : ISuperObject ;
begin
  JsonToTrainPlan(TuiQinPlan.TrainPlan,Json.O['trainPlan']);

  jsonTuiQinGroup := Json.O['tuiqinGroup'];
  JsonToGroup(TuiQinPlan.TuiQinGroup.Group,jsonTuiQinGroup.O['group']);
  with TuiQinPlan.TuiQinGroup do
  begin
    nVerifyID1 :=  TRsRegisterFlag ( strtoint(jsonTuiQinGroup.S['verifyID1']));
    JsonToAlcohol(testAlcoholInfo1,jsonTuiQinGroup.O['testAlcoholInfo1']);

    nVerifyID2 := TRsRegisterFlag ( strtoint(jsonTuiQinGroup.S['verifyID2']) );
    JsonToAlcohol(testAlcoholInfo2,jsonTuiQinGroup.O['testAlcoholInfo2']);

    nVerifyID3 := TRsRegisterFlag ( strtoint(jsonTuiQinGroup.S['verifyID3']) );
    JsonToAlcohol(testAlcoholInfo3,jsonTuiQinGroup.O['testAlcoholInfo3']);

    nVerifyID4 := TRsRegisterFlag ( strtoint(jsonTuiQinGroup.S['verifyID4']) );
    JsonToAlcohol(testAlcoholInfo4,jsonTuiQinGroup.O['testAlcoholInfo4']);

  end;

  with TuiQinPlan do
  begin
    if jsonTuiQinGroup.S['turnStartTime'] <> '' then
      dtTurnStartTime := StrToDatetime(jsonTuiQinGroup.S['turnStartTime']) ;
    if jsonTuiQinGroup.S['signed'] <> ''  then
      bSigned := StrToInt( jsonTuiQinGroup.S['signed'] );
    if jsonTuiQinGroup.S['isOver'] <> ''  then
      bIsOver  := StrToInt( jsonTuiQinGroup.S['isOver'] );
    if jsonTuiQinGroup.S['turnMinutes'] <> '' then
      nTurnMinutes := StrToInt( jsonTuiQinGroup.S['turnMinutes'] );
    if jsonTuiQinGroup.S['turnAlarmMinutes'] <> '' then
      nTurnAlarmMinutes := StrToInt( jsonTuiQinGroup.S['turnAlarmMinutes'] ) ;
  end;
end;

procedure TRsLCTrainPlan.PlanListToJson(PlanList: TStrings; Json: ISuperObject);
var
  i : Integer ;
  jsonArray:ISuperObject ;
  jsonPlan:ISuperObject ;
begin
  jsonArray := SO('[]');
  for I := 0 to PlanList.Count - 1 do
  begin
    jsonPlan := SO('{}');
    jsonPlan.S['strTrainPlanGUID'] := PlanList.Strings[i];
    jsonArray.AsArray.Add(jsonPlan);
  end;
  Json.O['plans'] := jsonArray ;
end;

procedure TRsLCTrainPlan.ReceiveTrainPlanToJson(
  ReceiveTrainPlan: RRsReceiveTrainPlan; Json: ISuperObject);
begin
  with ReceiveTrainPlan.TrainPlan do
  begin
    Json.S['trainPlan.trainjiaoluID'] := strTrainJiaoluGUID ;
    Json.S['trainPlan.placeID'] := strPlaceID ;
    Json.S['trainPlan.trainTypeName']:= strTrainTypeName ;
    Json.S['trainPlan.trainNumber']:= strTrainNumber ;
    Json.S['trainPlan.trainNo']:= strTrainNo;
    Json.S['trainPlan.kaiCheTime']:= FormatDateTime('yyyy-MM-dd HH:mm:ss',dtChuQinTime);   //计划开车时间
    Json.S['trainPlan.startTime']:= FormatDateTime('yyyy-MM-dd HH:mm:ss',dtStartTime);    //出勤
    Json.S['trainPlan.startStationID']:= strStartStation;
    Json.S['trainPlan.endStationID']:= strEndStation;
    Json.S['trainPlan.trainmanTypeID']:= IntToStr(Ord(nTrainmanTypeID));
    Json.S['trainPlan.planTypeID']:= IntToStr(Ord(nPlanType));
    Json.S['trainPlan.dragTypeID']:= IntToStr(Ord(nDragType));
    Json.S['trainPlan.kehuoID']:= IntToStr(Ord(nKeHuoID));
    Json.S['trainPlan.remarkTypeID']:= IntToStr(Ord(nRemarkType));
    Json.S['trainPlan.strMainPlanGUID'] := strMainPlanGUID ;

    Json.S['trainPlan.strTrackNumber'] := strTrackNumber ;
    Json.S['trainPlan.strWaiQinClientGUID'] := strWaiQinClientGUID ;
    Json.S['trainPlan.strWaiQinClientNumber'] := strWaiQinClientNumber ;
    Json.S['trainPlan.strWaiQinClientName'] := strWaiQinClientName ;
    //计划下发时间
    Json.S['trainPlan.sendPlanTime']:= FormatDateTime('yyyy-MM-dd HH:mm:ss',dtSendPlanTime);
    //计划接收时间
    Json.S['trainPlan.recvPlanTime']:= FormatDateTime('yyyy-MM-dd HH:mm:ss',dtRecvPlanTime);
    //候版时间
    json.I['trainPlan.nNeedRest'] :=  nNeedRest;
    if nNeedRest >= 1  then
    begin
      json.S['trainPlan.dtArriveTime'] := FormatDateTime('yyyy-MM-dd HH:mm:ss',dtArriveTime ) ;
      json.S['trainPlan.dtCallTime'] := FormatDateTime('yyyy-MM-dd HH:mm:ss',dtCallTime );
    end;
  end;

  with ReceiveTrainPlan do
  begin
    Json.S['user.userID'] := strUserID ;
    Json.S['user.userName'] := strUserName ;

    Json.S['site.siteID'] := strSiteID ;
    Json.S['site.siteName'] := strSiteName ;
  end;
end;

function TRsLCTrainPlan.RecieveTrainPlan(
  var ReceiveTrainPlan: RRsReceiveTrainPlan; out ErrStr: string): Boolean;
begin
  Result := EditTrainPlan(ReceiveTrainPlan,'TF.Runsafty.Plan.Train.Accept.Add',ErrStr);
end;

function TRsLCTrainPlan.RecvPlan(DutyUserGUID: string; out PlanList: TStrings;
  out ErrStr: string): Boolean;
var
  json: ISuperObject;
  jsonArray:TSuperArray;
  strResult : string ;
  i : Integer ;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['strDutyGUID'] := DutyUserGUID ;
  json.S['strSiteGUID'] :=  m_strSiteID ;
  try
    strResult := Post('TF.Runsafty.Plan.LCTrainPlan.Receive',json.AsString,ErrStr);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    jsonArray := json.asarray;
    for I := 0 to jsonArray.Length - 1 do
    begin
      PlanList.Add(jsonArray[i].S['planGUID']);
    end;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCTrainPlan.RemoveGroup(GroupGUID, TrainmanPlanGUID: string;
  out ErrStr: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['strGroupGUID'] := GroupGUID ;
  json.S['strTrainPlanGUID'] :=  TrainmanPlanGUID ;
  try
    strResult := Post('TF.Runsafty.Plan.LCTrainPlan.RemoveGroup',json.AsString,ErrStr);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCTrainPlan.RemoveTrainman(TrainmanGUID, TrainmanPlanGUID: string;GroupGUID:string;
  TrainmanIndex: Integer; out ErrStr: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['trainmanGUID'] := TrainmanGUID ;
  json.S['trainmanPlanGUID'] :=  TrainmanPlanGUID ;
  json.S['strGroupGUID'] := GroupGUID ;
  json.I['trainmanIndex'] := TrainmanIndex ;
  try
    strResult := Post('TF.Runsafty.Plan.LCTrainPlan.RemoveTrainman',json.AsString,ErrStr);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCTrainPlan.SendTrainPlan(PlanList: TStrings;DutyUserGUID:string;
  out ErrStr: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['DutyUserGUID'] := DutyUserGUID ;
  json.S['SiteGUID'] :=  m_strSiteID ;
  PlanListToJson(PlanList,json);
  try
    strResult := Post('TF.Runsafty.Plan.LCTrainPlan.Send',json.AsString,ErrStr);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

end.
