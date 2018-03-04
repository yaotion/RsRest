unit uFrmCallDevMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, AdvObj, BaseGrid, AdvGrid, ExtCtrls, RzPanel,
  uFrmEditCallDev,uRoomCall,uRoomCallApp,uTFSystem;

type
  TFrmCallDevMgr = class(TForm)
    pnlTop: TRzPanel;
    pnlBody: TRzPanel;
    GridCallDev: TAdvStringGrid;
    btnAdd: TButton;
    btnModify: TButton;
    btnDel: TButton;
    btnRefresh: TButton;
    procedure btnAddClick(Sender: TObject);
    procedure btnModifyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
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
  end;

implementation

uses
  utfPopBox ;

{$R *.dfm}

procedure TFrmCallDevMgr.btnAddClick(Sender: TObject);
var
  newDev:RCallDev;
begin
  if CreateRoomDev(newDev) = False then Exit;
  ReFreshData();

end;

procedure TFrmCallDevMgr.btnDelClick(Sender: TObject);
var
  selData:RCallDev;
begin
  if GetSelData(selData) = False then
  begin
    TtfPopBox.ShowBox('无效的数据行!');
    Exit;
  end;
  m_RoomCallApp.DBCallDev.Delete(selData.strGUID);
  ReFreshData();
end;

procedure TFrmCallDevMgr.btnModifyClick(Sender: TObject);
var
  selDev:RCallDev;
begin
  if GetSelData(selDev) = False then
  begin
    TtfPopBox.ShowBox('无效的数据行');
    Exit;
  end;
  if ModifyRoomDev(selDev) = False then Exit;
  ReFreshData();
end;

procedure TFrmCallDevMgr.btnRefreshClick(Sender: TObject);
begin
  ReFreshData();
end;

procedure TFrmCallDevMgr.FillGrid;
var
  i:Integer;
begin
  InitGird(Length(m_RoomDevAry)) ;
  for I := 0 to Length(m_RoomDevAry) - 1 do
  begin
    FillLine(i+1,m_roomDevAry[i]);
  end;
end;

procedure TFrmCallDevMgr.FillLine(nRow: Integer; roomDev: RCallDev);
begin
  GridCallDev.Cells[0,nRow] := IntToStr(nRow);
  GridCallDev.Cells[1,nRow] := roomDev.strRoomNum;
  GridCallDev.Cells[2,nRow] := IntToStr(roomDev.nDevNum);
end;

procedure TFrmCallDevMgr.FormCreate(Sender: TObject);
begin
  m_RoomCallApp:=TRoomCallApp.GetInstance;
end;

procedure TFrmCallDevMgr.FormShow(Sender: TObject);
begin
  ReFreshData();
end;

function TFrmCallDevMgr.GetSelData(var roomDev: RCallDev): Boolean;
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

procedure TFrmCallDevMgr.InitGird(nRowCount: Integer);
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

procedure TFrmCallDevMgr.ReFreshData;
begin
  m_RoomCallApp.DBCallDev.GetAll(m_RoomDevAry);
  FillGrid();
end;

end.
