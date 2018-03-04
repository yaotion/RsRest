unit uCallControl;
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////

//类名: TCallControl

//描述：用于控制无线叫班系统

//1、通信采用:
//              RS232串口通信方式，
//              波特率9600，
//              数据位8，
//              停止位1，
//              无校验。
//              每帧定长8字节，
//              16进制。
//
//2、采用末字节校验和方式， 即末字节 = 前7个字节之和取补码。
//
//3、上位机软件设置房间与设备对照表，上位机呼叫房间时以设备号形式向下位机发送，默认2字节，高字节在前，低
//      字节在后。如房间与设备对照表变更，需更改设备号或配置对照表使房间号与设备号一致。
//      即上位机与下位机通信均为设备号，房间号只在上位机软件上显示。
//
//4、  上位机发送，每帧数据均以0xaa，0x55开头。下位机返回，每帧数据均以0xaa，0x55开头，其余原数据返回。
//  发送和返回的数据第3字节为参数位：
//   0x58：从机设备号设置             0x59：从机设备号查询                 0x60：呼叫设备号
//   0x61：呼叫设备号查询             0x62：挂断电话                       0x63：拨号方式选择
//   0x64：复位对讲模块               0x65：录音切换                       0x66：放音切换
//   0x70：功放开关命令
//
//5、拨号方式有两种：一是电脑直接发DTMF音频信号；二是电脑发出拨号命令，由硬件发出DTMF音频信号
//   有效音频信号为 7字节 BYTE0 为包头、BYTE6 为包尾，中间5字节为房间号。 包头= 音效“c”；包尾= “#”。
//   保留旧版本 包头音效 “*” 适用于北京西公寓 。
//
//6、所有预留字节：0x00。

////////////////////////////////////////////////////////////////////////////////

interface

uses SysUtils, CPort, StrUtils, Windows,uLogs,uTFSystem,uRoomCall;

const
  RESVERED_BYTE = 0 ;
