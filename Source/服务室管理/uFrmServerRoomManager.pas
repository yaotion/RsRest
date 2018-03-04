unit uFrmServerRoomManager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, AdvObj, BaseGrid, AdvGrid, StdCtrls, ExtCtrls, RzPanel,
  uFrmEditCallDev2,uRoomCall,uRoomCallApp,uTFSystem;

type
  TFrmServerRoomManager = class(TForm)
    pnlTop: TRzPanel;
    btnAdd: TButton;
    btnModify: TButton;
    btnDel: TButton;
    btnRefresh: TButton;
    pnlBody: TRzPanel;
    GridCallDev: TAdvStringGrid;
    btnManager: TButton;
    procedure btnAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnModifyClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnManagerClick(Sender: TObject);
  private
    //房间设备数组
    m_RoomDevAry:TCallDevAry;
    //公寓叫班管理
    m_RoomCallApp:TRoomCallApp;
  private
    {功能:获取选中记录}
    function GetSelData(var roomDev:RCallDev):Boolean;
    {功能:填充列表}
    procedure FillGrid();
    {功能:填充行}
    procedure FillLine(nRow:Integer;roomDev:RCallDev);
    {功能:初始化列表}
    procedure InitGird(nRowCount:Integer);

  public
    {刷新数据}
    procedure ReFreshData();
  public
    { Public declarations }
    class procedure Manager();
  end;

var
  FrmServerRoomManager: TFrmServerRoomManager;

implementation
uses
  utfPopBox,uFrmServerRoomRelation;

{$R *.dfm}

{ TFrmServerRoomManager }

procedure TFrmServerRoomManager.btnAddClick(Sender: TObject);
var
  newDev:RCallDev;
begin
  if CreateServerRoomDev(newDev) = False then Exit;
  ReFreshData();
end;

procedure TFrmServerRoomManager.btnDelClick(Sender: TObject);
var
  selData:RCallDev;
begin
  if GetSelData(selData) = False then
  begin
    TtfPopBox.ShowBox('无效的数据行!');
    Exit;
  end;
  if not TBox('确认删除吗') then
    Exit ;
  m_RoomCallApp.DBServerRoomDev.Delete(selData.strGUID);
  ReFreshData();
end;

procedure TFrmServerRoomManager.btnManagerClick(Sender: TObject);
var
  selDev:RCallDev;
begin
  if GetSelData(selDev) = False then
  begin
    TtfPopBox.ShowBox('无效的数据行');
    Exit;
  end;
  if ManagerSleepRoom(selDev) = False then Exit;
end;

procedure TFrmServerRoomManager.btnModifyClick(Sender: TObject);
var
  selDev:RCallDev;
begin
  if GetSelData(selDev) = False then
  begin
    TtfPopBox.ShowBox('无效的数据行');
    Exit;
  end;
  if ModifyServerRoomDev(selDev) = False then Exit;
  ReFreshData();
end;

procedure TFrmServerRoomManager.btnRefreshClick(Sender: TObject);
begin
  ReFreshData();
end;

procedure TFrmServerRoomManager.FillGrid;
var
  i:Integer;
begin
  InitGird(Length(m_RoomDevAry)) ;
  for I := 0 to Length(m_RoomDevAry) - 1 do
  begin
    FillLine(i+1,m_roomDevAry[i]);
  end;
end;

procedure TFrmServerRoomManager.FillLine(nRow: Integer; roomDev: RCallDev);
begin
  GridCallDev.Cells[0,nRow] := IntToStr(nRow);
  GridCallDev.Cells[1,nRow] := roomDev.strRoomNum;
  GridCallDev.Cells[2,nRow] := IntToStr(roomDev.nDevNum);
end;

procedure TFrmServerRoomManager.FormCreate(Sender: TObject);
begin
  m_RoomCallApp:=TRoomCallApp.GetInstance;
end;

procedure TFrmServerRoomManager.FormShow(Sender: TObject);
begin
  ReFreshData;
end;

function TFrmServerRoomManager.GetSelData(var roomDev: RCallDev): Boolean;
var
  nRealRow:Integer;
begin
  Result := False;
  nRealRow :=GridCallDev.RealRow  ;
  if (nRealRow >= 1) and (nRealRow <= Length(m_RoomDevAry )) then
  begin
    roomDev := m_RoomDevAry[nRealRow-1];
    Result := True;
  end;
end;

procedure TFrmServerRoomManager.InitGird(nRowCount: Integer);
begin
  GridCallDev.ClearRows(1,10000);
  if nRowCount > 0  then
    GridCallDev.RowCount := nRowCount + 1
  else
  begin
    GridCallDev.RowCount := 2;
    GridCallDev.Cells[99,1] := ''
  end;
end;

class procedure TFrmServerRoomManager.Manager;
var
  FrmServerRoomManager: TFrmServerRoomManager ;
begin
  FrmServerRoomManager:= TFrmServerRoomManager.Create(nil);
  try
    FrmServerRoomManager.ShowModal;
  finally
    FrmServerRoomManager.Free;
  end;
end;

procedure TFrmServerRoomManager.ReFreshData;
begin
  m_RoomCallApp.DBServerRoomDev.GetAll(m_RoomDevAry);
  FillGrid();
end;

end.
