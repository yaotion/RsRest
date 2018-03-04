unit uGuideGroup;

interface

type
  //指导组信息
  RRsGuideGroup = record
    //指导组GUID
    strGuideGroupGUID : string;
    //所属车间
    strWorkShopGUID : string;
    //指导组名称
    strGuideGroupName  :string;
  end;
  TRsGuideGroupArray = array of RRsGuideGroup;
implementation

end.
