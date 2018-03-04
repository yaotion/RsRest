unit uWebJob_SyncDic;

interface
uses
  Classes,uHttpDataUpdateMgr,uWebIF,superobject,
  SysUtils;
type
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TWebJob_SyncDic
  /// 描述:同步字典数据
  //////////////////////////////////////////////////////////////////////////////
  TWebJob_SyncDic = class(THttpUpdateJob)
  public
    constructor Create(strJobName:string);override;
    destructor Destroy();override;
  public
    {功能:执行同步}
    procedure DoUpdate();override;
    {功能:从接口获取数据}
    function DownDic(strTableName:string;var strErr,strData:string):Boolean;
    {功能:保存数据}
    procedure SaveData(strData:String);virtual;abstract;
  protected
    //字典名称
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
  InsertLogs('开始同步...');
  if DownDic(strDicName,strErr,strData)= False then
  begin
    InsertLogs(Format('同步出错,原因%s',[strErr]));
    Exit;
  end;
  InsertLogs('下载数据完成,开始保存...');
  try
    SaveData(strData);
  except on e:Exception do
    InsertLogs(Format('保存数据失败,原因:%s',[e.message]));
  end;
  InsertLogs('保存数据成功');
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
