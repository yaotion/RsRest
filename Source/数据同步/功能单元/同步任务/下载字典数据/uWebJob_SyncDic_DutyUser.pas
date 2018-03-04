unit uWebJob_SyncDic_DutyUser;

interface
uses
  Classes,uHttpDataUpdateMgr,uWebJob_SyncDic,superobject,uDutyUser,
  SysUtils,uDBDutyUser;
type
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TWebJob_SyncDic_DutyUser
  /// 描述:同步字典数据_管理员
  //////////////////////////////////////////////////////////////////////////////
  TWebJob_SyncDic_DutyUser = class(TWebJob_SyncDic)
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
    //管理员数组
    m_DutyUserList:TRsDutyUserList;
    //管理员数据库操作
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
  self.InsertLogs(Format('解析出%d条数据',[jsData.AsArray.Length]));
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

