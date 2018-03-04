unit uFrmAutoCall;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, AdvObj, BaseGrid, AdvGrid, ExtCtrls, RzPanel,uRoomCall,
  uRoomCallApp,uPubFun,uRoomCallOp,uSaftyEnum,uGlobalDM,uTFSystem,uWaitWorkMgr,
  uWaitWork;

type

  TFrmAutoCall = class(TForm)
    pnl1: TRzPanel;
    pnl2: TRzPanel;
    btnConfirm: TButton;
    pnl3: TRzPanel;
    edtRecallTime: TEdit;
    lbl3: TLabel;
    lbl6: TLabel;
    edtFirstCallTime: TEdit;
    edtWaitTime: TEdit;
    lbl1: TLabel;
    lbl5: TLabel;
    edtRoomNum: TEdit;
    lbl4: TLabel;
    lbl2: TLabel;
    edtTrainNo: TEdit;
    tmrAutoClose: TTimer;
    pnl4: TRzPanel;
    Grid1: TAdvStringGrid;
    pnl5: TRzPanel;
    mmo1: TMemo;
    edtCallTime: TEdit;
    lbl_Nofity: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure tmrAutoCloseTimer(Sender: TObject);
    procedure btnConfirmClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
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
    //叫班语音结束时间
    m_nVoiceEnd:Integer;
    //是否连接设备成功
    m_bConSucess :Boolean;
    //倒计时
    m_nLeftTimeCount :Integer;
    //结束叫班事件
    m_FinishCallResult:TFinishCallResult;
  published
    property CallRecord:TCallRoomRecord read m_CallRecord write m_CallRecord;
    property CallRoomPlan :TCallRoomPlan read m_CallRoomPlan write m_CallRoomPlan;
    property FinishCallResult:TFinishCallResult read m_FinishCallResult write m_FinishCallResult;
  private
    {功能:显示候班计划信息}
    procedure ShowCallInfo();


    {功能:设置回调函数}
    function SetEventFun():Boolean;
    {功能:清除回调函数}
    procedure ClearEventFun();

    {功能:连接设备}
    function ConDev():Boolean;
    {功能:播放音乐}
    function PlayMusic():Boolean;
    {功能:挂断设备}
    function DisConDev():Boolean;
    {功能:自动叫班}
    function Call():Boolean;
    {功能:开始连接设备回调}
    procedure OnStartConDev(data:TCallDevCallBackData);
    {功能:尝试连接设备回到}
    procedure OnTryConDev(data:TCallDevCallBackData);
    {功能:连接设备结束回调}
    procedure OnFinishConDev(data:TCallDevCallBackData);
    {功能:开始首次叫班回调函数}
    procedure OnStartFirstCallVoice(data:TCallDevCallBackData);
    {功能:首叫结束回调函数}
    procedure OnFinishFirstCallVoice(data:TCallDevCallBackData);
    {功能:挂断设备回调函数}
    procedure OnDisConDevEvent(data:TCallDevCallBackData);
    {功能:插入进度日志}
    procedure AddMemLog(strMsg:string);
  public
    {功能:自动叫班}
    //class function AutoCall(callRecord :TCallRoomRecord;callRoomPlan:TCallRoomPlan):Boolean;
  end;



implementation

{$R *.dfm}

{ TFrmAutoCall }

procedure TFrmAutoCall.AddMemLog(strMsg: string);
begin
  mmo1.Lines.Add(TPubfun.DateTime2Str(Now) + ' : ' +strMsg);
end;
{
class function TFrmAutoCall.AutoCall(callRecord :TCallRoomRecord;callRoomPlan:TCallRoomPlan): Boolean;
var
  FrmAutoCall: TFrmAutoCall;
begin
  result := False;
  FrmAutoCall:= TFrmAutoCall.Create(nil);
  try
    if FrmAutoCall.m_RoomCallApp.CallDevOp.bCalling = True then Exit;

    FrmAutoCall.m_CallRecord := callRecord;
    FrmAutoCall.m_CallRoomPlan := callRoomPlan;
    if FrmAutoCall.ShowModal = mrOk then
    begin
      result := True;
      Exit;
    end
  finally
    FrmAutoCall.Free;
  end;
end;  }

procedure TFrmAutoCall.btn1Click(Sender: TObject);
begin
  ConDev();
end;

procedure TFrmAutoCall.btnConfirmClick(Sender: TObject);
begin
  tmrAutoClose.Enabled := False;

  //DisConDev;
  self.ModalResult := mrOk;
end;

function TFrmAutoCall.Call: Boolean;
begin
  Result := False;
  if ConDev() = False  then Exit;
  //if PlayMusic() = False then Exit;
  //if DisConDev() = False then Exit;
  result := True;
end;

