unit uFrmReverseCall_Insert;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, Grids, AdvObj, BaseGrid, AdvGrid, StdCtrls, ExtCtrls,
  RzPanel,uRoomCall,
  uRoomCallApp,uPubFun,uRoomCallOp,uSaftyEnum,uGlobalDM,uTFSystem,uWaitWorkMgr,
  uWaitWork;

type
  TFrmReverseCall_Insert = class(TForm)
    pnlCallWork: TRzPanel;
    lbl2: TLabel;
    lbl7: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    edtTrainNo: TEdit;
    edtWaitTime: TEdit;
    edtCallTime: TEdit;
    edtRoomNum: TEdit;
    mmo1: TMemo;
    pnl4: TRzPanel;
    Grid1: TAdvStringGrid;
    btnConnect: TRzButton;
    btnDisconnect: TRzButton;
    tmrAutoClose: TTimer;
    btnRefused: TRzButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure tmrAutoCloseTimer(Sender: TObject);
    procedure btnRefusedClick(Sender: TObject);
  private
    //叫班逻辑
    m_RoomCallApp:TRoomCallApp;
    //叫班数据
    m_CallRecord:TCallRoomRecord;
    //车次
    m_strCheCi:string;
    //房间
    m_strRoomNum:string;
    //叫班语音结束时间
    m_nVoiceEnd:Integer;
    //是否连接设备成功
    m_bConSucess :Boolean;
    //倒计时
    m_nLeftTimeCount :Integer;
    //结束叫班事件
    m_FinishCallResult:TFinishCallResult;
    //首叫的次数
    m_nFirstCallCount : integer ;
    //是否接通或者拒接
    m_bIsConnect : Boolean ;
  published
    property CallRecord:TCallRoomRecord read m_CallRecord write m_CallRecord;
    property FinishCallResult:TFinishCallResult read m_FinishCallResult write m_FinishCallResult;
  private
    {功能：播放收到呼叫信息}
    procedure PlayCallInfo();
    {功能:显示候班计划信息}
    procedure ShowCallInfo();
    {功能:设置回调函数}
    function SetEventFun():Boolean;
    {功能:清除回调函数}
    procedure ClearEventFun();

    {功能:连接设备}
    function ConDev():Boolean;
    {功能:挂断设备}
    function DisConDev():Boolean;
    {功能:拒接设备}
    function RefuseDev():Boolean;
    {功能:开始连接设备回调}
    procedure OnStartConDev(data:TCallDevCallBackData);
    {功能：查询设备}
    procedure OnQueryConDev(data:TCallDevCallBackData);
    {功能:尝试连接设备回到}
    procedure OnTryConDev(data:TCallDevCallBackData);
    {功能:连接设备结束回调}
    procedure OnFinishConDev(data:TCallDevCallBackData);
    {功能:挂断设备回调函数}
    procedure OnDisConDevEvent(data:TCallDevCallBackData);
    {功能:插入进度日志}
    procedure AddMemLog(strMsg:string);
  public
    {功能：是否处于接通状态}
    function IsConnect():Boolean;
    {功能：取消}
    procedure Cancel();
  end;

var
  FrmReverseCall_Insert: TFrmReverseCall_Insert;

implementation
{$INCLUDE uDebug.inc}
uses
  MMSystem,ufrmQuestionBox;

{$R *.dfm}

procedure TFrmReverseCall_Insert.AddMemLog(strMsg: string);
begin
  mmo1.Lines.Add(TPubfun.DateTime2Str(Now) + ':' +strMsg);
end;

procedure TFrmReverseCall_Insert.btnConnectClick(Sender: TObject);
begin
  ConDev ;
end;

procedure TFrmReverseCall_Insert.btnDisconnectClick(Sender: TObject);
begin
  DisConDev;
end;

procedure TFrmReverseCall_Insert.btnRefusedClick(Sender: TObject);
var
  strmsg:string;
begin
  if not tfMessageBox('确定拒接吗?') then
    Exit;

  m_bIsConnect := True ;
  if m_RoomCallApp.CallDevOp.RefuseReverseCall(CallRecord.nDeviceID,strmsg) then
  begin
    exit ;
  end;
  //ModalResult := mrCancel ;
end;

procedure TFrmReverseCall_Insert.Cancel;
begin
  //ModalResult := mrCancel ;
end;

procedure TFrmReverseCall_Insert.ClearEventFun;
begin
  m_RoomCallApp.CallDevOp.OnStartConDevEvent := nil;
  m_RoomCallApp.CallDevOp.OnTryConDevEvent := nil;
  m_RoomCallApp.CallDevOp.OnQueryConDevEvent := nil ;
  m_RoomCallApp.CallDevOp.OnFinishConDevEvent := nil;
  m_RoomCallApp.CallDevOp.OnStartFirstCallVoiceEvent := nil;
  m_RoomCallApp.CallDevOp.OnFinishFistCallVoiceEvent:=nil;

  m_RoomCallApp.CallDevOp.OnStartReCallVoiceEvent := nil;
  m_RoomCallApp.CallDevOp.OnFinishReCallVoiceEvent := nil;
  m_RoomCallApp.CallDevOp.OnDisConDevEvent := nil;
