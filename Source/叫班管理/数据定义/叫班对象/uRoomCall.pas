unit uRoomCall;

interface
uses
  Classes,SysUtils,uTFSystem,Graphics,uSaftyEnum,superobject,uPubFun,Contnrs,
  DateUtils;
type

  {查询条件}
  RCallQryParams = record
  public
    //车次
    strTrainNo:string;
    //房间
    strRoomNum:string;
    //叫班开始时间
    dtStartCallTime:TDateTime;
    //叫班结束时间
    dtEndCallTime:TDateTime;
  end;

  //////////////////////////////////////////////////////////////////////////////
  //类名:TCallManPlan
  //描述:人员叫班计划
  //////////////////////////////////////////////////////////////////////////////
  TCallManPlan = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //人员叫班计划GUID
    strGUID:string;
    //候班计划guid
    strWaitPlanGUID:string;
    //叫班通知GUID
    strCallNotifyGUID:string;
    //人员guid
    strTrainmanGUID:string;
    //人员工号
    strTrainmanNumber:string;
    //人员姓名
    strTrainmanName:string;
    //行车计划guid
    strTrainPlanGUID:string;
    //行车车次
    strTrainNo:string;
    //叫班时间
    dtCallTime:TDateTime;
    //出勤时间
    dtChuQinTime:TDateTime;
    //入住房间
    strRoomNum:string;
    //首叫时间
    dtFirstCallTime:TDateTime;
    //催叫时间
    dtReCallTime:TDateTime;
    //计划状态
    ePlanState:TRoomCallState;
    //叫班内容
    strCallContent:string;
    //首叫次数
    nFirstCallTimes:Integer;
    //催叫次数
    nReCallTimes:Integer;
    //首叫结果
    eFirstCallResult:TRoomCallResult;
    //催叫结果
    eReCallResult:TRoomCallResult;


    //服务室号码
    strServerRoomNum:string;
    //服务室设备编号
    nServerDeviceID:Integer;
    //呼叫服务室时间
    dtServerRoomCallTime:TDateTime;
    //呼叫服务室的次数
    nServerRoomCallTryTimes:Integer;
    //呼叫服务室的结果
    eServerRoomCallResult:TRoomCallResult;

    //联交房间
    JoinRoomList:TStringList;
  public
    //拷贝构造函数
    procedure clone(callManPlan:TCallManPlan);
  end;

  //人员叫班计划数组
  TCallManPlanList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TCallManPlan;
    procedure SetItem(Index: Integer; AObject: TCallManPlan);
  public
    function Add(AObject: TCallManPlan): Integer;
    property Items[Index: Integer]: TCallManPlan read GetItem write SetItem; default;
    {功能:按照人员guid查找}
    function Find(strTrainmanGUID:string):TCallManPlan;

  end;


  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TCallRoomPlan
  /// 描述:房间叫班计划
  //////////////////////////////////////////////////////////////////////////////
  TCallRoomPlan = class
  public
    constructor Create();
    destructor Destroy();override;
    //拷贝构造函数
    procedure Clone(callRoomPlan:TCallRoomPlan);
  public
    //人员叫班计划数组
    manList:TCallManPlanList;
    //索引id
    nID:Integer;
    //房间
    strRoomNum:string;
    //候班计划
    strWaitPlanGUID:string;
    //行车计划
    strTrainPlanGUID:string;
    //车次
    strTrainNo:string;
    //创建时间
    dtCreateTime:TDateTime;
    //设备编号
    nDeviceID:Integer;
    //叫班时间
    dtStartCallTime:TDateTime;
    //出勤时间
    dtChuQinTime:TDateTime;
    //首叫时间
    dtFirstCallTime:TDateTime;
    //催叫时间
    dtReCallTime:TDateTime;

    //计划状态
    ePlanState:TRoomCallState;
    //首叫次数
    nFirstCallTimes:Integer;
    //催叫次数
    nReCallTimes:Integer;

    //首叫结果
    eFirstCallResult:TRoomCallResult;
    //催叫结果
    eReCallResult:TRoomCallResult;

    //服务室号码
    strServerRoomNum:string;
    //服务室设备编号
    nServerDeviceID:Integer;
    //呼叫服务室时间
    dtServerRoomCallTime:TDateTime;
    //呼叫服务室的次数
    nServerRoomCallTryTimes:Integer;
    //呼叫服务室的结果
    eServerRoomCallResult:TRoomCallResult;
  public
    {功能:根据人员叫班计划初始化}
    procedure Init(manPlan:TCallManPlan);
    {功能:判断是否开始首叫}
    function bNeedFirstCall(dtNow:TDateTime):Boolean;
    {功能:判断是否开始催叫}
    function bNeedReCall(dtNow:TDateTime;nRecallInterval:Integer):Boolean;
    {功能:判断是否开始服务室呼叫}
    function bNeedServerRoomCall(dtNow:TDateTime;nRecallInterval:Integer):Boolean;
    {功能:转换为json数据}
    function ToJsonStr():string;
    {功能:解析json数据}
    procedure FromJson(strJson:string);
  end;

  //房间叫班计划数组
  TCallRoomPlanList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TCallRoomPlan;
    procedure SetItem(Index: Integer; AObject: TCallRoomPlan);
  public
    function Add(AObject: TCallRoomPlan): Integer;
    property Items[Index: Integer]: TCallRoomPlan read GetItem write SetItem; default;
    {功能:按照房间车次查找}
    function FindByRoomTrainNo(strRoomNum,strTrainNo:string):TCallRoomPlan;
    
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///结构体名称:TCallManRecord
  ///描述:人员叫班记录
  //////////////////////////////////////////////////////////////////////////////
  TCallManRecord = class
  public
    //记录GUID
    strGUID:string;
    //叫班计划GUID
    strCallManPlanGUID:string;
    //候班计划GUID
    strWaitPlanGUID:string;
    //人员guid
    strTrainmanGUID:string;
    //人员工号
    strTrainmanNumber:string;
    //人员名称
    strTrainmanName:string;
    //记录创建时间
    dtCreateTime:TDateTime;
    //车次
    strTrainNo:string;
    //房间
    strRoomNum:string;
    //设备ID
    nDeviceID:Integer;
    //叫班结果
    eCallResult:TRoomCallResult;
    //尝试次数
    nConTryTimes:Integer;
    //计划出勤时间
    dtChuQinTime:TDateTime;
    //叫班时间
    dtCallTime:TDateTime;
    //叫班类型
    eCallState :TRoomCallState;
    //叫班方式
    eCallType:TRoomCallType;
    //值班员
    strDutyUser:string;
    //描述信息
    strMsg:string;
    //叫班发音内容
    strVoiceTxt:string;
    //语音记录GUID
    strCallVoiceGUID:string;

  public
    {功能:拷贝}
    procedure Clone(SCallManRecord:TCallManRecord);
    {功能:根据叫班计划进行初始化}
    procedure Init(RoomPlan:TCallRoomPlan; ManPlan:TCallManPlan;dtNow:TDateTime);
  end;

  {人员叫班记录数组}
  TCallManRecordList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TCallManRecord;
    procedure SetItem(Index: Integer; AObject: TCallManRecord);
  public
    function Add(AObject: TCallManRecord): Integer;
    property Items[Index: Integer]: TCallManRecord read GetItem write SetItem; default;
        {功能:拷贝}
    procedure Clone(CallManRecordList :TCallManRecordList);
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///结构体名称:TCallVoice
  ///描述:房间叫班语音
  //////////////////////////////////////////////////////////////////////////////
  TCallVoice = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //语音记录GUID
    strCallVoiceGUID:string;
    //语音文件
    vms:TMemoryStream;
    //创建时间
    dtCreateTime:TDateTime;
    //语音文件存储路径
    strFilePathName:string;
  end;




  //////////////////////////////////////////////////////////////////////////////
  ///结构体名称:TCallRoomRecord
  ///描述:房间叫班记录
  //////////////////////////////////////////////////////////////////////////////
  TCallRoomRecord = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //人员叫班记录列表
    CallManRecordList :TCallManRecordList;
    //叫班语音
    CallVoice:TCallVoice;
  private
    //房间叫班计划
    m_strCallPlanGUID:string;
    //公寓房间
    m_strRoomNum:string;
    //设备ID
    m_nDeviceID :Integer;
    //叫班时间
    m_dtCallTime:TDateTime;
    //尝试次数
    m_nConTryTimes:Integer;
    //消息
    m_strMsg:string;
    //叫班结果
    m_eCallResult:TRoomCallResult;
    //车次
    m_strTrainNo :string;
    //叫班类型
    m_eCallState :TRoomCallState;
    //叫班方式
    m_eCallType:TRoomCallType;
    //附加数据房间号
    m_strExternalRoomNumber:string;
    //联叫房间
    m_lstJoinRooms : TStringList;
  private
    procedure SetRoomNum(strRoomNum:string);
    procedure SetDeviceID(nDeviceID:Integer);
    procedure SetCallTime(dtCallTime:TDateTime);
    procedure SetConTryTimes(nConTryTimes:Integer);
    procedure SetStrMsg(strMsg:string);
    procedure SetCallResult(callResult:TRoomCallResult);
    procedure SetTrainNo(strTrainNo:string);
    procedure SetCallState(eCallState:TRoomCallState);
    procedure SetCallType(eCallType:TRoomCallType);
    procedure SetExternalRoomNumber(ExternalRoomNumber:string);
    procedure SetJoinRooms(Rooms: TStringList);
  public
    {功能:克隆}
    procedure Clone(s_CallRoomRecord:TCallRoomRecord);
    {功能:根据房间叫班计划进行初始化}
    procedure Init(RoomPlan:TCallRoomPlan;dtNow:TDateTime);
    {功能:生成录音文件名称}
    function CreateVoiceFileName():string;
    {功能:生成联叫房号}
    function CreateDeviceIDs():string;
    {功能：获取联交房间}
    procedure GetJoinRooms(Rooms:TStringList);
  public
    //叫班计划
    property strCallPlanGUID :string read m_strCallPlanGUID write m_strCallPlanGUID;

    //房间号
    property strRoomNum:string read m_strRoomNum write SetRoomNum;
    //设备ID
    property nDeviceID:Integer read m_nDeviceID write SetDeviceID;
    //叫班时间
    property dtCallTime:TDateTime read m_dtCallTime write SetCallTime;
    //连接尝试次数
    property nConTryTimes:Integer read m_nConTryTimes write SetConTryTimes;
    //消息
    property strMsg:string read m_strMsg write SetStrMsg;
    //叫班结果
    property eCallResult:TRoomCallResult read m_eCallResult write SetCallResult;
    //车次
    property strTrainNo :string read m_strTrainNo write SetTrainNo;
    //叫班类型
    property eCallState :TRoomCallState read m_eCallState write SetCallState;
    //叫班方式
    property eCallType:TRoomCallType read m_eCallType write SetCallType;
    //附加数据房间号
    property  strExternalRoomNumber:string read m_strExternalRoomNumber write m_strExternalRoomNumber;
    //联叫房间
    property  JoinRooms:TStringList read m_lstJoinRooms write SetJoinRooms;
  end;
  
  {叫班操作回调数据}
  TCallDevCallBackData= class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //房间叫班计划
    callRoomRecord:TCallRoomRecord;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///结构体名称:RCallDev
  ///描述:房间设备配置信息
  //////////////////////////////////////////////////////////////////////////////
  RCallDev= record
  public
    //guid
    strGUID:string;
    //房间编号
    strRoomNum:string;
    //设备编号
    nDevNum:Integer;
  public
    {功能:新建初始化}
    procedure New();
  end;
  PCallDev =  ^RCallDev;
  {房间设备配置信息数组}
  TCallDevAry = array of RCallDev;


  //////////////////////////////////////////////////////////////////////////////
  ///结构体名称:TServerRoomRelation
  ///描述:服务房间和房间的关系
  //////////////////////////////////////////////////////////////////////////////
  RServerRoomRelation= record
  public
    //guid
    strGUID:string;
    //房间编号
    strNumber:string;
    //设备编号
    strRoomNum:string;
  public
    {功能:新建初始化}
    procedure New();
  end;

  PServerRoomRelation =  ^RServerRoomRelation ;
    {房间设备配置信息数组}
  TServerRoomRelationAry = array of RServerRoomRelation;


