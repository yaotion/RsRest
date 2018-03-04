unit uFrmAutoCall_Insert;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, AdvObj, BaseGrid, AdvGrid, ExtCtrls, RzPanel,uRoomCall,
  uRoomCallApp,uPubFun,uRoomCallOp,uSaftyEnum,uGlobalDM,uTFSystem,uWaitWorkMgr,
  uWaitWork, RzButton,uCallControl;

const
  FIRST_CALL_COUNT :integer = 3;            //首叫的次数
  FIRST_CALL_ELAPSE_SECOND :integer = 10 ;  //首叫之间的间隔

  FIRST_CALL_WAIT_TIME = 60 ;       //60 //20
  RE_CALL_WAIT_TIME = 5 ;

type

  TFrmAutoCall_Insert = class(TForm)
    pnlCallWork: TRzPanel;
    lblCallType: TLabel;
    lbl2: TLabel;
    lbl7: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    edtTrainNo: TEdit;
    edtWaitTime: TEdit;
    edtCallTime: TEdit;
    edtRoomNum: TEdit;
    mmo1: TMemo;
    tmrAutoClose: TTimer;
    pnl4: TRzPanel;
    Grid1: TAdvStringGrid;
    tmrTryPlay: TTimer;
    btnConfirm: TRzButton;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmrAutoCloseTimer(Sender: TObject);
    procedure btnConfirmClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrTryPlayTimer(Sender: TObject);
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
    //首叫的次数
    m_nFirstCallCount : integer ;
    //叫班的房间
    m_CallMultiDevicesArray : RCallMultiDevicesArray;
  published
    property CallRecord:TCallRoomRecord read m_CallRecord write m_CallRecord;
    property CallRoomPlan :TCallRoomPlan read m_CallRoomPlan write m_CallRoomPlan;
    property FinishCallResult:TFinishCallResult read m_FinishCallResult write m_FinishCallResult;
  private
    {功能：产生呼叫信息}
    procedure CreateCallMultiDevicesInfo();
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
    {功能:开始连接设备回调}
    procedure OnStartConDev(data:TCallDevCallBackData);
    {功能:尝试连接设备回到}
    procedure OnTryConDev(data:TCallDevCallBackData);
    {功能：查询设备}
    procedure OnQueryConDev(data:TCallDevCallBackData);
    {功能:连接设备结束回调}
    procedure OnFinishConDev(data:TCallDevCallBackData);
    {功能:开始首次叫班回调函数}
    procedure OnStartFirstCallVoice(data:TCallDevCallBackData);
    {功能:首叫结束回调函数}
    procedure OnFinishFirstCallVoice(data:TCallDevCallBackData);
    {功能:开始催叫回调函数}
    procedure OnStartReCallVoice(data:TCallDevCallBackData);
    {功能:催叫结束回调函数}
    procedure OnFinishReCallVoice(data:TCallDevCallBackData);
    {功能:挂断设备回调函数}
    procedure OnDisConDevEvent(data:TCallDevCallBackData);
    {功能:插入进度日志}
    procedure AddMemLog(strMsg:string);
  public
    {功能:自动叫班}
    //class function AutoCall(callRecord :TCallRoomRecord;callRoomPlan:TCallRoomPlan):Boolean;
  end;



implementation

uses
  MMSystem,StrUtils;

{$INCLUDE uDebug.inc}

{$R *.dfm}

{ TFrmAutoCall }

procedure TFrmAutoCall_Insert.AddMemLog(strMsg: string);
begin
  mmo1.Lines.Add(TPubfun.DateTime2Str(Now) + ':' +strMsg);
end;

procedure TFrmAutoCall_Insert.btnConfirmClick(Sender: TObject);
begin
  tmrTryPlay.Enabled := false ;
  tmrAutoClose.Enabled := False;
  m_RoomCallApp.CallDevOp.StopPlaySound;
  DisConDev;
end;



