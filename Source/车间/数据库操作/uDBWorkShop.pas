unit uDBWorkShop;

interface
uses
  ADODB,uTFSystem,uWorkShop;
type
  //车间数据库操作类
  TRsDBWorkShop = class(TDBOperate)
  public
    procedure Data2Ado(workShop:RRsWorkShop;qry:TADOQuery);
    procedure ADOQueryToData(ADOQuery : TADOQuery;out WorkShop : RRsWorkShop);
  public
    //获取机务段下所有车间
    procedure GetWorkShopOfArea(AreaGUID : string;out WorkShopArray : TRsWorkShopArray);
    //根据车间名称获取对应的GUID
    function GetWorkShopGUIDByName(WorkShopName : string) : string;
    {功能:获取所有车间}
    procedure GetWorkShopOfSite(strSiteGUID:string;out workShopArray:TRsWorkShopArray);
    //获取所有车间
    procedure GetAllWorkShop(out WorkShopArray : TRsWorkShopArray);
    //增加车间
    procedure Add(workShop:RRsWorkShop);
    //删除记录
    procedure Del(strGUID:string);
    //同步数据
    procedure Sync(WorkShopArray : TRsWorkShopArray);
  end;
implementation
uses
  SysUtils;
{ TDBWorkShop }

procedure TRsDBWorkShop.Add(workShop: RRsWorkShop);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  qry.SQL.Text := 'select * from tab_org_WorkShop where strWorkShopGUID = :strWorkShopGUID';
  try
    qry.Parameters.ParamByName('strWorkShopGUID').Value := workShop.strWorkShopGUID;
    qry.Open;
    if qry.RecordCount = 0 then
      qry.Append
    else
      qry.Edit;
    self.Data2Ado(workShop,qry);
    qry.Post;
  finally
    qry.Free;
  end;
end;

procedure TRsDBWorkShop.ADOQueryToData(ADOQuery: TADOQuery;
  out WorkShop: RRsWorkShop);
begin
  with ADOQuery do
  begin
    WorkShop.strWorkShopGUID := FieldByName('strWorkShopGUID').AsString;
    WorkShop.strAreaGUID := FieldByName('strAreaGUID').AsString;
    WorkShop.strWorkShopName := FieldByName('strWorkShopName').AsString;
    
    if ADOQuery.FindField('strWorkShopNumber') <> nil then
      WorkShop.strWorkShopNumber := FieldByName('strWorkShopNumber').AsString;
  end;
end;

procedure TRsDBWorkShop.Data2Ado(workShop: RRsWorkShop; qry: TADOQuery);
begin
  qry.FieldByName('strWorkShopGUID').AsString := WorkShop.strWorkShopGUID;
  qry.FieldByName('strAreaGUID').AsString := WorkShop.strAreaGUID;
  qry.FieldByName('strWorkShopName').AsString := WorkShop.strWorkShopName;
  qry.FieldByName('strWorkShopNumber').AsString := WorkShop.strWorkShopNumber;
end;

procedure TRsDBWorkShop.Del(strGUID: string);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'delete from tab_org_workShop where strWorkShopGUID = :strGUID';
    qry.Parameters.ParamByName('strGUID').Value := strGUID;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

procedure TRsDBWorkShop.GetWorkShopOfSite(strSiteGUID:string;out workShopArray: TRsWorkShopArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  workShop : RRsWorkShop;
begin
  SetLength(WorkShopArray,0);
  adoQuery := TADOQuery.Create(nil);
  try
    with  adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'SELECT DISTINCT strAreaGUID, strWorkShopName, strWorkShopGUID'
        + ' FROM VIEW_Base_TrainJiaoluInSite WHERE (strSiteGUID =:strSiteGUID) '
        + ' GROUP BY strWorkShopGUID, strWorkShopName, strAreaGUID '
        + ' ORDER BY strWorkShopName';
      SQL.Text := strSql;
      Parameters.ParamByName('strSiteGUID').Value := strSiteGUID;
      Open;
      while not eof do
      begin
        ADOQueryToData(adoQuery,workShop);
        SetLength(WorkShopArray,length(WorkShopArray) + 1);
        WorkShopArray[length(WorkShopArray) - 1] := workShop;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBWorkShop.Sync(WorkShopArray: TRsWorkShopArray);
var
  qry:TADOQuery;
  i:Integer;
begin
  qry := NewADOQuery;
  self.GetADOConnection.BeginTrans;
  try
    try
      qry.SQL.Text := 'delete from tab_org_WorkShop';
      qry.ExecSQL;
      for I := 0 to Length(WorkShopArray) - 1 do
      begin
        self.Add(WorkShopArray[i]);
      end;
      Self.GetADOConnection.CommitTrans;
    except on e:Exception do
      self.GetADOConnection.RollbackTrans;
    end;
  finally
    qry.Free;
  end;
end;

procedure TRsDBWorkShop.GetAllWorkShop(out WorkShopArray : TRsWorkShopArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  workShop : RRsWorkShop;
begin
  SetLength(WorkShopArray,0);
  adoQuery := TADOQuery.Create(nil);
  try
    with  adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from TAB_Org_WorkShop order by strWorkShopName';
      SQL.Text := strSql;
      Open;
      while not eof do
      begin
        ADOQueryToData(adoQuery,workShop);
        SetLength(WorkShopArray,length(WorkShopArray) + 1);
        WorkShopArray[length(WorkShopArray) - 1] := workShop;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;
function TRsDBWorkShop.GetWorkShopGUIDByName(WorkShopName: string): string;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := '';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select strWorkShopGUID from TAB_Org_WorkShop where  strWorkShopName = %s ';
      strSql := Format(strSql,[QuotedStr(WorkShopName)]);
      SQL.Text := strSql;
      Open;
      if RecordCount  > 0 then
        Result := FieldByName('strWorkShopGUID').AsString;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBWorkShop.GetWorkShopOfArea(AreaGUID: string;
  out WorkShopArray: TRsWorkShopArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  workShop : RRsWorkShop;
begin
  SetLength(WorkShopArray,0);
  adoQuery := TADOQuery.Create(nil);
  try
    with  adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from TAB_Org_WorkShop where strAreaGUID = %s order by strWorkShopName';
      strSql := Format(strSql,[QuotedStr(AreaGUID)]);
      SQL.Text := strSql;
      Open;
      while not eof do
      begin
        ADOQueryToData(adoQuery,workShop);
        SetLength(WorkShopArray,length(WorkShopArray) + 1);
        WorkShopArray[length(WorkShopArray) - 1] := workShop;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

end.
