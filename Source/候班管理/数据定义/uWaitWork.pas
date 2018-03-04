unit uWaitWork;

interface
uses
  Classes,SysUtils,Contnrs,uSaftyEnum,uTFSystem,superobject,uPubFun,uTrainman,
  StrUtils,uDutyUser,uSite,uTrainPlan,uWorkShop,Graphics,uSignPlan;
type

  TWaitWorkPlanType =(TWWPT_ASSIGN{派班},TWWPT_SIGN{签点},TWWPT_LOCAL{本地});

  TInOutRoomType = (TInRoom{入公寓},TOutRoom{出公寓}) ;

  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TSyncPlanIDInfo
  /// 描述:待同步待乘计划ID以及计划类型信息
  //////////////////////////////////////////////////////////////////////////////
  TSyncPlanIDInfo = class
    //计划GUID
    strPlanGUID:string;
    //计划类别
    ePlanType: TWaitWorkPlanType;
  end;

  {待同步待乘计划 id,类型信息列表}
  TSyncPlanIDInfoList  = class(TObjectList)
  protected
    function GetItem(Index: Integer): TSyncPlanIDInfo;
    procedure SetItem(Index: Integer; AObject: TSyncPlanIDInfo);
  public
    function Add(AObject: TSyncPlanIDInfo): Integer;
    property Items[Index: Integer]: TSyncPlanIDInfo read GetItem write SetItem; default;
  end;

  TWaitWorkPlan = class ;

  /////////////////////////////////////////////////////////////////////////////
  ///结构体名:RRSInOutRoomInfo
  ///描述:乘务员出入公寓信息
  /////////////////////////////////////////////////////////////////////////////
  RRSInOutRoomInfo= record
  public
    //记录GUID
    strGUID:string;
    //入寓记录GUID
    strInRoomGUID:string;
    //行车计划GUID
    strTrainPlanGUID  :string;
    //候班计划GUID
    strWaitPlanGUID:string;
    //出入公寓时间
    dtInOutRoomTime:TDateTime;
    //身份验证类型
    eVerifyType :TRsRegisterFlag;
    //值班员GUID
    strDutyUserGUID:string;
    //司机GUID
    strTrainmanGUID:string;
    //司机工号
    strTrainmanNumber:string;
    //司机姓名
    strTrainmanName:string;
    //记录创建时间
    dtCreatetTime  :TDateTime;
    //客户端guid
    strSiteGUID  :string;
    //房间号
    strRoomNumber :string;
    //床位号
    nBedNumber :Integer;
    //是否同步
    bUploaded:Boolean;
    //候班计划类型
    eWaitPlanType:TWaitWorkPlanType;
    //候班时间
    dtArriveTime:TDateTime;
    //叫班时间
    dtCallTime:TDateTime;
    //出入公寓类别
    eInOutType:TInOutRoomType;
  public
    {功能:转换为json数据}
    function ToJsonStr(inOutType:TInOutRoomType):string;
    {功能:设置值}
    procedure SetValue(waitPlan:TWaitWorkPlan;trainman:RRsTrainman;dtNow:TDateTime;
        eVerifyType :TRsRegisterFlag;eInOutType:TInOutRoomType;dutyUser:TRsDutyUser;
        siteInfo:TRsSiteInfo);

  end;
  //出入公寓信息数组
  RRsInOutRoomInfoArray= array of RRSInOutRoomInfo;


  (*
  //////////////////////////////////////////////////////////////////////////////
  ///类名:TInOutRoomInfo
  ///描述:人员出入公寓信息
  //////////////////////////////////////////////////////////////////////////////
  TInOutRoomInfo = class
  public
    {功能:设置值}
    procedure SetValues(strGUID,strPlanGUID,strTrainmanGUID:string;
        eType:TInOutRoomType;dtTime:TDateTime;dtArriveTime:TDateTime;ePlanType:TWaitWorkPlanType);
    {功能:重置}
    procedure Reset();
       {功能:转换为JSON对象}
    function ToJsonStr():string;

  public
    //记录GUID
    strGUID:string;
    //候班计划GUID
    strPlanGUID:string;
    //人员GUID
    strTrainmanGUID:string;
    //出入公寓类型
    eType:TInOutRoomType;
    //出入公寓时间
    dtTime:TDateTime;
    //候班时间
    dtArriveTime:TDateTime;
    // 是否上传
    bUpload :Boolean;
    //计划类型
    ePlanType:TWaitWorkPlanType;
  end;
  *)

  (*
  //////////////////////////////////////////////////////////////////////////////
  ///类名:TInOutRoomInfoList
  ///描述:人员出入公寓信息列表
  //////////////////////////////////////////////////////////////////////////////
  TInOutRoomInfoList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TInOutRoomInfo;
    procedure SetItem(Index: Integer; AObject: TInOutRoomInfo);
  public
    function Add(AObject: TInOutRoomInfo): Integer;
    property Items[Index: Integer]: TInOutRoomInfo read GetItem write SetItem; default;
    {功能:转换为json串}
    function ToJsonStr():string;

  end;
  *)
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:RWaitTime
  /// 描述:候班时刻表记录
  ///  /////////////////////////////////////////////////////////////////////////
  RWaitTime = record
    //记录GUID
    strGUID:string;
    //车间GUID
    strWorkshopGUID:string;
    //车间名称
    strWorkShopName:string;
    //交路GUID
    strTrainJiaoLuGUID:string;
    //交路名称
    strTrainJiaoLuName:string;
    //交路别名
    strTrainJiaoLuNickName:string;
    //车次
    strTrainNo:string;
    //房间号
    strRoomNum:string;
    //候班时间
    dtWaitTime:TDateTime;
    //叫班时间
    dtCallTime:TDateTime;
    //出勤时间
    dtChuQinTime:TDateTime;
    //开车时间
    dtKaiCheTime: TDateTime;
    //强休
    bMustSleep:Boolean;
  public
    {功能:初始化}
    procedure New();
  end;

  {候班房间时刻表}
  TWaitTimeAry = array of RWaitTime;
  //////////////////////////////////////////////////////////////////////////////
  ///类名:TWaitWorkTrainmanInfo
  ///描述:人员候班计划信息
  //////////////////////////////////////////////////////////////////////////////
  TWaitWorkTrainmanInfo = class
  public
    constructor Create();
    destructor Destroy();override;
    //拷贝构造函数
    procedure Clone(tmInfo:TWaitWorkTrainmanInfo);
  public
    //序号
    nIndex:Integer;
    //记录guid
    strGUID:string;
    //计划guid
    strPlanGUID:string;
    //人员GUID
    strTrainmanGUID:string;
    //人员工号
    strTrainmanNumber:string;
    //人员姓名
    strTrainmanName:string;
    //计划状态
    eTMState:TRsPlanState;
    //叫班状态
    //eCallState:TRoomCallState;
    //实际房间
    strRealRoom:string;
    //首叫时间
    dtFirstCallTime:TDateTime;
    //是否成功叫班
    bCallSucess:Boolean;
    //入寓记录
    InRoomInfo:RRSInOutRoomInfo;
    //出公寓记录
    OutRoomInfo:RRSInOutRoomInfo;
  public
    {功能:获取状态}
    function GetStateStr():string;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///类名:TWaitWorkTrainmanList
  ///描述:人员候班计划信息
  //////////////////////////////////////////////////////////////////////////////
  TWaitWorkTrainmanInfoList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TWaitWorkTrainmanInfo;
    procedure SetItem(Index: Integer; AObject: TWaitWorkTrainmanInfo);
  public
    {功能:查找人员}
    function findTrainman(strTrainmanGUID:string): TWaitWorkTrainmanInfo;
    {功能:查找人员按照工号}
    function FindTrainman_GH(strGH:string):TWaitWorkTrainmanInfo;
    {功能:查找人员按照工号}
    function FindTrainman_Name(Name:string):TWaitWorkTrainmanInfo;
    {功能:找到第一个空缺人员}
    function FindEmptyTrainman():TWaitWorkTrainmanInfo;
    function Add(AObject: TWaitWorkTrainmanInfo): Integer;
    property Items[Index: Integer]: TWaitWorkTrainmanInfo read GetItem write SetItem; default;
  end;


  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  ///  类名：TInRoomWorkPlan
  ///  描述：入寓计划
  //////////////////////////////////////////////////////////////////////////////
  TInRoomWorkPlan = class
  public
    constructor Create();
    destructor Destroy();override;
    //拷贝构造函数
  public
    procedure Clear();
  public
    strPlanGUID:string;
    //车次
    strCheCi:string;
    //房间号
    strRoomNum:string;
    //候班时间
    dtWaitWorkTime:TDateTime;
    //叫班时间
    dtCallWorkTime:TDateTime;
    //类型
    ePlanType:TWaitWorkPlanType;
    //需要同步叫班
    bNeedSyncCall:Boolean;
    bNeedRest:Boolean;
    //人员计划列表
    Trainman : RRsTrainman;
    //联交房间
    JoinRoomList:TStringList;
  end;

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  ///  类名：TWaitWorkPlan
  ///  描述：候班计划
  //////////////////////////////////////////////////////////////////////////////
  TWaitWorkPlan = class
  public
    constructor Create();
    destructor Destroy();override;
    //拷贝构造函数
    procedure Clone(waitWorkPlan:TWaitWorkPlan);
  public
    //序号
    nIndex:Integer;
    //候班计划GUID
    strPlanGUID:string;
    //签点计划GUID
    strSignPlanGUID:string;
    //车间GUID
    strCheJianGUID:string;
    //车间名称
    strCheJianName:string;
    //交路GUID
    strTrainJiaoLuGUID:string;
    //交路名称
    strTrainJiaoLuName:string;
    //交路简称
    strTrainJiaoLuNickName:string;
    //是否强休
    bNeedRest:Boolean;
    //计划状态
    ePlanState: TRsPlanState;
    //车次
    strCheCi:string;
    //候班时间
    dtWaitWorkTime:TDateTime;
    //叫班时间
    dtCallWorkTime:TDateTime;
    //开车时间
    dtKaiCheTime : TDateTime ;
    //房间号
    strRoomNum:string;
    //类型
    ePlanType:TWaitWorkPlanType;
    //需要同步叫班
    bNeedSyncCall:Boolean;
    //人员计划列表
    tmPlanList : TWaitWorkTrainmanInfoList;
    //未离寓提醒时间
    dtNotifyUnLeaveTime:TDateTime;
    //联交
    JoinRoomList:TStringList;
  public
    {功能:获取所有入住房间字符串}
    function GetAllRoomNumStr():string;
    {功能:判断人员是否入住相同的房间}
    function tmInSameRoom():Boolean;
    {功能:获取实际人员数量}
    function GetTrainmanCount():Integer;
    {功能:获取已入寓人员数量}
    function GetInRoomTrainmanCount():Integer;
    {功能:获取未出寓人员总数}
    function GetUnOutRoomTrainmanCount():Integer;
    {功能:判断是否都已出公寓}
    function bAllOutRoom():Boolean;
    {功能:判断是否都已入寓}
    function bAllInRoom():Boolean;
    {功能:更新计划状态}
    procedure UpdatePlanState();
    {功能:增加人员入寓计划}
    function AddTrainman(Trainman:RRsTrainman;var strResult:string):TWaitWorkTrainmanInfo;
    {功能:增加人员}
    procedure AddNewTrianman(strGUID,strNumber,strName:string);
    {功能:获取状态文字}
    function GetStateStr():string;
    {功能:根据行车计划构造}
    procedure CreateByTrainmanPlan(trainmanPlan:RRSTrainmanPlan;workShop:RRSWorkShop);
    {功能:根据签点计划构造}
    procedure CreateBySignPlan(signPlan:TSignPlan;workShop:RRsWorkShop);
    {功能:根据图钉候班表记录构造}
    procedure CreateByWaitTime(waitTime:RWaitTime);

    {功能:判断是否所有人员都更更换到另外一个房间}
    function bAllChanged2OtherRoom(waitMan:TWaitWorkTrainmanInfo):Boolean;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  类名：TWaitWorkPlanList
  ///  描述：候班计划列表
  //////////////////////////////////////////////////////////////////////////////
  TWaitWorkPlanList = class(TObjectList)

  protected
    function GetItem(Index: Integer): TWaitWorkPlan;
    procedure SetItem(Index: Integer; AObject: TWaitWorkPlan);
  public
    {功能:根据计划id查找计划}
    function Find(strPlanGUID:string):TWaitWorkPlan;
    {功能:根据房间号查找对象}
    function FindByRoomNum(strRoomNum:string):TWaitWorkPlan;
    {功能:查找根据车次}
    function findByCheCi(strCheCi:string):TWaitWorkPlan;
    {功能:获取候班记录总数}
    function GetRecordCount():Integer;

    property Items[Index: Integer]: TWaitWorkPlan read GetItem write SetItem; default;
    function Add(AObject: TWaitWorkPlan): Integer;
    {功能:获取指定类型计划个数}
    procedure GetPlanCount_Type(planType:TWaitWorkPlanType;var nPlanCount,nTrainmanCount:Integer);
    {功能:删除指定类型的计划}
    procedure DelPlan_ByType(planType:TWaitWorkPlanType);
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  类名:TWaitRoom
  ///  描述:待乘房间信息
  //////////////////////////////////////////////////////////////////////////////
  TWaitRoom = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //房间号
    strRoomNum:string;
    //待乘人员列表
    waitManList:TWaitWorkTrainmanInfoList;
  private
    function GetFloorNum():string;
  public
    //获取楼层号
    property FloorNum:string read GetFloorNum;
  end;

  //床位信息
  RRsBedInfo = record
    strRoomNumber:string;
    dtInRoomTime:TDateTime;
    strTrainmanGUID:string;
    strTrainmanName:string;
    strTrainmanNumber:string;
    nBedNumber:Integer;
  end;
  
  RRsBedInfoPointer = ^RRsBedInfo  ;
  TRsBedInfoList = array [0..2]  of  RRsBedInfo ;
    //房间信息
  RRsRoomInfo = record
    nID:Integer;
    strRoomNumber:string;           //房间号
    listBedInfo: TRsBedInfoList ;   //床位信息
  end;
  
  TRsBedInfoArray = array of   RRsBedInfo ;
  TRsRoomInfoArray = array of RRsRoomInfo;


  //////////////////////////////////////////////////////////////////////////////
  ///  类名:TRoomWaitManList
  ///  描述:待乘房间入住信息列表
  //////////////////////////////////////////////////////////////////////////////
  TWaitRoomList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TWaitRoom;
    procedure SetItem(Index: Integer; AObject: TWaitRoom);
  public
    {功能:根据房间号查找}
    function Find(strRoomNum:string):TWaitRoom;
    {功能:根据人员GUID查找人员入住信息}
    function FindTrainman(strTrainmanGUID:string):TWaitWorkTrainmanInfo;
    function Add(AObject: TWaitRoom): Integer;
    property Items[Index: Integer]: TWaitRoom read GetItem write SetItem; default;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  类名:TRoomFloor
  ///  描述:待乘房间楼层信息
  //////////////////////////////////////////////////////////////////////////////
  TRoomFloor = class
  public
    //楼层编号
    strFloorNum:string;
    //房间总数
    nTotalRoomNum:Integer;
    //已入住房间总数
    nInRoomNum:Integer;
  public
    //格式化显示楼层信息
    function FmtFloorInfo():string;
  end;

   //////////////////////////////////////////////////////////////////////////////
  ///  类名:TRoomFloorList
  ///  描述:待乘房间楼层信息列表
  //////////////////////////////////////////////////////////////////////////////
  TRoomFloorList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TRoomFloor;
    procedure SetItem(Index: Integer; AObject: TRoomFloor);
  public
    //清空房间统计信息
    procedure ResetRoomInfo();
    //查找楼层
    function FindFloor(strFloorNum:string):TRoomFloor;
    //增加房间
    procedure AddRoom(room:TWaitRoom);
    //所有房间数
    function GetTotalRoomNum():Integer;
    //所有入住房间数
    function GetTotalInRoomNum():Integer;
    //格式化显示楼层信息
    function FmtTotalFloorInfo():string;
    function Add(AObject: TRoomFloor): Integer;
    property Items[Index: Integer]: TRoomFloor read GetItem write SetItem; default;
  end;

  

