unit uWebJob_SyncDic_Site_Limit;

interface
uses
  Classes,uHttpDataUpdateMgr,uWebJob_SyncDic,superobject,uSite,
  SysUtils,uDBSite;
type
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:uWebJob_SyncDic_Site_Limit
  /// 描述:同步字典数据
  //////////////////////////////////////////////////////////////////////////////
  TWebJob_SyncDic_Site_Limit = class(TWebJob_SyncDic)
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
    //客户端权限数组
    m_siteLimitAry:TRsJobLimitArray;
    //客户端数据库操作
    m_DBSite:TRsDBSite;

  end;

implementation

{ TWebJob_SyncDic }

constructor TWebJob_SyncDic_Site_Limit.Create(strJobName: string);
begin
  inherited Create(strJobName);
  strDicName := 'TABBaseSiteLimit';
  m_DBSite := nil;
end;

destructor TWebJob_SyncDic_Site_Limit.Destroy;
begin
  m_DBSite.Free;
  inherited;
end;



procedure TWebJob_SyncDic_Site_Limit.FromJsonStr(strData: string);
var
  jsData:ISuperObject;
  i:Integer;
begin
  jsData := SO(strData);
  SetLength(m_siteLimitAry,jsData.AsArray.Length);
  for i:= 0 to jsData.AsArray.Length -1 do
  begin
    m_siteLimitAry[i].strSiteGUID := jsData.AsArray[i].S['strSiteGUID'];
    m_siteLimitAry[i].Job := TRsSiteJob(jsData.AsArray[i].I['nJobID']);
    m_siteLimitAry[i].Limimt := TRsJobLimit(jsData.AsArray[i].I['nJobLimit']);
  end;
  self.InsertLogs(Format('解析出%d条数据',[jsData.AsArray.Length]));
end;

procedure TWebJob_SyncDic_Site_Limit.SaveData(strData: String);
begin
  inherited;
  FromJsonStr(strData);
  ToDB;
end;

procedure TWebJob_SyncDic_Site_Limit.ToDB;
begin
  if m_DBSite = nil then
    m_DBSite:=TRsDBSite.Create(m_UpdateMgr.LocalDB);
  m_DBSite.SyncLimit(m_siteLimitAry)
end;

end.

