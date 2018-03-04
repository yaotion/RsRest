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
    {ִ��}
    procedure Execute; override;
    {�����־}
    procedure InsertLog(Text:String);
  public
    procedure SetLogEvent(OnEventByString:TOnEventByString);
  private
    m_RoomDevAry:TCallDevAry;
    m_RoomCallApp : TRoomCallApp ;  //����Ƿ��к���
    m_Handle:       THandle;        //��Ϣ���
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
    //�����豸����
    m_RoomDevAry:TCallDevAry;
    //��Ԣ�а����
    m_RoomCallApp:TRoomCallApp;


  private
    {���ܣ������־}
    procedure AddMemLog(Log:string);
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

procedure TFrmCallDevMgr.btnSendDeviceInfoClick(Sender: TObject);
var
  strMsg:string;
  thread : TSendRoomThread ;
begin

  if not tfMessageBox('���������ͷ�����ձ���') then
    Exit;

{$IFDEF DEBUG}
  if m_RoomCallApp.CallDevOp.OpenPort = False then
  begin
    AddMemLog('�˿ڴ�ʧ��!');
    Exit;
  end;
{$ENDIF}
  if m_RoomCallApp.CallDevOp.bCalling then
  begin
    AddMemLog('���ڽа�,');
    Exit;
  end;



  tfMessageBox('��ʼ���ͷ�����Ϣ,���Ե�',MB_ICONINFORMATION);

  mmoLog.Lines.Clear ;
  thread := TSendRoomThread.Create(Self.Handle,m_RoomDevAry);
  thread.SetLogEvent(AddMemLog);
  thread.Resume ;
  thread.WaitFor;
  thread.Terminate;
  thread.Free ;
  tfMessageBox('���ͷ�����Ϣ���',MB_ICONINFORMATION);

//  tfMessageBox('��ʼ���ͷ�������',MB_ICONINFORMATION);
//
//  //���ͷ�������
//  m_RoomCallApp.CallDevOp.SetRoomCount(Length(m_RoomDevAry)) ;
//  tfMessageBox('��ʼ���ͷ�����Ϣ',MB_ICONINFORMATION);
//  //���ͷ�����Ϣ
//  m_RoomCallApp.CallDevOp.SendMultiDeviceInfo(m_RoomDevAry);
//
//  tfMessageBox('�������',MB_ICONINFORMATION);
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


  InsertLog('��ʼ���ͷ�������');

  //���ͷ�������
  if  m_RoomCallApp.CallDevOp.SetRoomCount(Length(m_RoomDevAry)) <> 1 then
  begin
    InsertLog('���ͷ�������ʧ��');
    Exit ;
  end;
  InsertLog('��ʼ���ͷ�����Ϣ');
  //���ͷ�����Ϣ
  m_RoomCallApp.CallDevOp.SendMultiDeviceInfo(m_RoomDevAry);

  for I := 0 to Length(m_RoomDevAry) - 1 do
  begin
    strRoom := m_RoomDevAry[i].strRoomNum ;
    if m_RoomCallApp.CallDevOp.FindIDByRoom(strRoom,nDevice) then
    begin
      if nDevice <> m_RoomDevAry[i].nDevNum then
       InsertLog('����ʧ��:'+strRoom);
    end
    else
    begin
      InsertLog('��鷿��ʧ��:'+strRoom);
    end;
  end;

  InsertLog('�������');
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
