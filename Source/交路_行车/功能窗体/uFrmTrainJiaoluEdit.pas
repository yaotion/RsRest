unit uFrmTrainJiaoluEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uWorkShop,uDBWorkShop,uTrainJiaolu,uDBTrainJiaolu,
  uTFSystem,uGlobalDM;

type
  TFrmTrainJiaoLuEdit = class(TForm)
    lbl2: TLabel;
    lbl3: TLabel;
    edtName: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    cbbWorkShop: TComboBox;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    //车间
    m_workShopAry:TRsWorkShopArray;
    //车间数据库操作
    m_DBWorkShop:TRsDBWorkShop;
    //行车交路数据库操作
    m_DBTrainJiaolu:TRsDBTrainJiaolu;
    //行车交路
    m_TrainJiaolu:RRsTrainJiaolu;

  private
    //填充车间列表
    procedure FillWorkShop();
    //填充传入数据
    procedure FillData();
  public
    //添加车间
    class function Add(trainJiaolu:RRsTrainJiaolu):Boolean;
    //修改车间
    class function Modify(trainJiaolu:RRsTrainJiaolu):Boolean;
  end;



implementation

{$R *.dfm}

{ TFrmCheJianEdit }

class function TFrmTrainJiaoLuEdit.Add(trainJiaolu:RRsTrainJiaolu): Boolean;
var
  Frm: TFrmTrainJiaoLuEdit;
begin
  result := False;
  Frm:= TFrmTrainJiaoLuEdit.Create(nil);
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

procedure TFrmTrainJiaoLuEdit.btnCancelClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

procedure TFrmTrainJiaoLuEdit.btnOkClick(Sender: TObject);
begin
  m_TrainJiaolu.strWorkShopGUID :=  m_workShopAry[cbbWorkShop.itemIndex].strWorkShopGUID;
  m_TrainJiaolu.strTrainJiaoluName := Trim(edtName.Text);
  if m_TrainJiaolu.strTrainJiaoluGUID = '' then
  begin
    m_TrainJiaolu.strTrainJiaoluGUID := NewGUID();
  end;
  m_DBTrainJiaolu.Add(m_TrainJiaolu);
  self.ModalResult := mrOk;
end;

procedure TFrmTrainJiaoLuEdit.FormCreate(Sender: TObject);
begin
  m_DBTrainJiaolu:=TRsDBTrainJiaolu.Create(GlobalDM.LocalADOConnection);
  m_DBWorkShop:=TRsDBWorkShop.Create(GlobalDM.LocalADOConnection);
end;

procedure TFrmTrainJiaoLuEdit.FormDestroy(Sender: TObject);
begin
  m_DBTrainJiaolu.Free;
  m_DBWorkShop.Free;
end;

procedure TFrmTrainJiaoLuEdit.FormShow(Sender: TObject);
begin
  FillWorkShop();
  FillData();
end;

procedure TFrmTrainJiaoLuEdit.FillWorkShop;
var
  i:Integer;
begin
  SetLength(m_workShopAry,0);
  m_DBWorkShop.GetAllWorkShop(m_workShopAry);

  for i := 0 to Length(m_workShopAry) - 1 do
  begin
    cbbWorkShop.Items.Add(m_workShopAry[i].strWorkShopName);
  end;
  if cbbWorkShop.Items.Count > 0 then
    cbbWorkShop.ItemIndex := 0;
end;

procedure TFrmTrainJiaoLuEdit.FillData;
var
  index:Integer;
begin
  index := cbbWorkShop.Items.IndexOfObject(TObject(m_TrainJiaolu.strWorkShopGUID));
  if index = -1  then
  begin
    cbbWorkShop.ItemIndex := 0;
  end;
  edtName.Text := m_TrainJiaolu.strTrainJiaoluName;
end;

class function TFrmTrainJiaoLuEdit.Modify(trainJiaolu:RRsTrainJiaolu): Boolean;
var
  Frm: TFrmTrainJiaoLuEdit;
begin
  result := False;
  Frm:= TFrmTrainJiaoLuEdit.Create(nil);
  try
    Frm.m_TrainJiaolu := trainJiaolu;
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
