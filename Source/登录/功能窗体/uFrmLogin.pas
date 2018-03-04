unit uFrmLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ActnList,uDutyUser, RzPanel, jpeg, pngimage,
  Buttons, PngSpeedButton, Mask, RzEdit, RzStatus,uTFSystem,uDBDutyUser,uDBSite,
  PngCustomButton,uGlobalDM, Menus, RzButton, uDBTrainman, uTrainman,
   uApparatusCommon, RzCommon, RzPrgres, uDBCLientApp,
  uClientAppInfo;

type
  TfrmLogin = class(TForm)
    RzPanel1: TRzPanel;
    actLstLogin: TActionList;
    actCancel: TAction;
    actEnter: TAction;
    RzVersionInfo1: TRzVersionInfo;
    RzPanel3: TRzPanel;
    Label2: TLabel;
    lblDutyNumber: TLabel;
    edtDutyNumber: TRzEdit;
    edtDutyPWD: TRzEdit;
    LblBrief: TLabel;
    lblVersion: TLabel;
    ProgressBar: TRzProgressBar;
    img1: TImage;
    img2: TImage;
    img3: TImage;
    img4: TImage;
    lbl1: TLabel;
    lbl2: TLabel;
    btnRoomSign: TPngSpeedButton;
    btnDBConfig: TPngSpeedButton;
    btnLogin: TPngCustomButton;
    btnCancel: TPngCustomButton;
    Timer1: TTimer;
    procedure btnLoginClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure actEnterExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnDBConfigClick(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
    procedure Image3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnRoomSignClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);

  private
    { Private declarations }
    //登录用户信息操作类
    m_DBDutyUser : TRsDBDutyUser;
    //客户端信息操作类
    m_DBSite : TRsDBSite;
    //拖动点
    m_ptDragStart : TPoint;
  private
    procedure InitData;
    //初始化窗体显示
    procedure InitUI;
    //禁用窗体控件
    procedure DisableForm;
    //启用窗体控件
    procedure EnableForm;
    //检测输入合法性
    function CheckInput : boolean;
    //上传客户端信息
    function  UpLoadClientAppInfo():Boolean;

  public
    { Public declarations }

  end;

var
  frmLogin: TfrmLogin;

implementation
uses
  uSite,uFrmConfig,ufrmQuestionBox,
  uFrmMain_RoomSign;
{$R *.dfm}


procedure TfrmLogin.btnLoginClick(Sender: TObject);
var
  errorMsg : string;
  localIP : string;
