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
    {����:����б�}
    procedure FillGrid();
  public
    {ˢ������}
    procedure ReFreshData();
    procedure InitData(strCheCi,strRoomNum:string);
  private
      //�����豸����
    m_RoomDevAry:TCallDevAry;
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

  AddMemLog('��ʼ���') ;
{$IFNDEF UART_DEBUG}
  if m_RoomCallApp.CallDevOp.OpenPort = False then
  begin
    AddMemLog('�˿ڴ�ʧ��!');
    Exit;
  end;
{$ENDIF}
  if m_RoomCallApp.CallDevOp.bCalling then
  begin
    AddMemLog('���ڽа�,');
    Exit;
  end;



  if self.InitCallRecord = False then
  begin
    Exit;
  end;
  m_RoomCallApp.CallDevOp.CallRecord.Clone(m_CallRecord);

  AddMemLog('��ʼ���������豸,������...');
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

  TfrmHint.ShowHint('���ڹҶ��豸,���Ե�5����!!!');
  try
    AddMemLog('���ڹҶ��豸,���Ե�!');
    if m_RoomCallApp.CallDevOp.DisConDevice(strMsg) = False Then
    begin
      AddMemLog('�Ҷ�ʧ��!');
      Exit;
    end;
  finally
    TfrmHint.CloseHint;
  end;
  AddMemLog('�Ҷ��豸���!');
  btnConnect.Enabled := True;
  btnSysVoice.Enabled := False;
  btnDisconnect.Enabled := False;
  AddMemLog('�Ҷ��豸!');

end;

procedure TFrmMunualMonitor.btnSysVoiceClick(Sender: TObject);
var
  strMsg:string;
begin
{$IFNDEF UART_DEBUG}
  if m_RoomCallApp.CallDevOp.OpenPort = False then
  begin
    AddMemLog('�˿ڴ�ʧ��!');
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
    TtfPopBox.ShowBox('���β���Ϊ��!');
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
      Application.MessageBox('��ѡ��Ҫ�����ķ���','��ʾ',MB_OK + MB_ICONINFORMATION);
      exit;
    end;
    if Integer(ListView1.Selected.Data) = 0 then
    begin
      Application.MessageBox('�÷��仹δ��װ�豸','��ʾ',MB_OK + MB_ICONINFORMATION);
      exit;
    end;
    CallDev :=  PCallDev(ListView1.Selected.Data);
  end;



  if m_CallRecord <> nil then
    m_CallRecord.Free;
  //����а�ƻ�
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
  //�ֹ��а಻��ϲ������,������һ������Ľа��¼����,��Ա��Ϣ����
  m_CallRecord.Init(m_CallRoomPlan,GlobalDM.GetNow());

  if m_RoomCallApp.DBCallDev.FindByRoom(m_CallRecord.strRoomNum,dev) = False then
  begin
    TtfPopBox.ShowBox('����δָ���а��豸���!');
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
  Self.Caption := '��������: ' +  CallDev.strRoomNum ;
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
      strMsg := Format('��%d�μ��������豸,���:�ɹ�!',[data.callRoomRecord.nConTryTimes]) ;
      btnConnect.Enabled := False;
    end ;
    TR_FAIL:
    begin
      strMsg := Format('��%d�μ��������豸,���:ʧ��,ԭ��:%s',[data.callRoomRecord.nConTryTimes,data.callRoomRecord.strMsg]);
      btnDisconnect.Enabled := True;
    end;
    TR_CANCEL:
    begin
      strMsg := Format('��%d�μ��������豸,���:ʧ��,ԭ��:%s',[data.callRoomRecord.nConTryTimes,'�û�ȡ��']);
      btnSysVoice.Enabled := False;
    end;
    TR_TIMEOUT:
    begin
      strMsg := Format('��%d�μ��������豸,���:ʧ��,ԭ��:%s',[data.callRoomRecord.nConTryTimes,'���г�ʱ']);
      btnSysVoice.Enabled := False;
    end;
  else ;
  end;
  m_RoomCallApp.CallDevOp.CloseThread();
  //lbl_Nofity.Caption := IntToStr(m_nLeftTimeCount) +  '����Զ��ر�';
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
  lbl_Nofity.Caption := IntToStr(m_nLeftTimeCount) +  '����Զ��ر�';
  tmrAutoClose.Enabled := True;
end;

procedure TFrmMunualMonitor.OnStartConDev(data:TCallDevCallBackData);
var
  strMsg:string;
begin
  strMsg:= Format('��%d�������豸.',[data.callRoomRecord.nConTryTimes]);
  AddMemLog(strMsg);
  btnDisconnect.Enabled := True;
end;

procedure TFrmMunualMonitor.OnStartFirstCallVoice(data:TCallDevCallBackData);
begin
  AddMemLog('��ʼ����');
end;

procedure TFrmMunualMonitor.OnTryConDev(data: TCallDevCallBackData);
var
  strMsg:string;
begin
  case data.callRoomRecord.eCallResult of
    TR_SUCESS:
    begin
      btnSysVoice.Enabled := True;
      strMsg := Format('��%d�μ��������豸,���:�ɹ�!',[data.callRoomRecord.nConTryTimes]) ;
    end ;
    TR_FAIL:
    begin
      strMsg := Format('��%d�μ��������豸,���:ʧ��,ԭ��:%s',[data.callRoomRecord.nConTryTimes,data.callRoomRecord.strMsg]);
      btnDisconnect.Enabled := True;
    end;
    TR_CANCEL:
    begin
      strMsg := Format('��%d�μ��������豸,���:ʧ��,ԭ��:%s',[data.callRoomRecord.nConTryTimes,'�û�ȡ��']);
      btnSysVoice.Enabled := False;
    end;
    TR_TIMEOUT:
    begin
      strMsg := Format('��%d�μ��������豸,���:ʧ��,ԭ��:%s',[data.callRoomRecord.nConTryTimes,'���г�ʱ']);
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
  lbl_Nofity.Caption := IntToStr(m_nLeftTimeCount) +  '����Զ��ر�';
  if m_nLeftTimeCount <= 0 then
  begin
    tmrAutoClose.Enabled := False;
    btnCloseClick(nil); 
  end;
end;

end.
