unit uFrmReverseCallManager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,uTFSystem,uRoomCallApp,uRoomCall,uCallRoomFunIF, StdCtrls, ExtCtrls,
  RzPanel;

const

  NO_DEVICE_NUMBER = -1 ;

  WM_CHECK_CALL_SUCCESS = WM_USER+10;     //检测消息
  WM_CHECK_CALL_CANCEL = WM_USER+11;      //取消消息

  CHECK_CALL_INTERVAL = 5 * 1000 ;       //检测间隔 5秒钟左右

type
  ///反呼检测线程
  ///
  ///  如果正在呼叫，则不进行检测反呼
  ///  如果现在是空闲的，检索的反呼信号后，下位机清空一下反呼信息
  ///
  TCheckReverseCallThread = class(TThread)
  public
    constructor Create(Handle:THandle);
  protected
    procedure Execute; override;
        {停止}
    procedure Stop();
    {功能:延时}
    procedure Delay(ms: Cardinal);
    {添加日志}
    procedure InsertLog(Text:String);
  public
    procedure SetLogEvent(OnEventByString:TOnEventByString);
  private
    m_RoomCallApp : TRoomCallApp ;  //检测是否有呼叫
    m_Handle:       THandle;        //消息句柄
        m_bIsStop:      Boolean ;       //暂停标记
    m_OnLogEvent : TOnEventByString ;
  end;

//==============================================================================
// 检测反呼窗体
//==============================================================================

  TFrmReverseCallManager = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    {检测消息}
    procedure CheckWndProc(var Message : TMessage);
    {功能：是否联通该房间}
    function  ConnectReverseCall(nDevNum:Integer):Boolean;
        {功能：取消联通该房间}
    function  CancelReverseCall(nDevNum:Integer):Boolean;
    {功能:反呼叫班回调事件}
    procedure FinishReverseCallEvent(bSucess:Boolean; data:TCallDevCallBackData);
    {功能：添加LOG}
    procedure AddLog(Log:string);
  private
    m_nRecvDev:Integer ; //接收到的设备号
    m_hMessageWnd : THandle ;                   //消息句柄(用窗体本身的句柄有问题，所以单独创建了一个)
    m_CheckThread:  TCheckReverseCallThread;    //检测线程
    m_RoomCallApp : TRoomCallApp ;              //检测是否正在呼叫
  public
    { Public declarations }
  end;

var
  FrmReverseCallManager: TFrmReverseCallManager;

implementation
uses
  uGlobalDM ,uSaftyEnum,uFrmMain_RoomSign;

{$R *.dfm}

procedure TFrmReverseCallManager.AddLog(Log: string);
begin
  ;
end;


function TFrmReverseCallManager.ConnectReverseCall(nDevNum: Integer): Boolean;
var
  strText:string;
  roomDev:RCallDev;
  callrecord :TcallRoomRecord;
  dtNow:TDateTime;
begin
  result := False;
  dtNow := GlobalDM.GetNow;

  if m_RoomCallApp.CallDevOp.bCalling = False then
  begin
    if m_RoomCallApp.DBCallDev.FindByDev(nDevNum,roomDev) then
    begin
      callrecord :=TcallRoomRecord.Create;
      //callrecord.Init( callPlan,GlobalDM.GetNow);
      callrecord.strRoomNum := roomDev.strRoomNum ;
      callrecord.nDeviceID := nDevNum;
      callrecord.eCallType := TCT_ReverseCall;
      callrecord.eCallState := TCS_FIRSTCALL;
      callrecord.strTrainNo := '' ;
      try

        if not TCallRoomFunIF.GetInstance.bCallling then
        begin
          strText := Format('[反呼]:设备号:[%d]--房间号:[%s]',[roomDev.nDevNum,roomDev.strRoomNum]);
          GlobalDM.LogManage.InsertLog(strText);

          m_nRecvDev := nDevNum ;
          TCallRoomFunIF.GetInstance.ReverseCall_InsertFrm(FrmMain_RoomSign.pnlCallWork,callrecord,FinishReverseCallEvent);
          Result := True ;
        end;
      finally
        callrecord.Free;
      end;
    end;
  end;

end;



procedure TFrmReverseCallManager.FinishReverseCallEvent(bSucess: Boolean;
  data: TCallDevCallBackData);
begin

end;

