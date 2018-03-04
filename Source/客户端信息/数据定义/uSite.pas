unit uSite;

interface

uses
  InvokeRegistry;
type
  //岗位枚举
  TRsSiteJob = (sjAdmin,sjDiaodu{调度台},sjPaiBan{派班室},sjChuQin{出勤点},
    sjTuiQin{退勤点},sjHouBan{侯班},sjGuanLi{管理},sjDuanWang{断网},
    sjJiaoBan{公寓叫班},sjWaiQin{外勤端});
  //操作权限枚举
  TRsJobLimit = (jlBrowser{浏览},jlOperate{操作});
  //岗位权限
  RRsJobLimit = record
    strSiteGUID:string;
    Job : TRsSiteJob;
    Limimt : TRsJobLimit;
  end;
  TRsJobLimitArray = array of RRsJobLimit;
  
  //客户端信息，用于WEBService
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
    //管家人员交路列表
    TrainJiaolus : array of string;
    //岗位权限列表
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

  //客户端信息
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
    //事件类型
    nEventID :Integer;
    //事件发生日期
    dtEventTime:TDateTime;
    //
    strTrainmanNumber : string;
    //tmis
    nTMIS:Integer;
    //创建时间
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