implementation

uses
  StrUtils;

{ RRoomCall }
function TCallRoomPlan.bNeedReCall(dtNow:TDateTime;nRecallInterval:Integer):Boolean;
begin
  result := False;
  if self.nFirstCallTimes <=0 then Exit ;
  if Self.eReCallResult = TR_SUCESS then Exit;
  if self.nReCallTimes > 1 then Exit;

  if DateUtils.IncMinute(dtStartCallTime,nRecallInterval) <= dtNow  then
  begin
    result := True;
    Exit;
  end;

  {
  //未首叫,退出
  if Self.dtFirstCallTime <1 then Exit;

  if DateUtils.IncMinute(dtStartCallTime,nRecallInterval) <= dtNow  then
  begin
    result := True;
  end;   }
end;
function TCallRoomPlan.bNeedServerRoomCall(dtNow: TDateTime;
  nRecallInterval: Integer): Boolean;
begin
  result := False;
  if self.nReCallTimes <=0 then Exit ;
  if Self.eServerRoomCallResult = TR_SUCESS then Exit;
  if self.nServerRoomCallTryTimes > 1 then Exit;

  if DateUtils.IncMinute(dtReCallTime,1) <= dtNow  then
  begin
    result := True;
    Exit;
  end;

end;

procedure TCallRoomPlan.Clone(callRoomPlan: TCallRoomPlan);
var
  i:integer;
  callManPlan:TCallManPlan;
