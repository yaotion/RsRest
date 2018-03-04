unit uTrainJiaolu;

interface

type
  //折返区间信息
  RRsZheFanQuJian = record
    //折返区间GUID
    strZFQJGUID : string;
    //所属区段GUID 
    strTrainJiaoluGUID : string;
    //所在区间GUID
    nQuJianIndex : Integer;
    //开始站
    strBeginStationGUID : string;
    //开始站名称
    strBeginStationName : string;
    //结束站
    strEndStationGUID : string;
    //结束站名称
    strEndStationName : string;

  end;
  TRsZheFanQuJianArray = array of RRsZheFanQuJian;
  
  //机车交路信息
  RRsTrainJiaolu = record
    //机车交路GUID
    strTrainJiaoluGUID : string;
    //机车交路名称
    strTrainJiaoluName : string;
        //起始站GUID
    strStartStation : string;
    //起始站名称
    strStartStationName: string;
    //终到站GUID
    strEndStation : string;
    //终到站名称
    strEndStationName: string;
    //所属车间
    strWorkShopGUID : string;
    //是否出勤翻牌(0否，1是)
    bIsBeginWorkFP : integer;
    //折返区段
    ZheFanQuJianArray : TRsZheFanQuJianArray;
    //所属线路GUID
    strLineGUID :string;

  end;
  TRsTrainJiaoluArray = array of RRsTrainJiaolu;


  //客户端关注交路
  RRSTrainJiaoluInSite = record
    //记录guid
    strJiaoluInSiteGUID :string;
    //交路guid
    strTrainJiaoluGUID :string;
    //客户端guid
    strSiteGUID:string;
  end;

  TRRSTrainJiaoluInSiteArray = array of RRSTrainJiaoluInSite;

implementation

end.
