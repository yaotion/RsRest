unit uWebJob_SyncDic_DutyUser;

interface
uses
  Classes,uHttpDataUpdateMgr,uWebJob_SyncDic,superobject,uDutyUser,
  SysUtils,uDBDutyUser;
type
  //////////////////////////////////////////////////////////////////////////////
  /// ����:TWebJob_SyncDic_DutyUser
  /// ����:ͬ���ֵ�����_����Ա
  //////////////////////////////////////////////////////////////////////////////
  TWebJob_SyncDic_DutyUser = class(TWebJob_SyncDic)
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
    //����Ա����
    m_DutyUserList:TRsDutyUserList;
    //����Ա���ݿ����
    m_DBDutyUSer:TRsDBDutyUser;
  end;

implementation

{ TWebJob_SyncDic_DutyUser }

constructor TWebJob_SyncDic_DutyUser.Create(strJobName: string);
begin
  inherited Create(strJobName);
  strDicName := 'TABOrgDutyUser';
  m_DBDutyUSer := nil;

  m_DutyUserList := TRsDutyUserList.Create;
end;

destructor TWebJob_SyncDic_DutyUser.Destroy;
begin
  m_DutyUserList.Free;
  m_DBDutyUSer.Free;
  inherited;
end;

procedure TWebJob_SyncDic_DutyUser.FromJsonStr(strData: string);
var
  jsData:ISuperObject;
  i:Integer;
  dutyUser:TRsDutyUser;
begin
  jsData := SO(strData);
  m_DutyUserList.Clear;
  for i:= 0 to jsData.AsArray.Length -1 do
  begin
    dutyUser:=TRsDutyUser.Create;
    dutyUser.strDutyGUID  := jsData.AsArray[i].S['strDutyGUID'];
    dutyUser.strDutyNumber := jsData.AsArray[i].S['strDutyNumber'];
    dutyUser.strDutyName := jsData.AsArray[i].S['strDutyName'];
    dutyUser.strPassword := jsData.AsArray[i].S['strPassword'];
    dutyUser.strTokenID := jsData.AsArray[i].S['strTokenID'];
    m_DutyUserList.Add(dutyUser);
  end;
  self.InsertLogs(Format('������%d������',[jsData.AsArray.Length]));
end;

procedure TWebJob_SyncDic_DutyUser.SaveData(strData: String);
begin
  inherited;
  FromJsonStr(strData);
  ToDB;
end;

procedure TWebJob_SyncDic_DutyUser.ToDB;
begin
  if m_DBDutyUSer = nil then
    m_DBDutyUSer:=TRsDBDutyUser.Create(m_UpdateMgr.LocalDB);
  m_DBDutyUSer.Sync(m_DutyUserList);
end;

end.

