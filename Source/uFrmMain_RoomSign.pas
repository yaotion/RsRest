unit uFrmMain_RoomSign;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzStatus, ExtCtrls, RzPanel, Menus, ComCtrls, StdCtrls,
  Buttons, PngSpeedButton,uGlobalDM,  ActnList,utfsystem,ufrmTextInput,uWaitWorkMgr,uDBLocalTrainman,
  RzTabs, PngCustomButton, pngimage,
  uTrainman,
  uSaftyEnum,
  uDBTrainman,
  uRoomSignConfig ,
  uFrmWaitWorkPlanMgr,
  uFrmRoomSync     ,
  uFrmWaitTimeTable,
  ufrmCallConfig,
  uFrmCallDevMgr,
  uFrmQueryWaitRecord,
  uRoomCallApp,
  uFrmCallPlan,
  uFrmWaitPlanLoadTimeSet,
  ufrmTrainmanPicFigEdit,
  uFrmBaseDataConfig,
  uFrmRoomInfo,
  uProgressCommFun,
  StrUtils, ImgList;

const
  MENU_ITEM_WIDTH  : integer = 240 ;    //菜单宽度
  MENU_ITEM_HEIGHT : integer = 40 ;     //菜单高度
const
  //候班记录/查岗登记/房间管理 /待乘管理/同步管理 /叫班计划
  PAGE_Wait_Record  = 0 ;
  PAGE_LEADER_INSPECT = 1 ;
  PAGE_ROOM_MANAGER = 2  ;
  PAGE_WAITWORK_PLAN = 3;
  PAGE_DATA_SYNC = 4;
  PAGE_CALL_PLAN = 5;

  WM_CHECK_TRAINNO = WM_USER + 999;//判断车次是否图钉候班车次
  WM_CREATE_WAITPLAN = WM_USER + 1000;   //创建候班计划
