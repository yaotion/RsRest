unit uDBLocalTrainman;

interface

uses
  Classes,DB,Variants,ZKFPEngXUtils,
  ADODB,SysUtils,utfsystem,uSaftyEnum,uTrainman;

type

  TRsDBLocalTrainman = class(TDBOperate)
  public
    {功能:获取人员特征码}
    function GetTrainmanSignature():string;
    {功能:修改人员特征码}
    procedure SetTrainmanSignature(strSignature:string);
    {功能:获取指纹特征码}
    function GetFingerSignature():string;
    {功能:修改指纹特征码}
    procedure SetFingerSignature(strSignature:string);
    {功能:同步人员信息}
    procedure SyncTrainman(trainman:RRsTrainman);

    //获取乘务员的车间名字
    function GetTrainmanWorkShopName(TrainmanGUID : string;out WorkShopName : string) : boolean;
    //获取指定ID的乘务员的信息
    function GetTrainmanByNumber(TrainmanNumber : string;out Trainman : RRsTrainman) : boolean;
    //根据GUID获取乘务员信息
    function GetTrainman(TrainmanGUID : string;out Trainman : RRsTrainman) : boolean;
    //功能：删除乘务员
    procedure DeleteTrainman(TrainmanGUID: string);
    //功能：添加乘务员
    procedure AddTrainman(Trainman : RRsTrainman);
        //功能：修改乘务员
    procedure UpdateTrainman(Trainman : RRsTrainman) ;
    //是否存在非GUID的司机工号
    function ExistNumber(TrainmanGUID,TrainmanNumber : string) : boolean;
        //功能：查询司机信息
    procedure QueryTrainmans(QueryTrainman:RRsQueryTrainman;
      out TrainmanArray:TRsTrainmanArray);
          //验证司机工号是否存在
    function ExistTrainmanByNumber(TrainmanNumber : string):boolean;
          //验证司机工号是否存在
    function ExistTrainman(WorkShopGUID,TrainmanName : string;out Trainman : RRsTrainman):boolean;
        //获取指定ID的乘务员的信息
    function GetTrainmanByID(ADOConn:TADOConnection;ID : integer;out Trainman : RRsTrainman) : boolean;
    //
    function GetTrainmanMaxID(out ID:Integer):Boolean;
      //获取乘务员简要信息
    class procedure GetTrainmansBrief(ADOConn:TADOConnection; out TrainmanArray:TRsTrainmanArray);

        //获取空闲人员
    function GetPopupTrainmans(WorkShopGUID, strKeyName: string; PageIndex: integer; out TrainmanArray: TRsTrainmanArray): integer;
  protected
    procedure ADOQueryToData(var Trainman:RRsTrainman;ADOQuery : TADOQuery;NeedPicture : boolean = false);
    procedure DataToADOQuery(Trainman : RRsTrainman;ADOQuery : TADOQuery;NeedPicture : boolean=false);
  end;






implementation



{ TRsDBLocalTrainman }

procedure TRsDBLocalTrainman.DataToADOQuery(Trainman: RRsTrainman;
  ADOQuery: TADOQuery; NeedPicture: boolean);
var
  StreamObject : TMemoryStream;
begin
  //ADOQuery.FieldByName('nID').AsInteger := Trainman.nID ;
  adoQuery.FieldByName('strTrainmanGUID').AsString := Trainman.strTrainmanGUID;
  adoQuery.FieldByName('strTrainmanNumber').AsString := Trainman.strTrainmanNumber;
  adoQuery.FieldByName('strTrainmanName').AsString := Trainman.strTrainmanName;
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

procedure TRsDBLocalTrainman.DeleteTrainman(TrainmanGUID: string);
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
end;

function TRsDBLocalTrainman.ExistNumber(TrainmanGUID,
  TrainmanNumber: string): boolean;
var
  strSql : String;
  adoQuery : TADOQuery;