const
  TWaitWorkPlanTypeName : array[TWaitWorkPlanType] of string = ('派班','签点','本地');
  TWaitWorkPlanTypeColor : array[TWaitWorkPlanType] of TColor = (clRed,clYellow,clWindow);
implementation

{ TWaitWorkPlanList }

function TWaitWorkPlanList.Add(AObject: TWaitWorkPlan): Integer;
begin
  //if AObject.nIndex = -1 then
  AObject.nIndex := self.Count;
  Result := inherited Add (AObject);
end;

procedure TWaitWorkPlanList.DelPlan_ByType(planType: TWaitWorkPlanType);
var
  i:Integer;
begin
  for i := self.Count -1 Downto 0 do
  begin
    if self.Items[i].ePlanType = planType then
    begin
      self.Delete(i);
    end;
  end;
end;

function TWaitWorkPlanList.Find(strPlanGUID: string): TWaitWorkPlan;
var
  i:Integer;
begin
  Result := nil;
  for i := 0 to Self.Count - 1 do
  begin
    if Items[i].strPlanGUID = strPlanGUID then
    begin
      Result := Items[i];
      Break;
    end;
  end;
end;

function TWaitWorkPlanList.findByCheCi(strCheCi:string):TWaitWorkPlan;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to Self.Count - 1 do
  begin
    if UpperCase(Self.Items[i].strCheCi) = UpperCase(strCheCi) then
    begin
      result := Self.Items[i];
      Exit;
    end;
  end;
