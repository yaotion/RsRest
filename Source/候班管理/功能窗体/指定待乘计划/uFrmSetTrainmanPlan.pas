unit uFrmSetTrainmanPlan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Grids, AdvObj, BaseGrid, AdvGrid, StdCtrls, ExtCtrls,
  RzPanel, RzLabel,uTrainman,uWaitWork,uDBWaitWork,uGlobalDM,DateUtils,
  uDBLocalTrainman,uFrmEditWaitWork,uWaitWorkMgr,uTFSystem;

type
  TFrmSetTrainmanPlan = class(TForm)
    rzpnl1: TRzPanel;
    lblTitle: TLabel;
    rzpnl2: TRzPanel;
    GridTrainman: TAdvStringGrid;
    tvRoom: TTreeView;
    rzpnl3: TRzPanel;
    btnNewPlan: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tvRoomClick(Sender: TObject);
    procedure GridTrainmanCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure FormShow(Sender: TObject);
    procedure btnNewPlanClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    //入寓计划列表
    //m_PlanList:TWaitWorkPlanList;
    //待乘计划数据库操作
    //m_DBPlan:TDBWaitWorkPlan;
    //指定计划
    m_DestPlan:TWaitWorkPlan;
    //待乘管理
    m_waitworkMgr:TWaitWorkMgr;
    //人员数据库操作
    m_DBTrainman : TRsDBLocalTrainman;
  private
    {功能:填充入寓计划房间列表}
    procedure FillInRoomPlanList();
    {功能:填充房间人员信息}
    procedure UpdateTrainmanPlanInfo(plan:TWaitWorkPlan);
  public
    CurTrainman:RRsTrainman;
  end;
  {功能:指定人员所属待乘计划}
  function SetTrainmanWaitWorkPlan(trainman:RRsTRainman;var plan:TWaitWorkPlan):Boolean;


implementation

uses
  utfPopBox ;

{$R *.dfm}
function SetTrainmanWaitWorkPlan(trainman:RRsTRainman;var plan:TWaitWorkPlan):Boolean;
var
  frm: TFrmSetTrainmanPlan;
begin
  result:= False;
  frm:= TFrmSetTrainmanPlan.Create(nil);
  try
    frm.CurTrainman:= trainman;
    if frm.ShowModal = mrOk then
    begin
      plan := frm.m_DestPlan;
      Result := True;
    end;
  finally
    frm.Free;
  end;
end;
procedure TFrmSetTrainmanPlan.UpdateTrainmanPlanInfo(plan: TWaitWorkPlan);
var
  tmPlan:TWaitWorkTrainmanInfo;
  rsTrainman:RRsTrainman;
  i:Integer;
begin
  for i := 0 to plan.tmPlanList.Count - 1 do
  begin
    tmPlan := plan.tmPlanList.Items[i];
    GridTrainman.Cells[1,i] := tmPlan.strTrainmanGUID;
    if m_DBTrainman.GetTrainman(tmPlan.strTrainmanGUID,rsTrainman) = True then
    begin
      GridTrainman.Cells[2,i] := rsTrainman.strTrainmanNumber;
      GridTrainman.Cells[3,i] := rsTrainman.strTrainmanName;
    end;

  end;
end;

procedure TFrmSetTrainmanPlan.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //m_PlanList.Free;
  //m_DBPlan.Free;
end;

procedure TFrmSetTrainmanPlan.FormCreate(Sender: TObject);
begin
  //m_PlanList:=TWaitWorkPlanList.create;
  //m_DBPlan:=TDBWaitWorkPlan.Create(GlobalDM.LocalADOConnection);
  m_waitworkMgr:=TWaitWorkMgr.GetInstance(GlobalDM.LocalADOConnection)
end;


procedure TFrmSetTrainmanPlan.FormDestroy(Sender: TObject);
begin
  m_DBTrainman.Free;
end;

procedure TFrmSetTrainmanPlan.FormShow(Sender: TObject);
begin
  lblTitle.Caption := Format('待入寓人员 工号:[%s] 姓名:[%s]',
          [CurTrainman.strTrainmanNumber,CurTrainman.strTrainmanName]);
end;

procedure TFrmSetTrainmanPlan.GridTrainmanCanEditCell(Sender: TObject; ARow,
  ACol: Integer; var CanEdit: Boolean);
begin
  CanEdit := False;
end;

procedure TFrmSetTrainmanPlan.tvRoomClick(Sender: TObject);
var
  node:TTreeNode;
  plan:TWaitWorkPlan;
begin
  node := tvRoom.Selected;
  plan := TWaitWorkPlan(node.Data);
  UpdateTrainmanPlanInfo(plan);
end;

procedure TFrmSetTrainmanPlan.btnCancelClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

procedure TFrmSetTrainmanPlan.btnNewPlanClick(Sender: TObject);
var
  plan:TWaitWorkPlan;
begin
  if CreateWaitWorkPlan(plan) = False then Exit;
  if Assigned(plan.tmPlanList.findTrainman(self.CurTrainman.strTrainmanGUID)) then
  begin
    m_DestPlan := plan;
    Self.ModalResult := mrOk;
  end;
  {
  node := tvRoom.Items.AddChild(nil,plan.strRoomNum);
  node.Data := plan;
  node.Selected := True;
  UpdateTrainmanPlanInfo(plan); }
end;

procedure TFrmSetTrainmanPlan.btnOKClick(Sender: TObject);
var
  node:TTreeNode;
  plan :TWaitWorkPlan;
  strMsg:string;
begin
  node := tvRoom.Selected;
  plan := TWaitWorkPlan(node);
  if not Assigned(plan.AddTrainman(CurTrainman,strMsg)) then
  begin
    TtfPopBox.ShowBox(strMsg);
    Exit;
  end;
  m_waitworkMgr.ModifyPlan(plan);
  m_DestPlan := plan;
  Self.ModalResult := mrOk;
end;

procedure TFrmSetTrainmanPlan.FillInRoomPlanList;
var
  i:Integer;
  node:TTreeNode;
begin
  //m_DBPlan.GetAll(Today);
  for i := 0 to m_waitworkMgr.PlanList.Count - 1 do
  begin
    node := tvRoom.Items.AddChild(nil,m_waitworkMgr.PlanList.Items[i].strRoomNum);
    node.Data := m_waitworkMgr.PlanList.Items[i];
  end;

end;

end.