end;

function TFrmReverseCall_Insert.ConDev: Boolean;
var
  strMsg:string;
  nDevNum:Integer;
begin
  result := False;
  try
    nDevNum := m_CallRecord.nDeviceID ;
    result := m_RoomCallApp.CallDevOp.ConnectReverseCall(nDevNum,strMsg);
    if result = false then
      AddMemLog(strMsg)
    else
    begin
      m_bIsConnect := True ;
      tmrAutoClose.Enabled := False ;
      btnConnect.Enabled := False ;
      btnRefused.Visible := False ;
      btnDisconnect.Visible := True ;
      strMsg := '接通设备';
      AddMemLog(strMsg);
    end;
  finally

  end;
end;

function TFrmReverseCall_Insert.DisConDev: Boolean;
var
  strmsg:string;
  strStopMusic:string;
begin
  result := False;


  if m_RoomCallApp.CallDevOp.bCalling then
  begin
    m_RoomCallApp.CallDevOp.bCancel := True;
    m_RoomCallApp.CallDevOp.CloseThread();
  end;


  AddMemLog('开始挂断!');
  m_RoomCallApp.CallDevOp.DisConDevice(strMsg);
end;

procedure TFrmReverseCall_Insert.FormCreate(Sender: TObject);
begin
  m_bIsConnect := False ;
  m_nLeftTimeCount := 30 ;
  m_nFirstCallCount := 0 ;
  m_RoomCallApp := TRoomCallApp.GetInstance;
  m_CallRecord:=TCallRoomRecord.Create;
    //房间叫班计划

  btnDisconnect.Visible := False ;

end;

procedure TFrmReverseCall_Insert.FormDestroy(Sender: TObject);
begin
  FreeAndNil(m_CallRecord);
    //房间叫班计划
  ClearEventFun;
end;

procedure TFrmReverseCall_Insert.FormShow(Sender: TObject);
begin
  m_bConSucess := False;
  ShowCallInfo();
  PlayCallInfo();
  SetEventFun;
end;

function TFrmReverseCall_Insert.IsConnect: Boolean;
begin
  Result := m_bIsConnect ;
end;

procedure TFrmReverseCall_Insert.OnDisConDevEvent(data: TCallDevCallBackData);
begin
  if Assigned(FinishCallResult) then
    FinishCallResult(m_bConSucess,data);
end;

procedure TFrmReverseCall_Insert.OnFinishConDev(data: TCallDevCallBackData);
begin

end;

procedure TFrmReverseCall_Insert.OnQueryConDev(data: TCallDevCallBackData);
begin

end;

procedure TFrmReverseCall_Insert.OnStartConDev(data: TCallDevCallBackData);
begin

end;

procedure TFrmReverseCall_Insert.OnTryConDev(data: TCallDevCallBackData);
begin

end;

procedure TFrmReverseCall_Insert.PlayCallInfo;
var
  strStopMusic:string;
begin
  begin
    strStopMusic :=  ExtractFilePath(Application.ExeName) + 'CallMusic\收到房间呼叫.wav' ;
    MMSystem.PlaySound(PChar(strStopMusic), 0, SND_FILENAME or SND_SYNC);
  end;
end;

function TFrmReverseCall_Insert.RefuseDev: Boolean;
var
  strMsg:string;
  nDevNum:Integer;
begin
  result := False;
  try
    nDevNum := m_CallRecord.nDeviceID ;
    result := m_RoomCallApp.CallDevOp.RefuseReverseCall(nDevNum,strMsg);
    if result = false then
      AddMemLog(strMsg)
    else
    begin
      tmrAutoClose.Enabled := False ;
      btnConnect.Enabled := False ;
      strMsg := '拒接设备';
      AddMemLog(strMsg);
    end;
  finally

  end;
end;

function TFrmReverseCall_Insert.SetEventFun: Boolean;
begin
  result := False;
  if m_RoomCallApp.CallDevOp.bCalling then Exit;

  m_RoomCallApp.CallDevOp.OnStartConDevEvent := Self.OnStartConDev;
  m_RoomCallApp.CallDevOp.OnTryConDevEvent := Self.OnTryConDev;
  m_RoomCallApp.CallDevOp.OnFinishConDevEvent := Self.OnFinishConDev;


  m_RoomCallApp.CallDevOp.OnDisConDevEvent := Self.OnDisConDevEvent;
  result := True;
end;

procedure TFrmReverseCall_Insert.ShowCallInfo;
begin
  edtRoomNum.Text := m_CallRecord.strRoomNum ;
end;



procedure TFrmReverseCall_Insert.tmrAutoCloseTimer(Sender: TObject);
begin
  m_nLeftTimeCount := m_nLeftTimeCount -1;
  //btnConfirm.Caption := Format('关闭(%2d)',[m_nLeftTimeCount])  ;
  if m_nLeftTimeCount <= 0 then
  begin
    tmrAutoClose.Enabled := False;
    DisConDev;                      
  end;
end;

end.
