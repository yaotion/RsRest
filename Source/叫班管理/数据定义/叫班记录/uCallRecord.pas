unit uCallRecord;

interface

uses
  Classes,SysUtils,Forms,windows,adodb;
type
   //叫班数据结构
  TCallData = class
  public
    //叫班时间
    dtCallTime: TDateTime;
    strTrainNo: string;
    //计划GUID
    strGUID: string;
    //计划类型(1：强休；2：待乘)
    nType: Integer;
    //叫班类型(0：未叫班;1：已叫班;2：已追叫)
    //此处根据上次叫班时间来限制显示
    nCallState: Integer;
    //房间号
    strRoomNumber: string;
    //设备ID
    nDeviceID: Integer;
    //是否已追叫
    bAlarm : boolean;
    //计划状态
    nPlanState : integer;
    //是否叫班成功
    nCallSucceed : integer;
  end;

  RCallRecord = record
    strGUID : string;
    strPlanGUID : string;
    dtCreateTime : TDateTime;
    strRoomNumber : string;
    strTrainNo : string;
    bIsRecall : integer;
    bCallSucceed : integer;
    CallRecord : TMemoryStream;
    strDutyGUID : string;
    strAreaGUID : string;
  end;


implementation

end.