end;

function TWaitWorkPlanList.FindByRoomNum(strRoomNum: string): TWaitWorkPlan;
var
  i,j:Integer;
  JoinRoomList : TStringList ;
begin
  result := nil;
  for i := 0 to Self.Count - 1 do
  begin
    //检查是否是主房间
    if Self.Items[i].strRoomNum = strRoomNum then
    begin
      result := Self.Items[i];
      Exit;
    end;

    //检查是否是联交房间
    JoinRoomList := Self.Items[i].JoinRoomList ;
    for j := 0 to JoinRoomList.Count - 1 do
    begin
      if JoinRoomList[j] = strRoomNum  then
      begin
        result := Self.Items[i];
        Exit;
      end;
    end;
  end;
end;



function TWaitWorkPlanList.GetItem(Index: Integer): TWaitWorkPlan;
begin
  Result := TWaitWorkPlan( inherited GetItem(Index));
end;

procedure TWaitWorkPlanList.GetPlanCount_Type(
  planType:TWaitWorkPlanType;var nPlanCount,nTrainmanCount:Integer);
var
  i:Integer;
begin
  nPlanCount:= 0;
  nTrainmanCount:= 0;
  for I := 0 to self.Count - 1 do
  begin
    if Items[i].ePlanType = planType then
    begin
      inc(nPlanCount);
      nTrainmanCount := nTrainmanCount + Items[i].GetTrainmanCount;
    end;
  end;
end;

function TWaitWorkPlanList.GetRecordCount: Integer;
var
  i:Integer;