type
  TfrmMain_RoomSign = class(TForm)
    StatusBarBar1: TRzStatusBar;
    StatusPaneUpdate: TRzStatusPane;
    mm1: TMainMenu;
    mniN1: TMenuItem;
    mniN29: TMenuItem;
    mniN30: TMenuItem;
    mniExit: TMenuItem;
    mniSet: TMenuItem;
    mniN35: TMenuItem;
    mniN6: TMenuItem;
    mniN36: TMenuItem;
    rzpnl1: TRzPanel;
    timerCheckUpdate1: TTimer;
    tmrDBCheck: TTimer;
    actlst1: TActionList;
    actRoomManager: TAction;
    statusFinger: TRzGlyphStatus;
    actRoomSignIn: TAction;
    actRoomSignOut: TAction;
    statusDutyUser: TRzGlyphStatus;
    actInspectSentry: TAction;
    mniM1: TMenuItem;
    actModiyInTime: TAction;
    actModiyOutTime: TAction;
    actDelInRecord: TAction;
    actDelOutRecord: TAction;
    actDelInOutRecord: TAction;
    rzpnl4: TRzPanel;
    actSetLimitTime: TAction;
    img1: TImage;
    btnRefresh: TPngCustomButton;
    btnRoomManager: TPngCustomButton;
    btnJiaoBanLuYinQuery: TPngCustomButton;
    actImportSignInfo: TAction;
    PageCtrlMain: TRzPageControl;
    tsWaitRecord: TRzTabSheet;
    tsLeaderInspect: TRzTabSheet;
    tsRoomManager: TRzTabSheet;
    N7: TMenuItem;
    mniTrainmanManager: TMenuItem;
    actImportTrainmanInfo: TAction;
    actExportSignInfo: TAction;
    N9: TMenuItem;
    tsWaitWorkPlan: TRzTabSheet;
    btnPlanMgr: TPngCustomButton;
    tsSYNC: TRzTabSheet;
    tmrUpdateUser: TTimer;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    tsCallPlan: TRzTabSheet;
    btnCallNofity: TPngCustomButton;
    N1: TMenuItem;
    N2: TMenuItem;
    N4: TMenuItem;
    pnlCallWork: TRzPanel;
    lbl1: TLabel;
    lbl2: TLabel;
    edtTrainNo: TEdit;
    lbl7: TLabel;
    edtWaitTime: TEdit;
    lbl3: TLabel;
    edtCallTime: TEdit;
    lbl4: TLabel;
    edtRoomNum: TEdit;
    lbl5: TLabel;
    edtFirstCallTime: TEdit;
    lbl6: TLabel;
    edtRecallTime: TEdit;
    lbl8: TLabel;
    lbl9: TLabel;
    lbl10: TLabel;
    lbl11: TLabel;
    edt1: TEdit;
    edt2: TEdit;
    edt3: TEdit;
    edt4: TEdit;
    lbl12: TLabel;
    mmo1: TMemo;
    btn1: TButton;
    P1: TMenuItem;
    tmrDelVoiceRecord: TTimer;
    ImageList1: TImageList;
    statusPanelDBState: TRzGlyphStatus;
    tsRecordTel: TRzTabSheet;
    N5: TMenuItem;
    mniTelRecordQuery: TMenuItem;
    StatusPaneTelRecord: TRzGlyphStatus;
    N3: TMenuItem;
    N6: TMenuItem;
    N8: TMenuItem;
    tsReverseCall: TRzTabSheet;
    RzClockStatus1: TRzClockStatus;
    N10: TMenuItem;
    N11: TMenuItem;
    procedure mniN29Click(Sender: TObject);
    procedure mniExitClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure timerCheckUpdate1Timer(Sender: TObject);
    procedure tmrDBCheckTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnRoomManagerClick(Sender: TObject);
    procedure statusFingerDblClick(Sender: TObject);
    procedure btnSystemConfigClick(Sender: TObject);
    procedure mniN35Click(Sender: TObject);
    procedure btnJiaoBanLuYinQueryClick(Sender: TObject);
    procedure btnCheckRegisterClick(Sender: TObject);
    procedure mniTrainmanManagerClick(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure btnPlanMgrClick(Sender: TObject);
    procedure btnSyncClick(Sender: TObject);
    procedure tmrUpdateUserTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure N12Click(Sender: TObject);
    procedure btnWaitRecordClick(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure btnCallNofityClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure tmrDelVoiceRecordTimer(Sender: TObject);
    procedure mniN36Click(Sender: TObject);
    procedure mniTelRecordQueryClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
  private
    //配置管理
    //人员管理
    m_dbTrainman:TRsDBLocalTrainman ;
    //前一个调用的事件  ,指纹仪事件
    m_OldFingerTouch : TNotifyEvent;
    {候班管理}
    m_waitWorkMgr :TWaitWorkMgr;
    {人员特征码}
    strLocalFingerLibGUID:string;
    //叫班管理
    m_RoomCallApp:TRoomCallApp;
    //叫班计划窗体
    m_FrmCallPlan: TFrmCallPlan;
  private
    { Private declarations }
    procedure DrawMenu();
    //创建子窗体(入寓/离寓，查岗登记，房间管理 这三个界面直接嵌入到主界面)
    procedure CreateSubForms();
    //销毁子窗体
    procedure DestroySubForms();
    //刷新 房间管理
    procedure RefreshRoomManager();
    //刷新查岗登记
    procedure RefreshLeaderInspect();
    {功能:刷新待乘计划}
    procedure RefreshWaitWorkPlan();
    {功能:刷新叫班计划}
    procedure ReFreshWaitCallPlan();
    {功能:数据同步}
    procedure RefreshDataSync();

    procedure WMCOPYDATA(var AMsg: TWmCopyData); message WM_COPYDATA;

    procedure TelRecordEvent(strText: string);
  private
    //按下指纹仪
    procedure OnFingerTouching(Sender: TObject);
    //读取指纹状态
    procedure ReadFingerprintState;
    //数据库已连接
    procedure DBConnected(Sender : TObject);
    //数据库已断开
    procedure DBDisconnected(Sender : TObject);
  public
    procedure InitData();
  public
    { Public declarations }
    class procedure EnterRoomSign();
    class procedure LeaveRoomSign();
  end;

var
  frmMain_RoomSign: TfrmMain_RoomSign;

implementation

{$R *.dfm}

uses
  uFrmLogin,uCallRoomFunIF, uFrmMunualMonitor,
  uFrmQueryCallRecord,
  uFrmRoomMgr,ufrmQuestionBox,
  ufrmAccessReadFingerprintTemplates,
  uFrmLeaderInspect,
  ufrmConfig,
  DateUtils,
  uFrmTrainmanManage,
  uFrmProgressEx,
  uFrmRoomSignSysConfig,ufrmSelectTrainman,
  uFrmAbout,ufrmRecordTel,uFrmTelCallQuery,
  uFrmServerRoomManager,uFrmReverseCallManager,uDrawMenu;



procedure TfrmMain_RoomSign.btnCallNofityClick(Sender: TObject);
begin
  ReFreshWaitCallPlan();
end;

procedure TfrmMain_RoomSign.btnCheckRegisterClick(Sender: TObject);
begin
  RefreshLeaderInspect;
end;


procedure TfrmMain_RoomSign.btnExitClick(Sender: TObject);
begin
  Close;
end;



procedure TfrmMain_RoomSign.btnJiaoBanLuYinQueryClick(Sender: TObject);
var
  strNumber: string;
begin
  TFrmQueryCallRecord.ShowCallRecordFrm(nil);  
end;

procedure TfrmMain_RoomSign.btnPlanMgrClick(Sender: TObject);
begin
  RefreshWaitWorkPlan();
end;

procedure TfrmMain_RoomSign.btnRefreshClick(Sender: TObject);
begin
  case PageCtrlMain.ActivePageIndex of
  PAGE_ROOM_MANAGER :
    begin
      FrmRoomMgr.RefreshData;
    end;
  PAGE_LEADER_INSPECT :
    begin
      FrmLeaderInspect.RefreshData;
    end;
  PAGE_WAITWORK_PLAN:
    begin
      FrmWaitWorkPlanMgr.RefreshData;
    end;
  PAGE_DATA_SYNC:
    begin
      FrmRoomSync.Show;  
    end;
  PAGE_CALL_PLAN:
    begin
      m_FrmCallPlan.ReFreshData;
    end
  else
    ;
  end;
end;

procedure TfrmMain_RoomSign.btnRoomManagerClick(Sender: TObject);
begin
  RefreshRoomManager;
end;


procedure TfrmMain_RoomSign.btnSyncClick(Sender: TObject);
begin
  RefreshDataSync();
end;

procedure TfrmMain_RoomSign.btnSystemConfigClick(Sender: TObject);
begin
  TfrmConfig.EditConfig;
end;

procedure TfrmMain_RoomSign.btnWaitRecordClick(Sender: TObject);
begin
  PageCtrlMain.ActivePageIndex := 0;
end;



procedure TfrmMain_RoomSign.CreateSubForms;
begin
  //待乘计划
  FrmWaitWorkPlanMgr := TFrmWaitWorkPlanMgr.Create(nil);
  FrmWaitWorkPlanMgr.Parent := tsWaitWorkPlan;
  FrmWaitWorkPlanMgr.show;
  //查岗登记
//  FrmLeaderInspect := TFrmLeaderInspect.Create(nil);
//  FrmLeaderInspect.Parent := tsLeaderInspect ;
//  FrmLeaderInspect.Show ;
  //房间管理
  FrmRoomMgr := TFrmRoomMgr.Create(nil);
  FrmRoomMgr.Parent := tsRoomManager ;
  FrmRoomMgr.Show;
  //候班记录
//  FrmQueryWaitRecord := TFrmQueryWaitRecord.Create(nil);
//  FrmQueryWaitRecord.Parent := tsWaitRecord;
//  FrmQueryWaitRecord.Show();

//  if GlobalDM.bLeaveLine = False then
//  begin
//    {同步管理}
//    FrmRoomSync := TFrmRoomSync.create(nil);
//    FrmRoomSync.Parent := tsSYNC;
//    FrmRoomSync.Show;
//    FrmRoomSync.btnStartClick(nil);
//
//  end
//  else
//  begin
//    btnSync.Visible := False;
//  end;
  {叫班管理}

  {是否启用电话录音}
  if GlobalDM.bRecorcdTel then
  begin
    FrmRecordTel := TFrmRecordTel.Create(nil);
    FrmRecordTel.Parent := tsRecordTel;
    FrmRecordTel.LogEvent := TelRecordEvent ;
    FrmRecordTel.Hide;
    StatusPaneTelRecord.Caption := '电话录音:启用';
  end
  else
    StatusPaneTelRecord.Caption := '电话录音:禁用';
  // 交班计划
  m_FrmCallPlan:= TFrmCallPlan.Create(nil);
  m_FrmCallPlan.Parent := tsCallPlan;
  m_FrmCallPlan.Show;

  //反呼检测
  if GlobalDM.bEnableReverseCall then
  begin
    FrmReverseCallManager:= TFrmReverseCallManager.Create(nil);
    FrmReverseCallManager.Parent := tsReverseCall ;
    FrmReverseCallManager.Hide ;
  end;
end;

procedure TfrmMain_RoomSign.DBConnected(Sender: TObject);
begin
  try
    GlobalDM.LocalADOConnection.Connected := true;

    statusPanelDBState.ImageIndex := 0;
    statusPanelDBState.Caption := '数据库已连接!';
    statusPanelDBState.ShowHint := False ;
    statusPanelDBState.Font.Color := clBlack;

  except on e : exception do
    
  end;

end;

procedure TfrmMain_RoomSign.DBDisconnected(Sender: TObject);
begin
  try
    GlobalDM.LocalADOConnection.Connected := false;

    statusPanelDBState.ImageIndex := 1;
    statusPanelDBState.Caption := '数据库已断开';
    statusPanelDBState.Font.Color := clRed;
    statusPanelDBState.ShowHint := True ;

  except on e : exception do
  end;
end;


procedure TfrmMain_RoomSign.DestroySubForms;
begin
  //FreeAndNil(FrmRoomSign);


  //FreeAndNil(FrmLeaderInspect);
  FreeAndNil(FrmRoomMgr);
  FreeAndNil(FrmWaitWorkPlanMgr);
  //FreeAndNil(FrmQueryWaitRecord);
  //FreeAndNil(FrmRoomSync);
  FreeAndNil(m_FrmCallPlan);
  FreeAndNil(FrmRecordTel);
  FreeAndNil(FrmReverseCallManager);
end;


procedure TfrmMain_RoomSign.DrawMenu;
var
  drawMenu : TDrawMenu ;
begin

  drawMenu := TDrawMenu.Create ;
  try
    drawMenu.DrawMenus(mm1);
  finally
    drawMenu.free
  end;
end;

class procedure TfrmMain_RoomSign.EnterRoomSign();
begin
  if frmMain_RoomSign = nil then
  begin
    Application.CreateForm(TfrmMain_RoomSign,frmMain_RoomSign);
    frmMain_RoomSign.InitData;
  end;
  frmMain_RoomSign.Show;
end;


procedure TfrmMain_RoomSign.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin

  CanClose := tfMessageBox('您确定要退出吗?')  ;
  Exit;

  CanClose := MessageBox(Handle,'您确定要退出吗?','请问',
    MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = mrYes
end;

procedure TfrmMain_RoomSign.FormCreate(Sender: TObject);
var
  strTitle : string ;
begin

  strTitle := ReadIniFile(ExtractFilePath(ParamStr(0))+'Config.ini', 'sysConfig', 'AppTitle');
  if Trim(strTitle)  <> '' then
  begin
    self.Caption := strTitle ;
  end;
  
  //连接本地数据库
  GlobalDM.ConnectLocal_SQLDB();
  GlobalDM.m_bIsAccessMode := True ;
  m_DBTrainman := TRsDBLocalTrainman.Create(GlobalDM.LocalADOConnection);

    //当前登录用户
  statusDutyUser.Caption := '值班员: ' + GlobalDM.DutyUser.strDutyName;
  //GlobalDM.LogManage.InsertLog('查看指纹仪状态');

  GlobalDM.OnDBConnected := DBConnected;
  GlobalDM.OnDBDisconnected := DBDisconnected;


  m_RoomCallApp:=TRoomCallApp.GetInstance();
  m_RoomCallApp.InitInstance(GlobalDM.LocalADOConnection);

  tmrDelVoiceRecord.Interval := 1000 * 60 * 60 * 8;
    //打开端口
  try
    if m_RoomCallApp.CallDevOp.OpenPort= False then
      tfMessageBox('端口打开失败!',MB_ICONERROR);
  except
    on e:Exception do
    begin
      tfMessageBox(e.Message,MB_ICONERROR);
    end;
  end;


  m_waitWorkMgr := TWaitWorkMgr.GetInstance(GlobalDM.LocalADOConnection) ;

  if GlobalDM.bUseFinger then
  begin
    GlobalDM.LogManage.InsertLog('初始化指纹仪');
    //初始化指纹仪
    GlobalDM.InitFingerPrintting;
    //查看指纹仪状态
    ReadFingerprintState();
    GlobalDM.LogManage.InsertLog('读取指纹库内容');
    //读取指纹库内容
    if GlobalDM.FingerprintInitSuccess then
    begin
      GlobalDM.LogManage.InsertLog('初始化指纹仪成功!');
      ReadFingerprintTemplatesAccess(True);
      strLocalFingerLibGUID := m_DBTrainman.GetFingerSignature();
    end;
    GlobalDM.LogManage.InsertLog('读取指纹模板');

    //挂接指纹仪点击事件
    m_OldFingerTouch := GlobalDM.OnFingerTouching;
    GlobalDM.OnFingerTouching := OnFingerTouching;
  end;

  mniTelRecordQuery.Visible := GlobalDM.bRecorcdTel ;


  DrawMenu ;
end;

procedure TfrmMain_RoomSign.FormDestroy(Sender: TObject);
begin
  //obUpload.Free ;
  m_dbTrainman.Free ;


  DestroySubForms ;
  TWaitWorkMgr.FreeInstance() ;
  TRoomCallApp.FreeInstance();
end;

procedure TfrmMain_RoomSign.InitData;
var
  i : Integer ;
begin
  for I := 0 to PageCtrlMain.PageCount - 1 do
    PageCtrlMain.Pages[i].TabVisible := False;
  CreateSubForms ;
end;



class procedure TfrmMain_RoomSign.LeaveRoomSign;
begin

  if frmMain_RoomSign <> nil then
    FreeAndNil(frmMain_RoomSign);
end;

procedure TfrmMain_RoomSign.mniExitClick(Sender: TObject);
begin
  Close();
end;



procedure TfrmMain_RoomSign.mniN29Click(Sender: TObject);
begin
  frmLogin := TfrmLogin.Create(nil);
  try
    frmLogin.ShowModal;
  finally
    frmLogin.Free;
  end;
end;


procedure TfrmMain_RoomSign.mniN35Click(Sender: TObject);
begin
  //TfrmConfig.EditConfig;
  TFrmRoomSignsSysConfig.ShowConfig;
end;




procedure TfrmMain_RoomSign.mniN36Click(Sender: TObject);
begin
  frmAbout := TfrmAbout.Create(nil);
  try
    frmAbout.ShowModal;
  finally
    frmAbout.Free;
  end;
end;

procedure TfrmMain_RoomSign.mniTrainmanManagerClick(Sender: TObject);
var
  bOnlyQuery:Boolean;
begin
  bOnlyQuery := not GlobalDM.bLeaveLine;
  TfrmTrainmanManage.OpenTrainmanQuery(bOnlyQuery);
end;

procedure TfrmMain_RoomSign.N11Click(Sender: TObject);
var
  strCheCi,strRoomNum:string;
begin
  if TCallRoomFunIF.GetInstance.bCallling(false) then
  begin
    tfMessageBox('正在叫班!',MB_ICONERROR);
    Exit;
  end;

  strCheCi := '' ;
  strRoomNum := '' ;
  TCallRoomFunIF.GetInstance.MunualMonitor(nil,strCheCi,strRoomNum);
end;

procedure TfrmMain_RoomSign.N12Click(Sender: TObject);
begin
    ShowCallConfig();
end;


procedure TfrmMain_RoomSign.N14Click(Sender: TObject);
var
  frm:TFrmCallDevMgr;
begin
  frm := TFrmCallDevMgr.Create(nil);
  try
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

procedure TfrmMain_RoomSign.N1Click(Sender: TObject);
begin
  TFrmWaitWorkPlanLoadTimeSet.ShowConfig;
end;

procedure TfrmMain_RoomSign.N2Click(Sender: TObject);
begin
  TFrmBaseDataConfig.show;
end;

procedure TfrmMain_RoomSign.N3Click(Sender: TObject);
begin
  TFrmQueryCallRecord.ShowCallRecordFrm(nil);
end;

procedure TfrmMain_RoomSign.N4Click(Sender: TObject);
begin
  TFrmRoomInfo.Manager;
end;

procedure TfrmMain_RoomSign.N8Click(Sender: TObject);
begin
    TFrmServerRoomManager.Manager;
end;

procedure TfrmMain_RoomSign.mniTelRecordQueryClick(Sender: TObject);
begin
    TFrmTelCallQuery.ShowCallRecordFrm(nil);
end;

procedure TfrmMain_RoomSign.N9Click(Sender: TObject);
begin
  TFrmWaitTimeTable.ManageWaitRoomTable();
end;

//下载公寓相关信息
procedure TfrmMain_RoomSign.OnFingerTouching(Sender: TObject);
begin
  case PageCtrlMain.ActivePageIndex of
  PAGE_LEADER_INSPECT :
    begin
      FrmLeaderInspect.OnFingerTouching(Sender);
    end;
  PAGE_WAITWORK_PLAN :
    begin
      FrmWaitWorkPlanMgr.OnFingerTouching(Sender);
    end
  else
    ;
  end;
end;




procedure TfrmMain_RoomSign.ReadFingerprintState;
begin
  if GlobalDM.FingerprintInitSuccess then
  begin
    statusFinger.Font.Color := clBlack;
    statusFinger.Caption := '指纹仪连接正常';
  end
  else
  begin
    statusFinger.Font.Color := clRed;
    statusFinger.Caption := '指纹仪连接失败;双击重新连接！';
  end;
end;

procedure TfrmMain_RoomSign.RefreshDataSync;
begin
  PageCtrlMain.ActivePageIndex := PAGE_DATA_SYNC;
end;

procedure TfrmMain_RoomSign.RefreshLeaderInspect;
begin
  PageCtrlMain.ActivePageIndex := PAGE_LEADER_INSPECT ;
  FrmLeaderInspect.RefreshData;
end;

procedure TfrmMain_RoomSign.RefreshRoomManager;
begin
  PageCtrlMain.ActivePageIndex := PAGE_ROOM_MANAGER ;
  FrmRoomMgr.RefreshData;
end;


procedure TfrmMain_RoomSign.ReFreshWaitCallPlan;
begin
  PageCtrlMain.ActivePageIndex := 5;
  m_FrmCallPlan.ReFreshData;
end;

procedure TfrmMain_RoomSign.RefreshWaitWorkPlan;
begin
  PageCtrlMain.ActivePageIndex := PAGE_WAITWORK_PLAN ;
  FrmWaitWorkPlanMgr.RefreshData();
  FrmWaitWorkPlanMgr.SetOnFingerTouch;
end;


procedure TfrmMain_RoomSign.statusFingerDblClick(Sender: TObject);
begin
  try
    if not tfMessageBox('您确定要更新指纹信息吗?') then exit;
    //出勤端需要初始化指纹仪
    GlobalDM.InitFingerPrintting;
    //查看指纹仪状态
    ReadFingerprintState();
     //读取指纹库内容
    if GlobalDM.FingerprintInitSuccess then
    begin
      ReadFingerprintTemplatesAccess(true);
      strLocalFingerLibGUID  := m_DBTrainman.GetFingerSignature();
      statusFinger.Caption := '指纹仪:正常';
    end;
  finally
    tmrUpdateUser.Enabled := True;
  end;
end;



procedure TfrmMain_RoomSign.TelRecordEvent(strText: string);
begin
  StatusPaneTelRecord.Caption := '电话录音:' + strText ;
end;

procedure TfrmMain_RoomSign.timerCheckUpdate1Timer(Sender: TObject);
begin
  if GlobalDM.GetUpdateInfo then
  begin
    StatusPaneUpdate.Caption := '客户端需要更新，请重启系统';
    StatusPaneUpdate.Font.Color := clRed;
  end
  else
  begin
    StatusPaneUpdate.Caption := '客户端已是最新版本';
    StatusPaneUpdate.Font.Color := clBlack;
  end;
end;

procedure TfrmMain_RoomSign.tmrDBCheckTimer(Sender: TObject);
begin
  TTimer(Sender).Enabled := false;
  try
    if GlobalDM.LocalADOConnection.Connected then
    begin
      statusPanelDBState.ImageIndex := 0;
      statusPanelDBState.Caption := '数据库已连接!';
      statusPanelDBState.ShowHint := False;
      statusPanelDBState.Font.Color := clBlack;

    end
    else
    begin

      statusPanelDBState.ImageIndex := 1;
      statusPanelDBState.Caption := '数据库已断开';
      statusPanelDBState.Font.Color := clRed;
      statusPanelDBState.ShowHint := True;

    end;
    //statusSysTime.Caption := formatDateTime('yyyy-mm-dd hh:nn:ss', GlobalDM.GetNow);
  finally
    TTimer(Sender).Enabled := true;
  end;
end;

procedure TfrmMain_RoomSign.tmrDelVoiceRecordTimer(Sender: TObject);
var
  sch:TSearchrec;
  sDt:TDateTime;
  Path:string;
begin
  path :=  GlobalDM.AppPath + 'CallVoice\' ; ;
  if rightStr(trim(Path), 1) <> '\' then
      Path := trim(Path) + '\'
  else
      Path := trim(Path);
  if not DirectoryExists(Path) then
  begin
    exit;
  end;
  if FindFirst(Path + '*', faDirectory, sch) = 0 then
  begin
  repeat
    if ((sch.Name = '.') or (sch.Name = '..')) then Continue;
    if DirectoryExists(Path+sch.Name) then   // 这个地方加上一个判断，可以区别子文件夹河当前文件夹的操作
    begin
      //Result.Add(Path+sch.Name);
      if TryStrToDate(sch.Name,sDt) then
      begin

        if sDt < (Date - m_RoomCallApp.CallConfig.nVoiceStoreDays) then
        begin
          uTFSystem.ClearDirFile(Path+sch.Name);
          RemoveDirectory(PAnsiChar(AnsiString(Path+sch.Name)));
        end;
      end;
    end
  until FindNext(sch) <> 0;
  SysUtils.FindClose(sch);
  end;
end;

procedure TfrmMain_RoomSign.tmrUpdateUserTimer(Sender: TObject);
begin
  if GlobalDM.FingerprintInitSuccess then
  begin
    if strLocalFingerLibGUID  <> m_DBTrainman.GetFingerSignature() then
    begin
      statusFinger.Caption := '指纹仪:有指纹需更新'
    end;
  end;
end;

procedure TfrmMain_RoomSign.WMCOPYDATA(var AMsg: TWmCopyData);
var
  nMsgID:Integer;
  nData:Integer;
  strData:String;
begin
  TProgressCommFun.RecvMsg(AMsg,nMsgID,nData,strData);
  case nMsgID of
    WM_CREATE_WAITPLAN :
    begin
      utfsystem.ForceForegroundWindow(self.Handle);
      RefreshWaitWorkPlan;
      AMsg.Result := FrmWaitWorkPlanMgr.Msg_CreateWaitPlan(strData);
    end;
    WM_CHECK_TRAINNO :
    begin
      utfsystem.ForceForegroundWindow(self.Handle);
      RefreshWaitWorkPlan;
      AMsg.Result := FrmWaitWorkPlanMgr.Msg_CheckTrainNo(strData);
    end;
  end;

end;

end.
