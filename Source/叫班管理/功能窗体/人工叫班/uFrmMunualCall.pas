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
    //叫班逻辑
    m_RoomCallApp:TRoomCallApp;
    //叫班数据
    m_CallRecord:TCallRoomRecord;
    //房间叫班计划
    m_CallRoomPlan:TCallRoomPlan;
    //车次
    m_strCheCi:string;
    //房间
    m_strRoomNum:string;
    //自动关闭倒计时
    m_nLeftTimeCount:INteger;
  public
    property CallRoomPlan:TCallRoomPlan read m_CallRoomPlan write m_CallRoomPlan;
    property strCheCi:string read m_strCheCi write m_strCheCi;
    property strRoomNum:string read m_strRoomNum write m_strRoomNum;
  private
    {功能:开始连接设备回调}
    procedure OnStartConDev(data:TCallDevCallBackData);
    {功能:尝试连接设备回调}
    procedure OnTryConDev(data:TCallDevCallBackData);
    {功能:连接设备结束回调}
    procedure OnFinishConDev(data:TCallDevCallBackData);
    {功能:开始首次叫班回调函数}
    procedure OnStartFirstCallVoice(data:TCallDevCallBackData);
    {功能:首叫结束回调函数}
    procedure OnFinishFirstCallVoice(data:TCallDevCallBackData);
    {功能:挂断设备回调函数}
    procedure OnDisConDevEvent(data:TCallDevCallBackData);
    {功能:初始化叫班数据对象}
    function InitCallRecord():Boolean;
    {功能:插入进度日志}
    procedure AddMemLog(strMsg:string);

  public

  end;
  {功能:人工叫班}
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
    AddMemLog('端口打开失败!');
    Exit;
  end;
  if m_RoomCallApp.CallDevOp.bCalling then
  begin
    AddMemLog('正在叫班,');
    Exit;
  end;
  if self.InitCallRecord = False then Exit;
  m_RoomCallApp.CallDevOp.CallRecord.Clone(m_CallRecord);

  AddMemLog('开始呼叫房间设备,呼叫中...');
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
    AddMemLog('挂断失败!');
    Exit;
  end;
  btnConnect.Enabled := True;
  btnSysVoice.Enabled := False;
  btnDisconnect.Enabled := False;
  AddMemLog('挂断设备!');

end;

procedure TFrmMunualCall.btnSysVoiceClick(Sender: TObject);
var
  strMsg:string;
begin
  if m_RoomCallApp.CallDevOp.OpenPort = False then
  begin
    AddMemLog('端口打开失败!');
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
    TtfPopBox.ShowBox('车次不能为空!');
    Exit;
  end;  }
  if Trim(edtRoomNum.Text) = '' then
  begin
    TtfPopBox.ShowBox('房间不能为空!');
    Exit
  end;
  if m_CallRecord <> nil then
    m_CallRecord.Free;
  //构造叫班计划
  callmanplan:=TCallManPlan.Create;
  callmanplan.strTrainNo := Trim(edtTrainNo.Text);
  callmanplan.strRoomNum := Trim(edtRoomNum.Text);
  callmanplan.dtCallTime := GlobalDM.GetNow;
  m_CallRoomPlan.Init(callmanplan);
  m_CallRoomPlan.manList.Add(callmanplan);

  m_CallRecord := TCallRoomRecord.Create;
  //手工叫班不再喜欢到人,仅仅有一条房间的叫班记录就行,人员信息忽略
  m_CallRecord.Init(m_CallRoomPlan,GlobalDM.GetNow());

  if m_RoomCallApp.DBCallDev.FindByRoom(m_CallRecord.strRoomNum,dev) = False then
  begin
    TtfPopBox.ShowBox('房间未指定叫班设备编号!');
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
      strMsg := Format('第%d次呼叫房间设备,结果:成功!',[data.callRoomRecord.nConTryTimes]) ;
      btnConnect.Enabled := False;
    end ;
    TR_FAIL:
    begin
      strMsg := Format('第%d次呼叫房间设备,结果:失败,原因:%s',[data.callRoomRecord.nConTryTimes,data.callRoomRecord.strMsg]);
      btnDisconnect.Enabled := True;
    end;
    TR_CANCEL:
    begin
      strMsg := Format('第%d次呼叫房间设备,结果:失败,原因:%s',[data.callRoomRecord.nConTryTimes,'用户取消']);
      btnSysVoice.Enabled := False;
    end;
    TR_TIMEOUT:
    begin
      strMsg := Format('第%d次呼叫房间设备,结果:失败,原因:%s',[data.callRoomRecord.nConTryTimes,'呼叫超时']);
      btnSysVoice.Enabled := False;
    end;
  else ;
  end;
  m_RoomCallApp.CallDevOp.CloseThread();
  lbl_Nofity.Caption := IntToStr(m_nLeftTimeCount) +  '秒后自动关闭';
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
  lbl_Nofity.Caption := IntToStr(m_nLeftTimeCount) +  '秒后自动关闭';
  tmrAutoClose.Enabled := True;
end;

procedure TFrmMunualCall.OnStartConDev(data:TCallDevCallBackData);
var
  strMsg:string;
begin
  strMsg:= Format('第%d次连接设备.',[data.callRoomRecord.nConTryTimes]);
  AddMemLog(strMsg);
  btnDisconnect.Enabled := True;
end;

procedure TFrmMunualCall.OnStartFirstCallVoice(data:TCallDevCallBackData);
begin
  AddMemLog('开始播放首叫语音');
end;

procedure TFrmMunualCall.OnTryConDev(data: TCallDevCallBackData);
var
  strMsg:string;
begin
  case data.callRoomRecord.eCallResult of
    TR_SUCESS:
    begin
      btnSysVoice.Enabled := True;
      strMsg := Format('第%d次呼叫房间设备,结果:成功!',[data.callRoomRecord.nConTryTimes]) ;
    end ;
    TR_FAIL:
    begin
      strMsg := Format('第%d次呼叫房间设备,结果:失败,原因:%s',[data.callRoomRecord.nConTryTimes,data.callRoomRecord.strMsg]);
      btnDisconnect.Enabled := True;
    end;
    TR_CANCEL:
    begin
      strMsg := Format('第%d次呼叫房间设备,结果:失败,原因:%s',[data.callRoomRecord.nConTryTimes,'用户取消']);
      btnSysVoice.Enabled := False;
    end;
    TR_TIMEOUT:
    begin
      strMsg := Format('第%d次呼叫房间设备,结果:失败,原因:%s',[data.callRoomRecord.nConTryTimes,'呼叫超时']);
      btnSysVoice.Enabled := False;
    end;
  else ;
  end;
  AddMemLog(strMsg);
end;

procedure TFrmMunualCall.tmrAutoCloseTimer(Sender: TObject);
begin
  m_nLeftTimeCount := m_nLeftTimeCount -1;
  lbl_Nofity.Caption := IntToStr(m_nLeftTimeCount) +  '秒后自动关闭';
  if m_nLeftTimeCount <= 0 then
  begin
    tmrAutoClose.Enabled := False;
    btnCloseClick(nil); 
  end;
end;

end.
