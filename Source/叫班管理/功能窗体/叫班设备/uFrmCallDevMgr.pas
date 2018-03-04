unit uFrmCallDevMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, AdvObj, BaseGrid, AdvGrid, ExtCtrls, RzPanel,
  uFrmEditCallDev,uRoomCall,uRoomCallApp,uTFSystem;

type

  TSendRoomThread = class(TThread)
  public
    constructor Create(Handle:THandle;RoomDevAry:TCallDevAry);
  protected
    {执行}
    procedure Execute; override;
    {添加日志}
    procedure InsertLog(Text:String);
  public
    procedure SetLogEvent(OnEventByString:TOnEventByString);
  private
    m_RoomDevAry:TCallDevAry;
    m_RoomCallApp : TRoomCallApp ;  //检测是否有呼叫
    m_Handle:       THandle;        //消息句柄
    m_OnLogEvent : TOnEventByString ;
  end;

  TFrmCallDevMgr = class(TForm)
    pnlTop: TRzPanel;
    pnlBody: TRzPanel;
    GridCallDev: TAdvStringGrid;
    btnAdd: TButton;
    btnModify: TButton;
    btnDel: TButton;
    btnRefresh: TButton;
    btnSendDeviceInfo: TButton;
    mmoLog: TMemo;
    procedure btnAddClick(Sender: TObject);
    procedure btnModifyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSendDeviceInfoClick(Sender: TObject);
  private
    //房间设备数组
    m_RoomDevAry:TCallDevAry;
    //公寓叫班管理
    m_RoomCallApp:TRoomCallApp;


  private
    {功能：添加日志}
    procedure AddMemLog(Log:string);
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
  utfPopBox,ufrmQuestionBox ;

{$R *.dfm}

procedure TFrmCallDevMgr.AddMemLog(Log: string);
begin
  mmoLog.Lines.Add(Log);
end;

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

procedure TFrmCallDevMgr.btnSendDeviceInfoClick(Sender: TObject);
var
  strMsg:string;
  thread : TSendRoomThread ;
begin

  if not tfMessageBox('向主机发送房间对照表吗') then
    Exit;

{$IFDEF DEBUG}
  if m_RoomCallApp.CallDevOp.OpenPort = False then
  begin
    AddMemLog('端口打开失败!');
    Exit;
  end;
{$ENDIF}
  if m_RoomCallApp.CallDevOp.bCalling then
  begin
    AddMemLog('正在叫班,');
    Exit;
  end;



  tfMessageBox('开始发送房间信息,请稍等',MB_ICONINFORMATION);

  mmoLog.Lines.Clear ;
  thread := TSendRoomThread.Create(Self.Handle,m_RoomDevAry);
  thread.SetLogEvent(AddMemLog);
  thread.Resume ;
  thread.WaitFor;
  thread.Terminate;
  thread.Free ;
  tfMessageBox('发送房间信息完成',MB_ICONINFORMATION);

//  tfMessageBox('开始发送房间数量',MB_ICONINFORMATION);
//
//  //发送房间数量
//  m_RoomCallApp.CallDevOp.SetRoomCount(Length(m_RoomDevAry)) ;
//  tfMessageBox('开始发送房间信息',MB_ICONINFORMATION);
//  //发送房间信息
//  m_RoomCallApp.CallDevOp.SendMultiDeviceInfo(m_RoomDevAry);
//
//  tfMessageBox('发送完毕',MB_ICONINFORMATION);
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

{ TSendRoomThread }

constructor TSendRoomThread.Create(Handle: THandle; RoomDevAry: TCallDevAry);
begin
  m_Handle := Handle ;
  m_RoomDevAry := RoomDevAry ;
  inherited Create(True);
end;

procedure TSendRoomThread.Execute;
var
  i : Integer ;
  strText,strRoom:string ;
  nDevice:Word ;
begin
  inherited;
  m_RoomCallApp:=TRoomCallApp.GetInstance;


  InsertLog('开始发送房间数量');

  //发送房间数量
  if  m_RoomCallApp.CallDevOp.SetRoomCount(Length(m_RoomDevAry)) <> 1 then
  begin
    InsertLog('发送房间数量失败');
    Exit ;
  end;
  InsertLog('开始发送房间信息');
  //发送房间信息
  m_RoomCallApp.CallDevOp.SendMultiDeviceInfo(m_RoomDevAry);

  for I := 0 to Length(m_RoomDevAry) - 1 do
  begin
    strRoom := m_RoomDevAry[i].strRoomNum ;
    if m_RoomCallApp.CallDevOp.FindIDByRoom(strRoom,nDevice) then
    begin
      if nDevice <> m_RoomDevAry[i].nDevNum then
       InsertLog('房间失败:'+strRoom);
    end
    else
    begin
      InsertLog('检查房间失败:'+strRoom);
    end;
  end;

  InsertLog('发送完毕');
end;

procedure TSendRoomThread.InsertLog(Text: String);
begin
  if Assigned(m_OnLogEvent) then
    m_OnLogEvent(Text) ;
end;

procedure TSendRoomThread.SetLogEvent(OnEventByString: TOnEventByString);
begin
  m_OnLogEvent := OnEventByString ;
end;

end.
