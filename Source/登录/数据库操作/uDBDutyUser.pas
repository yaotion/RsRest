unit uDBDutyUser;

interface
uses
  ADODB,uDutyUser,uDutyPlace,uTFSystem;
type
  TRsDBDutyUser = class(TDBOperate)
  private
    procedure ADOQueryToData(ADOQuery : TADOQuery;DutyUser : TRsDutyUser);
    procedure Data2Ado(dutyUser:TRsDutyUser;qry:TADOQuery);
  public
    //根据用户名获取登录人员信息
    function GetDutyUserByNumber(DutyNumber : string ; DutyUser : TRsDutyUser) : boolean;
    //修改密码
    procedure ResetPassword(UserID,NewPassword : string);
    //获取出勤点信息
    function GetDutyPlace(SiteGUID:string ; var DutyPlace:RRsDutyPlace):Boolean;
    //获取出勤点信息
    function GetDutyPlaceList(var DutyPlaceList:TRsDutyPlaceList):Boolean;
    //保存数据
    procedure Save(dutyUser:TRsDutyUser);
    //获取所有的管理员信息
    procedure GetAllDutyUser(dutyUserList:TRsDutyUserList);
    //删除
    procedure Del(strGUID:string);
    //同步管理员
    procedure Sync(dutyUserList:TRsDutyUserList);
  end;
implementation

uses DB,SysUtils;

{ TDBDutyUser }

procedure TRsDBDutyUser.ADOQueryToData(ADOQuery: TADOQuery; DutyUser: TRsDutyUser);
begin
  with ADOQuery do
  begin
    DutyUser.strDutyGUID := FieldByName('strDutyGUID').AsString;
    DutyUser.strDutyNumber := FieldByName('strDutyNumber').AsString;
    DutyUser.strDutyName := FieldByName('strDutyName').AsString;
    DutyUser.strPassword := FieldByName('strPassword').AsString;
  end;
end;

procedure TRsDBDutyUser.Data2Ado(dutyUser: TRsDutyUser; qry: TADOQuery);
begin
  with qry do
  begin
    FieldByName('strDutyGUID').AsString := DutyUser.strDutyGUID;
    FieldByName('strDutyNumber').AsString := DutyUser.strDutyNumber;
    FieldByName('strDutyName').AsString := DutyUser.strDutyName;
    FieldByName('strPassword').AsString := DutyUser.strPassword;
  end;
end;

procedure TRsDBDutyUser.Del(strGUID: string);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'delete from tab_org_DutyUser where strDutyGUID = :strDutyGUID';
    qry.Parameters.ParamByName('strDutyGUID').Value := strGUID;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

procedure TRsDBDutyUser.GetAllDutyUser(dutyUserList: TRsDutyUserList);
var
  qry:TADOQuery;
  dutyUser:TRsDutyUser;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text:= 'select * from tab_org_DutyUser ';
    qry.Open;
    while not qry.Eof do
    begin
      dutyUser := TRsDutyUser.Create;
      dutyUserList.Add(dutyUser) ;
      self.ADOQueryToData(qry,dutyUser);
      qry.Next;
    end;

  finally
    qry.Free;
  end;
end;

function TRsDBDutyUser.GetDutyPlace(SiteGUID: string;
  var DutyPlace: RRsDutyPlace): Boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := Format('select * from VIEW_Base_Site_DutyPlace where strSiteGUID = %s',[QuotedStr(SiteGUID)]);
      SQL.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        with DutyPlace do
        begin
          placeID := FieldByName('strPlaceID').AsString; ;
          placeName := FieldByName('strPlaceName').AsString;
        end;
        result := true;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBDutyUser.GetDutyPlaceList(var DutyPlaceList:TRsDutyPlaceList): Boolean;
var
  i : Integer ;
  strSql : string;
  adoQuery : TADOQuery;
begin
  i := 0 ;
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from TAB_Base_DutyPlace ';
      SQL.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        SetLength(DutyPlaceList,RecordCount);
        while Not adoQuery.Eof do
        begin
          DutyPlaceList[i].placeID := FieldByName('strPlaceID').AsString;
          DutyPlaceList[i].placeName := FieldByName('strPlaceName').AsString;
          Inc(i);
          adoQuery.Next ;
        end;
        
        result := true;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBDutyUser.GetDutyUserByNumber(DutyNumber: string;
  DutyUser: TRsDutyUser) : boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from TAB_Org_DutyUser where strDutyNumber = %s';
      strSql := Format(strSql,[QuotedStr(DutyNumber)]);
      SQL.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        ADOQueryToData(adoQuery,DutyUser);
        result := true;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBDutyUser.ResetPassword(UserID, NewPassword: string);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'update TAB_Org_DutyUser set strPassword = %s where strDutyNumber = %s';
      strSql := Format(strSql,[QuotedStr(NewPassword),QuotedStr(UserID)]);
      SQL.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBDutyUser.Save(dutyUser: TRsDutyUser);
var
  qry:TADOQuery;
begin
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_org_dutyuser where strDutyGUID = :strDutyGUID';
    qry.Parameters.ParamByName('strDutyGUID').Value := dutyUser.strDutyGUID;
    qry.Open;
    if qry.RecordCount = 0 then
      qry.Append
    else
      qry.Edit;
    self.Data2Ado(dutyUser,qry);
    qry.Post;
  finally
    qry.Free;
  end;
end;

procedure TRsDBDutyUser.Sync(dutyUserList: TRsDutyUserList);
var
  qry:TADOQuery;
  i:Integer;
begin
  qry := NewADOQuery;
  self.GetADOConnection.BeginTrans;
  try
    try
      qry.SQL.Text := 'delete from tab_org_DutyUser';
      qry.ExecSQL;
      for I := 0 to dutyUserList.Count - 1 do
      begin
        self.Save(dutyUserList.Items[i]);
      end;
      Self.GetADOConnection.CommitTrans;
    except on e:Exception do
      self.GetADOConnection.RollbackTrans;
    end;
  finally
    qry.Free;
  end;
end;

end.
