unit uCallControl;
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////

//����: TCallControl

//���������ڿ������߽а�ϵͳ

//1��ͨ�Ų���:
//              RS232����ͨ�ŷ�ʽ��
//              ������9600��
//              ����λ8��
//              ֹͣλ1��
//              ��У�顣
//              ÿ֡����8�ֽڣ�
//              16���ơ�
//
//2������ĩ�ֽ�У��ͷ�ʽ�� ��ĩ�ֽ� = ǰ7���ֽ�֮��ȡ���롣
//
//3����λ��������÷������豸���ձ���λ�����з���ʱ���豸����ʽ����λ�����ͣ�Ĭ��2�ֽڣ����ֽ���ǰ����
//      �ֽ��ں��緿�����豸���ձ�����������豸�Ż����ö��ձ�ʹ��������豸��һ�¡�
//      ����λ������λ��ͨ�ž�Ϊ�豸�ţ������ֻ����λ���������ʾ��
//
//4��  ��λ�����ͣ�ÿ֡���ݾ���0xaa��0x55��ͷ����λ�����أ�ÿ֡���ݾ���0xaa��0x55��ͷ������ԭ���ݷ��ء�
//  ���ͺͷ��ص����ݵ�3�ֽ�Ϊ����λ��
//   0x58���ӻ��豸������             0x59���ӻ��豸�Ų�ѯ                 0x60�������豸��
//   0x61�������豸�Ų�ѯ             0x62���Ҷϵ绰                       0x63�����ŷ�ʽѡ��
//   0x64����λ�Խ�ģ��               0x65��¼���л�                       0x66�������л�
//   0x70�����ſ�������
//
//5�����ŷ�ʽ�����֣�һ�ǵ���ֱ�ӷ�DTMF��Ƶ�źţ����ǵ��Է������������Ӳ������DTMF��Ƶ�ź�
//   ��Ч��Ƶ�ź�Ϊ 7�ֽ� BYTE0 Ϊ��ͷ��BYTE6 Ϊ��β���м�5�ֽ�Ϊ����š� ��ͷ= ��Ч��c������β= ��#����
//   �����ɰ汾 ��ͷ��Ч ��*�� �����ڱ�������Ԣ ��
//
//6������Ԥ���ֽڣ�0x00��

////////////////////////////////////////////////////////////////////////////////

interface

uses SysUtils, CPort, StrUtils, Windows,uLogs,uTFSystem,uRoomCall;

const
  RESVERED_BYTE = 0 ;
