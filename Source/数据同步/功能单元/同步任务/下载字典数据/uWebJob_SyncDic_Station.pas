unit uWebJob_SyncDic_Station;

interface
uses
  Classes,uHttpDataUpdateMgr,uWebJob_SyncDic,superobject,uStation,
  SysUtils,uDBStation;
type
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TWebJob_SyncDic_Station
  /// 描述:同步字典数据_车站
  //////////////////////////////////////////////////////////////////////////////
  TWebJob_SyncDic_Station = class(TWebJob_SyncDic)
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
    //车站数组
    m_SattionAry:TRsStationArray;
    //车站数据库操作
    m_DBStation:TRSDBStation;
  end;

implementation

{ TWebJob_SyncDic_Station }

constructor TWebJob_SyncDic_Station.Create(strJobName: string);
begin
  inherited Create(strJobName);
  strDicName := 'TABBaseStation';
  m_DBStation := nil;

end;

destructor TWebJob_SyncDic_Station.Destroy;
begin
  m_DBStation.Free;
  inherited;
end;

procedure TWebJob_SyncDic_Station.FromJsonStr(strData: string);
var
  jsData:ISuperObject;
  i:Integer;
begin
  jsData := SO(strData);
  SetLength(m_SattionAry,jsData.AsArray.Length);
  for i:= 0 to jsData.AsArray.Length -1 do
  begin
    m_SattionAry[i].strStationGUID  := jsData.AsArray[i].S['strStationGUID'];
    m_SattionAry[i].strStationName  := jsData.AsArray[i].S['strStationName'];
    m_SattionAry[i].strStationNumber := jsData.AsArray[i].S['strStationNumber'];
    m_SattionAry[i].strWorkShopGUID := jsData.AsArray[i].S['strWorkShopGUID'];
    m_SattionAry[i].strStationPY := jsData.AsArray[i].S['strStationPY'];
  end;
  self.InsertLogs(Format('解析出%d条数据',[jsData.AsArray.Length]));
end;

procedure TWebJob_SyncDic_Station.SaveData(strData: String);
begin
  inherited;
  FromJsonStr(strData);
  ToDB;
end;

procedure TWebJob_SyncDic_Station.ToDB;
begin
  if m_DBStation = nil then
    m_DBStation:=TRSDBStation.Create(m_UpdateMgr.LocalDB);
  m_DBstation.sync(m_SattionAry)
end;

end.

