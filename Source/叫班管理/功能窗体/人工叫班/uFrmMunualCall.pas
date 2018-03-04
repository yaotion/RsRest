unit uFrmMunualCall;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uRoomCallApp,uCallUtils,uRoomCallMsgDefine,uTFSystem,
  uRoomCall,uGlobalDM, ExtCtrls,uPubFun,uRoomCallOp,uSaftyEnum;

type
  TFrmMunualCall = class(TForm)
    btnConnect: TButton;
    btnSysVoice: TButton;
    edtRoomNum: TEdit;
    lbl1: TLabel;
    lbl2: TLabel;
    edtTrainNo: TEdit;
    btnDisconnect: TButton;
    tmrAutoClose: TTimer;
    btnClose: TButton;
    mmoState: TMemo;
    chkSaveVoice: TCheckBox;
    lbl_Nofity: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnSysVoiceClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tmrAutoCloseTimer(Sender: TObject);
  private
    //�а��߼�
    m_RoomCallApp:TRoomCallApp;
    //�а�����
    m_CallRecord:TCallRoomRecord;
    //����а�ƻ�
    m_CallRoomPlan:TCallRoomPlan;
    //����
    m_strCheCi:string;
    //����
    m_strRoomNum:string;
    //�Զ��رյ���ʱ
    m_nLeftTimeCount:INteger;
  public
    property CallRoomPlan:TCallRoomPlan read m_CallRoomPlan write m_CallRoomPlan;
    property strCheCi:string read m_strCheCi write m_strCheCi;
    property strRoomNum:string read m_strRoomNum write m_strRoomNum;
  private
    {����:��ʼ�����豸�ص�}
    procedure OnStartConDev(data:TCallDevCallBackData);
    {����:���������豸�ص�}
    procedure OnTryConDev(data:TCallDevCallBackData);
    {����:�����豸�����ص�}
    procedure OnFinishConDev(data:TCallDevCallBackData);
    {����:��ʼ�״νа�ص�����}
    procedure OnStartFirstCallVoice(data:TCallDevCallBackData);
    {����:�׽н����ص�����}
    procedure OnFinishFirstCallVoice(data:TCallDevCallBackData);
    {����:�Ҷ��豸�ص�����}
    procedure OnDisConDevEvent(data:TCallDevCallBackData);
    {����:��ʼ���а����ݶ���}
    function InitCallRecord():Boolean;
    {����:���������־}
    procedure AddMemLog(strMsg:string);

  public

  end;
  {����:�˹��а�}
  function MunualCall(strCheCi:string = '';strRoomNum:string = ''):Boolean;

implementation

uses
  utfPopBox ;

{$R *.dfm}
function MunualCall(strCheCi:string ='';strRoomNum:string = ''):Boolean;
var
  frm: TFrmMunualCall;
begin
  result := False;
  frm := TFrmMunualCall.Create(nil);
  try
    frm.m_strCheCi := strCheCi;
    frm.m_strRoomNum := strRoomNum;
    if frm.ShowModal = mrOk then
      result := True;
  finally
    frm.Free;
  end;

end;  
procedure TFrmMunualCall.AddMemLog(strMsg: string);
begin

  mmoState.Lines.Add(TPubfun.DateTime2Str(Now) + ' : ' +strMsg);
end;

procedure TFrmMunualCall.btnCloseClick(Sender: TObject);
begin
  //if btnDisconnect.Enabled = True then
  // btnDisconnectClick(nil);
  self.modalResult := mrok;
end;

procedure TFrmMunualCall.btnConnectClick(Sender: TObject);
var
  strMsg:string;
begin
  if m_RoomCallApp.CallDevOp.OpenPort = False then
  begin
    AddMemLog('�˿ڴ�ʧ��!');
    Exit;
  end;
  if m_RoomCallApp.CallDevOp.bCalling then
  begin
    AddMemLog('���ڽа�,');
    Exit;
  end;
  if self.InitCallRecord = False then Exit;
  m_RoomCallApp.CallDevOp.CallRecord.Clone(m_CallRecord);

  AddMemLog('��ʼ���з����豸,������...');
  btnDisconnect.Enabled := true;
  if m_RoomCallApp.CallDevOp.MunualConDevice(strMsg) = False then
  begin
    AddMemLog(strMsg);
    Exit;
  end;
  //btnConnect.Enabled := False;
end;

procedure TFrmMunualCall.btnDisconnectClick(Sender: TObject);
var
  strmsg:string;
begin
  if m_RoomCallApp.CallDevOp.bCalling then
  begin
    m_RoomCallApp.CallDevOp.bCancel := True;
    m_RoomCallApp.CallDevOp.CloseThread();
  end;
  if m_RoomCallApp.CallDevOp.DisConDevice(strMsg) = False Then
  begin
    AddMemLog('�Ҷ�ʧ��!');
    Exit;
  end;
  btnConnect.Enabled := True;
  btnSysVoice.Enabled := False;
  btnDisconnect.Enabled := False;
  AddMemLog('�Ҷ��豸!');