procedure TFrmAutoCall.ClearEventFun;
begin
  m_RoomCallApp.CallDevOp.OnStartConDevEvent := nil;
  m_RoomCallApp.CallDevOp.OnFinishConDevEvent := nil;
  m_RoomCallApp.CallDevOp.OnFinishFistCallVoiceEvent:=nil;
  m_RoomCallApp.CallDevOp.OnStartFirstCallVoiceEvent := nil;
  m_RoomCallApp.CallDevOp.OnDisConDevEvent := nil;
end;

function TFrmAutoCall.ConDev: Boolean;
var
  strMsg:string;
begin
  m_RoomCallApp.CallDevOp.CallRecord.Clone(m_CallRecord);
  if m_RoomCallApp.CallDevOp.OpenPort = False then
  begin
    AddMemLog('端口打开失败!');
    Exit;
  end;
  if m_RoomCallApp.CallDevOp.bCalling then
  begin
    AddMemLog('正在叫班');
    Exit;
  end;
  //m_RoomCallApp.CallDevOp.CallRecord.Clone(m_CallRecord);

  AddMemLog('开始呼叫房间设备,呼叫中...');
  if m_RoomCallApp.CallDevOp.MunualConDevice(strMsg) = False then
  begin
    AddMemLog(strMsg);
    Exit;
  end;
end;

function TFrmAutoCall.DisConDev: Boolean;
var
  strmsg:string;
begin
  result := False;
  if m_RoomCallApp.CallDevOp.bCalling then
  begin
    m_RoomCallApp.CallDevOp.bCancel := True;
    m_RoomCallApp.CallDevOp.CloseThread();

  end;
  //if m_bConSucess = False then Exit;
  
  if m_RoomCallApp.CallDevOp.DisConDevice(strMsg) = False Then
  begin
    AddMemLog('挂断失败!');
    Exit;
  end;
  m_bConSucess := False;
  Result := true;
  AddMemLog('挂断设备!');
end;


procedure TFrmAutoCall.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DisConDev;
  ClearEventFun;
end;

procedure TFrmAutoCall.FormCreate(Sender: TObject);
begin
  m_RoomCallApp := TRoomCallApp.GetInstance;
  m_CallRecord:=TCallRoomRecord.Create;
    //房间叫班计划
  m_CallRoomPlan:=TCallRoomPlan.Create;
end;

procedure TFrmAutoCall.FormDestroy(Sender: TObject);
begin
  FreeAndNil(m_CallRecord);
    //房间叫班计划
  FreeAndNil(m_CallRoomPlan);
end;

procedure TFrmAutoCall.FormShow(Sender: TObject);
begin
  m_bConSucess := False;
  ShowCallInfo();
  if SetEventFun = True then
    ConDev();
end;

procedure TFrmAutoCall.OnDisConDevEvent(data: TCallDevCallBackData);
begin
  if Assigned(FinishCallResult) then
    FinishCallResult(m_bConSucess,data);
end;

procedure TFrmAutoCall.OnFinishConDev(data: TCallDevCallBackData);
var
  strMsg:string;
begin
  m_bConSucess := False;
  case data.callRoomRecord.eCallResult of
    TR_SUCESS:
    begin
      //btnSysVoice.Enabled := True;
      strMsg := Format('第%d次呼叫房间设备,结果:成功!',[data.callRoomRecord.nConTryTimes]) ;
      //m_RoomCallApp.CallDevOp.CloseThread();
      m_bConSucess:= True;
    end ;
    TR_FAIL:
    begin
      strMsg := Format('第%d次呼叫房间设备,结果:失败,原因:%s',[data.callRoomRecord.nConTryTimes,data.callRoomRecord.strMsg]);
      //btnDisconnect.Enabled := True;
    end;
    TR_CANCEL:
    begin
      strMsg := Format('第%d次呼叫房间设备,结果:失败,原因:%s',[data.callRoomRecord.nConTryTimes,'用户取消']);
      //btnSysVoice.Enabled := False;
    end;
    TR_TIMEOUT:
    begin
      strMsg := Format('第%d次呼叫房间设备,结果:失败,原因:%s',[data.callRoomRecord.nConTryTimes,'呼叫超时']);
      //btnSysVoice.Enabled := False;
    end;
  else ;
  end;
  m_RoomCallApp.CallDevOp.CloseThread();
  AddMemLog(strMsg);
  if data.callRoomRecord.eCallResult = TR_SUCESS then
  begin
    PlayMusic;
  end
  else //叫班失败
  begin
    btnConfirmClick(nil);
  end;


end;

procedure TFrmAutoCall.OnFinishFirstCallVoice(data: TCallDevCallBackData);
begin
  AddMemLog('语音播放完毕');
  AddMemLog(data.callRoomRecord.strMsg);
  m_RoomCallApp.CallDevOp.CloseThread;
  tmrAutoClose.Enabled := True;
  m_nLeftTimeCount := 30;
  lbl_Nofity.Caption := IntToStr(m_nLeftTimeCount) +  '秒后自动关闭';
  lbl_Nofity.Visible := True;
  m_nVoiceEnd := GetTickCount();
  btnConfirm.Visible := True;
end;

