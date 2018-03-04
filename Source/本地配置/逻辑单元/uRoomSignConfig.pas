unit uRoomSignConfig;

interface

uses
  SysUtils,IniFiles;

type

  {
    [公寓设置]
  bIsUseNetwork = 1
  bEnableTimeLimit = 1
  nSleepTime = 260
  bEnableUpload = 1
  nUploadTime = 120
  }
  //公寓CONFIG.INI配置结构体
  RRoomSignConfigInfo = record
    //是否使用网络版
    bIsUseNetwork :Boolean;
    //是否使用作息限制
    bEnableTimeLimit :Boolean;
    //作息限制时间 分钟 260
    nSleepTime :Integer;
    //是否使用回传数据
    bEnableUpload :Boolean;
    //回传数据时间
    nUploadTime :Integer;
  end;

  TRoomSignConfigOper = class
  public
    constructor Create(FileName:string);
    destructor  Destroy();override;
  public
    //初始化
    procedure Init();
      // 读取
    procedure ReadFromFile();
     //保存
    procedure SaveToFile();
  public
    RoomSignConfigInfo:RRoomSignConfigInfo;
  private
    m_strFileName:string;
  end;

implementation

{ TRoomSignConfigOper }

constructor TRoomSignConfigOper.Create(FileName:string);
begin
  inherited Create();
  with RoomSignConfigInfo do
  begin
    //是否是网络版
    bIsUseNetwork := False ;
    //是否使用作息限制
    bEnableTimeLimit := True ;
    //作息限制时间 分钟 260
    nSleepTime := 260 ;
    //是否使用回传数据
    bEnableUpload := False ;;
    //回传数据时间
    nUploadTime := 120 ;
  end;

  m_strFileName := FileName ;

end;

destructor TRoomSignConfigOper.Destroy;
begin

  inherited;
end;

procedure TRoomSignConfigOper.Init;
begin
  ;
end;

procedure TRoomSignConfigOper.ReadFromFile;
var
  ini:TIniFile;
begin
  if m_strFileName = '' then
    raise Exception.Create('配置文件名字为空!');
  ini := TIniFile.Create(m_strFileName);
  try
    with RoomSignConfigInfo do
    begin
      bIsUseNetwork := ini.ReadBool('公寓设置','bIsUseNetwork',False);
      bEnableTimeLimit := ini.ReadBool('公寓设置','bEnableTimeLimit',True);
      nSleepTime := ini.ReadInteger('公寓设置','nSleepTime',260);
      bEnableUpload := ini.ReadBool('公寓设置','bEnableUpload',False);
      nUploadTime := ini.ReadInteger('公寓设置','nUploadTime',5);
    end;
  finally
    ini.Free;
  end;
end;

procedure TRoomSignConfigOper.SaveToFile;
var
  ini:TIniFile;
begin
  if m_strFileName = '' then
    raise Exception.Create('配置文件名字为空!');
  ini := TIniFile.Create(m_strFileName);
  try
    with RoomSignConfigInfo do
    begin
      ini.WriteBool('公寓设置','bIsUseNetwork',bIsUseNetwork);
      ini.WriteBool('公寓设置','bEnableTimeLimit',bEnableTimeLimit);
      ini.WriteInteger('公寓设置','nSleepTime',nSleepTime);
      ini.WriteBool('公寓设置','bEnableUpload',bEnableUpload);
      ini.WriteInteger('公寓设置','nUploadTime',nUploadTime);
    end;
  finally
    ini.Free;
  end;
end;

end.
