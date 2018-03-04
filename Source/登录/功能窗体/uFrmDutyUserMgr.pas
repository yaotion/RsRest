unit uFrmDutyUserMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, RzPanel,uDutyUser,uDBDutyUser,
  uFrmDutyUserEdit,uTFSystem,uGlobalDM;

type

  TFrmDutyUserMgr = class(TForm)
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
    //刷新记录
    procedure ReFreshData();

  private
    //管理员数据库操作
    m_DBDutyUser:TRSDBDutyUser;
    //管理员对象列表
    m_DutyUserList:TRsDutyUserList;
  public
    { Public declarations }
  end;


implementation

uses
  utfPopBox ;

{$R *.dfm}

procedure TFrmDutyUserMgr.btnAddClick(Sender: TObject);
var
  dutyUser:TRsDutyUser;
begin
  dutyUser := TRsDutyUser.Create;
  try
    if TFrmDutyUserEdit.Add(dutyUser)= True then
    begin
      ReFreshData();
    end;
  finally
    dutyUser.Free;
  end;
end;

procedure TFrmDutyUserMgr.btnDelClick(Sender: TObject);
var
  sel:TRsDutyUser;
  selItem:TListItem;
begin
  selItem := lv1.Selected;
  if selItem = nil then
  begin
    TtfPopBox.ShowBox('未选择有效的记录');
    Exit;
  end;
  sel:= m_DutyUserList.Items[selItem.Index];
  m_DBDutyUser.del(sel.strDutyGUID);
  ReFreshData;
end;

procedure TFrmDutyUserMgr.btnModifyClick(Sender: TObject);
var
  sel:TRsDutyUser;
  selItem:TListItem;
begin
  selItem := lv1.Selected;
  if selItem = nil then
  begin
    TtfPopBox.ShowBox('未选择有效的记录');
    Exit;
  end;
  sel := m_DutyUserList.Items[selItem.Index];
  if TFrmDutyUserEdit.Modify(sel) = True then
    ReFreshData;

end;

procedure TFrmDutyUserMgr.FormCreate(Sender: TObject);
begin
  m_DBDutyUser:=TRSDBDutyUser.Create(GlobalDM.LocalADOConnection);
  m_DutyUserList:=TRsDutyUserList.Create;
end;

procedure TFrmDutyUserMgr.FormDestroy(Sender: TObject);
begin
  m_DBDutyUser.Free;
  m_DutyUserList.Free;
end;

procedure TFrmDutyUserMgr.FormShow(Sender: TObject);
begin
  
  pnl1.Visible := GlobalDM.bLeaveLine;
  ReFreshData;
end;


procedure TFrmDutyUserMgr.lv1DblClick(Sender: TObject);
begin
  btnModify.Click;
end;

procedure TFrmDutyUserMgr.ReFreshData;
var
  i:Integer;
  item:TListItem;
begin
  lv1.Items.Clear;
  m_DutyUserList.Clear;
  m_DBDutyUser.GetAllDutyUser(m_DutyUserList);
  for i := 0 to  m_DutyUserList.Count- 1 do
  begin
    item := lv1.Items.Add;
    item.Caption := IntToStr(i+1);
    item.SubItems.Add(m_DutyUserList.Items[i].strDutyNumber);
    item.SubItems.Add(m_DutyUserList.Items[i].strDutyName);
    item.SubItems.Add(m_DutyUserList.Items[i].strDutyGUID);
  end;
    
end;

end.