begin
  Result := False ;
  strSql := 'Select count(*) From tab_Org_Trainman Where strTrainmanNumber = %s and strTrainmanGUID <> %s';
  strSql := Format(strSql, [QuotedStr(TrainmanNumber),QuotedStr(TrainmanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := m_ADOConnection;
    adoQuery.SQL.Text := strSql;
    adoQuery.ParamCheck := False ;
    adoQuery.Open;
    Result := adoQuery.Fields[0].AsInteger > 0;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBLocalTrainman.ExistTrainman(WorkShopGUID,
  TrainmanName: string;out Trainman : RRsTrainman): boolean;
var
  strSql:string;
  query:TADOQuery;
begin
  result := False;
  query := NewADOQuery;
  try

    strSql := 'select strTrainmanGUID,strTrainmanNumber,strTrainmanName,nPostID,nKeHuoID,' +
            'bIsKey,strABCD,strMobileNumber,nTrainmanState,TAB_Org_Trainman.strWorkShopGUID,TAB_Org_WorkShop.strWorkShopName from TAB_Org_Trainman ' +
            'left join TAB_Org_WorkShop on TAB_Org_WorkShop.strWorkShopGUID=TAB_Org_Trainman.strWorkShopGUID ' +
            'where strTrainmanName =:strTrainmanName and TAB_Org_Trainman.strWorkShopGUID =:strWorkShopGUID';

    query.SQL.Text := strSql ;
    query.Parameters.ParamByName('strTrainmanName').Value := TrainmanName;
    query.Parameters.ParamByName('strWorkShopGUID').Value := WorkShopGUID;
    query.Open;
    if query.RecordCount > 0 then
    begin
        Trainman.strTrainmanGUID := query.FieldByName('strTrainmanGUID').AsString;
        Trainman.strTrainmanNumber := query.FieldByName('strTrainmanNumber').AsString;
        Trainman.strTrainmanName := query.FieldByName('strTrainmanName').AsString;
        Trainman.nPostID := TRsPost(query.FieldByName('nPostID').asInteger);
        if query.FieldByName('nKeHuoID').AsString = '' then
          Trainman.nKeHuoID := khNone
        else
          Trainman.nKeHuoID :=  TRsKehuo(query.FieldByName('nKeHuoID').AsInteger);
        Trainman.bIsKey := query.FieldByName('bIsKey').AsInteger;
        Trainman.strABCD := query.FieldByName('strABCD').AsString;
        Trainman.strMobileNumber := query.FieldByName('strMobileNumber').AsString;
        Trainman.nTrainmanState := TRsTrainmanState(query.FieldByName('nTrainmanState').asInteger);
        Trainman.strWorkShopGUID := query.FieldByName('strWorkShopGUID').AsString;
        Trainman.strWorkShopName := query.FieldByName('strWorkShopName').AsString;

      Result := True;
    end;
  finally
    query.Free;
  end;

end;

function TRsDBLocalTrainman.ExistTrainmanByNumber( TrainmanNumber: string): boolean;
var
  strSql : String;
  adoQuery : TADOQuery;
begin
  strSql := 'Select count(*) From tab_Org_Trainman Where strTrainmanNumber = %s';
  strSql := Format(strSql, [QuotedStr(TrainmanNumber)]);
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := m_ADOConnection;
    adoQuery.ParamCheck := False ;
    adoQuery.SQL.Text := strSql;
    adoQuery.Open;
    Result := adoQuery.Fields[0].AsInteger > 0;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBLocalTrainman.GetTrainmanSignature(): string;
var
  query:TADOQuery;
begin
  result := '';
  query := NewADOQuery;
  try
    query.SQL.Text := 'select * from tab_Signature where strName =:strName';
    query.Parameters.ParamByName('strName').Value := 'TrainmanInfo';
    query.Open;
    if query.RecordCount = 0 then Exit;
    result := query.FieldByName('strSignature').Value ;
  finally
    query.Free;
  end;
end;

function TRsDBLocalTrainman.GetTrainmanWorkShopName(TrainmanGUID: string;
  out WorkShopName: string): boolean;
var
  query:TADOQuery;
begin
  result := False;
  query := NewADOQuery;
  try
    query.SQL.Text := 'select strTrainmanGUID,strWorkShopName from TAB_Org_Trainman '  +
            'left join TAB_Org_WorkShop on TAB_Org_WorkShop.strWorkShopGUID=TAB_Org_Trainman.strWorkShopGUID ' +
            ' WHERE strTrainmanGUID =:strTrainmanGUID ' ;
    query.Parameters.ParamByName('strTrainmanGUID').Value := TrainmanGUID;
    query.Open;
    if query.RecordCount = 0 then Exit;
    WorkShopName := query.FieldByName('strWorkShopName').AsString ;
    Result := True ;
  finally
    query.Free;
  end;
end;

function  TRsDBLocalTrainman.GetFingerSignature():string;
var
  query:TADOQuery;
begin
  result := '';
  query := NewADOQuery;
  try
    query.SQL.Text := 'select * from tab_Signature where strName =:strName';
    query.Parameters.ParamByName('strName').Value := 'FingerInfo';
    query.Open;
    if query.RecordCount = 0 then Exit;
    result := query.FieldByName('strSignature').Value ;
  finally
    query.Free;
  end;
end;

function TRsDBLocalTrainman.GetPopupTrainmans(WorkShopGUID, strKeyName: string;
  PageIndex: integer; out TrainmanArray: TRsTrainmanArray): integer;
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
  strSql := 'select strTrainmanGUID,strTrainmanNumber,strTrainmanName,nPostID,nKeHuoID,' +
            'bIsKey,strABCD,strMobileNumber,nTrainmanState,TAB_Org_Trainman.strWorkShopGUID,TAB_Org_WorkShop.strWorkShopName from TAB_Org_Trainman ' +
            'left join TAB_Org_WorkShop on TAB_Org_WorkShop.strWorkShopGUID=TAB_Org_Trainman.strWorkShopGUID ' +
            'where 1=1';
  strSql := strSql + strWhere + ' order by strTrainmanNumber';

  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      MoveBy((PageIndex - 1) * 10);
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
        TrainmanArray[i].strWorkShopGUID := adoQuery.FieldByName('strWorkShopGUID').AsString;
        TrainmanArray[i].strWorkShopName := adoQuery.FieldByName('strWorkShopName').AsString;
        inc(i);
        if i = 10 then break;
        next;
      end;

      Close;
      SQL.Text := 'select count(*) from TAB_Org_Trainman where 1=1' + strWhere;
      Open;
      if not eof then result := adoQuery.Fields[0].AsInteger;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBLocalTrainman.GetTrainman(TrainmanGUID: string;
  out Trainman: RRsTrainman): boolean;
var
  strSql : String;
  adoQuery : TADOQuery;
begin
  Result := False;
  strSql := 'Select Top 1 * From tab_Org_Trainman Where strTrainmanGUID = %s';
  strSql := Format(strSql, [QuotedStr(TrainmanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := m_ADOConnection;
    adoQuery.ParamCheck := False ;
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

function TRsDBLocalTrainman.GetTrainmanByID(ADOConn: TADOConnection;
  ID: integer; out Trainman: RRsTrainman): boolean;
var
  strSql : String;
  adoQuery : TADOQuery;
begin
  Result := False;
  strSql := 'Select Top 1 * From tab_Org_Trainman Where nID = %d';
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



function TRsDBLocalTrainman.GetTrainmanByNumber(TrainmanNumber: string;
  out Trainman: RRsTrainman): boolean;
var
  strSql : String;
  adoQuery : TADOQuery;
begin
  Result := False;
  strSql := 'Select Top 1 * From tab_Org_Trainman Where strTrainmanNumber = %s';
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



function TRsDBLocalTrainman.GetTrainmanMaxID(out ID: Integer): Boolean;
var
  strSql : String;
  adoQuery : TADOQuery;
begin
  Result := False;
  strSql := 'SELECT max(nid) as maxid From tab_Org_Trainman ';
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := m_ADOConnection;
    adoQuery.SQL.Text := strSql;
    adoQuery.Open;
    if adoQuery.RecordCount > 0 then
    begin
      if adoQuery.FieldByName('maxid').AsString = '' then
        ID := 1
      else
        ID := adoQuery.FieldByName('maxid').AsInteger + 1;
      Result := True;
    end;
  finally
    adoQuery.Free;
  end;
end;

class procedure TRsDBLocalTrainman.GetTrainmansBrief(ADOConn: TADOConnection;
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
      ParamCheck := False ;
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

procedure TRsDBLocalTrainman.QueryTrainmans(QueryTrainman: RRsQueryTrainman;
  out TrainmanArray: TRsTrainmanArray);
{功能:根据ID获取乘务员信息}
var
  i : integer;
  strSql,sqlCondition : String;
  adoQuery : TADOQuery;
begin
  strSql := 'Select * From tab_Org_Trainman %s order by strTrainmanNumber ';

  {$region '组合查询条件'}
  sqlCondition :=  ' where 1=1 ';
  with QueryTrainman do
  begin
    if strTrainmanNumber <> '' then
    begin
      sqlCondition := sqlCondition + ' and strTrainmanNumber = %s';
      sqlCondition := Format(sqlCondition,[QuotedStr(strTrainmanNumber)])
    end;

    {
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
    }
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
        sqlCondition := sqlCondition + ' and (nPostID is null)';
      end;
      if nPhotoCount > 0 then
      begin
        sqlCondition := sqlCondition + ' and not (nPostID is null)';
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

procedure TRsDBLocalTrainman.SetTrainmanSignature(strSignature: string);
var
  query:TADOQuery;
begin
  query:= NewADOQuery;
  try
    query.SQL.Text := 'select * from tab_Signature where strName =:strName';
    query.Parameters.ParamByName('strName').Value := 'TrainmanInfo';
    query.Open;
    if query.RecordCount = 0 then
    begin
      query.Append;
    end
    else
    begin
      query.Edit;
    end;
    query.FieldByName('strName').Value := 'TrainmanInfo';
    query.FieldByName('strSignature').Value := strSignature;
    query.Post;
  finally
    query.Free;
  end;
end;

procedure TRsDBLocalTrainman.SetFingerSignature(strSignature:string);
var
  query:TADOQuery;
begin
  query:= NewADOQuery;
  try
    query.SQL.Text := 'select * from tab_Signature where strName =:strName';
    query.Parameters.ParamByName('strName').Value := 'FingerInfo';
    query.Open;
    if query.RecordCount = 0 then
    begin
      query.Append;
    end
    else
    begin
      query.Edit;
    end;
    query.FieldByName('strName').Value := 'FingerInfo';
    query.FieldByName('strSignature').Value := strSignature;
    query.Post;
  finally
    query.Free;
  end;
end;

procedure TRsDBLocalTrainman.SyncTrainman(trainman:RRsTrainman);
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
        Append;
      end
      else
      begin
        Edit;
      end;
      DataToADOQuery(Trainman,adoQuery,true);
      Post;
    end;
  finally
    adoQuery.Free;
  end;
end;
procedure TRsDBLocalTrainman.UpdateTrainman(Trainman: RRsTrainman);
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

end;

procedure TRsDBLocalTrainman.AddTrainman(Trainman: RRsTrainman);
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
      ParamCheck := False ;
      Sql.Text := strSql;
      Open;
      Append;
      DataToADOQuery(Trainman,adoQuery,true);
      Post;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBLocalTrainman.ADOQueryToData(var Trainman: RRsTrainman;
  ADOQuery: TADOQuery;NeedPicture : boolean = false);
var
  StreamObject : TMemoryStream;
begin
  Trainman.strTrainmanGUID := adoQuery.FieldByName('strTrainmanGUID').AsString;
  Trainman.strTrainmanNumber := adoQuery.FieldByName('strTrainmanNumber').AsString;
  Trainman.strTrainmanName := adoQuery.FieldByName('strTrainmanName').AsString;
  Trainman.nPostID := TRsPost(adoQuery.FieldByName('nPostID').asInteger);

  Trainman.strWorkShopGUID := adoQuery.FieldByName('strWorkShopGUID').AsString;
//  Trainman.strWorkShopName := adoQuery.FieldByName('strWorkShopName').AsString;
  Trainman.strGuideGroupGUID := adoQuery.FieldByName('strGuideGroupGUID').AsString;
 // Trainman.strGuideGroupName := adoQuery.FieldByName('strGuideGroupName').AsString;
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
//  Trainman.strTrainJiaoluName := adoQuery.FieldByName('strTrainJiaoluName').AsString;
  Trainman.dtLastEndworkTime := adoQuery.FieldByName('dtLastEndworkTime').AsDateTime;

  Trainman.dtCreateTime := adoQuery.FieldByName('dtLastEndworkTime').AsDateTime;
  Trainman.nTrainmanState := TRsTrainmanState(adoQuery.FieldByName('nTrainmanState').asInteger);
  trainman.nID := adoQuery.FieldByName('nID').asInteger;
  if ADOQuery.Fields.FindField('strJP') <> nil then
    trainman.strJP := adoQuery.FieldByName('strJP').AsString;
  StreamObject := TMemoryStream.Create;
  try
    {读取指纹1}
    if ADOQuery.FieldByName('FingerPrint1').IsNull = False then
    begin
      (ADOQuery.FieldByName('FingerPrint1') As TBlobField).SaveToStream(StreamObject);
      Trainman.FingerPrint1 := StreamToTemplateOleVariant(StreamObject);
      StreamObject.Clear;
    end;

    {读取指纹2}
    if ADOQuery.FieldByName('FingerPrint2').IsNull = False then
    begin
      (ADOQuery.FieldByName('FingerPrint2') As TBlobField).SaveToStream(StreamObject);
      Trainman.FingerPrint2 := StreamToTemplateOleVariant(StreamObject);
      StreamObject.Clear;
    end;

    if NeedPicture then
    begin
    {读取照片}
      if ADOQuery.FieldByName('Picture').IsNull = False then
      begin
        (ADOQuery.FieldByName('Picture') As TBlobField).SaveToStream(StreamObject);
        Trainman.Picture := StreamToTemplateOleVariant(StreamObject);
        StreamObject.Clear;
      end;
    end;
  finally
    StreamObject.Free;
  end;
end;


end.
