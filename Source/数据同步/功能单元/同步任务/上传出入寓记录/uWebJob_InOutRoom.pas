unit uWebJob_InOutRoom;

interface
uses
  Classes,uHttpDataUpdateMgr,uWebIF,uWaitWork,uWaitWorkMgr,superobject,
  SysUtils;
type
  //////////////////////////////////////////////////////////////////////////////
  /// ����:TWebJob_InOutRoom
  /// ����:ͬ�����빫Ԣ��¼
  //////////////////////////////////////////////////////////////////////////////
  TWebJob_InOutRoom = class(THttpUpdateJob)
  public
    constructor Create(strJobName:string);override;
    destructor Destroy();override;
  public
    {����:ִ��ͬ��}
    procedure DoUpdate();override;
    {����:�ϴ����빫Ԣ��¼}
    function UploadInfo(info:RRSInOutRoomInfo;var strErr:string):Boolean;
  private
    //������
    m_WaitWorkMgr :TWaitWorkMgr;
  end;

implementation

{ TWebJob_WaitWorkPlan }

constructor TWebJob_InOutRoom.Create(strJobName:string);
begin
  inherited Create(strJobName);

end;

destructor TWebJob_InOutRoom.Destroy;
begin
  if Assigned(m_WaitWorkMgr) then
    m_WaitWorkMgr.Free;
  inherited;
end;

procedure TWebJob_InOutRoom.DoUpdate;
var
  InRoomAry:RRsInOutRoomInfoArray;
  OutRoomAry:RRsInOutRoomInfoArray;
  i:Integer;
  strMsg:string;
begin
  inherited;
  try
    if not Assigned(m_WaitWorkMgr) then
    begin
      m_WaitWorkMgr:= TWaitWorkMgr.Create(self.UpdateManager.LocalDB);
    end;

    m_WaitWorkMgr.GetUnUploadInOutRoomInfo(InRoomAry,OutRoomAry);
    InsertLogs(Format('��������%d����Ԣ��¼��Ҫͬ��',[Length(InRoomAry)]));
    for i := 0 to Length(InRoomAry) - 1 do
    begin
      if Self.bStop then Exit;
      
      if UploadInfo(InRoomAry[i],strMsg)= True then
      begin
        InsertLogs(Format('ͬ����%d����Ԣ��¼�ɹ�!',[i+1]));
      end
      else
      begin
        InsertLogs(Format('ͬ����%d����Ԣ��¼ʧ��,ԭ��:%s!',[i+1,strMsg]));
      end;
    end;
    InsertLogs(Format('��������%d����Ԣ��¼��Ҫͬ��',[Length(OutRoomAry)]));
    for i := 0 to Length(OutRoomAry) - 1 do
    begin
      if Self.bStop then Exit;
      if UploadInfo(OutRoomAry[i],strMsg)= True then
      begin
        InsertLogs(Format('ͬ����%d����Ԣ��¼�ɹ�!',[i]));
      end
      else
      begin
        InsertLogs(Format('ͬ����%d����Ԣ��¼ʧ��,ԭ��:%s!',[i,strMsg]));
      end;
    end;
  except on E:Exception do
    InsertLogs('���빫Ԣ��Ϣͬ������:' + e.Message);
  end;

  InsertLogs('���빫Ԣ��Ϣͬ������');
end;

function TWebJob_InOutRoom.UploadInfo(info: RRSInOutRoomInfo;var strErr:string): Boolean;
var
  jsRet:ISuperObject;
  strResult:string;
  strJsData:string;
  strDataType:string;
begin
  result := False;
   strJsData := info.ToJsonStr(info.eInOutType) ;
  if info.eInOutType = TInRoom then
    strDataType := 'TF.RunSafty.Room.InRoom.Add'
  else
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
          info.bUploaded := True;
          m_WaitWorkMgr.ModifyInOutRoomInfo(info);
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

