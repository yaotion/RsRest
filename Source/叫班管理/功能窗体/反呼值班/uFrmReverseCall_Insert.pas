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
    //�а��߼�
    m_RoomCallApp:TRoomCallApp;
    //�а�����
    m_CallRecord:TCallRoomRecord;
    //����
    m_strCheCi:string;
    //����
    m_strRoomNum:string;
    //�а���������ʱ��
    m_nVoiceEnd:Integer;
    //�Ƿ������豸�ɹ�
    m_bConSucess :Boolean;
    //����ʱ
    m_nLeftTimeCount :Integer;
    //�����а��¼�
    m_FinishCallResult:TFinishCallResult;
    //�׽еĴ���
    m_nFirstCallCount : integer ;
    //�Ƿ��ͨ���߾ܽ�
    m_bIsConnect : Boolean ;
  published
    property CallRecord:TCallRoomRecord read m_CallRecord write m_CallRecord;
    property FinishCallResult:TFinishCallResult read m_FinishCallResult write m_FinishCallResult;
  private
    {���ܣ������յ�������Ϣ}
    procedure PlayCallInfo();
    {����:��ʾ���ƻ���Ϣ}
    procedure ShowCallInfo();
    {����:���ûص�����}
    function SetEventFun():Boolean;
    {����:����ص�����}
    procedure ClearEventFun();

    {����:�����豸}
    function ConDev():Boolean;
    {����:�Ҷ��豸}
    function DisConDev():Boolean;
    {����:�ܽ��豸}
    function RefuseDev():Boolean;
    {����:��ʼ�����豸�ص�}
    procedure OnStartConDev(data:TCallDevCallBackData);
    {���ܣ���ѯ�豸}
    procedure OnQueryConDev(data:TCallDevCallBackData);
    {����:���������豸�ص�}
    procedure OnTryConDev(data:TCallDevCallBackData);
    {����:�����豸�����ص�}
    procedure OnFinishConDev(data:TCallDevCallBackData);
    {����:�Ҷ��豸�ص�����}
    procedure OnDisConDevEvent(data:TCallDevCallBackData);
    {����:���������־}
    procedure AddMemLog(strMsg:string);
  public
    {���ܣ��Ƿ��ڽ�ͨ״̬}
    function IsConnect():Boolean;
    {���ܣ�ȡ��}
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
  if not tfMessageBox('ȷ���ܽ���?') then
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
      strMsg := '��ͨ�豸';
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


  AddMemLog('��ʼ�Ҷ�!');
  m_RoomCallApp.CallDevOp.DisConDevice(strMsg);
end;

procedure TFrmReverseCall_Insert.FormCreate(Sender: TObject);
begin
  m_bIsConnect := False ;
  m_nLeftTimeCount := 30 ;
  m_nFirstCallCount := 0 ;
  m_RoomCallApp := TRoomCallApp.GetInstance;
  m_CallRecord:=TCallRoomRecord.Create;
    //����а�ƻ�

  btnDisconnect.Visible := False ;

end;

procedure TFrmReverseCall_Insert.FormDestroy(Sender: TObject);
begin
  FreeAndNil(m_CallRecord);
    //����а�ƻ�
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
    strStopMusic :=  ExtractFilePath(Application.ExeName) + 'CallMusic\�յ��������.wav' ;
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
      strMsg := '�ܽ��豸';
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
  //btnConfirm.Caption := Format('�ر�(%2d)',[m_nLeftTimeCount])  ;
  if m_nLeftTimeCount <= 0 then
  begin
    tmrAutoClose.Enabled := False;
    DisConDev;                      
  end;
end;

end.
