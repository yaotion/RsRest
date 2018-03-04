unit uFrmMunualMonitor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uRoomCallApp,uCallUtils,uRoomCallMsgDefine,uTFSystem,
  uRoomCall,uGlobalDM, ExtCtrls,uPubFun,uRoomCallOp,uSaftyEnum, ComCtrls;

type
  TFrmMunualMonitor = class(TForm)
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
    ListView1: TListView;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnSysVoiceClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tmrAutoCloseTimer(Sender: TObject);
    procedure edtRoomNumChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
  private
    {功能:填充列表}
    procedure FillGrid();
  public
    {刷新数据}
    procedure ReFreshData();
    procedure InitData(strCheCi,strRoomNum:string);
  private
      //房间设备数组
    m_RoomDevAry:TCallDevAry;
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
  function MunualMonitor(strCheCi:string = '';strRoomNum:string = ''):Boolean;

implementation
{$INCLUDE uDebug.inc}

uses
  utfPopBox,ufrmHint ;

{$R *.dfm}
function MunualMonitor(strCheCi:string ='';strRoomNum:string = ''):Boolean;
var
  frm: TFrmMunualMonitor;
begin
  result := False;
  frm := TFrmMunualMonitor.Create(nil);
  try
    frm.InitData(strCheCi,strRoomNum);
    if frm.ShowModal = mrOk then
      result := True;
  finally
    frm.Free;
  end;

end;  
procedure TFrmMunualMonitor.AddMemLog(strMsg: string);
begin

  mmoState.Lines.Add(TPubfun.DateTime2Str(Now) + ' : ' +strMsg);
end;

procedure TFrmMunualMonitor.btnCloseClick(Sender: TObject);
begin
  //if btnDisconnect.Enabled = True then
  // btnDisconnectClick(nil);
  self.modalResult := mrok;
end;

procedure TFrmMunualMonitor.btnConnectClick(Sender: TObject);
var
  strMsg:string;
begin

  AddMemLog('开始检测') ;
{$IFNDEF UART_DEBUG}
  if m_RoomCallApp.CallDevOp.OpenPort = False then
  begin
    AddMemLog('端口打开失败!');
    Exit;
  end;
{$ENDIF}
  if m_RoomCallApp.CallDevOp.bCalling then
  begin
    AddMemLog('正在叫班,');
    Exit;
  end;



  if self.InitCallRecord = False then
  begin
    Exit;
  end;
  m_RoomCallApp.CallDevOp.CallRecord.Clone(m_CallRecord);

  AddMemLog('开始监听房间设备,连接中...');
  btnDisconnect.Enabled := true;
  if m_RoomCallApp.CallDevOp.MonitorConDevice(strMsg) = False then
  begin
    AddMemLog(strMsg);
    Exit;
  end;
  //btnConnect.Enabled := False;
end;

procedure TFrmMunualMonitor.btnDisconnectClick(Sender: TObject);
var
  strmsg:string;
begin
  if m_RoomCallApp.CallDevOp.bCalling then
  begin
    m_RoomCallApp.CallDevOp.bCancel := True;
    m_RoomCallApp.CallDevOp.CloseThread();
  end;

  TfrmHint.ShowHint('正在挂断设备,请稍等5秒钟!!!');
  try
    AddMemLog('正在挂断设备,请稍等!');
    if m_RoomCallApp.CallDevOp.DisConDevice(strMsg) = False Then
    begin
      AddMemLog('挂断失败!');
      Exit;
    end;
  finally
    TfrmHint.CloseHint;
  end;
  AddMemLog('挂断设备完毕!');
  btnConnect.Enabled := True;
  btnSysVoice.Enabled := False;
  btnDisconnect.Enabled := False;
  AddMemLog('挂断设备!');

end;

procedure TFrmMunualMonitor.btnSysVoiceClick(Sender: TObject);
var
  strMsg:string;
begin
{$IFNDEF UART_DEBUG}
  if m_RoomCallApp.CallDevOp.OpenPort = False then
  begin
    AddMemLog('端口打开失败!');
    Exit;
  end;
{$ENDIF}

  //m_RoomCallApp.CallDevOp.CallRecord := m_CallRecord;

  if m_RoomCallApp.CallDevOp.MunualFirstCallRoom(strMsg) = False then
  begin
    AddMemLog(strMsg);
    Exit;
  end;
  lbl_Nofity.Visible := False;
  tmrAutoClose.Enabled := False;

end;

procedure TFrmMunualMonitor.edtRoomNumChange(Sender: TObject);
begin
  ReFreshData;
end;

procedure TFrmMunualMonitor.FillGrid;
var
  i:Integer;
  item : TListItem;
