unit uFrmJoinRoomManager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uRoomCall,uRoomCallApp,uWaitWork,uGlobalDM,DateUtils,
  uWaitWorkMgr;

type
  TFrmJoinRoomManager = class(TForm)
    grpLianJiao: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    DstList: TListBox;
    btnAddRoom: TButton;
    btnDelRoom: TButton;
    SrcList: TListBox;
    btnOK: TButton;
    btnCancel: TButton;
    procedure btnAddRoomClick(Sender: TObject);
    procedure btnDelRoomClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
      //房间设备数组
    m_RoomDevAry:TCallDevAry;
    //公寓叫班管理
    m_RoomCallApp:TRoomCallApp;
    //待乘计划
    m_plan:TWaitWorkPlan;
    //待乘管理
    m_waitWorkMgr:TWaitworkMgr;
  private
    {功能:初始化}
    procedure InitData();
    {功能：初始化房间}
    procedure InitRooms();
    {功能:初始化联交房间}
    procedure InitLianJiaoRoom();
    {功能:获取新的叫班时间}
    function GetNewCallTime():TDateTime;
    {功能:校验输入数据}
    function CheckData():Boolean;
  private
    { Private declarations }
    procedure AddToJoinRoom();
    procedure DelFromJoinRoom();

    procedure MoveSelected(List: TCustomListBox; Items: TStrings);
    procedure SetItem(List: TListBox; Index: Integer);
    function GetFirstSelection(List: TCustomListBox): Integer;
    procedure SetButtons;
  public
    { Public declarations }
    class function Edit(plan:TWaitWorkPlan):Boolean;
  end;

var
  FrmJoinRoomManager: TFrmJoinRoomManager;

implementation
uses
  uTFSystem,ufrmQuestionBox;

{$R *.dfm}

procedure TFrmJoinRoomManager.AddToJoinRoom;
var
  Index: Integer;
  i : integer ;
begin
  Index := GetFirstSelection(SrcList);
  if Index < 0 then
    exit ;

  if SrcList.Items.Strings[Index] = Trim(m_plan.strRoomNum) then
  begin
    BoxErr('不能联叫自己');
    exit ;
  end;

  for I := 0 to DstList.Items.Count - 1 do
  begin
    if DstList.Items.Strings[I] = SrcList.Items.Strings[Index] then
    begin
      BoxErr('不能重复添加');
      exit ;
    end;
  end;

  MoveSelected(SrcList, DstList.Items);
  SetItem(SrcList, Index);
end;

procedure TFrmJoinRoomManager.btnAddRoomClick(Sender: TObject);
begin
  AddToJoinRoom;
end;

procedure TFrmJoinRoomManager.btnCancelClick(Sender: TObject);
begin
  ModalResult:= mrCancel ;
end;

procedure TFrmJoinRoomManager.btnDelRoomClick(Sender: TObject);
begin
  DelFromJoinRoom;
end;

procedure TFrmJoinRoomManager.btnOKClick(Sender: TObject);
begin
  if CheckData = False  then Exit;
  m_plan.JoinRoomList.Clear;
  m_plan.JoinRoomList.Assign(DstList.Items);
  m_waitWorkMgr.ModifyCallJoinRooms(m_plan,GlobalDM.bEnableOnesCall);
  ModalResult := mrOk;
end;

function TFrmJoinRoomManager.CheckData: Boolean;
var
  i : Integer ;
  plan : TWaitWorkPlan ;
begin
  Result := False ;

  for I := 0 to DstList.Items.Count - 1 do
  begin
    plan :=m_WaitWorkMgr.FindPlanByRoom(DstList.Items[i]);
    if Assigned (plan)   then
    begin
      if plan.strPlanGUID <> m_plan.strPlanGUID then
      begin
        tfMessageBox('房间:[' + plan.strRoomNum + ']已安排计划',MB_ICONINFORMATION);
        Exit;
      end;
    end;
  end;
  Result := True ;
end;

procedure TFrmJoinRoomManager.DelFromJoinRoom;
var
  Index: Integer;
begin
  Index := GetFirstSelection(DstList);
  if Index <0 then
    exit ;
  MoveSelected(DstList, SrcList.Items);
  SetItem(DstList, Index);
end;

class function TFrmJoinRoomManager.Edit(plan:TWaitWorkPlan): Boolean;
var
  Frm: TFrmJoinRoomManager;
begin
  result := False;
  frm:= TFrmJoinRoomManager.Create(nil);
  try
    Frm.m_plan := plan;
    Frm.InitData;
    if Frm.ShowModal = mrOk then
    begin
      result := True;
    end;
  finally
    Frm.Free;
  end;
end;

procedure TFrmJoinRoomManager.FormCreate(Sender: TObject);
begin
  m_RoomCallApp:=TRoomCallApp.GetInstance;
  m_waitWorkMgr:=TWaitworkMgr.GetInstance(GlobalDM.LocalADOConnection);
end;

procedure TFrmJoinRoomManager.FormDestroy(Sender: TObject);
begin
  ;
end;

function TFrmJoinRoomManager.GetFirstSelection(List: TCustomListBox): Integer;
begin
  for Result := 0 to List.Items.Count - 1 do
    if List.Selected[Result] then Exit;
  Result := LB_ERR;
end;

function TFrmJoinRoomManager.GetNewCallTime: TDateTime;
begin

end;

procedure TFrmJoinRoomManager.InitData;
begin
  InitRooms;
  InitLianJiaoRoom;
end;

procedure TFrmJoinRoomManager.InitLianJiaoRoom;
var
  i : Integer ;
  j : Integer;
begin
  DstList.Items.Clear;
  for I := 0 to m_plan.JoinRoomList.Count - 1 do
  begin
    DstList.Items.Add(m_plan.JoinRoomList.Strings[i]);
  end;
end;

procedure TFrmJoinRoomManager.InitRooms;
var
  i : Integer ;
begin
  m_RoomCallApp.DBCallDev.GetAll(m_RoomDevAry);
  for I := 0 to Length(m_RoomDevAry) - 1 do
  begin
    SrcList.Items.Add(m_RoomDevAry[i].strRoomNum);
  end;
end;

procedure TFrmJoinRoomManager.MoveSelected(List: TCustomListBox;
  Items: TStrings);
var
  I: Integer;
begin
  for I := List.Items.Count - 1 downto 0 do
    if List.Selected[I] then
    begin
      Items.AddObject(List.Items[I], List.Items.Objects[I]);
      List.Items.Delete(I);
    end;
end;

procedure TFrmJoinRoomManager.SetButtons;
var
  SrcEmpty, DstEmpty: Boolean;
begin
  SrcEmpty := SrcList.Items.Count = 0;
  DstEmpty := DstList.Items.Count = 0;
  btnAddRoom.Enabled := not SrcEmpty;
  btnDelRoom.Enabled := not DstEmpty;
end;

procedure TFrmJoinRoomManager.SetItem(List: TListBox; Index: Integer);
var
  MaxIndex: Integer;
begin
  with List do
  begin
    SetFocus;
    MaxIndex := List.Items.Count - 1;
    if Index = LB_ERR then Index := 0
    else if Index > MaxIndex then Index := MaxIndex;
    Selected[Index] := True;
  end;
  SetButtons;
end;

end.