begin
  result := 0;
  for i := 0 to Self.Count - 1 do
  begin
    if self.Items[i].tmPlanList.Count = 0 then
    begin
      result := result + 1;
    end
    else
    begin
      result := result + self.Items[i].tmPlanList.Count;
    end;
  end;
end;

procedure TWaitWorkPlanList.SetItem(Index: Integer; AObject: TWaitWorkPlan);
begin
  inherited SetItem(Index,AObject);
end;

{ TWaitWorkPlan }



procedure TWaitWorkPlan.AddNewTrianman(strGUID,strNumber,strName:string);
var
  tmPlan:TWaitWorkTrainmanInfo;
begin
  tmPlan:=TWaitWorkTrainmanInfo.Create;
  tmPlan.strGUID := NewGUID;
  tmPlan.strTrainmanGUID := strGUID;
  tmPlan.strPlanGUID := self.strPlanGUID;
  tmPlan.strTrainmanNumber := strNumber;
  tmPlan.strTrainmanName := strName;
  if tmPlan.strTrainmanGUID <> '' then
    tmPlan.eTMState := psPublish
  else
    tmPlan.eTMState := psEdit;
  self.tmPlanList.Add(tmPlan);
end;

function TWaitWorkPlan.AddTrainman(Trainman:RRsTrainman;var strResult:string): TWaitWorkTrainmanInfo;
var
  tmPlan:TWaitWorkTrainmanInfo;
begin
  Result := nil;
  tmPlan := Self.tmPlanList.findTrainman(Trainman.strTrainmanGUID);
  if Assigned(tmPlan) then //已找到
  begin
    strResult := '计划内不允许有重复的乘务员!';
    Exit;
  end;

  tmPlan := Self.tmPlanList.FindEmptyTrainman();
  if not Assigned(tmPlan) then
  begin
    strResult := '计划内最多允许包含四位乘务员!';
    Exit;
  end;
  tmPlan.strPlanGUID := self.strPlanGUID;
  tmPlan.strTrainmanGUID := Trainman.strTrainmanGUID;
  tmPlan.strTrainmanNumber := Trainman.strTrainmanNumber;
  tmPlan.strTrainmanName := Trainman.strTrainmanName;
  tmPlan.eTMState := psPublish;

  Result := tmPlan;
end;
procedure TWaitWorkPlan.UpdatePlanState();
var
  i:Integer;
  tmInfo:TWaitWorkTrainmanInfo;
  minState:TRsPlanState;
begin
  if self.GetTrainmanCount = 0 then
  begin
    self.ePlanState := psPublish;
    Exit;
  end;
  minState := psOutRoom;
  for i := 0 to Self.tmPlanList.Count - 1 do
  begin
    tmInfo := tmPlanList.Items[i];
    if (tmInfo.strTrainmanGUID <> '') then
    begin
      if tmInfo.eTMState< minState then
      begin
        minState := tmInfo.eTMState;
      end;
    end;
  end;
  Self.ePlanState := minState;
end;
function TWaitWorkPlan.bAllChanged2OtherRoom(
  waitMan: TWaitWorkTrainmanInfo): Boolean;
var
  i:Integer;
  man:TWaitWorkTrainmanInfo;
begin
  result := False;
  for i := 0 to self.tmPlanList.Count - 1 do
  begin
    man := tmPlanList.Items[i];
    if (man.strTrainmanGUID <> '') and (man.strTrainmanGUID <> waitman.strTrainmanGUID) then
    begin
      if man.strRealRoom <> waitMan.strRealRoom then Exit;
    end;
  end;

  if self.strRoomNum <> waitMan.strRealRoom then 
  begin
    result := true;
  end;
    
end;

function TWaitWorkPlan.bAllInRoom():Boolean;
var
  i:Integer;
  tmInfo:TWaitWorkTrainmanInfo;
begin
  result:= True;
  if self.GetTrainmanCount = 0 then
  begin
    result := False;
    Exit;
  end;
  for i := 0 to Self.tmPlanList.Count - 1 do
  begin
    tmInfo := tmPlanList.Items[i];
    if (tmInfo.strTrainmanGUID <> '') and (tmInfo.eTMState = psPublish) then
    begin
      result := False;
      Exit;
    end;
  end;
end;

function TWaitWorkPlan.bAllOutRoom: Boolean;
var
  i:Integer;
  tmInfo:TWaitWorkTrainmanInfo;
begin
  result:= True;
  if Self.GetTrainmanCount = 0 then
  begin
    result := False;
    Exit;
  end;
  
  for i := 0 to Self.tmPlanList.Count - 1 do
  begin
    tmInfo := tmPlanList.Items[i];
    if (tmInfo.strTrainmanGUID <> '') and (tmInfo.eTMState < psOutRoom) then
    begin
      result := False;
      Exit;
    end;
  end;
  
end;

procedure TWaitWorkPlan.Clone(waitWorkPlan: TWaitWorkPlan);
var
  i:Integer;
  waitMan:TWaitWorkTrainmanInfo;
begin
  //序号
  nIndex:=waitWorkPlan.nIndex ;
  strPlanGUID:=waitWorkPlan.strPlanGUID;
  strSignPlanGUID:=waitWorkPlan.strSignPlanGUID  ;
  strCheJianGUID:=waitWorkPlan.strCheJianGUID ;
  strCheJianName:= waitWorkPlan.strCheJianName ;
  strTrainJiaoLuGUID:= waitWorkPlan.strTrainJiaoLuGUID ;
  strTrainJiaoLuName:= waitWorkPlan.strTrainJiaoLuName;
  strTrainJiaoLuNickName:=  waitWorkPlan.strTrainJiaoLuNickName;
  bNeedRest:=  waitWorkPlan.bNeedRest;
  ePlanState:= waitWorkPlan.ePlanState ;
  strCheCi:= waitWorkPlan.strCheCi  ;
  dtWaitWorkTime:= waitWorkPlan.dtWaitWorkTime ;
  dtCallWorkTime:= waitWorkPlan.dtCallWorkTime ;
  strRoomNum:= waitWorkPlan.strRoomNum  ;
  ePlanType:= waitWorkPlan.ePlanType  ;
  bNeedSyncCall:= waitWorkPlan.bNeedSyncCall  ;
  tmPlanList.Clear;
  for i := 0 to waitWorkPlan.tmPlanList.Count - 1 do
  begin
    waitMan:=TWaitWorkTrainmanInfo.Create;
    tmPlanList.Add(waitMan);
    waitMan.Clone(waitWorkPlan.tmPlanList.Items[i]);
  end;
  Self.JoinRoomList.Assign(waitWorkPlan.JoinRoomList);
    
