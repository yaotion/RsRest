unit uDBCLientApp;

interface

uses
  SysUtils,Classes,ADODB,uClientAppInfo,uTFSystem;

type

  {�ͻ�����Ϣ���ݵ����ݿ������}

  TRsDBClientApp = class (TDBOperate)
  protected
    //���ͻ�����Ϣ��䵽ADO
    procedure DataToAdo(ADOQery:TADOQuery;ClientAppInfo:RRsClientAppInfo);
  end;

  TRsDBClientAppInfo = class (TRsDBClientApp)
  public
    //�ϴ������Ϣ�����ݿ�
    function Insert(ClientAppInfo:RRsClientAppInfo):Boolean;
  end;

  {�ͻ�����Ϣ���ݵ����ݿ������ ��Ҫ������־}
  TRsDBClientAppLog = class (TRsDBClientApp)
  public
    //�ϴ������Ϣ�����ݿ�
    function Insert(ClientAppInfo:RRsClientAppInfo):Boolean;
  end;

  {�ͻ�����Ϣ�ϴ������࣬���� ��ʷ���ǰ}
  TRsClientAppOper = class
  public
    constructor Create(ADOConnection : TADOConnection);
    destructor  Destroy();override;
  public
    //���ӿͻ�����Ϣ
    function Insert(ClientAppInfo:RRsClientAppInfo):Boolean;
  private
    //�ͻ�����Ϣ���ݿ����
    m_dbClientInfo : TRsDBClientAppInfo ;
    //�ͻ�����Ϣ���ݿ���� ��־
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
  //����ͻ������°汾��־
  m_dbClientInfo.Insert(ClientAppInfo);
  //����ͻ������°汾��־
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
