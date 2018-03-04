unit uSignPlan;

interface
uses
  Classes,SysUtils,superobject,uSaftyEnum,Contnrs,uTrainman;
type
  //////////////////////////////////////////////////////////////////////////////
  /// 类名: TSignPlan
  /// 描述: 退勤签点计划
  //////////////////////////////////////////////////////////////////////////////
  TSignPlan= class
  public
    //GUID
    strGUID:string;
    //计划状态
    eState:TRsPlanState;
    //签点时间
    dtSignTime:TDateTime;
    //交路GUID
    strTrainJiaoLuGUID:string;
    //交路名称
    strTrainJiaoLuName:string;
    //是否签点
    nNeedRest :Integer;
    //待乘时间
    dtArriveTime:TDateTime;
    //叫班时间
    dtCallTime:TDateTime;
    //车次
    strTrainNo:string;
    //  计划出勤时间
    dtChuQinTime:TDateTime;
    // 计划开车时间
    dtStartTrainTime:TDateTime;
    //图钉车次id
    strTrainNoGUID:String;
    //机组GUID
    strWorkGrouGUID:string;
    //司机1
    strTrainmanGUID1:string;
    strTrainmanName1:string;
    strTrainmanNumber1:string;
    //司机2
    strTrainmanGUID2:string;
    strTrainmanName2:string;
    strTrainmanNumber2:string;
    //司机3
    strTrainmanGUID3:string;
    strTrainmanName3:string;
    strTrainmanNumber3:string;
    //司机4
    strTrainmanGUID4:string;
    strTrainmanName4:string;
    strTrainmanNumber4:string;
    //派班结束
    nFinished:Integer;

  public
    {功能:查找司机索引,不为空的司机}
    function FindTrainmanIndex(strTrainmanGUID:string):Integer;
    {功能:获取人员个数}
    function GetTrainmanCount():Integer;
    {功能:拷贝对象}
    procedure Clone(var SourceObj:TSignPlan);
    {功能:判断是否已签点}
    function bSigned():Boolean;
    {功能:转换为json}
    procedure ToJson(var iJson:ISuperObject);
    {功能:json赋值给对象}
    procedure FromJson(iJson:ISuperObject);
     {功能:修改人员}
    function ModifyTrainman(nTrainmanIndex:Integer;DestTrainman:RRsTrainman):Boolean;

    {功能:转换字符串为日期}
    function str2DateTime(strDateTime:string):TDateTime;
    {功能:转换日期为字符串}
    function DateTime2Str(dt:TDateTime):String;
    {功能:根据索引获取人员GUID}
    function GetTrianmanID(index:Integer):string;
    
  end;
  {签点计划列表}
  TSignPlanList = class(TObjectList)
  public
    //日期
    dtDay :TDateTime;
  protected
    function GetItem(Index: Integer): TSignPlan;
    procedure SetItem(Index: Integer; AObject: TSignPlan);
  public
   function Add(AObject: TSignPlan): Integer;
   property Items[Index: Integer]: TSignPlan read GetItem write SetItem; default;
   {功能:解析json数据}
   procedure FromJson(iJson:ISuperObject);
   {功能:查找机组所在签点计划索引}
   function FindGroup (strGroupGUID:string):Integer;
   {功能:查找人员所在的欠点计划}
   function FindPlanByTM(strTrainmanGUID:string;var nTMIndex:Integer):TSignPlan;
   {功能:找到第一个签点的计划}
   function GetFirstSignedPlanIndex():Integer;
   {功能:找到下一个待签点计划索引}
   function FindNextSignPlanIndex():Integer;
  end;


  //////////////////////////////////////////////////////////////////////////////
  /// 类名: TSignPlanJiaoLu
  /// 描述: 交路退勤签点计划
  //////////////////////////////////////////////////////////////////////////////
  TSignPlanJiaoLu = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //交路GUID
    strTrainJiaoLuGUID:string;
    //当前签点计划
    strCurPlanGUID:string;
    //签点计划列表
    SignPlanList : TSignPlanList;
  
  public
    //解析json串
    procedure FromJson(iJson:ISuperObject);
  end;
  
  //////////////////////////////////////////////////////////////////////////////
  /// 类名: TDaySignPlanJiaoLu
  /// 描述: 交路退勤签点计划
  //////////////////////////////////////////////////////////////////////////////
  TDaySignPlanJiaoLu = class(TSignPlanJiaoLu)
  public
    //日期
    dtDay:TDateTime;
  end;

  
  //////////////////////////////////////////////////////////////////////////////
  /// 类名: TDaySignPlanJiaoLu
  /// 描述: 交路退勤签点计划
  //////////////////////////////////////////////////////////////////////////////
  TMutilDaySignPlanJiaoLuList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TDaySignPlanJiaoLu;
    procedure SetItem(Index: Integer; AObject: TDaySignPlanJiaoLu);
  public
    function Add(AObject: TDaySignPlanJiaoLu): Integer;
    property Items[Index: Integer]: TDaySignPlanJiaoLu read GetItem write SetItem; default;
    //功能:按照日期查找
    function FindByDay(dtDay:TDateTime):TDaySignPlanJiaoLu;
  end;


  //////////////////////////////////////////////////////////////////////////////
  /// 类名: TSignModifyTrainman
  /// 描述: 修改签点人员记录
  //////////////////////////////////////////////////////////////////////////////
  TSignModifyTrainman = class
  public
    //签点计划guid
    strSignPlanGUID:string;
    //原司机guid
    strSouceTMGUID:string;
    //新司机guid
    strDestTMGUID:string;
    //调整原因
    strReason:string;
    //调整时间
    dtModifyTime:TDateTime;
    //索引
    nIndex:Integer;
    //机组GUID
    strWorkGroupGUID:string;
    //计划状态
    ePlanState:TRsPlanState;
  public
    {功能:转换为json}
    procedure ToJson(var iJson:ISuperObject);


  end;

