unit uSaftyEnum;

interface
uses
  Graphics;
type
   {TRegisterFlag 乘务员身份登记类别}
  TRsRegisterFlag  = (rfInput{手动输入},rfFingerprint{指纹});
  
  //司机职位信息
  TRsPost = (ptNone{无},ptTrainman {司机}, ptSubTrainman {副司机}, ptLearning {学员});
  TRsPostArray = array of TRsPost;
  
  //驾驶工种
  TRsDriverType = (drtNone{无},drtNeiran{内燃N},drtDian{电车D},drtDong{动O});
  //客货类型
  TRsKehuo = (khNone{无},khKe{客车},khHuo{货车},khDiao{调车});
  TRsKeHuoIDArray = array of TRsKehuo;
  //司机状态
  TRsTrainmanState = (tsUnRuning {非运转}, tsReady {预备}, tsNormal {正常或已退勤},
    tsPlaning {已安排计划}, tsInRoom {已入寓}, tsOutRoom {已离寓}, tsRuning {已出勤},
    tsNil{空人员});

   //计划状态枚举
  TRsPlanState = (psCancel{已取消},psEdit{编辑},psSent{已下发},psReceive{已接收},psPublish{已发布},
     psInRoom{已入寓},psFirstCall{首叫},psReCall{催叫},psServerRoomCall{服务呼叫}, psOutRoom{已离寓},
    psBeginWork{已出勤},psEndWork{已退勤},psErrorFinish{异常结束});

  //TRsSignPlanState = (spsPublish{已发布},spsSign{已签点},spsInRoom{已入寓},spsOutRoom{已出寓}, spsAssigned{已派班});

  //计划备注类型妹夫
  TRsPlanRemarkType  = (prtKuJie=1{库接},prtZhanJie{站接},prtOther{其他});

  //值乘方式枚举
  TRsTrainmanType = (ttNormal=1{正常},ttDoubleDriver{双司机},ttSingleDriver{单司机});
  TRsTrainmanTypeArray = array of TRsTrainmanType;

  //计划类型枚举
  TRsPlanType = (ptYunYong = 1{运用},ptBianCheng{便乘},ptTingKai{停开},ptOther{其他});

  //牵引状态
  TRsDragType = (pdtBuJi=1{补机},pdtBenWu{本务},pdtChongLian{重连},pdtFuGua{附挂},pdtFuJia{附加});
  TRsDragTypeArray = array of TRsDragType;
  //运行类型
  TRsRunType = (trtZFQJ=1{按折返区间},trtHunPao=2{混跑});
    //事件类型
  TRsEventType = (etInroom=10001{入寓},etOutroom=10002{离寓},etBeginWork=10003{出勤},
      etChuKu=10004{出库},etEndWork=10005{退勤},etRuKu=10006{入库},etEnterStation=10007
      {进站},etLeaveStation=10008{出站},etYanKa=20001{验卡},etTestAlchol=30001{测酒});
   //工作流程类型
  TRsWorkTypeID = (wtBeginWork{出勤} = 2,wtEndWork{退勤} = 3,wtForeign{外段} = 10);
  
  //事件覆盖规则
  TRunEventCoverRule = (ecrCover = 1{直接覆盖},ecrIgnore =2{忽略新事件},ecrMin = 3{最小事件覆盖},ecrMax=4{最大时间覆盖}) ;
  //公寓叫班状态
  TRoomCallState = ( TCS_Publish{生成计划},TCS_FIRSTCALL{首叫},TCS_RECALL{催叫},TCS_SERVER_ROOM_CALL{服务室呼叫} );
  //公寓叫班类别
  TRoomCallType =(TCT_AutoCall{自动叫班},TCT_MunualCall{人工叫班},TCT_ReverseCall{反呼},TCT_MonitorCall{监听});
  //叫班状态
  TRsCallWorkState = (cwsNil = 0 {无},cwsNotify{通知叫班},cwsRecv{收到通知},cwsFinish{完成叫班} );
  //叫班类型
  TCallType = (TCT_PHONE{短信叫班},TCT_ROOM{公寓叫班});

  {公寓叫班结果类型}
  TRoomCallResult =(TR_SUCESS{成功},TR_FAIL{失败},TR_CANCEL{取消},TR_TIMEOUT{超时},TR_NONE{未叫});
