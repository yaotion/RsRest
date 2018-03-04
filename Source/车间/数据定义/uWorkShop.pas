unit uWorkShop;

interface

type
  //车间信息
  RRsWorkShop = record
    //车间GUID
    strWorkShopGUID : string;
    //所属机务段GUID
    strAreaGUID : string;
    //车间名称
    strWorkShopName : string;
    //车间编号
    strWorkShopNumber:string;
  end;
  TRsWorkShopArray = array of RRsWorkShop;
implementation

end.
