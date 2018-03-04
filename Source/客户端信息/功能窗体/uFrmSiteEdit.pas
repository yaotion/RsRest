unit uFrmSiteEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uArea,uDBArea,uWorkShop,uDBWorkShop,uSite,uDBSite,uGlobalDM,
  uTFSystem;

type
  TFrmSiteEdit = class(TForm)
    lbl2: TLabel;
    lbl3: TLabel;
    edtName: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    cbbArea: TComboBox;
    lbl1: TLabel;
    cbbWorkShop: TComboBox;
    lbl4: TLabel;
    edtNumber: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbbAreaChange(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    //���������
    m_AreaAry:TAreaArray;
    //�����db����
    m_DBArea:TRsDBArea;
    //��������
    m_WorkShopAry:TRsWorkShopArray;
    //����db����
    m_dbWorkShop:TRsDBWorkShop;
    //�ͻ��˶���
    m_site:RRsSiteInfo;
    //�ͻ���db����
    m_DBSite:TRsDBSite;

  private
    //��������
    function CheckInput():Boolean;
    //��ʼ��������б�
    procedure InitArea();
    //��ʼ�������б�
    procedure InitWorkShop(strAreaGUID:string);
    //��ʾ���޸�����
    procedure ShowModifyData();

  public
    //����
    class function Add(SiteInfo:RRsSiteInfo):Boolean;
    //�޸�
    class function Modify(var SiteInfo:RRsSiteInfo):Boolean;
  end;



implementation

uses
  utfPopBox ;

{$R *.dfm}

class function TFrmSiteEdit.Add(SiteInfo: RRsSiteInfo): Boolean;
var
  Frm: TFrmSiteEdit;
begin
  result := False;
  Frm:= TFrmSiteEdit.Create(nil);
  try
    if Frm.ShowModal = mrOk then
      result := True;
  finally
    Frm.Free;
  end;
end;

procedure TFrmSiteEdit.btnCancelClick(Sender: TObject);
begin
  self.ModalResult := mrCancel;
end;

procedure TFrmSiteEdit.btnOkClick(Sender: TObject);
begin
  if CheckInput = False then Exit;
  if m_site.strSiteGUID = '' then
  begin
    m_site.strSiteGUID := NewGUID;
  end;
  m_site.strSiteIP := Trim(edtNumber.Text);
  m_site.strSiteName := Trim(edtName.Text);
  m_site.strAreaGUID := m_AreaAry[cbbArea.itemIndex].strAreaGUID;
  m_site.strWorkShopGUID := m_WorkShopAry[cbbWorkShop.ItemIndex].strWorkShopGUID;
  m_site.strTMIS := m_site.strSiteIP;
  m_DBSite.Add(m_site);
  self.ModalResult := mrOk;
end;

procedure TFrmSiteEdit.cbbAreaChange(Sender: TObject);
begin
  if cbbArea.ItemIndex >= 0 then
  begin
    InitWorkShop(m_AreaAry[cbbArea.itemIndex].strAreaGUID);
  end;
end;

function TFrmSiteEdit.CheckInput: Boolean;
begin
  result := False;
  if cbbArea.ItemIndex = -1 then
  begin
    cbbArea.SetFocus;
    TtfPopBox.ShowBox('����β���Ϊ��!');
    Exit;
  end;
  if cbbWorkShop.ItemIndex = -1 then
  begin
    cbbWorkShop.SetFocus;
    TtfPopBox.ShowBox('���䲻��Ϊ��!');
    Exit;
  end;

  if Trim(edtNumber.Text) = '' then
  begin
    edtNumber.SetFocus;
    TtfPopBox.ShowBox('��Ų���Ϊ��!');
    Exit;
  end;

  if Trim(edtName.Text) = '' then
  begin
    edtName.SetFocus;
    TtfPopBox.ShowBox('���Ʋ���Ϊ��!');
    Exit;
  end;
  result:= True;
end;

procedure TFrmSiteEdit.FormCreate(Sender: TObject);
begin
  m_DBArea := TRsDBArea.Create;
  m_dbWorkShop := TRsDBWorkShop.Create(GlobalDM.LocalADOConnection);
  m_DBSite := TRsDBSite.Create(GlobalDM.LocalADOConnection);
end;

procedure TFrmSiteEdit.FormDestroy(Sender: TObject);
begin
  m_DBArea.Free;
  m_dbWorkShop.Free;
  m_DBSite.Free;
end;

procedure TFrmSiteEdit.FormShow(Sender: TObject);
begin
  InitArea;

  ShowModifyData;
end;

procedure TFrmSiteEdit.InitArea;
var
  i:Integer;
begin
  m_DBArea.GetAreas(GlobalDM.LocalADOConnection,m_AreaAry);
  for i := 0 to Length(m_AreaAry)  - 1 do
  begin
    cbbArea.Items.Add(m_AreaAry[i].strAreaName);
  end;
  if cbbArea.Items.Count > 0 then
  begin
    cbbArea.ItemIndex := 0;
    cbbAreaChange(nil);
  end;
end;

procedure TFrmSiteEdit.InitWorkShop(strAreaGUID:string);
var
  i:Integer;
begin
  cbbWorkShop.Clear;
  m_dbWorkShop.GetWorkShopOfArea(strAreaGUID,m_WorkShopAry);
  for i := 0 to Length(m_WorkShopAry)  - 1 do
  begin
    cbbWorkShop.Items.Add(m_WorkShopAry[i].strWorkShopName);
  end;
  if cbbWorkShop.Items.Count > 0 then
    cbbWorkShop.ItemIndex := 0;
end;

class function TFrmSiteEdit.Modify(var SiteInfo: RRsSiteInfo): Boolean;
var
  Frm: TFrmSiteEdit;
begin
  result := False;
  Frm:= TFrmSiteEdit.Create(nil);
  try
    Frm.m_site := SiteInfo;
    if Frm.ShowModal = mrOk then
    begin
      result := True;
      SiteInfo := Frm.m_site;
    end;
  finally
    Frm.Free;
  end;
end;

procedure TFrmSiteEdit.ShowModifyData;
var
  i:Integer;
begin
  for i := 0 to Length(m_AreaAry) - 1 do
  begin
    if m_AreaAry[i].strAreaGUID = m_site.strAreaGUID then
    begin
      cbbArea.ItemIndex := i;
    end;
  end;

  for i := 0 to Length(m_WorkShopAry) - 1 do
  begin
    if m_WorkShopAry[i].strWorkShopGUID = m_site.strWorkShopGUID then
    begin
      cbbWorkShop.ItemIndex := i;
    end;
  end;

  edtNumber.Text := m_site.strSiteIP;
  edtName.Text := m_site.strSiteName;

end;

end.
