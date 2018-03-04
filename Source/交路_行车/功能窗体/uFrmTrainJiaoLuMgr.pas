unit uFrmTrainJiaoLuMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, RzPanel,uTrainJiaolu,uDBTrainJiaolu,
  uWorkShop,uDBWorkShop,uFrmTrainJiaoluEdit,uTFSystem;

type
  TFrmTrainJiaoLuMgr = class(TForm)
    pnl1: TRzPanel;
    btnAdd: TButton;
    btnModify: TButton;
    btnDel: TButton;
    pnl2: TRzPanel;
    lv1: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnModifyClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure lv1DblClick(Sender: TObject);
  private
    //获取车间信息
    procedure InitWorkShop();
    //刷新记录
    procedure ReFreshData();
    //查找记录
    function FinWorkShop(strGUID:string;var workShop:RRsWorkShop):Boolean;
  private
    //车间数组
    m_WorkShopAry:TRsWorkShopArray;
    //车间数据库操作
    m_DBWorkShop:TRsDBWorkShop;
    //交路数组
    m_TrainjiaoluAry:TRsTrainJiaoluArray;
    //交路数据库操作
    m_DBTrainJiaolu:TRsDBTrainJiaolu;
  public
    { Public declarations }
  end;


implementation

uses
  uGlobalDM,
  utfPopBox ;

{$R *.dfm}

procedure TFrmTrainJiaoLuMgr.btnAddClick(Sender: TObject);
var
  trainjiaolu:RRsTrainJiaolu;
begin
  if TFrmTrainJiaoLuEdit.Add(trainjiaolu)= True then
  begin
    ReFreshData();
  end;
end;

procedure TFrmTrainJiaoLuMgr.btnDelClick(Sender: TObject);
var
  sel:RRsTrainJiaolu;
  selItem:TListItem;
begin
  selItem := lv1.Selected;
  if selItem = nil then
  begin
    TtfPopBox.ShowBox('未选择有效的记录');
    Exit;
  end;
  if not tbox('确认删除吗') then
    exit ;
  sel := m_TrainjiaoluAry[selItem.Index];
  m_DBTrainJiaolu.del(sel.strTrainJiaoluGUID);
  ReFreshData;
end;


procedure TFrmTrainJiaoLuMgr.btnModifyClick(Sender: TObject);
var
  sel:RRsTrainJiaolu;
  selItem:TListItem;
begin
  selItem := lv1.Selected;
  if selItem = nil then
  begin
    TtfPopBox.ShowBox('未选择有效的记录');
    Exit;
  end;
  sel := m_TrainjiaoluAry[selItem.Index];
  if TFrmTrainJiaoLuEdit.Modify(sel) = True then
    ReFreshData;

end;




function TFrmTrainJiaoLuMgr.FinWorkShop(strGUID:string;var workShop:RRsWorkShop):Boolean;
var
  i:Integer;
begin
  result := False;
  for i := 0 to length(m_WorkShopAry) - 1 do
  begin
    if m_WorkShopAry[i].strWorkShopGUID = strGUID then
    begin
      workShop := m_workShopAry[i];
      result := True;
      Exit;
    end;
  end;
end;

procedure TFrmTrainJiaoLuMgr.FormCreate(Sender: TObject);
begin
  m_DBWorkShop:=TRsDBWorkShop.Create(GlobalDM.LocalADOConnection);
  m_DBTrainJiaolu:=TRsDBTrainJiaolu.Create(GlobalDM.LocalADOConnection);
end;

procedure TFrmTrainJiaoLuMgr.FormDestroy(Sender: TObject);
begin
  m_DBWorkShop.Free;
  m_DBTrainJiaolu.Free;
end;


procedure TFrmTrainJiaoLuMgr.FormShow(Sender: TObject);
begin
  pnl1.Visible := GlobalDM.bLeaveLine;
  InitWorkShop;
  ReFreshData;
end;

procedure TFrmTrainJiaoLuMgr.InitWorkShop;
begin
  m_DBWorkShop.GetAllWorkShop(m_WorkShopAry);
end;

procedure TFrmTrainJiaoLuMgr.lv1DblClick(Sender: TObject);
begin
  btnModify.Click;
end;

procedure TFrmTrainJiaoLuMgr.ReFreshData;
var
  i:Integer;
  item:TListItem;
  workShop:RRsWorkShop;
begin
  lv1.Items.Clear;
  m_DBTrainJiaolu.GetAllTrainJiaolu(m_TrainjiaoluAry);
  for i := 0 to Length(m_TrainjiaoluAry)- 1 do
  begin
    item := lv1.Items.Add;
    item.Caption := IntToStr(i+1);

    if FinWorkShop(m_TrainjiaoluAry[i].strWorkShopGUID,workShop) = True then
    begin
      item.SubItems.Add(workShop.strWorkShopName);
    end
    else
    begin
      item.SubItems.Add('');
    end;

    item.SubItems.Add(m_TrainjiaoluAry[i].strTrainJiaoluName);
    item.SubItems.Add(m_TrainjiaoluAry[i].strTrainJiaoluGUID);
  end;
    
end;



end.