end;

procedure TFrmMunualCall.btnSysVoiceClick(Sender: TObject);
var
  strMsg:string;
begin
  if m_RoomCallApp.CallDevOp.OpenPort = False then
  begin
    AddMemLog('�˿ڴ�ʧ��!');
    Exit;
  end;
  //m_RoomCallApp.CallDevOp.CallRecord := m_CallRecord;

  if m_RoomCallApp.CallDevOp.MunualFirstCallRoom(strMsg) = False then
  begin
    AddMemLog(strMsg);
    Exit;
  end;
  lbl_Nofity.Visible := False;
  tmrAutoClose.Enabled := False;

end;

procedure TFrmMunualCall.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
  if btnClose.Enabled = true then
  begin
    btnDisconnectClick(nil);
    CanClose := True;
  end;

end;

procedure TFrmMunualCall.FormCreate(Sender: TObject);
begin
  m_RoomCallApp:=TRoomCallApp.GetInstance;
  m_RoomCallApp.CallDevOp.OnStartConDevEvent := Self.OnStartConDev;
  m_RoomCallApp.CallDevOp.OnFinishConDevEvent := Self.OnFinishConDev;
  m_RoomCallApp.CallDevOp.OnFinishFistCallVoiceEvent:= Self.OnFinishFirstCallVoice;
  m_RoomCallApp.CallDevOp.OnStartFirstCallVoiceEvent := Self.OnStartFirstCallVoice;
  m_RoomCallApp.CallDevOp.OnDisConDevEvent := Self.OnDisConDevEvent;
  m_CallRoomPlan := TCallRoomPlan.Create;
  m_nLeftTimeCount := 60;
end;

procedure TFrmMunualCall.FormDestroy(Sender: TObject);
begin
  m_RoomCallApp.CallDevOp.OnStartConDevEvent := nil;
  m_RoomCallApp.CallDevOp.OnFinishConDevEvent := nil;
  m_RoomCallApp.CallDevOp.OnFinishFistCallVoiceEvent:= nil;
  m_RoomCallApp.CallDevOp.OnStartFirstCallVoiceEvent := nil;
  if m_CallRecord <> nil then
    m_CallRecord.Free;
  m_CallRoomPlan.Free;
end;

procedure TFrmMunualCall.FormShow(Sender: TObject);
begin
  edtRoomNum.Text := m_strRoomNum;
  edtTrainNo.Text := m_strCheCi;
end;

function TFrmMunualCall.InitCallRecord:Boolean;
var
  dev:RCallDev;
  callmanplan:TCallManPlan;
begin
  result := False;
  {if Trim(edtTrainNo.Text) ='' then
  begin
    TtfPopBox.ShowBox('���β���Ϊ��!');
    Exit;
  end;  }
  if Trim(edtRoomNum.Text) = '' then
  begin
    TtfPopBox.ShowBox('���䲻��Ϊ��!');
    Exit
  end;
  if m_CallRecord <> nil then
    m_CallRecord.Free;
  //����а�ƻ�
  callmanplan:=TCallManPlan.Create;
  callmanplan.strTrainNo := Trim(edtTrainNo.Text);
  callmanplan.strRoomNum := Trim(edtRoomNum.Text);
  callmanplan.dtCallTime := GlobalDM.GetNow;
  m_CallRoomPlan.Init(callmanplan);
  m_CallRoomPlan.manList.Add(callmanplan);

  m_CallRecord := TCallRoomRecord.Create;
  //�ֹ��а಻��ϲ������,������һ������Ľа��¼����,��Ա��Ϣ����
  m_CallRecord.Init(m_CallRoomPlan,GlobalDM.GetNow());

  if m_RoomCallApp.DBCallDev.FindByRoom(m_CallRecord.strRoomNum,dev) = False then
  begin
    TtfPopBox.ShowBox('����δָ���а��豸���!');
    Exit;
  end
  else
    m_CallRecord.nDeviceID :=dev.nDevNum;
  m_CallRecord.eCallType:=TCT_MunualCall;
  result := True;
end;


procedure TFrmMunualCall.OnDisConDevEvent(data: TCallDevCallBackData);
var
  CallRecord :TCallRoomRecord;
  i:Integer;
  strFilePath:string;
