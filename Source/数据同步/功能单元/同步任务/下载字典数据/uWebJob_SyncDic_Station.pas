unit uWebJob_SyncDic_Station;

interface
uses
  Classes,uHttpDataUpdateMgr,uWebJob_SyncDic,superobject,uStation,
  SysUtils,uDBStation;
type
  //////////////////////////////////////////////////////////////////////////////
  /// ����:TWebJob_SyncDic_Station
  /// ����:ͬ���ֵ�����_��վ
  //////////////////////////////////////////////////////////////////////////////
  TWebJob_SyncDic_Station = class(TWebJob_SyncDic)
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
    //��վ����
    m_SattionAry:TRsStationArray;
    //��վ���ݿ����
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
  self.InsertLogs(Format('������%d������',[jsData.AsArray.Length]));
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

