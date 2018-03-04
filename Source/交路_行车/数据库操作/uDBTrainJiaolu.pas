unit uDBTrainJiaolu;

interface
uses
  ADODB,uTrainJiaolu,uTFSystem,uStation,Classes;
type
  //客户端关注交路
  TRSDBTrainJiaoluInSite = class(TDBOperate)
  public
    //增加记录
    procedure Add(trainJiaoluInSite:RRSTrainJiaoluInSite);
    //同步
    procedure Sync(jiaoluInsiteAry: TRRSTrainJiaoluInSiteArray);
    //data2ado
    procedure Data2Ado(trainJiaoluInSite:RRSTrainJiaoluInSite;qry:TADOQuery);
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///机车交路操作类
  //////////////////////////////////////////////////////////////////////////////
  TRsDBTrainJiaolu = class(TDBOperate)
  private
    procedure ADOQueryToData(ADOQuery : TADOQuery;var TrainJiaoLu : RRsTrainJiaolu);
    procedure Data2Ado(trainjiaolu:RRsTrainJiaolu;qry:TADOQuery);
    procedure ADOQueryToQuJianData(ADOQuery : TADOQuery;out ZheFanQuJian : RRsZheFanQuJian);
  public
    //功能：获取机车交路信息
    class procedure GetDBTrainJiaolu(ADOConn : TADOConnection;out ADOQuery : TADOQuery);
    //功能：获取机务段的所有区段
    procedure GetTrainJiaoluArrayOfWorkShop(WorkShopGUID : string; out TrainJiaoluArray : TRsTrainJiaoluArray);
    //获取所有的区段
    procedure GetAllTrainJiaolu( out TrainJiaoluArray : TRsTrainJiaoluArray);
    //根据行车区段名称获取对应的GUID
    function  GetTrainJiaoluGUIDByName(TrainJiaoluName : string) : string;
    //获取行车交路信息
    function  GetTrainJiaolu(TrainJiaoluGUID : string;TrainJiaolu : RRsTrainJiaolu) : boolean;
    //获取指定客户端管辖的行车区段信息
    procedure GetTrainJiaoluArrayOfSite(SiteGUID : string; out TrainJiaoluArray : TRsTrainJiaoluArray);
    //获取指定客户端管辖的所有行车区段信息
    procedure GetAllTrainJiaoluArrayOfSite(SiteGUID : string; out TrainJiaoluArray : TRsTrainJiaoluArray);
    //获取指定机车交路的折返区间
    procedure GetZFQJOfTrainJiaolu(TrainJiaoluGUID : string; out ZheFanQuJianArray : TRsZheFanQuJianArray);
    //获取指定机车交路的车站信息
    procedure GetStationOfTrainJiaolu(TrainJiaoluGUID : string; out StationArray : TRsStationArray);
    //判断交路是否属于客户端管辖
    function IsJiaoLuInSite(TrainJiaoluGUID,SiteGUID : string): Boolean;

    //增加记录
    procedure Add(Trainjiaolu:RRsTrainJiaolu);
    //删除记录
    procedure Del(strGUID:string);
    //增加客户端关联行车交路
    procedure updateSiteJiaoluRel(strSiteGUID:string;strJiaoluGUIDList:TStringList);
    //同步记录
    procedure Sync(trianjiaoluAry:TRsTrainJiaoluArray);


  end;
implementation

uses DB,SysUtils;

{ TDBTrainJiaolu }

procedure TRsDBTrainJiaolu.Add(Trainjiaolu: RRsTrainJiaolu);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_base_TrainJiaolu where strTrainJiaoluGUID = :strGUID';
    qry.Parameters.ParamByName('strGUID').Value := Trainjiaolu.strTrainJiaoluGUID;
    qry.Open;
    if qry.RecordCount = 0 then
      qry.Append
    else
      qry.Edit;
    self.Data2Ado(Trainjiaolu,qry);
    qry.Post;
  finally
    qry.Free;
  end;
