unit uFrmJWDEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uArea,uDBArea,uGlobalDM,uTFSystem;

type
  TFrmJWDEdit = class(TForm)
    lbl1: TLabel;
    edtNumber: TEdit;
    lbl2: TLabel;
    edtName: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    //机务段对象
    m_Area:RRsArea;
    //机务段数据库操作
    m_DBArea:TRsDBArea;
  private
    //校验输入
    function checkInput():Boolean;
    //显示待更新的数据
    procedure ShowData();
  public
    //增加机务段
    class function Add(var area:RRsArea):Boolean;
    //修改机务段
    class function Modity(var area:RRsArea):Boolean;
  end;



implementation

uses
  utfPopBox ;

{$R *.dfm}

{ TFrmJWDEdit }

class function TFrmJWDEdit.Add(var area: RRsArea): Boolean;
var
  FrmJWDEdit: TFrmJWDEdit;
begin
  result := False;
  FrmJWDEdit:= TFrmJWDEdit.Create(nil);
  try
    if FrmJWDEdit.ShowModal = mrOk then result := True;
  finally
    FrmJWDEdit.Free;
  end;
end;



procedure TFrmJWDEdit.btnCancelClick(Sender: TObject);
begin
  self.ModalResult := mrCancel;
end;

procedure TFrmJWDEdit.btnOkClick(Sender: TObject);
begin
  m_Area.strJWDNumber := Trim(edtNumber.Text);
  m_Area.strAreaName := Trim(edtName.Text);
  if m_Area.strAreaGUID = '' then
  begin
    m_Area.strAreaGUID := newGUID();
  end;
  m_DBArea.Add(GlobalDM.LocalADOConnection,m_Area);
  self.ModalResult := mrOk;
end;

function TFrmJWDEdit.checkInput: Boolean;
begin
  result := False;
  if Trim(edtNumber.Text) = '' then
  begin
    TtfPopBox.ShowBox('编号不能为空');
    edtNumber.SetFocus;
    Exit;
  end;
  if Trim(edtName.Text) = '' then
  begin
    TtfPopBox.ShowBox('名称不能为空');
    edtName.SetFocus;
    Exit;
  end;
  result := True;
end;

procedure TFrmJWDEdit.FormCreate(Sender: TObject);
begin
  m_DBArea:=TRsDBArea.Create;
end;

procedure TFrmJWDEdit.FormDestroy(Sender: TObject);
begin
  m_DBArea.Free;
end;

procedure TFrmJWDEdit.FormShow(Sender: TObject);
begin
  ShowData;
end;

class function TFrmJWDEdit.Modity(var area: RRsArea): Boolean;
var
  FrmJWDEdit: TFrmJWDEdit;
begin
  result := False;
  FrmJWDEdit:= TFrmJWDEdit.Create(nil);
  try
    FrmJWDEdit.m_Area := area;
    if FrmJWDEdit.ShowModal = mrOk then
    begin
      area := FrmJWDEdit.m_Area;
      result := True;
    end;
  finally
    FrmJWDEdit.Free;
  end;
end;

procedure TFrmJWDEdit.ShowData;
begin
  edtNumber.Text := m_Area.strJWDNumber;
  edtName.Text := m_Area.strAreaName;
end;

end.