begin
  ListView1.Items.Clear;
  for I := 0 to Length(m_RoomDevAry) - 1 do
  begin
    item := ListView1.Items.Add;
    item.Caption := m_roomDevAry[i].strRoomNum;
    item.SubItems.Add( IntToStr(m_roomDevAry[i].nDevNum));
    item.Data := Pointer(@m_roomDevAry[i]);
  end;
end;



procedure TFrmMunualMonitor.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
  if btnClose.Enabled = true then
  begin
    btnDisconnectClick(nil);
    CanClose := True;
  end;

end;

procedure TFrmMunualMonitor.FormCreate(Sender: TObject);
begin
  m_RoomCallApp:=TRoomCallApp.GetInstance;
  m_RoomCallApp.CallDevOp.OnStartConDevEvent := Self.OnStartConDev;
  m_RoomCallApp.CallDevOp.OnFinishConDevEvent := Self.OnFinishConDev;
  m_RoomCallApp.CallDevOp.OnFinishFistCallVoiceEvent:= Self.OnFinishFirstCallVoice;
  m_RoomCallApp.CallDevOp.OnStartFirstCallVoiceEvent := Self.OnStartFirstCallVoice;
  m_RoomCallApp.CallDevOp.OnDisConDevEvent := Self.OnDisConDevEvent;
  m_CallRoomPlan := TCallRoomPlan.Create;
  m_nLeftTimeCount := 180;
end;

procedure TFrmMunualMonitor.FormDestroy(Sender: TObject);
begin
  m_RoomCallApp.CallDevOp.OnStartConDevEvent := nil;
  m_RoomCallApp.CallDevOp.OnFinishConDevEvent := nil;
  m_RoomCallApp.CallDevOp.OnFinishFistCallVoiceEvent:= nil;
  m_RoomCallApp.CallDevOp.OnStartFirstCallVoiceEvent := nil;
  if m_CallRecord <> nil then
    m_CallRecord.Free;
  m_CallRoomPlan.Free;
end;

procedure TFrmMunualMonitor.FormShow(Sender: TObject);
begin
  edtRoomNum.Text := m_strRoomNum;
  edtTrainNo.Text := m_strCheCi;
  ReFreshData();
end;



function TFrmMunualMonitor.InitCallRecord:Boolean;
var
  dev:RCallDev;
  callmanplan:TCallManPlan;
  CallDev:PCallDev;
begin
  result := False;
  {if Trim(edtTrainNo.Text) ='' then
  begin
    TtfPopBox.ShowBox('车次不能为空!');
    Exit;
  end;  }
  if ListView1.Items.Count = 1 then
  begin
    CallDev :=  PCallDev(ListView1.Items[0].Data);
  end
  else
  begin
    if ListView1.Selected = nil then
    begin
      Application.MessageBox('请选择要监听的房间','提示',MB_OK + MB_ICONINFORMATION);
      exit;
    end;
    if Integer(ListView1.Selected.Data) = 0 then
    begin
      Application.MessageBox('该房间还未安装设备','提示',MB_OK + MB_ICONINFORMATION);
      exit;
    end;
    CallDev :=  PCallDev(ListView1.Selected.Data);
  end;



  if m_CallRecord <> nil then
    m_CallRecord.Free;
  //构造叫班计划
  callmanplan:=TCallManPlan.Create;
  if CallDev <> nil then
    callmanplan.strRoomNum := CallDev^.strRoomNum
  else
    callmanplan.strRoomNum := Trim(edtRoomNum.Text);

  callmanplan.strTrainNo:= Trim(edtTrainNo.Text);
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
  m_CallRecord.eCallType:=TCT_MonitorCall;
  result := True;
end;




procedure TFrmMunualMonitor.InitData(strCheCi,strRoomNum:string);
begin
  self.m_strCheCi := strCheCi;
  self.m_strRoomNum := strRoomNum;
  if strRoomNum <> '' then
  begin
    Timer1.Enabled := true ;
  end;
end;

procedure TFrmMunualMonitor.ListView1Click(Sender: TObject);
var
  CallDev : PCallDev ;
begin
  if ListView1.Selected = nil then
  begin
    exit;
  end;
  if Integer(ListView1.Selected.Data) = 0 then
  begin
    exit;
  end;
  CallDev :=  PCallDev(ListView1.Selected.Data);
  Self.Caption := '监听房间: ' +  CallDev.strRoomNum ;
end;

procedure TFrmMunualMonitor.OnDisConDevEvent(data: TCallDevCallBackData);
var
  CallRecord :TCallRoomRecord;
  i:Integer;
  strFilePath:string;
