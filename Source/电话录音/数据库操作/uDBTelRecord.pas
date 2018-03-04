unit uDBTelRecord;

interface

uses
  utfsystem,ADODB,db,uTelRecord,SysUtils;
type


  {数据库查询电话录音记录类}
  TDBTelRecord = class(TDBOperate)
  public
    {功能：查询}
    procedure Query(TelRecordQueryCond:TTelRecordQueryCond;TelRecordList:TTelRecordList);
    {功能：增加一条记录}
    procedure Insert(TelRecord: TTelRecord);
  private
    procedure AdoToData(ADOQuery: TADOQuery;TelRecord: TTelRecord);
    procedure DataToAdo(ADOQuery: TADOQuery;TelRecord: TTelRecord);
  end;

implementation

{ TDBTelRecord }

procedure TDBTelRecord.Insert(TelRecord: TTelRecord);
var
  strSql : string ;
  adoQuery: TADOQuery ;
begin
  adoQuery := NewADOQuery;
  try
    with adoQuery do
    begin
      strSql := 'select * from TAB_Record_TelCall where 1 = 2 ';
      Sql.Text := strSql;
      Open;
      Append;
      DataToAdo(adoQuery,TelRecord);
      Post;
    end;
  finally
    adoQuery.Free
  end;
end;

procedure TDBTelRecord.AdoToData(ADOQuery: TADOQuery; TelRecord: TTelRecord);
begin
  with  TelRecord do
  begin
    nId :=   ADOQuery.FieldByName('nId').AsInteger ;
    strGUID := ADOQuery.FieldByName('strGUID').AsString ;
    strDestTel:= ADOQuery.FieldByName('strDestTel').AsString ;
    strUserNumber := ADOQuery.FieldByName('strUserNumber').AsString ;
    strUserName := ADOQuery.FieldByName('strUserName').AsString ;
    strFileName := ADOQuery.FieldByName('strFileName').AsString ;
    dtCreateTime := ADOQuery.FieldByName('dtCreateTime').AsDateTime;
    dtStartTime := ADOQuery.FieldByName('dtStartTime').AsDateTime ;
    dtEndTime := ADOQuery.FieldByName('dtEndTime').AsDateTime ;
    nCallDirection := ADOQuery.FieldByName('nCallDirection').AsInteger ;

    if ADOQuery.FieldByName('bIsDialed').AsInteger = 1 then
      bIsDialed :=   true
    else
      bIsDialed := false ;
    strRemark := ADOQuery.FieldByName('strRemark').AsString ;
  end;
end;

procedure TDBTelRecord.DataToAdo(ADOQuery: TADOQuery; TelRecord: TTelRecord);
begin
  with  TelRecord do
  begin
    //ADOQuery.FieldByName('nId').AsInteger := nId ;
    ADOQuery.FieldByName('strGUID').AsString := strGUID ;
    ADOQuery.FieldByName('strDestTel').AsString:= strDestTel ;
    ADOQuery.FieldByName('strUserNumber').AsString := strUserNumber ;
    ADOQuery.FieldByName('strUserName').AsString := strUserName ;
    ADOQuery.FieldByName('strFileName').AsString := strFileName ;
    ADOQuery.FieldByName('dtCreateTime').AsDateTime := dtCreateTime;
    ADOQuery.FieldByName('dtStartTime').AsDateTime := dtStartTime ;
    ADOQuery.FieldByName('dtEndTime').AsDateTime := dtEndTime ;
    ADOQuery.FieldByName('nCallDirection').AsInteger := nCallDirection ;
    ADOQuery.FieldByName('bIsDialed').AsInteger := ord( bIsDialed ) ;
    ADOQuery.FieldByName('strRemark').AsString := strRemark ;
  end;
end;

procedure TDBTelRecord.Query(TelRecordQueryCond:TTelRecordQueryCond;TelRecordList:TTelRecordList);
var
  ADOQuery: TADOQuery;
  strSQL: string;
  TelRecord: TTelRecord ;
begin
  ADOQuery := NewADOQuery;
  try
    strSQL := 'Select * from TAB_Record_TelCall where ( dtCreateTime between %s and %s ) and 1 =1 ';
    strSQL := Format(strSQL,[
      QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',TelRecordQueryCond.StartDate)),
      QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',TelRecordQueryCond.EndDate))]);


    if Trim(TelRecordQueryCond.UserNumber) <> '' then
    begin
      strSQL := strSQL + ' and strUserNumber =  '  + QuotedStr(TelRecordQueryCond.UserNumber) ;
    end;

    if TelRecordQueryCond.CallDirection <> -1 then
    begin
      strSQL := strSQL + ' and nCallDirection = ' + inttostr(TelRecordQueryCond.CallDirection) ;
    end;


    if TelRecordQueryCond.DailedType <> -1 then
    begin
      strSQL := strSQL + ' and bIsDialed = ' + inttostr(TelRecordQueryCond.DailedType) ;
    end;

    strSQL := strSQL + ' order by dtCreateTime   ';

    ADOQuery.SQL.Text := strSQL ;
    ADOQuery.Open();

    while  not ADOQuery.Eof  do
    begin
      TelRecord:= TTelRecord.Create;
      AdoToData(ADOQuery,TelRecord);
      TelRecordList.Add(TelRecord);
      ADOQuery.Next;
    end;
    

  finally
    ADOQuery.free;
  end;

end;

end.