type

  {�����豸}
  RCallMultiDevices = record
    idSrc :Word;        //�����豸���
    idDst :Word;        //�����豸���
    state:Byte;        //�豸״̬
    roomnumber:string;  //������
  end;

   RCallMultiDevicesArray = array of  RCallMultiDevices;


  TCallProtocol = (cpRS232{232Э��},cpRS485{485Э��});
  ///����״̬
  TCallStatus = (ctNil{��} ,ctCallSuccess{���гɹ�},ctHangUp,ctCalling{������});

  TCallControl = class
  public
    constructor Create(CallProtocolVer :TCallProtocol=cpRS485);
    destructor Destroy(); override;
  public
    //����Э��汾
    function GetCallProtocol():TCallProtocol;
    procedure SetCallProtocol(CallProtocolVer :TCallProtocol);
    //���Ͷ�ȡ������д�������
    procedure SendDataLog(Tag:string;Data: array of byte);
  public
    {���ܣ������豸���}
    function CallDevice(const num: word): integer;
    {���ܣ��Ҷ��豸���}
    function HangUp(const num: word): integer;
    {���ܣ����÷�������}
    function SetRoomCount(const num:Word):Integer;
    {���ܣ������豸}
    function MonitorDevice(const num: word): integer;
    {���ܣ�  �������豸���}
    function ReverseCallDevice(out num: word): Boolean;
    {���ܣ�  ��ͨ�������豸���}
    function  ConnectReverseCallDevice(nDevNum:Integer):integer;
    {���ܣ�  �ܽӷ������豸���}
    function  RefuseReverseCallDevice(nDevNum:Integer):integer;
    {���� �����ж���豸}
    function CallMultiDevices(Src:RCallMultiDevicesArray):Boolean;
    {���� ����ѯ���еĶ���豸״̬}
    function QueryMultiDevices(Src:RCallMultiDevicesArray):Boolean;
    {���� : ���ͷ�����Ϣ}
    function SendRoomDeviceInfoList(CallDevAry:TCallDevAry):BOOL;
    {���� :��а��������ͷ�����Ϣ}
    function SendRoomDeviceInfo(TotalFrame,CurrentFrame,CurrentCount:Integer;CallDevAry:TCallDevAry):Boolean;
        {���ܣ���ѯ�����Ӧ�豸��}
    function FindIDByRoom(RoomNumber:string;out num: word): Boolean;
  public
    {���ܣ������豸485}
    function CallDevice485(const num: word): integer;
    {���ܣ��Ҷ��°���Ҫ��ѯ485}
    function HangUp485(const num: word): integer;
    {���ܣ��Ҷ����е��豸}
    function HangUpAll(): integer; deprecated ;
  private
      {���ܣ��°汾�Ķ�ȡ����}
    function ReadSerialEx(var wdata: array of byte; const len: integer; var num: word): integer;
      {���ܣ���ȡ�������}
    function ReadReverseCall(var num: word): Boolean;
    {���ܣ� ���Э����װ}
    procedure CreateCallMultiDevicesProtocol(var wdata: array of byte;DevicesArray:RCallMultiDevicesArray);
    {���ܣ����Э����}
    procedure AnalysisCallMultiDevicesProtocol(var wdata: array of byte;var DevicesArray:RCallMultiDevicesArray);


    {���ܣ� �а��豸��Ϣ��Э����װ}
    procedure CreateSendDevicesInfoProtocol(var wdata: array of byte;CurrentCount,CurrentFrame: Integer; CallDevAry: TCallDevAry);
    {���ܣ��а��豸��Ϣ�����}
    procedure AnalysisSendDevicesInfoProtocol(var wdata: array of byte;var CallDevAry: TCallDevAry);
  public
    {���ܣ��򿪴���}
    function OpenPort(const port: integer): integer;
    {���ܣ��رմ���}
    procedure ClosePort();
    {���ܣ����ôӻ��豸��}
    function SetDeviceNum(const num: word): integer;
    {���ܣ���ȡ�ӻ��豸��}
    function GetDeviceNum(var devnum: word): integer;
    {���ܣ������豸}
    function CallDevice232(const num: word): integer;
    {���ܣ���ѯ�����豸��}
    function QueryCallDevState(var devnum: word): integer;
    //��ѯ�豸״̬
    function QueryDeviceState(nDeviceID : Word) : boolean;
    //ȷ���豸״̬
    function ConfirmDeviceState(nDeviceID : Word;var BRet:Boolean) : boolean;
    {���ܣ��Ҷ�}
    function HangUp232(const num: word): integer;
    {���ܣ�������ģ�鸴λ}
    function Reset() : integer;
    {���ܣ����ŷ�ʽѡ��}
    function SetDialType(const typeID : word) : Integer;
    {���ܣ���ȡ¼��ģʽ}
    function GetRecordMode():Integer;
    {���ܣ�����¼��ģʽѡ��}
    function SetRecordMode(Mode : Word) : boolean;
    {���ܣ���ȡ����ģʽ}
    function GetPlayMode() : Integer;
    {���ܣ����÷���ģʽ}
    function SetPlayMode(Mode : Word) : boolean;
    //�򿪹���
    function OpenGF() : boolean;
    //�رչ���
    function CloseGF() : boolean;
  private
    function GetProtocol(PType:Byte):string;
    {���ܣ������־}
    procedure AddLog(Tag:string;Data: array of byte);
    {���ܣ�������־}
    function CreateDataLog(Tag:string;Data: array of byte):string;
    {���ܣ�CRCУ��}
    procedure TCRC(old: array of byte; const len: Integer);
    {���ܣ���ȡCRCУ��}
    function GetCrc(src:array of byte):Byte;
    {���ܣ����߽а�Э����װ}
    procedure FixProtocol(const parm: word = 0);
    function WriteSerial(const wdata: array of byte; const len: integer): integer;
    function ReadSerial(var wdata: array of byte; const len: integer; var num: word): integer;overload;
    function ReadSerial(var wdata: array of byte; const len: integer):Integer;overload;
    function GetSerialErrCode(strerr: string): integer;
  private
    m_OnLogEvent : TOnEventByString ;   //������־
  private
    ComPort1: TComPort;
    {���ӵĴ��ں�}
    m_nPort: integer;
    {������}
    m_nBand: integer;
    {��λ����������}
    m_byScmd: array[0..7] of byte;
    {��λ������ָ��}
    m_byRcmd: array[0..7] of byte;
      {Э��汾}
    m_nCallProtocolVer :TCallProtocol ;
    {Э������}
    type protocol = (SETCALLNUM, GETCALLNUM, CALL, QUERYCALL, HANG,SELECT_TYPE,ptReset,ptRecordEx,ptPlayEx,ptTestGF,
      ptSetRoomCount{��������},ptMonitorDevice{����},
      ptReverseCallQuery{������ѯ},ptReverseCallConnect{������������},ptReverseCallRefuse{���������ܽ�},
      ptQueryDeviceInfo{��ѯ�豸��Ϣ});
    {��ǰ����}
    var  m_ptltype: protocol;
  public
    property  LogEvent:TOnEventByString read m_OnLogEvent write m_OnLogEvent ;
  end;

implementation

uses
  Math;

constructor TCallControl.Create(CallProtocolVer :TCallProtocol=cpRS485);
  //���ܣ���ʼ����Ա�������������ڶ���
begin
  m_nCallProtocolVer :=  CallProtocolVer ;
  m_nPort := -1;
  m_nBand := 9600;
  m_byScmd[0] := $AA;
  m_byScmd[1] := $55;
  ComPort1 := TComPort.Create(nil);
end;


procedure TCallControl.CreateCallMultiDevicesProtocol(var wdata: array of byte;DevicesArray:RCallMultiDevicesArray);
const
  BEGIN_INDEX = 4 ;
var
  i,nIndex,nDeviceCount : Integer ;
begin
  nDeviceCount := Length(DevicesArray) ;
  for I := 0 to nDeviceCount - 1 do
  begin
    nIndex :=  (i)*3  + BEGIN_INDEX  ;
    wdata[nIndex + 0 ] := HiByte( DevicesArray[i].idSrc );
    wdata[nIndex + 1 ] := LoByte( DevicesArray[i].idSrc );
    wdata[nIndex + 2 ] := 0;
  end;

  wdata[ Length(wdata)  -1 ] := GetCrc(wdata);
end;

function TCallControl.CreateDataLog(Tag:string;Data: array of byte): string;
var
  strTemp : string ;
  strText:string;
  i : Integer ;
begin
  strTemp := '';
  for I := 0 to Length(Data) - 1 do
  begin
    strTemp := strTemp + IntToHex(Data[i],2) + ' ';
  end;



  strText := Format('[%s]_[%s]:%s',[Tag,GetProtocol(Data[2]),strTemp]);
  Result := strText ;
end;

procedure TCallControl.CreateSendDevicesInfoProtocol(var wdata: array of byte;CurrentCount,CurrentFrame: Integer; CallDevAry: TCallDevAry);
{
  ���磺 1201����  ���333��,1201=0x04B1   333=0x014D  ����˳�� 0x04 0xb1  0x01 0x4D
}
const
  BEGIN_INDEX = 8 ;
var
  I,nIndex: Integer;
  strRoomNum:string ;
  nDevNum : Word ;
