unit uTrainPlan;

interface
uses
  uSaftyEnum,uTrainman,uStation,uTrainmanJiaolu,uApparatusCommon;
type
 
  //出勤地点设置信息
  RRsChuQinDiDian = record
    strGUID : string;
    //出勤车站GUID
    strStationGUID : string;
    //所属车间GUID
    strWorkShopGUID : string;
    //本段最短休息时间
    nLocalRest : integer;
    //本段提前出勤时间
    nLocalPre : integer;
    //外段最短休息时间
    nOutRest : integer;
    //外段提前出勤时间
    nOutPre : integer;
    //站接提前出勤时间
    nZJPre : integer;
    //夜班调整
    nNightReset : integer;
    //是否侯班
    bIsRest : integer;
    //侯班时间
    dtRestTime : TDatetime;
    //侯班结束时间(叫班时间)
    dtCallTime : TDateTime;
    //超劳时序时长
    nContinueHours : integer;
    //按入库排序
    bRuKuFanPai : integer;
    //本段是否统计超劳
    bLocalChaolao : integer;
    //外段是否统计超劳
    bOutChaoLao : integer;
  end;
  TRsChuQinDiDianArray = array of RRsChuQinDiDian;

  TRsPlanStateSet = set of TRsPlanState;
 
  //////////////////////////////////////////////////////////////////////////////
  /// 说明：机车计划
  //////////////////////////////////////////////////////////////////////////////
  RRsTrainPlan = record
  public
    //
    strPlaceID:string;
    strPlaceName:string;

    strTrainPlanGUID : String;
     //机车类型
    strTrainTypeName : string;
    //机车号
    strTrainNumber : string;
    {车次}
    strTrainNo : String;
    {开车时间}
    dtStartTime : TDateTime;
    //实际开车时间
    dtRealStartTime : TDateTime;
    //初发开车时间
    dtFirstStartTime : TDateTime;
    // 字段错误(意思为计划开车时间)
    dtChuQinTime:TDateTime ;
    //实际出勤时间
    dtRealBeginWorkTime:TDateTime;
    {机车交路}
    strTrainJiaoluGUID : String;
   //机车交路名称
    strTrainJiaoluName : string;
    {起始站GUID}
    strStartStation : string;
    //起始站名称
    strStartStationName : string;
    {终到站GUID}
    strEndStation : string;
    //终到站名称
    strEndStationName : string;
    //值乘方式
    nTrainmanTypeID : TRsTrainmanType;

    strTrainmanTypeName:string;
    //计划类型
    nPlanType : TRsPlanType;
    strPlanTypeName:string;
    //牵引状态
    nDragType : TRsDragType;
    strDragTypeName:string;
    //客货
    nKeHuoID : TRsKehuo;
    strKehuoName:string;
    //备注类型
    nRemarkType : TRsPlanRemarkType;
    strRemarkTypeName:string;
    //备注内容
    strRemark : string;
    //计划状态
    nPlanState : TRsPlanState;
    //计划状态名称
    strPlanStateName : string;
    //最后到达时间
    dtLastArriveTime : TDateTime;
     {记录产生时间}
    dtCreateTime : TDateTime;
    //创建的客户端GUID
    strCreateSiteGUID : string;
    //创建的客户端名称
    strCreateSiteName : string;
    //创建人
    strCreateUserGUID : string;
    //创建人名称
    strCreateUserName : string;
     //主计划GUID
    strMainPlanGUID: string;

    //是否需要强休 0:不需要，1：需要
    nNeedRest : integer;
    //到达时间
    dtArriveTime : TDateTime;
    //叫班时间
    dtCallTime : TDateTime;
    //股道号
    strTrackNumber: string;
    //外勤端客户端GUID
    strWaiQinClientGUID : string;
    //外勤端客户端编号
    strWaiQinClientNumber: string;
    //外勤端客户端名称
    strWaiQinClientName: string;
    //计划下达时间
    dtSendPlanTime:TDateTime;
    //计划接收时间
    dtRecvPlanTime:TDateTime;
  public
    procedure Clone(Source: RRsTrainPlan);
  end;
  TRsTrainPlanArray = array of RRsTrainPlan;



  //接受机车计划
  RRsReceiveTrainPlan = record
    strPlanID:string;
    TrainPlan:RRsTrainPlan;
    strUserID:string;
    strUserName:string;
    strSiteID:string;
    strSiteName:string;
  end;
  
  //机车计划下发日志
  RRsTrainPlanSendLog = record
    //下发记录GUID
    strSendGUID : string;
    //车次
    strTrainNo: string;
    //机车计划关联GUID
    strTrainPlanGUID : string;
    //行车区段名称
    strTrainJiaoluName : string;
    //计划开车时间
    dtStartTime : TDateTime;
    //实际开车时间
    dtRealStartTime : TDateTime;
    //下发客户端名称
    strSendSiteName : string;
    //下发时间
    dtSendTime : TDateTime;
  end;
  TRsTrainPlanSendLogArray = array of RRsTrainPlanSendLog;

  //机车计划改动日志
  RRsTrainPlanChangeLog = record
    //计划GUID
    strTrainPlanGUID : String;
     //机车类型
    strTrainTypeName : string;
    //机车号
    strTrainNumber : string;
    {车次}
    strTrainNo : String;
    //计划开车时间
    dtStartTime : TDateTime;

    {机车交路}
    strTrainJiaoluGUID : String;
   //机车交路名称
    strTrainJiaoluName : string;
    {起始站GUID}
    strStartStation : string;
    //起始站名称
    strStartStationName : string;
    {终到站GUID}
    strEndStation : string;
    //终到站名称
    strEndStationName : string;
    //值乘方式
    nTrainmanTypeID : TRsTrainmanType;

    strTrainmanTypeName:string;
    //计划类型
    nPlanType : TRsPlanType;
    strPlanTypeName:string;
    //牵引状态
    nDragType : TRsDragType;
    strDragTypeName:string;
    //客货
    nKeHuoID : TRsKehuo;
    strKehuoName:string;
    //备注类型
    nRemarkType : TRsPlanRemarkType;
    strRemarkTypeName:string;
    //备注内容
    strRemark : string;
    //计划状态
    nPlanState : TRsPlanState;
    {记录产生时间}
    dtCreateTime : TDateTime;
    //改变时间
    dtChangeTime:TDateTime ;
  end;
  TRsTrainPlanChangeLogArray = array of RRsTrainPlanChangeLog;


  //计划休息信息
  RRsRest = record
  public
    //是否需要强休 0:不需要，1：需要
    nNeedRest : integer;
    //到达时间
    dtArriveTime : TDateTime;
    //叫班时间
    dtCallTime : TDateTime;
  end;

  //人员计划
  RRsTrainmanPlan = record
  public
    //机车计划信息
    TrainPlan : RRsTrainPlan;
    //人员派班信息
    Group : RRsGroup;
    //出勤时间
    dtBeginWorkTime : TDateTime;
    //侯班信息
    RestInfo : RRsRest;
    //计划ID
    strPlanID:string;
  end;

  TRsTrainmanPlanArray = array of RRsTrainmanPlan; 
  ///机组出勤信息
  RRsChuQinGroup = record
  public
    Group : RRsGroup;
    
    //正司机验证方式
    nVerifyID1 : TRsRegisterFlag;
    //正司机测酒结果
    TestAlcoholInfo1: RTestAlcoholInfo;
   
    
    //副司机验证方式
    nVerifyID2 : TRsRegisterFlag;
    //副司机测酒结果
    TestAlcoholInfo2: RTestAlcoholInfo;

    //学员验证方式
    nVerifyID3 : TRsRegisterFlag;
    //学员测酒结果
    TestAlcoholInfo3: RTestAlcoholInfo;

    //学员验证方式
    nVerifyID4 : TRsRegisterFlag;
    //学员测酒结果
    TestAlcoholInfo4: RTestAlcoholInfo;

    //出勤说明
    strChuQinMemo : string;
  end;

  //出勤计划信息
  RRsChuQinPlan = record
  public
    //机车计划信息
    TrainPlan : RRsTrainPlan;
    //出勤时间
    dtBeginWorkTime : TDateTime;
    //人员出勤
    ChuQinGroup : RRsChuQinGroup;
    //出勤验卡结果
    strICCheckResult : string;
    //出勤备注
    strChuQinMemo:string;
  end;
  TRsChuQinPlanArray = array of RRsChuQinPlan;

  //导入计划信息
  RRsImportPlan = record
  public
    //机车计划信息
    TrainPlan : RRsTrainPlan;
    //出勤时间
    dtBeginWorkTime : TDateTime;
    //人员组
    Group : RRsGroup;
    //司机
    Trainman : RRsTrainman;

    //选择
    blnSelected: boolean;
    //验证方式
    nVerifyID : TRsRegisterFlag;
    //测酒结果
    TestAlcoholInfo: RTestAlcoholInfo;
    //本地测酒信息ID
    nDrinkInfoID: integer;
    //匹配
    blnMatched: boolean;
  end;
  TRsImportPlanArray = array of RRsImportPlan;


  //入寓登记信息
  RRsInRoomInfo = record
  public
    //机车计划GUID
    strTrainPlanGUID : string;
    //乘务员GUID
    strTrainmanGUID : string;
    //验证方式
    nVerifyID : TRsRegisterFlag;
    //入寓房间号
    strRoomNumber : string;
    //值班员编号
    strDutyUserGUID : string;
  end;

  //离寓登记信息
  RRsOutRoomInfo = record
  public
    //机车计划GUID
    strTrainPlanGUID : string;
    //乘务员GUID
    strTrainmanGUID : string;
    //验证方式
    nVerifyID : TRsRegisterFlag;
    //值班员编号
    strDutyUserGUID : string;
  end;
  
  ///机组出入寓信息
  RRsInOutGroup = record
  public
    Group : RRsGroup;
    //房间号
    strRoomNumber : string;
    //叫班次数
    CallCount : integer;
    
    //正司机入寓验证方式
    nInRoomVerifyID1 : TRsRegisterFlag;
    //正司入寓时间
    dtInRoomTime1 : TDateTime;

    //副司机入寓验证方式
    nInRoomVerifyID2 : TRsRegisterFlag;
    //副司入寓时间
    dtInRoomTime2 : TDateTime;

    //学员入寓验证方式
    nInRoomVerifyID3 : TRsRegisterFlag;
    //学员入寓时间
    dtInRoomTime3 : TDateTime;

    //正司机入寓验证方式
    nOutRoomVerifyID1 : TRsRegisterFlag;
    //正司入寓时间
    dtOutRoomTime1 : TDateTime;

    //副司机入寓验证方式
    nOutRoomVerifyID2 : TRsRegisterFlag;
    //副司入寓时间
    dtOutRoomTime2 : TDateTime;

    //学员入寓验证方式
    nOutRoomVerifyID3 : TRsRegisterFlag;
    //学员入寓时间
    dtOutRoomTime3 : TDateTime;

    //学员入寓验证方式
    nOutRoomVerifyID4 : TRsRegisterFlag;
    //学员入寓时间
    dtOutRoomTime4 : TDateTime;
  end;
 //出入寓计划信息
  RRsInOutPlan = record
  public
    //机车计划信息
    TrainPlan : RRsTrainPlan;
    //人员出入寓信息
    InOutGroup : RRsInOutGroup;
    //最后一次是否叫班成功
    nCallSucceed : integer;
  end;
  TRsInOutPlanArray = array of RRsInOutPlan;

  //退勤机组信息                    
  RRsTuiQinGroup = record
    Group : RRsGroup;
    //正司机验证方式
    nVerifyID1 : TRsRegisterFlag;
    //正司机测酒结果
    TestAlcoholInfo1: RTestAlcoholInfo;
   
    
    //副司机验证方式
    nVerifyID2 : TRsRegisterFlag;
    //副司机测酒结果
    TestAlcoholInfo2: RTestAlcoholInfo;

    //学员验证方式
    nVerifyID3 : TRsRegisterFlag;
    //学员测酒结果
    TestAlcoholInfo3: RTestAlcoholInfo;

    //学员验证方式
    nVerifyID4 : TRsRegisterFlag;
    //学员测酒结果
    TestAlcoholInfo4: RTestAlcoholInfo;
  end;
  /////////////////////////////////////////////////////////////////////////////
  /// REndWork :退勤信息
  /////////////////////////////////////////////////////////////////////////////
  RRsTuiQinPlan = record
    //机车计划信息
    TrainPlan : RRsTrainPlan;
    //出勤时间
    dtBeginWorkTime : TDateTime;
    //人员出勤
    TuiQinGroup : RRsTuiQinGroup;
    //趟开始时间
    dtTurnStartTime : TDateTime;
    //是否已经签署预警意见
    bSigned : integer;
    //预警是否已经结束
    bIsOver : integer;
    //超劳时长
    nTurnMinutes : integer;
    //预警时长
    nTurnAlarmMinutes : integer;
  end;
  TRsTuiQinPlanArray = array of RRsTuiQinPlan;