begin
  
  Self.manList.Clear;
  //人员叫班计划数组
  for i := 0 to callRoomPlan.manList.Count - 1 do
  begin
    callManPlan := TCallManPlan.Create;
    self.manList.Add(callManPlan);
    callManPlan.clone(callRoomPlan.manList.Items[i]);
  end;
  
  Self.nID:=Self.nID;
  Self.strRoomNum:= callRoomPlan.strRoomNum;
  Self.strWaitPlanGUID:= callRoomPlan.strWaitPlanGUID;
  Self.strTrainPlanGUID:= callRoomPlan.strTrainPlanGUID;
  Self.strTrainNo:= callRoomPlan.strTrainNo;
  Self.dtCreateTime:= callRoomPlan.dtCreateTime;
  Self.nDeviceID:= callRoomPlan.nDeviceID;
  Self.dtStartCallTime:= callRoomPlan.dtStartCallTime;
  Self.dtChuQinTime:= callRoomPlan.dtChuQinTime;
  Self.dtFirstCallTime:= callRoomPlan.dtFirstCallTime;
  Self.dtReCallTime:= callRoomPlan.dtReCallTime;
  Self.ePlanState:=callRoomPlan.ePlanState;
  Self.nFirstCallTimes:= callRoomPlan.nFirstCallTimes ;
  Self.nReCallTimes:= callRoomPlan.nReCallTimes ;
  Self.eFirstCallResult:= callRoomPlan.eFirstCallResult ;
  Self.eReCallResult:= callRoomPlan.eReCallResult ;


  self.strServerRoomNum  := callRoomPlan.strServerRoomNum ;
  Self.nServerDeviceID := callRoomPlan.nServerDeviceID ;
  Self.dtServerRoomCallTime:= callRoomPlan.dtServerRoomCallTime ;
  Self.nServerRoomCallTryTimes:= callRoomPlan.nServerRoomCallTryTimes ;
  Self.eServerRoomCallResult:= callRoomPlan.eServerRoomCallResult ;

