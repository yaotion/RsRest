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
    //�����豸����
    m_RoomDevAry:TCallDevAry;
    //��Ԣ�а����
    m_RoomCallApp:TRoomCallApp;


  private
    {����:��ȡѡ�м�¼}
    function GetSelData(var roomDev:RCallDev):Boolean;
    {����:����б�}
    procedure FillGrid();
    {����:�����}
    procedure FillLine(nRow:Integer;roomDev:RCallDev);
    {����:��ʼ���б�}
    procedure InitGird(nRowCount:Integer);

  public
    {ˢ������}
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
    TtfPopBox.ShowBox('��Ч��������!');
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
    TtfPopBox.ShowBox('��Ч��������');
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
