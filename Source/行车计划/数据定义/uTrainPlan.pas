unit uTrainPlan;

interface
uses
  uSaftyEnum,uTrainman,uStation,uTrainmanJiaolu,uApparatusCommon;
type
 
  //���ڵص�������Ϣ
  RRsChuQinDiDian = record
    strGUID : string;
    //���ڳ�վGUID
    strStationGUID : string;
    //��������GUID
    strWorkShopGUID : string;
    //���������Ϣʱ��
    nLocalRest : integer;
    //������ǰ����ʱ��
    nLocalPre : integer;
    //��������Ϣʱ��
    nOutRest : integer;
    //�����ǰ����ʱ��
    nOutPre : integer;
    //վ����ǰ����ʱ��
    nZJPre : integer;
    //ҹ�����
    nNightReset : integer;
    //�Ƿ���
    bIsRest : integer;
    //���ʱ��
    dtRestTime : TDatetime;
    //������ʱ��(�а�ʱ��)
    dtCallTime : TDateTime;
    //����ʱ��ʱ��
    nContinueHours : integer;
    //���������
    bRuKuFanPai : integer;
    //�����Ƿ�ͳ�Ƴ���
    bLocalChaolao : integer;
    //����Ƿ�ͳ�Ƴ���
    bOutChaoLao : integer;
  end;
  TRsChuQinDiDianArray = array of RRsChuQinDiDian;

  TRsPlanStateSet = set of TRsPlanState;
 
  //////////////////////////////////////////////////////////////////////////////
  /// ˵���������ƻ�
  //////////////////////////////////////////////////////////////////////////////
  RRsTrainPlan = record
  public
    //
    strPlaceID:string;
    strPlaceName:string;

    strTrainPlanGUID : String;
     //��������
    strTrainTypeName : string;
    //������
    strTrainNumber : string;
    {����}
    strTrainNo : String;
    {����ʱ��}
    dtStartTime : TDateTime;
    //ʵ�ʿ���ʱ��
    dtRealStartTime : TDateTime;
    //��������ʱ��
    dtFirstStartTime : TDateTime;
    // �ֶδ���(��˼Ϊ�ƻ�����ʱ��)
    dtChuQinTime:TDateTime ;
    //ʵ�ʳ���ʱ��
    dtRealBeginWorkTime:TDateTime;
    {������·}
    strTrainJiaoluGUID : String;
   //������·����
    strTrainJiaoluName : string;
    {��ʼվGUID}
    strStartStation : string;
    //��ʼվ����
    strStartStationName : string;
    {�յ�վGUID}
    strEndStation : string;
    //�յ�վ����
    strEndStationName : string;
    //ֵ�˷�ʽ
    nTrainmanTypeID : TRsTrainmanType;

    strTrainmanTypeName:string;
    //�ƻ�����
    nPlanType : TRsPlanType;
    strPlanTypeName:string;
    //ǣ��״̬
    nDragType : TRsDragType;
    strDragTypeName:string;
    //�ͻ�
    nKeHuoID : TRsKehuo;
    strKehuoName:string;
    //��ע����
    nRemarkType : TRsPlanRemarkType;
    strRemarkTypeName:string;
    //��ע����
    strRemark : string;
    //�ƻ�״̬
    nPlanState : TRsPlanState;
    //�ƻ�״̬����
    strPlanStateName : string;
    //��󵽴�ʱ��
    dtLastArriveTime : TDateTime;
     {��¼����ʱ��}
    dtCreateTime : TDateTime;
    //�����Ŀͻ���GUID
    strCreateSiteGUID : string;
    //�����Ŀͻ�������
    strCreateSiteName : string;
    //������
    strCreateUserGUID : string;
    //����������
    strCreateUserName : string;
     //���ƻ�GUID
    strMainPlanGUID: string;

    //�Ƿ���Ҫǿ�� 0:����Ҫ��1����Ҫ
    nNeedRest : integer;
    //����ʱ��
    dtArriveTime : TDateTime;
    //�а�ʱ��
    dtCallTime : TDateTime;
    //�ɵ���
    strTrackNumber: string;
    //���ڶ˿ͻ���GUID
    strWaiQinClientGUID : string;
    //���ڶ˿ͻ��˱��
    strWaiQinClientNumber: string;
    //���ڶ˿ͻ�������
    strWaiQinClientName: string;
    //�ƻ��´�ʱ��
    dtSendPlanTime:TDateTime;
    //�ƻ�����ʱ��
    dtRecvPlanTime:TDateTime;
  public
    procedure Clone(Source: RRsTrainPlan);
  end;
  TRsTrainPlanArray = array of RRsTrainPlan;



  //���ܻ����ƻ�
  RRsReceiveTrainPlan = record
    strPlanID:string;
    TrainPlan:RRsTrainPlan;
    strUserID:string;
    strUserName:string;
    strSiteID:string;
    strSiteName:string;
  end;
  
  //�����ƻ��·���־
  RRsTrainPlanSendLog = record
    //�·���¼GUID
    strSendGUID : string;
    //����
    strTrainNo: string;
    //�����ƻ�����GUID
    strTrainPlanGUID : string;
    //�г���������
    strTrainJiaoluName : string;
    //�ƻ�����ʱ��
    dtStartTime : TDateTime;
    //ʵ�ʿ���ʱ��
    dtRealStartTime : TDateTime;
    //�·��ͻ�������
    strSendSiteName : string;
    //�·�ʱ��
    dtSendTime : TDateTime;
  end;
  TRsTrainPlanSendLogArray = array of RRsTrainPlanSendLog;

  //�����ƻ��Ķ���־
  RRsTrainPlanChangeLog = record
    //�ƻ�GUID
    strTrainPlanGUID : String;
     //��������
    strTrainTypeName : string;
    //������
    strTrainNumber : string;
    {����}
    strTrainNo : String;
    //�ƻ�����ʱ��
    dtStartTime : TDateTime;

    {������·}
    strTrainJiaoluGUID : String;
   //������·����
    strTrainJiaoluName : string;
    {��ʼվGUID}
    strStartStation : string;
    //��ʼվ����
    strStartStationName : string;
    {�յ�վGUID}
    strEndStation : string;
    //�յ�վ����
    strEndStationName : string;
    //ֵ�˷�ʽ
    nTrainmanTypeID : TRsTrainmanType;

    strTrainmanTypeName:string;
    //�ƻ�����
    nPlanType : TRsPlanType;
    strPlanTypeName:string;
    //ǣ��״̬
    nDragType : TRsDragType;
    strDragTypeName:string;
    //�ͻ�
    nKeHuoID : TRsKehuo;
    strKehuoName:string;
    //��ע����
    nRemarkType : TRsPlanRemarkType;
    strRemarkTypeName:string;
    //��ע����
    strRemark : string;
    //�ƻ�״̬
    nPlanState : TRsPlanState;
    {��¼����ʱ��}
    dtCreateTime : TDateTime;
    //�ı�ʱ��
    dtChangeTime:TDateTime ;
  end;
  TRsTrainPlanChangeLogArray = array of RRsTrainPlanChangeLog;


  //�ƻ���Ϣ��Ϣ
  RRsRest = record
  public
    //�Ƿ���Ҫǿ�� 0:����Ҫ��1����Ҫ
    nNeedRest : integer;
    //����ʱ��
    dtArriveTime : TDateTime;
    //�а�ʱ��
    dtCallTime : TDateTime;
  end;

  //��Ա�ƻ�
  RRsTrainmanPlan = record
  public
    //�����ƻ���Ϣ
    TrainPlan : RRsTrainPlan;
    //��Ա�ɰ���Ϣ
    Group : RRsGroup;
    //����ʱ��
    dtBeginWorkTime : TDateTime;
    //�����Ϣ
    RestInfo : RRsRest;
    //�ƻ�ID
    strPlanID:string;
  end;

  TRsTrainmanPlanArray = array of RRsTrainmanPlan; 
  ///���������Ϣ
  RRsChuQinGroup = record
  public
    Group : RRsGroup;
    
    //��˾����֤��ʽ
    nVerifyID1 : TRsRegisterFlag;
    //��˾����ƽ��
    TestAlcoholInfo1: RTestAlcoholInfo;
   
    
    //��˾����֤��ʽ
    nVerifyID2 : TRsRegisterFlag;
    //��˾����ƽ��
    TestAlcoholInfo2: RTestAlcoholInfo;

    //ѧԱ��֤��ʽ
    nVerifyID3 : TRsRegisterFlag;
    //ѧԱ��ƽ��
    TestAlcoholInfo3: RTestAlcoholInfo;

    //ѧԱ��֤��ʽ
    nVerifyID4 : TRsRegisterFlag;
    //ѧԱ��ƽ��
    TestAlcoholInfo4: RTestAlcoholInfo;

    //����˵��
    strChuQinMemo : string;
  end;

  //���ڼƻ���Ϣ
  RRsChuQinPlan = record
  public
    //�����ƻ���Ϣ
    TrainPlan : RRsTrainPlan;
    //����ʱ��
    dtBeginWorkTime : TDateTime;
    //��Ա����
    ChuQinGroup : RRsChuQinGroup;
    //�����鿨���
    strICCheckResult : string;
    //���ڱ�ע
    strChuQinMemo:string;
  end;
  TRsChuQinPlanArray = array of RRsChuQinPlan;

  //����ƻ���Ϣ
  RRsImportPlan = record
  public
    //�����ƻ���Ϣ
    TrainPlan : RRsTrainPlan;
    //����ʱ��
    dtBeginWorkTime : TDateTime;
    //��Ա��
    Group : RRsGroup;
    //˾��
    Trainman : RRsTrainman;

    //ѡ��
    blnSelected: boolean;
    //��֤��ʽ
    nVerifyID : TRsRegisterFlag;
    //��ƽ��
    TestAlcoholInfo: RTestAlcoholInfo;
    //���ز����ϢID
    nDrinkInfoID: integer;
    //ƥ��
    blnMatched: boolean;
  end;
  TRsImportPlanArray = array of RRsImportPlan;


  //��Ԣ�Ǽ���Ϣ
  RRsInRoomInfo = record
  public
    //�����ƻ�GUID
    strTrainPlanGUID : string;
    //����ԱGUID
    strTrainmanGUID : string;
    //��֤��ʽ
    nVerifyID : TRsRegisterFlag;
    //��Ԣ�����
    strRoomNumber : string;
    //ֵ��Ա���
    strDutyUserGUID : string;
  end;

  //��Ԣ�Ǽ���Ϣ
  RRsOutRoomInfo = record
  public
    //�����ƻ�GUID
    strTrainPlanGUID : string;
    //����ԱGUID
    strTrainmanGUID : string;
    //��֤��ʽ
    nVerifyID : TRsRegisterFlag;
    //ֵ��Ա���
    strDutyUserGUID : string;
  end;
  
  ///�������Ԣ��Ϣ
  RRsInOutGroup = record
  public
    Group : RRsGroup;
    //�����
    strRoomNumber : string;
    //�а����
    CallCount : integer;
    
    //��˾����Ԣ��֤��ʽ
    nInRoomVerifyID1 : TRsRegisterFlag;
    //��˾��Ԣʱ��
    dtInRoomTime1 : TDateTime;

    //��˾����Ԣ��֤��ʽ
    nInRoomVerifyID2 : TRsRegisterFlag;
    //��˾��Ԣʱ��
    dtInRoomTime2 : TDateTime;

    //ѧԱ��Ԣ��֤��ʽ
    nInRoomVerifyID3 : TRsRegisterFlag;
    //ѧԱ��Ԣʱ��
    dtInRoomTime3 : TDateTime;

    //��˾����Ԣ��֤��ʽ
    nOutRoomVerifyID1 : TRsRegisterFlag;
    //��˾��Ԣʱ��
    dtOutRoomTime1 : TDateTime;

    //��˾����Ԣ��֤��ʽ
    nOutRoomVerifyID2 : TRsRegisterFlag;
    //��˾��Ԣʱ��
    dtOutRoomTime2 : TDateTime;

    //ѧԱ��Ԣ��֤��ʽ
    nOutRoomVerifyID3 : TRsRegisterFlag;
    //ѧԱ��Ԣʱ��
    dtOutRoomTime3 : TDateTime;

    //ѧԱ��Ԣ��֤��ʽ
    nOutRoomVerifyID4 : TRsRegisterFlag;
    //ѧԱ��Ԣʱ��
    dtOutRoomTime4 : TDateTime;
  end;
 //����Ԣ�ƻ���Ϣ
  RRsInOutPlan = record
  public
    //�����ƻ���Ϣ
    TrainPlan : RRsTrainPlan;
    //��Ա����Ԣ��Ϣ
    InOutGroup : RRsInOutGroup;
    //���һ���Ƿ�а�ɹ�
    nCallSucceed : integer;
  end;
  TRsInOutPlanArray = array of RRsInOutPlan;

  //���ڻ�����Ϣ                    
  RRsTuiQinGroup = record
    Group : RRsGroup;
    //��˾����֤��ʽ
    nVerifyID1 : TRsRegisterFlag;
    //��˾����ƽ��
    TestAlcoholInfo1: RTestAlcoholInfo;
   
    
    //��˾����֤��ʽ
    nVerifyID2 : TRsRegisterFlag;
    //��˾����ƽ��
    TestAlcoholInfo2: RTestAlcoholInfo;

    //ѧԱ��֤��ʽ
    nVerifyID3 : TRsRegisterFlag;
    //ѧԱ��ƽ��
    TestAlcoholInfo3: RTestAlcoholInfo;

    //ѧԱ��֤��ʽ
    nVerifyID4 : TRsRegisterFlag;
    //ѧԱ��ƽ��
    TestAlcoholInfo4: RTestAlcoholInfo;
  end;
  /////////////////////////////////////////////////////////////////////////////
  /// REndWork :������Ϣ
  /////////////////////////////////////////////////////////////////////////////
  RRsTuiQinPlan = record
    //�����ƻ���Ϣ
    TrainPlan : RRsTrainPlan;
    //����ʱ��
    dtBeginWorkTime : TDateTime;
    //��Ա����
    TuiQinGroup : RRsTuiQinGroup;
    //�˿�ʼʱ��
    dtTurnStartTime : TDateTime;
    //�Ƿ��Ѿ�ǩ��Ԥ�����
    bSigned : integer;
    //Ԥ���Ƿ��Ѿ�����
    bIsOver : integer;
    //����ʱ��
    nTurnMinutes : integer;
    //Ԥ��ʱ��
    nTurnAlarmMinutes : integer;
  end;
  TRsTuiQinPlanArray = array of RRsTuiQinPlan;
