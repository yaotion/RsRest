unit uRunEvent;

interface
uses
  uSaftyEnum;
type
  //�¼�����
  TRunEventType = (eteNull = 0{��},
    eteInRoom = 10001{��Ԣ},
    eteOutRoom = 10002{��Ԣ},
    eteBeginWork = 10003{����},
    eteOutDepots = 10004{����},
    eteEndWork = 10005{����},
    eteInDepots = 10006{���},
    eteStopInStation = 10007{ͣ��},
    eteStartFromStation = 10008{����},
    eteVerifyCard = 20001{�鿨},
    eteDrinkTest = 30001{���},
    eteFileBegin = 10009{�ļ���ʼ},
    eteFileEnd = 10010{�ļ�����},
    eteEnterStation = 10011{��վ},
    eteLeaveStation = 10012{��վ},
    eteLastStopStation = 10013,{վ�����һ��ͣ��}
    eteChangeTrainman = 10014{վ�����һ��ͣ��}
    );

    
  //�����¼���Ϣ
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
  //���������¼����ռ�¼
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
  //���������¼����ռ�¼
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

  //������Ԣ��Ϣ
  RRsLocalInRoom = record
    strInRoomGUID : string;
    strTrainPlanGUID : string;
    strTrainmanGUID : string;
    dtInRoomTime : TDateTime;
    nInRoomVerifyID : integer;
    strTrainmanNumber : string;
  end;
  
  //�����Ԣ��Ϣ
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
