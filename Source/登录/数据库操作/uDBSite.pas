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
    procedure FillSiteTrainJiaolus(ADOQuery : TADOQuery; Site : TRsSiteInfo);
    procedure FillSiteJobLimits(ADOQuery : TADOQuery; Site : TRsSiteInfo);
  public
    function GetSiteByIP(IP : string; Site : TRsSiteInfo) : boolean;
    //功能:获取全部的站点信息
    class procedure GetSites(ADOConn: TADOConnection; out SiteArray: TRsSiteArray);
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
        inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
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
