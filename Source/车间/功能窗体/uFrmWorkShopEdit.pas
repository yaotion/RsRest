unit uFrmWorkShopEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uArea,uDBArea,uGlobalDM,uWorkShop,uDBWorkShop,uTFSystem;

type
  TFrmWorkShopEdit = class(TForm)
    lbl1: TLabel;
    lbl2: TLabel;
    edtNumber: TEdit;
    edtName: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    lbl3: TLabel;
    cbbJWD: TComboBox;
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    //机务段数组
    m_AreaAry:TAreaArray;
    //机务段数据库操作
    m_DBArea:TRsDBArea;
    //车间
    m_workShop:RRsWorkShop;
    //车间数据库操作
    m_DBWorkShop:TRsDBWorkShop;
  private
    //填充机务段列表
    procedure FillArea();
    //填充传入数据
    procedure FillData();
  public
    //添加车间
    class function Add(workShop:RRsWorkShop):Boolean;
    //修改车间
    class function Modify(workShop:RRsWorkShop):Boolean;
  end;



implementation

{$R *.dfm}

{ TFrmCheJianEdit }

class function TFrmWorkShopEdit.Add(workShop: RRsWorkShop): Boolean;
var
  Frm: TFrmWorkShopEdit;
begin
  result := False;
  Frm:= TFrmWorkShopEdit.Create(nil);
  try
    if Frm.ShowModal = mrOk then
    begin
      result := True;
      Exit;
    end;
  finally
    Frm.Free;
  end;
end;

procedure TFrmWorkShopEdit.btnCancelClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

procedure TFrmWorkShopEdit.btnOkClick(Sender: TObject);
begin
  m_workShop.strAreaGUID := m_AreaAry[cbbJWD.itemIndex].strAreaGUID;
  m_workShop.strWorkShopName := Trim(edtName.Text);
  m_workShop.strWorkShopNumber := Trim(edtNumber.Text);
  if m_workShop.strWorkShopGUID = '' then
  begin
    m_workShop.strWorkShopGUID := NewGUID();
  end;
  m_DBWorkShop.Add(m_workShop);
  self.ModalResult := mrOk;
end;

procedure TFrmWorkShopEdit.FormCreate(Sender: TObject);
begin
  m_DBArea:=TRsDBArea.Create;
  m_DBWorkShop:=TRsDBWorkShop.Create(GlobalDM.LocalADOConnection);
end;

procedure TFrmWorkShopEdit.FormDestroy(Sender: TObject);
begin
  m_DBArea.Free;
  m_DBWorkShop.Free;
end;

procedure TFrmWorkShopEdit.FormShow(Sender: TObject);
begin
  FillArea();
  FillData();
end;

procedure TFrmWorkShopEdit.FillArea;
var
  i:Integer;
begin
  SetLength(m_AreaAry,0);
  m_DBArea.GetAreas(GlobalDM.LocalADOConnection,m_AreaAry);

  for i := 0 to Length(m_AreaAry) - 1 do
  begin
    cbbJWD.Items.Add(m_AreaAry[i].strAreaName);
  end;
  if cbbJWD.Items.Count > 0 then
    cbbJWD.ItemIndex := 0;
end;

procedure TFrmWorkShopEdit.FillData;
var
  index:Integer;
begin
  index := cbbJWD.Items.IndexOf(m_workShop.strWorkShopName);
  if index = -1  then
  begin
    cbbJWD.ItemIndex := 0;
  end;
  edtNumber.Text := m_workShop.strWorkShopNumber;
  edtName.Text := m_workShop.strWorkShopName;
end;

class function TFrmWorkShopEdit.Modify(workShop: RRsWorkShop): Boolean;
var
  Frm: TFrmWorkShopEdit;
begin
  result := False;
  Frm:= TFrmWorkShopEdit.Create(nil);
  try
    Frm.m_workShop := workShop;
    if Frm.ShowModal = mrOk then
    begin
      result := True;
      Exit;
    end;
  finally
    Frm.Free;
  end;
end;

end.
