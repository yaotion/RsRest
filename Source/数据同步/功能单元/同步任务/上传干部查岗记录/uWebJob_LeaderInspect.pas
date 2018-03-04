unit uWebJob_LeaderInspect;

interface
uses
  Classes,uHttpDataUpdateMgr,uWebIF,uLeaderExam,uDBLeaderInspect,superobject,
  SysUtils;
type
  //////////////////////////////////////////////////////////////////////////////
  /// ����:TWebJob_LeaderInspect
  /// ����:ͬ���ɲ���ڼ�¼
  //////////////////////////////////////////////////////////////////////////////
  TWebJob_LeaderInspect = class(THttpUpdateJob)
  public
    constructor Create(strJobName:string);override;
    destructor Destroy();override;
  public
    {����:ִ��ͬ��}
    procedure DoUpdate();override;
    {����:�ϴ��ɲ���ڼ�¼}
    function UploadInfo(info:RRsLeaderInspect;var strErr:string):Boolean;
  private
    {����:�����Ϣת��Ϊjson�ַ���}
    function InspectInfoToStr(info:RRsLeaderInspect):string;
  private
    //�ɲ�������ݿ����
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
    InsertLogs(Format('��������%d����¼��Ҫͬ��',[Length(LeaderInspectAry)]));
    for i := 0 to Length(LeaderInspectAry) - 1 do
    begin
      if Self.bStop then Exit;
      
      if UploadInfo(LeaderInspectAry[i],strMsg)= True then
      begin
        InsertLogs(Format('ͬ����%d����Ԣ��¼�ɹ�!',[i+1]));
      end
      else
      begin
        InsertLogs(Format('ͬ����%d����Ԣ��¼ʧ��,ԭ��:%s!',[i+1,strMsg]));
      end;
    end;

  except on E:Exception do
    InsertLogs('ͬ������:' + e.Message);
  end;

  InsertLogs('ͬ������');
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

