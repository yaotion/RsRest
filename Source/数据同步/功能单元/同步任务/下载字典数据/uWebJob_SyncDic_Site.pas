unit uWebJob_SyncDic_Site;

interface
uses
  Classes,uHttpDataUpdateMgr,uWebJob_SyncDic,superobject,uSite,
  SysUtils,uDBSite;
type
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TWebJob_SyncDic_Site
  /// 描述:同步字典数据
  //////////////////////////////////////////////////////////////////////////////
  TWebJob_SyncDic_Site = class(TWebJob_SyncDic)
  public
    constructor Create(strJobName:string);override;
    destructor Destroy();override;
  public
    {功能:保存数据}
    procedure SaveData(strData:String);override;
  private
    {功能:构造对象}
    procedure FromJsonStr(strData:string);
    {功能:保存数据}
    procedure ToDB();
  private
    //客户端数组
    m_siteAry:TRsSiteArray;
    //客户端数据库操作
    m_DBSite:TRsDBSite;

  end;

implementation

{ TWebJob_SyncDic }

constructor TWebJob_SyncDic_Site.Create(strJobName: string);
begin
  inherited Create(strJobName);
  strDicName := 'TABBaseSite';
  m_DBSite := nil;
end;

destructor TWebJob_SyncDic_Site.Destroy;
begin
  m_DBSite.Free;
  inherited;
end;



procedure TWebJob_SyncDic_Site.FromJsonStr(strData: string);
var
  jsData:ISuperObject;
  i:Integer;
begin
  jsData := SO(strData);
  SetLength(m_siteAry,jsData.AsArray.Length);
  for i:= 0 to jsData.AsArray.Length -1 do
  begin
    m_siteAry[i].strSiteGUID := jsData.AsArray[i].S['strSiteGUID'];
    m_siteAry[i].strSiteNumber := jsData.AsArray[i].S['strSiteNumber'];
    m_siteAry[i].strSiteName := jsData.AsArray[i].S['strSiteName'];
    m_siteAry[i].strAreaGUID := jsData.AsArray[i].S['strAreaGUID'];
    m_siteAry[i].nSiteEnable := jsData.AsArray[i].I['nSiteEnable'];
    m_siteAry[i].strSiteIP := jsData.AsArray[i].S['strSiteIP'];
    m_siteAry[i].nSiteJob := jsData.AsArray[i].I['nSiteJob'];
    m_siteAry[i].strTMIS := jsData.AsArray[i].S['strTMIS'];
    m_siteAry[i].strStationGUID := jsData.AsArray[i].S['strStationGUID'];
    m_siteAry[i].strWorkShopGUID := jsData.AsArray[i].S['strWorkShopGUID'];
  end;
  self.InsertLogs(Format('解析出%d条数据',[jsData.AsArray.Length]));
end;

procedure TWebJob_SyncDic_Site.SaveData(strData: String);
begin
  inherited;
  FromJsonStr(strData);
  ToDB;

end;

procedure TWebJob_SyncDic_Site.ToDB;
begin
  if m_DBSite = nil then
    m_DBSite:=TRsDBSite.Create(m_UpdateMgr.LocalDB);
  m_DBSite.Sync(m_siteAry)
end;

end.

