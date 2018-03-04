unit uFrmWorkShopMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, RzPanel,uWorkShop,uDBWorkShop,
  uFrmWorkShopEdit,uTFSystem,uGlobalDM,uDBArea,uArea;

type

  TFrmWorkShopMgr = class(TForm)
    pnl1: TRzPanel;
    btnAdd: TButton;
    btnModify: TButton;
    btnDel: TButton;
    pnl2: TRzPanel;
    lv1: TListView;
  procedure btnAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnModifyClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure lv1DblClick(Sender: TObject);
  private
    //获取机务段信息
    procedure InitJWD();
    //刷新记录
    procedure ReFreshData();
    //查找记录
    function FinWorkShop(strGUID:string;var workShop:RRsWorkShop):Boolean;
    //查找机务段
    function FindArea(strGUID:string;var area:RRsArea):Boolean;
  private
    //车间数组
    m_WorkShopAry:TRsWorkShopArray;
    //机务段数组
    m_AreaAry:TAreaArray;
    //车间数据库操作
    m_DBWorkShop:TRsDBWorkShop;
    //机务段数据库操作
    m_DBArea:TRsDBArea;
  public
    { Public declarations }
  end;


implementation

uses
  utfPopBox ;

{$R *.dfm}

procedure TFrmWorkShopMgr.btnAddClick(Sender: TObject);
var
  workshop:RRsWorkShop;
begin
  if TFrmWorkShopEdit.Add(workshop)= True then
  begin
    ReFreshData();
  end;
end;

procedure TFrmWorkShopMgr.btnDelClick(Sender: TObject);
var
  sel:RRsWorkShop;
  selItem:TListItem;
begin
  selItem := lv1.Selected;
  if selItem = nil then
  begin
    TtfPopBox.ShowBox('未选择有效的记录');
    Exit;
  end;
  if FinWorkShop(selItem.SubItems.Strings[3],sel) = False then
  begin
    TtfPopBox.ShowBox('未选择有效的记录');
    Exit;
  end;
  if not tbox('确认删除吗?') then
    exit ;
  m_DBWorkShop.del(sel.strWorkShopGUID);
  ReFreshData;
end;

procedure TFrmWorkShopMgr.btnModifyClick(Sender: TObject);
var
  sel:RRsWorkShop;
  selItem:TListItem;
begin
  selItem := lv1.Selected;
  if selItem = nil then
  begin
    TtfPopBox.ShowBox('未选择有效的记录');
    Exit;
  end;
  if FinWorkShop(selItem.SubItems.Strings[3],sel) = False then
  begin
    TtfPopBox.ShowBox('未选择有效的记录');
    Exit;
  end;
  if TFrmWorkShopEdit.Modify(sel) = True then
    ReFreshData;

end;

function TFrmWorkShopMgr.FindArea(strGUID: string;var area:RRsArea):Boolean;
var
  i:Integer;
begin
  result := False;
  for i := 0 to Length(m_AreaAry) - 1 do
  begin
    if m_AreaAry[i].strAreaGUID =strGUID then
    begin
      area := m_areaAry[i];
      result := True;
      Exit;
    end;
  end;
end;

function TFrmWorkShopMgr.FinWorkShop(strGUID:string;var workShop:RRsWorkShop):Boolean;
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

procedure TFrmWorkShopMgr.FormCreate(Sender: TObject);
begin
  m_DBWorkShop:=TRsDBWorkShop.Create(GlobalDM.LocalADOConnection);
  m_DBArea:=TRsDBArea.Create;
end;

procedure TFrmWorkShopMgr.FormDestroy(Sender: TObject);
begin
  m_DBWorkShop.Free;
  m_DBArea.Free;
end;

procedure TFrmWorkShopMgr.FormShow(Sender: TObject);
begin
  pnl1.Visible := GlobalDM.bLeaveLine;
  InitJWD;
  ReFreshData;
end;

procedure TFrmWorkShopMgr.InitJWD;
begin
  m_DBArea.GetAreas(GlobalDM.LocalADOConnection,m_AreaAry);
end;

procedure TFrmWorkShopMgr.lv1DblClick(Sender: TObject);
begin
  btnModify.Click;
end;

procedure TFrmWorkShopMgr.ReFreshData;
var
  i:Integer;
  item:TListItem;
  area:RRsArea;
begin
  lv1.Items.Clear;
  m_DBWorkShop.GetAllWorkShop(m_WorkShopAry);
  for i := 0 to  Length(m_WorkShopAry)- 1 do
  begin
    item := lv1.Items.Add;
    item.Caption := IntToStr(i+1);

    if FindArea(m_WorkShopAry[i].strAreaGUID,area) = True then
    begin
      item.SubItems.Add(area.strAreaName);
    end
    else
    begin
      item.SubItems.Add('');
    end;
    

    item.SubItems.Add(m_WorkShopAry[i].strWorkShopNumber);
    item.SubItems.Add(m_WorkShopAry[i].strWorkShopName);
    item.SubItems.Add(m_WorkShopAry[i].strWorkShopGUID);
  end;
    
end;

end.
