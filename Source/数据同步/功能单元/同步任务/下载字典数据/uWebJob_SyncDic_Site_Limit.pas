unit uWebJob_SyncDic_Site_Limit;

interface
uses
  Classes,uHttpDataUpdateMgr,uWebJob_SyncDic,superobject,uSite,
  SysUtils,uDBSite;
type
  //////////////////////////////////////////////////////////////////////////////
  /// ����:uWebJob_SyncDic_Site_Limit
  /// ����:ͬ���ֵ�����
  //////////////////////////////////////////////////////////////////////////////
  TWebJob_SyncDic_Site_Limit = class(TWebJob_SyncDic)
  public
    constructor Create(strJobName:string);override;
    destructor Destroy();override;
  public
    {����:��������}
    procedure SaveData(strData:String);override;
  private
    {����:�������}
    procedure FromJsonStr(strData:string);
    {����:��������}
    procedure ToDB();
  private
    //�ͻ���Ȩ������
    m_siteLimitAry:TRsJobLimitArray;
    //�ͻ������ݿ����
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
  self.InsertLogs(Format('������%d������',[jsData.AsArray.Length]));
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

