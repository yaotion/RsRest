unit uDBSite;

interface

uses
  ADODB,uSite,uTrainmanJiaolu,uTrainJiaolu,uTFSystem,uRsInterfaceDefine,uRunEvent;
type
  //////////////////////////////////////////////////////////////////////////////
  ///客户端信息操作类
  //////////////////////////////////////////////////////////////////////////////
  TRsDBSite = class(TDBOperate)
  private
    procedure ADOQueryTOData(ADOQuery : TADOQuery;Site : TRsSiteInfo);
    procedure Data2Ado(site:RRsSiteInfo;qry:TADOQuery);
    procedure FillSiteTrainJiaolus(ADOQuery : TADOQuery; Site : TRsSiteInfo);
    procedure FillSiteJobLimits(ADOQuery : TADOQuery; Site : TRsSiteInfo);
  public
    function GetSiteByIP(IP : string; Site : TRsSiteInfo) : boolean;
    //增加记录
    procedure Add(siteInfo:RRsSiteInfo);
    //同步增加记录
    procedure SyncAdd(qry:TADOQuery;siteInfo:RRsSiteInfo);
    //增加客户端权限记录
    procedure AddLimit(Limit:RRsJobLimit);
    //删除记录
    procedure Del(strSiteGUID:string);
    //功能:获取全部的站点信息
    class procedure GetSites(ADOConn: TADOConnection; out SiteArray: TRsSiteArray);
    //同步数据
    procedure Sync(SiteArray: TRsSiteArray);
    //同步客户端权限限制
    procedure SyncLimit(LimitArray:TRsJobLimitArray);
  end;

    TDBSite = class(TDBOperate)
  public
    procedure Query(BeginTime,EndTime : TDateTime;TrainNumber  : string; out SiteArray : TSiteArray);
    //将机车日志信息转化为外公寓出入寓事件信息
    procedure ConvertToMessage(SiteDetail : RSite;out  SiteDetailMessage : RRSCWYEvent);

  private
    procedure ADOQueryToData(ADOQuery : TADOQuery;var  Site: RSite);
  end;

implementation
uses
  SysUtils, DB;
{ TDBSite }

procedure TRsDBSite.Add(siteInfo: RRsSiteInfo);
var
  qry:TADOQuery;
begin
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Base_Site where strSiteGUID = :strSiteGUID';
    qry.Parameters.ParamByName('strSiteGUID').Value := siteInfo.strSiteGUID;
    qry.Open;
    if qry.RecordCount = 0 then
      qry.Append
    else
      qry.Edit;
    self.Data2Ado(siteInfo,qry);
    qry.Post;
  finally
    qry.Free;
  end;
end;

procedure TRsDBSite.AddLimit(Limit: RRsJobLimit);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Base_Site_Limit where strSiteGUID = :strSiteGUID';
    qry.Parameters.ParamByName('strSiteGUID').Value := Limit.strSiteGUID;
    qry.Open;
    if qry.RecordCount = 0 then
      qry.Append
    else
      qry.Edit;
    qry.FieldByName('strSiteGUID').Value := Limit.strSiteGUID;
    qry.FieldByName('nJobID').Value := ord(Limit.Job) ;
    qry.FieldByName('nJobLimit').Value := Ord(Limit.Limimt) ;
    qry.Post;
    
  finally
    qry.Free;
  end;
end;

procedure TRsDBSite.ADOQueryTOData(ADOQuery : TADOQuery;Site : TRsSiteInfo);
begin
  with ADOQuery do
  begin
    Site.strSiteGUID := Trim(FieldByName('strSiteGUID').AsString);
    Site.strSiteNumber := Trim(FieldByName('strSiteNumber').AsString);
    Site.strSiteName := Trim(FieldByName('strSiteName').AsString);
    Site.strAreaGUID := Trim(FieldByName('strAreaGUID').AsString);
    Site.nSiteEnable := FieldByName('nSiteEnable').AsInteger;
    Site.strSiteIP := Trim(FieldByName('strSiteIP').AsString);
    Site.nSiteJob := FieldByName('nSiteJob').AsInteger;
    Site.strStationGUID := Trim(FieldByName('strStationGUID').AsString);
    Site.WorkShopGUID := Trim(FieldByName('strWorkShopGUID').AsString);
    Site.Tmis := StrToInt(Trim(FieldByName('strTMIS').AsString));
  end;
end;

