unit uRsInterfaceDefine;

interface
uses
  uLKJson,SysUtils,superobject,Windows;
type
  
  {TRegisterFlag 乘务员身份登记类别}
  TRegisterFlag  = (rfFingerprint{指纹},rfInput{手动输入},rfICCar{IC卡});
  
  {测酒结果类型}
  TTestAlcoholResult = (taNormal{测酒正常},taAlcoholContentMiddling{酒精含量中},
      taAlcoholContentHeight{酒精含量高},taNoTest{未测试},tsError{测试故障});

  {乘务员事件类型}
  TCWYEventType = (cweInRoom = 1,cweOutRoom,cweYanKa,cweBeginWork,cweEndWork);

  {RRSBFCWYEvent 博飞乘务员事件}
  RRSBFCWYEvent = record
  const
    SJBS = 'SJ_CWY';
  public
    SJSJ: string;     //事件时间,格式YYYYMMDDHHNNSS
    CWYID: string;    //乘务员工号
    CWYXM: string;    //乘务员姓名
    CQSJ: string;     //出勤时间
    CYSJ: string;     //出寓时间
    SJLX: string;     //事件类型 01超劳预警
    CJMS: string;     //事件描述
    CX: string;       //车型
    CH: string;       //车号
    CC: string;       //车次
    DWH: string;      //单位号
    {为值乘类型(1代表正常班、2代表双司机、3代表单司机)}
    tmtype : string;
    {客货类型(1代表客车、2代表火车、3代表调车)}
    kh : string;
    {为红色超劳时长，单位为分钟}
    outMinutes : string;
    {黄色预警时长，单位为分钟}
    alarmMinutes : string;    
  end;

  {RRSBFJCEvent 博飞机车事件}
  RRSBFJCEvent = record
  const
    SJBS = 'SJ_JC';
  public
    SJSJ: string;     //事件时间,格式YYYYMMDDHHNNSS
    CWYID1: string;   //乘务员工号
    CWYID2: string;   //乘务员工号
    CC: string;       //车次
    CX: string;       //车型
    CH: string;       //车号
    JLH: string;      //交路号
    CZH: string;      //车站号
    KH: string;       //客货
    CZBZ: string;     //事件标志{1-出库,2-入库,3-停车,4-开车}
  end;

  {RRSBFZhengBeiEvent 博飞整备场事件}
  RRSBFZhengBeiEvent = record
  const
    SJBS = 'SJ_ZBC';
  public
    SJSJ: string;     //事件时间,格式YYYYMMDDHHNNSS
    ZBC_BS: string;   //整备场标识
    CX: string;       //车型
    CH: string;       //车号
    GDH: string;      //股道号
    JCZT:string;      //机车状态
    SJLX: string;     //事件类型
    X: string;        //X坐标
    Y: string;        //Y坐标
    CDKD: string;     //整备场宽度
    CDGD: string;     //整备场高度
  end;

  {RTrainState 机车状态改变}
  RTrainStateChange = Record
  public
    ID : Integer;
    //车型
    strLocoType : String;
    //车号
    strLocoNum : String;
    //状态
    nState : Integer;
    //时间
    dtStateTime : TDateTime;
    //整备场ID
    strDWH : String;
  end;
  {机车状态数组}
  TTrainStateChanges = array of RTrainStateChange;


  RRsBFCtqEvent = record
  const
    SJBS = 'SJ_CTQ';
  public
    SJSJ: string;     //事件时间,格式YYYYMMDDHHNNSS
    DWH: string;      //单位号
    CWYID: string;    //乘务员工号
    CWYXM: string;    //乘务员姓名
    CJJG: string;     //测酒结果,0未测试、1正常、2饮酒、3酗酒
    SJLX: string;     //事件类型,1出寓、2出勤、3退勤、4入寓
  public
    function ToJSON(): string;
    procedure SetTestResult(nRsTestResult: Integer);    
  end;


  {乘务员事件}
  RRSCWYEvent = record
    {事件时间}
    etime: TDateTime;
    {乘务员工号}
    tmid: string;
    {乘务员姓名}
    tmname: string;
    {TMIS站号}
    stmis: Integer;
    {结果状态:0}
    nresult: Integer;
    {验证方式}
    nVerify: Integer;
    {描述信息}
    strResult: string;
    {事件标志}
    sjbz: TCWYEventType;
  end;

  TRSCWYEvent = array of RRSCWYEvent;

  {运行记录事件}
  RRSRTFileEvent = record
    nID: Integer;
    {开车时间}
    dtKaiCheTime: TDateTime;
    {进站时间}
    dtEnterStationTime: TDateTime;
    {文件结束时间}
    dtFileEndTime: TDateTime;
    {乘务员工号}
    tmid1: string;
    {乘务员工号}
    tmid2: string;
  end;

  {超劳预警信息}
  RRSOverWorkRecord = record
    {记录ID}
    nID: string;
    {乘务员工号}
    tmid: string;
    {乘务员姓名}
    tmname: string;
    {机车型号}
    strTrainType: string;
    {机车号}
    strTrainNumber: string;
    {车次}
    strCheCi: string;
    {单位号}
    strDWH: string;
    {出勤时间}
    dtBeginWorkTime: string;
    {出寓时间}
    dtOutroomTime: string;
    {事件标志}
    sjbz: Integer;
    {备注}
    strRemark: string;
    {为值乘类型(1代表正常班、2代表双司机、3代表单司机)}
    tmtype : string;
    {客货类型(1代表客车、2代表火车、3代表调车)}
    kh : string;
    {为红色超劳时长，单位为分钟}
    outMinutes : string;
    {黄色预警时长，单位为分钟}
    alarmMinutes : string;
  end;
  PRSOverWorkRecord = ^RRSOverWorkRecord;
  
  TYanKaResultType =(rtSame{一致},rtUnsame{不一致},rtManul{人工验卡});
  {验卡记录}
  RYanKaRecord = record
    {验卡时间}
    dtTestTime: TDateTime;
    {验卡地点}
    strPlace: string;
    {工号}
    strGh: string;
    {姓名}
    strName: string;
    {揭示数量}
    JieShiCount: string;
    {限速揭示数量}
    LimiteCount: string;
    {特殊揭示数量}
    SpecialCount: string;
    {标准揭示数量}
    nStandJieShi: string; 
    {验卡结果}
    strResult: string;{合格，不合格，人工验卡}
  end;

  {机车事件类型}
  TJCEventType = (jceChuKu = 1,jceRuKu,jceTingChe,jceKaiChe,jceFileBegin,
    jceFileEnd,jceEnterStation=7,jceLeaveStation=8,jceDiaoCheStart=9,jceDiaoCheStop=10,
    jceChangeTrainman=11);

  {机车事件}
  RRSJCEvent = record
    {事件时间}
    etime: TDateTime;
    {乘务员工号}
    tmid1: string;
    {乘务员工号}
    tmid2: string;
    {TMIS站号}
    stmis: Integer;
    {车型}
    cx: string;
    {车号}
    ch: string;
    {车次}
    cc: string;
    {事件标志}
    sjbz: TJCEventType;
  end;

  PRSJCEvent = ^RRSJCEvent;

  {TZBEventType 整备场事件类型}
  TZBEventType = (zbAdd = 1{添加},zbDel{删除},zbEdit{修改});
  {TZBJCZTState 整备机车状态}
  TZBJCZTState = (jcsOther{其它},jcsChangBei{长备},jcsDuanBei{短备},jcsLinXiu{临修},
    jcsXiuCheng{修程},jcsZhengBei{整备},jcsDaiYong{待用});

  {RRSZhengBeiXX 整备信息}
  RRSZhengBeiXX = record
    {数据库记录ID}
    nid: Integer;
    {事件时间}
    etime: TDateTime;
    {站号}
    stmis: Integer;
    {车型}
    cx: string;
    {车号}
    ch: string;
    {事件类型}
    sjlx: TZBEventType;
    {股道号}
    gdh: string;
    {整备场标识}
    zbcbs: string;
    {机车状态}
    jczt: TZBJCZTState;
    {x坐标}
    xPos: Double;
    {y坐标}
    yPos: Double;
    {整备场宽度}
    cdkd: Integer;
    {整备场高度}
    cdgd: Integer;
  end;



  {功能:整备场信息转换为博飞整备场结构}
  function ZBCXXToBFZBCEvent(ZBCXX: RRSZhengBeiXX): RRSBFZhengBeiEvent;
  {功能:博飞人员事件转换为JSON}
  function BFCWYEventToJson(BFCWYEvent: RRSBFCWYEvent): string;
  {功能:博飞机车事件转换为JSON}
  function BFJCEventToJson(JCEvent: RRSBFJCEvent): string;
  {功能:博飞整备场事件转换为JSON}
  function BFZhengBeiEventToJson(BFZhengBeiEvent: RRSBFZhengBeiEvent): string;
  function OverWorkRecordToBFCWYEvent(DWH: string;OverWorkRecord: RRSOverWorkRecord): RRSBFCWYEvent;
  {功能:JSON转换为博飞机车事件}
  function JsonToBFJCEvent(strJson: string): RRSBFJCEvent;