implementation

{ TSignPlan }


function TSignPlan.bSigned: Boolean;
begin
  Result := False;
  if strTrainmanGUID1 <> '' then
  begin
    result := True;
    Exit;
  end;
  if strTrainmanGUID2 <> '' then
  begin
    result := True;
    Exit;
  end;
  if strTrainmanGUID3 <> '' then
  begin
    result := True;
    Exit;
  end;
  if strTrainmanGUID4 <> '' then
  begin
    result := True;
    Exit;
  end;

end;

procedure TSignPlan.Clone(var SourceObj:TSignPlan);
begin
  //GUID
    self.strGUID:= SourceObj.strGUID;
    //计划状态
    self.eState:=SourceObj.eState;
    //签点时间
    self.dtSignTime:=SourceObj.dtSignTime;
    //交路GUID
    self.strTrainJiaoLuGUID:=SourceObj.strTrainJiaoLuGUID;
    //是否签点
    self.nNeedRest :=SourceObj.nNeedRest;
    //待乘时间
    self.dtArriveTime:=SourceObj.dtArriveTime;
    //叫班时间
    self.dtCallTime:=SourceObj.dtCallTime;
    //车次
    self.strTrainNo:=SourceObj.strTrainNo;
    //  计划出勤时间
    self.dtChuQinTime:=SourceObj.dtChuQinTime;
    // 计划开车时间
    self.dtStartTrainTime:=SourceObj.dtStartTrainTime;
    //图钉车次id
    self.strTrainNoGUID:=SourceObj.strTrainNoGUID;
    //机组GUID
    self.strWorkGrouGUID:=SourceObj.strWorkGrouGUID;
    //司机1
    self.strTrainmanGUID1:=SourceObj.strTrainmanGUID1;
    self.strTrainmanName1:=SourceObj.strTrainmanName1;
    self.strTrainmanNumber1:=SourceObj.strTrainmanNumber1;
    //司机2
    self.strTrainmanGUID2:=SourceObj.strTrainmanGUID2;
    self.strTrainmanName2:=SourceObj.strTrainmanName2;
    self.strTrainmanNumber2:=SourceObj.strTrainmanNumber2;
    //司机3
    self.strTrainmanGUID3:=SourceObj.strTrainmanGUID3;
    self.strTrainmanName3:=SourceObj.strTrainmanName3;
    self.strTrainmanNumber3:=SourceObj.strTrainmanNumber3;
    //司机4
    self.strTrainmanGUID4:=SourceObj.strTrainmanGUID4;
    self.strTrainmanName4:=SourceObj.strTrainmanName4;
    self.strTrainmanNumber4:=SourceObj.strTrainmanNumber4;
end;

function TSignPlan.DateTime2Str(dt: TDateTime): String;
begin
  result := FormatDateTime('yyyy-mm-dd HH:mm:ss',dt);
end;

