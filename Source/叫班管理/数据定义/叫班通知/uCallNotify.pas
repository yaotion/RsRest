unit uCallNotify;

interface
uses
  uSaftyEnum,superobject,uPubFun;
type
  /////////////////////////////////////////////////////////////////////////////
  //����:RRsCallNotify
  //����:�а�֪ͨ
  //////////////////////////////////////////////////////////////////////////////
  RRsCallNotify = record
    nCallWorkType:Integer;  //�а���Ϣ���� 0 ���ӽа�  1 ȡ���а�
    strTrainPlanGUID:string;         //�ƻ�GUID
    strTrainNo:string;          //����
    dtCallTime:TDateTime;       //�а�ʱ��
    dtChuQinTime:TDateTime;     //����ʱ��
    dtStartTime:TDateTime ;     //����ʱ��
    strMsgGUID:string;          //��ϢID
    strSendMsgContent:string;      //������Ϣ����
    strRecvMsgContent:string;     //������Ϣ����
    dtSendTime:TDateTime;       //֪ͨ�а�ʱ��
    strSendUser:string;         //������Ա
    dtRecvTime:TDateTime;       //����ʱ��
    strRecvUser:string ;        //������Ա
    eCallState:TRsCallWorkState;//�а�״̬
    eCallType:TCallType ;       //�а�����
    nCancel:Integer;          //�Ƿ�ȡ��
    strCancelReason:string;      //ȡ��ԭ��
    dtCancelTime:TDateTime;      //ȡ��ʱ��
    strCancelUser:string ;       //ȡ����Ա
    strTrainmanGUID:string;     //˾��GUID
    strTrainmanNumber:string;   //����
    strTrainmanName:string;     //����
    strMobileNumber:string;     //�绰����
  public
    {����:ת��Ϊjson}
    procedure ToJson(var iJson:ISuperObject);
    {����:����json}
    procedure FromJson(iJson :ISuperObject);
  end;
  //�а�֪ͨ����
  TRSCallNotifyAry = array of RRsCallNotify;

implementation



{ RRsCallNotify }

procedure RRsCallNotify.FromJson(iJson :ISuperObject);
begin

  nCallWorkType := iJson.I['nCallWorkType'];//�а���Ϣ���� 0 ���ӽа�  1 ȡ���а�
  strTrainPlanGUID := iJson.S['strTrainPlanGUID'];         //�ƻ�GUID
  strTrainNo:= iJson.S['strTrainNo'];       //����
  dtChuQinTime:= TPubFun.Str2DateTime(iJson.S['dtChuQinTime']);    //����ʱ��
  dtStartTime:= TPubFun.Str2DateTime(iJson.S['dtStartTime']);     //����ʱ��
  strMsgGUID:=iJson.S['strMsgGUID'];       //��ϢID
  strSendMsgContent:=  iJson.S['strSendMsgContent'];       //��Ϣ����
  strRecvMsgContent:=  iJson.S['strRecvMsgContent'];
  dtSendTime:= TPubFun.Str2DateTime(iJson.S['dtSendTime']);     //֪ͨ�а�ʱ��
  strSendUser:= iJson.S['strSendUser'];        //������Ա
  dtRecvTime:= TPubFun.Str2DateTime(iJson.S['dtRecvTime']);       //����ʱ��
  strRecvUser:=iJson.S['strRecvUser'];       //������Ա
  eCallState:=TRSCallWorkState(iJson.I['eCallState']);//�а�״̬
  eCallType:=TCallType(iJson.I['eCallType']);       //�а�����
  strTrainmanGUID:=iJson.S['strTrainmanGUID'];     //˾��GUID
  strTrainmanNumber:=iJson.S['strTrainmanNumber'];   //����
  strTrainmanName:=iJson.S['strTrainmanName'];     //����
  strMobileNumber:=iJson.S['strMobileNumber'];     //�绰����
  nCancel:= iJson.I['nCancel'];
  strCancelReason:=iJson.s['strCancelReason'];      //ȡ��ԭ��
  dtCancelTime:= TPubFun.Str2DateTime(iJson.s['dtCancelTime']);      //ȡ��ʱ��
  strCancelUser:=iJson.s['strCancelUser'];        //ȡ����Ա

end;

procedure RRsCallNotify.ToJson(var iJson: ISuperObject);
begin
  iJson.I['nCallWorkType'] := nCallWorkType;//�а���Ϣ���� 0 ���ӽа�  1 ȡ���а�
  iJson.S['strTrainPlanGUID'] := strTrainPlanGUID;         //�ƻ�GUID
  iJson.S['strTrainNo']:= strTrainNo;       //����
  iJson.S['dtChuQinTime']:= TPubFun.DateTime2Str(dtChuQinTime);    //����ʱ��
  iJson.S['dtStartTime']:= TPubFun.DateTime2Str(dtStartTime);     //����ʱ��
  iJson.S['strMsgGUID']:=strMsgGUID;       //��ϢID
  iJson.S['strSendMsgContent']:= strSendMsgContent;       //��Ϣ����
  iJson.S['strRecvMsgContent']:= strRecvMsgContent;
  iJson.S['dtSendTime']:= TPubFun.DateTime2Str(dtSendTime);     //֪ͨ�а�ʱ��
  iJson.S['strSendUser']:= strSendUser;        //������Ա
  iJson.S['dtRecvTime']:= TPubFun.DateTime2Str(dtRecvTime);       //����ʱ��
  iJson.S['strRecvUser']:=strRecvUser;       //������Ա
  iJson.I['eCallState']:=Ord(eCallState);//�а�״̬
  iJson.I['eCallType']:=Ord(eCallType);       //�а�����
  iJson.S['strTrainmanGUID']:=strTrainmanGUID;     //˾��GUID
  iJson.S['strTrainmanNumber']:=strTrainmanNumber;   //����
  iJson.S['strTrainmanName']:=strTrainmanName;     //����
  iJson.S['strMobileNumber']:=strMobileNumber;     //�绰����
end;


end.
