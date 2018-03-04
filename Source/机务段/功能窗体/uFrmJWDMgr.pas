unit uFrmJWDMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, RzPanel,uFrmJWDEdit,uDBArea,uArea,
  uGlobalDM,uTFSystem;

type
  TFrmJWDMgr = class(TForm)
    pnl1: TRzPanel;
    pnl2: TRzPanel;
    btnAdd: TButton;
    btnModify: TButton;
    btnDel: TButton;
    lv1: TListView;
    procedure btnAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnModifyClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure lv1DblClick(Sender: TObject);
  private
    //刷新记录
    procedure ReFreshData();
  private
    //机务段
    m_AreaAry:TAreaArray;
    //机务段数据库操作
    m_DBArea:TRSDBArea;
  public
    { Public declarations }
  end;


implementation
uses
  utfPopBox ;

{$R *.dfm}

procedure TFrmJWDMgr.btnAddClick(Sender: TObject);
var
  area:RRSArea;
begin
  if TFrmJWDEdit.Add(area)= True then
  begin
    ReFreshData();
  end;
end;

procedure TFrmJWDMgr.btnDelClick(Sender: TObject);
var
  selArea:RRsArea;
  selItem:TListItem;
begin
  selItem := lv1.Selected;
  if selItem = nil then
  begin
    TtfPopBox.ShowBox('未选择有效的记录');
    Exit;
  end;
  if m_DBArea.GetAreaByGUID(GlobalDM.LocalADOConnection,selItem.SubItems.Strings[2],selArea)= False then
  begin
    TtfPopBox.ShowBox('未选择有效的记录');
    Exit;
  end;
  if not tbox('确认删除吗') then
    exit ;
  m_DBArea.Del(GlobalDM.LocalADOConnection,selArea.strAreaGUID);
  ReFreshData;
end;

procedure TFrmJWDMgr.btnModifyClick(Sender: TObject);
var
  selArea:RRsArea;
  selItem:TListItem;
begin
  selItem := lv1.Selected;
  if selItem = nil then
  begin
    TtfPopBox.ShowBox('未选择有效的记录');
    Exit;
  end;
  if m_DBArea.GetAreaByGUID(GlobalDM.LocalADOConnection,selItem.SubItems.Strings[2],selArea)= False then
  begin
    TtfPopBox.ShowBox('未选择有效的记录');
    Exit;
  end;
  if TFrmJWDEdit.Modity(selArea) = True then
    ReFreshData;

end;

procedure TFrmJWDMgr.FormCreate(Sender: TObject);
begin
  m_DBArea:=TRSDBArea.Create;
end;

procedure TFrmJWDMgr.FormDestroy(Sender: TObject);
begin
  m_DBArea.Free;
end;

procedure TFrmJWDMgr.FormShow(Sender: TObject);
begin
  ReFreshData;
  pnl1.Visible :=  GlobalDM.bLeaveLine;
  
end;

procedure TFrmJWDMgr.lv1DblClick(Sender: TObject);
begin
  btnModify.Click;
end;

procedure TFrmJWDMgr.ReFreshData;
var
  i:Integer;
  item:TListItem;
begin
  lv1.Items.Clear;
  m_DBArea.GetAreas(GlobalDM.LocalADOConnection,m_AreaAry);
  for i := 0 to  Length(m_AreaAry)- 1 do
  begin
    item := lv1.Items.Add;
    item.Caption := IntToStr(i+1);
    item.SubItems.Add(m_areaAry[i].strJWDNumber);
    item.SubItems.Add(m_areaary[i].strAreaName);
    item.SubItems.Add(m_AreaAry[i].strAreaGUID);
  end;
    
end;

end.