type

  {呼叫设备}
  RCallMultiDevices = record
    idSrc :Word;        //发送设备编号
    idDst :Word;        //接受设备编号
    state:Byte;        //设备状态
    roomnumber:string;  //房间编号
  end;

   RCallMultiDevicesArray = array of  RCallMultiDevices;


  TCallProtocol = (cpRS232{232协议},cpRS485{485协议});
  ///呼叫状态
  TCallStatus = (ctNil{空} ,ctCallSuccess{呼叫成功},ctHangUp,ctCalling{呼叫中});

  TCallControl = class
  public
    constructor Create(CallProtocolVer :TCallProtocol=cpRS485);
    destructor Destroy(); override;
  public
    //设置协议版本
    function GetCallProtocol():TCallProtocol;
    procedure SetCallProtocol(CallProtocolVer :TCallProtocol);
    //发送读取到或者写入的数据
    procedure SendDataLog(Tag:string;Data: array of byte);
  public
    {功能：呼叫设备外壳}
    function CallDevice(const num: word): integer;
    {功能：挂断设备外壳}
    function HangUp(const num: word): integer;
    {功能：设置房间数量}
    function SetRoomCount(const num:Word):Integer;
    {功能：监听设备}
    function MonitorDevice(const num: word): integer;
    {功能：  反呼叫设备外壳}
    function ReverseCallDevice(out num: word): Boolean;
    {功能：  联通反呼叫设备外壳}
    function  ConnectReverseCallDevice(nDevNum:Integer):integer;
    {功能：  拒接反呼叫设备外壳}
    function  RefuseReverseCallDevice(nDevNum:Integer):integer;
    {功能 ：呼叫多个设备}
    function CallMultiDevices(Src:RCallMultiDevicesArray):Boolean;
    {功能 ：查询呼叫的多个设备状态}
    function QueryMultiDevices(Src:RCallMultiDevicesArray):Boolean;
    {功能 : 发送房间信息}
    function SendRoomDeviceInfoList(CallDevAry:TCallDevAry):BOOL;
    {功能 :向叫班主机发送房间信息}
    function SendRoomDeviceInfo(TotalFrame,CurrentFrame,CurrentCount:Integer;CallDevAry:TCallDevAry):Boolean;
        {功能：查询房间对应设备号}
    function FindIDByRoom(RoomNumber:string;out num: word): Boolean;
  public
    {功能：呼叫设备485}
    function CallDevice485(const num: word): integer;
    {功能：挂断新版需要查询485}
    function HangUp485(const num: word): integer;
    {功能：挂断所有的设备}
    function HangUpAll(): integer; deprecated ;
  private
      {功能：新版本的读取函数}
    function ReadSerialEx(var wdata: array of byte; const len: integer; var num: word): integer;
      {功能：读取反呼结果}
    function ReadReverseCall(var num: word): Boolean;
    {功能： 多叫协议组装}
    procedure CreateCallMultiDevicesProtocol(var wdata: array of byte;DevicesArray:RCallMultiDevicesArray);
    {功能：多叫协议拆解}
    procedure AnalysisCallMultiDevicesProtocol(var wdata: array of byte;var DevicesArray:RCallMultiDevicesArray);


    {功能： 叫班设备信息，协议组装}
    procedure CreateSendDevicesInfoProtocol(var wdata: array of byte;CurrentCount,CurrentFrame: Integer; CallDevAry: TCallDevAry);
    {功能：叫班设备信息，拆解}
    procedure AnalysisSendDevicesInfoProtocol(var wdata: array of byte;var CallDevAry: TCallDevAry);
  public
    {功能：打开串口}
    function OpenPort(const port: integer): integer;
    {功能：关闭串口}
    procedure ClosePort();
    {功能：设置从机设备号}
    function SetDeviceNum(const num: word): integer;
    {功能：获取从机设备号}
    function GetDeviceNum(var devnum: word): integer;
    {功能：连接设备}
    function CallDevice232(const num: word): integer;
    {功能：查询呼叫设备号}
    function QueryCallDevState(var devnum: word): integer;
    //查询设备状态
    function QueryDeviceState(nDeviceID : Word) : boolean;
    //确定设备状态
    function ConfirmDeviceState(nDeviceID : Word;var BRet:Boolean) : boolean;
    {功能：挂断}
    function HangUp232(const num: word): integer;
    {功能：发射器模块复位}
    function Reset() : integer;
    {功能：拨号方式选择}
    function SetDialType(const typeID : word) : Integer;
    {功能：获取录音模式}
    function GetRecordMode():Integer;
    {功能：设置录音模式选择}
    function SetRecordMode(Mode : Word) : boolean;
    {功能：获取放音模式}
    function GetPlayMode() : Integer;
    {功能：设置放音模式}
    function SetPlayMode(Mode : Word) : boolean;
    //打开攻放
    function OpenGF() : boolean;
    //关闭攻放
    function CloseGF() : boolean;
  private
    function GetProtocol(PType:Byte):string;
    {功能：添加日志}
    procedure AddLog(Tag:string;Data: array of byte);
    {功能：产生日志}
    function CreateDataLog(Tag:string;Data: array of byte):string;
    {功能：CRC校验}
    procedure TCRC(old: array of byte; const len: Integer);
    {功能：获取CRC校验}
    function GetCrc(src:array of byte):Byte;
    {功能：无线叫班协议组装}
    procedure FixProtocol(const parm: word = 0);
    function WriteSerial(const wdata: array of byte; const len: integer): integer;
    function ReadSerial(var wdata: array of byte; const len: integer; var num: word): integer;overload;
    function ReadSerial(var wdata: array of byte; const len: integer):Integer;overload;
    function GetSerialErrCode(strerr: string): integer;
  private
    m_OnLogEvent : TOnEventByString ;   //数据日志
  private
    ComPort1: TComPort;
    {连接的串口号}
    m_nPort: integer;
    {波特率}
    m_nBand: integer;
    {上位机发送命令}
    m_byScmd: array[0..7] of byte;
    {下位机返回指令}
    m_byRcmd: array[0..7] of byte;
      {协议版本}
    m_nCallProtocolVer :TCallProtocol ;
    {协议类型}
    type protocol = (SETCALLNUM, GETCALLNUM, CALL, QUERYCALL, HANG,SELECT_TYPE,ptReset,ptRecordEx,ptPlayEx,ptTestGF,
      ptSetRoomCount{房间数量},ptMonitorDevice{监听},
      ptReverseCallQuery{反呼查询},ptReverseCallConnect{反呼操作接听},ptReverseCallRefuse{反呼操作拒接},
      ptQueryDeviceInfo{查询设备信息});
    {当前命令}
    var  m_ptltype: protocol;
  public
    property  LogEvent:TOnEventByString read m_OnLogEvent write m_OnLogEvent ;
  end;

