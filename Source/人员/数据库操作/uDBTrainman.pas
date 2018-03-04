unit uDBTrainman;

interface
uses
  ADODB,uTrainman,Variants,uTFVariantUtils,uTFSystem,uSaftyEnum,uApparatusCommon,
  Windows, StrUtils,classes,uTrainmanJiaolu;
type
  TRsDBTrainman = class(TDBOperate)
  private
    //从adoquery中读取数据放入RTrainman结构中
    class procedure ADOQueryToData(var Trainman:RRsTrainman;ADOQuery : TADOQuery;NeedPicture : boolean = false);
    //将数据从RTrainman结构中放入到ADOQUERY中
    procedure DataToADOQuery(Trainman : RRsTrainman;ADOQuery : TADOQuery;NeedPicture : boolean=false);

    //从ADOQUERY获取人员统计
    procedure ADOQueryToTrainmanStateCount(ADOQuery : TADOQuery;var TrainmanStateCount:RTrainmanStateCount);
    //从ADOQUERY获取请假人员统计
    procedure  ADOQueryToTrainmanLeaveCount(ADOQuery : TADOQuery;var LeaveCount:RRsTrainmanLeaveCount);
  public
    //验证司机工号是否存在
    class function ExistTrainmanByNumber(ADOConn : TADOConnection;TrainmanNumber : string):boolean;
    //获取指定ID的乘务员的信息
    class function GetTrainmanByID(ADOConn:TADOConnection;ID : integer;out Trainman : RRsTrainman) : boolean;
    //获取指定ID的乘务员的信息
    function GetTrainmanByNumber(TrainmanNumber : string;out Trainman : RRsTrainman) : boolean;
    //功能:获取全部的乘务员信息
    class procedure GetTrainmans(ADOConn:TADOConnection; out TrainmanArray:TRsTrainmanArray);
    
    //获取乘务员简要信息
    class procedure GetTrainmansBrief(ADOConn:TADOConnection; out TrainmanArray:TRsTrainmanArray);
    //功能：查询司机信息
    procedure QueryTrainmans(QueryTrainman:RRsQueryTrainman;
      out TrainmanArray:TRsTrainmanArray);
    //功能：查询司机信息,指纹照片01标志,无数据
    procedure QueryTrainmans_blobFlag(QueryTrainman:RRsQueryTrainman;PageIndex: integer;
      out TrainmanArray:TRsTrainmanArray;out nTotalCount:Integer);

    //功能：获取司机职位信息
    class procedure GetPosts(ADOConn : TADOConnection;var postArray : TRsPostArray);
    //是否存在非GUID的司机工号
    function ExistNumber(TrainmanGUID,TrainmanNumber : string) : boolean;
    //根据GUID获取乘务员信息
    function GetTrainman(TrainmanGUID : string;out Trainman : RRsTrainman) : boolean;
    //功能：添加乘务员
    procedure AddTrainman(Trainman : RRsTrainman);
    //功能：修改乘务员
    procedure UpdateTrainman(Trainman : RRsTrainman) ;
    //功能：删除乘务员
    procedure DeleteTrainman(TrainmanGUID: string);
    //获取指定车间内处于预备队列的人员信息
    procedure GetPrepareTrainman(WorkShopGUID : string ;out TrainmanArray : TRsTrainmanArray);

    //预备人员的状态转换成空
    function ConvertTrainmanStateToNull(TrainmanNumber : string):Boolean;overload;
    function ConvertAllTrainmanStateToNull(WorkShopGUID : string ):Boolean;overload;
    //获取指定车间内处于预备队列的人员信息
    procedure GetPrepareTrainmanByNumber(strTrainmanNumber : string ;out TrainmanArray : TRsTrainmanArray);
    //获取空闲人员
    function GetPopupTrainmans(WorkShopGUID, strKeyName: string; PageIndex: integer; out TrainmanArray: TRsTrainmanArray): integer;
    //获取指定车间内出寓请假的人员的信息
    procedure GetUnRunTrainmans(WorkShopGUID : string ;out TrainmanArray : TRsTrainmanLeaveArray);
    //根据请假类型和人员交路获取指定车间内出寓请假的人员的信息
    procedure GetUnRunTrainmanByJiaoLu(WorkShopGUID : string ;TrainmanJiaoLu:string;out TrainmanArray : TRsTrainmanLeaveArray);
    //获取指定类型的非运转的人员列表信息
    procedure GetUnRunTrainmansByType(WorkShopGUID : string ;LeaveTypes : TStrings;out TrainmanArray : TRsTrainmanLeaveArray);
    //获取空闲人员
    procedure GetNilTrainmans(WorkShopGUID : string;strKeyName : string ;
      out TrainmanArray : TRsTrainmanArray);

    //获取车间的人员的 运行状况
    procedure GetTrainmanRunStateCount(WorkShopGUID : string;var TrainmanRunStateCountArray:TRTrainmanRunStateCountArray);
    //获取指定车间的 人员交路状况
    procedure GetTrainmanJiaoLuCount(WorkShopGUID : string;var RsTrainJiaoLuCountArray: TRsTrainJiaoLuCountArray);
    //获取指定车间的所有请假人员统计
    procedure GetTrainmanLeaveCount(WorkShopGUID : string;var LeaveCount:RRsTrainmanLeaveCount);
    //获取指定车间的所有人员的状态
    procedure GetTrainmanStateCount(WorkShopGUID : string;var TrainmanStateCount:RTrainmanStateCount);
    //设置指定人员状态
    procedure SetTrainmanState(TrainmanGUID : string; TrainmanState : TRsTrainmanState);
    //更新司机联系方式
    procedure UpdateTrainmanTel(TrainmanGUID : string;TrainmanTel,
      TrainmanMobile,TrainmanAddress,TrainmanRemark : string);
    procedure GetKeyNameTrainmans(strKeyName: string;out TrainmanArray : TRsTrainmanArray);
    {功能:更新退勤测酒结果}
    procedure UpdateEndworkTestAlcoholResult(TrainmanGUID : string;testResult: RTestAlcoholInfo);
    //根据工号、姓名、简拼取一个司机
    function GetTrainmanGUID(strWorkShopGUID, strTrainmanNumber, strTrainmanName, strJP: string): string;
    //更新指纹库标记
    procedure UpdateFingerLibGUID();
    //获取最后一次的人员交路GUID
    function GetLastTrainmanJiaoLu(TrainmanGUID : string;out TrainmanJiaoLuGUID:string):Boolean;
    {功能:获取最后出入公寓时间}
    function GetLastInOutRoomTime(strTrainmanGUID:string;out dtInRoom,dtOutRoom:TDateTime):Boolean;
  end;
implementation
uses
  SysUtils,DB,ZKFPEngXUtils;
{ TDBTrainman }

procedure TRsDBTrainman.AddTrainman(Trainman: RRsTrainman);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      strSql := 'select * from TAB_Org_Trainman where  1=2 ';
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      Append;
      DataToADOQuery(Trainman,adoQuery,true);
      Post;
    end;
  finally
    adoQuery.Free;
  end;

  UpdateFingerLibGUID;
end;

procedure TRsDBTrainman.UpdateEndworkTestAlcoholResult(TrainmanGUID: string;
  testResult: RTestAlcoholInfo);
const
  UPDATE_SQL = 'update ';
var
  ADOQuery: TADOQuery;
begin
  ADOQuery := TADOQuery.Create(nil);
  try
    ADOQuery.SQL.Text := ''
  finally
    ADOQuery.Free;
  end;
end;

procedure TRsDBTrainman.UpdateTrainman(Trainman: RRsTrainman);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      strSql := 'select * from TAB_Org_Trainman where  strTrainmanGUID = %s ';
      strSql := Format(strSql,[QuotedStr(Trainman.strTrainmanGUID)]);
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then begin
        raise Exception.Create('未找到指定的乘务员信息');
      end;
      Edit;
      DataToADOQuery(Trainman,adoQuery,true);
      Post;
    end;
  finally
    adoQuery.Free;
  end;
  
  UpdateFingerLibGUID;
