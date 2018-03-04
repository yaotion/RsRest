unit uFrmSiteMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, RzPanel,uArea,uDBArea,uWorkShop,
  uDBWorkShop,uSite,uDBSite,uGlobalDM,uFrmSiteEdit,uTFSystem,uFrmTrainJiaoluSel,
  uDBTrainJiaolu,uTrainJiaolu;

type
  TFrmSiteMgr = class(TForm)
    pnl1: TRzPanel;
    btnAdd: TButton;
    btnModify: TButton;
    btnDel: TButton;
    pnl2: TRzPanel;
    lv1: TListView;
    btnTrainJiaolu: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnModifyClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnTrainJiaoluClick(Sender: TObject);
    procedure lv1DblClick(Sender: TObject);
  private
    //机务段数组
    m_AreaAry:TAreaArray;
    //机务段db操作
    m_DBArea:TRsDBArea;
    //车间数组
    m_WorkShopAry:TRsWorkShopArray;
    //车间db操作
    m_dbWorkShop:TRsDBWorkShop;
    //客户端列表
    m_SiteAry:TRsSiteArray;
    //客户端db操作
    m_DBSite:TRsDBSite;
    //交路数据库操作
    m_DBTrainJiaolu:TRsDBTrainJiaolu;
    //交路列表
    m_TrainjiaoLuAry:TRsTrainJiaoluArray;
  private
    //显示数据
    procedure ReFreashData();
    //获取机务段名称
    function GetAreaName(strAreaGUID:string):string;
    //获取车间名称
    function GetWorkShopName(strWorkShopGUID:string):string;
  public
    { Public declarations }
  end;

implementation
uses
  utfPopBox ;

{$R *.dfm}

procedure TFrmSiteMgr.btnAddClick(Sender: TObject);
var
  site:RRsSiteInfo;
begin
  if TFrmSiteEdit.Add(site) = True then
    ReFreashData();
end;

procedure TFrmSiteMgr.btnDelClick(Sender: TObject);
var
  ListItem:TListItem;
  site:RRsSiteInfo;
begin
  listItem:= lv1.Selected;
  if ListItem = nil then
  begin
    TtfPopBox.ShowBox('未选择有效行!');
    Exit;
  end;
  site := m_siteAry[listItem.Index];
  m_DBSite.Del(site.strSiteGUID);
    ReFreashData;
end;

procedure TFrmSiteMgr.btnModifyClick(Sender: TObject);
var
  ListItem:TListItem;
  site:RRsSiteInfo;
begin
  listItem:= lv1.Selected;
  if ListItem = nil then
  begin
    TtfPopBox.ShowBox('未选择有效行!');
    Exit;
  end;
  site := m_siteAry[listItem.Index];
  if TFrmSiteEdit.Modify(site) = True then
    ReFreashData;

end;

procedure TFrmSiteMgr.btnTrainJiaoluClick(Sender: TObject);
var
  ListItem:TListItem;
  site:RRsSiteInfo;
  Site_TrainJiaoluAry:TRsTrainJiaoluArray;
  selGUIDList:TStringList;
begin
  listItem:= lv1.Selected;
  if ListItem = nil then
  begin
    TtfPopBox.ShowBox('未选择有效行!');
    Exit;
  end;
  site := m_siteAry[listItem.Index];
  m_DBTrainJiaolu.GetTrainJiaoluArrayOfSite(site.strSiteGUID,Site_TrainJiaoluAry);
  selGUIDList:=TStringList.Create;
  try
    if TFrmTrainJiaoSel.SelTrainJiaoLu(m_TrainjiaoLuAry,Site_TrainJiaoluAry,selGUIDList)= False then Exit;
    //修改
    m_DBTrainJiaolu.updateSiteJiaoluRel(site.strSiteGUID,selGUIDList);
  finally
    selGUIDList.Free;
  end;
end;

procedure TFrmSiteMgr.FormCreate(Sender: TObject);
begin
  m_DBArea:=TRsDBArea.Create;
  m_dbWorkShop:=TRsDBWorkShop.Create(GlobalDM.LocalADOConnection);
  m_DBSite:=TRsDBSite.Create(GlobalDM.LocalADOConnection);
  m_DBTrainJiaolu:=TRsDBTrainJiaolu.Create(GlobalDM.LocalADOConnection);
end;

procedure TFrmSiteMgr.FormDestroy(Sender: TObject);
begin
  m_DBArea.Free;
  m_dbWorkShop.Free;
  m_DBSite.Free;
  m_DBTrainJiaolu.Free;
end;

procedure TFrmSiteMgr.FormShow(Sender: TObject);
begin
  pnl1.Visible := GlobalDM.bLeaveLine;
  SetLength(m_AreaAry,0);
  m_DBArea.GetAreas(GlobalDM.LocalADOConnection,m_AreaAry);
  SetLength(m_WorkShopAry,0);
  m_dbWorkShop.GetAllWorkShop(m_WorkShopAry);
  m_DBTrainJiaolu.GetAllTrainJiaolu(m_TrainjiaoLuAry);
  ReFreashData;
end;

function TFrmSiteMgr.GetAreaName(strAreaGUID: string): string;
var
  i:Integer;
begin
  result := '';
  for i := 0 to Length(m_AreaAry) - 1 do
  begin
    if m_AreaAry[i].strAreaGUID = strAreaGUID then
    begin
      result := m_AreaAry[i].strAreaName;
      Exit;
    end;
  end;
end;

function TFrmSiteMgr.GetWorkShopName(strWorkShopGUID: string): string;
var
  i:Integer;
begin
  result := '';
  for i := 0 to Length(m_WorkShopAry) - 1 do
  begin
    if m_WorkShopAry[i].strWorkShopGUID = strWorkShopGUID then
    begin
      result := m_WorkShopAry[i].strWorkShopName;
      Exit;
    end;
  end;
end;

procedure TFrmSiteMgr.lv1DblClick(Sender: TObject);
begin
  btnModify.Click;
end;

procedure TFrmSiteMgr.ReFreashData;
var
  i:Integer;
  listItem:TListItem;
begin
  m_DBSite.GetSites(GlobalDM.LocalADOConnection,m_SiteAry);
  lv1.Items.Clear;
  for i := 0 to Length(m_SiteAry) - 1 do
  begin
    listItem := lv1.Items.Add;
    listItem.Caption := IntToStr(i+1);
    listItem.SubItems.Add(m_SiteAry[i].strSiteIP);
    listItem.SubItems.Add(m_SiteAry[i].strSiteName);
    listItem.SubItems.Add(GetAreaName(m_SiteAry[i].strAreaGUID));
    listItem.SubItems.Add(GetWorkShopName(m_SiteAry[i].strWorkShopGUID));
    listItem.SubItems.Add(m_SiteAry[i].strSiteGUID);
  end;
end;

end.