begin
  for I := 0 to CurrentCount - 1 do
  begin
    nIndex :=  (i)*4  + BEGIN_INDEX  ;

    strRoomNum := CallDevAry[ i + CurrentFrame* 16 ].strRoomNum ;
    nDevNum := CallDevAry[ i + CurrentFrame* 16 ].nDevNum ;

    wdata[ nIndex + 0 ] := HiByte(  StrToInt( strRoomNum  ) );
    wdata[ nIndex + 1 ] := LoByte( StrToInt(  strRoomNum ) );

    wdata[ nIndex + 2 ] := HiByte( nDevNum );
    wdata[ nIndex + 3 ] := LoByte( nDevNum ) ;
  end;

  wdata[ Length(wdata)  -1 ] := GetCrc(wdata);
end;

destructor TCallControl.Destroy();
    //���ܣ��رմ���
begin
  if ComPort1.Connected = FALSE then
    ComPort1.Close();
  m_nPort := -1;
  if Assigned(ComPort1) then
   FreeAndNil(ComPort1);
end;

function TCallControl.SetDialType(const typeID: word): Integer;
 //���ܣ�ѡ��ͨѶģʽ(1������;2����)
 //����ֵ��1 �����豸�ɹ�  >1 ����ʧ�ܴ�����
var rst: integer;
    devnum: word;
begin
  //485���治��Ҫ����ͨѶģʽ
  if m_nCallProtocolVer = cpRS485 then
  begin
    Result := 1 ;
    Exit ;
  end;

  m_ptltype := SELECT_TYPE;
  FixProtocol(typeID);

  //�򴮿�д����
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));

        //д�ɹ������ȡ��������
  if (rst = 1) then
  begin
    Sleep(100);
    Result := ReadSerial(m_byRcmd, sizeof(m_byRcmd),devnum);
  end
  else begin
    Result := rst;
  end;
end;

function TCallControl.SetDeviceNum(const num: word): integer;
   //���ܣ��ӻ����������
   //������num �ӻ������

var rst: integer;
    devnum: word;
begin

   //Э����װ
  m_ptltype := SETCALLNUM;
  FixProtocol(num);

   //�򴮿�д����
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));

   //д�ɹ������ȡ��������
  if (rst = 1) then
  begin
    Sleep(100);
    Result := ReadSerial(m_byRcmd, sizeof(m_byRcmd), devnum);
  end
  else
    Result := rst; //

end;

procedure TCallControl.SendDataLog(Tag:string;Data: array of byte);
var
  strText:string;
begin
  strText := CreateDataLog(Tag,Data);
  if Assigned(m_OnLogEvent) then
    m_OnLogEvent(strText);
end;

function TCallControl.SendRoomDeviceInfoList(CallDevAry: TCallDevAry): BOOL;
{16��һ֡�������ϳ�һ֡}
const
  FRAME_SIZE = 16 ;
var
  i,nTotalCount : Integer ;
  nTotalFrame,nCurrentFrame,nCurrentCount,nResverCount : Integer ;
begin
  Result := False ;
  nTotalCount := Length(CallDevAry);
  if nTotalCount = 0 then
  begin
    Result := True ;
    Exit ;
  end;
  nCurrentFrame := 0 ;
  nTotalFrame := ceil(   nTotalCount / 16.0 ) ;
  nResverCount :=  nTotalCount ;
  repeat
    if nResverCount >= FRAME_SIZE then
    begin
      nResverCount := nResverCount - FRAME_SIZE;
      nCurrentCount := FRAME_SIZE;
    end
    else
      nCurrentCount := nResverCount;
    SendRoomDeviceInfo(nTotalFrame,nCurrentFrame,nCurrentCount,CallDevAry);
    Inc(nCurrentFrame);
  until (nCurrentFrame>=nTotalFrame);
  Result := True ;
end;

function TCallControl.SendRoomDeviceInfo(TotalFrame, CurrentFrame,
  CurrentCount: Integer; CallDevAry: TCallDevAry): Boolean;
var
  pSendCmd: array[0..72] of byte;
  pRecvCmd: array[0..72] of byte ;
  nLen ,nRet : Integer ;
begin
  Result := False ;
  ZeroMemory(@pSendCmd[0], Length(pSendCmd) );
  ZeroMemory(@pRecvCmd[0], Length(pRecvCmd) );
  //��װ����
  pSendCmd[0] := $AA;
  pSendCmd[1] := $55;
  pSendCmd[2] := $72;

  //�ܹ���֡
  pSendCmd[3] := HiByte(TotalFrame);
  pSendCmd[4] := LoByte(TotalFrame);
  //��ǰ֡
  pSendCmd[5] := HiByte(CurrentFrame);
  pSendCmd[6] := LoByte(CurrentFrame);
  //��ǰ����
  pSendCmd[7] := Byte(CurrentCount);
  CreateSendDevicesInfoProtocol(pSendCmd,CurrentCount,CurrentFrame,CallDevAry);
  //����ָ��
  nRet := WriteSerial(pSendCmd, sizeof(pSendCmd));
  if nRet = 1 then
  begin
    Sleep(1*1000);
    nRet := ComPort1.Read(pRecvCmd, SizeOf(pRecvCmd));
    SendDataLog('������:',pRecvCmd);
    if nRet = 73 then
    begin
      Result := True ;
    end;
  end;
end;

procedure TCallControl.SetCallProtocol(CallProtocolVer: TCallProtocol);
begin
  if m_nCallProtocolVer <>  CallProtocolVer then
    m_nCallProtocolVer := CallProtocolVer ;
end;

function TCallControl.SetPlayMode(Mode: Word): boolean;
var
  rst: integer;
begin
  Result := false;
  m_ptltype := ptPlayEx;
  FixProtocol(Mode);
   //�򴮿�д����
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //д�ɹ������ȡ��������
  if (rst = 1) then
  begin
    Sleep(100);
    rst := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    if rst = 1 then
    begin
      rst := m_byRcmd[3];
      if rst = Mode then
        Result := true;
    end;
  end
