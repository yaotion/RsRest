unit uTrainJiaolu;

interface

type
  //�۷�������Ϣ
  RRsZheFanQuJian = record
    //�۷�����GUID
    strZFQJGUID : string;
    //��������GUID 
    strTrainJiaoluGUID : string;
    //��������GUID
    nQuJianIndex : Integer;
    //��ʼվ
    strBeginStationGUID : string;
    //��ʼվ����
    strBeginStationName : string;
    //����վ
    strEndStationGUID : string;
    //����վ����
    strEndStationName : string;

  end;
  TRsZheFanQuJianArray = array of RRsZheFanQuJian;
  
  //������·��Ϣ
  RRsTrainJiaolu = record
    //������·GUID
    strTrainJiaoluGUID : string;
    //������·����
    strTrainJiaoluName : string;
        //��ʼվGUID
    strStartStation : string;
    //��ʼվ����
    strStartStationName: string;
    //�յ�վGUID
    strEndStation : string;
    //�յ�վ����
    strEndStationName: string;
    //��������
    strWorkShopGUID : string;
    //�Ƿ���ڷ���(0��1��)
    bIsBeginWorkFP : integer;
    //�۷�����
    ZheFanQuJianArray : TRsZheFanQuJianArray;
    //������·GUID
    strLineGUID :string;

  end;
  TRsTrainJiaoluArray = array of RRsTrainJiaolu;


  //�ͻ��˹�ע��·
  RRSTrainJiaoluInSite = record
    //��¼guid
    strJiaoluInSiteGUID :string;
    //��·guid
    strTrainJiaoluGUID :string;
    //�ͻ���guid
    strSiteGUID:string;
  end;

  TRRSTrainJiaoluInSiteArray = array of RRSTrainJiaoluInSite;

implementation

end.