begin
  if Trim(edtDutyNumber.Text) = '' then
  begin
    tfMessageBox('请输入值班员工号',MB_ICONERROR);
    edtDutyNumber.SetFocus;
    exit;
  end;
  DisableForm;
  try
    LblBrief.Visible := true;

    {$region '加载本地配置文件'}
    LblBrief.Caption := '正在加载本地配置文件...';
    GlobalDM.LoadConfig;
    {$endregion '加载本地配置文件'}

    {$region '连接数据库'}
    LblBrief.Caption := '正在连接数据库...';
    try
      if GlobalDM.bLeaveLine = False then
        GlobalDM.ConnecDB;
      GlobalDM.ConnectLocal_SQLDB;
    except on e : exception do
      begin
        tfMessageBox(Format('连接数据库失败:%s...',[e.Message]),MB_ICONERROR);
        {//切换模式
        if MessageBox(Handle,'连接服务器失败，是否切换到断网测酒模式？','请问', MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = mrYes then
        begin
          btnRoomSign.Click;
        end; }
        exit;
      end;
    end;
    LblBrief.Caption := '连接数据库成功...';
    {$endregion '连接数据库'}

    {$region '验证值班员账户'}
    errorMsg := '';
    LblBrief.Caption := '正在验证值班员账户信息...';
    if GlobalDM.DutyUser <> nil then
      FreeAndNil(GlobalDM.DutyUser);    
    GlobalDM.DutyUser := TRsDutyUser.Create;
    if not m_DBDutyUser.GetDutyUserByNumber(Trim(edtDutyNumber.Text),GlobalDM.DutyUser) then
    begin
      tfMessageBox(Format('验证错误，错误信息：%s',['不存在此值班员工号']),MB_ICONERROR);
      exit;
    end;
    if GlobalDM.DutyUser.strPassword <> Trim(edtDutyPWD.Text) then
    begin
      tfMessageBox(Format('验证错误，错误信息：%s',['密码错误']),MB_ICONERROR);
      exit;
    end;
    
    LblBrief.Caption := '验证值班员账户信息成功...';
    {$endregion '验证值班员账户'}

    localIP := GlobalDM.SiteNumber;
    //if not GetLocalIP(localIP) then exit;

    {$region '获取客户端岗位信息'}
    LblBrief.Caption := '正在获取客户端岗位信息...';
    if GlobalDM.SiteInfo <> nil then
      FreeAndNil(GlobalDM.SiteInfo);
    GlobalDM.SiteInfo := TRsSiteInfo.Create;
    try
      if not m_DBSite.GetSiteByIP(localIP,GlobalDM.SiteInfo) then
      begin
        tfMessageBox(Format('该客户端没有在服务器上注册',[]),MB_ICONINFORMATION);
        exit;
      end;
    except on e : exception do
      begin
        tfMessageBox('登录失败：' + e.Message,MB_ICONERROR);
        exit;
      end;
    end;
    {if GlobalDM.SiteInfo.nSiteJob <> Ord(sjHouBan)  then
    begin
      tfMessageBox('非公寓端编号');
      exit;
    end; }


    LblBrief.Caption := '获取客户端岗位信息成功...';

    {$endregion '获取客户端岗位信息'}
    //GlobalDM.LoadSiteConfig();
    if GlobalDM.bLeaveLine = False then
    begin
      GlobalDM.LoadDB_Config();
      //打开消息组件
      GlobalDM.OpenMessageCompnent;
    end;

    GlobalDM.RemeberUser := edtDutyNumber.Text;
    GlobalDM.RemeberPWD := edtDutyPWD.Text ;
    GlobalDM.AutoLogin := True ;

    lblBrief.Caption := '登录成功';
    ModalResult := mrOk;
  finally
    LblBrief.Visible := false;
    EnableForm;
    if not edtDutyNumber.Focused then
      edtDutyNumber.SetFocus;
  end;
end;



procedure TfrmLogin.btnRoomSignClick(Sender: TObject);
begin

end;

{procedure TfrmLogin.btnRoomSignClick(Sender: TObject);
begin
  GlobalDM.ConnectLocal_SQLDB();
  GlobalDM.bLeaveLine := 1;
  if m_DBSite <> nil then
    FreeAndNil(m_DBSite);
  GlobalDM.LoadConfig;
  m_DBSite := TRsDBSite.Create(GlobalDM.LocalADOConnection);
  if GlobalDM.SiteInfo <> nil then
      FreeAndNil(GlobalDM.SiteInfo);
  GlobalDM.SiteInfo := TRsSiteInfo.Create;
  m_DBSite.GetSiteByIP(GlobalDM.SiteNumber,GlobalDM.SiteInfo);
  GlobalDM.DutyUser := TRsDutyUser.Create;

  TfrmMain_RoomSign.EnterRoomSign;
  ModalResult := mrCancel;
end; }

function TfrmLogin.CheckInput: boolean;
begin
  result := false;
  if Trim(edtDutyNumber.Text) = '' then
  begin
    tfMessageBox('请输入值班员工号',MB_ICONERROR);
    exit;
  end;
  result := true;
end;

procedure TfrmLogin.DisableForm;
begin
  btnLogin.Enabled := false;
  btnCancel.Enabled := false;
  edtDutyNumber.Enabled := false;
  edtDutyPWD.Enabled := false;
end;

procedure TfrmLogin.EnableForm;
begin
  btnLogin.Enabled := true;
  btnCancel.Enabled := true;
  edtDutyNumber.Enabled := true;
  edtDutyPWD.Enabled := true;
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  m_DBDutyUser := TRsDBDutyUser.Create(GlobalDM.LocalADOConnection);
  m_DBSite := TRsDBSite.Create(GlobalDM.LocalADOConnection);
  LblBrief.Visible := false;
  RzPanel3.DoubleBuffered := true;
  InitUI;
  InitData;
end;

procedure TfrmLogin.FormDestroy(Sender: TObject);
begin
  m_DBDutyUser.Free;
  m_DBSite.Free;
end;

procedure TfrmLogin.Image3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  m_ptDragStart := ClientToScreen(Point(X,Y))
end;

procedure TfrmLogin.Image3MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  pt : TPoint;
begin
  if (m_ptDragStart.X > 0) then
  begin
    pt := ClientToScreen(Point(X,Y));
    Left := Left + pt.X - m_ptDragStart.X;
    Top := Top + pt.Y - m_ptDragStart.Y;
    m_ptDragStart := pt;
  end;
end;

procedure TfrmLogin.Image3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  m_ptDragStart := Point(-1,-1);
end;

procedure TfrmLogin.InitData;
begin
  edtDutyNumber.Text := GlobalDM.RemeberUser;
  edtDutyPWD.Text := GlobalDM.RemeberPWD ;
end;

procedure TfrmLogin.InitUI;
begin
  lblVersion.Caption := '版本：' + RzVersionInfo1.FileVersion;
end;

procedure TfrmLogin.Timer1Timer(Sender: TObject);
begin
  TTimer(Sender).Enabled := false;
  if GlobalDM.AutoLogin then
  begin
    if Trim(edtDutyNumber.Text) <> '' then
      btnLogin.Click;
  end;
end;

function TfrmLogin.UpLoadClientAppInfo: Boolean;
var
  obClientApp : TRsClientAppOper ;
  clientAppInfo : RRsClientAppInfo ;
begin
  Result := False ;
  with clientAppInfo do
  begin
    strClientID := GlobalDM.SiteNumber;
    strClientVersion := RzVersionInfo1.FileVersion ;
    dtLogInTime := GlobalDM.GetNow;
    dtCreateTime := GlobalDM.GetNow;
  end;

  obClientApp := TRsClientAppOper.Create(GlobalDM.ADOConnection);
  try
    obClientApp.Insert(clientAppInfo)  ;
    Result := True ;
  finally
    obClientApp.Free;
  end;
end;

procedure TfrmLogin.actCancelExecute(Sender: TObject);
begin
  btnCancel.Click;
end;

procedure TfrmLogin.actEnterExecute(Sender: TObject);
begin
  if edtDutyNumber.Focused then
  begin
    if not CheckInput then exit;
    edtDutyPWD.SetFocus;
    exit;
  end;
  if edtDutyPWD.Focused then
  begin
    btnLogin.Click;
  end;
end;

procedure TfrmLogin.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmLogin.btnDBConfigClick(Sender: TObject);
begin
  TfrmConfig.EditConfig;
end;





end.