end;

function TCallControl.SetRecordMode(Mode: Word): boolean;
var
  rst: integer;
begin
  Result := false;
  m_ptltype := ptRecordEx;
  FixProtocol(Mode);
   //�򴮿�д����
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //д�ɹ������ȡ��������
  if (rst = 1) then
  begin
    Sleep(100);
    rst := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    if rst = 1 then
    begin
      rst := m_byRcmd[3];
      if rst = Mode then
        Result := true;
    end;;
  end
end;

function TCallControl.SetRoomCount(const num: Word): Integer;
var
  rst: integer;
  devnum : word ;
begin
   //Э����װ
  m_ptltype := ptSetRoomCount;
  FixProtocol(num);
  //�򴮿�д����
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));

    //д�ɹ������ȡ��������
  if (rst = 1) then
  begin
    Sleep(100);
    Result := ReadSerial(m_byRcmd, sizeof(m_byRcmd),devnum);
  end
  else begin
    Result := rst;
  end;
end;

function TCallControl.GetDeviceNum(var devnum: word): integer;
   //���ܣ��ӻ�����Ų�ѯ
   //
var rst: integer;
begin
     //Э����װ
  m_ptltype := GETCALLNUM;
  FixProtocol(RESVERED_BYTE);
   //�򴮿�д����
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));

   //д�ɹ������ȡ��������
  if (rst = 1) then
  begin
    Sleep(100);
    Result := ReadSerial(m_byRcmd, sizeof(m_byRcmd), devnum);
  end
  else
    Result := rst;
end;


function TCallControl.GetCallProtocol: TCallProtocol;
begin
  Result := m_nCallProtocolVer ;
end;

function TCallControl.GetCrc(src: array of byte): Byte;
var
  i : Integer ;
  sum: integer;
  strhex: string;
begin
  sum := 0;
  for I := 0 to Length(src) - 2 do
  begin
    sum := sum + src[i];
  end;

  sum := not (sum);
  strhex := IntToHex(sum, 2);

  Result := StrToInt('$' + strhex) + 1; 
end;

function TCallControl.GetPlayMode: Integer;
var
  rst: integer;
begin
  Result := -1;
  m_ptltype := ptPlayEx;
  FixProtocol(RESVERED_BYTE);
   //�򴮿�д����
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //д�ɹ������ȡ��������
  if (rst = 1) then
  begin
    Sleep(100);
    rst := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    if rst = 1 then
    begin
      Result := m_byRcmd[3];
    end;;
  end
end;

function TCallControl.GetProtocol(PType: Byte): string;
var
  strText:string;
begin
  case PType of
    $56:
      strText := '�����в�ѯ ';
    $57:
      strText := '�����н���';
    $58:
      strText := '�ӻ��豸������';
    $59:
      strText := '�ӻ��豸�Ų�ѯ';
    $60:
      strText := '����1�豸��';
    $61:
      strText := '�����豸�Ų�ѯ ';
    $62:
      strText := '�Ҷϵ绰';
    $63:
      strText := ' ���ŷ�ʽѡ�� ';
    $64:
      strText := '��λ�Խ�ģ�� ';
    $65:
      strText := '¼���л�';
    $66:
      strText := '�����л�  ';
    $70:
      strText := '���ſ������� ';
    $71:
      strText := '������Ϣ���� ';
    $72:
      strText := '�����豸�Ŷ��ձ� ';
    $73:
      strText := ' ����״̬��ѯ ';
    $74:
      strText := ' ������� ';
    $75:
      strText := ' ���ж���豸�� ';
    $76:
      strText := ' ���ж���豸�Ų�ѯ ';
    $77:
      strText := ' �����豸�Ų�ѯ ';
  end;
  Result := strText ;
end;

function TCallControl.GetRecordMode: Integer;
var
  rst: integer;
begin
  Result := -1;
  m_ptltype := ptRecordEx;
  FixProtocol(RESVERED_BYTE);
   //�򴮿�д����
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //д�ɹ������ȡ��������
  if (rst = 1) then
  begin
    Sleep(100);
    rst := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    if rst = 1 then
    begin
      Result := m_byRcmd[3];
      if (Result < 1) or (Result > 2) then
        Result := -1;
    end;;
  end
end;

function TCallControl.CallDevice232(const num: word): integer;
//���ܣ������豸
var
  strTemp: string;
  i: Integer;
begin
  //Э����װ
  m_ptltype := CALL;
  FixProtocol(num);
  //��ͨ����
  Result := WriteSerial(m_byScmd, sizeof(m_byScmd));
  {�ƣ�����������д����־}
  strTemp := '';
  for I := 0 to Length(m_byScmd) - 1 do
  begin
    strTemp := strTemp + IntToStr(m_byScmd[i]);
  end;
  TLog.SaveLog(Now,'���ͺ������' + strTemp);

  OutputDebugString(PChar(Format('--------------------------------------���ͺ�������:%d',[Result])));
  //д�ɹ������ȡ��������
  if (Result = 1) then
  begin
    Sleep(100);
    Result := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    OutputDebugString(PChar(Format('--------------------------------------ȡ��������:%d',[Result])));
  end
end;

function TCallControl.QueryCallDevState(var devnum: word): integer;
//��ѯ�����豸��
//������devnum = 0 ���豸����
//����ֵ: 1: 2: 3:
var rst: integer;
begin
  //Э����װ
  m_ptltype := QUERYCALL;
  FixProtocol(devnum);

   //�򴮿�д����
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //д�ɹ������ȡ��������
  if (rst = 1) then
  begin
    Sleep(100);
    Result := ReadSerial(m_byRcmd, sizeof(m_byRcmd), devnum);
  end
  else begin
    Result := rst;
  end;

end;

function TCallControl.QueryDeviceState(nDeviceID: Word): boolean;
var
  rst: integer;
