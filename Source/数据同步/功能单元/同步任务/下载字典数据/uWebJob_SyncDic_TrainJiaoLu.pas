unit uWebJob_SyncDic_TrainJiaoLu;

interface
uses
  Classes,uHttpDataUpdateMgr,uWebJob_SyncDic,superobject,uTrainJiaolu,
  SysUtils,uDBTrainJiaolu;
type
  //////////////////////////////////////////////////////////////////////////////
  /// ����:TWebJob_SyncDic_TrainJiaoLu
  /// ����:ͬ���ֵ�����_�г���·
  //////////////////////////////////////////////////////////////////////////////
  TWebJob_SyncDic_TrainJiaoLu = class(TWebJob_SyncDic)
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
    //�г���·����
    m_TrainJiaoluAry:TRsTrainJiaoluArray;
    //��·���ݿ����
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
  self.InsertLogs(Format('������%d������',[jsData.AsArray.Length]));
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