end;

constructor TCallRoomPlan.Create;
begin
  manList:=TCallManPlanList.Create;
end;

destructor TCallRoomPlan.Destroy;
begin
  manList.Free;
  inherited;
end;

procedure TCallRoomPlan.FromJson(strJson: string);
begin

end;



procedure TCallRoomPlan.Init(manPlan: TCallManPlan);
begin
  Self.strTrainPlanGUID := manPlan.strTrainPlanGUID;
  self.strWaitPlanGUID := manPlan.strWaitPlanGUID;
  self.strRoomNum := manPlan.strRoomNum;
  self.strTrainNo := manPlan.strTrainNo;
  self.dtStartCallTime := manPlan.dtCallTime;
  self.dtChuQinTime := manPlan.dtChuQinTime;
  self.dtFirstCallTime:= manPlan.dtFirstCallTime;
  self.dtReCallTime:=manPlan.dtReCallTime;
  self.ePlanState := manPlan.ePlanState;
  self.nFirstCallTimes := manPlan.nFirstCallTimes;
  Self.nReCallTimes := manPlan.nReCallTimes;
  self.eFirstCallResult := manPlan.eFirstCallResult;
  self.eReCallResult := manPlan.eReCallResult;

  Self.strServerRoomNum := manPlan.strServerRoomNum;
  self.nServerDeviceID :=  manPlan.nServerDeviceID ;
  Self.dtServerRoomCallTime := manPlan.dtServerRoomCallTime ;
  Self.nServerRoomCallTryTimes := manPlan.nServerRoomCallTryTimes;
  self.eServerRoomCallResult := manPlan.eServerRoomCallResult;