begin
  Result := false;
  m_ptltype := QUERYCALL;
  try
    FixProtocol(nDeviceID);
    //�򴮿�д����
    rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
    OutputDebugString(PChar(Format('--------------------------------------���Ͳ�ѯ����:%d',[rst])));
    if (rst <> 1) then
    begin
      OutputDebugString(PChar(Format('--------------------------------------���Ͳ�ѯ����ʧ��:%d',[Result])));
      exit;
    end;
    //д�ɹ������ȡ��������
    Sleep(500);
    ZeroMemory(@m_byRcmd[0], Length(m_byRcmd));
    ComPort1.Read(m_byRcmd, sizeof(m_byRcmd));
    SendDataLog('������:',m_byRcmd);
    OutputDebugString(PChar(Format('--------------------------------------��ȡ��ѯ����سɹ�:%d',[m_byRcmd[5]])));
    if m_byRcmd[5] <> 1 then exit;

    Result := true;
  except

  end;
end;

function TCallControl.QueryMultiDevices(Src: RCallMultiDevicesArray): Boolean;
var
  pSendCmd: array of byte;
  pRecvCmd: array of byte ;
  nLen ,nRet : Integer ;
begin
  Result := False ;
  nLen :=  Length(Src) ;
  setLength(pSendCmd, 5 + Length(Src)*3 );
  setLength(pRecvCmd, 5 + Length(Src)*3 );
  ZeroMemory(@pSendCmd[0], Length(pSendCmd) );
  ZeroMemory(@pRecvCmd[0], Length(pRecvCmd) );
  //��װ����
  pSendCmd[0] := $AA;
  pSendCmd[1] := $55;
  pSendCmd[2] := $76;
  pSendCmd[3] := nLen;
  CreateCallMultiDevicesProtocol(pSendCmd,Src);
  //����ָ��
  nRet := WriteSerial(pSendCmd, Length(pSendCmd));

  Sleep(1*1000);
  nRet := ComPort1.Read(pRecvCmd[0], Length(pRecvCmd));
  SendDataLog('������:',pRecvCmd);
  if nRet >0 then
  begin
    AnalysisCallMultiDevicesProtocol(pRecvCmd,Src);
    Result := True ;
  end;
end;

function TCallControl.HangUp(const num: word): integer;
begin
  case m_nCallProtocolVer of
    cpRS232 : Result := HangUp232(num) ;
    cpRS485 : Result := HangUp485(num) ;
    else
    begin
      Result := HangUp232(num) ;
    end;
  end;
end;

function TCallControl.HangUp232(const num: word): integer;
 //���ܣ��һ�
 //����ֵ��1 �����豸�ɹ�  >1 ����ʧ�ܴ�����
var
  rst: integer;
  devnum : word ;
begin
   //Э����װ
  m_ptltype := HANG;
  FixProtocol(num);
  //�򴮿�д����
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));

    //д�ɹ������ȡ��������
  if (rst = 1) then
  begin
    Sleep(100);
    Result := ReadSerial(m_byRcmd, sizeof(m_byRcmd),devnum);
  end
  else begin
    Result := rst;
  end;
end;


function TCallControl.HangUp485(const num: word): integer;
 //���ܣ��һ�
 //����ֵ��1 �����豸�ɹ�  >1 ����ʧ�ܴ�����
const
  MAX_TRY_COUNT:INTEGER = 3 ;
var
  i : integer ;
  rst: integer;
  devnum : word ;
begin

  devnum := 0 ;

   //Э����װ
  m_ptltype := HANG;
  FixProtocol(num);

  //�򴮿�д����
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));

  //д�ɹ������ȡ��������
  if (rst = 1) then
  begin
    for I := 0 to MAX_TRY_COUNT - 1 do
    begin
      Sleep(1*1000);
      Result := ReadSerialEx(m_byRcmd, sizeof(m_byRcmd),devnum);
      if Result  = 1 then
        break
      else
        Continue ;
    end;
  end
  else begin
    Result := rst;
  end;
end;

function TCallControl.HangUpAll: integer;
begin

end;

function TCallControl.MonitorDevice(const num: word): integer;
var rst: integer;
    devnum: word;
begin

   //Э����װ
  m_ptltype := ptMonitorDevice;
  FixProtocol(num);

   //�򴮿�д����
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));

   //д�ɹ������ȡ��������
  if (rst = 1) then
  begin
    Sleep(100);
    Result := ReadSerial(m_byRcmd, sizeof(m_byRcmd), devnum);
  end
  else
    Result := rst; //
end;

procedure TCallControl.TCRC(old: array of byte; const len: Integer);
var i: integer;
  sum: integer;
  strhex: string;
begin
  sum := 0;
  for i := 0 to len - 2 do
    sum := sum + old[i];

  sum := not (sum);
  strhex := IntToHex(sum, 2);
  m_byScmd[7] := StrToInt('$' + strhex) + 1;

end;

function TCallControl.OpenGF: boolean;
const
  OPEN_GF = 1 ;
var
  i,rst: integer;
begin
  Result := false;
  m_ptltype := ptTestGF;
  FixProtocol(OPEN_GF);
   //�򴮿�д����
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //д�ɹ������ȡ��������
  if (rst = 1) then
  begin
    Sleep(100);
    rst := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    if rst = 1 then
    begin
      if Length(m_byScmd) <> Length(m_byRcmd) then exit;
      for i := 0 to Length(m_byScmd) - 1 do
      begin
        if m_byScmd[i] <> m_byRcmd[i] then exit;       
      end;        
      Result := true;
    end;;
  end

end;

function TCallControl.OpenPort(const port: integer): integer;
  //���ܣ��򿪴���
  //����ֵ��1 ���ڴ򿪳ɹ�   >1���ڴ�ʧ�ܴ�����
var strcom: string;
begin
  m_nPort := port;
  strcom := 'COM' + IntToStr(m_nPort);
  begin
    try
      ComPort1.Port := strcom;
      ComPort1.Open();
    except
      on Err: Exception do
      begin
        Result := GetSerialErrCode(Err.Message);
        exit;
      end;
    end
  end;
  Result := 1;
