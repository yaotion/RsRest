unit uFrmDutyUserEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uDutyUser,uDBDutyUser,uCheckInputPubFun,uTFSystem,uGlobalDM;

type
  TFrmDutyUserEdit = class(TForm)
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    edtName: TEdit;
    edtPsw: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    edtNumber: TEdit;
    lbl4: TLabel;
    edtPsw2: TEdit;
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    //数据库操作
    m_dbDutyUser:TRsDBDutyUser;
    //值班员
    m_DutyUser:TRsDutyUser;
  private
    //校验输入
    function CheckInput():Boolean;
    //将UI数据赋值给对象
    procedure UI2Obj();
    //显示待修改数据
    procedure ShowModifyData();
  public
    //增加管理员
    class function Add(dutyUser:TRsDutyUser) :Boolean;
    //修改管理员
    class function Modify(dutyUser:TRsDutyUser):Boolean;
  end;



implementation

uses
  utfPopBox;

{$R *.dfm}

{ TFrmDutyUserEdit }

class function TFrmDutyUserEdit.Add(dutyUser: TRsDutyUser): Boolean;
var
  Frm: TFrmDutyUserEdit;
begin
  result := False;
  Frm:= TFrmDutyUserEdit.Create(nil);
  try
    if Frm.ShowModal = mrOk then
    begin
      dutyUser.Copy(Frm.m_DutyUser);
      result := True;
    end;
  finally
    Frm.Free;
  end;
end;

procedure TFrmDutyUserEdit.btnCancelClick(Sender: TObject);
begin
  self.ModalResult := mrCancel;
end;

procedure TFrmDutyUserEdit.btnOkClick(Sender: TObject);
begin
  if CheckInput = False then Exit;
  UI2Obj;
  m_dbDutyUser.Save(m_DutyUser);

  Self.ModalResult := mrok;
end;

function TFrmDutyUserEdit.CheckInput: Boolean;
begin
  result := False;
  if TCheckInputPF.bEmpty(edtNumber) = False then
  begin
    TtfPopBox.ShowBox('工号不能为空!');
    Exit;
  end;
  if TCheckInputPF.bEmpty(edtName) = False then
  begin
    TtfPopBox.ShowBox('姓名不能为空!');
    Exit;
  end;
  if TCheckInputPF.bEmpty(edtPsw) = False then
  begin
    TtfPopBox.ShowBox('密码不能为空!');
    Exit;
  end;
  if TCheckInputPF.bEmpty(edtPsw) = False then
  begin
    TtfPopBox.ShowBox('确认密码不能为空!');
    Exit;
  end;

  if Trim(edtPsw.Text ) <> Trim(edtPsw2.Text) then
  begin
    TtfPopBox.ShowBox('2次输入密码不一致!');
    Exit;
  end;
  result := true;
end;

procedure TFrmDutyUserEdit.FormCreate(Sender: TObject);
begin
  m_dbDutyUser:=TRsDBDutyUser.Create(GlobalDM.LocalADOConnection);
  m_DutyUser:=TRsDutyUser.Create;
end;

procedure TFrmDutyUserEdit.FormDestroy(Sender: TObject);
begin
  m_DutyUser.Free;
end;

procedure TFrmDutyUserEdit.FormShow(Sender: TObject);
begin
  ShowModifyData;
end;

class function TFrmDutyUserEdit.Modify(dutyUser: TRsDutyUser): Boolean;
var
  Frm: TFrmDutyUserEdit;
begin
  result := False;
  Frm:= TFrmDutyUserEdit.Create(nil);
  try
    frm.m_DutyUser.Copy(dutyUser);
    if Frm.ShowModal = mrOk then
    begin
      dutyUser.Copy(Frm.m_DutyUser);
      result := True;
    end;
  finally
    Frm.Free;
  end;
end;

procedure TFrmDutyUserEdit.ShowModifyData;
begin
  edtNumber.Text := m_DutyUser.strDutyNumber;
  edtName.Text := m_DutyUser.strDutyName;
  edtPsw.Text := m_DutyUser.strPassword;
  edtPsw2.Text := m_DutyUser.strPassword;
end;

procedure TFrmDutyUserEdit.UI2Obj;
begin
  m_DutyUser.strDutyNumber :=Trim( edtNumber.Text);
  m_DutyUser.strDutyName :=Trim( edtName.Text);
  m_DutyUser.strPassword :=Trim( edtPsw.Text);
  m_DutyUser.strPassword :=Trim( edtPsw2.Text);
end;

end.
