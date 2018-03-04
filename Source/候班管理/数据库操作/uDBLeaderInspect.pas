unit uDBLeaderInspect;

interface

uses
  Classes,DB,Variants,
  ADODB,SysUtils,uLeaderExam,utfsystem;
type
  //干部查岗数据库操作
  TRsDBLeaderInspect = class(TDBOperate)
  public
      //获取干部检查列表信息
    procedure  GetLeaderInspectList(BeginDate,EndDate:TDateTime;var LeaderInspectList:TRsLeaderInspectList);
    //添加一个检查信息
    function   AddLeaderInspect(LeaderInspect:RRsLeaderInspect):boolean;
    //删除过时的记录
    procedure DelOldInpect(EndDate:TDateTime);
    //设置上传标志
    procedure SetUploadFlag(strGUID:string;bUpload:Boolean);
    //获取未上传查岗记录
    procedure GetUploadInpectInfo(var LeaderInspectAry:TRsLeaderInspectList);

    procedure  AdoToData(ADOQuery:TADOQuery;var LeaderInspect:RRsLeaderInspect);
    procedure  DataToAdo(ADOQuery:TADOQuery;var LeaderInspect:RRsLeaderInspect);

  end;

implementation

procedure TRsDBLeaderInspect.AdoToData(ADOQuery: TADOQuery;
  var LeaderInspect: RRsLeaderInspect);
begin
  with ADOQuery do
  begin
    LeaderInspect.GUID := FieldByName('strGUID').AsString;
    LeaderInspect.strTrainmanNumber := FieldByName('strTrainmanNumber').AsString;;
    LeaderInspect.strTrainmanName := FieldByName('strTrainmanName').AsString;
    LeaderInspect.LeaderGUID := FieldByName('strLeaderGUID').AsString;
    LeaderInspect.AreaGUID := FieldByName('strAreaGUID').AsString;
    LeaderInspect.VerifyID := FieldByName('nVerifyID').AsInteger;
    LeaderInspect.CreateTime := FieldByName('dtCreateTime').AsDateTime;
    LeaderInspect.DutyGUID := FieldByName('strDutyGUID').AsString;
    LeaderInspect.strContext  := FieldByName('strContext').AsString;
  end;
end;

procedure TRsDBLeaderInspect.DataToAdo(ADOQuery: TADOQuery;
  var LeaderInspect: RRsLeaderInspect);
begin
  with ADOQuery do
  begin
    FieldByName('strGUID').AsString := LeaderInspect.GUID;
    FieldByName('strLeaderGUID').AsString := LeaderInspect.LeaderGUID;
    FieldByName('strAreaGUID').AsString := LeaderInspect.AreaGUID;
    FieldByName('nVerifyID').AsInteger := LeaderInspect.VerifyID;
    FieldByName('dtCreateTime').AsDateTime := LeaderInspect.CreateTime;
    FieldByName('strDutyGUID').AsString := LeaderInspect.DutyGUID;
    FieldByName('strContext').AsString := LeaderInspect.strContext;
  end;  
end;
  
function TRsDBLeaderInspect.AddLeaderInspect(
  LeaderInspect: RRsLeaderInspect): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := m_ADOConnection;
      Sql.Text := 'select * from  TAB_Exam_Information where 1 = 2 ' ;
      Open;
      Append;
      DataToAdo(ado,LeaderInspect);
      Post;
      Result :=  True ;
    end;
  finally
    ado.Free;
  end;
end;

procedure TRsDBLeaderInspect.DelOldInpect(EndDate: TDateTime);
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  ADOQuery := TADOQuery.Create(nil);
  try
    strSQL := Format('delete * from  TAB_Exam_Information where dtCreateTime < ''%s''  or nDelFlag = 1 ',[
      FormatDateTime('yyyy-MM-dd HH:nn:ss',EndDate)])  ;
    ADOQuery.Connection := m_ADOConnection;
    ADOQuery.SQL.Text := strSQL ;
    ADOQuery.ParamCheck := False ;
    ADOQuery.ExecSQL;
  finally
    ADOQuery.Free;
  end;
end;

procedure TRsDBLeaderInspect.GetLeaderInspectList(BeginDate,
  EndDate: TDateTime; var LeaderInspectList: TRsLeaderInspectList);
var
  ado : TADOQuery;
  i:Integer ;
  strText:string;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := m_ADOConnection;
      ParamCheck := False ;
      strText := Format('select a.*,b.strTrainmanNumber,b.strTrainmanName from TAB_Exam_Information a ' +
       ' LEFT OUTER JOIN TAB_Org_Trainman  b on a.strLeaderGUID = b.strTrainmanGUID ' +
       ' where a.dtCreateTime >= ''%s'' and a.dtCreateTime <= ''%s'' order by a.dtCreateTime',[
      FormatDateTime('yyyy-MM-dd HH:nn:ss',BeginDate),
      FormatDateTime('yyyy-MM-dd HH:nn:ss',EndDate)]);
      Sql.Text := strText;
      Open;
      if RecordCount <= 0 then
        Exit;
      i := 0 ;
      SetLength(LeaderInspectList,RecordCount);
      while not eof do
      begin
        AdoToData(ado,LeaderInspectList[i]);
        Next;Inc(i);
      end;
    end;
  finally
    ado.Free;
  end;
end;
procedure TRsDBLeaderInspect.GetUploadInpectInfo(
  var LeaderInspectAry: TRsLeaderInspectList);
var
  qry:TADOQuery;
  i:Integer;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from TAB_Exam_Information where bInUploaded =0';
    qry.Open;
    SetLength(LeaderInspectAry,qry.RecordCount);
    i:= 0;
    while not qry.Eof do
    begin
      self.AdoToData(qry,LeaderInspectAry[i]);
      Inc(i);
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

procedure TRsDBLeaderInspect.SetUploadFlag(strGUID: string; bUpload: Boolean);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'update TAB_Exam_Information set bInUploaded = :bInUploaded where strGUID = :strGUID';
    qry.Parameters.ParamByName('strGUID').Value := strGUID;
    qry.Parameters.ParamByName('bInUploaded').Value := bUpload;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

end.