function TSignPlan.FindTrainmanIndex(strTrainmanGUID: string): Integer;
begin
  result := -1;
  if strTrainmanGUID1 <> '' then
  begin
    if strTrainmanGUID1 = strTrainmanGUID then
    begin
      Result := 1;
      Exit;
    end;
  end;
  if strTrainmanGUID2 <> '' then
  begin
    if strTrainmanGUID2 = strTrainmanGUID then
    begin
      Result := 2;
      Exit;
    end;
  end;
  if strTrainmanGUID3 <> '' then
  begin
    if strTrainmanGUID3 = strTrainmanGUID then
    begin
      Result := 3;
      Exit;
    end;
  end;
  if strTrainmanGUID4 <> '' then
  begin
    if strTrainmanGUID4 = strTrainmanGUID then
    begin
      Result := 4;
      Exit;
    end;
  end;
end;

procedure TSignPlan.FromJson(iJson:ISuperObject);
begin
  //GUID
    strGUID:= iJson.S['strGUID'];
    //计划状态
    eState := TRsPlanState(iJson.I['ePlanState']);
    if eState = psCancel then
      eState := psReceive;
    //签点时间
    dtSignTime := str2DateTime(iJson.S['dtSignTime']);
    //交路GUID
    strTrainJiaoLuGUID:= iJson.S['strTrainJiaoLuGUID'];
    //是否待乘
    nNeedRest := iJson.I['nNeedRest'];
    //待乘时间
    dtArriveTime:= str2DateTime(iJson.S['dtArriveTime']);
    //叫班时间
    dtCallTime:= str2DateTime(iJson.S['dtCallTime']);
    //车次
    strTrainNo:= iJson.S['strTrainNo'];
    //计划开车时间
    dtChuQinTime:=  str2DateTime(iJson.S['dtChuQinTime']);
    //计划出勤时间
    dtStartTrainTime:= str2DateTime(iJson.S['dtStartTrainTime']);
    //图钉车次id
    strTrainNoGUID:= iJson.S['strTrainNoGUID'];
    //机组GUID
    strWorkGrouGUID:= iJson.S['strWorkGrouGUID'];
    //司机1
    strTrainmanGUID1:= iJson.S['strTrainmanGUID1'];
    strTrainmanName1:= iJson.S['strTrainmanName1'];
    strTrainmanNumber1:= iJson.S['strTrainmanNumber1'];
    //司机2
    strTrainmanGUID2:= iJson.S['strTrainmanGUID2'];
    strTrainmanName2:= iJson.S['strTrainmanName2'];
    strTrainmanNumber2:= iJson.S['strTrainmanNumber2'];
    //司机3
    strTrainmanGUID3:= iJson.S['strTrainmanGUID3'];
    strTrainmanName3:= iJson.S['strTrainmanName3'];
    strTrainmanNumber3:= iJson.S['strTrainmanNumber3'];
    //司机4
    strTrainmanGUID4:= iJson.S['strTrainmanGUID4'];
    strTrainmanName4:= iJson.S['strTrainmanName4'];
    strTrainmanNumber4:= iJson.S['strTrainmanNumber4'];
    nFinished := iJson.I['nFinished'];
    if nFinished = 1 then
    begin
      nFinished := 1;
    end;
end;


function TSignPlan.GetTrainmanCount: Integer;
begin
  result := 0;
  if strTrainmanGUID1 <> '' then
    Inc(Result);
  if strTrainmanGUID2 <> '' then
    Inc(Result);
  if strTrainmanGUID3 <> '' then
      Inc(Result);
  if strTrainmanGUID4 <> '' then
      Inc(Result);

end;

function TSignPlan.GetTrianmanID(index: Integer): string;
begin
  result := '';
  case index of
  1:Result := strTrainmanGUID1;
  2:Result := strTrainmanGUID2;
  3:Result := strTrainmanGUID3;
  4:Result := strTrainmanGUID4;
  end;
end;

function TSignPlan.ModifyTrainman(nTrainmanIndex:Integer;
  DestTrainman: RRStrainman): Boolean;
