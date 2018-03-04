unit uFrmRoomSign_Config;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, pngimage, StdCtrls, Mask, RzEdit,utfsystem,
  uRoomSignConfig;

type
  TFrmRoomSign_Config = class(TForm)
    Image1: TImage;
    btnSave: TButton;
    btnTestNetWork: TButton;
    chkLimitTime: TCheckBox;
    edtLimitTime: TRzEdit;
    lb1: TLabel;
    chkUseNetWork: TCheckBox;
    chkUploadData: TCheckBox;
    edtUploadTime: TRzEdit;
    Label1: TLabel;
    procedure btnTestNetWorkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure edtLimitTimeKeyPress(Sender: TObject; var Key: Char);
    procedure edtUploadTimeKeyPress(Sender: TObject; var Key: Char);
  private
    //初始化数据
    procedure InitData();
    //检查输入条件
    function CheckInput():Boolean;
  private
    { Private declarations }
    //公寓配置操作类
    m_obRoomSignConfig:TRoomSignConfigOper;
  public
    { Public declarations }
  end;

var
  FrmRoomSign_Config: TFrmRoomSign_Config;

implementation


uses
  uGlobalDM;

{$R *.dfm}

procedure TFrmRoomSign_Config.btnSaveClick(Sender: TObject);
begin
  if not CheckInput then
  begin
    BoxErr('错误');
    Exit ;
  end;
  
  with m_obRoomSignConfig.RoomSignConfigInfo do
  begin
    bIsUseNetwork := chkUseNetWork.Checked ;
    bEnableTimeLimit := chkLimitTime.Checked ;
    bEnableUpload := chkUploadData.Checked ;
    nSleepTime := StrToInt(edtLimitTime.Text);
    nUploadTime := StrToInt(edtUploadTime.Text);
  end;
  m_obRoomSignConfig.SaveToFile;
  Box('保存成功');
end;

procedure TFrmRoomSign_Config.btnTestNetWorkClick(Sender: TObject);
begin
  try
    GlobalDM.ConnecDB;
    Box('连接服务器成功！');
  except on e : exception do
    begin
      Box(Format('网络连接失败！',[]));
      Exit;
    end;
  end;
end;

function TFrmRoomSign_Config.CheckInput: Boolean;
begin
  Result := False ;
  Result := True ;
end;

procedure TFrmRoomSign_Config.edtLimitTimeKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9',#13,#8 ,#46]) then
    key := #0;
end;

procedure TFrmRoomSign_Config.edtUploadTimeKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9',#13,#8 ,#46]) then
    key := #0;
end;

procedure TFrmRoomSign_Config.FormCreate(Sender: TObject);
begin
  m_obRoomSignConfig := TRoomSignConfigOper.Create(GlobalDM.AppPath + 'config.ini');
  InitData;
end;

procedure TFrmRoomSign_Config.FormDestroy(Sender: TObject);
begin
  FreeAndNil(m_obRoomSignConfig);
end;

procedure TFrmRoomSign_Config.InitData;
begin
  m_obRoomSignConfig.ReadFromFile;

  with m_obRoomSignConfig.RoomSignConfigInfo do
  begin
    chkUseNetWork.Checked := bIsUseNetwork ;
    chkLimitTime.Checked := bEnableTimeLimit ;
    chkUploadData.Checked := bEnableUpload ;
    edtLimitTime.Text := IntToStr(nSleepTime) ;
    edtUploadTime.Text := IntToStr(nUploadTime)  ;
  end;
end;

end.