end;

constructor TWaitWorkPlan.Create;
begin
  tmPlanList := TWaitWorkTrainmanInfoList.Create;
  JoinRoomList:=TStringList.Create;
end;
procedure TWaitWorkPlan.CreateByWaitTime(waitTime:RWaitTime);
begin
  Self.strPlanGUID := NewGUID;
  self.strCheJianGUID := waitTime.strWorkShopGUID;
  self.strCheJianName := waitTime.strWorkShopName;
  self.strTrainJiaoLuGUID := waitTime.strTrainJiaoluGUID;
  self.strTrainJiaoLuName := waitTime.strTrainJiaoLuName;
  Self.strTrainJiaoLuNickName := waitTime.strTrainJiaoLuName;
  Self.bNeedRest := False;
  self.ePlanState := psPublish;
  Self.strRoomNum := waitTime.strRoomNum;
  self.strCheCi := waitTime.strTrainNo;
  self.dtWaitWorkTime := waitTime.dtWaitTime;
  self.dtCallWorkTime := waitTime.dtCallTime;
  Self.bNeedSyncCall := false;
  if FormatDateTime('HH:nn:ss',waitTime.dtCallTime) <> '00:00:00' then
    Self.bNeedSyncCall := true;

  {if FormatDateTime('HH:nn:ss',waitTime.dtWaitTime) <> '00:00:00' then
    Self.bNeedRest := true;
  }
  Self.bNeedRest := waitTime.bMustSleep;
  self.ePlanType := TWWPT_LOCAL;
end;


procedure TWaitWorkPlan.CreateBySignPlan(signPlan: TSignPlan;
  workShop: RRsWorkShop);
var
  waitman:TWaitWorkTrainmanInfo;
  i:Integer;
begin
  Self.strPlanGUID := signPlan.strGUID;
  self.strCheJianGUID := workShop.strWorkShopGUID;
  self.strCheJianName := workShop.strWorkShopName;
  self.strTrainJiaoLuGUID := signPlan.strTrainJiaoluGUID;
  self.strTrainJiaoLuName := signPlan.strTrainJiaoLuName;
  Self.strTrainJiaoLuNickName := signPlan.strTrainJiaoLuName;
  Self.bNeedRest := TPubFun.Int2Bool(signPlan.nNeedRest);
  self.ePlanState := psPublish;
  self.strCheCi := signPlan.strTrainNo;
  self.dtWaitWorkTime := signPlan.dtArriveTime;
  self.dtCallWorkTime := signPlan.dtCallTime;
  Self.bNeedSyncCall := true;
  self.ePlanType := TWWPT_ASSIGN;

  for i := 0 to 3 do
  begin
    if i >=  self.tmPlanList.Count  then
    begin
      waitman := TWaitWorkTrainmanInfo.Create;
      waitman.strGUID := NewGUID;
      waitman.eTMState := psPublish;
      Self.tmPlanList.Add(waitman)
    end
    else
    begin
      waitMan := self.tmPlanList.Items[i];
    end;
    waitman.strPlanGUID := strPlanGUID;
    case i of
      0:
      begin
        waitman.strTrainmanGUID := signPlan.strTrainmanGUID1;
        waitman.strTrainmanNumber := signPlan.strTrainmanNumber1;
        waitman.strTrainmanName := signPlan.strTrainmanName1;
      end;
      1:
      begin
        waitman.strTrainmanGUID := signPlan.strTrainmanGUID2;
        waitman.strTrainmanNumber := signPlan.strTrainmanNumber2;
        waitman.strTrainmanName := signPlan.strTrainmanName2;
      end;
      2:
      begin
        waitman.strTrainmanGUID := signPlan.strTrainmanGUID3;
        waitman.strTrainmanNumber := signPlan.strTrainmanNumber3;
        waitman.strTrainmanName := signPlan.strTrainmanName3;
      end;
      3:
      begin
        waitman.strTrainmanGUID := signPlan.strTrainmanGUID4;
        waitman.strTrainmanNumber := signPlan.strTrainmanNumber4;
        waitman.strTrainmanName := signPlan.strTrainmanName4;
      end;

    end;
    if waitman.strTrainmanGUID = '' then
    begin
      waitman.eTMState := psEdit;
    end
    else
    begin
      waitman.eTMState := psPublish;
    end;

  end;
end;

procedure TWaitWorkPlan.CreateByTrainmanPlan(trainmanPlan:RRSTrainmanPlan;workShop:RRSWorkShop);
var
  waitman:TWaitWorkTrainmanInfo;
  i:Integer;
begin
  Self.strPlanGUID := trainmanPlan.TrainPlan.strTrainPlanGUID;
  self.strCheJianGUID := workShop.strWorkShopGUID;
  self.strCheJianName := workShop.strWorkShopName;
  self.strTrainJiaoLuGUID := trainmanPlan.TrainPlan.strTrainJiaoluGUID;
  self.strTrainJiaoLuName := trainmanPlan.TrainPlan.strTrainJiaoluName;
  Self.strTrainJiaoLuNickName := trainmanPlan.TrainPlan.strTrainJiaoluName;
  Self.bNeedRest := TPubFun.Int2Bool(trainmanPlan.TrainPlan.nNeedRest);
  self.ePlanState := psPublish;
  self.strCheCi := trainmanPlan.TrainPlan.strTrainNo;
  self.dtWaitWorkTime := trainmanPlan.TrainPlan.dtArriveTime;
  self.dtCallWorkTime := trainmanPlan.TrainPlan.dtCallTime;
  Self.bNeedSyncCall := true;
  self.ePlanType := TWWPT_ASSIGN;

  for i := 0 to 3 do
  begin
    if i >=  self.tmPlanList.Count  then
    begin
      waitman := TWaitWorkTrainmanInfo.Create;
      waitman.strGUID := NewGUID;
      waitman.eTMState := psPublish;
      Self.tmPlanList.Add(waitman)
    end
    else
    begin
      waitMan := self.tmPlanList.Items[i];
    end;
    waitman.strPlanGUID := strPlanGUID;
    case i of
      0:
      begin
        waitman.strTrainmanGUID := trainmanPlan.Group.Trainman1.strTrainmanGUID;
        waitman.strTrainmanNumber := trainmanPlan.Group.Trainman1.strTrainmanNumber;
        waitman.strTrainmanName := trainmanPlan.Group.Trainman1.strTrainmanName;
      end;
      1:
      begin
        waitman.strTrainmanGUID := trainmanPlan.Group.Trainman2.strTrainmanGUID;
        waitman.strTrainmanNumber := trainmanPlan.Group.Trainman2.strTrainmanNumber;
        waitman.strTrainmanName := trainmanPlan.Group.Trainman2.strTrainmanName;
      end;
      2:
      begin
        waitman.strTrainmanGUID := trainmanPlan.Group.Trainman3.strTrainmanGUID;
        waitman.strTrainmanNumber := trainmanPlan.Group.Trainman3.strTrainmanNumber;
        waitman.strTrainmanName := trainmanPlan.Group.Trainman3.strTrainmanName;
      end;
      3:
      begin
        waitman.strTrainmanGUID := trainmanPlan.Group.Trainman4.strTrainmanGUID;
        waitman.strTrainmanNumber := trainmanPlan.Group.Trainman4.strTrainmanNumber;
        waitman.strTrainmanName := trainmanPlan.Group.Trainman4.strTrainmanName;
      end;



    end;
    if waitman.strTrainmanGUID = '' then
    begin
      waitman.eTMState := psEdit;
    end
    else
    begin
      waitman.eTMState := psPublish;
    end;

  end;
