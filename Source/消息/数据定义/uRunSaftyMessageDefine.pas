unit uRunSaftyMessageDefine;

interface
const
  {出勤}
  TFM_WORK_BEGIN = 10101;
  {退勤}
  TFM_WORK_END = 10201;

  
  {发布人员计划}
  TFM_PLAN_RENYUAN_PUBLISH = 10301;
  {更新人员计划}
  TFM_PLAN_RENYUAN_UPDATE = 10302;
  {撤销人员计划}
  TFM_PLAN_RENYUAN_DELETE = 10303;
  {接收计划}
  TFM_PLAN_RENYUAN_RECIEVE = 10304;
  {移除人员}
  TFM_PLAN_RENYUAN_RMTRAINMAN = 10305;
  {移除机组}
  TFM_PLAN_RENYUAN_RMGROUP = 10306;
  {修改待乘计划}
  TFM_PLAN_RENYUAN_WAITWORK = 10307;
  {签点待乘计划}
  TFM_PLAN_SIGN_WAITWORK = 10308;
  {签点}
  TFM_PLAN_SIGN = 10309;

  {发布机车计划}
  TFM_PLAN_TRAIN_PUBLISH = 10401;
  {更新机车计划}
  TFM_PLAN_TRAIN_UPDATE = 10402;
  {撤销机车计划}
  TFM_PLAN_TRAIN_CANCEL = 10403;
  //运行记录分析完毕
  TFM_PLAN_FINISH = 20000;

  {入寓}
  TFM_ROOM_IN = 10501;
  {离寓}
  TFM_ROOM_OUT = 10502;

  {验卡}
  TFM_OTHER_YANKA = 10901;
  {外点入寓}  
  TFM_SITE_ROOM_IN = 10902;
  {外点离寓}
  TFM_SITE_ROOM_OUT = 10903;
  {终到时间}
  TFM_OTHER_REACHTIME = 10904;
  {过站信息}
  TFM_OTHER_PASSSTATION = 10905;

  {入库}
  TFM_TRAIN_DEPOTS = 10906;
   {文件开始}
  TFM_TRAIN_FILEBEGINEnd = 10907;
  //调车
  TFM_TRAIN_DiaoChe = 10908;


    {叫班信息发送}
  TFM_CALLWORK_PUBLISH = 20001  ;
  {交班信息回执}
  TFM_CALLWORK_UPDATE = 20002 ;
  {叫班信息删除}
  TFM_CALLWORK_DELETE = 20003;

  //发送测酒消息
  TFM_TEST_ALCOHOL = 10601 ;

implementation

end.