procedure TRsDBSite.Data2Ado(site: RRsSiteInfo; qry: TADOQuery);
begin
  with qry do
  begin
    FieldByName('strSiteGUID').AsString := Site.strSiteGUID;
    FieldByName('strSiteNumber').AsString := Site.strSiteNumber;
    FieldByName('strSiteName').AsString := Site.strSiteName;
    FieldByName('strAreaGUID').AsString := Site.strAreaGUID;
    FieldByName('nSiteEnable').AsInteger := Site.nSiteEnable;
    FieldByName('strSiteIP').AsString := Site.strSiteIP;
    FieldByName('nSiteJob').AsInteger := Site.nSiteJob;
    FieldByName('strStationGUID').AsString := Site.strStationGUID;
    FieldByName('strWorkShopGUID').AsString := Site.strWorkShopGUID;
    FieldByName('strTMIS').AsString := Site.strTmis;
  end;
end;

procedure TRsDBSite.Del(strSiteGUID: string);
var
  qry:TADOQuery;
begin
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'delete from tab_base_Site where strSiteGUID = :strGUID';
    qry.Parameters.ParamByName('strGUID').Value := strSiteGUID;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

procedure TRsDBSite.FillSiteJobLimits(ADOQuery: TADOQuery; Site: TRsSiteInfo);
begin
  with adoQuery do
  begin
    while not eof do
    begin
      SetLength(Site.JobLimits,length(Site.JobLimits) + 1);
      Site.JobLimits[length(Site.JobLimits) - 1].Job := TRsSiteJob(FieldByName('nJobID').AsInteger);
      Site.JobLimits[length(Site.JobLimits) - 1].Limimt := TRsJobLimit(FieldByName('nJobLimit').AsInteger);
      next;
    end;
  end;
end;

procedure TRsDBSite.FillSiteTrainJiaolus(ADOQuery: TADOQuery; Site: TRsSiteInfo);
begin
  with adoQuery do
  begin
    while not eof do
    begin
      SetLength(Site.TrainJiaolus,length(Site.TrainJiaolus) + 1);
      Site.TrainJiaolus[length(Site.TrainJiaolus) - 1] := Trim(FieldByName('strTrainJiaoluGUID').asstring);
      next;
    end;
  end;
end;


function TRsDBSite.GetSiteByIP(IP: string; Site: TRsSiteInfo): boolean;
var
  strSql,strSiteGUID : string;
  adoQuery : TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from TAB_Base_Site where strSiteIP = %s';
      strSql := Format(strSql,[QuotedStr(IP)]);
      SQL.Text := strSql;
      Open;
      if RecordCount = 0 then exit;
      strSiteGUID := Trim(FieldByName('strSiteGUID').AsString);
      ADOQueryToData(adoQuery,Site);
      result := true;

      strSql := 'select * from TAB_Base_TrainJiaoluInSite where strSiteGUID = %s';
      strSql := Format(strSql,[QuotedStr(strSiteGUID)]);
      Sql.Text := strSql;
      Open;
      FillSiteTrainJiaolus(ADOQuery,Site);

      strSql := 'select * from TAB_Base_Site_Limit where strSiteGUID = %s';
      strSql := Format(strSql,[QuotedStr(strSiteGUID)]);
      Sql.Text := strSql;
      Open;
      FillSiteJobLimits(ADOQuery,Site);
    end;
  finally
    adoQuery.Free;
  end;
end;

class procedure TRsDBSite.GetSites(ADOConn: TADOConnection; out SiteArray: TRsSiteArray);
var
  i : integer;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin         
      Connection := ADOConn;
      SQL.Text := 'Select * From TAB_Base_Site';
      Open;
      SetLength(SiteArray,RecordCount);
      i := 0;
      while not eof do
      begin
        SiteArray[i].strSiteGUID := FieldByName('strSiteGUID').AsString;
        SiteArray[i].strSiteName := FieldByName('strSiteName').AsString;
        SiteArray[i].strSiteIP := FieldByName('strSiteIP').AsString;
        SiteArray[i].nSiteJob := FieldByName('nSiteJob').AsInteger;
        SiteArray[i].strWorkShopGUID := FieldByName('strWorkShopGUID').AsString;
        SiteArray[i].strAreaGUID := FieldByName('strAreaGUID').AsString;
        inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;



procedure TRsDBSite.Sync(SiteArray: TRsSiteArray);
var
  qry:TADOQuery;
  i:Integer;