const
  TZBJCZTStateArray : array[TZBJCZTState] of string =
    ('其它','长备','短备','临修','修程','整备','待用');
  TCWYEventTypeName : array[TCWYEventType] of string =
    ('入寓','离寓','验卡','出勤','退勤');

implementation
function OverWorkRecordToBFCWYEvent(DWH: string;OverWorkRecord: RRSOverWorkRecord): RRSBFCWYEvent;
begin
  Result.CQSJ := OverWorkRecord.dtBeginWorkTime;
  Result.CYSJ := OverWorkRecord.dtOutroomTime;
  Result.SJLX := Format('%.2d',[OverWorkRecord.sjbz]);
  Result.CJMS := OverWorkRecord.strRemark;
  Result.SJSJ := FormatDateTime('yyyyMMddhhnnss',Now);
  Result.SJLX := '01';
  Result.CJMS := OverWorkRecord.strRemark;
  Result.CX := OverWorkRecord.strTrainType;
  Result.CH := OverWorkRecord.strTrainNumber;
  Result.CC := OverWorkRecord.strCheCi;
  Result.DWH := DWH;

  Result.CWYID := OverWorkRecord.tmid;
  Result.CWYXM := OverWorkRecord.tmname;
  
  Result.tmtype := OverWorkRecord.tmtype;
  Result.kh := OverWorkRecord.kh;
  Result.outMinutes := OverWorkRecord.outMinutes;
  Result.alarmMinutes := OverWorkRecord.alarmMinutes;