end;

destructor TWaitWorkPlan.Destroy;
begin
  tmPlanList.Free;
  JoinRoomList.Free;
  inherited;
end;


function TWaitWorkPlan.GetAllRoomNumStr: string;
var
  i,index:Integer;
  man:TWaitWorkTrainmanInfo;
  strList:TStringList;
begin
  result := '';
  strList:= TStringList.Create;
  if strRoomNum <> '' then
    strList.Add(self.strRoomNum);
  try
    for i := 0 to self.tmPlanList.Count - 1 do
    begin
      man := Self.tmPlanList.Items[i];
      if man.strRealRoom <> '' then
      begin
        if strList.Find(man.strRealRoom,index) = False then
          strList.Add(man.strRealRoom);
      end;
    end;
    //strList.DelimitedText;
    if strList.Count = 0 then Exit;
    
    result := strList.DelimitedText;
  finally
    strList.Free;
  end;
    
end;

function TWaitWorkPlan.GetInRoomTrainmanCount: Integer;
var
  tm:TWaitWorkTrainmanInfo;
  i:Integer;
begin
  result := 0;
  for I := 0 to self.tmPlanList.Count - 1 do
  begin
    tm:= self.tmPlanList.Items[i];
    if tm.eTMState >= psInRoom  then
      Inc(Result);
  end;
end;

function TWaitWorkPlan.GetStateStr: string;
var
  i:Integer;
begin
  result := '已发布';
  if Self.bAllOutRoom then
  begin
    result := '已离寓';
  end;
  for i := 0 to tmPlanList.Count - 1 do
  begin
    if tmPlanList.Items[i].InRoomInfo.strGUID <>'' then
    begin
      result := '已入寓';
      Exit;
    end;
  end;
end;

function TWaitWorkPlan.GetTrainmanCount: Integer;
var
  i:Integer;
  tmInfo:TWaitWorkTrainmanInfo;
begin
  result := 0;
  for i := 0 to tmPlanList.Count - 1 do
  begin
    tmInfo := tmPlanList.Items[i];
    if tmInfo.strTrainmanGUID <> '' then
      Inc(result);
  end;
end;
function TWaitWorkPlan.GetUnOutRoomTrainmanCount():Integer;
var
  i:Integer;
  tmInfo:TWaitWorkTrainmanInfo;
begin
  result := 0;
  for i := 0 to tmPlanList.Count - 1 do
  begin
    tmInfo := tmPlanList.Items[i];
    if (tmInfo.eTMState > psPublish) and (tmInfo.eTMState < psOutRoom) then
      Inc(Result);
  end;

end;

function TWaitWorkPlan.tmInSameRoom: Boolean;
var
  i:Integer;
  strRoomNum : string;
  waitMan:TWaitWorkTrainmanInfo;
begin
  strRoomNum := Self.strRoomNum;
  result := True;
  for i := 0 to self.tmPlanList.Count - 1 do
  begin
    waitMan := self.tmPlanList.Items[i];
    if waitMan.eTMState >= psInRoom then
    begin
//      if strRoomNum = '' then
//      begin
//        strRoomNum := waitMan.strRealRoom;
//      end
//      else
      //begin
        if waitMan.strRealRoom <> strRoomNum then
        begin
          result := False;
          Exit;
        end;
        
      //end;
    end;
  end;
 
  

end;

{ TWaitWorkTrainmanList }

function TWaitWorkTrainmanInfoList.Add(AObject: TWaitWorkTrainmanInfo): Integer;
begin
  AObject.nIndex := self.Count ;
  result := inherited Add(AObject);
end;

function TWaitWorkTrainmanInfoList.FindEmptyTrainman(
  ): TWaitWorkTrainmanInfo;
var
  i:Integer;
  info:TWaitWorkTrainmanInfo;
begin
  Result := nil;
  if Self.Count <4 then
  begin
    info := TWaitWorkTrainmanInfo.Create;
    Self.Add(info);
  end;

  for i := 0 to self.Count - 1 do
  begin
    if Items[i].strTrainmanGUID = '' then
    begin
      Result := Items[i];
      Break;
    end;
  end;


end;

function TWaitWorkTrainmanInfoList.findTrainman(
  strTrainmanGUID: string): TWaitWorkTrainmanInfo;
var
  i:Integer;
begin
  Result := nil;
  for i := 0 to Self.Count - 1 do
  begin
    if Items[i].strTrainmanGUID = strTrainmanGUID then
    begin
      Result := items[i];
      Break;
    end;
  end;
end;

function TWaitWorkTrainmanInfoList.FindTrainman_GH(
  strGH: string): TWaitWorkTrainmanInfo;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to self.Count - 1 do
  begin
    if Items[i].strTrainmanNumber = strGH then
    begin
      result := Items[i];
    end;
  end;
end;

function TWaitWorkTrainmanInfoList.FindTrainman_Name(
  Name: string): TWaitWorkTrainmanInfo;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to self.Count - 1 do
  begin
    if Items[i].strTrainmanName = Name then
    begin
      result := Items[i];
    end;
  end;
end;

function TWaitWorkTrainmanInfoList.GetItem(Index: Integer): TWaitWorkTrainmanInfo;
begin
  result := TWaitWorkTrainmanInfo(inherited GetItem(Index));
end;

procedure TWaitWorkTrainmanInfoList.SetItem(Index: Integer; AObject: TWaitWorkTrainmanInfo);
begin
  SetItem(Index,AObject);