procedure TFrmReverseCallManager.FormCreate(Sender: TObject);
begin
  m_nRecvDev := NO_DEVICE_NUMBER ;
  m_hMessageWnd := Classes.AllocateHWnd(CheckWndProc);
  m_RoomCallApp := TRoomCallApp.GetInstance;
  m_CheckThread :=  TCheckReverseCallThread.Create(m_hMessageWnd);
end;

procedure TFrmReverseCallManager.FormDestroy(Sender: TObject);
begin
  m_CheckThread.Stop;
  m_CheckThread.Terminate;
  m_CheckThread.Free ;
  DeallocateHWnd(m_hMessageWnd);
end;

function TFrmReverseCallManager.CancelReverseCall(nDevNum: Integer): Boolean;
begin
    //取消反呼叫
    TCallRoomFunIF.GetInstance.CancelReverseCall_InsertFrm();
end;

procedure TFrmReverseCallManager.CheckWndProc(var Message: TMessage);
var
  nDevNum : Integer ;
begin
  //收到反呼信息
  if Message.Msg = WM_CHECK_CALL_SUCCESS then
  begin
    //if m_nRecvDev = NO_DEVICE_NUMBER then
    begin
      //获取设备号
      nDevNum := Message.WParam ;
      ConnectReverseCall(nDevNum);
    end;
  end
  else if Message.Msg = WM_CHECK_CALL_CANCEL then
  begin
//    if m_nRecvDev <> NO_DEVICE_NUMBER then
    begin
      //获取设备号
      nDevNum := -1  ;
      CancelReverseCall(nDevNum);
    end;
  end;
end;



{ TCheckReverseCallThread }

constructor TCheckReverseCallThread.Create(Handle:THandle);
begin
  m_Handle := Handle ;
  m_bIsStop := False ;
  m_RoomCallApp := TRoomCallApp.GetInstance;
  inherited Create(False);
end;

procedure TCheckReverseCallThread.Delay(ms: Cardinal);
{功能:延时}
var
  nBeginTime: Cardinal;
begin
  nBeginTime := GetTickCount;
  while GetTickCount - nBeginTime < ms do
  begin
    Sleep(10);
    if Self.Terminated then
      Break;    
  end;
end;

procedure TCheckReverseCallThread.Execute;
var
  nDevNum: Integer;
  strMessage: string;
begin
  while not Self.Terminated do
  begin
    //检查是否有反呼信息
    try
      Delay(CHECK_CALL_INTERVAL);
      Windows.OutputDebugString('开始进入反呼线程');
      //检查是否在呼叫
      if (m_RoomCallApp.CallDevOp.bCalling = False) and (not TCallRoomFunIF.GetInstance.bCallling) then
      begin
        //检查是否有反呼信息
        Windows.OutputDebugString('开始检查是否有反呼信息!!!!');
        if m_RoomCallApp.CallDevOp.HaveReverseCall(nDevNum, strMessage) then
        begin
          if m_Handle <> 0 then
          begin
            Windows.OutputDebugString('检查到反呼信息!!!!');
            PostMessage(m_Handle, WM_CHECK_CALL_SUCCESS, nDevNum, 0);
          end;
        end;
      end
      //如果正在反呼，且检测到取消指令
      else if ( TCallRoomFunIF.GetInstance.bFrmReverseCalling ) and  ( not  m_RoomCallApp.CallDevOp.HaveReverseCall(nDevNum, strMessage)  )then
      begin
        if m_Handle <> 0 then
        begin
          Windows.OutputDebugString('没检查到反呼信息!!!!');
          PostMessage(m_Handle, WM_CHECK_CALL_CANCEL, 0, 0);
        end;
          //Windows.OutputDebugString('没有检查到反呼信息!!!!');
      end;
    except
      on e:Exception do
      begin
        Windows.OutputDebugString( PAnsiChar(e.Message) );
      end;
    end;
  end;
end;



procedure TCheckReverseCallThread.InsertLog(Text: String);
begin
  if Assigned(m_OnLogEvent) then
    m_OnLogEvent(Text) ;
end;

procedure TCheckReverseCallThread.SetLogEvent(
  OnEventByString: TOnEventByString);
begin
  m_OnLogEvent := OnEventByString ;
end;

procedure TCheckReverseCallThread.Stop;
begin
  m_bIsStop := True ;
end;

end.
