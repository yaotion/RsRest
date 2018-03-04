unit uRunEvent;

interface
uses
  uSaftyEnum;
type
  //事件类型
  TRunEventType = (eteNull = 0{空},
    eteInRoom = 10001{入寓},
    eteOutRoom = 10002{离寓},
    eteBeginWork = 10003{出勤},
    eteOutDepots = 10004{出库},
    eteEndWork = 10005{退勤},
    eteInDepots = 10006{入库},
    eteStopInStation = 10007{停车},
    eteStartFromStation = 10008{开车},
    eteVerifyCard = 20001{验卡},
    eteDrinkTest = 30001{测酒},
    eteFileBegin = 10009{文件开始},
    eteFileEnd = 10010{文件结束},
    eteEnterStation = 10011{进站},
    eteLeaveStation = 10012{出站},
    eteLastStopStation = 10013,{站内最后一次停车}
    eteChangeTrainman = 10014{站内最后一次停车}
    );

    
  //运行事件信息
  RRsRunEvent = record
    strRunEventGUID : string;
    strTrainPlanGUID : string;
    nEventID : TRunEventType;
    strEventName : string;
    dtEventTime : TDateTime;
    strTrainNo : string;
    strTrainTypeName : string;
    strTrainNumber : string;
    nTMIS : integer;
    strStationName : string;
    nKehuo : TRsKehuo;
    strGroupGUID : string;
    strTrainmanNumber1 : string;
    strTrainmanNumber2 : string;
    dtCreateTime : TDateTime;
    nResultID : integer;
    strResult : string;
  end;
  TRsRunEventArray = array of RRsRunEvent;
  //单人运行事件接收记录
  RRsRunEventTrainDetail =record
    strGUID : string;
    strRunEventGUID : string;
    nEventID : TRunEventType;
    dtEventTime : TDateTime;
    strTrainmanNumber1 : string;
    strTrainmanNumber2 : string;
    nTMIS : integer;
    dtCreateTime : TDateTime;
    nResultID : integer;
    strResult : string;
    nKehuo : TRsKehuo;
    strTrainNo : string;
    strTrainTypeName : string;
    strTrainNumber : string;
  end;
  //两人运行事件接收记录
  RRsRunEventTrainmanDetail =record
    strGUID : string;
    strRunEventGUID : string;
    nEventID : TRunEventType;
    dtEventTime : TDateTime;
    strTrainmanNumber : string;
    nTMIS : integer;
    dtCreateTime : TDateTime;
    nResultID : integer;
    strResult : string;
    nSubmitResult : integer;
    strSubmitRemark : string;
    nKehuo : integer;
  end;

  //本段入寓信息
  RRsLocalInRoom = record
    strInRoomGUID : string;
    strTrainPlanGUID : string;
    strTrainmanGUID : string;
    dtInRoomTime : TDateTime;
    nInRoomVerifyID : integer;
    strTrainmanNumber : string;
  end;
  
  //外段离寓信息
  RRsLocalOutRoom = record
    strOutRoomGUID : string;
    strTrainPlanGUID : string;
    strTrainmanGUID : string;
    dtOutRoomTime : TDateTime;
    nOutRoomVerifyID : integer;
    strTrainmanNumber : string;
  end;
implementation

end.
