unit uCallRecord;

interface

uses
  Classes,SysUtils,Forms,windows,adodb;
type
   //�а����ݽṹ
  TCallData = class
  public
    //�а�ʱ��
    dtCallTime: TDateTime;
    strTrainNo: string;
    //�ƻ�GUID
    strGUID: string;
    //�ƻ�����(1��ǿ�ݣ�2������)
    nType: Integer;
    //�а�����(0��δ�а�;1���ѽа�;2����׷��)
    //�˴������ϴνа�ʱ����������ʾ
    nCallState: Integer;
    //�����
    strRoomNumber: string;
    //�豸ID
    nDeviceID: Integer;
    //�Ƿ���׷��
    bAlarm : boolean;
    //�ƻ�״̬
    nPlanState : integer;
    //�Ƿ�а�ɹ�
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