implementation

{ RRsTrainPlan }

procedure RRsTrainPlan.Clone(Source: RRsTrainPlan);
begin
  strPlaceID := Source.strPlaceID ;
  strTrainPlanGUID := Source.strTrainPlanGUID;
  strTrainTypeName := Source.strTrainTypeName;
  strTrainNumber := Source.strTrainNumber;
  strTrainNo := Source.strTrainNo;
  dtStartTime := Source.dtStartTime;
  dtChuQinTime := Source.dtChuQinTime ;
  dtRealStartTime := Source.dtRealStartTime;
  dtFirstStartTime := Source.dtFirstStartTime;
  strTrainJiaoluGUID := Source.strTrainJiaoluGUID;
  strTrainJiaoluName := Source.strTrainJiaoluName;
  strStartStation := Source.strStartStation;
  strStartStationName := Source.strStartStationName;
  strEndStation := Source.strEndStation;
  strEndStationName := Source.strEndStationName;
  nTrainmanTypeID := Source.nTrainmanTypeID;
  nPlanType := Source.nPlanType;
  nDragType := Source.nDragType;
  nKeHuoID := Source.nKeHuoID;
  nRemarkType := Source.nRemarkType;
  strRemark := Source.strRemark;
  nPlanState := Source.nPlanState;
  strPlanStateName := Source.strPlanStateName;
  dtLastArriveTime := Source.dtLastArriveTime;
  dtCreateTime := Source.dtCreateTime;
  strCreateSiteGUID := Source.strCreateSiteGUID;
  strCreateSiteName := Source.strCreateSiteName;
  strCreateUserGUID := Source.strCreateUserGUID;
  strCreateUserName := Source.strCreateUserName;
  strMainPlanGUID := Source.strMainPlanGUID;

  //股道号
    strTrackNumber:= Source.strTrackNumber;
    //外勤端客户端GUID
    strWaiQinClientGUID := Source.strWaiQinClientGUID;
    //外勤端客户端编号
    strWaiQinClientNumber:= Source.strWaiQinClientNumber;
    //外勤端客户端名称
    strWaiQinClientName:= Source.strWaiQinClientName;

    dtSendPlanTime:= Source.dtSendPlanTime;
    dtRecvPlanTime:= Source.dtRecvPlanTime;
end;

end.