implementation

uses
  Math;

constructor TCallControl.Create(CallProtocolVer :TCallProtocol=cpRS485);
  //功能：初始化成员变量，创建串口对象
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
  例如： 1201房间  编号333，,1201=0x04B1   333=0x014D  数组顺序 0x04 0xb1  0x01 0x4D
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
    //功能：关闭串口
begin
  if ComPort1.Connected = FALSE then
    ComPort1.Close();
  m_nPort := -1;
  if Assigned(ComPort1) then
   FreeAndNil(ComPort1);
end;

function TCallControl.SetDialType(const typeID: word): Integer;
 //功能：选择通讯模式(1：串口;2音乐)
 //返回值：1 呼叫设备成功  >1 呼叫失败错误码
var rst: integer;
    devnum: word;
begin
  //485里面不需要设置通讯模式
  if m_nCallProtocolVer = cpRS485 then
  begin
    Result := 1 ;
    Exit ;
  end;

  m_ptltype := SELECT_TYPE;
  FixProtocol(typeID);

  //向串口写数据
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));

        //写成功，则读取串口数据
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
   //功能：从机房间号设置
   //参数：num 从机房间号

var rst: integer;
    devnum: word;
begin

   //协议组装
  m_ptltype := SETCALLNUM;
  FixProtocol(num);

   //向串口写数据
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));

   //写成功，则读取串口数据
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
{16个一帧，不够合成一帧}
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
  //组装数据
  pSendCmd[0] := $AA;
  pSendCmd[1] := $55;
  pSendCmd[2] := $72;

  //总共几帧
  pSendCmd[3] := HiByte(TotalFrame);
  pSendCmd[4] := LoByte(TotalFrame);
  //当前帧
  pSendCmd[5] := HiByte(CurrentFrame);
  pSendCmd[6] := LoByte(CurrentFrame);
  //当前个数
  pSendCmd[7] := Byte(CurrentCount);
  CreateSendDevicesInfoProtocol(pSendCmd,CurrentCount,CurrentFrame,CallDevAry);
  //发送指令
  nRet := WriteSerial(pSendCmd, sizeof(pSendCmd));
  if nRet = 1 then
  begin
    Sleep(1*1000);
    nRet := ComPort1.Read(pRecvCmd, SizeOf(pRecvCmd));
    SendDataLog('读数据:',pRecvCmd);
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
   //向串口写数据
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //写成功，则读取串口数据
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
   //向串口写数据
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //写成功，则读取串口数据
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
   //协议组装
  m_ptltype := ptSetRoomCount;
  FixProtocol(num);
  //向串口写数据
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));

    //写成功，则读取串口数据
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
   //功能：从机房间号查询
   //
var rst: integer;
begin
     //协议组装
  m_ptltype := GETCALLNUM;
  FixProtocol(RESVERED_BYTE);
   //向串口写数据
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));

   //写成功，则读取串口数据
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
   //向串口写数据
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //写成功，则读取串口数据
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
      strText := '反呼叫查询 ';
    $57:
      strText := '反呼叫接听';
    $58:
      strText := '从机设备号设置';
    $59:
      strText := '从机设备号查询';
    $60:
      strText := '呼叫1设备号';
    $61:
      strText := '呼叫设备号查询 ';
    $62:
      strText := '挂断电话';
    $63:
      strText := ' 拨号方式选择 ';
    $64:
      strText := '复位对讲模块 ';
    $65:
      strText := '录音切换';
    $66:
      strText := '放音切换  ';
    $70:
      strText := '功放开关命令 ';
    $71:
      strText := '房间信息设置 ';
    $72:
      strText := '房间设备号对照表 ';
    $73:
      strText := ' 房间状态查询 ';
    $74:
      strText := ' 房间监听 ';
    $75:
      strText := ' 呼叫多个设备号 ';
    $76:
      strText := ' 呼叫多个设备号查询 ';
    $77:
      strText := ' 房间设备号查询 ';
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
   //向串口写数据
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //写成功，则读取串口数据
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
//功能：连接设备
var
  strTemp: string;
  i: Integer;