const
  //身份认证类型名称
  TRsRegisterFlagName : array[TRsRegisterFlag] of string = ('手工','指纹');

  TRsPlanStateNameAry : array[TRsPlanState] of string =
    ('已取消','编辑','已下发','已接收','待候班','已入寓','已首叫','已催叫','服务呼叫','已离寓',
    '已出勤','已退勤','异常结束');
  //TRsSignPlanStateNameAry : array[TRsSignPlanState] of string  = ('已发布','已签点','已入寓','已出寓', '已派班');
  //计划备注类型
  TRsPlanRemarkTypeName : array[TRsPlanRemarkType] of string = ('库接','站接','其他');

  //值乘方式枚举
  TRsTrainmanTypeName : array[TRsTrainmanType] of string = ('正常','双司机','单司机');

  //计划类型枚举
  TRsPlanTypeName : array[TRsPlanType] of string = ('运用','便乘','停开','其他');

   //牵引状态
  TRsDragTypeName : array[TRsDragType] of string = ('补机','本务','重连','附挂','附加');

  TRsKeHuoName : array[TRsKehuo] of string = ('无','客车','货车','调车');

  TRsCallWorkStateName : array[TRsCallWorkState] of string = (' ','已通知','已接收','已完成');

  TRsPlanStateColorAry : array [TRsPlanState] of TColor =
    (clGray{取消},clWhite{编辑},clRed{下发},clYellow{接收},clFuchsia{发布},clAqua{入寓},
    clLime{首叫},clSkyBlue{催叫},clSkyBlue{服务室呼叫},
    clScrollBar{离寓},clWindow{出勤},clSilver{退勤},clRed{异常});

  //公寓叫班状态名称
  TRoomCallStateNameAry :array[TRoomCallState] of string =
    ('待叫','首叫','催叫','服务呼叫' );
   //叫班类别名称
  TRoomCallTypeNameAry : array[TRoomCallType] of string =
    ('自动叫班','人工叫班','反呼','监听');

  TCallTypeNameAry :array[TCallType] of string =
    ('短信叫班','公寓叫班');

  //公寓叫班状态颜色
  TRoomCallStateColorAry : array[TRoomCallState] of TColor  =
          ( clAqua{待叫},clScrollBar{首叫},clWindow{催叫},clWindow);

   {公寓叫班结果类型}
  TRoomCallResultNameAry:array[TRoomCallResult] of string =
      ('成功','失败','取消','超时','未叫');

  DRINK_TEST_CHU_QIN = 2 ;	  //出勤测酒
  DRINK_TEST_TUI_QIN = 3 ;	  //退勤测酒
  DRINK_TEST_IN_ROOM = 4 ;	  //外公寓入寓测酒
  DRINK_TEST_OUT_ROOM = 5 ;	  //外公寓出寓测酒
  DRINK_TEST_OUTER_SIDE = 6 ;	  //外段测酒
  DRINK_TEST_TEST      = 7 ;    //测试测酒
  DRINK_TEST_HAND_WORK = 10	; //手工测酒



  function TrianmanTypeNameToType(strName: string): TRsTrainmanType;
  function PlanRemarkTypeNameToType(strName: string): TRsPlanRemarkType;
  function PlanTypeNameToType(strName: string): TRsPlanType;
  function DragTypeNameToType(strName: string): TRsDragType;
  function KeHuoNameToType(strName: string): TRsKehuo;

implementation
function TrianmanTypeNameToType(strName: string): TRsTrainmanType;
var
  TrainmanType: TRsTrainmanType;
begin
  Result := ttNormal;
  for TrainmanType := Low(TRsTrainmanType) to High(TRsTrainmanType) do
  begin
    if TRsTrainmanTypeName[TrainmanType] = strName then
    begin
      Result := TrainmanType;
      Break;
    end;
  end;
end;
function PlanRemarkTypeNameToType(strName: string): TRsPlanRemarkType;
var
  PlanRemarkType: TRsPlanRemarkType;
begin
  Result := prtKuJie;
  for PlanRemarkType := Low(TRsPlanRemarkType) to High(TRsPlanRemarkType) do
  begin
    if TRsPlanRemarkTypeName[PlanRemarkType] = strName then
    begin
      Result := PlanRemarkType;
      Break;
    end;
  end;
end;
function PlanTypeNameToType(strName: string): TRsPlanType;
var
  PlanType: TRsPlanType;
begin
  Result := ptYunYong; 
  for PlanType := Low(TRsPlanType) to High(TRsPlanType) do
  begin
    if TRsPlanTypeName[PlanType] = strName then
    begin
      Result := PlanType;
      Break;
    end;
  end;
    
end;
function DragTypeNameToType(strName: string): TRsDragType;
var
  DragType: TRsDragType;
begin
  Result := pdtBenWu; 
  for DragType := Low(TRsDragType) to High(TRsDragType) do
  begin
    if TRsDragTypeName[DragType] = strName then
    begin
      Result := DragType;
      Break;
    end;
  end;
    
end;
function KeHuoNameToType(strName: string): TRsKehuo;
var
  Kehuo: TRsKehuo;
begin
  Result := khKe;
  for Kehuo := Low(TRsKehuo) to High(TRsKehuo) do
  begin
    if TRsKeHuoName[Kehuo] = strName then
    begin
      Result := Kehuo;
      Break;
    end;
  end;
end;
end.
