unit uLeaderExam;

interface
uses
  Classes,SysUtils,Forms,windows,adodb;
type
  //////////////////////////////////////////////////////////////////////////////
  //�ɲ����
  //////////////////////////////////////////////////////////////////////////////
  RRsLeaderExam = record
    GUID : string;
    LeaderGUID : string;    //�ɲ�GUID
    AreaGUID : string;     //�������GUID
    VerifyID :  Integer;     //��֤��ʽID
    CreateTime : TDateTime; //���ʱ��
    DutyGUID : string;      //ֵ��ԱGUID

    public
      procedure Init;
  end;


  RRsLeaderInspect = record
    GUID : string;
    LeaderGUID : string;    //�ɲ�GUID
    strTrainmanNumber:string;
    strTrainmanName:string;
    strContext:string;
    AreaGUID : string;     //�������GUID
    VerifyID :  Integer;     //��֤��ʽID
    CreateTime : TDateTime; //���ʱ��
    DutyGUID : string;      //ֵ��ԱGUID

  end;



  TRsLeaderInspectList = array of RRsLeaderInspect ;


implementation



{ RLeaderExam }

procedure RRsLeaderExam.Init;
begin

end;

end.