begin
  case nTrainmanIndex of
    1:
    begin
      strTrainmanGUID1 := DestTrainman.strTrainmanGUID;
      strTrainmanName1 := DestTrainman.strTrainmanName;
      strTrainmanNumber1 := DestTrainman.strTrainmanNumber;
    end;
    2:
    begin
      strTrainmanGUID2 := DestTrainman.strTrainmanGUID;
      strTrainmanName2 := DestTrainman.strTrainmanName;
      strTrainmanNumber2 := DestTrainman.strTrainmanNumber;
    end;
    3:
    begin
      strTrainmanGUID3 := DestTrainman.strTrainmanGUID;
      strTrainmanName3 := DestTrainman.strTrainmanName;
      strTrainmanNumber3 := DestTrainman.strTrainmanNumber;
    end;
    4:
    begin
      strTrainmanGUID4 := DestTrainman.strTrainmanGUID;
      strTrainmanName4 := DestTrainman.strTrainmanName;
      strTrainmanNumber4 := DestTrainman.strTrainmanNumber;
    end;
  end;

  if bSigned = False  then
  begin
    Self.strWorkGrouGUID := '';
    self.eState := psPublish;
  end;


end;

function TSignPlan.str2DateTime(strDateTime: string): TDateTime;
var
  dt:TDateTime;
begin
  if strDateTime ='' then Exit;
  if TryStrToDateTime(strDateTime,dt )then
    Result := dt
  else
    result := 0;
end;

procedure TSignPlan.ToJson(var iJson:ISuperObject);
begin
  //GUID
    iJson.S['strGUID']:= strGUID;
    //计划状态
    iJson.I['ePlanState']:= ord(eState);
    //签点时间
    iJson.S['dtSignTime'] := DateTime2Str(dtSignTime);
    //交路GUID
    iJson.S['strTrainJiaoLuGUID']:= strTrainJiaoLuGUID;
     iJson.I['nNeedRest'] :=  nNeedRest;
    //待乘时间
    iJson.S['dtArriveTime']:= DateTime2Str( dtArriveTime);
    //叫班时间
    iJson.S['dtCallTime'] := DateTime2Str(dtCallTime);
    //车次
    iJson.S['strTrainNo']:= strTrainNo;
    // 计划出勤时间 
    iJson.S['dtChuQinTime']:=  DateTime2Str(dtChuQinTime);
    //计划开车时间
    iJson.S['dtStartTrainTime']:= DateTime2Str(dtStartTrainTime);
    //图钉车次id
     iJson.S['strTrainNoGUID']:=strTrainNoGUID;
    //机组GUID
    iJson.S['strWorkGrouGUID']:=strWorkGrouGUID ;
    //司机1
    iJson.S['strTrainmanGUID1']:=strTrainmanGUID1 ;
    //iJson.S['strTrainmanName1']:= strTrainmanName1;
    //iJson.S['strTrainmanNumber1']:= strTrainmanNumber1;
    //司机2
    iJson.S['strTrainmanGUID2']:=strTrainmanGUID2 ;
    //iJson.S['strTrainmanName2']:= strTrainmanName2;
    //iJson.S['strTrainmanNumber2']:= strTrainmanNumber2;
    //司机3
    iJson.S['strTrainmanGUID3']:= strTrainmanGUID3;
    //iJson.S['strTrainmanName3']:= strTrainmanName3;
    //iJson.S['strTrainmanNumber3']:= strTrainmanNumber3;
    //司机4
    iJson.S['strTrainmanGUID4']:= strTrainmanGUID4 ;
    //iJson.S['strTrainmanName4']:= strTrainmanName4;
    //iJson.S['strTrainmanNumber4']:= strTrainmanNumber4;
    iJson.I['nFinished']:= nFinished;
end;

{ TSignPlanJiaoLu }


constructor TSignPlanJiaoLu.Create;
begin
  SignPlanList := TSignPlanList.Create;
end;

destructor TSignPlanJiaoLu.Destroy;
begin
  SignPlanList.Free;
  inherited;
end;

function TSignPlanList.FindGroup(strGroupGUID: string): Integer;
var
  i:Integer;
begin
  result := -1;

  for i := 0 to self.Count -1  do
  begin
    if Items[i].strWorkGrouGUID = strGroupGUID then
    begin
      result := i;
      Break;
    end;
  end;
end;

function TSignPlanList.GetFirstSignedPlanIndex():Integer;
var
  i:Integer;
begin
  result := -1 ;
  for i := 0 to self.Count - 1 do
  begin
    if Items[i].bSigned  = True then
    begin
      Result := i;
      Exit;
    end;
  end;
    
end;
function TSignPlanList.FindNextSignPlanIndex: Integer;
var
  i:Integer;
