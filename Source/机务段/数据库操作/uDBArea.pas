unit uDBArea;

interface
uses
  SysUtils,Classes,ADODB,DB,uArea,Variants, uTFSystem;

type
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TDBArea
  /// 说明:区域数据操作类
  //////////////////////////////////////////////////////////////////////////////
  TRsDBArea = class
  public
    {功能:根据区域ID获取区域对象}
    class function GetAreaByGUID(ADOConn : TADOConnection;AreaGUID:String;out Area:RRsArea):Boolean;
    {功能:根据所有区域信息}
    class procedure GetAreas(ADOConn : TADOConnection;out AreaArray:TAreaArray);
    //增加机务段
    procedure Add(adocon:TADOConnection; area:RRsArea);
    //修改机务段
    procedure Modify(adocon:TADOConnection; area:RRsArea);
    //删除机务段
    procedure Del(adoCon:TADOConnection;strGUID:string);
    //同步
    procedure Sync(adoCon:TADOConnection;areaAry:TAreaArray);

    procedure Data2Ado(area:RRsArea;qry:TADOQuery);
    procedure Ado2Data(qry:TADOQuery;area:RRsArea);


  end;

implementation

{ TAreaObjectDB }
procedure TRsDBArea.Add(adocon: TADOConnection; area: RRsArea);
var
  qry:TADOQuery;
begin
  qry:= TADOQuery.Create(nil);
  qry.Connection := adocon;
  try
    qry.SQL.Text := 'select * from tab_org_area where strGUID =:strGUID';
    qry.Parameters.ParamByName('strGUID').Value := area.strAreaGUID;
    qry.Open;
    if qry.RecordCount = 0 then
      qry.Append
    else
      qry.Edit;
    Self.Data2Ado(area,qry);
    qry.Post;
  finally
    qry.Free;
  end;
end;

procedure TRsDBArea.Ado2Data(qry: TADOQuery; area: RRsArea);
begin
  area.strAreaGUID := qry.FieldByName('strGUID').Value;
  area.strAreaName := qry.FieldByName('strAreaName').Value;
  area.strJWDNumber := qry.FieldByName('strJWDNumber').Value;
end;

procedure TRsDBArea.Data2Ado(area: RRsArea; qry: TADOQuery);
begin
  qry.FieldByName('strGUID').Value := area.strAreaGUID;
  qry.FieldByName('strAreaName').Value := area.strAreaName;
  qry.FieldByName('strJWDNumber').Value := area.strJWDNumber;
end;

procedure TRsDBArea.Del(adoCon: TADOConnection; strGUID: string);
var
  qry:TADOQuery;
begin
  qry := TADOQuery.Create(nil);
  qry.Connection := adoCon;
  try
    qry.SQL.Text := 'delete from tab_org_Area where strGUID =:strGUID';
    qry.Parameters.ParamByName('strGUID').Value := strGUID;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

class function TRsDBArea.GetAreaByGUID(ADOConn : TADOConnection;AreaGUID:String;out Area:RRsArea):Boolean;
{功能:根据区域ID获取区域对象}
var
  adoQuery : TADOQuery;
begin
  Result := False;
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := ADOConn;
    adoQuery.SQL.Text := 'Select * from View_Org_Area where '+
        'strGUID = '+QuotedStr(AreaGUID);
    adoQuery.Open;
    if adoQuery.RecordCount > 0 then
    begin
      Area.strAreaGUID := ADOQuery.FieldByName('strGUID').AsString;
      Area.strAreaName := ADOQuery.FieldByName('strAreaName').AsString;
      Area.strJWDNumber := ADOQuery.FieldByName('strJWDNumber').AsString;
      Area.strJWDName := ADOQuery.FieldByName('strAreaName').AsString;
      Result := True;
    end;
  finally
    adoQuery.Free;
  end;
end;
class procedure TRsDBArea.GetAreas(ADOConn: TADOConnection; 
  out AreaArray: TAreaArray);
{功能:根据区域ID获取区域对象}
var
  i : integer;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := ADOConn;
    adoQuery.SQL.Text := 'Select * from View_Org_Area order by strAreaName';
    adoQuery.Open;
    setLength(AreaArray,adoQuery.RecordCount);
    i := 0;
    while not adoQuery.Eof do
    begin
      if adoQuery.RecordCount > 0 then
      begin
        AreaArray[i].strAreaGUID := ADOQuery.FieldByName('strGUID').AsString;
        AreaArray[i].strAreaName := ADOQuery.FieldByName('strAreaName').AsString;
        AreaArray[i].strJWDNumber := ADOQuery.FieldByName('strJWDNumber').AsString;
        AreaArray[i].strJWDName := ADOQuery.FieldByName('strAreaName').AsString;
        inc(i);
      end;
      adoQuery.Next;
    end;
  finally
    adoQuery.Free;
  end;

end;

procedure TRsDBArea.Modify(adocon: TADOConnection; area: RRsArea);
var
  qry:TADOQuery;
begin
  qry:= TADOQuery.Create(nil);
  qry.Connection := adocon;
  try
    qry.SQL.Text := 'select * from tab_org_area where strGUID =:strGUID';
    qry.Parameters.ParamByName('strGUID').Value := area.strAreaGUID;
    qry.Open;
    if qry.RecordCount = 0 then
      qry.Append
    else
      qry.Edit;
    Self.Data2Ado(area,qry);
    qry.Post;
  finally
    qry.Free;
  end;
end;

procedure TRsDBArea.Sync(adoCon:TADOConnection;areaAry: TAreaArray);
var
  qry:TADOQuery;
  i:Integer;
begin
  qry := TADOQuery.Create(adoCon);
  adoCon.BeginTrans;
  try
    try
      qry.SQL.Text := 'delete from tab_org_area';
      qry.ExecSQL;
      for I := 0 to Length(areaAry) - 1 do
      begin
        self.Add(adoCon,areaAry[i]);
      end;
      adoCon.CommitTrans;
    except on e:exception do
      adoCon.RollbackTrans;
    end;
  finally
    qry.Free;
  end;
end;

end.
