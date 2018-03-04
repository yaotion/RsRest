unit uFrmRoomSync;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RzPanel, Buttons, PngCustomButton,uGlobalDM
  ,uUPDateThread,uTFMessageDefine,uTFMessageComponent,uTrainman,
  uRunSaftyMessageDefine,uWaitWorkMgr,uWaitWork,uWebIF,superobject,
  uTFSystem,uDBLocalTrainman;

type
  TFrmRoomSync = class(TForm)
    rzpnlTop: TRzPanel;
    mmoLogs: TMemo;
    btnStop: TPngCustomButton;
    btnStart: TPngCustomButton;
    btn1: TPngCustomButton;
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  public
    {功能:开始同步}
    function StartUpdate():Boolean;
    {功能:停止同步}
    procedure StopUpdate();
  private
    {日志输出}
    procedure InsertLogs(strLogText: string);
    {初始化消息组件}
    procedure InitMsgComponent();
    {功能:关闭消息组件}
    procedure UnInitMsgComponent();
    {功能:消息组件消息数据回调}
    procedure OnTFMessage(TFMessages: TTFMessageList);
    {功能:消息组件报错回调}
    procedure OnMessageError(strText: string);
    {功能:得到计划类型}
    function GetPlanType(eMsgID:Integer):TWaitWorkPlanType;
   
  private
    //同步线程
    m_UPDateThread : TUPDateThread;
    //待乘管理
    m_WaitWorkMgr: TWaitWorkMgr;
    //web接口操作
    m_WebIF:TWebIF;
    //人员指纹特征修改
    m_DBTrainman:TRsDBLocalTrainman;

  end;

var
  FrmRoomSync: TFrmRoomSync;

implementation

{$R *.dfm}

procedure TFrmRoomSync.btn1Click(Sender: TObject);
begin
  m_DBTrainman.SetTrainmanSignature('');
end;

procedure TFrmRoomSync.btnStartClick(Sender: TObject);
begin

  if StartUpdate = True then
  begin
    btnStart.Enabled := False;
    btnStop.Enabled := True;

  end;
end;

procedure TFrmRoomSync.btnStopClick(Sender: TObject);
begin
  StopUpdate ;
  btnStop.Enabled := False;
  btnStart.Enabled := True;
end;

procedure TFrmRoomSync.FormCreate(Sender: TObject);
begin
  //ShowMessage('1');
  m_WaitWorkMgr:= TWaitWorkMgr.GetInstance(GlobalDM.LocalADOConnection);
  //ShowMessage('2');
  btnStop.Enabled := False;
  m_WebIF:=TWebIF.Create;
  m_WebIF.webConfig.strCID := GlobalDM.SiteInfo.strSiteGUID;
  m_WebIF.webConfig.strURL := GlobalDM.GetWebUrl();
  m_DBTrainman:= TRsDBLocalTrainman.Create(GlobalDM.LocalADOConnection);
end;

procedure TFrmRoomSync.FormDestroy(Sender: TObject);
begin
  if btnStop.Enabled then
    btnStopClick(nil);
  m_WebIF.Free;
  m_DBTrainman.Free;
end;

procedure TFrmRoomSync.FormShow(Sender: TObject);
begin
  //InitMsgComponent();
end;

procedure TFrmRoomSync.InitMsgComponent;
begin
  if GlobalDM.bLeaveLine then
    Exit;
  GlobalDM.TFMessageCompnent.OnMessage := OnTFMessage;
  GlobalDM.TFMessageCompnent.Open();
end;

procedure TFrmRoomSync.InsertLogs(strLogText: string);
begin
  if MmoLogs.Lines.Count>1000 then
  begin
    MmoLogs.Lines.Clear;
  end;
  strLogText := formatDateTime('[yyyy-mm-dd hh:nn:ss]', now) + ' ' + strLogText;
  if MmoLogs.Lines.Count > 1000 then
    MmoLogs.Lines.Clear;
  MmoLogs.Lines.Add(strLogText);
end;

procedure TFrmRoomSync.OnMessageError(strText: string);
begin

end;

procedure TFrmRoomSync.OnTFMessage(TFMessages: TTFMessageList);
var
  i,J: Integer;
  GUIDS: TStringList;
  strMessageType: string;
  ePlanType:TWaitWorkPlanType;
  planIDInfo:TSyncPlanIDInfo;