procedure TFrmAutoCall.OnStartConDev(data: TCallDevCallBackData);
var
  strMsg:string;
begin
  strMsg:= Format('第%d次连接设备.',[data.callRoomRecord.nConTryTimes]);
  AddMemLog(strMsg);
  //btnDisconnect.Enabled := True;
end;
{功能:尝试连接设备回到}
procedure TFrmAutoCall.OnTryConDev(data:TCallDevCallBackData);
var
  strMsg:string;
begin
  m_bConSucess := False;
  case data.callRoomRecord.eCallResult of
    TR_SUCESS:
    begin
      //btnSysVoice.Enabled := True;
      strMsg := Format('第%d次呼叫房间设备,结果:成功!',[data.callRoomRecord.nConTryTimes]) ;
      //m_RoomCallApp.CallDevOp.CloseThread();
      m_bConSucess:= True;
    end ;
    TR_FAIL:
    begin
      strMsg := Format('第%d次呼叫房间设备,结果:失败,原因:%s',[data.callRoomRecord.nConTryTimes,data.callRoomRecord.strMsg]);
      //btnDisconnect.Enabled := True;
    end;
    TR_CANCEL:
    begin
      strMsg := Format('第%d次呼叫房间设备,结果:失败,原因:%s',[data.callRoomRecord.nConTryTimes,'用户取消']);
      //btnSysVoice.Enabled := False;
    end;
    TR_TIMEOUT:
    begin
      strMsg := Format('第%d次呼叫房间设备,结果:失败,原因:%s',[data.callRoomRecord.nConTryTimes,'呼叫超时']);
      //btnSysVoice.Enabled := False;
    end;
  else ;
  end;
  AddMemLog(strMsg);
  if data.callRoomRecord.eCallResult = TR_SUCESS then
    PlayMusic;
end;

procedure TFrmAutoCall.OnStartFirstCallVoice(data: TCallDevCallBackData);
begin
  AddMemLog('开始播放语音');
end;

function TFrmAutoCall.PlayMusic: Boolean;
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
end;

function TFrmAutoCall.SetEventFun: Boolean;
begin
  result := False;
  if m_RoomCallApp.CallDevOp.bCalling then Exit;

  m_RoomCallApp.CallDevOp.OnStartConDevEvent := Self.OnStartConDev;
  m_RoomCallApp.CallDevOp.OnFinishConDevEvent := Self.OnFinishConDev;
  m_RoomCallApp.CallDevOp.OnFinishFistCallVoiceEvent:= Self.OnFinishFirstCallVoice;
  m_RoomCallApp.CallDevOp.OnStartFirstCallVoiceEvent := Self.OnStartFirstCallVoice;
  m_RoomCallApp.CallDevOp.OnDisConDevEvent := Self.OnDisConDevEvent;
  result := True;
end;

procedure TFrmAutoCall.ShowCallInfo;
var
  waitMgr:TWaitWorkMgr;
  waitPlan:TWaitWorkPlan;
  i:Integer;
begin
  waitMgr := TWaitWorkMgr.GetInstance(GlobalDM.LocalADOConnection);
  waitPlan := waitMgr.planList.Find(m_CallRoomPlan.strWaitPlanGUID);
  if waitPlan <> nil then
  begin
    edtWaitTime.Text := TPubFun.DateTime2Str(waitPlan.dtWaitWorkTime);
    edtCallTime.Text := TPubFun.DateTime2Str(waitPlan.dtCallWorkTime);
  end;
  edtTrainNo.Text := m_CallRecord.strTrainNo;
  edtRoomNum.Text := m_CallRecord.strRoomNum;
  if m_CallRoomPlan.dtFirstCallTime > 1 then
  begin
    edtFirstCallTime.Text := TPubFun.DateTime2Str(m_CallRoomPlan.dtFirstCallTime);
  end;
  if m_CallRoomPlan.dtReCallTime > 1 then
  begin
    edtRecallTime.Text := TPubFun.DateTime2Str(m_CallRoomPlan.dtReCallTime);
  end;
  for i := 0 to m_CallRoomPlan.manList.Count - 1 do
  begin
    //Grid1.Cells[0,i+1] := IntToStr(i+1);
    Grid1.Cells[0,i+1] := m_CallRoomPlan.manList.Items[i].strTrainmanNumber;
    Grid1.Cells[1,i+1] := m_CallRoomPlan.manList.Items[i].strTrainmanName;
  end;

end;

procedure TFrmAutoCall.tmrAutoCloseTimer(Sender: TObject);
begin
  m_nLeftTimeCount := m_nLeftTimeCount -1;
  lbl_Nofity.Caption := IntToStr(m_nLeftTimeCount) +  '秒后自动关闭';
  if m_nLeftTimeCount <= 0 then
  begin
    tmrAutoClose.Enabled := False;
    //if DisConDev = True then
    begin
      //tmrAutoClose.Enabled := False;
      Self.ModalResult := mrOk;
    end;
  end;
end;

end.