begin
  if chkSaveVoice.Checked = False  then Exit;


  CallRecord := data.callRoomRecord;
  CallRecord.CallVoice.strCallVoiceGUID := NewGUID;
  CallRecord.CallVoice.dtCreateTime := GlobalDM.GetNow;
  strFilePath := GlobalDM.AppPath + 'CallVoice\' ;
  if DirectoryExists(strFilePath) = False  then
    CreateDir(strFilePath);
  strFilePath := strFilePath + FormatDateTime('yyyy-MM-dd',CallRecord.CallVoice.dtCreateTime) + '\';
  if DirectoryExists(strFilePath) = False  then
    CreateDir(strFilePath);
  
  CallRecord.CallVoice.strFilePathName := strFilePath  + CallRecord.CreateVoiceFileName();
  for i := 0 to CallRecord.CallManRecordList.Count - 1 do
  begin
    CallRecord.CallManRecordList.Items[i].strCallVoiceGUID :=CallRecord.CallVoice.strCallVoiceGUID;

  end;
  m_RoomCallApp.DBCallRecord.Add(CallRecord);
end;

procedure TFrmMunualCall.OnFinishConDev(data:TCallDevCallBackData);
var
  strMsg:string;
begin
  btnConnect.Enabled := True;
  case data.callRoomRecord.eCallResult of
    TR_SUCESS:
    begin
      btnSysVoice.Enabled := True;
      strMsg := Format('��%d�κ��з����豸,���:�ɹ�!',[data.callRoomRecord.nConTryTimes]) ;
      btnConnect.Enabled := False;
    end ;
    TR_FAIL:
    begin
      strMsg := Format('��%d�κ��з����豸,���:ʧ��,ԭ��:%s',[data.callRoomRecord.nConTryTimes,data.callRoomRecord.strMsg]);
      btnDisconnect.Enabled := True;
    end;
    TR_CANCEL:
    begin
      strMsg := Format('��%d�κ��з����豸,���:ʧ��,ԭ��:%s',[data.callRoomRecord.nConTryTimes,'�û�ȡ��']);
      btnSysVoice.Enabled := False;
    end;
    TR_TIMEOUT:
    begin
      strMsg := Format('��%d�κ��з����豸,���:ʧ��,ԭ��:%s',[data.callRoomRecord.nConTryTimes,'���г�ʱ']);
      btnSysVoice.Enabled := False;
    end;
  else ;
  end;
  m_RoomCallApp.CallDevOp.CloseThread();
  lbl_Nofity.Caption := IntToStr(m_nLeftTimeCount) +  '����Զ��ر�';
  lbl_Nofity.Visible := True;
  tmrAutoClose.Enabled := True;
  AddMemLog(strMsg);
end;

procedure TFrmMunualCall.OnFinishFirstCallVoice(data:TCallDevCallBackData);
begin
  btnSysVoice.Enabled := True;
  AddMemLog(data.callRoomRecord.strMsg);

  m_RoomCallApp.CallDevOp.CloseThread;
  lbl_Nofity.Visible := True;
  m_nLeftTimeCount := 20;
  lbl_Nofity.Caption := IntToStr(m_nLeftTimeCount) +  '����Զ��ر�';
  tmrAutoClose.Enabled := True;
end;

procedure TFrmMunualCall.OnStartConDev(data:TCallDevCallBackData);
var
  strMsg:string;
begin
  strMsg:= Format('��%d�������豸.',[data.callRoomRecord.nConTryTimes]);
  AddMemLog(strMsg);
  btnDisconnect.Enabled := True;
end;

procedure TFrmMunualCall.OnStartFirstCallVoice(data:TCallDevCallBackData);
begin
  AddMemLog('��ʼ�����׽�����');
end;

procedure TFrmMunualCall.OnTryConDev(data: TCallDevCallBackData);
var
  strMsg:string;
begin
  case data.callRoomRecord.eCallResult of
    TR_SUCESS:
    begin
      btnSysVoice.Enabled := True;
      strMsg := Format('��%d�κ��з����豸,���:�ɹ�!',[data.callRoomRecord.nConTryTimes]) ;
    end ;
    TR_FAIL:
    begin
      strMsg := Format('��%d�κ��з����豸,���:ʧ��,ԭ��:%s',[data.callRoomRecord.nConTryTimes,data.callRoomRecord.strMsg]);
      btnDisconnect.Enabled := True;
    end;
    TR_CANCEL:
    begin
      strMsg := Format('��%d�κ��з����豸,���:ʧ��,ԭ��:%s',[data.callRoomRecord.nConTryTimes,'�û�ȡ��']);
      btnSysVoice.Enabled := False;
    end;
    TR_TIMEOUT:
    begin
      strMsg := Format('��%d�κ��з����豸,���:ʧ��,ԭ��:%s',[data.callRoomRecord.nConTryTimes,'���г�ʱ']);
      btnSysVoice.Enabled := False;
    end;
  else ;
  end;
  AddMemLog(strMsg);
end;

procedure TFrmMunualCall.tmrAutoCloseTimer(Sender: TObject);
begin
  m_nLeftTimeCount := m_nLeftTimeCount -1;
  lbl_Nofity.Caption := IntToStr(m_nLeftTimeCount) +  '����Զ��ر�';
  if m_nLeftTimeCount <= 0 then
  begin
    tmrAutoClose.Enabled := False;
    btnCloseClick(nil); 
  end;
end;

end.