implementation

{ RRsTrainPlan }

procedure RRsTrainPlan.Clone(Source: RRsTrainPlan);
begin
  strPlaceID := Source.strPlaceID ;
  strTrainPlanGUID := Source.strTrainPlanGUID;
  strTrainTypeName := Source.strTrainTypeName;
  strTrainNumber := Source.strTrainNumber;
  strTrainNo := Source.strTrainNo;
  dtStartTime := Source.dtStartTime;
  dtChuQinTime := Source.dtChuQinTime ;
  dtRealStartTime := Source.dtRealStartTime;
  dtFirstStartTime := Source.dtFirstStartTime;
  strTrainJiaoluGUID := Source.strTrainJiaoluGUID;
  strTrainJiaoluName := Source.strTrainJiaoluName;
  strStartStation := Source.strStartStation;
  strStartStationName := Source.strStartStationName;
  strEndStation := Source.strEndStation;
  strEndStationName := Source.strEndStationName;
  nTrainmanTypeID := Source.nTrainmanTypeID;
  nPlanType := Source.nPlanType;
  nDragType := Source.nDragType;
  nKeHuoID := Source.nKeHuoID;
  nRemarkType := Source.nRemarkType;
  strRemark := Source.strRemark;
  nPlanState := Source.nPlanState;
  strPlanStateName := Source.strPlanStateName;
  dtLastArriveTime := Source.dtLastArriveTime;
  dtCreateTime := Source.dtCreateTime;
  strCreateSiteGUID := Source.strCreateSiteGUID;
  strCreateSiteName := Source.strCreateSiteName;
  strCreateUserGUID := Source.strCreateUserGUID;
  strCreateUserName := Source.strCreateUserName;
  strMainPlanGUID := Source.strMainPlanGUID;

  //�ɵ���
    strTrackNumber:= Source.strTrackNumber;
    //���ڶ˿ͻ���GUID
    strWaiQinClientGUID := Source.strWaiQinClientGUID;
    //���ڶ˿ͻ��˱��
    strWaiQinClientNumber:= Source.strWaiQinClientNumber;
    //���ڶ˿ͻ�������
    strWaiQinClientName:= Source.strWaiQinClientName;

    dtSendPlanTime:= Source.dtSendPlanTime;
    dtRecvPlanTime:= Source.dtRecvPlanTime;
end;

end.
