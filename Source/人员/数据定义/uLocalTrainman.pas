unit uLocalTrainman;

interface
uses
  Classes,SysUtils;
type
  //˾����Ϣ
  RRsLocalTrainman = record
    //˾��nID
    nID: integer;
    //˾��GUID
    strTrainmanGUID: string;
    //˾������
    strTrainmanName: string;
    //˾������
    strTrainmanNumber: string;
    //��ϵ�绰
    strTelNumber: string;
    //�ֻ���
    strMobileNumber : string;
   {ָ��1}
    //FingerPrint1 : OleVariant;
    {ָ��2}
    //FingerPrint2 : OleVariant;
    //�����Ƭ
    //Picture : OleVariant;
    //������ƴ
    strJP : string;
  end;
  TRsLocalTrainmanArray = array of RRsLocalTrainman;
implementation

end.
