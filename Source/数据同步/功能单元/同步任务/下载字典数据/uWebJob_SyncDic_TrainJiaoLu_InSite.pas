unit uWebJob_SyncDic_TrainJiaoLu_InSite;

interface
uses
  Classes,uHttpDataUpdateMgr,uWebJob_SyncDic,superobject,uTrainJiaolu,
  SysUtils,uDBTrainJiaolu;
type
  //////////////////////////////////////////////////////////////////////////////
  /// ����:TWebJob_SyncDic_TrainJiaoLu_InSite
  /// ����:ͬ���ֵ�����_�ͻ��˹�ע�г���·
  //////////////////////////////////////////////////////////////////////////////
  TWebJob_SyncDic_TrainJiaoLu_InSite = class(TWebJob_SyncDic)
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
    //��ע��·����
    m_TrainJiaoluInSiteAry:TRRSTrainJiaoluInSiteArray;
    //��վ���ݿ����
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
  self.InsertLogs(Format('������%d������',[jsData.AsArray.Length]));
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

