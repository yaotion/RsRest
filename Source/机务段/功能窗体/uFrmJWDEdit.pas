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
    //����ζ���
    m_Area:RRsArea;
    //��������ݿ����
    m_DBArea:TRsDBArea;
  private
    //У������
    function checkInput():Boolean;
    //��ʾ�����µ�����
    procedure ShowData();
  public
    //���ӻ����
    class function Add(var area:RRsArea):Boolean;
    //�޸Ļ����
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
    TtfPopBox.ShowBox('��Ų���Ϊ��');
    edtNumber.SetFocus;
    Exit;
  end;
  if Trim(edtName.Text) = '' then
  begin
    TtfPopBox.ShowBox('���Ʋ���Ϊ��');
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