end;

procedure TRsDBTrainman.UpdateTrainmanTel(TrainmanGUID, TrainmanTel,
  TrainmanMobile, TrainmanAddress, TrainmanRemark: string);
var
  strSql : String;
  adoQuery : TADOQuery;
begin
  strSql := 'update TAB_Org_Trainman set strTelNumber = %s,strMobileNumber = %s, ' +
    ' strAddress = %s,strRemark = %s where strTrainmanGUID=%s ';


  strSql := Format(strSql,[QuotedStr(TrainmanTel),QuotedStr(TrainmanMobile),
    QuotedStr(TrainmanAddress),QuotedStr(TrainmanRemark),QuotedStr(TrainmanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainman.DataToADOQuery(Trainman: RRsTrainman; ADOQuery: TADOQuery;
  NeedPicture: boolean);
var
  StreamObject : TMemoryStream;
begin
  adoQuery.FieldByName('strTrainmanGUID').AsString := Trainman.strTrainmanGUID;
  adoQuery.FieldByName('strTrainmanNumber').AsString := Trainman.strTrainmanNumber;
  adoQuery.FieldByName('strTrainmanName').AsString := Trainman.strTrainmanName;
  ADOQuery.FieldByName('strAreaGUID').AsString:=  Trainman.strAreaGUID ;
  adoQuery.FieldByName('nPostID').asInteger := Ord(Trainman.nPostID);
  adoQuery.FieldByName('strWorkShopGUID').AsString := Trainman.strWorkShopGUID;
  adoQuery.FieldByName('strGuideGroupGUID').AsString := Trainman.strGuideGroupGUID;
  adoQuery.FieldByName('strTelNumber').AsString := Trainman.strTelNumber;
  adoQuery.FieldByName('strMobileNumber').AsString := Trainman.strMobileNumber;
  adoQuery.FieldByName('strAddress').AsString := Trainman.strAdddress;
  adoQuery.FieldByName('nDriverType').asInteger := Ord(Trainman.nDriverType);
  adoQuery.FieldByName('bIsKey').AsInteger := Trainman.bIsKey;
  adoQuery.FieldByName('dtRuZhiTime').AsDateTime := Trainman.dtRuZhiTime;
  adoQuery.FieldByName('dtJiuZhiTime').AsDateTime := Trainman.dtJiuZhiTime;
  adoQuery.FieldByName('nDriverLevel').AsInteger := Trainman.nDriverLevel;
  adoQuery.FieldByName('strABCD').AsString := Trainman.strABCD;
  adoQuery.FieldByName('strRemark').AsString := Trainman.strRemark;
  adoQuery.FieldByName('nKeHuoID').AsInteger := Ord(Trainman.nKeHuoID);
  adoQuery.FieldByName('strRemark').AsString := Trainman.strRemark;
  adoQuery.FieldByName('strTrainJiaoluGUID').AsString := Trainman.strTrainJiaoluGUID;
  ADOQuery.FieldByName('strTrainmanJiaoluGUID').AsString :=  Trainman.strTrainmanJiaoluGUID;
  adoQuery.FieldByName('dtLastEndworkTime').AsDateTime := Trainman.dtLastEndworkTime;
  adoQuery.FieldByName('dtCreateTime').AsDateTime := Trainman.dtCreateTime;
  adoQuery.FieldByName('nTrainmanState').asInteger := Ord(Trainman.nTrainmanState);
  adoQuery.FieldByName('strJP').AsString := Trainman.strJP;

  StreamObject := TMemoryStream.Create;
  try
    {读取指纹1}
    if not (VarIsNull(Trainman.FingerPrint1)  or VarIsEmpty(Trainman.FingerPrint1)) then
    begin
      TemplateOleVariantToStream(Trainman.FingerPrint1,StreamObject);
      (ADOQuery.FieldByName('FingerPrint1') As TBlobField).LoadFromStream(StreamObject);
      StreamObject.Clear;
    end;

    {读取指纹2}
    if not (VarIsNull(Trainman.FingerPrint2)  or VarIsEmpty(Trainman.FingerPrint2)) then
      begin
      TemplateOleVariantToStream(Trainman.FingerPrint2,StreamObject);
      (ADOQuery.FieldByName('FingerPrint2') As TBlobField).LoadFromStream(StreamObject);

      StreamObject.Clear;
    end;
    
    if NeedPicture then
    begin
    {读取照片}
      if not (VarIsNull(Trainman.Picture)  or VarIsEmpty(Trainman.Picture)) then
      begin
         TemplateOleVariantToStream(Trainman.Picture,StreamObject);
        (ADOQuery.FieldByName('Picture') As TBlobField).LoadFromStream(StreamObject);
        StreamObject.Clear;
      end;
    end;
  finally
    StreamObject.Free;
  end;
end;

procedure TRsDBTrainman.DeleteTrainman(TrainmanGUID: string);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      strSql := 'delete from tab_org_trainman where strTrainmanGUID = %s';
      strSql := Format(strSql,[QuotedStr(TrainmanGUID)]);
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      ExecSQL
    end;
  finally
    adoQuery.Free;
  end;

  UpdateFingerLibGUID;
end;

function TRsDBTrainman.ExistNumber(TrainmanGUID, TrainmanNumber: string): boolean;
var
  strSql : String;
  adoQuery : TADOQuery;
begin
  strSql := 'Select count(*) From VIEW_Org_Trainman Where strTrainmanNumber = %s and strTrainmanGUID <> %s';
  strSql := Format(strSql, [QuotedStr(TrainmanNumber),QuotedStr(TrainmanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := m_ADOConnection;
    adoQuery.SQL.Text := strSql;
    adoQuery.Open;
    Result := adoQuery.Fields[0].AsInteger > 0;
  finally
    adoQuery.Free;
  end;

end;

class function TRsDBTrainman.ExistTrainmanByNumber(ADOConn: TADOConnection;
  TrainmanNumber: string): boolean;
var
  strSql : String;
  adoQuery : TADOQuery;
begin
  strSql := 'Select count(*) From VIEW_Org_Trainman Where strTrainmanNumber = %s';
  strSql := Format(strSql, [QuotedStr(TrainmanNumber)]);
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := ADOConn;
    adoQuery.SQL.Text := strSql;
    adoQuery.Open;
    Result := adoQuery.Fields[0].AsInteger > 0; 
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainman.GetPopupTrainmans(WorkShopGUID, strKeyName: string; PageIndex: integer; out TrainmanArray: TRsTrainmanArray): integer;
var
  i: integer;
  strSql, strWhere: String;
  adoQuery: TADOQuery;
begin
  result := 0;
  WorkShopGUID := Trim(WorkShopGUID);
  strKeyName := Trim(strKeyName);
  if PageIndex <= 0 then PageIndex := 1;
  
  strWhere := '';
  if WorkShopGUID <> '' then strWhere := strWhere + Format(' and strWorkShopGUID=''%s''', [WorkShopGUID]);
  if strKeyName <> '' then
  begin
    strWhere := strWhere + Format(' and ((strTrainmanNumber like ''%s'') or (strJP like ''%s'') or (strTrainmanName like ''%s''))',
                                  [strKeyName+'%', strKeyName+'%', strKeyName+'%']);
  end;
  {strSql := 'select  strTrainmanGUID,strTrainmanNumber,strTrainmanName,nPostID,nKeHuoID,' +
            'bIsKey,strABCD,strMobileNumber,nTrainmanState from TAB_Org_Trainman where 1=1';
  strSql := strSql + strWhere + ' order by strTrainmanNumber';
                                                                   }
  strSql := 'select top 10 strTrainmanGUID,strTrainmanNumber,strTrainmanName,nPostID,nKeHuoID,' +
          'bIsKey,strABCD,strMobileNumber,nTrainmanState from '+
          '(select ROW_NUMBER() over(order by strTrainmanNumber) as rownumber,* from TAB_Org_Trainman where 1=1 ';
  strSql := strSql + strWhere + ' ) A where RowNumber >' + IntToStr(10 *(PageIndex -1));

  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      //MoveBy((PageIndex - 1) * 10);
      i := 0;
      while not eof do
      begin
        SetLength(TrainmanArray, i + 1);
        TrainmanArray[i].strTrainmanGUID := adoQuery.FieldByName('strTrainmanGUID').AsString;
        TrainmanArray[i].strTrainmanNumber := adoQuery.FieldByName('strTrainmanNumber').AsString;
        TrainmanArray[i].strTrainmanName := adoQuery.FieldByName('strTrainmanName').AsString;
        TrainmanArray[i].nPostID := TRsPost(adoQuery.FieldByName('nPostID').asInteger);
        if adoQuery.FieldByName('nKeHuoID').AsString = '' then
          TrainmanArray[i].nKeHuoID := khNone
        else
          TrainmanArray[i].nKeHuoID :=  TRsKehuo(adoQuery.FieldByName('nKeHuoID').AsInteger);    
        TrainmanArray[i].bIsKey := adoQuery.FieldByName('bIsKey').AsInteger;
        TrainmanArray[i].strABCD := adoQuery.FieldByName('strABCD').AsString;
        TrainmanArray[i].strMobileNumber := adoQuery.FieldByName('strMobileNumber').AsString;
        TrainmanArray[i].nTrainmanState := TRsTrainmanState(adoQuery.FieldByName('nTrainmanState').asInteger);

        inc(i);
        //if i = 10 then break;
        next;
      end;

      Close;
      SQL.Text := 'select count(nid) from TAB_Org_Trainman where 1=1' + strWhere;
      Open;
      if not eof then result := adoQuery.Fields[0].AsInteger;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainman.GetTrainmanGUID(strWorkShopGUID, strTrainmanNumber, strTrainmanName, strJP: string): string;
var
  strSql, strSql0, strSql1, strSql2, strSql3: String;
  adoQuery : TADOQuery;
begin
  result := '';
  strSql := 'select top 1 strTrainmanGUID from VIEW_Org_Trainman where 1=1 ';

  if Trim(strWorkShopGUID) <> '' then
  begin
    strSql := strSql + ' and (strWorkShopGUID = %s ) ';
    strSql := Format(strSql,[QuotedStr(Trim(strWorkShopGUID))]);
  end;
  if (Trim(strTrainmanNumber) <> '') or (Trim(strTrainmanName) <> '') or (Trim(strJP) <> '') then
  begin                     
    strSql0 := '(0=1) ';
    if Trim(strTrainmanNumber) <> '' then strSql1 := Format('or (strTrainmanNumber like %s) ',[QuotedStr(Trim(strTrainmanNumber) + '%')]);
    if Trim(strTrainmanName) <> '' then strSql2 := Format('or (strTrainmanName like %s) ',[QuotedStr(Trim(strTrainmanName) + '%')]);
    if Trim(strJP) <> '' then strSql3 := Format('or (strJP like %s) ',[QuotedStr(Trim(strJP) + '%')]);
    strSql0 := strSql0 + strSql1 + strSql2 + strSql3;
    strSql := strSql + ' and (' + strSql0 + ') ';
  end;

  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      if not eof then
      begin
        result := FieldByName('strTrainmanGUID').AsString;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainman.GetTrainmanJiaoLuCount(WorkShopGUID: string;
  var RsTrainJiaoLuCountArray: TRsTrainJiaoLuCountArray);
var
  strSql : String;
  adoQuery : TADOQuery;
  i : Integer ;
begin
  strSql := 'select count(*) as nCount,strTrainmanJiaoluGUID,strTrainmanJiaoluName from VIEW_Nameplate_TrainmanInJiaolu_All ' +
  ' where strTrainmanJiaoluGUID in (select strTrainmanJiaoluGUID from VIEW_Base_JiaoluRelation where strWorkSHopGUID = %s) ' +
  ' group by strTrainmanJiaoluGUID,strTrainmanJiaoluName ';
  strSql := Format(strSql,[QuotedStr(WorkShopGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      SetLength(RsTrainJiaoLuCountArray,RecordCount);
      i := 0;
      while not eof do
      begin
        RsTrainJiaoLuCountArray[i].strJiaoLuName :=
          adoQuery.FieldByName('strTrainmanJiaoluName').AsString;
        RsTrainJiaoLuCountArray[i].nCount :=
          adoQuery.FieldByName('nCount').AsInteger;
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainman.GetTrainmanLeaveCount(WorkShopGUID: string;
  var LeaveCount: RRsTrainmanLeaveCount);
var
  strSql : String;
  adoQuery : TADOQuery;
begin
  strSql := 'select *, ' +
    ' (select top 1 strLeaveTypeGUID from VIEW_LeaveMgr_AskLeaveWithTypeName where strTrainmanID=strTrainmanNumber order by dBeginTime desc) as strLeaveTypeGUID, ' +
    ' (select top 1 strTypeName from VIEW_LeaveMgr_AskLeaveWithTypeName where strTrainmanID=strTrainmanNumber order by dBeginTime desc) as strLeaveTypeName' +
    ' from VIEW_Org_Trainman where strWorkShopGUID=%s  ' +
    ' and nTrainmanState = %d  order by strLeaveTypeGUID,strTrainmanNumber ';
  strSql := Format(strSql,[QuotedStr(WorkShopGUID),Ord(tsUnRuning)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      while not eof do
      begin
        ADOQueryToTrainmanLeaveCount(adoQuery,LeaveCount);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainman.GetTrainmanRunStateCount(WorkShopGUID: string;
  var TrainmanRunStateCountArray: TRTrainmanRunStateCountArray);
var
  strSql : String;
  adoQuery : TADOQuery;
  strLastJiaoLuName : string;
  strCurrentJiaoLuName:string;
  i :Integer ;
  j : Integer;
  n : Integer ;
  nEvent : Integer ;
  nPlanState : Integer;
  group : RRsGroup;
begin
  j := 0 ;
  strSql := 'select tm.*,p.nPlanState,  '+
    ' (select top 1 nEventID from tab_plan_RunEvent where tm.strTrainPlanGUID = strTrainPlanGUID order by dtEventTime desc) as nEventID from '+
    ' (  '+
    ' select strWorkShopGUID1,strTrainmanName1,strTrainmanNumber1, strTrainmanName2,strTrainmanNumber2,strTrainmanName3,strTrainmanNumber3, strTrainmanName4,strTrainmanNumber4,strTrainmanJiaoluName,strTrainPlanGUID from VIEW_Nameplate_Group '+
    ' )  '+
    ' as tm left join tab_plan_train as p on  tm.strTrainPlanGUID = p.strTrainPlanGUID  '+
    ' left join TAB_Org_WorkShop as w on  tm.strWorkShopGUID1 = w.strWorkShopGUID where strWorkShopGUID1 = %s order by strTrainmanjiaoluName';

  strSql := Format(strSql,[QuotedStr(WorkShopGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      if  RecordCount = 0 then
        Exit ;
      
      i := 0 ;
      n := 0 ;
      while not eof do
      begin
        strCurrentJiaoLuName := FieldByName('strTrainmanJiaoluName').asstring;
        //add 2014/08/05
        //排除交路名字为空的
        if strCurrentJiaoLuName = '' then
        begin
          next;
          Continue;
        end;

        if ( strCurrentJiaoLuName <> strLastJiaoLuName ) then
        begin
          j := 0 ;
          SetLength(TrainmanRunStateCountArray,Length(TrainmanRunStateCountArray)+1);
          if i <> 0 then
          begin
             Inc(n);
          end;
        end;
        TrainmanRunStateCountArray[n].strJiaoLuName :=  strCurrentJiaoLuName ;

        nEvent :=  FieldByName('nEventID').AsInteger;
        if nEvent = 10001 then
        begin
          group.GroupState := tsOutRoom;
          Inc(TrainmanRunStateCountArray[n].nSiteCount)  ;
        end
        else
        begin
          nPlanState := FieldByName('nPlanState').AsInteger;
          if nPlanState = 7  then
          begin
            group.GroupState := tsRuning;
            Inc(TrainmanRunStateCountArray[n].nRuningCount)  ;
          end
          else
          begin
            group.GroupState := tsInRoom;
            Inc(TrainmanRunStateCountArray[n].nLocalCount)   ;
          end;
        end;

        group.Trainman1.strTrainmanName :=   FieldByName('strTrainmanName1').AsString;
        group.Trainman1.strTrainmanNumber :=   FieldByName('strTrainmanNumber1').AsString;

        group.Trainman2.strTrainmanName :=   FieldByName('strTrainmanName2').AsString;
        group.Trainman2.strTrainmanNumber :=   FieldByName('strTrainmanNumber2').AsString;

        group.Trainman3.strTrainmanName :=   FieldByName('strTrainmanName3').AsString;
        group.Trainman3.strTrainmanNumber :=   FieldByName('strTrainmanNumber3').AsString;

        group.Trainman4.strTrainmanName :=   FieldByName('strTrainmanName4').AsString;
        group.Trainman4.strTrainmanNumber :=   FieldByName('strTrainmanNumber4').AsString;


        SetLength(TrainmanRunStateCountArray[n].group,Length(TrainmanRunStateCountArray[n].group)+1);
        TrainmanRunStateCountArray[n].group[j] :=  group ;

        strLastJiaoLuName := strCurrentJiaoLuName ;
        Inc(i);
        inc(j);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainman.GetKeyNameTrainmans(strKeyName: string;
  out TrainmanArray: TRsTrainmanArray);
var
  i : integer;
  strSql : String;
  adoQuery : TADOQuery;
begin
  strSql := 'select top 10 strTrainmanGUID,strTrainmanNumber,strTrainmanName from TAB_Org_Trainman ';

  if Trim(strKeyName) <> '' then
  begin
    strSql := strSql + ' where strTrainmanNumber like %s';
    strSql := Format(strSql,[QuotedStr(Trim(strKeyName) + '%')]);
  end;
  strSql := strSql + ' order by strTrainmanNumber';

  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      SetLength(TrainmanArray,RecordCount);
      i := 0;
      while not eof do
      begin
        TrainmanArray[i].strTrainmanGUID :=
              adoQuery.FieldByName('strTrainmanGUID').AsString;
        TrainmanArray[i].strTrainmanNumber :=
              adoQuery.FieldByName('strTrainmanNumber').AsString;
        TrainmanArray[i].strTrainmanName :=
              adoQuery.FieldByName('strTrainmanName').AsString;
        inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;



function TRsDBTrainman.GetLastInOutRoomTime(strTrainmanGUID: string;
  out dtInRoom, dtOutRoom: TDateTime): Boolean;
var
  qry:TADOQuery;
begin
  result := False;
  dtInRoom := 0;
  dtOutRoom := 0;
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select dtLastInRoomTime ,dtLastOutRoomTime from '
      + 'tab_Org_Trainman where strTrainmanGUID = :strTrainmanGUID';
    qry.Parameters.ParamByName('strTrainmanGUID').Value := strTrainmanGUID;
    qry.Open;
    if qry.RecordCount = 0  then Exit;
    if not qry.FieldByName('dtLastInRoomTime').IsNull then
    begin
      dtInRoom := qry.FieldByName('dtLastInRoomTime').AsDateTime;
    end;
    if not qry.FieldByName('dtLastOutRoomTime').IsNull then
    begin
      dtOutRoom := qry.FieldByName('dtLastOutRoomTime').AsDateTime;
    end;
    result := True;
  finally
    qry.Free;
  end;
end;

function TRsDBTrainman.GetLastTrainmanJiaoLu(TrainmanGUID:string;
  out TrainmanJiaoLuGUID: string): Boolean;
var
  strSql : String;
  adoQuery : TADOQuery;
begin
  Result := False ;
  strSql := 'Select * From  tab_org_trainman where strTrainmanGuid = ' + QuotedStr(TrainmanGUID);
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := m_ADOConnection ;
    adoQuery.SQL.Text := strSql;
    adoQuery.Open;
    if adoQuery.RecordCount = 0 then
      Exit ;
    TrainmanJiaoLuGUID := adoQuery.FieldByName('strTrainmanJiaoluGUID').AsString;
    Result := True ;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainman.GetNilTrainmans(WorkShopGUID : string;strKeyName : string ;
      out TrainmanArray : TRsTrainmanArray);
var
  i : integer;
  strSql,strState : String;
  adoQuery : TADOQuery;
begin
  if WorkShopGUID <> '' then
  begin
    strSql := 'select top 10 * from VIEW_Org_Trainman where strWorkShopGUID = %s and nTrainmanState in %s ';
    strState := '(%d,%d)';
    strState := Format(strState,[Ord(tsReady),Ord(tsNil)]);
    strSql := Format(strSql,[QuotedStr(WorkShopGUID),strState]);
  end
  else
  begin
    strSql := 'select top 10 * from VIEW_Org_Trainman where nTrainmanState in %s ';
    strState := '(%d,%d)';
    strState := Format(strState,[Ord(tsReady),Ord(tsNil)]);
    strSql := Format(strSql,[strState]);
  end;

  if Trim(strKeyName) <> '' then
  begin
    strSql := strSql + ' and ((strTrainmanNumber like %s ) or (strJP like %s)) ';
    strSql := Format(strSql,[QuotedStr(Trim(strKeyName) + '%'),QuotedStr(Trim(strKeyName) + '%')]);
  end;
  strSql := strSql + ' order by strTrainmanNumber';

  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      SetLength(TrainmanArray,RecordCount);
      i := 0;
      while not eof do
      begin
        ADOQueryToData(TrainmanArray[i],adoQuery);
        inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

class procedure TRsDBTrainman.GetPosts(ADOConn: TADOConnection;
  var postArray: TRsPostArray);
var
  i : integer;
  strSql : String;
  adoQuery : TADOQuery;
begin
  strSql := 'Select * From TAB_System_Post order by nPostID';
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := ADOConn;
    adoQuery.SQL.Text := strSql;
    adoQuery.Open;

    setLength(postArray,adoQuery.RecordCount + 1);
    i := 0;
    postArray[0]:=ptNone;
    while not adoQuery.eof  do
    begin
      inc(i);
      postArray[i]:=TRsPost(adoQuery.FieldByName('nPostID').asinteger);
      adoQuery.next;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainman.GetPrepareTrainman(WorkShopGUID: string;
  out TrainmanArray: TRsTrainmanArray);
{功能:根据ID获取乘务员信息}
var
  i : integer;
  strSql : String;
  adoQuery : TADOQuery;
begin
  strSql :=  'select * from VIEW_Nameplate_TrainmanJiaolu_Prepare where nTrainmanState <> 7 and strWorkShopGUID = %s order by strTrainmanNumber';
  strSql := Format(strSql,[QuotedStr(WorkShopGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      SetLength(TrainmanArray,RecordCount);
      i := 0;
      while not eof do
      begin
        ADOQueryToData(TrainmanArray[i],adoQuery);
        inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainman.GetPrepareTrainmanByNumber(
  strTrainmanNumber: string; out TrainmanArray: TRsTrainmanArray);
var
  i : integer;
  strSql : String;
  adoQuery : TADOQuery;
begin
  strSql :=  'select *,strTrainmanJiaoluGUID from VIEW_Nameplate_TrainmanJiaolu_Prepare where strTrainmanNumber = %s order by strTrainmanNumber';
  strSql := Format(strSql,[QuotedStr(strTrainmanNumber)]);  
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      SetLength(TrainmanArray,RecordCount);
      i := 0;
      while not eof do
      begin
        ADOQueryToData(TrainmanArray[i],adoQuery);
        inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;




function TRsDBTrainman.GetTrainman(TrainmanGUID: string;
  out Trainman: RRsTrainman): boolean;
var
  strSql : String;
  adoQuery : TADOQuery;
begin
  Result := False;
  strSql := 'Select Top 1 * From VIEW_Org_Trainman Where strTrainmanGUID = %s';
  strSql := Format(strSql, [QuotedStr(TrainmanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := m_ADOConnection;
    adoQuery.SQL.Text := strSql;
    adoQuery.Open;
    if adoQuery.RecordCount > 0 then
    begin
      ADOQueryToData(Trainman,adoQuery,true);
      Result := True;
    end;
  finally
    adoQuery.Free;
  end;
end;

class function TRsDBTrainman.GetTrainmanByID(ADOConn: TADOConnection;
  ID: integer; out Trainman: RRsTrainman) : boolean;
{功能:根据ID获取乘务员信息}
var
  strSql : String;
  adoQuery : TADOQuery;
begin
  Result := False;
  strSql := 'Select Top 1 * From VIEW_Org_Trainman Where nID = %d';
  strSql := Format(strSql, [ID]);
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := ADOConn;
    adoQuery.SQL.Text := strSql;
    adoQuery.Open;
    if adoQuery.RecordCount > 0 then
    begin
      ADOQueryToData(Trainman,adoQuery,true);
      Result := True;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainman.GetTrainmanByNumber(TrainmanNumber: string; out Trainman: RRsTrainman): boolean;
{功能:根据ID获取乘务员信息}
var
  strSql : String;
  adoQuery : TADOQuery;
begin
  Result := False;
  strSql := 'Select Top 1 * From VIEW_Org_Trainman Where strTrainmanNumber = %s';
  strSql := Format(strSql, [QuotedStr(TrainmanNumber)]);
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := m_ADOConnection;
    adoQuery.SQL.Text := strSql;
    adoQuery.Open;
    if adoQuery.RecordCount > 0 then
    begin
      ADOQueryToData(Trainman,adoQuery,true);
      Result := True;
    end;
  finally
    adoQuery.Free;
  end;

end;

class procedure TRsDBTrainman.GetTrainmans(ADOConn: TADOConnection;
  out TrainmanArray: TRsTrainmanArray);
{功能:根据ID获取乘务员信息}
var
  i : integer;
  strSql : String;
  adoQuery : TADOQuery;
begin
  strSql := 'Select * From VIEW_Org_Trainman order by strTrainmanNumber ';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      SQL.Text := strSql;
      Open;
      SetLength(TrainmanArray,RecordCount);
      i := 0;
      while not eof do
      begin
        ADOQueryToData(TrainmanArray[i],adoQuery);
        inc(i);

        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

class procedure TRsDBTrainman.GetTrainmansBrief(ADOConn: TADOConnection;
  out TrainmanArray: TRsTrainmanArray);
var
  i : integer;
  strSql : String;
  adoQuery : TADOQuery;
  StreamObject: TMemoryStream;
begin
  strSql := 'Select strTrainmanGUID,strTrainmanNumber,strTrainmanName,strWorkShopGUID,'
    + 'strTelNumber,strMobileNumber,strJP,nID,FingerPrint1,FingerPrint2 '
    + 'From TAB_Org_Trainman order by nID';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      SQL.Text := strSql;
      Open;
      SetLength(TrainmanArray,RecordCount);
      i := 0;
      while not eof do
      begin
        TrainmanArray[i].strTrainmanGUID := adoQuery.FieldByName('strTrainmanGUID').AsString;
        TrainmanArray[i].strTrainmanNumber := adoQuery.FieldByName('strTrainmanNumber').AsString;
        TrainmanArray[i].strTrainmanName := adoQuery.FieldByName('strTrainmanName').AsString;
        TrainmanArray[i].strWorkShopGUID := adoQuery.FieldByName('strWorkShopGUID').AsString;
        TrainmanArray[i].strTelNumber := adoQuery.FieldByName('strTelNumber').AsString;
        TrainmanArray[i].nID := adoQuery.FieldByName('nID').asInteger;

        TrainmanArray[i].strJP := adoQuery.FieldByName('strJP').AsString;
        StreamObject := TMemoryStream.Create;
        try
          {读取指纹1}
          if ADOQuery.FieldByName('FingerPrint1').IsNull = False then
          begin
            (ADOQuery.FieldByName('FingerPrint1') As TBlobField).SaveToStream(StreamObject);
            TrainmanArray[i].FingerPrint1 := StreamToTemplateOleVariant(StreamObject);
            StreamObject.Clear;
          end;

          {读取指纹2}
          if ADOQuery.FieldByName('FingerPrint2').IsNull = False then
          begin
            (ADOQuery.FieldByName('FingerPrint2') As TBlobField).SaveToStream(StreamObject);
            TrainmanArray[i].FingerPrint2 := StreamToTemplateOleVariant(StreamObject);
            StreamObject.Clear;
          end;
        finally
          StreamObject.Free;
        end;

        
        inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;


procedure TRsDBTrainman.GetTrainmanStateCount(WorkShopGUID: string;
  var TrainmanStateCount: RTrainmanStateCount);
var
  strSql : String;
  adoQuery : TADOQuery;
begin
  strSql := 'select nTrainmanState from TAB_Org_Trainman where strWorkShopGUID = %s ';
  strSql := Format(strSql,[QuotedStr(WorkShopGUID),Ord(tsUnRuning)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      while not eof do
      begin
        ADOQueryToTrainmanStateCount(adoQuery,TrainmanStateCount);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainman.GetUnRunTrainmanByJiaoLu(WorkShopGUID,
  TrainmanJiaoLu: string; 
  out TrainmanArray: TRsTrainmanLeaveArray);
var
  i : integer;
  strSql : String;
  adoQuery : TADOQuery;
begin
  strSql := 'select *, ' +
    ' (select top 1 strLeaveTypeGUID from VIEW_LeaveMgr_AskLeaveWithTypeName where strTrainmanID=strTrainmanNumber order by dBeginTime desc) as strLeaveTypeGUID, ' +
    ' (select top 1 strTypeName from VIEW_LeaveMgr_AskLeaveWithTypeName where strTrainmanID=strTrainmanNumber order by dBeginTime desc) as strLeaveTypeName' +
    ' from VIEW_Org_Trainman where strWorkShopGUID=%s  ' +
    ' and nTrainmanState = %d  and  strTrainmanJiaoluGUID = %s order by strLeaveTypeGUID,strTrainmanNumber ';
  strSql := Format(strSql,[QuotedStr(WorkShopGUID),Ord(tsUnRuning),QuotedStr(TrainmanJiaoLu)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      SetLength(TrainmanArray,RecordCount);
      i := 0;
      while not eof do
      begin
        ADOQueryToData(TrainmanArray[i].Trainman,adoQuery);
        TrainmanArray[i].strLeaveTypeGUID := FieldByName('strLeaveTypeGUID').AsString;
        TrainmanArray[i].strLeaveTypeName := FieldByName('strLeaveTypeName').AsString;
        inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainman.GetUnRunTrainmans(WorkShopGUID: string;
  out TrainmanArray: TRsTrainmanLeaveArray);
{功能:根据ID获取乘务员信息}
var
  i : integer;
  strSql : String;
  adoQuery : TADOQuery;
begin
  strSql := 'select *, ' +
    ' (select top 1 strLeaveTypeGUID from VIEW_LeaveMgr_AskLeaveWithTypeName where strTrainmanID=strTrainmanNumber order by dBeginTime desc) as strLeaveTypeGUID, ' +
    ' (select top 1 strTypeName from VIEW_LeaveMgr_AskLeaveWithTypeName where strTrainmanID=strTrainmanNumber order by dBeginTime desc) as strLeaveTypeName' +
    ' from VIEW_Org_Trainman where strWorkShopGUID=%s  ' +
    ' and nTrainmanState = %d  order by strLeaveTypeGUID,strTrainmanNumber ';
  strSql := Format(strSql,[QuotedStr(WorkShopGUID),Ord(tsUnRuning)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      SetLength(TrainmanArray,RecordCount);
      i := 0;
      while not eof do
      begin
        ADOQueryToData(TrainmanArray[i].Trainman,adoQuery);
        TrainmanArray[i].strLeaveTypeGUID := FieldByName('strLeaveTypeGUID').AsString;
        TrainmanArray[i].strLeaveTypeName := FieldByName('strLeaveTypeName').AsString;
        inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;

procedure TRsDBTrainman.GetUnRunTrainmansByType(WorkShopGUID: string;
  LeaveTypes: TStrings; out TrainmanArray: TRsTrainmanLeaveArray);
{功能:根据ID获取乘务员信息}
var
  i : integer;
  strSql : String;
  adoQuery : TADOQuery;
  strLeaveTypes : string;
begin
  for i := 0 to LeaveTypes.Count - 1 do
  begin
    if strLeaveTypes = '' then
      strLeaveTypes := QuotedStr(LeaveTypes[i])
    else
      strLeaveTypes := strLeaveTypes + ',' + QuotedStr(LeaveTypes[i]);
  end;
  if strLeaveTypes = '' then
    strLeaveTypes := Format('(%s)',[QuotedStr(strLeaveTypes)])
  else
    strLeaveTypes := Format('(%s)',[strLeaveTypes]);
  strSql := 'select *, ' +
    ' (select top 1 strLeaveTypeGUID from VIEW_LeaveMgr_AskLeaveWithTypeName where strTrainmanID=strTrainmanNumber order by dBeginTime desc) as strLeaveTypeGUID, ' +
    ' (select top 1 strTypeName from VIEW_LeaveMgr_AskLeaveWithTypeName where strTrainmanID=strTrainmanNumber order by dBeginTime desc) as strLeaveTypeName' +
    ' from VIEW_Org_Trainman where strWorkShopGUID=%s  ' +
    ' and nTrainmanState = %d and ' +
    ' (select top 1 strLeaveTypeGUID from VIEW_LeaveMgr_AskLeaveWithTypeName ' +
    ' where strTrainmanID=strTrainmanNumber order by dBeginTime desc) in %s  ' +
    'order by (select top 1 strLeaveTypeGUID from VIEW_LeaveMgr_AskLeaveWithTypeName ' +
    ' where strTrainmanID=strTrainmanNumber order by dBeginTime desc),strTrainmanNumber ';
  strSql := Format(strSql,[QuotedStr(WorkShopGUID),Ord(tsUnRuning),strLeaveTypes]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      SetLength(TrainmanArray,RecordCount);
      i := 0;
      while not eof do
      begin
        ADOQueryToData(TrainmanArray[i].Trainman,adoQuery);
        TrainmanArray[i].strLeaveTypeGUID := FieldByName('strLeaveTypeGUID').AsString;
        TrainmanArray[i].strLeaveTypeName := FieldByName('strLeaveTypeName').AsString;
        inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainman.QueryTrainmans(QueryTrainman: RRsQueryTrainman;
  out TrainmanArray: TRsTrainmanArray);
{功能:根据ID获取乘务员信息}
var
  i : integer;
  strSql,sqlCondition : String;
  adoQuery : TADOQuery;
begin
  strSql := 'Select * From VIEW_Org_Trainman %s order by strTrainmanNumber ';   

  {$region '组合查询条件'}
  sqlCondition :=  ' where 1=1 ';
  with QueryTrainman do
  begin
    if strTrainmanNumber <> '' then
    begin
      sqlCondition := sqlCondition + ' and strTrainmanNumber = %s';
      sqlCondition := Format(sqlCondition,[QuotedStr(strTrainmanNumber)])
    end;

    if (strWorkShopGUID <> '') then
    begin
      sqlCondition := sqlCondition + ' and strWorkShopGUID = %s';
      sqlCondition := Format(sqlCondition,[QuotedStr(strWorkShopGUID)])
    end;
    if (strGuideGroupGUID <> '') then
    begin
      sqlCondition := sqlCondition + ' and strGuideGroupGUID = %s';
      sqlCondition := Format(sqlCondition,[QuotedStr(strGuideGroupGUID)]);
    end;
    if (strTrainJiaoluGUID <> '') then
    begin
      sqlCondition := sqlCondition + ' and strTrainJiaoluGUID = %s';
      sqlCondition := Format(sqlCondition,[QuotedStr(strTrainJiaoluGUID)]);    
    end;
    if strTrainmanName <> '' then
    begin
      sqlCondition := sqlCondition + ' and strTrainmanName like %s';
      sqlCondition := Format(sqlCondition,[QuotedStr('%'+strTrainmanName+'%')])    
    end;
    if (nFingerCount >= 0) then
    begin
      if nFingerCount = 0 then
      begin
        sqlCondition := sqlCondition + ' and ((FingerPrint1 is null) and (FingerPrint2 is null))';
      end;
      if nFingerCount = 1 then
      begin
        sqlCondition := sqlCondition + ' and (((FingerPrint1 is null) and not (FingerPrint2 is null)) or  ((FingerPrint2 is null) and not (FingerPrint1 is null)))';
      end;
      if nFingerCount = 2 then
      begin
        sqlCondition := sqlCondition + ' and (not(FingerPrint1 is null) and not(FingerPrint2 is null)) ';
      end;
    end;
    if (nPhotoCount >= 0) then
    begin
      if nPhotoCount = 0 then
      begin
        sqlCondition := sqlCondition + ' and (picture is null)';
      end;
      if nPhotoCount > 0 then
      begin
        sqlCondition := sqlCondition + ' and not (picture is null)';
      end;
    end;
  end;
  {$endregion '组合查询条件'}
  strSql := Format(strSql,[sqlCondition]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      SetLength(TrainmanArray,RecordCount);
      i := 0;
      while not eof do
      begin
        ADOQueryToData(TrainmanArray[i],adoQuery);
        inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;


procedure TRsDBTrainman.QueryTrainmans_blobFlag(QueryTrainman: RRsQueryTrainman;PageIndex: integer;
  out TrainmanArray: TRsTrainmanArray;out nTotalCount:Integer);
{功能:根据ID获取乘务员信息}
var
  i : integer;
  strSql,sqlCondition,sqlPageCondition : String;
  adoQuery : TADOQuery;
begin
  if PageIndex <=  0 then
    PageIndex := 1;

  strSql := 'SELECT  top 100  strTrainmanNumber';
  strSql := strSql + ',strTrainmanName';
  strSql := strSql + '    ,strTelNumber';
  strSql := strSql + '    ,strRemark ';
  strSql := strSql + '    ,nID  ';
  strSql := strSql + '    ,dtCreateTime ';
  strSql := strSql + '    ,case WHEN  ';
  strSql := strSql + '    FingerPrint1 IS NULL THEN 0 ';
  strSql := strSql + '    ELSE 1 END AS FG1ISNULL  ';
  strSql := strSql + '    ,CASE WHEN ';
  strSql := strSql + '    Picture IS NULL THEN 0 ';
  strSql := strSql + '    ELSE 1 END AS PICISNULL ';
  strSql := strSql + '    ,CASE WHEN ';
  strSql := strSql + '     FingerPrint2 IS NULL THEN 0 ';
  strSql := strSql + '     ELSE 1 END AS FG2ISNULL ';
  strSql := strSql + '     ,nTrainmanState ';
  strSql := strSql + '     ,nPostID ';
  strSql := strSql + '     ,strWorkShopGUID ';
  strSql := strSql + '     ,strGuideGroupGUID  ';
  strSql := strSql + '     ,strMobileNumber ';
  strSql := strSql + '     ,strAddress ';
  strSql := strSql + '     ,strTrainmanGUID  ';
  strSql := strSql + '     ,nDriverType ';
  strSql := strSql + '     ,bIsKey  ';
  strSql := strSql + '     ,dtRuZhiTime ';
  strSql := strSql + '     ,dtJiuZhiTime ';
  strSql := strSql + '     ,nDriverLevel ';
  strSql := strSql + '     ,strABCD  ';
  strSql := strSql + '     ,nKeHuoID ';
  strSql := strSql + '     ,strTrainJiaoluGUID ';
  strSql := strSql + '     ,dtLastEndWorkTime ';
  strSql := strSql + '    ,nDeleteState   ';
  strSql := strSql + '     ,strTrainJiaoluName ';
  strSql := strSql + '     ,strGuideGroupName ';
  strSql := strSql + '     ,strWorkShopName';
  strSql := strSql + '     ,strAreaGUID  ';
  strSql := strSql + '     ,strAreaName ';
  strSql := strSql + '     ,strJWDNumber';
  strSql := strSql + '     ,strJP ';
  strSql := strSql + '     ,strTrainmanJiaoluGUID ';
  strSql := strSql + '     ,dtLastInRoomTime ';
  strSql := strSql + '     ,dtLastOutRoomTime ';
  strSql := strSql + ' FROM ';
  strSql := strSql + '(select ROW_NUMBER() over(order by nid) as rownumber,* from VIEW_Org_Trainman %s) A %s';

  {$region '组合查询条件'}
  sqlCondition :=  ' where 1=1 ';
  with QueryTrainman do
  begin
    if strTrainmanNumber <> '' then
    begin
      sqlCondition := sqlCondition + ' and strTrainmanNumber = %s';
      sqlCondition := Format(sqlCondition,[QuotedStr(strTrainmanNumber)])
    end;

     if (strAreaGUID <> '') then
    begin
      sqlCondition := sqlCondition + ' and strAreaGUID = %s';
      sqlCondition := Format(sqlCondition,[QuotedStr(strAreaGUID)]) ;
      if (strWorkShopGUID <> '') then
      begin
        sqlCondition := sqlCondition + ' and strWorkShopGUID = %s';
        sqlCondition := Format(sqlCondition,[QuotedStr(strWorkShopGUID)])
      end;
      if (strGuideGroupGUID <> '') then
      begin
        sqlCondition := sqlCondition + ' and strGuideGroupGUID = %s';
        sqlCondition := Format(sqlCondition,[QuotedStr(strGuideGroupGUID)]);
      end;
      if (strTrainJiaoluGUID <> '') then
      begin
        sqlCondition := sqlCondition + ' and strTrainJiaoluGUID = %s';
        sqlCondition := Format(sqlCondition,[QuotedStr(strTrainJiaoluGUID)]);    
      end;
    end;
    if strTrainmanName <> '' then
    begin
      sqlCondition := sqlCondition + ' and strTrainmanName like %s';
      sqlCondition := Format(sqlCondition,[QuotedStr('%'+strTrainmanName+'%')])    
    end;
    if (nFingerCount >= 0) then
    begin
      if nFingerCount = 0 then
      begin
        sqlCondition := sqlCondition + ' and ((FingerPrint1 is null) and (FingerPrint2 is null))';
      end;
      if nFingerCount = 1 then
      begin
        sqlCondition := sqlCondition + ' and (((FingerPrint1 is null) and not (FingerPrint2 is null)) or  ((FingerPrint2 is null) and not (FingerPrint1 is null)))';
      end;
      if nFingerCount = 2 then
      begin
        sqlCondition := sqlCondition + ' and (not(FingerPrint1 is null) and not(FingerPrint2 is null)) ';
      end;
    end;
    if (nPhotoCount >= 0) then
    begin
      if nPhotoCount = 0 then
      begin
        sqlCondition := sqlCondition + ' and (picture is null)';
      end;
      if nPhotoCount > 0 then
      begin
        sqlCondition := sqlCondition + ' and not (picture is null)';
      end;
    end;
  end;

  {
    strSql := 'select top 15 strTrainmanGUID,strTrainmanNumber,strTrainmanName,nPostID,nKeHuoID,' +
          'bIsKey,strABCD,strMobileNumber,nTrainmanState from '+
          '(select ROW_NUMBER() over(order by nid) as rownumber,* from TAB_Org_Trainman) A where 1=1';
  strSql := strSql + strWhere + ' and RowNumber >' + IntToStr(15 *(PageIndex -1)) + ' order by strTrainmanNumber';}

  {$endregion '组合查询条件'}
  sqlPageCondition :=  ' where RowNumber >' + IntToStr(100 *(PageIndex -1));
  strSql := Format(strSql,[sqlCondition,sqlPageCondition]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      SetLength(TrainmanArray,RecordCount);
      i := 0;
      while not eof do
      begin
        ADOQueryToData(TrainmanArray[i],adoQuery,True);
        inc(i);
        next;
      end;
      
      Close;
      SQL.Text := Format('select count(nid) from VIEW_Org_Trainman  %s' ,[sqlCondition]);
      Open;
      if not eof then nTotalCount := adoQuery.Fields[0].AsInteger;
      
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainman.SetTrainmanState(TrainmanGUID: string;
  TrainmanState: TRsTrainmanState);
var

  strSql : String;
  adoQuery : TADOQuery;
begin
  strSql := 'update TAB_Org_Trainman set nTrainmanState = %d where strTrainmanGUID=%s ';


  strSql := Format(strSql,[Ord(TrainmanState),QuotedStr(TrainmanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

class procedure TRsDBTrainman.ADOQueryToData(var Trainman: RRsTrainman;
  ADOQuery: TADOQuery;NeedPicture : boolean = false);
var
  StreamObject : TMemoryStream;
begin
  Trainman.strTrainmanGUID := adoQuery.FieldByName('strTrainmanGUID').AsString;
  Trainman.strTrainmanNumber := adoQuery.FieldByName('strTrainmanNumber').AsString;
  Trainman.strTrainmanName := adoQuery.FieldByName('strTrainmanName').AsString;
  Trainman.nPostID := TRsPost(adoQuery.FieldByName('nPostID').asInteger);
  Trainman.strAreaGUID := ADOQuery.FieldByName('strAreaGUID').AsString;
  Trainman.strWorkShopGUID := adoQuery.FieldByName('strWorkShopGUID').AsString;
  Trainman.strWorkShopName := adoQuery.FieldByName('strWorkShopName').AsString;
  Trainman.strGuideGroupGUID := adoQuery.FieldByName('strGuideGroupGUID').AsString;
  Trainman.strGuideGroupName := adoQuery.FieldByName('strGuideGroupName').AsString;
  Trainman.strTelNumber := adoQuery.FieldByName('strTelNumber').AsString;
  Trainman.strMobileNumber := adoQuery.FieldByName('strMobileNumber').AsString;
  Trainman.strAdddress := adoQuery.FieldByName('strAddress').AsString;
  Trainman.nDriverType := TRsDriverType(adoQuery.FieldByName('nDriverType').asInteger);
  Trainman.bIsKey := adoQuery.FieldByName('bIsKey').AsInteger;
  Trainman.dtRuZhiTime := adoQuery.FieldByName('dtRuZhiTime').AsDateTime;
  Trainman.dtJiuZhiTime := adoQuery.FieldByName('dtJiuZhiTime').AsDateTime;
  Trainman.nDriverLevel := adoQuery.FieldByName('nDriverLevel').AsInteger;
  Trainman.strABCD := adoQuery.FieldByName('strABCD').AsString;
  Trainman.strRemark := adoQuery.FieldByName('strRemark').AsString;
  if adoQuery.FieldByName('nKeHuoID').AsString = '' then
    Trainman.nKeHuoID := khNone
  else
    Trainman.nKeHuoID :=  TRsKehuo(adoQuery.FieldByName('nKeHuoID').AsInteger);
  Trainman.strRemark := adoQuery.FieldByName('strRemark').AsString;
  Trainman.strTrainJiaoluGUID := adoQuery.FieldByName('strTrainJiaoluGUID').AsString;
  Trainman.strTrainmanJiaoluGUID := adoQuery.FieldByName('strTrainmanJiaoluGUID').AsString;
  Trainman.strTrainJiaoluName := adoQuery.FieldByName('strTrainJiaoluName').AsString;
  Trainman.dtLastEndworkTime := adoQuery.FieldByName('dtLastEndworkTime').AsDateTime;

  Trainman.dtCreateTime := adoQuery.FieldByName('dtLastEndworkTime').AsDateTime;
  Trainman.nTrainmanState := TRsTrainmanState(adoQuery.FieldByName('nTrainmanState').asInteger);
  trainman.nID := adoQuery.FieldByName('nID').asInteger;
  if not ADOQuery.FieldByName('dtLastInRoomTime').IsNull then
    Trainman.dtLastInRoomTime := ADOQuery.FieldByName('dtLastInRoomTime').AsDateTime;
  if not ADOQuery.FieldByName('dtLastOutRoomTime').IsNull then
    Trainman.dtLastOutRoomTime := ADOQuery.FieldByName('dtLastOutRoomTime').AsDateTime;

  if ADOQuery.Fields.FindField('strJP') <> nil then
    trainman.strJP := adoQuery.FieldByName('strJP').AsString;
  StreamObject := TMemoryStream.Create;
  try
    {读取指纹1}
    if Assigned(ADOQuery.FindField('FingerPrint1')) then
    begin
      if ADOQuery.FieldByName('FingerPrint1').IsNull = False then
      begin
        (ADOQuery.FieldByName('FingerPrint1') As TBlobField).SaveToStream(StreamObject);
        Trainman.FingerPrint1 := StreamToTemplateOleVariant(StreamObject);
        StreamObject.Clear;
      end;
    end;
    if Assigned(ADOQuery.FindField('FG1ISNULL')) then
    begin
      if ADOQuery.FieldByName('FG1ISNULL').IsNull = False then //不为空
      begin
        Trainman.nFingerPrint1_Null := 1;
      end
      else
      begin
        Trainman.nFingerPrint1_Null := 0;
      end;
    end;

    {读取指纹2}
    if Assigned(ADOQuery.FindField('FingerPrint2')) then
    begin
      if ADOQuery.FieldByName('FingerPrint2').IsNull = False then
      begin
        (ADOQuery.FieldByName('FingerPrint2') As TBlobField).SaveToStream(StreamObject);
        Trainman.FingerPrint2 := StreamToTemplateOleVariant(StreamObject);
        StreamObject.Clear;
      end;
    end;
    if Assigned(ADOQuery.FindField('FG2ISNULL')) then
    begin
      if ADOQuery.FieldByName('FG2ISNULL').IsNull = False then //不为空
      begin
        Trainman.nFingerPrint2_Null := 1;
      end
      else
      begin
        Trainman.nFingerPrint2_Null := 0;
      end;
    end;

    if NeedPicture then
    begin
    {读取照片}
      if Assigned(ADOQuery.FindField('Picture')) then
      begin
        if ADOQuery.FieldByName('Picture').IsNull = False then
        begin
          (ADOQuery.FieldByName('Picture') As TBlobField).SaveToStream(StreamObject);
          Trainman.Picture := StreamToTemplateOleVariant(StreamObject);
          StreamObject.Clear;
        end;
      end;
      if Assigned(ADOQuery.FindField('PICISNULL')) then
      begin
        if ADOQuery.FieldByName('PICISNULL').IsNull = False then //不为空
        begin
          Trainman.nPicture_Null := 1;
        end
        else
        begin
          Trainman.nPicture_Null := 0;
        end;
      end;

    end;
  finally
    StreamObject.Free;
  end;
end;

procedure TRsDBTrainman.ADOQueryToTrainmanLeaveCount(ADOQuery: TADOQuery;
  var LeaveCount: RRsTrainmanLeaveCount);
var
  strTypeName:string;
begin
  strTypeName := ADOQuery.FieldByName('strLeaveTypeName').AsString;
  if strTypeName = '丧假' then
    Inc(LeaveCount.nBereavement)
  else if strTypeName = '病假' then
    Inc(LeaveCount.nSick)
  else if strTypeName = '探亲假' then
    Inc(LeaveCount.nVisit)
  else if strTypeName = '单牌' then
    Inc(LeaveCount.nSingle)
  else if strTypeName = '年休假' then
    Inc(LeaveCount.nAnnual)
  else if strTypeName = '培训' then
    Inc(LeaveCount.nTrain)
  else if strTypeName = '婚假' then
    Inc(LeaveCount.nMarriage)
  else if strTypeName = '事假' then
    Inc(LeaveCount.nCasual )
  else
    Inc(LeaveCount.nOther);
end;



procedure TRsDBTrainman.ADOQueryToTrainmanStateCount(ADOQuery: TADOQuery;
  var TrainmanStateCount: RTrainmanStateCount);
var
  iType : TRsTrainmanState ;
begin
  with  ADOQuery do
  begin
    iType :=  TRsTrainmanState(FieldByName('nTrainmanState').AsInteger) ;
    case iType of
      tsUnRuning: Inc(TrainmanStateCount.nUnRuning);
      tsReady: Inc(TrainmanStateCount.nReady);
      tsNormal:Inc(TrainmanStateCount.nNormal);
      tsPlaning:Inc(TrainmanStateCount.nPlaning);
      tsInRoom:Inc(TrainmanStateCount.nInRoom);
      tsOutRoom:Inc(TrainmanStateCount.nOutRoom);
      tsRuning: Inc(TrainmanStateCount.nRuning);
      tsNil: Inc(TrainmanStateCount.nNil);
    end;
  end;
end;

function TRsDBTrainman.ConvertAllTrainmanStateToNull(
  WorkShopGUID: string): Boolean;
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  Result := False ;
  strSql := 'update TAB_Org_Trainman set nTrainmanState = %d  where nTrainmanState <> 7 and strWorkShopGUID = %s order by strTrainmanNumber';
  strSql := Format(strSql, [Ord(tsNil),QuotedStr(WorkShopGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      if (ExecSQL = 0) then
      begin
        raise exception.Create('转换人员状态错误');
        exit;
      end;
      Result := True;
    end;
  finally
    adoQuery.Free;
  end;
end;




function TRsDBTrainman.ConvertTrainmanStateToNull(
  TrainmanNumber: string): Boolean;
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  Result := False ;
  strSql := 'update TAB_Org_Trainman set nTrainmanState =%d  where strTrainmanGUID = %s';
  strSql := Format(strSql, [Ord(tsNil),QuotedStr(TrainmanNumber)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      if (ExecSQL = 0) then
      begin
        raise exception.Create('转换人员状态错误');
        exit;
      end;
      Result := True;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainman.UpdateFingerLibGUID();
var
  adoQuery: TADOQuery;
  strSQL: string;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := m_ADOConnection;
    strSQL := 'select * from TAB_System_Config where strSection=''SysConfig'' and strIdent=''ServerFingerLibGUID''';
    adoQuery.SQL.Text := strSQL;
    adoQuery.Open;
    if adoQuery.RecordCount = 0 then
    begin
      adoQuery.Append;
      adoQuery.FieldByName('strSection').AsString := 'SysConfig';
      adoQuery.FieldByName('strIdent').AsString := 'ServerFingerLibGUID';
      adoQuery.FieldByName('strValue').AsString := NewGUID;
    end else begin
      adoQuery.Edit;
      adoQuery.FieldByName('strValue').AsString := NewGUID;
    end;
    adoQuery.Post;
  finally
    adoQuery.Free;
  end;
end;

end.