begin
  tmrAutoClose.Enabled := false ;
  lbl_Nofity.Visible := False;
  
  if chkSaveVoice.Checked = False  then Exit;


  CallRecord := data.callRoomRecord;

//  if ( CallRecord.strRoomNum ='' )    then
//    exit ;

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

procedure TFrmMunualMonitor.OnFinishConDev(data:TCallDevCallBackData);
var
  strMsg:string;
begin
  btnConnect.Enabled := True;
  case data.callRoomRecord.eCallResult of
    TR_SUCESS:
    begin
      btnSysVoice.Enabled := True;
      strMsg := Format('第%d次监听房间设备,结果:成功!',[data.callRoomRecord.nConTryTimes]) ;
      btnConnect.Enabled := False;
    end ;
    TR_FAIL:
    begin
      strMsg := Format('第%d次监听房间设备,结果:失败,原因:%s',[data.callRoomRecord.nConTryTimes,data.callRoomRecord.strMsg]);
      btnDisconnect.Enabled := True;
    end;
    TR_CANCEL:
    begin
      strMsg := Format('第%d次监听房间设备,结果:失败,原因:%s',[data.callRoomRecord.nConTryTimes,'用户取消']);
      btnSysVoice.Enabled := False;
    end;
    TR_TIMEOUT:
    begin
      strMsg := Format('第%d次监听房间设备,结果:失败,原因:%s',[data.callRoomRecord.nConTryTimes,'呼叫超时']);
      btnSysVoice.Enabled := False;
    end;
  else ;
  end;
  m_RoomCallApp.CallDevOp.CloseThread();
  //lbl_Nofity.Caption := IntToStr(m_nLeftTimeCount) +  '秒后自动关闭';
  //lbl_Nofity.Visible := True;
  //tmrAutoClose.Enabled := True;
  AddMemLog(strMsg);
end;

procedure TFrmMunualMonitor.OnFinishFirstCallVoice(data:TCallDevCallBackData);
begin
  btnSysVoice.Enabled := True;
  AddMemLog(data.callRoomRecord.strMsg);

  m_RoomCallApp.CallDevOp.CloseThread;
  lbl_Nofity.Visible := True;
  m_nLeftTimeCount := 180;
  lbl_Nofity.Caption := IntToStr(m_nLeftTimeCount) +  '秒后自动关闭';
  tmrAutoClose.Enabled := True;
end;

procedure TFrmMunualMonitor.OnStartConDev(data:TCallDevCallBackData);
var
  strMsg:string;
begin
  strMsg:= Format('第%d次连接设备.',[data.callRoomRecord.nConTryTimes]);
  AddMemLog(strMsg);
  btnDisconnect.Enabled := True;
end;

procedure TFrmMunualMonitor.OnStartFirstCallVoice(data:TCallDevCallBackData);
begin
  AddMemLog('开始监听');
end;

procedure TFrmMunualMonitor.OnTryConDev(data: TCallDevCallBackData);
var
  strMsg:string;
begin
  case data.callRoomRecord.eCallResult of
    TR_SUCESS:
    begin
      btnSysVoice.Enabled := True;
      strMsg := Format('第%d次监听房间设备,结果:成功!',[data.callRoomRecord.nConTryTimes]) ;
    end ;
    TR_FAIL:
    begin
      strMsg := Format('第%d次监听房间设备,结果:失败,原因:%s',[data.callRoomRecord.nConTryTimes,data.callRoomRecord.strMsg]);
      btnDisconnect.Enabled := True;
    end;
    TR_CANCEL:
    begin
      strMsg := Format('第%d次监听房间设备,结果:失败,原因:%s',[data.callRoomRecord.nConTryTimes,'用户取消']);
      btnSysVoice.Enabled := False;
    end;
    TR_TIMEOUT:
    begin
      strMsg := Format('第%d次监听房间设备,结果:失败,原因:%s',[data.callRoomRecord.nConTryTimes,'呼叫超时']);
      btnSysVoice.Enabled := False;
    end;
  else ;
  end;
  AddMemLog(strMsg);
end;

procedure TFrmMunualMonitor.ReFreshData;
var
  strRoomNumber:string ;
begin
  strRoomNumber := Trim(edtRoomNum.Text);
  m_RoomCallApp.DBCallDev.QueryRooms(strRoomNumber,m_RoomDevAry);
  FillGrid();
end;

procedure TFrmMunualMonitor.Timer1Timer(Sender: TObject);
begin
  TTimer(Sender).Enabled := false ;
  btnConnect.Click ;
end;

procedure TFrmMunualMonitor.tmrAutoCloseTimer(Sender: TObject);
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
