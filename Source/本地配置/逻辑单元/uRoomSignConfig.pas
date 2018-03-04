unit uRoomSignConfig;

interface

uses
  SysUtils,IniFiles;

type

  {
    [��Ԣ����]
  bIsUseNetwork = 1
  bEnableTimeLimit = 1
  nSleepTime = 260
  bEnableUpload = 1
  nUploadTime = 120
  }
  //��ԢCONFIG.INI���ýṹ��
  RRoomSignConfigInfo = record
    //�Ƿ�ʹ�������
    bIsUseNetwork :Boolean;
    //�Ƿ�ʹ����Ϣ����
    bEnableTimeLimit :Boolean;
    //��Ϣ����ʱ�� ���� 260
    nSleepTime :Integer;
    //�Ƿ�ʹ�ûش�����
    bEnableUpload :Boolean;
    //�ش�����ʱ��
    nUploadTime :Integer;
  end;

  TRoomSignConfigOper = class
  public
    constructor Create(FileName:string);
    destructor  Destroy();override;
  public
    //��ʼ��
    procedure Init();
      // ��ȡ
    procedure ReadFromFile();
     //����
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
    //�Ƿ��������
    bIsUseNetwork := False ;
    //�Ƿ�ʹ����Ϣ����
    bEnableTimeLimit := True ;
    //��Ϣ����ʱ�� ���� 260
    nSleepTime := 260 ;
    //�Ƿ�ʹ�ûش�����
    bEnableUpload := False ;;
    //�ش�����ʱ��
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
    raise Exception.Create('�����ļ�����Ϊ��!');
  ini := TIniFile.Create(m_strFileName);
  try
    with RoomSignConfigInfo do
    begin
      bIsUseNetwork := ini.ReadBool('��Ԣ����','bIsUseNetwork',False);
      bEnableTimeLimit := ini.ReadBool('��Ԣ����','bEnableTimeLimit',True);
      nSleepTime := ini.ReadInteger('��Ԣ����','nSleepTime',260);
      bEnableUpload := ini.ReadBool('��Ԣ����','bEnableUpload',False);
      nUploadTime := ini.ReadInteger('��Ԣ����','nUploadTime',5);
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
    raise Exception.Create('�����ļ�����Ϊ��!');
  ini := TIniFile.Create(m_strFileName);
  try
    with RoomSignConfigInfo do
    begin
      ini.WriteBool('��Ԣ����','bIsUseNetwork',bIsUseNetwork);
      ini.WriteBool('��Ԣ����','bEnableTimeLimit',bEnableTimeLimit);
      ini.WriteInteger('��Ԣ����','nSleepTime',nSleepTime);
      ini.WriteBool('��Ԣ����','bEnableUpload',bEnableUpload);
      ini.WriteInteger('��Ԣ����','nUploadTime',nUploadTime);
    end;
  finally
    ini.Free;
  end;
end;

end.
