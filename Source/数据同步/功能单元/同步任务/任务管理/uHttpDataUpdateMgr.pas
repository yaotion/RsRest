unit uHttpDataUpdateMgr;

interface

uses
  Windows, Classes, Math, SysUtils, IdHTTP, Contnrs, ADODB, DB ,uWebIF,ActiveX ;

type
  //http�����¼�
  TProcessEvent = procedure(APercent: Integer) of object;
  //�ַ����¼�
  TOnEventByString = procedure(strText: string) of object;




  {����ͬ��������}
  TDataUpdateManager  = class;
  //////////////////////////////////////////////////////////////////////////////
  ///  ����:THttpUpdateJob
  ///  ����:http����ͬ������
  //////////////////////////////////////////////////////////////////////////////
  THttpUpdateJob = class
  public
    constructor Create(strJobName:string); virtual;
    destructor Destroy();override;
  public
    {����:�޸�web����}
    procedure UpdateWebConfig(webConfig:RWebConfig);
    {����:ִ��ͬ��}
    procedure DoUpdate(); virtual; abstract;
    //������־
    procedure InsertLogs(strLog : String); 
  protected
    //������
    m_strJobName:string;
    //���������
    m_UpdateMgr: TDataUpdateManager;
    {�Ƿ�ֹͣ}
    m_bStop:Boolean;
  protected
    //web����
    m_webIF:TWebIF;
  public
    property UpdateManager: TDataUpdateManager read m_UpdateMgr;
    property bStop:Boolean read m_bStop write m_bStop;
  end;

  TDataUpdateManager = class(TObject)
  public
    constructor Create();
    destructor Destroy(); override;
  public
    {����:�������ݿ�}
    function InitDB(adoConString:string;strMsg:string):Boolean;
    {����:����web����}
    procedure SetWebConfig(webConfig:RWebConfig);

    {��ʼ����}
    procedure DoUpdate();
    {ֹͣ����}
    procedure Stop();
    {ע��ͬ�����󣬲����ظö���}
    function AddUpdateJob(AJob: THttpUpdateJob): THttpUpdateJob;
  protected
    {����:��־���}
    procedure InsertLogs(strLog : String);

  private
    //�������ݿ�����
    m_LocalDB: TADOConnection;
    //�����б�
    m_JobList: TObjectList;
    //��־�¼�
    m_InsertLogs: TOnEventByString;
    //��ʱ·��
    m_TempPath: string;
  

  public
    property LocalDB: TADOConnection read m_LocalDB write m_LocalDB;
    property UpdateList: TObjectList read m_JobList;
    property TempPath: string read m_TempPath write m_TempPath;

    property OnInsertLogs: TOnEventByString read m_InsertLogs write m_InsertLogs;
  end;


implementation


{ TDataUpdateManager }

//------------------------------------------------------------------------------

function TDataUpdateManager.AddUpdateJob(AJob: THttpUpdateJob): THttpUpdateJob;
begin
  result := AJob;
  AJob.m_UpdateMgr := Self;
  m_JobList.Add(AJob);
end;
//------------------------------------------------------------------------------

constructor TDataUpdateManager.Create();
begin
  inherited Create;
  m_TempPath := ExtractFilePath(ParamStr(0))+'tmpFile\';
  m_LocalDB := TADOConnection.Create(nil);
  m_JobList := TObjectList.Create;
  CoInitialize(nil);
end;
//------------------------------------------------------------------------------

destructor TDataUpdateManager.Destroy;
begin
  m_JobList.Free;
  m_LocalDB.Free;
  CoUninitialize;
  inherited;
end;

//------------------------------------------------------------------------------
function TDataUpdateManager.InitDB(adoConString: string;strMsg:string): Boolean;
begin
  result := False;
  CoInitialize(nil);  //ʹ��com�������Ҫ��ʼ��
  try
    m_LocalDB.Close ;
    m_LocalDB.ConnectionString := adoConString;
    m_LocalDB.LoginPrompt := False;
    m_LocalDB.Open;
    result := True;
  except On e:exception do
    strMsg := e.Message;
  end;
  CoUninitialize;
end;

procedure TDataUpdateManager.InsertLogs(strLog: String);
begin
  if Assigned(m_InsertLogs) then
  begin
    m_InsertLogs(strLog);
  end;
end;


procedure TDataUpdateManager.DoUpdate;
var
  I: Integer;
  p: THttpUpdateJob;
begin
  for I := 0 to m_JobList.Count - 1 do
  begin
    P := m_JobList[I] as THttpUpdateJob;
    if Assigned(p) then
    begin
      if p.bStop then
        Continue;
      p.DoUpdate();
    end;
  end;
end;
//------------------------------------------------------------------------------

procedure TDataUpdateManager.SetWebConfig(webConfig: RWebConfig);
var
  I: Integer;
  p: THttpUpdateJob;
begin
  for I := 0 to m_JobList.Count - 1 do
  begin
    P := m_JobList[I] as THttpUpdateJob;
    if Assigned(p) then
    begin
      p.UpdateWebConfig(webConfig);
    end;
  end;
end;

procedure TDataUpdateManager.Stop;
var
  I: Integer;
  p: THttpUpdateJob;
begin
  for I := 0 to m_JobList.Count - 1 do
  begin
    P := m_JobList[I] as THttpUpdateJob;
    if Assigned(p) then
    begin
      p.bStop := True;
    end;
  end;
end;


constructor THttpUpdateJob.Create(strJobName: string);
begin
  inherited create() ;
  m_strJobName := strJobName;
  m_webIF:=TWebIF.Create;
end;

destructor THttpUpdateJob.Destroy;
begin
  m_webIF.Free;
  inherited;
end;

procedure THttpUpdateJob.InsertLogs(strLog: String);
begin
  if Assigned(m_UpdateMgr) then
  begin
    m_UpdateMgr.InsertLogs(Format('[%s]', [self.m_strJobName])+ strLog);
  end;
end;
procedure THttpUpdateJob.UpdateWebConfig(webConfig:RWebConfig);
begin
  m_webIF.webConfig := webConfig;
end;

//------------------------------------------------------------------------------

end.
