unit uLeaderExam;

interface
uses
  Classes,SysUtils,Forms,windows,adodb;
type
  //////////////////////////////////////////////////////////////////////////////
  //干部检查
  //////////////////////////////////////////////////////////////////////////////
  RRsLeaderExam = record
    GUID : string;
    LeaderGUID : string;    //干部GUID
    AreaGUID : string;     //检查区域GUID
    VerifyID :  Integer;     //验证方式ID
    CreateTime : TDateTime; //检查时间
    DutyGUID : string;      //值班员GUID

    public
      procedure Init;
  end;


  RRsLeaderInspect = record
    GUID : string;
    LeaderGUID : string;    //干部GUID
    strTrainmanNumber:string;
    strTrainmanName:string;
    strContext:string;
    AreaGUID : string;     //检查区域GUID
    VerifyID :  Integer;     //验证方式ID
    CreateTime : TDateTime; //检查时间
    DutyGUID : string;      //值班员GUID

  end;



  TRsLeaderInspectList = array of RRsLeaderInspect ;


implementation



{ RLeaderExam }

procedure RRsLeaderExam.Init;
begin

end;

end.