procedure TFrmAutoCall_Insert.ClearEventFun;
begin
  m_RoomCallApp.CallDevOp.OnStartConDevEvent := nil;
  m_RoomCallApp.CallDevOp.OnTryConDevEvent := nil;
  m_RoomCallApp.CallDevOp.OnFinishConDevEvent := nil;
  m_RoomCallApp.CallDevOp.OnQueryConDevEvent := nil ;

  m_RoomCallApp.CallDevOp.OnStartFirstCallVoiceEvent := nil;
  m_RoomCallApp.CallDevOp.OnFinishFistCallVoiceEvent:=nil;

  m_RoomCallApp.CallDevOp.OnStartReCallVoiceEvent := nil;
  m_RoomCallApp.CallDevOp.OnFinishReCallVoiceEvent := nil;
  m_RoomCallApp.CallDevOp.OnDisConDevEvent := nil;
end;

function TFrmAutoCall_Insert.ConDev: Boolean;
var
  strMsg:string;
begin
  result := False;
  try
    m_RoomCallApp.CallDevOp.CallRecord.Clone(m_CallRecord);
    if m_CallRecord.eCallState = TCS_FIRSTCALL then
    begin
      //如果联叫>于1
      if Length(m_CallMultiDevicesArray) > 1 then
        result := m_RoomCallApp.CallDevOp.AutoFirstCalls(m_CallMultiDevicesArray,strMsg)
      else
        result := m_RoomCallApp.CallDevOp.AutoFirstCall(strMsg)
    end
    else
    begin
      //如果联叫>于1
      if Length(m_CallMultiDevicesArray) > 1 then
        result := m_RoomCallApp.CallDevOp.AutoReCalls(m_CallMultiDevicesArray,strMsg)
      else
        result := m_RoomCallApp.CallDevOp.AutoReCall(strMsg)
    end;
    if result = false then
      AddMemLog(strMsg);
  finally
    if result = False  then
    begin
      m_RoomCallApp.CallDevOp.PlaySoundFileLoop(GlobalDM.AppPath + 'Sounds\'+'叫班失败.wav');
      tmrAutoClose.Enabled := True;
      m_nLeftTimeCount := FIRST_CALL_WAIT_TIME ;
      btnConfirm.Caption := Format('关闭(%2d)',[m_nLeftTimeCount])  ;
      btnConfirm.Visible := true;
    end;
  end;
end;

procedure TFrmAutoCall_Insert.CreateCallMultiDevicesInfo;
  function GetDeviceID(Text: string): Integer;
  var
    idStr: string;
    nStart, nLen: Integer;
  begin
    nStart := Pos('=', Text);
    nLen := Length(Text) - nStart;
    idStr := MidStr(Text, nStart + 1, nLen);
    Result := StrToInt(idStr);
  end;

  function GetRoomNumber(Text: string): string;
  var
    nStart, nLen: Integer;
  begin
    nStart := Pos('=', Text);
    nLen := Length(Text) - nStart;
    Result := LeftStr(Text, nStart -1);
  end;
{
房间 id
201=123
}
var
  strText:string;
  nLen,nDeviceID : Integer ;
  i : Integer ;
begin

  SetLength(m_CallMultiDevicesArray,0);

  nLen := m_CallRecord.JoinRooms.Count + 1 ;
  SetLength(m_CallMultiDevicesArray, nLen);

  m_CallMultiDevicesArray[0].roomnumber := m_CallRecord.strRoomNum ;
  m_CallMultiDevicesArray[0].idSrc := m_CallRecord.nDeviceID ;
  m_CallMultiDevicesArray[0].idDst := 0 ;
  m_CallMultiDevicesArray[0].state := 0 ;

  for I := 1 to nLen - 1 do
  begin
    strText :=  m_CallRecord.JoinRooms.Strings[i-1]  ;
    m_CallMultiDevicesArray[I].roomnumber := GetRoomNumber(strText)  ;
    m_CallMultiDevicesArray[I].idSrc := GetDeviceID(strText)  ;
    m_CallMultiDevicesArray[I].idDst := 0 ;
    m_CallMultiDevicesArray[I].state := 0 ;
  end;
end;

function TFrmAutoCall_Insert.DisConDev: Boolean;
var
  strmsg:string;
  strStopMusic:string;
begin
  result := False;
  if m_CallRecord.eCallState = TCS_FIRSTCALL then
  begin
    strStopMusic :=  ExtractFilePath(Application.ExeName) + 'CallMusic\谢谢合作.wav' ;
    MMSystem.PlaySound(PChar(strStopMusic), 0, SND_FILENAME or SND_SYNC);
  end;

  if m_RoomCallApp.CallDevOp.bCalling then
  begin
    m_RoomCallApp.CallDevOp.bCancel := True;
    m_RoomCallApp.CallDevOp.CloseThread();
  end;


  AddMemLog('开始挂断!');

  if Length(m_CallMultiDevicesArray) > 1 then
    m_RoomCallApp.CallDevOp.DisConDeviceAll(m_CallMultiDevicesArray,strMsg)
  else
    m_RoomCallApp.CallDevOp.DisConDevice(strMsg) ;

end;




procedure TFrmAutoCall_Insert.FormCreate(Sender: TObject);
begin
  m_nFirstCallCount := 0 ;
  m_RoomCallApp := TRoomCallApp.GetInstance;
  m_CallRecord:=TCallRoomRecord.Create;
    //房间叫班计划
  m_CallRoomPlan:=TCallRoomPlan.Create;
end;

procedure TFrmAutoCall_Insert.FormDestroy(Sender: TObject);
begin
  FreeAndNil(m_CallRecord);
    //房间叫班计划
  FreeAndNil(m_CallRoomPlan);
  ClearEventFun;
end;

procedure TFrmAutoCall_Insert.FormShow(Sender: TObject);
begin
  CreateCallMultiDevicesInfo;
  m_bConSucess := False;
  ShowCallInfo();
  if SetEventFun = True then
    ConDev();
end;

procedure TFrmAutoCall_Insert.OnDisConDevEvent(data: TCallDevCallBackData);
begin
  //if m_bConSucess = False then
  //  m_RoomCallApp.CallDevOp.PlaySoundFileLoop(GlobalDM.AppPath + 'Sounds\'+'叫班失败.wav');
  if Assigned(FinishCallResult) then
    FinishCallResult(m_bConSucess,data);
end;

procedure TFrmAutoCall_Insert.OnFinishConDev(data: TCallDevCallBackData);
var
  strMsg:string;
begin
  m_bConSucess := False;
  case data.callRoomRecord.eCallResult of
    TR_SUCESS:
    begin
      strMsg := Format('第%d次呼叫房间设备,结果:成功!',[data.callRoomRecord.nConTryTimes]) ;
      m_bConSucess:= True;
    end ;
    TR_FAIL:
    begin
      strMsg := Format('第%d次呼叫房间设备,结果:失败,原因:%s',[data.callRoomRecord.nConTryTimes,data.callRoomRecord.strMsg]);
    end;
    TR_CANCEL:
    begin
      strMsg := Format('第%d次呼叫房间设备,结果:失败,原因:%s',[data.callRoomRecord.nConTryTimes,'用户取消']);
    end;
    TR_TIMEOUT:
    begin
      strMsg := Format('第%d次呼叫房间设备,结果:失败,原因:%s',[data.callRoomRecord.nConTryTimes,'呼叫超时']);
    end;
  else ;
  end;
  if data.callRoomRecord.eCallResult <> TR_SUCESS then
  begin
    //DisConDev;

    m_RoomCallApp.CallDevOp.PlaySoundFileLoop(GlobalDM.AppPath + 'Sounds\'+'叫班失败.wav');
    tmrAutoClose.Enabled := True;
    m_nLeftTimeCount := FIRST_CALL_WAIT_TIME;
    btnConfirm.Caption := Format('关闭(%2d)',[m_nLeftTimeCount])  ;
    btnConfirm.Visible := true;
  end;
end;

procedure TFrmAutoCall_Insert.OnFinishFirstCallVoice(data: TCallDevCallBackData);
begin
  Inc(m_nFirstCallCount);

  m_RoomCallApp.CallDevOp.CloseThread;
  m_nVoiceEnd := GetTickCount();

  tmrTryPlay.Enabled := true ;
  tmrTryPlay.Tag := 0 ;



  if not tmrAutoClose.Enabled then
  begin
    tmrAutoClose.Enabled := True;
    m_nLeftTimeCount := FIRST_CALL_WAIT_TIME;
    btnConfirm.Caption := Format('关闭(%2d)',[m_nLeftTimeCount])  ;

    btnConfirm.Visible := True;
  end;

  if m_nFirstCallCount >= FIRST_CALL_COUNT then
  begin
    tmrTryPlay.Enabled := false ;
    AddMemLog('语音播放完毕');
    AddMemLog(data.callRoomRecord.strMsg);
  end;
end;

procedure TFrmAutoCall_Insert.OnFinishReCallVoice(data: TCallDevCallBackData);
begin
  AddMemLog('语音播放完毕');
  AddMemLog(data.callRoomRecord.strMsg);
  m_RoomCallApp.CallDevOp.CloseThread;
  tmrAutoClose.Enabled := True;
  m_nLeftTimeCount := RE_CALL_WAIT_TIME ;
  btnConfirm.Caption := Format('关闭(%2d)',[m_nLeftTimeCount])  ;
  m_nVoiceEnd := GetTickCount();
  btnConfirm.Visible := True;
end;

procedure TFrmAutoCall_Insert.OnQueryConDev(data: TCallDevCallBackData);
var
  strMsg:string;
begin
  m_bConSucess := False;
  case data.callRoomRecord.eCallResult of
    TR_SUCESS:
    begin
      //btnSysVoice.Enabled := True;
      strMsg := Format('第%d次呼叫,结果:成功,备注%s',[data.callRoomRecord.nConTryTimes,data.callRoomRecord.strMsg]) ;
      //m_RoomCallApp.CallDevOp.CloseThread();
      m_bConSucess:= True;
    end ;
    TR_FAIL:
    begin
      strMsg := Format('第%d次呼叫,结果:失败,原因:%s',[data.callRoomRecord.nConTryTimes,data.callRoomRecord.strMsg]);
      //btnDisconnect.Enabled := True;
    end;
    TR_CANCEL:
    begin
      strMsg := Format('第%d次呼叫,结果:失败,原因:%s',[data.callRoomRecord.nConTryTimes,'用户取消']);
      //btnSysVoice.Enabled := False;
    end;
    TR_TIMEOUT:
    begin
      strMsg := Format('第%d次呼叫,结果:失败,原因:%s',[data.callRoomRecord.nConTryTimes,'呼叫超时']);
      //btnSysVoice.Enabled := False;
    end;
  else ;
  end;
  AddMemLog(strMsg);
end;

procedure TFrmAutoCall_Insert.OnStartConDev(data: TCallDevCallBackData);
var
  strMsg:string;
begin
  strMsg:= Format('第%d次连接设备.',[data.callRoomRecord.nConTryTimes]);
  AddMemLog(strMsg);
  //btnDisconnect.Enabled := True;
end;
{功能:尝试连接设备回到}
procedure TFrmAutoCall_Insert.OnTryConDev(data:TCallDevCallBackData);
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
end;


procedure TFrmAutoCall_Insert.OnStartFirstCallVoice(data: TCallDevCallBackData);
begin
  AddMemLog('开始播放首叫语音');
end;

procedure TFrmAutoCall_Insert.OnStartReCallVoice(data: TCallDevCallBackData);
begin
  AddMemLog('开始播放催叫语音');
end;


function TFrmAutoCall_Insert.SetEventFun: Boolean;
begin
  result := False;
  if m_RoomCallApp.CallDevOp.bCalling then Exit;

  m_RoomCallApp.CallDevOp.OnStartConDevEvent := Self.OnStartConDev;
  m_RoomCallApp.CallDevOp.OnTryConDevEvent := Self.OnTryConDev;
  m_RoomCallApp.CallDevOp.OnQueryConDevEvent := Self.OnQueryConDev;
  m_RoomCallApp.CallDevOp.OnFinishConDevEvent := Self.OnFinishConDev;
  m_RoomCallApp.CallDevOp.OnFinishFistCallVoiceEvent:= Self.OnFinishFirstCallVoice;
  m_RoomCallApp.CallDevOp.OnStartFirstCallVoiceEvent := Self.OnStartFirstCallVoice;

  m_RoomCallApp.CallDevOp.OnStartReCallVoiceEvent := Self.OnStartReCallVoice;
  m_RoomCallApp.CallDevOp.OnFinishReCallVoiceEvent := Self.OnFinishReCallVoice;

  m_RoomCallApp.CallDevOp.OnDisConDevEvent := Self.OnDisConDevEvent;
  result := True;
end;

procedure TFrmAutoCall_Insert.ShowCallInfo;
var
  waitMgr:TWaitWorkMgr;
  waitPlan:TWaitWorkPlan;
  i:Integer;
begin
  waitMgr := TWaitWorkMgr.GetInstance(GlobalDM.LocalADOConnection);
  waitPlan := waitMgr.planList.Find(m_CallRoomPlan.strWaitPlanGUID);
  if waitPlan <> nil then
  begin
    edtWaitTime.Text := TPubFun.DT2StrmmddHHnn(waitPlan.dtWaitWorkTime);
    edtCallTime.Text := TPubFun.DT2StrmmddHHnn(waitPlan.dtCallWorkTime);
  end;
  edtTrainNo.Text := m_CallRecord.strTrainNo;
  edtRoomNum.Text := m_CallRecord.strRoomNum;
  lblCallType.Caption := TRoomCallStateNameAry[m_CallRecord.eCallState];


//  Grid1.ClearRows(1, 10000);
//  Grid1.RowCount := 2;
  for i := 0 to m_CallRoomPlan.manList.Count - 1 do
  begin
    //Grid1.Cells[0,i+1] := IntToStr(i+1);
    Grid1.RowHeights[i+1] := 30;
    Grid1.Cells[0,i+1] := m_CallRoomPlan.manList.Items[i].strTrainmanNumber;
    Grid1.Cells[1,i+1] := m_CallRoomPlan.manList.Items[i].strTrainmanName;
  end;

end;

procedure TFrmAutoCall_Insert.tmrAutoCloseTimer(Sender: TObject);
begin
  m_nLeftTimeCount := m_nLeftTimeCount -1;
  btnConfirm.Caption := Format('关闭(%2d)',[m_nLeftTimeCount])  ;
  if m_nLeftTimeCount <= 0 then
  begin
    tmrAutoClose.Enabled := False;
    DisConDev;
  end;
end;

procedure TFrmAutoCall_Insert.tmrTryPlayTimer(Sender: TObject);
var
  strMsg:string;
begin
  TTimer(Sender).Tag := TTimer(Sender).Tag + 1;
  if TTimer(Sender).Tag >= FIRST_CALL_ELAPSE_SECOND then
  begin
    AddMemLog('开始次播放');
    TTimer(Sender).Enabled := false ;
    if m_CallRecord.eCallState = TCS_FIRSTCALL then
       m_RoomCallApp.CallDevOp.DoFirstCall(strMsg)  ;
  end;
end;

end.
