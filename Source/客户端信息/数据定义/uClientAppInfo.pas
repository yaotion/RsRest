unit uClientAppInfo;

interface

type
  RRsClientAppInfo = record
    strClientID:string;     //客户端ID
    strClientVersion:string; //客户端版本
    dtLogInTime:TDateTime;    //最近登录时间
    dtCreateTime:TDateTime; //建立时间
  end;


implementation

end.
