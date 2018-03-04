unit uTrainmanJiaolu;

interface
uses
  uTrainman,uStation,uSaftyEnum,uTrainJiaolu,uDutyPlace;
type
  //交路类型枚举
  TRsJiaoluType = (jltAny=-1,jltUnrun{非运转},jltReady{预备},jltNamed{记名式},jltOrder{轮乘},jltTogether{包乘});

  //人员交路
  RRsTrainmanJiaolu = record
    //人员交路GUID
    strTrainmanJiaoluGUID : string;
    //人员交路名称
    strTrainmanJiaoluName : string;
    //交路类型
    nJiaoluType : TRsJiaoluType;
    //所属线路
    strLineGUID : string;
    //所属区段
//    strTrainJiaoluGUID : string;
    //客货类型
    nKeHuoID : TRsKehuo;
    //值乘类型
    nTrainmanTypeID : TRsTrainmanType;
    //牵引类型
    nDragTypeID : TRsDragType;
    //交路运行类型
    nTrainmanRunType : TRsRunType;
    //开始车站GUID
    strStartStationGUID : string;
    //开始车站名称
    strStartStationName : string;
    //结束车站GUID
    strEndStationGUID : string;
    //结束车站名称
    strEndStationName : string;
    //所属区域
    strAreaGUID : string;

  end;
  //人员交路数组
  TRsTrainmanJiaoluArray = array of RRsTrainmanJiaolu;

  //人员交路带下发计划的数量
  RRsTrainmanJiaoluSendCount = record
  public
     TrainmanJiaolu : RRsTrainmanJiaolu;
     SendCount : Integer; 
  end;  
  TRsTrainmanJiaoluSendCountArray = array of RRsTrainmanJiaoluSendCount;
  
  //车次类型
  TRsCheciType = (cctCheci{实际车次},cctRest{休班});
  //机班信息
  RRsGroup = record
    //机班GUID
    strGroupGUID : string;
    //出勤低点
    place:RRsDutyPlace;
    //机班所在车站
    Station : RRsStation;
    //所在折返区间的GUID
    ZFQJ : RRsZheFanQuJian;
    //正司机
    Trainman1 : RRsTrainman;
    //副司机
    Trainman2 : RRsTrainman;
    //学员
    Trainman3 : RRsTrainman;
    //学员2
    Trainman4 : RRsTrainman;
    //机组状态
    GroupState : TRsTrainmanState;
    //当前值乘的计划的GUID
    strTrainPlanGUID : string;
    //最近到达时间
    dtArriveTime : TDateTime;
    //四i最近一次入寓时间
    dtLastInRoomTime1 : TDateTime;
    //司机2最近一次入寓时间
    dtLastInRoomTime2 : TDateTime;
    //学员最后一次入寓时间
    dtLastInRoomTime3 : TDateTime;
    //学员最后一次入寓时间
    dtLastInRoomTime4 : TDateTime;
  end;
  TRsGroupArray = array of RRsGroup;
  
  //记名式交路内机班信息
  RRsNamedGroup = record
    //车次GUID
    strCheciGUID : string;
    //所属人员交路GUID
    strTrainmanJiaoluGUID : string;
    //交路内序号
    nCheciOrder : integer;
    //车次类型
    nCheciType : TRsCheciType;
    //车次1
    strCheci1 : string;
    //车次2
    strCheci2 : string;
    //当班机组
    Group : RRsGroup;
    //最后一次到达时间
    dtLastArriveTime : TDateTime; 
  end;
  TRsNamedGroupArray = array of RRsNamedGroup;

  //轮乘交路内机班信息
  RRsOrderGroup = record
    //排序GUID
    strOrderGUID : string;
    //所属交路GUID
    strTrainmanJiaoluGUID : string;
    //序号
    nOrder : integer;
    //当班机组
    Group : RRsGroup;
    //最后一次到达时间
    dtLastArriveTime : TDateTime;
  end;  
  TRsOrderGroupArray = array of RRsOrderGroup;

  //包成交路内机班信息
  RRsOrderGroupInTrain = record
    //排序GUID
    strOrderGUID : string;
    //所属机车GUID
    strTrainGUID : string;
    //序号
    nOrder : integer;
    //当班机组
    Group : RRsGroup;
    //最后一次到达时间
    dtLastArriveTime : TDateTime;
  end;  
  TRsOrderGroupInTrainArray = array of RRsOrderGroupInTrain;

  //包乘机车信息
  RRsTogetherTrain = record
    //包乘机车GUID
    strTrainGUID : string;
    //所属交路GUID
    strTrainmanJiaoluGUID : string;
    //机车类型
    strTrainTypeName : string;
    //机车号
    strTrainNumber : string;
    //包含的机组
    Groups : TRsOrderGroupInTrainArray;
  end;
  TRsTogetherTrainArray = array of RRsTogetherTrain;

  //非运转或预备项
  RRsOtherGroup = record
    strTrainmanJiaoluGUID : string;
    Trainman : RRsTrainman;
    Station : RRsStation;
  end;
  TRsOtherGroupArray = array of RRsOtherGroup;

  //乘务员信息，附带所在交路信息
  RRsTrainmanWithJL = record
    Trainman : RRsTrainman;
    TrainmanJiaolu : RRsTrainmanJiaolu;
  end;
  TRsTrainmanWithJLArray = array of RRsTrainmanWithJL;
  
  //乘务员在班组内的信息
  RRsTrainmanInGroup = record
    strTrainmanGUID : string;
    strGroupGUID :string;
    nTrainmanIndex : integer;
  end;

  //派班相关参数信息：自动保存派班时间1、自动保存派班时间2、睡眠时间等
  RRsPlanParam = record
    dtAutoSaveTime1: TDateTime;     //自动保存时间1
    dtAutoSaveTime2: TDateTime;     //自动保存时间2
    dtPlanBeginTime: TDateTime;     //计划开始时间
    dtPlanEndTime: TDateTime;       //计划结束时间
    dtKeepSleepTime: TDateTime;     //睡眠时间
    bEnableSleepCheck: Boolean;     //是否进行寓休卡控
  end;
  //////////////////////////////////////////////////////////////////////////////
  ///类名:RRsKernelTimeConfig
  ///描述:运安系统时间参数
  //////////////////////////////////////////////////////////////////////////////
  RRsKernelTimeConfig = record
    //叫班时间 早于 计划出勤时间 分钟数
    nMinCallBeforeChuQing:Integer;
    //站接方式 计划出勤时间 早于 计划开车时间 分钟数
    nMinChuQingBeforeStartTrain_Z :Integer;
    //库接方式 计划出勤时间 早于 计划开车时间 分钟数
    nMinChuQingBeforeStartTrain_K :Integer;
    //白班开始时间 相对于 0点的分钟数
    nMinDayWorkStart:Integer;
    //夜班开始时间 相对于 0点的分钟数
    nMinNightWokrStart:TDateTime;

  end;

    RTrainmanRunStateCount = record
    strJiaoLuName : string;
    //运行中
    nRuningCount:Integer ;
    //本段休息
    nLocalCount : Integer ;
    //外段休息
    nSiteCount:Integer;
    //组信息
    group:TRsGroupArray;
  end;

  TRTrainmanRunStateCountArray = array of  RTrainmanRunStateCount;

implementation


end.
