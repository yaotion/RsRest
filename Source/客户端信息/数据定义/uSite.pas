unit uSite;

interface

uses
  InvokeRegistry;
type
  //��λö��
  TRsSiteJob = (sjAdmin,sjDiaodu{����̨},sjPaiBan{�ɰ���},sjChuQin{���ڵ�},
    sjTuiQin{���ڵ�},sjHouBan{���},sjGuanLi{����},sjDuanWang{����},
    sjJiaoBan{��Ԣ�а�},sjWaiQin{���ڶ�});
  //����Ȩ��ö��
  TRsJobLimit = (jlBrowser{���},jlOperate{����});
  //��λȨ��
  RRsJobLimit = record
    strSiteGUID:string;
    Job : TRsSiteJob;
    Limimt : TRsJobLimit;
  end;
  TRsJobLimitArray = array of RRsJobLimit;
  
  //�ͻ�����Ϣ������WEBService
  TRsSiteInfo = class(TRemotable)
  private
    m_strSiteGUID : string;
    m_strSiteNumber : string;
    m_strSiteName : string;
    m_strAreaGUID : string;
    m_nSiteEnable : integer;
    m_strSiteIP : string;
    m_nSiteJob : integer;
    m_strStationGUID : string;
    m_strWorkShopGUID : string;
    m_nTmis: Integer;
  public
    //�ܼ���Ա��·�б�
    TrainJiaolus : array of string;
    //��λȨ���б�
    JobLimits : TRsJobLimitArray; 
  published
    property strSiteGUID : string read m_strSiteGUID write m_strSiteGUID;
    property strSiteNumber : string read m_strSiteNumber write m_strSiteNumber;
    property strSiteName : string read m_strSiteName write m_strSiteName;
    property strAreaGUID : string read m_strAreaGUID write m_strAreaGUID;
    property nSiteEnable : integer read m_nSiteEnable write m_nSiteEnable;
    property strSiteIP : string read m_strSiteIP write m_strSiteIP;
    property nSiteJob : integer read m_nSiteJob write m_nSiteJob;
    property strStationGUID : string read m_strStationGUID write m_strStationGUID;
    property WorkShopGUID : string read m_strWorkShopGUID write m_strWorkShopGUID;
    property Tmis: Integer read m_nTmis write m_nTmis; 
  end;

  //�ͻ�����Ϣ
  RRsSiteInfo = record
    strSiteGUID : string;
    strSiteNumber : string;
    strSiteName : string;
    strAreaGUID : string;
    nSiteEnable : integer;
    strSiteIP : string;
    nSiteJob : integer;
    strTMIS:string;
    strStationGUID : string;
    strWorkShopGUID: string;
  end;
  TRsSiteArray = array of RRsSiteInfo;


    RSite = record
    //nid
    nid:Integer;
    //guid
    strRunEventGUID:string;
    //�¼�����
    nEventID :Integer;
    //�¼���������
    dtEventTime:TDateTime;
    //
    strTrainmanNumber : string;
    //tmis
    nTMIS:Integer;
    //����ʱ��
    dtCreateTime:TDateTime;
    //
    nResultID:Integer;
    //
    strResult:string;
    //
    nSubmitResult:Integer;
    //
    strSubmitRemark:string;
    //
    nKeHuo:Integer;
  end;

  TSiteArray = array of RSite;

implementation

end.
