unit uSaftyEnum;

interface
uses
  Graphics;
type
   {TRegisterFlag ����Ա��ݵǼ����}
  TRsRegisterFlag  = (rfInput{�ֶ�����},rfFingerprint{ָ��});
  
  //˾��ְλ��Ϣ
  TRsPost = (ptNone{��},ptTrainman {˾��}, ptSubTrainman {��˾��}, ptLearning {ѧԱ});
  TRsPostArray = array of TRsPost;
  
  //��ʻ����
  TRsDriverType = (drtNone{��},drtNeiran{��ȼN},drtDian{�糵D},drtDong{��O});
  //�ͻ�����
  TRsKehuo = (khNone{��},khKe{�ͳ�},khHuo{����},khDiao{����});
  TRsKeHuoIDArray = array of TRsKehuo;
  //˾��״̬
  TRsTrainmanState = (tsUnRuning {����ת}, tsReady {Ԥ��}, tsNormal {������������},
    tsPlaning {�Ѱ��żƻ�}, tsInRoom {����Ԣ}, tsOutRoom {����Ԣ}, tsRuning {�ѳ���},
    tsNil{����Ա});

   //�ƻ�״̬ö��
  TRsPlanState = (psCancel{��ȡ��},psEdit{�༭},psSent{���·�},psReceive{�ѽ���},psPublish{�ѷ���},
     psInRoom{����Ԣ},psFirstCall{�׽�},psReCall{�߽�},psServerRoomCall{�������}, psOutRoom{����Ԣ},
    psBeginWork{�ѳ���},psEndWork{������},psErrorFinish{�쳣����});

  //TRsSignPlanState = (spsPublish{�ѷ���},spsSign{��ǩ��},spsInRoom{����Ԣ},spsOutRoom{�ѳ�Ԣ}, spsAssigned{���ɰ�});

  //�ƻ���ע�����÷�
  TRsPlanRemarkType  = (prtKuJie=1{���},prtZhanJie{վ��},prtOther{����});

  //ֵ�˷�ʽö��
  TRsTrainmanType = (ttNormal=1{����},ttDoubleDriver{˫˾��},ttSingleDriver{��˾��});
  TRsTrainmanTypeArray = array of TRsTrainmanType;

  //�ƻ�����ö��
  TRsPlanType = (ptYunYong = 1{����},ptBianCheng{���},ptTingKai{ͣ��},ptOther{����});

  //ǣ��״̬
  TRsDragType = (pdtBuJi=1{����},pdtBenWu{����},pdtChongLian{����},pdtFuGua{����},pdtFuJia{����});
  TRsDragTypeArray = array of TRsDragType;
  //��������
  TRsRunType = (trtZFQJ=1{���۷�����},trtHunPao=2{����});
    //�¼�����
  TRsEventType = (etInroom=10001{��Ԣ},etOutroom=10002{��Ԣ},etBeginWork=10003{����},
      etChuKu=10004{����},etEndWork=10005{����},etRuKu=10006{���},etEnterStation=10007
      {��վ},etLeaveStation=10008{��վ},etYanKa=20001{�鿨},etTestAlchol=30001{���});
   //������������
  TRsWorkTypeID = (wtBeginWork{����} = 2,wtEndWork{����} = 3,wtForeign{���} = 10);
  
  //�¼����ǹ���
  TRunEventCoverRule = (ecrCover = 1{ֱ�Ӹ���},ecrIgnore =2{�������¼�},ecrMin = 3{��С�¼�����},ecrMax=4{���ʱ�串��}) ;
  //��Ԣ�а�״̬
  TRoomCallState = ( TCS_Publish{���ɼƻ�},TCS_FIRSTCALL{�׽�},TCS_RECALL{�߽�},TCS_SERVER_ROOM_CALL{�����Һ���} );
  //��Ԣ�а����
  TRoomCallType =(TCT_AutoCall{�Զ��а�},TCT_MunualCall{�˹��а�},TCT_ReverseCall{����},TCT_MonitorCall{����});
  //�а�״̬
  TRsCallWorkState = (cwsNil = 0 {��},cwsNotify{֪ͨ�а�},cwsRecv{�յ�֪ͨ},cwsFinish{��ɽа�} );
  //�а�����
  TCallType = (TCT_PHONE{���Žа�},TCT_ROOM{��Ԣ�а�});

  {��Ԣ�а�������}
  TRoomCallResult =(TR_SUCESS{�ɹ�},TR_FAIL{ʧ��},TR_CANCEL{ȡ��},TR_TIMEOUT{��ʱ},TR_NONE{δ��});
