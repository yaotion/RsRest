unit uFrmReverseCallManager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,uTFSystem,uRoomCallApp,uRoomCall,uCallRoomFunIF, StdCtrls, ExtCtrls,
  RzPanel;

const

  NO_DEVICE_NUMBER = -1 ;

  WM_CHECK_CALL_SUCCESS = WM_USER+10;     //�����Ϣ
  WM_CHECK_CALL_CANCEL = WM_USER+11;      //ȡ����Ϣ

  CHECK_CALL_INTERVAL = 5 * 1000 ;       //����� 5��������

type
  ///��������߳�
  ///
  ///  ������ں��У��򲻽��м�ⷴ��
  ///  ��������ǿ��еģ������ķ����źź���λ�����һ�·�����Ϣ
  ///
  TCheckReverseCallThread = class(TThread)
  public
    constructor Create(Handle:THandle);
  protected
    procedure Execute; override;
        {ֹͣ}
    procedure Stop();
    {����:��ʱ}
    procedure Delay(ms: Cardinal);
    {�����־}
    procedure InsertLog(Text:String);
  public
    procedure SetLogEvent(OnEventByString:TOnEventByString);
  private
    m_RoomCallApp : TRoomCallApp ;  //����Ƿ��к���
    m_Handle:       THandle;        //��Ϣ���
        m_bIsStop:      Boolean ;       //��ͣ���
    m_OnLogEvent : TOnEventByString ;
  end;

//==============================================================================
// ��ⷴ������
//==============================================================================

  TFrmReverseCallManager = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    {�����Ϣ}
    procedure CheckWndProc(var Message : TMessage);
    {���ܣ��Ƿ���ͨ�÷���}
    function  ConnectReverseCall(nDevNum:Integer):Boolean;
        {���ܣ�ȡ����ͨ�÷���}
    function  CancelReverseCall(nDevNum:Integer):Boolean;
    {����:�����а�ص��¼�}
    procedure FinishReverseCallEvent(bSucess:Boolean; data:TCallDevCallBackData);
    {���ܣ����LOG}
    procedure AddLog(Log:string);
  private
    m_nRecvDev:Integer ; //���յ����豸��
    m_hMessageWnd : THandle ;                   //��Ϣ���(�ô��屾��ľ�������⣬���Ե���������һ��)
    m_CheckThread:  TCheckReverseCallThread;    //����߳�
    m_RoomCallApp : TRoomCallApp ;              //����Ƿ����ں���
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
          strText := Format('[����]:�豸��:[%d]--�����:[%s]',[roomDev.nDevNum,roomDev.strRoomNum]);
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
    //ȡ��������
    TCallRoomFunIF.GetInstance.CancelReverseCall_InsertFrm();
end;

procedure TFrmReverseCallManager.CheckWndProc(var Message: TMessage);
var
  nDevNum : Integer ;
begin
  //�յ�������Ϣ
  if Message.Msg = WM_CHECK_CALL_SUCCESS then
  begin
    //if m_nRecvDev = NO_DEVICE_NUMBER then
    begin
      //��ȡ�豸��
      nDevNum := Message.WParam ;
      ConnectReverseCall(nDevNum);
    end;
  end
  else if Message.Msg = WM_CHECK_CALL_CANCEL then
  begin
//    if m_nRecvDev <> NO_DEVICE_NUMBER then
    begin
      //��ȡ�豸��
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
{����:��ʱ}
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
    //����Ƿ��з�����Ϣ
    try
      Delay(CHECK_CALL_INTERVAL);
      Windows.OutputDebugString('��ʼ���뷴���߳�');
      //����Ƿ��ں���
      if (m_RoomCallApp.CallDevOp.bCalling = False) and (not TCallRoomFunIF.GetInstance.bCallling) then
      begin
        //����Ƿ��з�����Ϣ
        Windows.OutputDebugString('��ʼ����Ƿ��з�����Ϣ!!!!');
        if m_RoomCallApp.CallDevOp.HaveReverseCall(nDevNum, strMessage) then
        begin
          if m_Handle <> 0 then
          begin
            Windows.OutputDebugString('��鵽������Ϣ!!!!');
            PostMessage(m_Handle, WM_CHECK_CALL_SUCCESS, nDevNum, 0);
          end;
        end;
      end
      //������ڷ������Ҽ�⵽ȡ��ָ��
      else if ( TCallRoomFunIF.GetInstance.bFrmReverseCalling ) and  ( not  m_RoomCallApp.CallDevOp.HaveReverseCall(nDevNum, strMessage)  )then
      begin
        if m_Handle <> 0 then
        begin
          Windows.OutputDebugString('û��鵽������Ϣ!!!!');
          PostMessage(m_Handle, WM_CHECK_CALL_CANCEL, 0, 0);
        end;
          //Windows.OutputDebugString('û�м�鵽������Ϣ!!!!');
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
