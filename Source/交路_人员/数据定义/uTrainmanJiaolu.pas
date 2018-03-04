unit uTrainmanJiaolu;

interface
uses
  uTrainman,uStation,uSaftyEnum,uTrainJiaolu,uDutyPlace;
type
  //��·����ö��
  TRsJiaoluType = (jltAny=-1,jltUnrun{����ת},jltReady{Ԥ��},jltNamed{����ʽ},jltOrder{�ֳ�},jltTogether{����});

  //��Ա��·
  RRsTrainmanJiaolu = record
    //��Ա��·GUID
    strTrainmanJiaoluGUID : string;
    //��Ա��·����
    strTrainmanJiaoluName : string;
    //��·����
    nJiaoluType : TRsJiaoluType;
    //������·
    strLineGUID : string;
    //��������
//    strTrainJiaoluGUID : string;
    //�ͻ�����
    nKeHuoID : TRsKehuo;
    //ֵ������
    nTrainmanTypeID : TRsTrainmanType;
    //ǣ������
    nDragTypeID : TRsDragType;
    //��·��������
    nTrainmanRunType : TRsRunType;
    //��ʼ��վGUID
    strStartStationGUID : string;
    //��ʼ��վ����
    strStartStationName : string;
    //������վGUID
    strEndStationGUID : string;
    //������վ����
    strEndStationName : string;
    //��������
    strAreaGUID : string;

  end;
  //��Ա��·����
  TRsTrainmanJiaoluArray = array of RRsTrainmanJiaolu;

  //��Ա��·���·��ƻ�������
  RRsTrainmanJiaoluSendCount = record
  public
     TrainmanJiaolu : RRsTrainmanJiaolu;
     SendCount : Integer; 
  end;  
  TRsTrainmanJiaoluSendCountArray = array of RRsTrainmanJiaoluSendCount;
  
  //��������
  TRsCheciType = (cctCheci{ʵ�ʳ���},cctRest{�ݰ�});
  //������Ϣ
  RRsGroup = record
    //����GUID
    strGroupGUID : string;
    //���ڵ͵�
    place:RRsDutyPlace;
    //�������ڳ�վ
    Station : RRsStation;
    //�����۷������GUID
    ZFQJ : RRsZheFanQuJian;
    //��˾��
    Trainman1 : RRsTrainman;
    //��˾��
    Trainman2 : RRsTrainman;
    //ѧԱ
    Trainman3 : RRsTrainman;
    //ѧԱ2
    Trainman4 : RRsTrainman;
    //����״̬
    GroupState : TRsTrainmanState;
    //��ǰֵ�˵ļƻ���GUID
    strTrainPlanGUID : string;
    //�������ʱ��
    dtArriveTime : TDateTime;
    //��i���һ����Ԣʱ��
    dtLastInRoomTime1 : TDateTime;
    //˾��2���һ����Ԣʱ��
    dtLastInRoomTime2 : TDateTime;
    //ѧԱ���һ����Ԣʱ��
    dtLastInRoomTime3 : TDateTime;
    //ѧԱ���һ����Ԣʱ��
    dtLastInRoomTime4 : TDateTime;
  end;
  TRsGroupArray = array of RRsGroup;
  
  //����ʽ��·�ڻ�����Ϣ
  RRsNamedGroup = record
    //����GUID
    strCheciGUID : string;
    //������Ա��·GUID
    strTrainmanJiaoluGUID : string;
    //��·�����
    nCheciOrder : integer;
    //��������
    nCheciType : TRsCheciType;
    //����1
    strCheci1 : string;
    //����2
    strCheci2 : string;
    //�������
    Group : RRsGroup;
    //���һ�ε���ʱ��
    dtLastArriveTime : TDateTime; 
  end;
  TRsNamedGroupArray = array of RRsNamedGroup;

  //�ֳ˽�·�ڻ�����Ϣ
  RRsOrderGroup = record
    //����GUID
    strOrderGUID : string;
    //������·GUID
    strTrainmanJiaoluGUID : string;
    //���
    nOrder : integer;
    //�������
    Group : RRsGroup;
    //���һ�ε���ʱ��
    dtLastArriveTime : TDateTime;
  end;  
  TRsOrderGroupArray = array of RRsOrderGroup;

  //���ɽ�·�ڻ�����Ϣ
  RRsOrderGroupInTrain = record
    //����GUID
    strOrderGUID : string;
    //��������GUID
    strTrainGUID : string;
    //���
    nOrder : integer;
    //�������
    Group : RRsGroup;
    //���һ�ε���ʱ��
    dtLastArriveTime : TDateTime;
  end;  
  TRsOrderGroupInTrainArray = array of RRsOrderGroupInTrain;

  //���˻�����Ϣ
  RRsTogetherTrain = record
    //���˻���GUID
    strTrainGUID : string;
    //������·GUID
    strTrainmanJiaoluGUID : string;
    //��������
    strTrainTypeName : string;
    //������
    strTrainNumber : string;
    //�����Ļ���
    Groups : TRsOrderGroupInTrainArray;
  end;
  TRsTogetherTrainArray = array of RRsTogetherTrain;

  //����ת��Ԥ����
  RRsOtherGroup = record
    strTrainmanJiaoluGUID : string;
    Trainman : RRsTrainman;
    Station : RRsStation;
  end;
  TRsOtherGroupArray = array of RRsOtherGroup;

  //����Ա��Ϣ���������ڽ�·��Ϣ
  RRsTrainmanWithJL = record
    Trainman : RRsTrainman;
    TrainmanJiaolu : RRsTrainmanJiaolu;
  end;
  TRsTrainmanWithJLArray = array of RRsTrainmanWithJL;
  
  //����Ա�ڰ����ڵ���Ϣ
  RRsTrainmanInGroup = record
    strTrainmanGUID : string;
    strGroupGUID :string;
    nTrainmanIndex : integer;
  end;

  //�ɰ���ز�����Ϣ���Զ������ɰ�ʱ��1���Զ������ɰ�ʱ��2��˯��ʱ���
  RRsPlanParam = record
    dtAutoSaveTime1: TDateTime;     //�Զ�����ʱ��1
    dtAutoSaveTime2: TDateTime;     //�Զ�����ʱ��2
    dtPlanBeginTime: TDateTime;     //�ƻ���ʼʱ��
    dtPlanEndTime: TDateTime;       //�ƻ�����ʱ��
    dtKeepSleepTime: TDateTime;     //˯��ʱ��
    bEnableSleepCheck: Boolean;     //�Ƿ����Ԣ�ݿ���
  end;
  //////////////////////////////////////////////////////////////////////////////
  ///����:RRsKernelTimeConfig
  ///����:�˰�ϵͳʱ�����
  //////////////////////////////////////////////////////////////////////////////
  RRsKernelTimeConfig = record
    //�а�ʱ�� ���� �ƻ�����ʱ�� ������
    nMinCallBeforeChuQing:Integer;
    //վ�ӷ�ʽ �ƻ�����ʱ�� ���� �ƻ�����ʱ�� ������
    nMinChuQingBeforeStartTrain_Z :Integer;
    //��ӷ�ʽ �ƻ�����ʱ�� ���� �ƻ�����ʱ�� ������
    nMinChuQingBeforeStartTrain_K :Integer;
    //�װ࿪ʼʱ�� ����� 0��ķ�����
    nMinDayWorkStart:Integer;
    //ҹ�࿪ʼʱ�� ����� 0��ķ�����
    nMinNightWokrStart:TDateTime;

  end;

    RTrainmanRunStateCount = record
    strJiaoLuName : string;
    //������
    nRuningCount:Integer ;
    //������Ϣ
    nLocalCount : Integer ;
    //�����Ϣ
    nSiteCount:Integer;
    //����Ϣ
    group:TRsGroupArray;
  end;

  TRTrainmanRunStateCountArray = array of  RTrainmanRunStateCount;

implementation


end.
