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
  MENU_ITEM_WIDTH  : integer = 240 ;    //�˵����
  MENU_ITEM_HEIGHT : integer = 40 ;     //�˵��߶�
const
  //����¼/��ڵǼ�/������� /���˹���/ͬ������ /�а�ƻ�
  PAGE_Wait_Record  = 0 ;
  PAGE_LEADER_INSPECT = 1 ;
  PAGE_ROOM_MANAGER = 2  ;
  PAGE_WAITWORK_PLAN = 3;
  PAGE_DATA_SYNC = 4;
  PAGE_CALL_PLAN = 5;

  WM_CHECK_TRAINNO = WM_USER + 999;//�жϳ����Ƿ�ͼ����೵��
  WM_CREATE_WAITPLAN = WM_USER + 1000;   //�������ƻ�
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
    //���ù���
    //��Ա����
    m_dbTrainman:TRsDBLocalTrainman ;
    //ǰһ�����õ��¼�  ,ָ�����¼�
    m_OldFingerTouch : TNotifyEvent;
    {������}
    m_waitWorkMgr :TWaitWorkMgr;
    {��Ա������}
    strLocalFingerLibGUID:string;
    //�а����
    m_RoomCallApp:TRoomCallApp;
    //�а�ƻ�����
    m_FrmCallPlan: TFrmCallPlan;
  private
    { Private declarations }
    procedure DrawMenu();
    //�����Ӵ���(��Ԣ/��Ԣ����ڵǼǣ�������� ����������ֱ��Ƕ�뵽������)
    procedure CreateSubForms();
    //�����Ӵ���
    procedure DestroySubForms();
    //ˢ�� �������
    procedure RefreshRoomManager();
    //ˢ�²�ڵǼ�
    procedure RefreshLeaderInspect();
    {����:ˢ�´��˼ƻ�}
    procedure RefreshWaitWorkPlan();
    {����:ˢ�½а�ƻ�}
    procedure ReFreshWaitCallPlan();
    {����:����ͬ��}
    procedure RefreshDataSync();

    procedure WMCOPYDATA(var AMsg: TWmCopyData); message WM_COPYDATA;

    procedure TelRecordEvent(strText: string);
  private
    //����ָ����
    procedure OnFingerTouching(Sender: TObject);
    //��ȡָ��״̬
    procedure ReadFingerprintState;
    //���ݿ�������
    procedure DBConnected(Sender : TObject);
    //���ݿ��ѶϿ�
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
  //���˼ƻ�
  FrmWaitWorkPlanMgr := TFrmWaitWorkPlanMgr.Create(nil);
  FrmWaitWorkPlanMgr.Parent := tsWaitWorkPlan;
  FrmWaitWorkPlanMgr.show;
  //��ڵǼ�
//  FrmLeaderInspect := TFrmLeaderInspect.Create(nil);
//  FrmLeaderInspect.Parent := tsLeaderInspect ;
//  FrmLeaderInspect.Show ;
  //�������
  FrmRoomMgr := TFrmRoomMgr.Create(nil);
  FrmRoomMgr.Parent := tsRoomManager ;
  FrmRoomMgr.Show;
  //����¼
//  FrmQueryWaitRecord := TFrmQueryWaitRecord.Create(nil);
//  FrmQueryWaitRecord.Parent := tsWaitRecord;
//  FrmQueryWaitRecord.Show();