begin
  qry := NewADOQuery;
  Self.GetADOConnection.BeginTrans;
  try
    try
      qry.SQL.Text := 'delete from tab_Base_Site ';
      qry.ExecSQL;
      for i := 0 to Length(SiteArray) - 1 do
      begin
        //self.SyncAdd(qry,SiteArray[i]);
        self.Add(SiteArray[i]);
      end;
      self.GetADOConnection.CommitTrans;
    except on e:Exception do
    begin
      self.GetADOConnection.RollbackTrans;
    end;

    end;
  finally
    qry.Free;
  end;
end;

procedure TRsDBSite.SyncAdd(qry: TADOQuery; siteInfo: RRsSiteInfo);
begin
  qry.SQL.Text := 'select * from tab_Base_Site where strSiteGUID = :strSiteGUID';
  qry.Parameters.ParamByName('strSiteGUID').Value := siteInfo.strSiteGUID;
  qry.Open;
  if qry.RecordCount = 0 then
    qry.Append
  else
    qry.Edit;
  self.Data2Ado(siteInfo,qry);
  qry.Post;
end;

procedure TRsDBSite.SyncLimit(LimitArray: TRsJobLimitArray);
var
  qry:TADOQuery;
  i:Integer;
begin
  qry := NewADOQuery;
  self.GetADOConnection.BeginTrans;
  try
    try
      qry.SQL.Text := 'delete from tab_Base_Site_Limit';
      qry.ExecSQL;
      for i := 0 to Length(LimitArray) - 1 do
      begin
        Self.AddLimit(LimitArray[i]);
      end;
      self.GetADOConnection.CommitTrans;
    except on e:Exception do
      self.GetADOConnection.RollbackTrans;
    end;
  finally
    qry.Free;
  end;
end;

{ TDBSite }

procedure TDBSite.ADOQueryToData(ADOQuery: TADOQuery; var Site: RSite);
begin
  with  ADOQuery do
  begin
    Site.nid := FieldByName('nid').AsInteger;
    Site.strRunEventGUID := FieldByName('strRunEventGUID').AsString;
    Site.nEventID := FieldByName('nEventID').AsInteger;
    Site.dtEventTime := FieldByName('dtEventTime').AsDateTime;
    Site.strTrainmanNumber := FieldByName('strTrainmanNumber').AsString;
    Site.nTMIS := FieldByName('nTMIS').AsInteger;
    Site.dtCreateTime := FieldByName('dtCreateTime').AsDateTime;
    Site.nResultID := FieldByName('nResultID').AsInteger;
    Site.strResult := FieldByName('strResult').AsString;
    Site.nSubmitResult := FieldByName('nSubmitResult').AsInteger;
    Site.strSubmitRemark := FieldByName('strSubmitRemark').AsString;
    Site.nKeHuo := FieldByName('nKeHuo').AsInteger;
  end;
end;

procedure TDBSite.ConvertToMessage(SiteDetail: RSite;
  out SiteDetailMessage: RRSCWYEvent);
begin
  SiteDetailMessage.etime := SiteDetail.dtEventTime;
  SiteDetailMessage.tmid := SiteDetail.strTrainmanNumber;
  SiteDetailMessage.stmis := SiteDetail.nTMIS;
  SiteDetailMessage.nresult := SiteDetail.nResultID;
  SiteDetailMessage.strResult := SiteDetail.strResult;  
  case TRunEventType(SiteDetail.nEventID) of
    eteBeginWork: SiteDetailMessage.sjbz := cweBeginWork;
    eteEndWork: SiteDetailMessage.sjbz := cweEndWork;
    eteVerifyCard: SiteDetailMessage.sjbz := cweYanKa;
    eteInRoom: SiteDetailMessage.sjbz := cweInRoom;
    eteOutRoom: SiteDetailMessage.sjbz := cweOutRoom;
  end;
end;

procedure TDBSite.Query(BeginTime, EndTime: TDateTime; TrainNumber: string;
  out SiteArray: TSiteArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  i : integer;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from TAB_Plan_RunEvent_Site where dtEventTime >= %s and dtEventTime <=%s ';
      strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd 00:00:00',BeginTime)),
        QuotedStr(FormatDateTime('yyyy-MM-dd 23:59:59',EndTime))]);


      if Trim(TrainNumber) <> '' then
      begin
        strSql := strSql + ' and (strTrainmanNumber = %s )';
        strSql := Format(strSql,[QuotedStr(TrainNumber)]);
      end;

      strSql := strSql + ' order by dtEventTime';
      SQL.Text := strSql;
      Open;
      SetLength(SiteArray,RecordCount);
      i := 0;
      while not eof do
      begin
        ADOQueryToData(ADOQuery,SiteArray[i]);
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;



end.
