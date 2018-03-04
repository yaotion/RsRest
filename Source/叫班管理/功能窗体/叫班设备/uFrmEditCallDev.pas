unit uFrmEditCallDev;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uRoomCall,uRoomCallApp,uTFSystem, Spin;

type
  TFrmEditCallDev = class(TForm)
    lbl1: TLabel;
    edtRoomNum: TEdit;
    Label1: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    edtDevNum: TSpinEdit;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    //是否修改
    m_bEdit:Boolean;
    //房间设备
    m_RoomDev:RCallDev;
    //公寓叫班管理
    m_RoomCallApp : TRoomCallApp;
  private
    {功能:校验数据}
    function CheckData():Boolean;
    {功能:设置值}
    procedure SetData();

  end;
  {功能:增加房间设备配置}
  function CreateRoomDev(out dev:RCallDev):Boolean;
  {功能:修改房间设备配置}
  function ModifyRoomDev(var dev:RCallDev):Boolean;


implementation

uses
  utfPopBox ;

{$R *.dfm}
function CreateRoomDev(out dev:RCallDev):Boolean;
var
  Frm: TFrmEditCallDev;
begin
  Result := False;
  Frm:= TFrmEditCallDev.Create(nil);
  try
    dev.New;
    Frm.m_RoomDev := dev;
    if Frm.ShowModal = mrOk then
    begin
      dev := Frm.m_RoomDev;
      Frm.m_RoomCallApp.DBCallDev.Add(dev);
      result := True;
    end;
  finally
    Frm.Free;
  end;
end;

function ModifyRoomDev(var dev:RCallDev):Boolean;
var
  Frm: TFrmEditCallDev;
begin
  result:= False;
  Frm:= TFrmEditCallDev.Create(nil);
  try
    Frm.m_RoomDev := dev;
    Frm.m_bEdit := True;
    if Frm.ShowModal = mrOk then
    begin
      dev := Frm.m_RoomDev;
      Frm.m_RoomCallApp.DBCallDev.Modify (dev);
      result := True;
    end;
  finally
    Frm.Free;
  end;
end;
procedure TFrmEditCallDev.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmEditCallDev.btnOKClick(Sender: TObject);
begin
  SetData;
  if CheckData = False Then Exit;
  ModalResult := mrOk;
end;

function TFrmEditCallDev.CheckData: Boolean;
var
  tRoomDev:RCallDev;
begin
  result := False;
  //新增
  if not m_bEdit then
  begin
    if m_RoomCallApp.DBCallDev.FindByRoom(m_RoomDev.strRoomNum,tRoomDev) = True then
    begin
      TtfPopBox.ShowBox('房间编号已存在!');
      Exit;
    end;
    if m_RoomCallApp.DBCallDev.FindByDev(m_RoomDev.nDevNum,tRoomDev) = True then
    begin
      TtfPopBox.ShowBox('设备编号已存在!');
      Exit;
    end;
  end;

  //修改
  if m_RoomCallApp.DBCallDev.FindByDev(m_RoomDev.nDevNum,tRoomDev) = True then
  begin
    TtfPopBox.ShowBox('设备编号已存在!');
    Exit;
  end;
  result :=True;

end;

procedure TFrmEditCallDev.FormCreate(Sender: TObject);
begin
  m_RoomCallApp := TRoomCallApp.GetInstance;
end;

procedure TFrmEditCallDev.FormShow(Sender: TObject);
begin
  if m_bEdit then
  begin
    edtRoomNum.Enabled := False;
  end
  else
  begin
    edtRoomNum.Enabled := True;
  end;
  
  edtRoomNum.Text := m_RoomDev.strRoomNum;
  edtDevNum.Value := m_RoomDev.nDevNum;
end;

procedure TFrmEditCallDev.SetData;
begin
  m_RoomDev.strRoomNum := Trim(edtRoomNum.Text) ;
  m_RoomDev.nDevNum := edtDevNum.Value;
end;

end.