begin
  result := -1;
  //全部计划未签点,需要首次定向签点
  if GetFirstSignedPlanIndex = -1 then
  begin
    result := 0;
    Exit;
  end;

  //从第一个签点计划,到计划数据,找第一个未签点的计划
  for i := GetFirstSignedPlanIndex to self.Count- 1 do
  begin
    if Items[i].bSigned = False then
    begin
      result := i;
      Exit;
    end;
  end;
 
end;



function TSignPlanList.FindPlanByTM(strTrainmanGUID: string;
  var nTMIndex: Integer): TSignPlan;
var
  i:Integer;
begin
  Result := nil;
  if strTrainmanGUID = '' then Exit;
  
  for i := 0 to self.Count - 1 do
  begin
    if self.Items[i].strTrainmanGUID1 = strTrainmanGUID then
    begin
      result := self.Items[i];
      nTMIndex := 0;
      Exit;
    end;
    if self.Items[i].strTrainmanGUID2 = strTrainmanGUID then
    begin
      result := self.Items[i];
      nTMIndex := 1;
      Exit;
    end;
    if self.Items[i].strTrainmanGUID3 = strTrainmanGUID then
    begin
      result := self.Items[i];
      nTMIndex := 2;
      Exit;
    end;
    if self.Items[i].strTrainmanGUID4 = strTrainmanGUID then
    begin
      result := self.Items[i];
      nTMIndex := 3;
      Exit;
    end;
  end;
end;

procedure TSignPlanJiaoLu.FromJson(iJson:ISuperObject);
begin
  SignPlanList.Clear;
  Self.strTrainJiaoLuGUID := iJson.S['strTrainJiaoLuGUID'];
  Self.strCurPlanGUID := iJson.S['strCurPlanGUID'];
  SignPlanList.FromJson(iJson.o['planArray']);
end;


{ TSignModifyTrainman }


procedure TSignModifyTrainman.ToJson(var iJson: ISuperObject);
begin
  iJson.S['strPlanGUID'] := strSignPlanGUID;
  iJson.I['nTrainmanIndex'] := nIndex;
  iJson.S['strOldTrainmanGUID'] := strSouceTMGUID;
  iJson.S['strNewTrainmanGUID'] := strDestTMGUID;
  iJson.I['ePlanState'] := ord(self.ePlanState);
  iJson.S['dtModifyTime'] := FormatDateTime('yyyy-mm-dd HH:mm:ss',dtModifyTime);
  iJson.S['strReason'] := strReason;
  iJson.S['strWorkGroupGUID'] := strWorkGroupGUID;
end;

{ TSignPlanList }

function TSignPlanList.Add(AObject: TSignPlan): Integer;
begin
  result := inherited Add(AObject) ;
end;

procedure TSignPlanList.FromJson(iJson: ISuperObject);
var
  i:Integer;
  nCount:Integer;
  signPlan:TSignPlan;
begin
  nCount := iJson.AsArray.Length;
  for i := 0 to nCount - 1 do
  begin
    signPlan := TSignPlan.Create;
    signPlan.FromJson(iJson.AsArray[i]);
    self.Add(signPlan);
  end;
end;

function TSignPlanList.GetItem(Index: Integer): TSignPlan;
begin
  Result := TSignPlan(inherited GetItem(Index));
end;

procedure TSignPlanList.SetItem(Index: Integer; AObject: TSignPlan);
begin
  inherited SetItem(Index,AObject);
end;

{ TMutilDaySignPlanJiaoLuList }

function TMutilDaySignPlanJiaoLuList.Add(AObject: TDaySignPlanJiaoLu): Integer;
begin
  result := inherited Add(AObject);
end;

function TMutilDaySignPlanJiaoLuList.FindByDay(dtDay: TDateTime): TDaySignPlanJiaoLu;
var
  i:Integer;
begin
  Result := nil;
  for i := 0 to self.Count - 1 do
  begin
    if Self.Items[i].dtDay = dtDay then
    begin
      result := self.Items[i];
      Exit;
    end;
  end;
end;

function TMutilDaySignPlanJiaoLuList.GetItem(Index: Integer): TDaySignPlanJiaoLu;
begin
  Result := TDaySignPlanJiaoLu( inherited GetItem(Index));
end;

procedure TMutilDaySignPlanJiaoLuList.SetItem(Index: Integer; AObject: TDaySignPlanJiaoLu);
begin
  inherited SetItem(Index,AObject);
end;

end.