const
  //�����֤��������
  TRsRegisterFlagName : array[TRsRegisterFlag] of string = ('�ֹ�','ָ��');

  TRsPlanStateNameAry : array[TRsPlanState] of string =
    ('��ȡ��','�༭','���·�','�ѽ���','�����','����Ԣ','���׽�','�Ѵ߽�','�������','����Ԣ',
    '�ѳ���','������','�쳣����');
  //TRsSignPlanStateNameAry : array[TRsSignPlanState] of string  = ('�ѷ���','��ǩ��','����Ԣ','�ѳ�Ԣ', '���ɰ�');
  //�ƻ���ע����
  TRsPlanRemarkTypeName : array[TRsPlanRemarkType] of string = ('���','վ��','����');

  //ֵ�˷�ʽö��
  TRsTrainmanTypeName : array[TRsTrainmanType] of string = ('����','˫˾��','��˾��');

  //�ƻ�����ö��
  TRsPlanTypeName : array[TRsPlanType] of string = ('����','���','ͣ��','����');

   //ǣ��״̬
  TRsDragTypeName : array[TRsDragType] of string = ('����','����','����','����','����');

  TRsKeHuoName : array[TRsKehuo] of string = ('��','�ͳ�','����','����');

  TRsCallWorkStateName : array[TRsCallWorkState] of string = (' ','��֪ͨ','�ѽ���','�����');

  TRsPlanStateColorAry : array [TRsPlanState] of TColor =
    (clGray{ȡ��},clWhite{�༭},clRed{�·�},clYellow{����},clFuchsia{����},clAqua{��Ԣ},
    clLime{�׽�},clSkyBlue{�߽�},clSkyBlue{�����Һ���},
    clScrollBar{��Ԣ},clWindow{����},clSilver{����},clRed{�쳣});

  //��Ԣ�а�״̬����
  TRoomCallStateNameAry :array[TRoomCallState] of string =
    ('����','�׽�','�߽�','�������' );
   //�а��������
  TRoomCallTypeNameAry : array[TRoomCallType] of string =
    ('�Զ��а�','�˹��а�','����','����');

  TCallTypeNameAry :array[TCallType] of string =
    ('���Žа�','��Ԣ�а�');

  //��Ԣ�а�״̬��ɫ
  TRoomCallStateColorAry : array[TRoomCallState] of TColor  =
          ( clAqua{����},clScrollBar{�׽�},clWindow{�߽�},clWindow);

   {��Ԣ�а�������}
  TRoomCallResultNameAry:array[TRoomCallResult] of string =
      ('�ɹ�','ʧ��','ȡ��','��ʱ','δ��');

  DRINK_TEST_CHU_QIN = 2 ;	  //���ڲ��
  DRINK_TEST_TUI_QIN = 3 ;	  //���ڲ��
  DRINK_TEST_IN_ROOM = 4 ;	  //�⹫Ԣ��Ԣ���
  DRINK_TEST_OUT_ROOM = 5 ;	  //�⹫Ԣ��Ԣ���
  DRINK_TEST_OUTER_SIDE = 6 ;	  //��β��
  DRINK_TEST_TEST      = 7 ;    //���Բ��
  DRINK_TEST_HAND_WORK = 10	; //�ֹ����



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
