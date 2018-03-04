unit uLogManage;

interface
uses
  Windows,SysUtils,Classes,uTFSystem;
type
  //////////////////////////////////////////////////////////////////////////////
  ///  类名:TLogManage
  ///  说明:日志管理器
  //////////////////////////////////////////////////////////////////////////////
  TLogManage = class
  public
    Constructor Create();
    Destructor Destroy();override;
  public
    {功能:插入日志}
    procedure InsertLog(strLogText : String);
  private
    {互斥对象}
    m_CriticalSection : TRTLCriticalSection;
    {日志文件名}
    m_strFileNamePath : String;
    {日志输出事件}
    m_OnInsertLog : TOnEventByString;
  private
    procedure SetFileNamePath(strFileNamePath:String);
  public
    property FileNamePath : String read m_strFileNamePath write SetFileNamePath;
    property OnInsertLog : TOnEventByString read m_OnInsertLog write m_OnInsertLog;
  end;

implementation

{ TLogManage }

constructor TLogManage.Create;
begin
  InitializeCriticalSection(m_CriticalSection);
end;

destructor TLogManage.Destroy;
begin
  DeleteCriticalSection(m_CriticalSection);
  inherited;
end;

procedure TLogManage.InsertLog(strLogText: String);
{功能:插入日志}
var
  txFile : TextFile;
  strFileName : String;
  FileHandle : Integer;
begin
  EnterCriticalSection(m_CriticalSection);
  try
    strLogText := formatDateTime('[yyy-mm-dd hh:nn:ss]',Now)+' '+strLogText;
    strFileName := m_strFileNamePath+FormatDateTime('yyy-mm-dd',now)+'.log';
    if FileExists(strFileName) = False then
    begin
      FileHandle := FileCreate(strFileName);
      FileClose(filehandle);
    end;
    AssignFile(txFile,strFileName);
    Append(txFile);
    Writeln(txFile,strLogText);
    CloseFile(txFile);
    if Assigned(m_OnInsertLog) then
      m_OnInsertLog(strLogText);
  finally
    LeaveCriticalSection(m_CriticalSection);
  end;
end;

procedure TLogManage.SetFileNamePath(strFileNamePath: String);
begin
  EnterCriticalSection(m_CriticalSection);
  if strFileNamePath <> '' then
  begin
    if strFileNamePath[Length(strFileNamePath)] <> '\' then
      strFileNamePath := strFileNamePath + '\';
  end;

  if DirectoryExists(strFileNamePath) = False then
    Mkdir(strFileNamePath);

  m_strFileNamePath := strFileNamePath;

  LeaveCriticalSection(m_CriticalSection);
end;

end.