begin
  //协议组装
  m_ptltype := CALL;
  FixProtocol(num);
  //接通命令
  Result := WriteSerial(m_byScmd, sizeof(m_byScmd));
  {闫，将发送命令写入日志}
  strTemp := '';
  for I := 0 to Length(m_byScmd) - 1 do
  begin
    strTemp := strTemp + IntToStr(m_byScmd[i]);
  end;
  TLog.SaveLog(Now,'发送呼叫命令：' + strTemp);

  OutputDebugString(PChar(Format('--------------------------------------发送呼叫命令:%d',[Result])));
  //写成功，则读取串口数据
  if (Result = 1) then
  begin
    Sleep(100);
    Result := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    OutputDebugString(PChar(Format('--------------------------------------取呼叫命令:%d',[Result])));
  end
end;

function TCallControl.QueryCallDevState(var devnum: word): integer;
//查询呼叫设备号
//参数：devnum = 0 无设备呼叫
//返回值: 1: 2: 3:
var rst: integer;
begin
  //协议组装
  m_ptltype := QUERYCALL;
  FixProtocol(devnum);

   //向串口写数据
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //写成功，则读取串口数据
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
    //向串口写数据
    rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
    OutputDebugString(PChar(Format('--------------------------------------发送查询命令:%d',[rst])));
    if (rst <> 1) then
    begin
      OutputDebugString(PChar(Format('--------------------------------------发送查询命令失败:%d',[Result])));
      exit;
    end;
    //写成功，则读取串口数据
    Sleep(500);
    ZeroMemory(@m_byRcmd[0], Length(m_byRcmd));
    ComPort1.Read(m_byRcmd, sizeof(m_byRcmd));
    SendDataLog('读数据:',m_byRcmd);
    OutputDebugString(PChar(Format('--------------------------------------读取查询命令返回成功:%d',[m_byRcmd[5]])));
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
  //组装数据
  pSendCmd[0] := $AA;
  pSendCmd[1] := $55;
  pSendCmd[2] := $76;
  pSendCmd[3] := nLen;
  CreateCallMultiDevicesProtocol(pSendCmd,Src);
  //发送指令
  nRet := WriteSerial(pSendCmd, Length(pSendCmd));

  Sleep(1*1000);
  nRet := ComPort1.Read(pRecvCmd[0], Length(pRecvCmd));
  SendDataLog('读数据:',pRecvCmd);
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
 //功能：挂机
 //返回值：1 呼叫设备成功  >1 呼叫失败错误码
var
  rst: integer;
  devnum : word ;
begin
   //协议组装
  m_ptltype := HANG;
  FixProtocol(num);
  //向串口写数据
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));

    //写成功，则读取串口数据
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
 //功能：挂机
 //返回值：1 呼叫设备成功  >1 呼叫失败错误码
const
  MAX_TRY_COUNT:INTEGER = 3 ;
var
  i : integer ;
  rst: integer;
  devnum : word ;
begin

  devnum := 0 ;

   //协议组装
  m_ptltype := HANG;
  FixProtocol(num);

  //向串口写数据
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));

  //写成功，则读取串口数据
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

   //协议组装
  m_ptltype := ptMonitorDevice;
  FixProtocol(num);

   //向串口写数据
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));

   //写成功，则读取串口数据
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
   //向串口写数据
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //写成功，则读取串口数据
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
  //功能：打开串口
  //返回值：1 串口打开成功   >1串口打开失败错误码
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
//功能：呼叫房间号
const
  MAX_TRY_COUNT:integer=3;
var
  strTemp: string;
  i,j: Integer;
  devnum : word ;