end;
(*
{ TInOutRoomInfoList }

function TInOutRoomInfoList.Add(AObject: TInOutRoomInfo): Integer;
begin
  Result := inherited Add(AObject);
end;

function TInOutRoomInfoList.GetItem(Index: Integer): TInOutRoomInfo;
begin
  result := TInOutRoomInfo(inherited GetItem(Index));
end;

procedure TInOutRoomInfoList.SetItem(Index: Integer; AObject: TInOutRoomInfo);
begin
  inherited SetItem(Index,AObject);
end;

function TInOutRoomInfoList.ToJsonStr: string;
var
  i:Integer;
  iJson: ISuperObject;
  infoJson:ISuperObject;
begin
  for i := 0 to self.Count - 1 do
  begin
    infoJson := so(Self.Items[i].ToJsonStr);
    iJson.AsArray.Add(infoJson);
  end;
  result := iJson.asstring;
  iJson := nil;
end;
 *)
{ TWaitWorkTrainmanInfo }

procedure TWaitWorkTrainmanInfo.Clone(tmInfo:TWaitWorkTrainmanInfo);
begin
  //序号
    nIndex:=tmInfo.nIndex  ;
    strGUID:=tmInfo.strGUID ;
    strPlanGUID:=tmInfo.strPlanGUID;
    strTrainmanGUID:=tmInfo.strTrainmanGUID;
    strTrainmanNumber:=tmInfo.strTrainmanNumber;
    strTrainmanName:=tmInfo.strTrainmanName;
    eTMState:=tmInfo.eTMState ;
    dtFirstCallTime := tmInfo.dtFirstCallTime;
    strRealRoom:=tmInfo.strRealRoom;
    InRoomInfo:=tmInfo.InRoomInfo ;
    OutRoomInfo:=tmInfo.OutRoomInfo;
end;

constructor TWaitWorkTrainmanInfo.Create;
begin
  nIndex := -1;
end;

destructor TWaitWorkTrainmanInfo.Destroy;
begin
  inherited;
end;

{ TInOutRoomInfo }

function TWaitWorkTrainmanInfo.GetStateStr: string;
begin
  result := '';
  if Self.strTrainmanGUID <> '' then
    Result := '未入寓';

  if Self.eTMState > psPublish then
    result := TRsPlanStateNameAry[Self.eTMState];

  if (Self.eTMState = psFirstCall) and  (Self.bCallSucess = False) then
    Result := '首叫失败!';
  if (Self.eTMState = psReCall) and  (Self.bCallSucess = False) then
    Result := '催叫失败!';
  Exit;
end;
 (*
procedure TInOutRoomInfo.Reset;
begin
  Self.strGUID := '';
  Self.strPlanGUID := '';
  Self.strTrainmanGUID := '';
  self.eType := TInRoom;
  Self.dtTime := 0;
  Self.dtArriveTime := 0;
  bUpload := False;
end;

procedure TInOutRoomInfo.SetValues(strGUID, strPlanGUID, strTrainmanGUID: string;
    eType: TInOutRoomType; dtTime: TDateTime;dtArriveTime:TDateTime;ePlanType:TWaitWorkPlanType);
begin
  Self.strGUID := strGUID;
  Self.strPlanGUID := strPlanGUID;
  Self.strTrainmanGUID := strTrainmanGUID;
  self.eType := eType;
  Self.dtTime := dtTime;
  self.dtArriveTime := dtArriveTime;
  Self.ePlanType := ePlanType;
  bUpload := False;
end;


function TInOutRoomInfo.ToJsonStr: string;
var
  jso:ISuperObject;
begin
  jso  := so('{}');
  jso.S['strGUID'] := strGUID;
  jso.s['strWaitPlanGUID'] := strPlanGUID;
  jso.s['strTrainmanGUID'] := strTrainmanGUID;
  jso.I['InOutRoomType'] := Ord(eType);
  jso.s['dtArriveTime']:= FormatDateTime('yyyy-mm-dd HH:mm:ss',dtTime);
  jso.s['dtTime'] := FormatDateTime('yyyy-mm-dd HH:mm:ss',dtTime);
  if ePlanType = TWWPT_ASSIGN then
    jso.S['strTrainPlanGUID'] := strPlanGUID;
  Result := jso.AsString;
  jso := nil;
end;
  *)

{ TSyncPlanIDInfoList }

function TSyncPlanIDInfoList.Add(AObject: TSyncPlanIDInfo): Integer;
begin
  result := inherited Add(AObject);
end;

function TSyncPlanIDInfoList.GetItem(Index: Integer): TSyncPlanIDInfo;
begin
  result := TSyncPlanIDInfo(inherited GetItem(Index));
end;

procedure TSyncPlanIDInfoList.SetItem(Index: Integer; AObject: TSyncPlanIDInfo);
begin
  inherited SetItem(Index,AObject);
end;



{ TWaitRoomList }

function TWaitRoomList.Add(AObject: TWaitRoom): Integer;
begin
  Result:= inherited Add(AObject);
end;

function TWaitRoomList.Find(strRoomNum: string): TWaitRoom;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to Self.Count - 1 do
  begin
    if Items[i].strRoomNum = strRoomNum then
    begin
      result := Items[i];
      Exit;
    end;
  end;
end;

function TWaitRoomList.FindTrainman(
  strTrainmanGUID: string): TWaitWorkTrainmanInfo;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to self.Count - 1 do
  begin
    result := self.Items[i].waitManList.findTrainman(strTrainmanGUID);
    if Assigned(Result) then Exit;
  end;
end;

function TWaitRoomList.GetItem(Index: Integer): TWaitRoom;
begin
  result := TWaitRoom(inherited GetItem(index) );
end;

procedure TWaitRoomList.SetItem(Index: Integer;
  AObject: TWaitRoom);
begin
  inherited SetItem(index,AObject);
end;

{ TWaitWorkRoomInfo }

constructor TWaitRoom.Create;
begin
  waitManList:=TWaitWorkTrainmanInfoList.Create;
end;

destructor TWaitRoom.Destroy;
begin
  waitManList.Free;
  inherited;
end;



function TWaitRoom.GetFloorNum: string;
begin
  result := LeftStr(strRoomNum,1);
end;

{ RRSInOutRoomInfo }

procedure RRSInOutRoomInfo.SetValue(waitPlan: TWaitWorkPlan;
  trainman: RRsTrainman;dtNow:TDateTime; eVerifyType: TRsRegisterFlag;
  eInOutType: TInOutRoomType;dutyUser:TRsDutyUser;siteInfo:TRsSiteInfo);