end;

procedure TCallControl.AddLog(Tag: string; Data: array of byte);
var
  strTemp : string ;
  strText:string;
  i : Integer ;
begin
  strTemp := '';
  for I := 0 to Length(Data) - 1 do
  begin
    strTemp := strTemp + IntToStr(Data[i]);
  end;
  strText := Format('[%s--%s]',[Tag,strTemp]);
  TLog.SaveLog(Now,strText);

end;

procedure TCallControl.AnalysisCallMultiDevicesProtocol(var wdata: array of byte;
  var DevicesArray: RCallMultiDevicesArray);
const
  BEGIN_INDEX = 4 ;
var
  i,nIndex,nDeviceCount : Integer ;
begin
  Windows.OutputDebugString('AnalysisCallMultiDevicesProtocol__begin');
  nDeviceCount := Length(DevicesArray) ;
  for I := 0 to nDeviceCount - 1 do
  begin
    Windows.OutputDebugString('AnalysisCallMultiDevicesProtocol__111');
    nIndex :=  (i)*3  + BEGIN_INDEX  ;
    DevicesArray[i].idDst := MakeWord( wdata[ nIndex + 1] ,wdata[ nIndex + 0]) ;
    Windows.OutputDebugString('AnalysisCallMultiDevicesProtocol__222');
    DevicesArray[i].state := wdata[ nIndex + 2]  ;
    Windows.OutputDebugString('AnalysisCallMultiDevicesProtocol__333');
  end;
end;

procedure TCallControl.AnalysisSendDevicesInfoProtocol(var wdata: array of byte;
  var CallDevAry: TCallDevAry);
begin

end;

function TCallControl.CallDevice(const num: word): integer;
begin
  case m_nCallProtocolVer of
    cpRS232 : Result := CallDevice232(num) ;
    cpRS485 : Result := CallDevice485(num) ;
    else
    begin
      Result := CallDevice232(num) ;
    end;
  end;

end;

function TCallControl.CallDevice485(const num: word): integer;
//���ܣ����з����
const
  MAX_TRY_COUNT:integer=3;
var
  strTemp: string;
  i,j: Integer;
  devnum : word ;
begin
  //Э����װ
  m_ptltype := CALL;
  FixProtocol(num);
  //��ͨ����
  Result := WriteSerial(m_byScmd, sizeof(m_byScmd));
  {�ƣ�����������д����־}
  strTemp := '';
  for I := 0 to Length(m_byScmd) - 1 do
  begin
    strTemp := strTemp + IntToStr(m_byScmd[i]);
  end;
  TLog.SaveLog(Now,'���ͺ������' + strTemp);

  OutputDebugString(PChar(Format('--------------------------------------���ͺ�������:%d',[Result])));
  //д�ɹ������ȡ��������
  if (Result = 1) then
  begin
    for j := 0 to MAX_TRY_COUNT - 1 do
    begin
      Sleep(1*1000);
      Result := ReadSerialEx(m_byRcmd, sizeof(m_byRcmd),devnum);
      if Result  = 1 then
        break
      else
        Continue ;
    end;
    OutputDebugString(PChar(Format('--------------------------------------ȡ��������:%d',[Result])));
  end
end;

function TCallControl.CallMultiDevices(Src: RCallMultiDevicesArray): Boolean;
var
  pSendCmd: array of byte;
  pRecvCmd: array of byte ;
  nLen ,nRet : Integer ;
begin
  Result := False ;
  nLen :=  Length(Src) ;
  setLength(pSendCmd, 5 + Length(Src)*3 );
  setLength(pRecvCmd, 5 + Length(Src)*3 );
  ZeroMemory(@pSendCmd[0], Length(pSendCmd) );
  ZeroMemory(@pRecvCmd[0], Length(pRecvCmd) );
  //��װ����
  pSendCmd[0] := $AA;
  pSendCmd[1] := $55;
  pSendCmd[2] := $75;
  pSendCmd[3] := nLen;
  Windows.OutputDebugString('CreateCallMultiDevicesProtocol___');
  CreateCallMultiDevicesProtocol(pSendCmd,Src);
  //����ָ��
  Windows.OutputDebugString('CreateCallMultiDevicesProtocol___����ָ��');
  nRet := WriteSerial(pSendCmd, Length(pSendCmd));

  Sleep(3*100);
  Windows.OutputDebugString('CreateCallMultiDevicesProtocol___ComPort1.Read');
  nRet := ComPort1.Read(pRecvCmd[0], Length(pRecvCmd));
  Windows.OutputDebugString('CreateCallMultiDevicesProtocol___ComPort1.Read_ok');
  SendDataLog('������:',pRecvCmd);
  Windows.OutputDebugString('CreateCallMultiDevicesProtocol___ComPort1.Read_ok111');
  if nRet >0 then
  begin
    AnalysisCallMultiDevicesProtocol(pRecvCmd,Src);
    Result := True ;
  end;
end;

function TCallControl.CloseGF: boolean;
const
  CLOSE_GF = 2 ;
var
  i,rst: integer;
begin
  Result := false;
  m_ptltype := ptTestGF;
  FixProtocol(CLOSE_GF);
   //�򴮿�д����
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //д�ɹ������ȡ��������
  if (rst = 1) then
  begin
    Sleep(100);
    rst := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    if rst = 1 then
    begin
      if Length(m_byScmd) <> Length(m_byRcmd) then exit;
      for i := 0 to Length(m_byScmd) - 1 do
      begin
        if m_byScmd[i] <> m_byRcmd[i] then exit;       
      end;        
      Result := true;
    end;;
  end
end;

procedure TCallControl.ClosePort();
  //���ܣ��رմ���
begin
  ComPort1.Close();
end;

function TCallControl.ConfirmDeviceState(nDeviceID: Word;var BRet:Boolean): boolean;
var
  rst: integer;
