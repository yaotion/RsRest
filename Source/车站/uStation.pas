unit uStation;

interface
type
  //车站信息
  RRsStation = record
    strStationGUID : string;
    strStationName : string;
    strStationNumber: string;
    strWorkShopGUID:string;
    strStationPY:string;
  end;
  //车站信息列表
  TRsStationArray = array of RRsStation;
implementation

end.