end;


function TCallRoomPlan.bNeedFirstCall(dtNow:TDateTime): Boolean;
begin
  //result := True ;Exit;
  result := False;
  if Self.eFirstCallResult = TR_SUCESS then Exit;
  if self.nFirstCallTimes > 0 then Exit;

  if dtStartCallTime <= dtNow  then
  begin
    result := True;
    Exit;
  end;
  {
  
  //已首叫
  if Self.dtFirstCallTime > 1 then Exit;

  if dtStartCallTime <= dtNow  then
  begin
    result := True;
  end;}

end;


function TCallRoomPlan.ToJsonStr: string;
var
  iJson:ISuperObject;
begin
  iJson := so();
    //房间号
  iJson.S['strRoomNum'] := strRoomNum;
    //索引id
  iJson.I['nID'] := nID;
    //设备编号
  iJson.I['nDeviceID'] := nDeviceID;
end;

{ RRoomDev }

procedure RCallDev.New;
begin
  strGUID := NewGUID();
end;



{ TCallDevCallBackData }

constructor TCallDevCallBackData.Create;
begin
  callRoomRecord:=TCallRoomRecord.Create;
end;

destructor TCallDevCallBackData.Destroy;
begin
  callRoomRecord.Free;
  inherited;
end;

{ TCallManPlanList }

function TCallManPlanList.Add(AObject: TCallManPlan): Integer;
begin
  result := inherited Add(AObject);
end;

procedure TCallManRecordList.Clone(CallManRecordList: TCallManRecordList);
var
  i:Integer;
  callManRecord:TCallManRecord;
begin
  self.clear;
  for i := 0 to CallManRecordList.Count - 1 do
  begin
    callManRecord:=TCallManRecord.Create;
    callManRecord.Clone(CallManRecordList.Items[i]);
    self.Add(callManRecord) ;
  end;
end;

function TCallManPlanList.Find(strTrainmanGUID: string): TCallManPlan;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to self.Count - 1 do
  begin
    if self.Items[i].strTrainmanGUID = strTrainmanGUID then
    begin
      result := self.Items[i];
      Exit;
    end;
  end;
end;

function TCallManPlanList.GetItem(Index: Integer): TCallManPlan;
begin
  Result := TCallManPlan(inherited GetItem(Index));
end;

procedure TCallManPlanList.SetItem(Index: Integer; AObject: TCallManPlan);
begin
  inherited SetItem(Index,AObject);
end;

{ TCallRoomPlanList }

function TCallRoomPlanList.Add(AObject: TCallRoomPlan): Integer;
begin
  Result := inherited Add(AObject);
end;



function TCallRoomPlanList.FindByRoomTrainNo(strRoomNum,strTrainNo:string): TCallRoomPlan;
var
  i:Integer;
begin
  result := nil;
  for I := 0 to Self.Count - 1 do
  begin
    if self.Items[i].strRoomNum = strRoomNum then
    begin
      if self.Items[i].strTrainNo = strTrainNo then
      begin
        result := self.Items[i];
        Exit;
      end;
    end;
  end;
    
end;

function TCallRoomPlanList.GetItem(Index: Integer): TCallRoomPlan;
begin
  result := TCallRoomPlan(inherited GetItem(Index));
end;

procedure TCallRoomPlanList.SetItem(Index: Integer; AObject: TCallRoomPlan);
begin
  inherited SetItem(Index,AObject);
end;

{ TCallVoice }

constructor TCallVoice.Create;
begin
  //vms:=TMemoryStream.Create;
end;

destructor TCallVoice.Destroy;
begin
  FreeAndNil(vms);
  inherited;
end;


{ TRoomCallRecord }