begin
  Result := false;
  m_ptltype := QUERYCALL;
  try
    FixProtocol(nDeviceID);
    //�򴮿�д����
    rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
    OutputDebugString(PChar(Format('--------------------------------------���Ͳ�ѯ����:%d',[rst])));
    if (rst <> 1) then
    begin
      OutputDebugString(PChar(Format('--------------------------------------���Ͳ�ѯ����ʧ��:%d',[Result])));
      exit;
    end;
    //д�ɹ������ȡ��������
    Sleep(500);
    ZeroMemory(@m_byRcmd[0], Length(m_byRcmd));
    ComPort1.Read(m_byRcmd, sizeof(m_byRcmd));
    SendDataLog('������:',m_byRcmd);
    OutputDebugString(PChar(Format('--------------------------------------��ȡ��ѯ����سɹ�:%d',[m_byRcmd[5]])));
    if m_byRcmd[5] = 1  then    //1 ���гɹ�
    begin
      Result := true;
      BRet := True ;
      Exit ;
    end
    else  if m_byRcmd[5] = 4 then   //����ʧ�ܣ��ο�Э�飩
    begin
      Result := true;
      BRet := False ;
      Exit ;
    end
    else
    begin
      Result := False ;
      Exit ;
    end;
    
    Result := False;
  except

  end;
end;

function TCallControl.ConnectReverseCallDevice(nDevNum: Integer): integer;
//���ܣ����ӷ����豸
var
  strTemp: string;
  i: Integer;
begin
  //Э����װ
  m_ptltype := ptReverseCallConnect ;
  FixProtocol(nDevNum);
  //��ͨ����
  Result := WriteSerial(m_byScmd, sizeof(m_byScmd));
  {�ƣ�����������д����־}
  strTemp := '';
  for I := 0 to Length(m_byScmd) - 1 do
  begin
    strTemp := strTemp + IntToStr(m_byScmd[i]);
  end;
  TLog.SaveLog(Now,'���ͺ������' + strTemp);

  OutputDebugString(PChar(Format('--------------------------------------���ͺ�������:%d',[Result])));
  //д�ɹ������ȡ��������
  if (Result = 1) then
  begin
    Sleep(100);
    Result := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    OutputDebugString(PChar(Format('--------------------------------------ȡ��������:%d',[Result])));
  end
end;

function TCallControl.FindIDByRoom(RoomNumber: string; out num: word): Boolean;
//���ܣ���ѯ������豸��
var
  nRoomNmber:Word ;
  strTemp: string;
  iRet : Integer ;
begin
  Result := False ;
  //Э����װ
  nRoomNmber := StrToInt(RoomNumber);
  m_ptltype := ptQueryDeviceInfo ;
  FixProtocol(nRoomNmber);
  iRet := WriteSerial(m_byScmd, sizeof(m_byScmd));
  //д�ɹ������ȡ��������
  if ( iRet = 1 ) then
  begin
    Sleep(100);
    iRet := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    if (iRet = 1) then
    begin
    // 5,6λΪ���
      num := MakeWord(m_byRcmd[6], m_byRcmd[5]);
      Result := True;
    end;
  end
end;

procedure TCallControl.FixProtocol(const parm: word);
//���ܣ����߽а�Э����װ
begin
   //���Э�����ݲ���
  ZeroMemory(@m_byScmd[2], Length(m_byScmd) - 2);
  case m_ptltype of
    SETCALLNUM:
      begin
        m_byScmd[2] := $58;
        m_byScmd[3] := HIBYTE(parm);
        m_byScmd[4] := LOBYTE(parm);
      end;
    GETCALLNUM:
      begin
        m_byScmd[2] := $59;
      end;
    CALL:
      begin
        m_byScmd[2] := $60;
        m_byScmd[3] := HIBYTE(parm);
        m_byScmd[4] := LOBYTE(parm);
      end;
    QUERYCALL:
      begin
        m_byScmd[2] := $61;
        m_byScmd[3] := HIBYTE(parm);
        m_byScmd[4] := LOBYTE(parm);
      end;
    HANG:
      begin
        m_byScmd[2] := $62;
        m_byScmd[3] := HIBYTE(parm);
        m_byScmd[4] := LOBYTE(parm);
      end;
    SELECT_TYPE:
      begin
        m_byScmd[2] := $63;
        m_byScmd[3] := parm;
        m_byScmd[4] := 0;
      end;
     ptReset:
      begin
        m_byScmd[2] := $64;
        m_byScmd[3] := 0;
        m_byScmd[4] := 0;
      end;
      ptRecordEx:
      begin
        m_byScmd[2] := $65;
        m_byScmd[3] := parm;
        m_byScmd[4] := 0;
      end;
      ptPlayEx:
      begin
        m_byScmd[2] := $66;
        m_byScmd[3] := parm;
        m_byScmd[4] := 0;
      end;

      ptTestGF :
      begin
        m_byScmd[2] := $70;
        m_byScmd[3] := parm;
        m_byScmd[4] := 0;
      end;

      ptSetRoomCount:
      begin
        m_byScmd[2] := $71;
        m_byScmd[3] := HIBYTE(parm);
        m_byScmd[4] := LOBYTE(parm);
      end;

      {�����豸}
      ptMonitorDevice:
      begin
        m_byScmd[2] := $74;
        m_byScmd[3] := HIBYTE(parm);
        m_byScmd[4] := LOBYTE(parm);
      end;

      ptQueryDeviceInfo :
      begin
        m_byScmd[2] := $77;
        m_byScmd[3] := HIBYTE(parm);
        m_byScmd[4] := LOBYTE(parm);
      end;

      {������ѯ}
      ptReverseCallQuery :
      begin
        m_byScmd[2] := $56;
        m_byScmd[3] := 0;
        m_byScmd[4] := 0;
      end;
      {��������}
      ptReverseCallConnect :
      begin
        m_byScmd[2] := $57;
        m_byScmd[3] := 1;
        m_byScmd[4] := HIBYTE(parm);
        m_byScmd[5] := LOBYTE(parm);
      end;
      {�����ܽ�}
      ptReverseCallRefuse :
      begin
        m_byScmd[2] := $57;
        m_byScmd[3] := 2;
        m_byScmd[4] := HIBYTE(parm);
        m_byScmd[5] := LOBYTE(parm);
      end;
  end;
    //
  TCRC(m_byScmd, sizeof(m_byScmd));

