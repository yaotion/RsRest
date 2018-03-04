unit uFrmEditCallDev2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uRoomCall,uRoomCallApp,uTFSystem, Spin;

type
  TFrmEditCallDev2 = class(TForm)
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
    //�Ƿ��޸�
    m_bEdit:Boolean;
    //�����豸
    m_RoomDev:RCallDev;
    //��Ԣ�а����
    m_RoomCallApp : TRoomCallApp;
  private
    {����:У������}
    function CheckData():Boolean;
    {����:����ֵ}
    procedure SetData();

  end;
  {����:���ӷ����豸����}
  function CreateServerRoomDev(out dev:RCallDev):Boolean;
  {����:�޸ķ����豸����}
  function ModifyServerRoomDev(var dev:RCallDev):Boolean;


implementation

uses
  utfPopBox ;

{$R *.dfm}
function CreateServerRoomDev(out dev:RCallDev):Boolean;
var
  Frm: TFrmEditCallDev2;
begin
  Result := False;
  Frm:= TFrmEditCallDev2.Create(nil);
  try
    dev.New;
    Frm.m_RoomDev := dev;
    if Frm.ShowModal = mrOk then
    begin
      dev := Frm.m_RoomDev;
      Frm.m_RoomCallApp.DBServerRoomDev.Add(dev);
      result := True;
    end;
  finally
    Frm.Free;
  end;
end;

function ModifyServerRoomDev(var dev:RCallDev):Boolean;
var
  Frm: TFrmEditCallDev2;
begin
  result:= False;
  Frm:= TFrmEditCallDev2.Create(nil);
  try
    Frm.m_RoomDev := dev;
    Frm.m_bEdit := True;
    if Frm.ShowModal = mrOk then
    begin
      dev := Frm.m_RoomDev;
      Frm.m_RoomCallApp.DBServerRoomDev.Modify (dev);
      result := True;
    end;
  finally
    Frm.Free;
  end;
end;
procedure TFrmEditCallDev2.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmEditCallDev2.btnOKClick(Sender: TObject);
begin
  SetData;
  if CheckData = False Then Exit;
  ModalResult := mrOk;
end;

function TFrmEditCallDev2.CheckData: Boolean;
var
  tRoomDev:RCallDev;
begin
  result := False;
  //����
  if not m_bEdit then
  begin
    if m_RoomCallApp.DBServerRoomDev.FindByRoom(m_RoomDev.strRoomNum,tRoomDev) = True then
    begin
      TtfPopBox.ShowBox('�������Ѵ���!');
      Exit;
    end;
    if m_RoomCallApp.DBServerRoomDev.FindByDev(m_RoomDev.nDevNum,tRoomDev) = True then
    begin
      TtfPopBox.ShowBox('�豸����Ѵ���!');
      Exit;
    end;
  end;

  //�޸�
  if m_RoomCallApp.DBServerRoomDev.FindByDev(m_RoomDev.nDevNum,tRoomDev) = True then
  begin
    TtfPopBox.ShowBox('�豸����Ѵ���!');
    Exit;
  end;
  result :=True;

end;

procedure TFrmEditCallDev2.FormCreate(Sender: TObject);
begin
  m_RoomCallApp := TRoomCallApp.GetInstance;
end;

procedure TFrmEditCallDev2.FormShow(Sender: TObject);
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

procedure TFrmEditCallDev2.SetData;
begin
  m_RoomDev.strRoomNum := Trim(edtRoomNum.Text) ;
  m_RoomDev.nDevNum := edtDevNum.Value;
end;

end.
