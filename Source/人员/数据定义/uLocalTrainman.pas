unit uLocalTrainman;

interface
uses
  Classes,SysUtils;
type
  //司机信息
  RRsLocalTrainman = record
    //司机nID
    nID: integer;
    //司机GUID
    strTrainmanGUID: string;
    //司机姓名
    strTrainmanName: string;
    //司机工号
    strTrainmanNumber: string;
    //联系电话
    strTelNumber: string;
    //手机号
    strMobileNumber : string;
   {指纹1}
    //FingerPrint1 : OleVariant;
    {指纹2}
    //FingerPrint2 : OleVariant;
    //测酒照片
    //Picture : OleVariant;
    //姓名简拼
    strJP : string;
  end;
  TRsLocalTrainmanArray = array of RRsLocalTrainman;
implementation

end.
