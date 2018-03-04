unit uWebJob_SyncDic_TrainJiaoLu_InSite;

interface
uses
  Classes,uHttpDataUpdateMgr,uWebJob_SyncDic,superobject,uTrainJiaolu,
  SysUtils,uDBTrainJiaolu;
type
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TWebJob_SyncDic_TrainJiaoLu_InSite
  /// 描述:同步字典数据_客户端关注行车交路
  //////////////////////////////////////////////////////////////////////////////
  TWebJob_SyncDic_TrainJiaoLu_InSite = class(TWebJob_SyncDic)
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
    //关注交路数组
    m_TrainJiaoluInSiteAry:TRRSTrainJiaoluInSiteArray;
    //车站数据库操作
    m_DBTrainJiaoLuInSite:TRSDBTrainJiaoluInSite;
  end;

implementation

{ TWebJob_SyncDic_TrainJiaoLu_InSite }

constructor TWebJob_SyncDic_TrainJiaoLu_InSite.Create(strJobName: string);
begin
  inherited Create(strJobName);
  strDicName := 'TABBaseTrainJiaoluInSite';
  m_DBTrainJiaoLuInSite := nil;

end;

destructor TWebJob_SyncDic_TrainJiaoLu_InSite.Destroy;
begin
  m_DBTrainJiaoLuInSite.Free;
  inherited;
end;

procedure TWebJob_SyncDic_TrainJiaoLu_InSite.FromJsonStr(strData: string);
var
  jsData:ISuperObject;
  i:Integer;
begin
  jsData := SO(strData);
  SetLength(m_TrainJiaoluInSiteAry,jsData.AsArray.Length);
  for i:= 0 to jsData.AsArray.Length -1 do
  begin
    m_TrainJiaoluInSiteAry[i].strTrainJiaoluGUID  := jsData.AsArray[i].S['strTrainJiaoluGUID'];
    m_TrainJiaoluInSiteAry[i].strSiteGUID  := jsData.AsArray[i].S['strSiteGUID'];
    m_TrainJiaoluInSiteAry[i].strJiaoluInSiteGUID := jsData.AsArray[i].S['strJiaoluInSiteGUID'];
  end;
  self.InsertLogs(Format('解析出%d条数据',[jsData.AsArray.Length]));
end;

procedure TWebJob_SyncDic_TrainJiaoLu_InSite.SaveData(strData: String);
begin
  inherited;

  FromJsonStr(strData);
  ToDB;

end;

procedure TWebJob_SyncDic_TrainJiaoLu_InSite.ToDB;
begin
  if m_DBTrainJiaoLuInSite = nil then
    m_DBTrainJiaoLuInSite:=TRSDBTrainJiaoluInSite.Create(m_UpdateMgr.LocalDB);
  m_DBTrainJiaoLuInSite.Sync(m_TrainJiaoluInSiteAry);
end;

end.

