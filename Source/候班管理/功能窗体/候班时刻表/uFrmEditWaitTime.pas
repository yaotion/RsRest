unit uFrmEditWaitTime;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RzEdit,uWaitWork,uTFSystem,uWaitWorkMgr,uDBWorkShop,
  uDBTrainJiaolu,uWorkShop,uTrainJiaolu,uGlobalDM;

type
  TFrmEditWaitTime = class(TForm)
    lbl3: TLabel;
    edtCheci: TEdit;
    lbl8: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    edtHouBan: TRzDateTimeEdit;
    edtJiaoBan: TRzDateTimeEdit;
    edtChuQin: TRzDateTimeEdit;
    edtKaiche: TRzDateTimeEdit;
    btnOK: TButton;
    btnCancel: TButton;
    lbl2: TLabel;
    edtRoomNum: TEdit;
    chk_MustSleep: TCheckBox;
    lbl10: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbbCheJianChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    {����:У������}
    function CheckData():Boolean;
    {����:��ֵ����}
    procedure UI2Obj();
    {���� :��ʾ����}
    procedure obj2UI();
    {����:��ʼ������}
    procedure InitWorkShop(strWorkShopGUID:string='');
    {����:��ʼ����·}
    procedure InitJiaoLu(strJiaoLuGUID:string='');


  private
    //���ʱ�̱�
    m_WaitTime:RWaitTime;
    //�������ݿ����
    m_DBWorkShop:TRsDBWorkShop;
    //��·���ݿ����
    m_DBTrainJiaoLu:TRsDBTrainJiaolu;
    //��������
    m_WorkShopAry:TRsWorkShopArray;
    //��·����
    m_JiaoLuAry:TRsTrainJiaoluArray;

  public
    {����:�޸ĺ���}
    class function ModifyWaitTable(var WaitTime:RWaitTime):Boolean;
    {����:���Ӻ���}
    class function AddWaitTable(out WaitTime:RWaitTime):Boolean;
  end;

implementation

uses
  utfPopBox ;

{$R *.dfm}

{ TFrmEditWaitTable }

class function TFrmEditWaitTime.AddWaitTable(out WaitTime: RWaitTime): Boolean;
var
  frm:TFrmEditWaitTime;
begin
  result := False;
  frm := TFrmEditWaitTime.Create(nil);
  try
    frm.m_WaitTime.New();
    if frm.ShowModal = mrOk then
    begin
      WaitTime := frm.m_WaitTime;
      result := True;
    end;
  finally
    frm.Free;
  end;
end;

procedure TFrmEditWaitTime.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmEditWaitTime.btnOKClick(Sender: TObject);
begin
  if CheckData = False then Exit;
  UI2Obj();
  ModalResult := mrOk;
end;

procedure TFrmEditWaitTime.cbbCheJianChange(Sender: TObject);
begin
  InitJiaoLu();
end;

function TFrmEditWaitTime.CheckData: Boolean;
begin
  Result := False ;
  if Trim(edtCheci.Text) = '' then
  begin
    edtCheci.Focused;
    TtfPopBox.ShowBox('���β���Ϊ��');
    Exit;
  end;

  {if Trim(edtRoomNum.Text) = '' then
  begin
    edtCheci.Focused;
    TtfPopBox.ShowBox('����Ų���Ϊ��');
    Exit;
  end;}

  if Trim(edtHouBan.Text) = '' then
  begin
    edtCheci.Focused;
    TtfPopBox.ShowBox('���ʱ�䲻��Ϊ��');
    Exit;
  end;

  if Trim(edtJiaoBan.Text) = '' then
  begin
    edtCheci.Focused;
    TtfPopBox.ShowBox('�а�ʱ�䲻��Ϊ��');
    Exit;
  end;

  if Trim(edtChuQin.Text) = '' then
  begin
    edtCheci.Focused;
    TtfPopBox.ShowBox('����ʱ�䲻��Ϊ��');
    Exit;
  end;

  if Trim(edtKaiche.Text) = '' then
  begin
    edtCheci.Focused;
    TtfPopBox.ShowBox('����ʱ�䲻��Ϊ��');
    Exit;
  end;
  result := True;
  
end;

procedure TFrmEditWaitTime.FormCreate(Sender: TObject);
begin
  m_DBWorkShop := TRsDBWorkShop.Create(GlobalDM.LocalADOConnection);
  m_DBTrainJiaoLu := TRsDBTrainJiaolu.Create(GlobalDM.LocalADOConnection);
end;

procedure TFrmEditWaitTime.FormDestroy(Sender: TObject);
begin
  m_DBWorkShop.Free;
  m_DBTrainJiaoLu.Free;
end;

procedure TFrmEditWaitTime.FormShow(Sender: TObject);
begin
  obj2UI();
end;


procedure TFrmEditWaitTime.InitJiaoLu(strJiaoLuGUID:string);
begin

end;

procedure TFrmEditWaitTime.InitWorkShop(strWorkShopGUID:string);
var
  i:Integer;
begin
;
end;

class function TFrmEditWaitTime.ModifyWaitTable(
  var WaitTime: RWaitTime): Boolean;
var
  frm:TFrmEditWaitTime;
begin
  result := False;
  frm := TFrmEditWaitTime.Create(nil);
  try
    frm.m_WaitTime := WaitTime;
    if frm.ShowModal = mrOk then
    begin
      WaitTime := frm.m_WaitTime;
      result := True;
    end;
  finally
    frm.Free;
  end;
end;

procedure TFrmEditWaitTime.obj2UI;
begin
  InitWorkShop(m_WaitTime.strWorkshopGUID);
  InitJiaoLu(m_WaitTime.strTrainJiaoLuGUID);
  edtCheci.Text := m_WaitTime.strTrainNo;
  edtRoomNum.Text := m_WaitTime.strRoomNum;
  edtHouBan.Time := m_WaitTime.dtWaitTime;
  edtJiaoBan.Time := m_WaitTime.dtCallTime;
  edtChuQin.Time := m_WaitTime.dtChuQinTime;
  edtKaiche.Time := m_WaitTime.dtKaiCheTime;
  chk_MustSleep.Checked := m_WaitTime.bMustSleep  ;
end;

procedure TFrmEditWaitTime.UI2Obj;
begin
  m_WaitTime.strTrainNo := Trim(edtCheci.Text);
  m_WaitTime.strRoomNum := Trim(edtRoomNum.Text);
  m_WaitTime.dtWaitTime := edtHouBan.Time;
  m_WaitTime.dtCallTime := edtJiaoBan.Time;
  m_WaitTime.dtChuQinTime := edtChuQin.Time;
  m_WaitTime.dtKaiCheTime := edtKaiche.Time;
  m_WaitTime.bMustSleep := chk_MustSleep.Checked;
end;

end.
