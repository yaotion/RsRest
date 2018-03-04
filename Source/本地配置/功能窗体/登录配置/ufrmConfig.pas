unit ufrmConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, StdCtrls, PngImageList, Buttons, PngCustomButton,
  DB, ADODB, ImgList, ActnList, ComCtrls, Mask, RzEdit, RzLabel, uFrmSQLConfig,
  utfSQLConn, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdFTP,uTFSystem, RzDTP,uFrmBaseDataConfig,
  uFrmSyncBaseData;

type
  TfrmConfig = class(TForm)
    Panel1: TPanel;
    PageControl: TPageControl;
    tvItemSelect: TTreeView;
    Panel2: TPanel;
    RzPanel4: TRzPanel;
    btnSave: TButton;
    btnCancel: TButton;
    PngImageList1: TPngImageList;
    SQLConfigDialog1: TSQLConfigDialog;
    tabBaseConfig: TTabSheet;
    RzPanel1: TRzPanel;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    edtSiteNumber: TEdit;
    Label3: TLabel;
    edtWebHost: TEdit;
    tsLocalDB: TTabSheet;
    SQLConfigPanelLocal: TSQLConfigPanel;
    RzPanel2: TRzPanel;
    Image3: TImage;
    Label4: TLabel;
    btnLocalConfig: TButton;
    tsBaseData: TTabSheet;
    btnDicConfig: TButton;
    btnDicDownLoad: TButton;
    rbOnLine: TRadioButton;
    rbstandalone: TRadioButton;
    pnl1: TRzPanel;
    img1: TImage;
    lbl1: TLabel;
    btnViewDic: TButton;
    chk_UseFinger: TCheckBox;
    chk_RecordTel: TCheckBox;
    chk_UninterruptedSign: TCheckBox;
    chk_ServerRoomCall: TCheckBox;
    chk_AutoLeaveRoom: TCheckBox;
    chk_enableReverseCall: TCheckBox;
    chk_enableOnesCall: TCheckBox;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnConfigClick(Sender: TObject);
    procedure tvItemSelectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnLocalConfigClick(Sender: TObject);
    procedure btnDicConfigClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rbstandaloneClick(Sender: TObject);
    procedure rbOnLineClick(Sender: TObject);
    procedure btnDicDownLoadClick(Sender: TObject);
  private
    { Private declarations }
    procedure Init;
    //检测输入
    function CheckInput : boolean;
    //控制程序模式设置
    procedure SetProMode();

  public
    { Public declarations }
    class function EditConfig() : boolean;
  end;



implementation
uses
  uGlobalDM,ufrmCallConfig;
{$R *.dfm}

{ TfrmConfig }

procedure TfrmConfig.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmConfig.btnConfigClick(Sender: TObject);
begin
  if not SQLConfigDialog1.Execute(GlobalDM.SQLConfig) then exit;
  //SQLConfigPanel1.SQLConfig := GlobalDM.SQLConfig;
end;
    
procedure TfrmConfig.btnDicConfigClick(Sender: TObject);
begin
  try
    GlobalDM.ConnectLocal_SQLDB;
  except on e:Exception do
    begin
      Box(e.Message);
      Exit;
    end;
  end;
  TFrmBaseDataConfig.Show;
end;

procedure TfrmConfig.btnDicDownLoadClick(Sender: TObject);
begin
  TFrmSyncBaseData.LoadData
end;

procedure TfrmConfig.btnLocalConfigClick(Sender: TObject);
begin
  if not SQLConfigDialog1.Execute(GlobalDM.SQLConfig_Local) then exit;
  SQLConfigPanelLocal.SQLConfig := GlobalDM.SQLConfig_Local;
end;


procedure TfrmConfig.btnSaveClick(Sender: TObject);
begin
  if not CheckInput then exit;
  GlobalDM.SQLConfig.Save;
  GlobalDM.SQLConfig_Local.save;
  GlobalDM.SiteNumber := edtSiteNumber.Text;
  GlobalDM.WebHost := edtWebHost.Text;

  GlobalDM.bLeaveLine := rbstandalone.Checked;
  GlobalDM.bUseFinger := chk_UseFinger.Checked;

  GlobalDM.bRecorcdTel := chk_RecordTel.Checked ;
  GlobalDM.bUninterruptedSign := chk_UninterruptedSign.Checked ;
  GlobalDM.bEnableServerRoomCall := chk_ServerRoomCall.Checked ;
  GlobalDM.bAutoLeaveRoom := chk_AutoLeaveRoom.Checked;
  GlobalDM.bEnableReverseCall := chk_enableReverseCall.Checked ;
  GlobalDM.bEnableOnesCall := chk_enableOnesCall.Checked ;
  ModalResult := mrOk;
end;

function TfrmConfig.CheckInput: boolean;
begin
  result := true;
end;




class function TfrmConfig.EditConfig: boolean;
var
  frmConfig : TfrmConfig;
begin
  result := false;
  frmConfig := TfrmConfig.Create(nil);
  try
    frmConfig.Init;
    if frmConfig.ShowModal = mrCancel then exit;
    result := true;
  finally
    frmConfig.Free;
  end;
end;

procedure TfrmConfig.FormCreate(Sender: TObject);
begin
  PageControl.ActivePageIndex := 0;
end;



procedure TfrmConfig.FormShow(Sender: TObject);
begin
  //btnDicConfig.Visible := rbstandalone.Checked ;
  //SetProMode;
end;

procedure TfrmConfig.Init;
begin
  //数据库连接信息
  //SQLConfigPanel1.SQLConfig := GlobalDM.SqlConfig;
  SQLConfigPanelLocal.SQLConfig := GlobalDM.SQLConfig_Local;
  edtSiteNumber.Text := GlobalDM.SiteNumber;
  edtWebHost.Text := GlobalDM.WebHost ;
  rbstandalone.Checked := GlobalDM.bLeaveLine;
  SetProMode;

  chk_UseFinger.Checked := GlobalDM.bUseFinger;
  chk_RecordTel.Checked := GlobalDM.bRecorcdTel ;
  chk_UninterruptedSign.Checked := GlobalDM.bUninterruptedSign ;
  chk_ServerRoomCall.Checked := GlobalDM.bEnableServerRoomCall ;
  chk_AutoLeaveRoom.Checked := GlobalDM.bAutoLeaveRoom;
  chk_enableReverseCall.Checked := GlobalDM.bEnableReverseCall ;
  chk_enableOnesCall.Checked := GlobalDM.bEnableOnesCall ;
end;


procedure TfrmConfig.rbOnLineClick(Sender: TObject);
begin
  SetProMode;
end;

procedure TfrmConfig.rbstandaloneClick(Sender: TObject);
begin
  SetProMode;
end;

procedure TfrmConfig.SetProMode;
begin
  if rbstandalone.Checked then
  begin
    btnDicConfig.Visible := True;
    btnViewDic.Visible := False;
    btnDicDownLoad.Visible := False;
  end
  else
  begin
    btnDicConfig.Visible := False;
    btnViewDic.Visible := True;
    btnDicDownLoad.Visible := True;
  end;
end;

procedure TfrmConfig.tvItemSelectClick(Sender: TObject);
begin
  PageControl.ActivePageIndex := tvItemSelect.Selected.Index;
end;

end.