end;

procedure TRsDBTrainJiaolu.updateSiteJiaoluRel(strSiteGUID:string;strJiaoluGUIDList:TStringList);
var
  qry:TADOQuery;
  i:Integer;
begin
  qry:= NewADOQuery;
  self.GetADOConnection.BeginTrans;
  try
    try
      qry.SQL.Text := 'delete from tab_base_TrainJiaoluInSite where strSiteGUID = :strSiteGUID';
      qry.Parameters.ParamByName('strSiteGUID').value := strSiteGUID;
      qry.ExecSQL;
      for I := 0 to strJiaoluGUIDList.Count - 1 do
      begin
        qry.SQL.Text := 'Insert into tab_base_TrainJiaoluInSite values(:strSiteGUID,'
          + ' :strTrainJiaoluGUID, :strJiaoluInSiteGUID)';
        qry.Parameters.ParamByName('strSiteGUID').Value := strSiteGUID;
        qry.Parameters.ParamByName('strTrainJiaoluGUID').Value := strJiaoluGUIDList.Strings[i];
        qry.Parameters.ParamByName('strJiaoluInSiteGUID').Value := NewGUID ;
        qry.ExecSQL;
      end;
      self.GetADOConnection.CommitTrans;
    except on e:Exception do
      self.GetADOConnection.RollbackTrans;
    end;
  finally
    qry.Free;
  end;
end;

procedure TRsDBTrainJiaolu.ADOQueryToData(ADOQuery: TADOQuery;
  var TrainJiaoLu: RRsTrainJiaolu);
begin
  with ADOQuery do
  begin
    TrainJiaolu.strTrainJiaoluGUID := FieldByName('strTrainJiaoluGUID').AsString;
    TrainJiaolu.strTrainJiaoluName := FieldByName('strTrainJiaoluName').AsString;
    TrainJiaolu.strStartStation := FieldByName('strStartStation').AsString;
    TrainJiaolu.strEndStation := FieldByName('strEndStation').AsString;
    TrainJiaolu.strWorkShopGUID := FieldByName('strWorkShopGUID').AsString;
    TrainJiaolu.bIsBeginWorkFP := FieldByName('bIsBeginWorkFP').ASInteger;
    TrainJiaolu.strStartStationName := FieldByName('strStartStationName').AsString;
    TrainJiaolu.strEndStationName := FieldByName('strEndStationName').AsString;
  end;
end;

procedure TRsDBTrainJiaolu.ADOQueryToQuJianData(ADOQuery: TADOQuery;
  out ZheFanQuJian: RRsZheFanQuJian);
begin
  with ADOQuery do
  begin
    ZheFanQuJian.strZFQJGUID := FieldByName('strZFQJGUID').AsString;
    ZheFanQuJian.strTrainJiaoluGUID := FieldByName('strTrainJiaoluGUID').AsString;
    ZheFanQuJian.nQuJianIndex := FieldByName('nQuJianIndex').AsInteger;
    ZheFanQuJian.strBeginStationGUID := FieldByName('strBeginStationGUID').AsString;
    ZheFanQuJian.strBeginStationName := FieldByName('strBeginStationName').AsString;
    ZheFanQuJian.strEndStationGUID := FieldByName('strEndStationGUID').AsString;
    ZheFanQuJian.strEndStationName := FieldByName('strEndStationName').AsString;
  end;
end;

procedure TRsDBTrainJiaolu.Data2Ado(trainjiaolu: RRsTrainJiaolu;
  qry: TADOQuery);
