unit uDBCLientApp;

interface

uses
  SysUtils,Classes,ADODB,uClientAppInfo,uTFSystem;

type

  {客户端信息传递到数据库操作类}

  TRsDBClientApp = class (TDBOperate)
  protected
    //将客户端信息填充到ADO
    procedure DataToAdo(ADOQery:TADOQuery;ClientAppInfo:RRsClientAppInfo);
  end;

  TRsDBClientAppInfo = class (TRsDBClientApp)
  public
    //上传软件信息到数据库
    function Insert(ClientAppInfo:RRsClientAppInfo):Boolean;
  end;

  {客户端信息传递到数据库操作类 主要用于日志}
  TRsDBClientAppLog = class (TRsDBClientApp)
  public
    //上传软件信息到数据库
    function Insert(ClientAppInfo:RRsClientAppInfo):Boolean;
  end;

  {客户端信息上传操作类，包含 历史类和前}
  TRsClientAppOper = class
  public
    constructor Create(ADOConnection : TADOConnection);
    destructor  Destroy();override;
  public
    //增加客户端信息
    function Insert(ClientAppInfo:RRsClientAppInfo):Boolean;
  private
    //客户端信息数据库操作
    m_dbClientInfo : TRsDBClientAppInfo ;
    //客户端信息数据库操作 日志
    m_dbClientLog : TRsDBClientAppLog ;
  end;

implementation

{ TRsClientAppInfo }

function TRsDBClientAppInfo.Insert(ClientAppInfo: RRsClientAppInfo): Boolean;
var
  strSql:string;
  adoQuery:TADOQuery;
begin
  Result := False ;
  adoQuery := NewADOQuery;
  try
    strSql := format('select * from TAB_Base_ClientInfo where strClientID = %s ',[QuotedStr(ClientAppInfo.strClientID)]);
    with adoQuery do
    begin
      SQL.Text := strSql;
      Open;
      if IsEmpty  then
        Append
      else
        Edit;
      DataToAdo(adoQuery,ClientAppInfo);
      Post;
      Result := True ;
    end;
  finally
    adoQuery.Free;
  end;
end;

{ RsClientAppLog }


function TRsDBClientAppLog.Insert(ClientAppInfo: RRsClientAppInfo): Boolean;
var
  strSql:string;
  adoQuery:TADOQuery;
begin
  Result := False ;
  adoQuery := NewADOQuery;
  try
    strSql := 'select * from Tab_Base_ClientLog where 1 = 2 ';
    with adoQuery do
    begin
      SQL.Text := strSql;
      Open;
      Append;
      DataToAdo(adoQuery,ClientAppInfo);
      Post;
      Result := True ;
    end;
  finally
    adoQuery.Free;
  end;
end;

{ TRsClientAppOper }

constructor TRsClientAppOper.Create(ADOConnection: TADOConnection);
begin
  inherited Create();
  m_dbClientInfo := TRsDBClientAppInfo.Create(ADOConnection);
  m_dbClientLog := TRsDBClientAppLog.Create(ADOConnection);
end;

destructor TRsClientAppOper.Destroy;
begin
  m_dbClientInfo.Free;
  m_dbClientLog.Free;
  inherited;
end;

function TRsClientAppOper.Insert(ClientAppInfo: RRsClientAppInfo): Boolean;
begin
  Result := False ;
  //插入客户端最新版本日志
  m_dbClientInfo.Insert(ClientAppInfo);
  //插入客户端最新版本日志
  m_dbClientLog.Insert(ClientAppInfo)  ;
  Result := True ;
end;

{ TRsClientAppToDB }

procedure TRsDBClientApp.DataToAdo(ADOQery: TADOQuery;
  ClientAppInfo: RRsClientAppInfo);
begin
  with ADOQery do
  begin
    FieldByName('strClientID').AsString := ClientAppInfo.strClientID;
    FieldByName('strClientVersion').AsString := ClientAppInfo.strClientVersion;
    FieldByName('dtLogInTime').AsDateTime := ClientAppInfo.dtLogInTime;
    FieldByName('dtCreateTime').AsDateTime := ClientAppInfo.dtCreateTime;
  end;
end;

end.