end;
function ZBCXXToBFZBCEvent(ZBCXX: RRSZhengBeiXX): RRSBFZhengBeiEvent;
{功能:整备场信息转换为博飞整备场结构}
begin
  Result.SJSJ := FormatDateTime('YYYYMMDDHHNNSS',ZBCXX.etime);
  Result.ZBC_BS := ZBCXX.zbcbs;
  Result.CX := ZBCXX.cx;
  Result.CH := ZBCXX.ch;
  Result.GDH := ZBCXX.gdh;
  Result.JCZT := Format('%.2d',[Integer(ZBCXX.jczt)]);
  Result.SJLX := Format('%.2d',[Integer(ZBCXX.sjlx)]);
  Result.X := FloatToStr(ZBCXX.xPos);
  Result.Y := FloatToStr(ZBCXX.yPos);
  Result.CDKD := IntToStr(ZBCXX.cdkd);
  Result.CDGD := IntToStr(ZBCXX.cdgd);
end;
function JsonToBFJCEvent(strJson: string): RRSBFJCEvent;
var
  JSONObject : TlkJSONObject;
begin
  JSONObject := TlkJSON.ParseText(strJson) as TlkJSONobject;
  try
    Result.SJSJ := JSONObject.getString('SJSJ');
    Result.CWYID1 := JSONObject.getString('CWYID1');
    Result.CWYID2 := JSONObject.getString('CWYID2');
    Result.CC := JSONObject.getString('CC');
    Result.CX := JSONObject.getString('CX');
    Result.CH := JSONObject.getString('CH');
    Result.JLH := JSONObject.getString('JLH');
    Result.CZH := JSONObject.getString('CZH');
    Result.CZBZ := JSONObject.getString('CZBZ');
    Result.KH := JSONObject.getString('KH');
  finally
    JSONObject.Free;
  end;
end;


function BFZhengBeiEventToJson(BFZhengBeiEvent: RRSBFZhengBeiEvent): string;
var
  JSONObject : TlkJSONObject;
begin
  Result := '';
  JSONObject := TlkJSONobject.Create;
  try
    JSONObject.Add('SJBS',BFZhengBeiEvent.SJBS);
    JSONObject.Add('SJSJ',BFZhengBeiEvent.SJSJ);
    JSONObject.Add('ZBC_BS',BFZhengBeiEvent.ZBC_BS);
    JSONObject.Add('CX',BFZhengBeiEvent.CX);
    JSONObject.Add('CH',BFZhengBeiEvent.CH);
    JSONObject.Add('GDH',BFZhengBeiEvent.GDH);
    JSONObject.Add('JCZT',BFZhengBeiEvent.JCZT);
    JSONObject.Add('SJLX',BFZhengBeiEvent.SJLX);
    JSONObject.Add('JCX',BFZhengBeiEvent.X);
    JSONObject.Add('JCY',BFZhengBeiEvent.Y);
    JSONObject.Add('CDKD',BFZhengBeiEvent.CDKD);
    JSONObject.Add('CDGD',BFZhengBeiEvent.CDGD);
    Result := TlkJSON.GenerateText(JSONObject);

  finally
    JSONObject.Free;
  end;