begin
  strGUID := NewGUID;
  if waitPlan.ePlanType = TWWPT_ASSIGN then
    strTrainPlanGUID := waitPlan.strPlanGUID;

  strWaitPlanGUID:= waitPlan.strPlanGUID;
  dtInOutRoomTime:= dtNow;
  Self.eVerifyType :=eVerifyType;
  strDutyUserGUID:= dutyUser.strDutyGUID;
  strTrainmanGUID:=trainman.strTrainmanGUID;
  strTrainmanNumber:= trainman.strTrainmanNumber;
  strTrainmanName := trainman.strTrainmanName;
  dtCreatetTime :=dtNow;
  strSiteGUID :=siteInfo.strSiteGUID;
  strRoomNumber :=waitPlan.strRoomNum;
  dtArriveTime := waitPlan.dtWaitWorkTime;
  nBedNumber := 0;
  bUploaded:= False;
  eWaitPlanType:=waitPlan.ePlanType;
  eInOutType:=eInOutType;
end;

function RRSInOutRoomInfo.ToJsonStr(inOutType:TInOutRoomType): string;
var
  jso:ISuperObject;
begin
  jso  := so('{}');
  if inOutType = TInRoom then
  begin
    jso.S['strInRoomGUID'] := strGUID;
    jso.S['dtInRoomTime'] := TPubFun.dateTime2Str(dtInOutRoomTime)   ;
    jso.I['nInRoomVerifyID'] := ord(eVerifyType)   ;
  end;
  if inOutType = TOutRoom then
  begin
    jso.S['strInRoomGUID'] := self.strInRoomGUID;
    jso.S['strOutRoomGUID'] := strGUID;
    jso.S['dtOutRoomTime'] := TPubFun.dateTime2Str(dtInOutRoomTime)   ;
    jso.I['nOutRoomVerifyID'] := ord(eVerifyType)   ;
  end;
  jso.S['strTrainPlanGUID'] := strTrainPlanGUID;
  jso.S['strTrainmanNumber'] := strTrainmanNumber;
  jso.S['strTrainmanGUID'] := strTrainmanGUID ;
  jso.S['strDutyUserGUID'] := strDutyUserGUID   ;
  jso.S['strSiteGUID'] := strSiteGUID  ;
  jso.S['strRoomNumber'] := strRoomNumber  ;
  jso.I['nBedNumber'] := nBedNumber  ;
  jso.S['dtCreateTime'] := TPubFun.dateTime2Str(dtCreatetTime)  ;
  jso.S['strWaitPlanGUID'] := strWaitPlanGUID  ;
  jso.I['ePlanType']  := Ord(eWaitPlanType) ;
  jso.S['dtArriveTime'] := TPubFun.DateTime2Str(dtArriveTime);
  //jso.I['bUpLoaded'] := TPubFun.Bool2Int(bUploaded)  ;
  Result := jso.AsString;
  jso := nil;
end;

{ RWaitTime }

procedure RWaitTime.New;
begin
  strGUID := NewGUID();
  strWorkshopGUID:='';
  strWorkShopName:='';
  strTrainJiaoLuGUID:='';
  strTrainJiaoLuName:='';
  strTrainJiaoLuNickName:='';
  strTrainNo:='';
  strRoomNum:='';
  dtWaitTime:=0;
  dtCallTime:=0;
  dtChuQinTime:=0;
  dtKaiCheTime:=0;
end;

{ TRoomFloorList }

function TRoomFloorList.Add(AObject: TRoomFloor): Integer;
begin
  result := inherited Add(AObject);
end;

procedure TRoomFloorList.AddRoom(room: TWaitRoom);
var
  roomFloor:TRoomFloor;
begin
  roomFloor := self.FindFloor(room.FloorNum);
  if roomFloor <> nil then
  begin
    Inc(roomFloor.nTotalRoomNum);
    if room.waitManList.Count >0 then
    begin
      Inc(roomFloor.nInRoomNum);
    end;
  end;
end;

function TRoomFloorList.FindFloor(strFloorNum: string): TRoomFloor;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to self.Count - 1 do
  begin
    if self.Items[i].strFloorNum = strFloorNum then
    begin
      result := Self.Items[i];
      Break;
    end;
  end;
end;

function TRoomFloorList.FmtTotalFloorInfo: string;
begin
  result := Format('%s楼[%d/%d]',['所有',self.GetTotalInRoomNum,self.GetTotalRoomNum]);
end;

function TRoomFloorList.GetTotalInRoomNum: Integer;
var
  i:Integer;
begin
  result := 0;
  for i := 0 to self.Count - 1 do
  begin
    result := result + self.Items[i].nInRoomNum;
  end;
end;

function TRoomFloorList.GetItem(Index: Integer): TRoomFloor;
begin
  result := TRoomFloor(inherited GetItem(Index));
end;

function TRoomFloorList.GetTotalRoomNum: Integer;
var
  i:Integer;
begin
  result := 0;
  for i := 0 to self.Count - 1 do
  begin
    result := result + self.Items[i].nTotalRoomNum;
  end;
end;

procedure TRoomFloorList.ResetRoomInfo;
var
  i:integer;
begin
  for i := 0 to self.Count - 1 do
  begin
    self.Items[i].nTotalRoomNum := 0;
    self.Items[i].nInRoomNum := 0;
  end;
end;

procedure TRoomFloorList.SetItem(Index: Integer; AObject: TRoomFloor);
begin
  inherited SetItem(Index,AObject);
end;

{ TRoomFloor }

function TRoomFloor.FmtFloorInfo: string;
begin
  result := Format('%s楼[%d/%d]',[Self.strFloorNum,self.nInRoomNum,self.nTotalRoomNum]);
end;

{ TInRoomWorkPlan }

procedure TInRoomWorkPlan.Clear;
begin
    strPlanGUID:= '';
    //车次
    strCheCi:= '' ;
    //房间号
    strRoomNum:= '';
    //候班时间
    dtWaitWorkTime:= 0;
    //叫班时间
    dtCallWorkTime:= 0 ;
    //类型
    ePlanType:=TWWPT_LOCAL;
    //需要同步叫班
    bNeedSyncCall:= false ;
    bNeedRest:= false ;
    //人员计划列表
    FillChar(Trainman,SizeOf(RRsTrainman),0);
    //联交房间
    JoinRoomList.Clear;
end;

constructor TInRoomWorkPlan.Create;
begin
  JoinRoomList := TStringList.Create;
end;

destructor TInRoomWorkPlan.Destroy;
begin
  JoinRoomList.Free;
  inherited;
end;

end.