procedure TCallRoomRecord.Clone(s_CallRoomRecord: TCallRoomRecord);
begin
      //房间
    Self.strRoomNum:=s_CallRoomRecord.strRoomNum;
    //叫班设备ID
    self.nDeviceID:=s_CallRoomRecord.nDeviceID;
    //叫班时间
    self.dtCallTime:=s_CallRoomRecord.dtCallTime;
    //
    self.nConTryTimes := s_CallRoomRecord.nConTryTimes;
    self.eCallResult := s_CallRoomRecord.eCallResult;
    self.strMsg := s_CallRoomRecord.strMsg;
    self.strCallPlanGUID := s_CallRoomRecord.strCallPlanGUID;
    self.strRoomNum := s_CallRoomRecord. strRoomNum;
    self.strMsg := s_CallRoomRecord.strMsg;
    self.strTrainNo := s_CallRoomRecord.strTrainNo;
    self.eCallState := s_CallRoomRecord.eCallState;
    self.eCallType := s_CallRoomRecord.eCallType;

    Self.strExternalRoomNumber :=s_CallRoomRecord.strExternalRoomNumber ;

    Self.m_lstJoinRooms.Assign( s_CallRoomRecord.m_lstJoinRooms );

//    Self.dtServerRoomCallTime:= s_CallRoomRecord.dtServerRoomCallTime ;
//    Self.nServerRoomCallTryTimes:= s_CallRoomRecord.nServerRoomCallTryTimes ;
//    Self.eServerRoomCallResult:= s_CallRoomRecord.eServerRoomCallResult ;


    //人员叫班记录列表
    CallManRecordList.clone(s_CallRoomRecord.CallManRecordList);
end;

constructor TCallRoomRecord.Create;
begin
  m_lstJoinRooms := TStringList.Create;
   CallManRecordList :=TCallManRecordList.Create;
end;

function TCallRoomRecord.CreateDeviceIDs: string;
var
  i : Integer ;
  strTemp,strText:string ;
  strRoom:string;
  nPos,nDeviceID:Integer;
begin
  //主叫房间号
  strText := IntToStr( m_nDeviceID );
  for I := 0 to m_lstJoinRooms.Count - 1 do
  begin
    strTemp := m_lstJoinRooms.Strings[i];
    nPos := Pos('=',strTemp);
    strRoom  := LeftStr(strTemp,nPos-1);
    nDeviceID := StrToInt( RightStr(strTemp,Length(strTemp) - nPos ) );
    strText := strText + IntToStr(nDeviceID);
  end;
  Result := strText ;
end;

function TCallRoomRecord.CreateVoiceFileName: string;
var
  strTMInfo:string;
  i:Integer;
begin
  for I := 0 to Self.CallManRecordList.Count - 1 do
  begin
    strTMInfo := strTMInfo + Format('%s[%s]',[CallManRecordList.Items[i].strTrainmanName,
      CallManRecordList.Items[i].strTrainmanNumber]);
  end;
  result := Self.m_strRoomNum + FormatDateTime('yy-MM-dd_HH_nn',Self.dtCallTime) + '_' + strTMInfo + '.wav';
end;

destructor TCallRoomRecord.Destroy;
begin
  m_lstJoinRooms.Free ;
  CallManRecordList.Free;
  if CallVoice <> nil then
    CallVoice.Free;
  inherited;
end;


procedure TCallRoomRecord.GetJoinRooms(Rooms: TStringList);
var
  i : Integer ;
  strTemp:string ;
  strRoom:string;
  nPos:Integer;
begin
//  //主叫房间号
//  Rooms.Add(m_strRoomNum);
  //添加联交房间
  for I := 0 to m_lstJoinRooms.Count - 1 do
  begin
    strTemp := m_lstJoinRooms.Strings[i];
    nPos := Pos('=',strTemp);
    strRoom  := LeftStr(strTemp,nPos-1);
    Rooms.Add(strRoom);
  end;
end;

procedure TCallRoomRecord.Init(RoomPlan: TCallRoomPlan;dtNow:TDateTime);
var
  i:Integer;
  manRecord:TCallManRecord;
begin
  for i := 0 to RoomPlan.manList.Count - 1 do
  begin
    manRecord := TCallManRecord.Create;
    manRecord.Init(RoomPlan,RoomPlan.manList.Items[i],dtNow);
    Self.CallManRecordList.Add(manRecord)
  end;
//  //无人员计划
//  if roomPlan.manList.Count = 0 then
//  begin
//    manRecord := TCallManRecord.Create;
//    manRecord.strTrainNo := RoomPlan.strTrainNo;
//    manRecord.strRoomNum := RoomPlan.strRoomNum;
//    Self.CallManRecordList.Add(manRecord)
//  end;
  self.m_strRoomNum := RoomPlan.strRoomNum;
  self.m_strTrainNo := RoomPlan.strTrainNo;
  self.m_dtCallTime := dtNow;
    