begin
  //协议组装
  m_ptltype := CALL;
  FixProtocol(num);
  //接通命令
  Result := WriteSerial(m_byScmd, sizeof(m_byScmd));
  {闫，将发送命令写入日志}
  strTemp := '';
  for I := 0 to Length(m_byScmd) - 1 do
  begin
    strTemp := strTemp + IntToStr(m_byScmd[i]);
  end;
  TLog.SaveLog(Now,'发送呼叫命令：' + strTemp);

  OutputDebugString(PChar(Format('--------------------------------------发送呼叫命令:%d',[Result])));
  //写成功，则读取串口数据
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
    OutputDebugString(PChar(Format('--------------------------------------取呼叫命令:%d',[Result])));
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
  //组装数据
  pSendCmd[0] := $AA;
  pSendCmd[1] := $55;
  pSendCmd[2] := $75;
  pSendCmd[3] := nLen;
  Windows.OutputDebugString('CreateCallMultiDevicesProtocol___');
  CreateCallMultiDevicesProtocol(pSendCmd,Src);
  //发送指令
  Windows.OutputDebugString('CreateCallMultiDevicesProtocol___发送指令');
  nRet := WriteSerial(pSendCmd, Length(pSendCmd));

  Sleep(3*100);
  Windows.OutputDebugString('CreateCallMultiDevicesProtocol___ComPort1.Read');
  nRet := ComPort1.Read(pRecvCmd[0], Length(pRecvCmd));
  Windows.OutputDebugString('CreateCallMultiDevicesProtocol___ComPort1.Read_ok');
  SendDataLog('读数据:',pRecvCmd);
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
   //向串口写数据
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //写成功，则读取串口数据
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
  //功能：关闭串口
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
    //向串口写数据
    rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
    OutputDebugString(PChar(Format('--------------------------------------发送查询命令:%d',[rst])));
    if (rst <> 1) then
    begin
      OutputDebugString(PChar(Format('--------------------------------------发送查询命令失败:%d',[Result])));
      exit;
    end;
    //写成功，则读取串口数据
    Sleep(500);
    ZeroMemory(@m_byRcmd[0], Length(m_byRcmd));
    ComPort1.Read(m_byRcmd, sizeof(m_byRcmd));
    SendDataLog('读数据:',m_byRcmd);
    OutputDebugString(PChar(Format('--------------------------------------读取查询命令返回成功:%d',[m_byRcmd[5]])));
    if m_byRcmd[5] = 1  then    //1 呼叫成功
    begin
      Result := true;
      BRet := True ;
      Exit ;
    end
    else  if m_byRcmd[5] = 4 then   //呼叫失败（参看协议）
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
//功能：连接反呼设备
var
  strTemp: string;
  i: Integer;
begin
  //协议组装
  m_ptltype := ptReverseCallConnect ;
  FixProtocol(nDevNum);
  //接通命令
  Result := WriteSerial(m_byScmd, sizeof(m_byScmd));
  {闫，将发送命令写入日志}
  strTemp := '';
  for I := 0 to Length(m_byScmd) - 1 do
  begin
    strTemp := strTemp + IntToStr(m_byScmd[i]);
  end;
  TLog.SaveLog(Now,'发送呼叫命令：' + strTemp);

  OutputDebugString(PChar(Format('--------------------------------------发送呼叫命令:%d',[Result])));
  //写成功，则读取串口数据
  if (Result = 1) then
  begin
    Sleep(100);
    Result := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    OutputDebugString(PChar(Format('--------------------------------------取呼叫命令:%d',[Result])));
  end
end;

function TCallControl.FindIDByRoom(RoomNumber: string; out num: word): Boolean;
//功能：查询房间的设备号
var
  nRoomNmber:Word ;
  strTemp: string;
  iRet : Integer ;
begin
  Result := False ;
  //协议组装
  nRoomNmber := StrToInt(RoomNumber);
  m_ptltype := ptQueryDeviceInfo ;
  FixProtocol(nRoomNmber);
  iRet := WriteSerial(m_byScmd, sizeof(m_byScmd));
  //写成功，则读取串口数据
  if ( iRet = 1 ) then
  begin
    Sleep(100);
    iRet := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    if (iRet = 1) then
    begin
    // 5,6位为结果
      num := MakeWord(m_byRcmd[6], m_byRcmd[5]);
      Result := True;
    end;
  end
