unit uWebJob_LeaderInspect;

interface
uses
  Classes,uHttpDataUpdateMgr,uWebIF,uLeaderExam,uDBLeaderInspect,superobject,
  SysUtils;
type
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TWebJob_LeaderInspect
  /// 描述:同步干部查岗记录
  //////////////////////////////////////////////////////////////////////////////
  TWebJob_LeaderInspect = class(THttpUpdateJob)
  public
    constructor Create(strJobName:string);override;
    destructor Destroy();override;
  public
    {功能:执行同步}
    procedure DoUpdate();override;
    {功能:上传干部查岗记录}
    function UploadInfo(info:RRsLeaderInspect;var strErr:string):Boolean;
  private
    {功能:查岗信息转换为json字符串}
    function InspectInfoToStr(info:RRsLeaderInspect):string;
  private
    //干部查岗数据库操作
    m_DBLeaderInspect:TRsDBLeaderInspect;
  end;

implementation

{ TWebJob_LeaderInspect }

constructor TWebJob_LeaderInspect.Create(strJobName:string);
begin
  inherited Create(strJobName);
  m_DBLeaderInspect := nil;
end;

destructor TWebJob_LeaderInspect.Destroy;
begin
  inherited;
  m_DBLeaderInspect.Free;
end;

procedure TWebJob_LeaderInspect.DoUpdate;
var
  i:Integer;
  strMsg:string;
  LeaderInspectAry:TRsLeaderInspectList;
begin
  inherited;
  if m_DBLeaderInspect = nil then
    m_DBLeaderInspect:=TRsDBLeaderInspect.Create(m_UpdateMgr.LocalDB);
  try
    m_DBLeaderInspect.GetUploadInpectInfo(LeaderInspectAry);
    InsertLogs(Format('检索出有%d条记录需要同步',[Length(LeaderInspectAry)]));
    for i := 0 to Length(LeaderInspectAry) - 1 do
    begin
      if Self.bStop then Exit;
      
      if UploadInfo(LeaderInspectAry[i],strMsg)= True then
      begin
        InsertLogs(Format('同步第%d条入寓记录成功!',[i+1]));
      end
      else
      begin
        InsertLogs(Format('同步第%d条入寓记录失败,原因:%s!',[i+1,strMsg]));
      end;
    end;

  except on E:Exception do
    InsertLogs('同步出错:' + e.Message);
  end;

  InsertLogs('同步结束');
end;

function TWebJob_LeaderInspect.InspectInfoToStr(info: RRsLeaderInspect): string;
var
  iJson:ISuperObject;
begin
  iJson := so();
  iJson.S['GUID'] := info.GUID ;
  iJson.S['LeaderGUID'] := info.LeaderGUID ;
  iJson.S['strTrainmanNumber'] := info.strTrainmanNumber ;
  iJson.S['strTrainmanName'] := info.strTrainmanName ;
  iJson.S['strContext'] := info.strContext ;
  iJson.S['AreaGUID'] := info.AreaGUID ;
  iJson.S['DutyGUID'] := info.DutyGUID ;
  iJson.I['VerifyID'] := info.VerifyID ;
  iJson.s['CreateTime'] := FormatDateTime('yyyy-mm-dd HH:nn:ss', info.CreateTime);
  result := iJson.AsString;
end;

function TWebJob_LeaderInspect.UploadInfo(info: RRsLeaderInspect;var strErr:string): Boolean;
var
  jsRet:ISuperObject;
  strResult:string;
  strJsData:string;
  strDataType:string;
begin
  result := False;
  strJsData := InspectInfoToStr(info) ;

  strDataType := 'TF.RunSafty.Room.OutRoom.Add';

  if m_WebIF.TransData_UnifiedURL(strDataType,strJsData,strResult) = False then
  begin
    strErr := strResult;
    Exit;
  end;
  if strResult<>'' then
  begin
    jsRet := SO(strResult);

    case jsRet.I['result'] of
      0:
      begin
        try
          m_DBLeaderInspect.SetUploadFlag(info.GUID,True);
          Result := True;
        except on e:Exception do
          strErr := e.Message;
        end;
      end;
      else
      begin
        strErr :=jsRet.S['resultStr'];
      end;
    end;
  end;
end;


end.