end;

procedure TCallRoomRecord.SetCallResult(callResult: TRoomCallResult);
var
  i:Integer;
begin
  Self.m_eCallResult := callResult;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].eCallResult := callResult;
  end;
end;

procedure TCallRoomRecord.SetCallTime(dtCallTime: TDateTime);
var
  i:Integer;
begin
  Self.m_dtCallTime := dtCallTime;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].dtCallTime := dtCallTime;
  end;
end;

procedure TCallRoomRecord.SetConTryTimes(nConTryTimes: Integer);
var
  i:Integer;
begin
  Self.m_nConTryTimes := nConTryTimes;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].nConTryTimes := nConTryTimes;
  end;
end;

procedure TCallRoomRecord.SetDeviceID(nDeviceID: Integer);
var
  i:Integer;
begin
  Self.m_nDeviceID := nDeviceID;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].nDeviceID := nDeviceID;
  end;
end;

procedure TCallRoomRecord.SetExternalRoomNumber(ExternalRoomNumber: string);
var
  i:Integer;
begin
  Self.m_strExternalRoomNumber := ExternalRoomNumber;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].strRoomNum := ExternalRoomNumber;
  end;
end;

procedure TCallRoomRecord.SetJoinRooms(Rooms: TStringList);
begin
  m_lstJoinRooms.Assign( Rooms );
end;

procedure TCallRoomRecord.SetRoomNum(strRoomNum: string);
var
  i:Integer;
begin
  Self.m_strRoomNum := strRoomNum;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].strRoomNum := strRoomNum;
  end;
end;

procedure TCallRoomRecord.SetStrMsg(strMsg: string);
var
  i:Integer;
begin
  Self.m_strMsg := strMsg;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].strMsg := strMsg;
  end;
end;

procedure TCallRoomRecord.SetTrainNo(strTrainNo: string);
var
  i:Integer;
begin
  self.m_strTrainNo := strTrainNo;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].strTrainNo := strTrainNo;
  end;
end;
procedure TCallRoomRecord.SetCallState(eCallState:TRoomCallState);
var
  i:Integer;
begin
  self.m_eCallState := eCallState;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].eCallState := eCallState;
  end;
end;

procedure TCallRoomRecord.SetCallType(eCallType:TRoomCallType);
var
  i:Integer;
begin
  self.m_eCallType := eCallType;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].eCallType := eCallType;
  end;
end;
{ TCallManRecordList }

function TCallManRecordList.Add(AObject: TCallManRecord): Integer;
begin
  result := inherited Add(AObject);
end;

function TCallManRecordList.GetItem(Index: Integer): TCallManRecord;
begin
  result := TCallManRecord(inherited GetItem(Index));
end;

procedure TCallManRecordList.SetItem(Index: Integer; AObject: TCallManRecord);
begin
  inherited SetItem(Index,AObject);
end;

procedure TCallManRecord.Clone(SCallManRecord: TCallManRecord);
begin
   //记录GUID
    strGUID:=SCallManRecord.strGUID;
    //叫班计划GUID
    strCallManPlanGUID:=SCallManRecord.strCallManPlanGUID;
    //候班计划GUID
    strWaitPlanGUID := SCallManRecord.strWaitPlanGUID;
    //人员GUID
    strTrainmanGUID:=SCallManRecord.strTrainmanGUID;
    //人员工号
    strTrainmanNumber:=SCallManRecord.strTrainmanNumber;
    //人员名称
    strTrainmanName:=SCallManRecord.strTrainmanName;
    //记录创建时间
    dtCreateTime:=SCallManRecord.dtCreateTime;
    //车次
    strTrainNo:=SCallManRecord.strTrainNo;
    //房间
    strRoomNum:=SCallManRecord.strRoomNum;
    //设备ID
    nDeviceID:=SCallManRecord.nDeviceID;
    //叫班结果
    eCallResult:=SCallManRecord.eCallResult;
    //尝试次数
    nConTryTimes:=SCallManRecord.nConTryTimes;
    //计划出勤时间
    dtChuQinTime:=SCallManRecord.dtChuQinTime;
    //叫班时间
    dtCallTime:=SCallManRecord.dtCallTime;
    //叫班类型
    eCallState :=SCallManRecord.eCallState;
    //叫班方式
    eCallType:=SCallManRecord.eCallType;
    //值班员
    strDutyUser:=SCallManRecord.strDutyUser;
    //描述信息
    strMsg:=SCallManRecord.strMsg;
    //叫班发音内容
    strVoiceTxt:=SCallManRecord.strVoiceTxt;
