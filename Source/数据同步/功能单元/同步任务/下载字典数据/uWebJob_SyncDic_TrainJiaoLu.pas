unit uWebJob_SyncDic_TrainJiaoLu;

interface
uses
  Classes,uHttpDataUpdateMgr,uWebJob_SyncDic,superobject,uTrainJiaolu,
  SysUtils,uDBTrainJiaolu;
type
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TWebJob_SyncDic_TrainJiaoLu
  /// 描述:同步字典数据_行车交路
  //////////////////////////////////////////////////////////////////////////////
  TWebJob_SyncDic_TrainJiaoLu = class(TWebJob_SyncDic)
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
    //行车交路数组
    m_TrainJiaoluAry:TRsTrainJiaoluArray;
    //交路数据库操作
    m_DBTrainJiaoLu:TRsDBTrainJiaolu;
  end;

implementation

{ TWebJob_SyncDic_Station }

constructor TWebJob_SyncDic_TrainJiaoLu.Create(strJobName: string);
begin
  inherited Create(strJobName);
  strDicName := 'TABBaseTrainJiaolu';
  m_DBTrainJiaoLu := nil;

end;

destructor TWebJob_SyncDic_TrainJiaoLu.Destroy;
begin
  m_DBTrainJiaoLu.Free;
  inherited;
end;

procedure TWebJob_SyncDic_TrainJiaoLu.FromJsonStr(strData: string);
var
  jsData:ISuperObject;
  i:Integer;
begin
  jsData := SO(strData);
  SetLength(m_TrainJiaoluAry,jsData.AsArray.Length);
  for i:= 0 to jsData.AsArray.Length -1 do
  begin
    m_TrainJiaoluAry[i].strTrainJiaoluGUID  := jsData.AsArray[i].S['strTrainJiaoluGUID'];
    m_TrainJiaoluAry[i].strTrainJiaoluName  := jsData.AsArray[i].S['strTrainJiaoluName'];
    m_TrainJiaoluAry[i].strStartStation := jsData.AsArray[i].S['strStartStation'];
    m_TrainJiaoluAry[i].strEndStation := jsData.AsArray[i].S['strEndStation'];
    m_TrainJiaoluAry[i].strWorkShopGUID := jsData.AsArray[i].S['strWorkShopGUID'];
    m_TrainJiaoluAry[i].bIsBeginWorkFP := jsData.AsArray[i].I['bIsBeginWorkFP'];
  end;
  self.InsertLogs(Format('解析出%d条数据',[jsData.AsArray.Length]));
end;

procedure TWebJob_SyncDic_TrainJiaoLu.SaveData(strData: String);
begin
  inherited;

  FromJsonStr(strData);
  ToDB;

end;

procedure TWebJob_SyncDic_TrainJiaoLu.ToDB;
begin
  if m_DBTrainJiaoLu = nil then
    m_DBTrainJiaoLu:=TRsDBTrainJiaolu.Create(m_UpdateMgr.LocalDB);
  m_DBTrainJiaoLu.Sync(m_TrainJiaoluAry);
  //m_DBstation.sync(m_SattionAry)
end;

end.