begin
  GUIDS := TStringList.Create;
  try
    for I := 0 to TFMessages.Count - 1 do
    begin
      TFMessages.Items[i].nResult := TFMESSAGE_STATE_CANCELD;
      case TFMessages.Items[i].msg of
        TFM_PLAN_RENYUAN_PUBLISH,
        TFM_PLAN_RENYUAN_RECIEVE,
        TFM_PLAN_RENYUAN_UPDATE,
        TFM_PLAN_RENYUAN_DELETE,
        TFM_PLAN_RENYUAN_RMTRAINMAN,
        TFM_PLAN_RENYUAN_RMGROUP,
        TFM_PLAN_RENYUAN_WAITWORK,
        TFM_PLAN_SIGN_WAITWORK
        :
        begin
          GUIDS.Text := TFMessages.Items[i].StrField['GUIDS'];
          case TFMessages.Items[i].msg of
            TFM_PLAN_RENYUAN_PUBLISH: ePlanType := TWWPT_ASSIGN;
            TFM_PLAN_RENYUAN_UPDATE: ePlanType := TWWPT_ASSIGN;
            TFM_PLAN_TRAIN_CANCEL: ePlanType := TWWPT_ASSIGN;
            TFM_PLAN_RENYUAN_RECIEVE: ePlanType := TWWPT_ASSIGN;
            TFM_PLAN_RENYUAN_RMTRAINMAN: ePlanType := TWWPT_ASSIGN;
            TFM_PLAN_RENYUAN_RMGROUP: ePlanType := TWWPT_ASSIGN;
            TFM_PLAN_RENYUAN_WAITWORK: ePlanType := TWWPT_ASSIGN;
            TFM_PLAN_SIGN_WAITWORK : ePlanType := TWWPT_SIGN;
          end;
          for J := 0 to GUIDS.Count - 1 do
          begin
            planIDInfo:=TSyncPlanIDInfo.create;
            try
              planIDInfo.strPlanGUID:=GUIDS.Strings[j];
              planIDInfo.ePlanType :=ePlanType;
              m_WaitWorkMgr.SaveSYNCPlanGUID(planIDInfo);
              TFMessages.Items[i].nResult := TFMESSAGE_STATE_CANCELD;
            finally
              planIDInfo.Free;
            end;
          end;
        end;
        
      ELSE
        Continue;
      end;

    end;

  finally
    GUIDS.Free;
  end;
end;
function TFrmRoomSync.GetPlanType(eMsgID:Integer):TWaitWorkPlanType;
begin

end;

{
function TFrmRoomSync.SaveWaitWorkPlanID(strPlanGUID:string) :Boolean;
var
  plan:TWaitWorkPlan;
begin
  plan:= GetPlan(strPlanGUID);
  if not Assigned(plan) then Exit;

  result := m_WaitWorkMgr.AddPlan(plan,True);
end;
function TFrmRoomSync.DeleteWaitWorkPlan(strPlanGUID:string) :Boolean;
var
  plan:TWaitWorkPlan;
begin
  plan := m_WaitWorkMgr.planList.Find(strPlanGUID);
  if Assigned(plan) then
    m_WaitWorkMgr.DelPlan(plan);
end;

function TFrmRoomSync.DealWaitWorkPlan(strPlanGUID: string;nMsg:Integer):Boolean;
var
  values:TStringList;
  strResult:string;
begin
  result := False;
  if nMsg = TFM_PLAN_TRAIN_CANCEL then
  begin
    Result := DeleteWaitWorkPlan(strPlanGUID);
    Exit;
  end;
  result := SaveWaitWorkPlanID(strPlanGUID);


end;
    }
function TFrmRoomSync.StartUpdate:Boolean;
var
  webConfig:RWebConfig;
begin
  result := False;
  BtnStart.Enabled := False;
  BtnStop.Enabled := True;

  webConfig.strCID := GlobalDM.SiteInfo.strSiteGUID;
  webConfig.strURL := GlobalDM.GetWebUrl;
  webConfig.strHost := GlobalDM.GetWebApiHost();

  InitMsgComponent();

  InsertLogs('正在启动数据同步线程……');
  m_UPDateThread := TUPDateThread.Create(True);
  m_UPDateThread.SetDB(GlobalDM.LocalADOConnection);
  m_UPDateThread.SetWebConfig(webConfig);
  m_UPDateThread.SetPeriod(5);
  m_UPDateThread.OnLogEvent := InsertLogs;
  m_UPDateThread.Continue;

end;

procedure TFrmRoomSync.StopUpdate;
begin
  UnInitMsgComponent();
  InsertLogs('正在停止数据同步线程……');
  m_UPDateThread.Stop;
  m_UPDateThread.WaitFor;
  m_UPDateThread.OnLogEvent := nil;
  m_UPDateThread.Free;

end;

procedure TFrmRoomSync.UnInitMsgComponent;
begin
  if GlobalDM.bLeaveLine then
    Exit;
  GlobalDM.TFMessageCompnent.OnMessage := nil;
  GlobalDM.TFMessageCompnent.Close;
end;


end.
