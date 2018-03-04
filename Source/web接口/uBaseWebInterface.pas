unit uBaseWebInterface;

interface

uses
  SysUtils,Classes,superobject,uHttpCom,uTrainman,uTrainmanJiaolu,uSaftyEnum,uApparatusCommon;

type

  RRsWebInterfaceResult = record
    result:Integer;
    resultStr : string ;
  end;

  //网站接口基类
  TBaseWebInterface = class
  public
    //构造函数
    //AURL 接口地址
    //ClientID客户端编号
    constructor Create(AUrl:string;ClientID:string;SiteID:string);
    //西沟函数
    destructor  Destroy();override;
  public
    //json -> group
    procedure JsonToGroup(var Group:RRsGroup;Json: ISuperObject);

  protected
    //产生JSON输入数据
    function  CreateInputJson():ISuperObject;
    //提交JSON数据到WEB接口 dataType = 提交类型  sendstr 输入的数据   ErrStr  输出错误结果
    function  Post(DataType:string;SendStr:string;out ErrStr:string):string;
    {功能:提交数据,原始方式}
    function PostStringS(DataType: string; Values: TStringS;out ErrStr:string):string;
    //检查JSON的返回结果,并返回JSON数据
    function  GetJsonResult(AStr:string;out AJson:ISuperObject;out ErrStr:string):Boolean;
  protected
    //客户端编号
    m_strClientID:string;
    //网址接口
    m_strUrl:string;
    //SITE_id
    m_strSiteID:string;
  public
    property ClientID:string read m_strClientID ;
    property Url:string read m_strUrl ;
    property SiteID:string read m_strSiteID ;
  end;

implementation

{ TBaseWebInterface }


function TBaseWebInterface.GetJsonResult(AStr: string;
  out AJson: ISuperObject;out ErrStr:string): Boolean;
var
  json: ISuperObject;
begin
  Result := False ;
  try
    if AStr = '' then
    begin
      ErrStr := '返回数据为空' ;
      exit ;
    end;
    json := SO(AStr);
    if json = nil then
      Exit ;
    if  json.I['result']  = 0  then
    begin
      if  json.O['data'] <> nil  then
      begin
        AJson :=  json.O['data'] ;
      end;
      Result := True ;
    end
    else
      ErrStr := json.S['resultStr'];
  except
   on e:Exception do
   begin
    ErrStr := e.Message ;
   end;
  end;
end;



procedure TBaseWebInterface.JsonToGroup(var Group: RRsGroup;
  Json: ISuperObject);

  procedure JsonToTrainman(var Trainman: RRsTrainman;  Json: ISuperObject);
  begin
    with Trainman do
    begin
      strTrainmanGUID := Json.S['trainmanID'] ;
      strTrainmanNumber := Json.S['trainmanNumber'] ;
      strTrainmanName := Json.S['trainmanName'] ;
      nPostID :=  TRsPost ( strtoint(Json.S['postID']) ) ;
      strTelNumber := Json.S['telNumber'] ;
      strMobileNumber := strTelNumber ;
      //strMobileNumber := Json.S['mobileNumber'];
      nTrainmanState := TRsTrainmanState   (StrToInt(Json.S['trainmanState']));
      strPostName := Json.S['postName'] ;
      nDriverType := TRsDriverType ( strtoint ( Json.S['driverTypeID'] ) ) ;
      strDriverTypeName := Json.S['driverTypeName'] ;
      strABCD := Json.S['ABCD'] ;
      bIsKey :=  ( StrToInt(Json.S['isKey']) ) ;

      if Json.S['callWorkState'] <> '' then
        nCallWorkState :=  TRsCallWorkState ( StrToInt(Json.S['callWorkState']) );
      if Json.S['callWorkID'] <> '' then
        strCallWorkGUID := Json.S['callWorkID'];
    end;
  end;

begin

  with Group do
  begin
    strGroupGUID := Json.S['groupID'];
    if Json.S['groupState'] <> '' then
      groupState :=  TRsTrainmanState ( strtoint ( Json.S['groupState'] ) ) ;
    strTrainPlanGUID := Json.S['trainPlanID'];

    if json.S['arriveTime'] <> '' then
      dtArriveTime := StrToDateTime(json.S['arriveTime']) ;

    if json.S['lastInRoomTime1'] <> '' then
      dtLastInRoomTime1:= StrToDateTime(json.S['lastInRoomTime1']) ;

    if json.S['lastInRoomTime2'] <> '' then
      dtLastInRoomTime2:= StrToDateTime(json.S['lastInRoomTime2']) ;

    if json.S['lastInRoomTime3'] <> '' then
      dtLastInRoomTime3:= StrToDateTime(json.S['lastInRoomTime3']) ;

    if json.S['lastInRoomTime4'] <> '' then
      dtLastInRoomTime4:=  StrToDateTime(json.S['lastInRoomTime4']) ;

  end;

  with Group.place do
  begin
    placeID := Json.S['place.placeID'];
    placeName := Json.S['place.placeName'];
  end;

  with Group.Station do
  begin
    strStationGUID := Json.S['station.stationID'] ;
    strStationNumber := Json.S['station.stationNumber'];
    strStationName := Json.S['station.stationName'];
  end;

  with Group do
  begin
    JsonToTrainman(trainman1,Json.O['trainman1']);

    JsonToTrainman(trainman2,Json.O['trainman2']);

    JsonToTrainman(trainman3,Json.O['trainman3']);
    
    JsonToTrainman(trainman4,Json.O['trainman4']);

  end;
end;



constructor TBaseWebInterface.Create(AUrl, ClientID: string;SiteID:string);
begin
  inherited Create();
  m_strClientID := ClientID ;
  m_strUrl := AUrl ;
  m_strSiteID := SiteID ;
end;

function TBaseWebInterface.CreateInputJson: ISuperObject;
var
  json : ISuperObject ;
begin
  json := SO('{}');
  json.S['cid'] := m_strSiteID;//m_strClientID ;
  Result := json ;
end;

destructor TBaseWebInterface.Destroy;
begin
  inherited;
end;


function TBaseWebInterface.Post(DataType, SendStr: string;
  out ErrStr: string): string;
var
  http : TRsHttpCom;
  iJson:ISuperobject;
begin
  http := TRsHttpCom.Create;
  try
    Result := http.Post(m_strUrl,DataType,SendStr,ErrStr);
    Result := so(result).asstring;
    iJson := nil;
  finally
    http.Free ;
  end;

end;

function TBaseWebInterface.PostStringS(DataType: string; Values: TStringS;
  out ErrStr:string):string;
var
  http : TRsHttpCom;
begin
  Result := '';
  http := TRsHttpCom.Create;
  try
    Result := http.PostStringS(m_strUrl + 'DataType=' + DataType,Values,ErrStr);
  finally
    http.Free ;
  end;
end;

end.
