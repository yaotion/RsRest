unit uCallNotify;

interface
uses
  uSaftyEnum,superobject,uPubFun;
type
  /////////////////////////////////////////////////////////////////////////////
  //类名:RRsCallNotify
  //描述:叫班通知
  //////////////////////////////////////////////////////////////////////////////
  RRsCallNotify = record
    nCallWorkType:Integer;  //叫班信息类型 0 增加叫班  1 取消叫班
    strTrainPlanGUID:string;         //计划GUID
    strTrainNo:string;          //车次
    dtCallTime:TDateTime;       //叫班时间
    dtChuQinTime:TDateTime;     //出勤时间
    dtStartTime:TDateTime ;     //开车时间
    strMsgGUID:string;          //消息ID
    strSendMsgContent:string;      //发送消息内容
    strRecvMsgContent:string;     //接收消息内容
    dtSendTime:TDateTime;       //通知叫班时间
    strSendUser:string;         //发送人员
    dtRecvTime:TDateTime;       //接收时间
    strRecvUser:string ;        //接收人员
    eCallState:TRsCallWorkState;//叫班状态
    eCallType:TCallType ;       //叫班类型
    nCancel:Integer;          //是否取消
    strCancelReason:string;      //取消原因
    dtCancelTime:TDateTime;      //取消时间
    strCancelUser:string ;       //取消人员
    strTrainmanGUID:string;     //司机GUID
    strTrainmanNumber:string;   //工号
    strTrainmanName:string;     //名字
    strMobileNumber:string;     //电话号码
  public
    {功能:转换为json}
    procedure ToJson(var iJson:ISuperObject);
    {功能:解析json}
    procedure FromJson(iJson :ISuperObject);
  end;
  //叫班通知数组
  TRSCallNotifyAry = array of RRsCallNotify;

implementation



{ RRsCallNotify }

procedure RRsCallNotify.FromJson(iJson :ISuperObject);
begin

  nCallWorkType := iJson.I['nCallWorkType'];//叫班信息类型 0 增加叫班  1 取消叫班
  strTrainPlanGUID := iJson.S['strTrainPlanGUID'];         //计划GUID
  strTrainNo:= iJson.S['strTrainNo'];       //车次
  dtChuQinTime:= TPubFun.Str2DateTime(iJson.S['dtChuQinTime']);    //出勤时间
  dtStartTime:= TPubFun.Str2DateTime(iJson.S['dtStartTime']);     //开车时间
  strMsgGUID:=iJson.S['strMsgGUID'];       //消息ID
  strSendMsgContent:=  iJson.S['strSendMsgContent'];       //消息内容
  strRecvMsgContent:=  iJson.S['strRecvMsgContent'];
  dtSendTime:= TPubFun.Str2DateTime(iJson.S['dtSendTime']);     //通知叫班时间
  strSendUser:= iJson.S['strSendUser'];        //发送人员
  dtRecvTime:= TPubFun.Str2DateTime(iJson.S['dtRecvTime']);       //接收时间
  strRecvUser:=iJson.S['strRecvUser'];       //接收人员
  eCallState:=TRSCallWorkState(iJson.I['eCallState']);//叫班状态
  eCallType:=TCallType(iJson.I['eCallType']);       //叫班类型
  strTrainmanGUID:=iJson.S['strTrainmanGUID'];     //司机GUID
  strTrainmanNumber:=iJson.S['strTrainmanNumber'];   //工号
  strTrainmanName:=iJson.S['strTrainmanName'];     //名字
  strMobileNumber:=iJson.S['strMobileNumber'];     //电话号码
  nCancel:= iJson.I['nCancel'];
  strCancelReason:=iJson.s['strCancelReason'];      //取消原因
  dtCancelTime:= TPubFun.Str2DateTime(iJson.s['dtCancelTime']);      //取消时间
  strCancelUser:=iJson.s['strCancelUser'];        //取消人员

end;

procedure RRsCallNotify.ToJson(var iJson: ISuperObject);
begin
  iJson.I['nCallWorkType'] := nCallWorkType;//叫班信息类型 0 增加叫班  1 取消叫班
  iJson.S['strTrainPlanGUID'] := strTrainPlanGUID;         //计划GUID
  iJson.S['strTrainNo']:= strTrainNo;       //车次
  iJson.S['dtChuQinTime']:= TPubFun.DateTime2Str(dtChuQinTime);    //出勤时间
  iJson.S['dtStartTime']:= TPubFun.DateTime2Str(dtStartTime);     //开车时间
  iJson.S['strMsgGUID']:=strMsgGUID;       //消息ID
  iJson.S['strSendMsgContent']:= strSendMsgContent;       //消息内容
  iJson.S['strRecvMsgContent']:= strRecvMsgContent;
  iJson.S['dtSendTime']:= TPubFun.DateTime2Str(dtSendTime);     //通知叫班时间
  iJson.S['strSendUser']:= strSendUser;        //发送人员
  iJson.S['dtRecvTime']:= TPubFun.DateTime2Str(dtRecvTime);       //接收时间
  iJson.S['strRecvUser']:=strRecvUser;       //接收人员
  iJson.I['eCallState']:=Ord(eCallState);//叫班状态
  iJson.I['eCallType']:=Ord(eCallType);       //叫班类型
  iJson.S['strTrainmanGUID']:=strTrainmanGUID;     //司机GUID
  iJson.S['strTrainmanNumber']:=strTrainmanNumber;   //工号
  iJson.S['strTrainmanName']:=strTrainmanName;     //名字
  iJson.S['strMobileNumber']:=strMobileNumber;     //电话号码
end;


end.