end;

procedure TCallControl.FixProtocol(const parm: word);
//功能：无线叫班协议组装
begin
   //清空协议内容部分
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

      {监听设备}
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

      {反呼查询}
      ptReverseCallQuery :
      begin
        m_byScmd[2] := $56;
        m_byScmd[3] := 0;
        m_byScmd[4] := 0;
      end;
      {反呼接听}
      ptReverseCallConnect :
      begin
        m_byScmd[2] := $57;
        m_byScmd[3] := 1;
        m_byScmd[4] := HIBYTE(parm);
        m_byScmd[5] := LOBYTE(parm);
      end;
      {反呼拒接}
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
//功能：写串口数据
//返回值：1 写成功 ；>1 端口错误码
begin
  try
    SendDataLog('发数据:',wdata);
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
//功能：读串口数据
//返回值：1 读取数据成功  >1 读数据失败错误码
var rst: integer;

begin
  rst := ComPort1.Read(wdata, len);
  SendDataLog('读数据:',wdata);

  if rst = sizeof(wdata) then
  begin
    num := makeword(wdata[4], wdata[3]); //房间号
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
    AddLog('反呼叫查询',m_byRcmd);
    if m_byRcmd[3] = HAVE_REVERSECALL then
    begin
    // 4,5位为结果
      num := MakeWord(m_byRcmd[5], m_byRcmd[4]);
      Result := True;
    end;
  end;
end;

function TCallControl.ReadSerial(var wdata: array of byte;
  const len: integer): Integer;
//功能：读串口数据
//返回值：1 读取数据成功  >1 读数据失败错误码
var
  rst: integer;
begin
  Result := -1; //
  rst := ComPort1.Read(wdata, len);
  SendDataLog('读数据:',wdata);
  if rst = sizeof(wdata) then
  begin
    Result := 1;
  end;
end;

function TCallControl.ReadSerialEx(var wdata: array of byte; const len: integer;
  var num: word): integer;
//功能：读串口数据
//返回值：1 读取数据成功  >1 读数据失败错误码
var rst: integer;

begin
  rst := ComPort1.Read(wdata, len);
  SendDataLog('读数据:',wdata);
  if rst = sizeof(wdata) then
  begin
    num := makeword(wdata[4], wdata[3]); //房间号
    case wdata[2] of
      $61:   // 呼叫查询
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
//功能：连接反呼设备
var
  strTemp: string;
  i: Integer;
begin
  //协议组装
  m_ptltype := ptReverseCallRefuse ;
  FixProtocol(nDevNum);
  //接通命令
  Result := WriteSerial(m_byScmd, sizeof(m_byScmd));
  {闫，将发送命令写入日志}
  strTemp := '';
  for I := 0 to Length(m_byScmd) - 1 do
  begin
    strTemp := strTemp + IntToStr(m_byScmd[i]);
  end;
  TLog.SaveLog(Now,'发送呼叫命令：' + strTemp);

  OutputDebugString(PChar(Format('--------------------------------------发送呼叫命令:%d',[Result])));
  //写成功，则读取串口数据
  if (Result = 1) then
  begin
    Sleep(100);
    Result := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    OutputDebugString(PChar(Format('--------------------------------------取呼叫命令:%d',[Result])));
  end
end;

function TCallControl.Reset: integer;
var
  rst: integer;
  devnum : word ;
begin
   //协议组装
  m_ptltype := ptReset;
  FixProtocol(RESVERED_BYTE);
  //向串口写数据
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));

      //写成功，则读取串口数据
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
//功能：反呼设备
var
  strTemp: string;
  iRet : Integer ;
begin
  Result := False ;
  //协议组装
  m_ptltype := ptReverseCallQuery ;
  FixProtocol(RESVERED_BYTE);
  //检查是否有反呼房间
  iRet := WriteSerial(m_byScmd, sizeof(m_byScmd));
  //写成功，则读取串口数据
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

