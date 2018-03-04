unit uWebJob_SyncDic;

interface
uses
  Classes,uHttpDataUpdateMgr,uWebIF,superobject,
  SysUtils;
type
  //////////////////////////////////////////////////////////////////////////////
  /// ����:TWebJob_SyncDic
  /// ����:ͬ���ֵ�����
  //////////////////////////////////////////////////////////////////////////////
  TWebJob_SyncDic = class(THttpUpdateJob)
  public
    constructor Create(strJobName:string);override;
    destructor Destroy();override;
  public
    {����:ִ��ͬ��}
    procedure DoUpdate();override;
    {����:�ӽӿڻ�ȡ����}
    function DownDic(strTableName:string;var strErr,strData:string):Boolean;
    {����:��������}
    procedure SaveData(strData:String);virtual;abstract;
  protected
    //�ֵ�����
    strDicName:string;
  end;

implementation

{ TWebJob_SyncDic }

constructor TWebJob_SyncDic.Create(strJobName: string);
begin
  inherited Create(strJobName);
end;

destructor TWebJob_SyncDic.Destroy;
begin
  inherited;
end;

procedure TWebJob_SyncDic.DoUpdate;
var
  strErr:string;
  strData:string;
begin
  inherited;
  InsertLogs('��ʼͬ��...');
  if DownDic(strDicName,strErr,strData)= False then
  begin
    InsertLogs(Format('ͬ������,ԭ��%s',[strErr]));
    Exit;
  end;
  InsertLogs('�����������,��ʼ����...');
  try
    SaveData(strData);
  except on e:Exception do
    InsertLogs(Format('��������ʧ��,ԭ��:%s',[e.message]));
  end;
  InsertLogs('�������ݳɹ�');
end;

function TWebJob_SyncDic.DownDic(strTableName:string;var strErr,strData:string): Boolean;
var
  jsRet,jsInput:ISuperObject;
  strJsData:string;
  strDataType:string;
begin
  result := False;
  jsInput := SO();
  jsInput.S['DBName']:=strTableName;
  strDataType := 'TF.RunSafty.Bll.Synchronization.ISynchronization.GetSynchronization';

  if m_WebIF.TransData_UnifiedURL(strDataType,jsInput.AsString,strJsData) = False then
  begin
    strErr := strJsData;
    Exit;
  end;
  if strJsData<>'' then
  begin
    jsRet := SO(strJsData);
    case jsRet.I['result'] of
      0:
      begin
        try
          strData := jsRet.S['data'];
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
