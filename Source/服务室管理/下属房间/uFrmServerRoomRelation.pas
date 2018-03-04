unit uFrmServerRoomRelation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,uRoomCall,uRoomCallApp, Grids, AdvObj, BaseGrid, AdvGrid, StdCtrls,
  ExtCtrls, RzPanel;

type
  TFrmServerRoomRelation = class(TForm)
    pnlTop: TRzPanel;
    btnAdd: TButton;
    btnModify: TButton;
    btnDel: TButton;
    btnRefresh: TButton;
    pnlBody: TRzPanel;
    GridCallDev: TAdvStringGrid;
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnModifyClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
  private
      //房间设备
    m_RoomDev:RCallDev;
    //房间设备数组
    m_ServerRoomRelationAry:TServerRoomRelationAry;
    //公寓叫班管理
    m_RoomCallApp:TRoomCallApp;
  private
    {功能:获取选中记录}
    function GetSelData(var ServerRoomRelation:RServerRoomRelation):Boolean;
    {功能:填充列表}
    procedure FillGrid();
    {功能:填充行}
    procedure FillLine(nRow:Integer;ServerRoomRelation:RServerRoomRelation);
    {功能:初始化列表}
    procedure InitGird(nRowCount:Integer);

  public
    {刷新数据}
    procedure ReFreshData();
  end;

    {功能:修改房间设备配置}
  function ManagerSleepRoom(var dev:RCallDev):Boolean;

var
  FrmServerRoomRelation: TFrmServerRoomRelation;

implementation
uses
  uTFSystem,utfPopBox,ufrmTextInput2 ;


function ManagerSleepRoom(var dev:RCallDev):Boolean;
var
  Frm: TFrmServerRoomRelation;
begin
  Result := False;
  Frm:= TFrmServerRoomRelation.Create(nil);
  Frm.Caption := Frm.Caption + Format('[%s] 服务室管理',[dev.strRoomNum]) ;
  try
    Frm.m_RoomDev := dev;
    if Frm.ShowModal = mrOk then
    begin
      result := True;
    end;
  finally
    Frm.Free;
  end;
end;

{$R *.dfm}

procedure TFrmServerRoomRelation.btnAddClick(Sender: TObject);
var
  strNum:string;
  strSleepRoomNumber:string;
  ServerRoomRelation:RServerRoomRelation;
begin
  ServerRoomRelation.strGUID := NewGUID ;
  ServerRoomRelation.strNumber := m_RoomDev.strRoomNum ;
  try
  if InputText('请输入房间号','房间号',strSleepRoomNumber) then
  begin
    ServerRoomRelation.strRoomNum := strSleepRoomNumber ;
    if m_RoomCallApp.DBServerRoomDev.IsExistSleepRoom(strSleepRoomNumber,strNum) then
    begin
      BoxErr('该房间已经关联服务室 ['+strNum+' ]');
      Exit;
    end;


    m_RoomCallApp.DBServerRoomDev.AddSleepRoom(ServerRoomRelation);
    ReFreshData();
  end;
  except
    on e:exception do
    begin
      BoxErr(e.Message);
    end;
  end;
end;

procedure TFrmServerRoomRelation.btnDelClick(Sender: TObject);
var
  ServerRoomRelation:RServerRoomRelation;
begin
  if GetSelData(ServerRoomRelation) = False then
  begin
    TtfPopBox.ShowBox('无效的数据行!');
    Exit;
  end;
  if not TBox('确认删除吗') then
    Exit ;
  m_RoomCallApp.DBServerRoomDev.DeleteSleepRoom(ServerRoomRelation.strGUID);
  ReFreshData();
end;

procedure TFrmServerRoomRelation.btnModifyClick(Sender: TObject);
var
  strNum:string;
  strSleepRoomNumber:string;
  ServerRoomRelation:RServerRoomRelation;
begin
  if GetSelData(ServerRoomRelation) = False then
  begin
    TtfPopBox.ShowBox('无效的数据行');
    Exit;
  end;

  strSleepRoomNumber := ServerRoomRelation.strRoomNum;
  try
    if InputText('请输入房间号','房间号',strSleepRoomNumber) then
    begin
      //
      if m_RoomCallApp.DBServerRoomDev.IsExistSleepRoom(strSleepRoomNumber,strNum) then
      begin
        BoxErr('该房间已经关联服务室 ['+strNum+' ]');
        Exit;
      end;

      ServerRoomRelation.strRoomNum := strSleepRoomNumber;
      m_RoomCallApp.DBServerRoomDev.ModifySleepRoom(ServerRoomRelation) ;
      ReFreshData();
    end;
  except
    on e:exception do
    begin
      BoxErr(e.Message);
    end;
  end;
end;

procedure TFrmServerRoomRelation.btnRefreshClick(Sender: TObject);
begin
  ReFreshData ;
end;

procedure TFrmServerRoomRelation.FillGrid;
var
  i:Integer;
begin
  InitGird(Length(m_ServerRoomRelationAry)) ;
  for I := 0 to Length(m_ServerRoomRelationAry) - 1 do
  begin
    FillLine(i+1,m_ServerRoomRelationAry[i]);
  end;
end;

procedure TFrmServerRoomRelation.FillLine(nRow: Integer;
  ServerRoomRelation: RServerRoomRelation);
begin
  GridCallDev.Cells[0,nRow] := IntToStr(nRow);
  GridCallDev.Cells[1,nRow] := ServerRoomRelation.strNumber;
  GridCallDev.Cells[2,nRow] := ServerRoomRelation.strRoomNum;
end;

procedure TFrmServerRoomRelation.FormCreate(Sender: TObject);
begin
  m_RoomCallApp:=TRoomCallApp.GetInstance;;
end;

procedure TFrmServerRoomRelation.FormShow(Sender: TObject);
begin
    ReFreshData;
end;

function TFrmServerRoomRelation.GetSelData(
  var ServerRoomRelation: RServerRoomRelation): Boolean;
var
  nRealRow:Integer;
begin
  Result := False;
  nRealRow :=GridCallDev.RealRow  ;
  if (nRealRow >= 1) and (nRealRow <= Length(m_ServerRoomRelationAry )) then
  begin
    ServerRoomRelation := m_ServerRoomRelationAry[nRealRow-1];
    Result := True;
  end;
end;

procedure TFrmServerRoomRelation.InitGird(nRowCount: Integer);
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

procedure TFrmServerRoomRelation.ReFreshData;
begin
  m_RoomCallApp.DBServerRoomDev.GetAllSleepRoom(m_RoomDev.strRoomNum,m_ServerRoomRelationAry);
  FillGrid();
end;

end.