begin
  with qry do
  begin
    FieldByName('strTrainJiaoluGUID').AsString := TrainJiaolu.strTrainJiaoluGUID;
    FieldByName('strTrainJiaoluName').AsString := TrainJiaolu.strTrainJiaoluName;
    FieldByName('strStartStation').AsString := TrainJiaolu.strStartStation;
    FieldByName('strEndStation').AsString := TrainJiaolu.strEndStation;
    FieldByName('strWorkShopGUID').AsString := TrainJiaolu.strWorkShopGUID;
    FieldByName('bIsBeginWorkFP').ASInteger := TrainJiaolu.bIsBeginWorkFP;
  end;
end;

procedure TRsDBTrainJiaolu.Del(strGUID: string);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'delete from tab_base_Trainjiaolu where strTrainJiaoluGUID=:strGUID';
    qry.Parameters.ParamByName('strGUID').Value := strGUID;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;


procedure TRsDBTrainJiaolu.GetAllTrainJiaolu(
  out TrainJiaoluArray: TRsTrainJiaoluArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  trainJiaolu : RRsTrainJiaolu;
begin
  SetLength(TrainJiaoluArray,0);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from VIEW_Base_TrainJiaolu ';
      strSql := Format(strSql,[]);
      SQL.Text := strSql;
      Open;
      while not eof do
      begin
        ADOQueryToData(adoQuery,trainJiaolu);
        SetLength(TrainJiaoluArray,length(TrainJiaoluArray) + 1);
        TrainJiaoluArray[length(TrainJiaoluArray) - 1] := trainJiaolu;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;

procedure TRsDBTrainJiaolu.GetAllTrainJiaoluArrayOfSite(SiteGUID: string;
  out TrainJiaoluArray: TRsTrainJiaoluArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  trainJiaolu : RRsTrainJiaolu;
begin
  SetLength(TrainJiaoluArray,0);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from VIEW_Base_TrainJiaolu where  ' +
      ' strTrainJiaoluGUID in (select strTrainJiaoluGUID from TAB_Base_TrainJiaoluInSite ' +
      ' where strSiteGUID =%s union select strSubTrainJiaoluGUID as strTrainJiaoluGUID '  +
      ' from TAB_Base_TrainJiaolu_SubDetail where strTrainJiaoluGUID in ' +
      ' (select strTrainJiaoluGUID from TAB_Base_TrainJiaoluInSite where strSiteGUID = %s)) and (bIsDir = 0 or bIsDir is null)';
      strSql := Format(strSql,[QuotedStr(SiteGUID),QuotedStr(SiteGUID)]);
      SQL.Text := strSql;
      Open;
      while not eof do
      begin
        ADOQueryToData(adoQuery, trainJiaolu );
        SetLength(TrainJiaoluArray,length(TrainJiaoluArray) + 1);
        TrainJiaoluArray[length(TrainJiaoluArray) - 1] := trainJiaolu;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

class procedure TRsDBTrainJiaolu.GetDBTrainJiaolu(ADOConn: TADOConnection;
  out ADOQuery: TADOQuery);
var
  strSql : string;  
begin
  strSql := 'select * from TAB_Base_TrainJiaolu where order by strLineGUID,strTrainJiaoluName';
  adoQuery := TADOQuery.Create(nil);
  with adoQuery do
  begin
    Connection := ADOConn;
    Sql.Text := strSql;
    Open;
  end;
end;

procedure TRsDBTrainJiaolu.GetStationOfTrainJiaolu(TrainJiaoluGUID: string;
  out StationArray: TRsStationArray);
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  SetLength(StationArray,0);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from VIEW_Base_StationInTrainJiaolu where  strTrainJiaoluGUID = %s order by nSortID';
      strSql := Format(strSql,[QuotedStr(TrainJiaoluGUID)]);
      SQL.Text := strSql;
      Open;
      while not eof do
      begin        
        SetLength(StationArray,length(StationArray) + 1);
        StationArray[length(StationArray) - 1].strStationGUID := FieldByName('strStationGUID').AsString;
        StationArray[length(StationArray) - 1].strStationName := FieldByName('strStationName').AsString;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;

function TRsDBTrainJiaolu.GetTrainJiaolu(TrainJiaoluGUID: string;
  TrainJiaolu: RRsTrainJiaolu): boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from VIEW_Base_TrainJiaolu where  strTrainJiaoluGUID = %s ';
      strSql := Format(strSql,[QuotedStr(TrainJiaoluGUID)]);
      SQL.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        ADOQueryToData(adoQuery,TrainJiaolu);
        result := true;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;

procedure TRsDBTrainJiaolu.GetTrainJiaoluArrayOfSite(SiteGUID: string;
  out TrainJiaoluArray: TRsTrainJiaoluArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  trainJiaolu : RRsTrainJiaolu;
begin
  SetLength(TrainJiaoluArray,0);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from VIEW_Base_TrainJiaoluInSite where  strSiteGUID = %s ';
      strSql := Format(strSql,[QuotedStr(SiteGUID)]);
      SQL.Text := strSql;
      Open;
      while not eof do
      begin
        ADOQueryToData(adoQuery,trainJiaolu);
        SetLength(TrainJiaoluArray,length(TrainJiaoluArray) + 1);
        TrainJiaoluArray[length(TrainJiaoluArray) - 1] := trainJiaolu;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainJiaolu.GetTrainJiaoluArrayOfWorkShop(WorkShopGUID: string;
  out TrainJiaoluArray: TRsTrainJiaoluArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  trainJiaolu : RRsTrainJiaolu;
begin
  SetLength(TrainJiaoluArray,0);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from VIEW_Base_TrainJiaolu where  strWorkShopGUID = %s ';
      strSql := Format(strSql,[QuotedStr(WorkShopGUID)]);
      SQL.Text := strSql;
      Open;
      while not eof do
      begin
        ADOQueryToData(adoQuery,trainJiaolu);
        SetLength(TrainJiaoluArray,length(TrainJiaoluArray) + 1);
        TrainJiaoluArray[length(TrainJiaoluArray) - 1] := trainJiaolu;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainJiaolu.GetTrainJiaoluGUIDByName(
  TrainJiaoluName: string): string;
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
      strSql := 'select strTrainJiaoluGUID from TAB_Base_TrainJiaolu where  strTrainJiaoluName = %s ';
      strSql := Format(strSql,[QuotedStr(TrainJiaoluName)]);
      SQL.Text := strSql;
      Open;
      if RecordCount  > 0 then
        Result := FieldByName('strTrainJiaoluGUID').AsString;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainJiaolu.GetZFQJOfTrainJiaolu(TrainJiaoluGUID: string;
  out ZheFanQuJianArray: TRsZheFanQuJianArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  zfqj : RRsZheFanQuJian;
begin
  SetLength(ZheFanQuJianArray,0);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from VIEW_Base_ZFQJ where  strTrainJiaoluGUID = %s order by nQuJianIndex';
      strSql := Format(strSql,[QuotedStr(TrainJiaoluGUID)]);
      SQL.Text := strSql;
      Open;
      while not eof do
      begin
        ADOQueryToQuJianData(adoQuery,zfqj);
        SetLength(ZheFanQuJianArray,length(ZheFanQuJianArray) + 1);
        ZheFanQuJianArray[length(ZheFanQuJianArray) - 1] := zfqj;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainJiaolu.IsJiaoLuInSite(TrainJiaoluGUID,
  SiteGUID: string): Boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select strTrainJiaoluGUID  from TAB_Base_TrainJiaoluInSite where strSiteGUID = %0:s ' +
        'and strTrainJiaoluGUID = %1:s union ' +
        'select strTrainJiaoluGUID from TAB_Base_TrainJiaolu_SubDetail where strSubTrainJiaoLuGUID in ' +
        '(select strTrainJiaoluGUID  from TAB_Base_TrainJiaoluInSite where strSiteGUID = %0:s) ' +
        'union select strSubTrainJiaoLuGUID as strTrainJiaoluGUID from TAB_Base_TrainJiaolu_SubDetail where strTrainJiaoluGUID in ' +
        '(select strTrainJiaoluGUID  from TAB_Base_TrainJiaoluInSite where strSiteGUID = %0:s and strSubTrainJiaoLuGUID = %1:s)  ';

      strSql := 'select strTrainJiaoluGUID  from TAB_Base_TrainJiaoluInSite where strSiteGUID = %0:s ' +
              ' and strTrainJiaoluGUID = %1:s ' +
              ' union  ' +
              ' select strSubTrainJiaoLuGUID from TAB_Base_TrainJiaolu_SubDetail where strTrainJiaoluGUID in  ' +
              ' (select strTrainJiaoluGUID  from TAB_Base_TrainJiaoluInSite where strSiteGUID = %0:s) ' +
              '   and strSubTrainJiaoLuGUID = %1:s ' ;
      strSql := Format(strSql,[QuotedStr(SiteGUID),QuotedStr(TrainJiaoluGUID)]);
      SQL.Text := strSql;
      Open;
      Result := adoQuery.RecordCount > 0;
      Close;
    end;
  finally
    adoQuery.Free;
  end;
end;


procedure TRsDBTrainJiaolu.Sync(trianjiaoluAry: TRsTrainJiaoluArray);
var
  qry:TADOQuery;
  i:INteger;
begin
  qry := NewADOQuery;
  self.GetADOConnection.BeginTrans;
  try
    try
      qry.SQL.Text := 'delete from tab_Base_Trainjiaolu ';
      qry.ExecSQL;
      for i := 0 to Length(trianjiaoluAry) - 1 do
      begin
        self.Add(trianjiaoluAry[i]);
      end;
      self.GetADOConnection.CommitTrans;
    except on e:Exception do
      self.GetADOConnection.RollbackTrans;
    end;
  finally
    qry.Free;
  end;
end;

{ TRSDBTrainJiaoluInSite }

procedure TRSDBTrainJiaoluInSite.Add(trainJiaoluInSite: RRSTrainJiaoluInSite);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Base_TrainJiaoluInSite where strJiaoluInSiteGUID = :strJiaoluInSiteGUID';
    qry.Parameters.ParamByName('strJiaoluInSiteGUID').Value :=  trainJiaoluInSite.strJiaoluInSiteGUID;
    qry.Open;
    if qry.RecordCount = 0 then
      qry.Append
    else
      qry.Edit;
   self.Data2Ado(trainJiaoluInSite,qry);
   qry.Post;
  finally
    qry.Free;
  end;
end;

procedure TRSDBTrainJiaoluInSite.Data2Ado(
  trainJiaoluInSite: RRSTrainJiaoluInSite; qry: TADOQuery);
begin
  qry.FieldByName('strSiteGUID').Value := trainJiaoluInSite.strSiteGUID;
  qry.FieldByName('strTrainJiaoluGUID').Value :=trainJiaoluInSite.strTrainJiaoluGUID ;
  qry.FieldByName('strJiaoluInSiteGUID').Value := trainJiaoluInSite.strJiaoluInSiteGUID;
end;

procedure TRSDBTrainJiaoluInSite.Sync(
  jiaoluInsiteAry: TRRSTrainJiaoluInSiteArray);
var
  qry:TADOQuery;
  i:INteger;
begin
  qry := NewADOQuery;
  self.GetADOConnection.BeginTrans;
  try
    try
      qry.SQL.Text := 'delete from tab_Base_TrainJiaoluInSite ';
      qry.ExecSQL;
      for i := 0 to Length(jiaoluInsiteAry) - 1 do
      begin
        self.Add(jiaoluInsiteAry[i]);
      end;
      self.GetADOConnection.CommitTrans;
    except on e:Exception do
      self.GetADOConnection.RollbackTrans;
    end;
  finally
    qry.Free;
  end;
end;

end.