//  if GlobalDM.bLeaveLine = False then
//  begin
//    {ͬ������}
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
  {�а����}

  {�Ƿ����õ绰¼��}
  if GlobalDM.bRecorcdTel then
  begin
    FrmRecordTel := TFrmRecordTel.Create(nil);
    FrmRecordTel.Parent := tsRecordTel;
    FrmRecordTel.LogEvent := TelRecordEvent ;
    FrmRecordTel.Hide;
    StatusPaneTelRecord.Caption := '�绰¼��:����';
  end
  else
    StatusPaneTelRecord.Caption := '�绰¼��:����';
  // ����ƻ�
  m_FrmCallPlan:= TFrmCallPlan.Create(nil);
  m_FrmCallPlan.Parent := tsCallPlan;
  m_FrmCallPlan.Show;

  //�������
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
    statusPanelDBState.Caption := '���ݿ�������!';
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
    statusPanelDBState.Caption := '���ݿ��ѶϿ�';
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

  CanClose := tfMessageBox('��ȷ��Ҫ�˳���?')  ;
  Exit;

  CanClose := MessageBox(Handle,'��ȷ��Ҫ�˳���?','����',
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
  
  //���ӱ������ݿ�
  GlobalDM.ConnectLocal_SQLDB();
  GlobalDM.m_bIsAccessMode := True ;
  m_DBTrainman := TRsDBLocalTrainman.Create(GlobalDM.LocalADOConnection);

    //��ǰ��¼�û�
  statusDutyUser.Caption := 'ֵ��Ա: ' + GlobalDM.DutyUser.strDutyName;
  //GlobalDM.LogManage.InsertLog('�鿴ָ����״̬');

  GlobalDM.OnDBConnected := DBConnected;
  GlobalDM.OnDBDisconnected := DBDisconnected;


  m_RoomCallApp:=TRoomCallApp.GetInstance();
  m_RoomCallApp.InitInstance(GlobalDM.LocalADOConnection);

  tmrDelVoiceRecord.Interval := 1000 * 60 * 60 * 8;
    //�򿪶˿�
  try
    if m_RoomCallApp.CallDevOp.OpenPort= False then
      tfMessageBox('�˿ڴ�ʧ��!',MB_ICONERROR);
  except
    on e:Exception do
    begin
      tfMessageBox(e.Message,MB_ICONERROR);
    end;
  end;


  m_waitWorkMgr := TWaitWorkMgr.GetInstance(GlobalDM.LocalADOConnection) ;

  if GlobalDM.bUseFinger then
  begin
    GlobalDM.LogManage.InsertLog('��ʼ��ָ����');
    //��ʼ��ָ����
    GlobalDM.InitFingerPrintting;
    //�鿴ָ����״̬
    ReadFingerprintState();
    GlobalDM.LogManage.InsertLog('��ȡָ�ƿ�����');
    //��ȡָ�ƿ�����
    if GlobalDM.FingerprintInitSuccess then
    begin
      GlobalDM.LogManage.InsertLog('��ʼ��ָ���ǳɹ�!');
      ReadFingerprintTemplatesAccess(True);
      strLocalFingerLibGUID := m_DBTrainman.GetFingerSignature();
    end;
    GlobalDM.LogManage.InsertLog('��ȡָ��ģ��');

    //�ҽ�ָ���ǵ���¼�
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
    tfMessageBox('���ڽа�!',MB_ICONERROR);
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

//���ع�Ԣ�����Ϣ
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
    statusFinger.Caption := 'ָ������������';
  end
  else
  begin
    statusFinger.Font.Color := clRed;
    statusFinger.Caption := 'ָ��������ʧ��;˫���������ӣ�';
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
    if not tfMessageBox('��ȷ��Ҫ����ָ����Ϣ��?') then exit;
    //���ڶ���Ҫ��ʼ��ָ����
    GlobalDM.InitFingerPrintting;
    //�鿴ָ����״̬
    ReadFingerprintState();
     //��ȡָ�ƿ�����
    if GlobalDM.FingerprintInitSuccess then
    begin
      ReadFingerprintTemplatesAccess(true);
      strLocalFingerLibGUID  := m_DBTrainman.GetFingerSignature();
      statusFinger.Caption := 'ָ����:����';
    end;
  finally
    tmrUpdateUser.Enabled := True;
  end;
end;



procedure TfrmMain_RoomSign.TelRecordEvent(strText: string);
begin
  StatusPaneTelRecord.Caption := '�绰¼��:' + strText ;
end;

procedure TfrmMain_RoomSign.timerCheckUpdate1Timer(Sender: TObject);
begin
  if GlobalDM.GetUpdateInfo then
  begin
    StatusPaneUpdate.Caption := '�ͻ�����Ҫ���£�������ϵͳ';
    StatusPaneUpdate.Font.Color := clRed;
  end
  else
  begin
    StatusPaneUpdate.Caption := '�ͻ����������°汾';
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
      statusPanelDBState.Caption := '���ݿ�������!';
      statusPanelDBState.ShowHint := False;
      statusPanelDBState.Font.Color := clBlack;

    end
    else
    begin

      statusPanelDBState.ImageIndex := 1;
      statusPanelDBState.Caption := '���ݿ��ѶϿ�';
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
    if DirectoryExists(Path+sch.Name) then   // ����ط�����һ���жϣ������������ļ��кӵ�ǰ�ļ��еĲ���
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
      statusFinger.Caption := 'ָ����:��ָ�������'
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