end;
function BFCWYEventToJson(BFCWYEvent: RRSBFCWYEvent): string;
var
  JSONObject : TlkJSONObject;
begin
  Result := '';
  JSONObject := TlkJSONobject.Create;
  try
    JSONObject.Add('SJBS',BFCWYEvent.SJBS);
    JSONObject.Add('SJSJ',BFCWYEvent.SJSJ);
    JSONObject.Add('CWYID',BFCWYEvent.CWYID);
    JSONObject.Add('CWYXM',BFCWYEvent.CWYXM);
    JSONObject.Add('CQSJ',BFCWYEvent.CQSJ);
    JSONObject.Add('CYSJ',BFCWYEvent.CYSJ);
    JSONObject.Add('SJLX',BFCWYEvent.SJLX);
    JSONObject.Add('CJMS',BFCWYEvent.CJMS);
    JSONObject.Add('CX',BFCWYEvent.CX);
    JSONObject.Add('CH',BFCWYEvent.CH);
    JSONObject.Add('CC',BFCWYEvent.CC);
    JSONObject.Add('DWH',BFCWYEvent.DWH);

    JSONObject.Add('tmtype',BFCWYEvent.tmtype);
    JSONObject.Add('kh',BFCWYEvent.kh);
    JSONObject.Add('outMinutes',BFCWYEvent.outMinutes);
    JSONObject.Add('alarmMinutes',BFCWYEvent.alarmMinutes);
    
    Result := TlkJSON.GenerateText(JSONObject);

  finally
    JSONObject.Free;
  end;
end;

function BFJCEventToJson(JCEvent: RRSBFJCEvent): string;
var
  JSONObject : TlkJSONObject;
begin
  Result := '';
  JSONObject := TlkJSONobject.Create;
  try
    JSONObject.Add('SJBS',JCEvent.SJBS);
    JSONObject.Add('SJSJ',JCEvent.SJSJ);
    JSONObject.Add('CWYID1',JCEvent.CWYID1);
    JSONObject.Add('CWYID2',JCEvent.CWYID2);
    JSONObject.Add('CC',JCEvent.CC);
    JSONObject.Add('CX',JCEvent.CX);
    JSONObject.Add('CH',JCEvent.CH);
    JSONObject.Add('JLH',JCEvent.JLH);
    JSONObject.Add('CZH',JCEvent.CZH);
    JSONObject.Add('CZBZ',JCEvent.CZBZ);
    
    Result := TlkJSON.GenerateText(JSONObject);

  finally
    JSONObject.Free;
  end;
end;

{ RRsBFCtqEvent }

procedure RRsBFCtqEvent.SetTestResult(nRsTestResult: Integer);
begin
  case nRsTestResult of
    //taNormal
    0: CJJG := '1';
    //taAlcoholContentMiddling
    1: CJJG := '2';
    //taAlcoholContentHeight
    2: CJJG := '3';
    //taNoTest,//tsError
    3,4: CJJG := '0';
  end;
end;

function RRsBFCtqEvent.ToJSON: string;
//var
//  iJSON: ISuperObject;
//begin
//  iJSON := SO();
//  iJSON.S['SJBS'] := SJBS;
//  iJSON.S['SJSJ'] := SJSJ;
//  iJSON.S['DWH'] := DWH;
//  iJSON.S['CWYID'] := CWYID;
//  iJSON.S['CWYXM'] := CWYXM;
//  iJSON.S['CJJG'] := CJJG;
//  iJSON.S['SJLX'] := SJLX;
//  Result := iJSON.AsString;
//  iJSON := nil;
//end;

var
  JSONObject : TlkJSONObject;
begin
  Result := '';
  
  JSONObject := TlkJSONobject.Create;
  try
    JSONObject.Add('SJBS',SJBS);
    JSONObject.Add('SJSJ',SJSJ);
    JSONObject.Add('DWH',DWH);
    JSONObject.Add('CWYID',CWYID);
    
    JSONObject.Add('CWYXM',WideString(CWYXM));
    JSONObject.Add('CJJG',CJJG);
    JSONObject.Add('SJLX',SJLX);    
    Result := TlkJSON.GenerateText(JSONObject);
  finally
    JSONObject.Free;
  end;
end;

end.