end;

function TCallControl.WriteSerial(const wdata: array of byte; const len: integer)
  : integer;
//���ܣ�д��������
//����ֵ��1 д�ɹ� ��>1 �˿ڴ�����
begin
  try
    SendDataLog('������:',wdata);
    ComPort1.ClearBuffer(True,TRUe);
    ComPort1.Write(wdata, sizeof(wdata));
  except
    on Err: Exception do
    begin
      Result := GetSerialErrCode(Err.Message);
      exit;
    end;

  end;
  Result := 1;
end;

function TCallControl.ReadSerial(var wdata: array of byte; const len: integer; var num: word): integer;
//���ܣ�����������
//����ֵ��1 ��ȡ���ݳɹ�  >1 ������ʧ�ܴ�����
var rst: integer;

begin
  rst := ComPort1.Read(wdata, len);
  SendDataLog('������:',wdata);

  if rst = sizeof(wdata) then
  begin
    num := makeword(wdata[4], wdata[3]); //�����
    case wdata[2] of
      $61:
        begin
          if num = 0 then
          begin
            Result := 1;
          end
          else
            Result := wdata[5]; //
        end; //end if
    else
      Result := 1;
    end; //end case
  end
  else
    Result := -1; //

end;

function TCallControl.ReadReverseCall(var num: word): Boolean;
const
  HAVE_REVERSECALL:Byte = 1;
var
  iRet : Integer ;
  strText:string;
begin
  Result := False ;

  iRet := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
  if (iRet = 1) then
  begin
    Windows.OutputDebugString('TCallControl.ReadReverseCall');
    AddLog('�����в�ѯ',m_byRcmd);
    if m_byRcmd[3] = HAVE_REVERSECALL then
    begin
    // 4,5λΪ���
      num := MakeWord(m_byRcmd[5], m_byRcmd[4]);
      Result := True;
    end;
  end;
end;

function TCallControl.ReadSerial(var wdata: array of byte;
  const len: integer): Integer;
//���ܣ�����������
//����ֵ��1 ��ȡ���ݳɹ�  >1 ������ʧ�ܴ�����
var
  rst: integer;
begin
  Result := -1; //
  rst := ComPort1.Read(wdata, len);
  SendDataLog('������:',wdata);
  if rst = sizeof(wdata) then
  begin
    Result := 1;
  end;
end;

function TCallControl.ReadSerialEx(var wdata: array of byte; const len: integer;
  var num: word): integer;
//���ܣ�����������
//����ֵ��1 ��ȡ���ݳɹ�  >1 ������ʧ�ܴ�����
var rst: integer;

begin
  rst := ComPort1.Read(wdata, len);
  SendDataLog('������:',wdata);
  if rst = sizeof(wdata) then
  begin
    num := makeword(wdata[4], wdata[3]); //�����
    case wdata[2] of
      $61:   // ���в�ѯ
        begin
          Result := wdata[5];
        end;
      $62:
        begin
          if wdata[5] = Ord(ctHangUp) then
            Result := 1 
          else
            Result := -1 ;
        end; //end if
    else
      Result := 1;
    end; //end case
  end
  else
    Result := -1; //
end;

function TCallControl.RefuseReverseCallDevice(nDevNum: Integer): integer;
//���ܣ����ӷ����豸
var
  strTemp: string;
  i: Integer;
begin
  //Э����װ
  m_ptltype := ptReverseCallRefuse ;
  FixProtocol(nDevNum);
  //��ͨ����
  Result := WriteSerial(m_byScmd, sizeof(m_byScmd));
  {�ƣ�����������д����־}
  strTemp := '';
  for I := 0 to Length(m_byScmd) - 1 do
  begin
    strTemp := strTemp + IntToStr(m_byScmd[i]);
  end;
  TLog.SaveLog(Now,'���ͺ������' + strTemp);

  OutputDebugString(PChar(Format('--------------------------------------���ͺ�������:%d',[Result])));
  //д�ɹ������ȡ��������
  if (Result = 1) then
  begin
    Sleep(100);
    Result := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    OutputDebugString(PChar(Format('--------------------------------------ȡ��������:%d',[Result])));
  end
end;

function TCallControl.Reset: integer;
var
  rst: integer;
  devnum : word ;
begin
   //Э����װ
  m_ptltype := ptReset;
  FixProtocol(RESVERED_BYTE);
  //�򴮿�д����
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));

      //д�ɹ������ȡ��������
  if (rst = 1) then
  begin
    Sleep(100);
    Result := ReadSerial(m_byRcmd, sizeof(m_byRcmd),devnum);
  end
  else begin
    Result := rst;
  end;
end;

function TCallControl.ReverseCallDevice(out num: word): Boolean;
//���ܣ������豸
var
  strTemp: string;
  iRet : Integer ;
begin
  Result := False ;
  //Э����װ
  m_ptltype := ptReverseCallQuery ;
  FixProtocol(RESVERED_BYTE);
  //����Ƿ��з�������
  iRet := WriteSerial(m_byScmd, sizeof(m_byScmd));
  //д�ɹ������ȡ��������
  if ( iRet = 1 ) then
  begin
    Sleep(100);
    Result := ReadReverseCall(num);
  end
end;

function TCallControl.GetSerialErrCode(strerr: string): integer;
var idx: integer;
begin
  idx := Pos('code:', strerr);
  strerr := LeftStr(strerr, Length(strerr) - Length(')'));
  Result := StrToInt(RightStr(strerr, Length(strerr) - idx - Length('code:')));
end;


end.