end;

procedure TCallManRecord.Init(RoomPlan:TCallRoomPlan; ManPlan:TCallManPlan;dtNow:TDateTime);
begin
  //记录GUID
    strGUID:= NewGUID;;

    //叫班计划GUID 
    strCallManPlanGUID:= ManPlan.strGUID;
    //候班计划GUID
    strWaitPlanGUID:= ManPlan.strWaitPlanGUID;
    //人员guid
    strTrainmanGUID:=ManPlan.strTrainmanGUID;
    //人员工号
    strTrainmanNumber:= ManPlan.strTrainmanNumber;
    //人员名称
    strTrainmanName:= ManPlan.strTrainmanName;
    //记录创建时间
    dtCreateTime:= dtNow;
    //车次
    strTrainNo:= ManPlan.strTrainNo;
    //房间
    strRoomNum:= ManPlan.strRoomNum;
    //设备ID
    nDeviceID:=RoomPlan.nDeviceID;
    //计划出勤时间
    dtChuQinTime:= ManPlan.dtChuQinTime;
    //叫班时间
    dtCallTime:= ManPlan.dtCallTime;
    //叫班内容
    strVoiceTxt:= ManPlan.strCallContent;

    if ManPlan.ePlanState >= TCS_FIRSTCALL then
      eCallState := TCS_RECALL;
    if ManPlan.ePlanState = TCS_Publish then
      eCallState := TCS_FIRSTCALL;
end;

{ TCallManPlan }

procedure TCallManPlan.clone(callManPlan: TCallManPlan);
begin
  self.strGUID:= callManPlan.strGUID;
  self.strWaitPlanGUID:= callManPlan.strWaitPlanGUID;
  self.strCallNotifyGUID:= callManPlan.strCallNotifyGUID;
  self.strTrainmanGUID:= callManPlan.strTrainmanGUID ;
  self.strTrainmanNumber:= callManPlan.strTrainmanNumber;
  self.strTrainmanName:= callManPlan.strTrainmanName  ;
  self.strTrainPlanGUID:= callManPlan.strTrainPlanGUID ;
  self.strTrainNo:= callManPlan.strTrainNo     ;
  self.dtCallTime:= callManPlan.dtCallTime     ;
  self.dtChuQinTime:= callManPlan.dtChuQinTime  ;
  self.strRoomNum:= callManPlan.strRoomNum        ;
  self.dtFirstCallTime:= callManPlan.dtFirstCallTime   ;
  self.dtReCallTime:= callManPlan.dtReCallTime   ;
  self.ePlanState:=callManPlan.ePlanState       ;
  self.strCallContent:= callManPlan.strCallContent  ;
  
  Self.nFirstCallTimes:= callManPlan.nFirstCallTimes ;
  Self.nReCallTimes:= callManPlan.nReCallTimes ;
  Self.eFirstCallResult:= callManPlan.eFirstCallResult ;
  Self.eReCallResult:= callManPlan.eReCallResult ;

  Self.strServerRoomNum := callManPlan.strServerRoomNum;
  //服务室设备编号
  Self.nServerDeviceID:= callManPlan.nServerDeviceID;
  //呼叫服务室时间
  Self.dtServerRoomCallTime:= callManPlan.dtServerRoomCallTime;
  //呼叫服务室的次数
  Self.nServerRoomCallTryTimes:= callManPlan.nServerRoomCallTryTimes;
  //呼叫服务室的结果
  Self.eServerRoomCallResult:= callManPlan.eServerRoomCallResult;

  //联叫
  self.JoinRoomList.Assign( callManPlan.JoinRoomList );
end;

constructor TCallManPlan.Create;
begin
  JoinRoomList:=TStringList.Create;
end;

destructor TCallManPlan.Destroy;
begin
  JoinRoomList.Free ;
  inherited;
end;

{ RServerRoomRelation }

procedure RServerRoomRelation.New;
begin
  strGUID := NewGUID();
end;

end.
