unit uFrmNotifyNotOutRoom;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, AdvObj, BaseGrid, AdvGrid, RzPanel,
  uWaitWork,uWaitWorkMgr,uPubFun,uGlobalDM,uRoomCallApp;

type
  TFrmNotifyNotOutRoom = class(TForm)
    lbl_Nofity: TLabel;
    pnl1: TRzPanel;
    pnl2: TRzPanel;
    lbl3: TLabel;
    lbl1: TLabel;
    lbl4: TLabel;
    lbl2: TLabel;
    edtWaitTime: TEdit;
    edtRoomNum: TEdit;
    edtTrainNo: TEdit;
    edtCallTime: TEdit;
    pnl4: TRzPanel;
    Grid1: TAdvStringGrid;
    btnCancel: TButton;
    tmrAutoClose: TTimer;
    btnReCall: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnReCallClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrAutoCloseTimer(Sender: TObject);
  private
    //候班计划
    m_WaitPlan:TWaitWorkPlan;
    //候班管理
    m_WaitWorkMgr:TWaitWorkMgr;
    //叫班管理器
    m_CallMgr:TRoomCallApp;
    //窗体关闭倒计时
    m_nCloseLeftSecond:Integer;
  public
    property WaitPlan :TWaitWorkPlan read m_WaitPlan write m_WaitPlan;

  private
    {功能:显示候班计划}
    procedure showWaitPlan();
  public
    {功能:未离寓提醒}
    //class function NotOutRoomNotify(waitPlan:TWaitWorkPlan):TFrmNotifyNotOutRoom;
  end;



implementation

{$R *.dfm}

{ TFrmNotifyNotOutRoom }

procedure TFrmNotifyNotOutRoom.btnCancelClick(Sender: TObject);
begin
  self.ModalResult := mrCancel;
end;

procedure TFrmNotifyNotOutRoom.btnReCallClick(Sender: TObject);
begin
  m_WaitPlan.dtCallWorkTime := GlobalDM.GetNow;
  m_WaitWorkMgr.PublishCallPlan(m_WaitPlan);
  self.ModalResult := mrOk;
end;

procedure TFrmNotifyNotOutRoom.FormCreate(Sender: TObject);
begin
  m_WaitWorkMgr:=TWaitWorkMgr.GetInstance(nil);
  m_CallMgr:=TRoomCallApp.GetInstance;
  m_WaitPlan:=TWaitWorkPlan.Create;
end;

procedure TFrmNotifyNotOutRoom.FormDestroy(Sender: TObject);
begin
  m_WaitPlan.Free;
  m_CallMgr.CallDevOp.StopPlaySound;
end;

procedure TFrmNotifyNotOutRoom.FormShow(Sender: TObject);
begin
  m_nCloseLeftSecond:= 20;
  lbl_Nofity.Caption :=  Format('%d秒后自动重叫',[m_nCloseLeftSecond]);
  showWaitPlan();
  m_CallMgr.CallDevOp.PlaySoundFileLoop(GlobalDM.AppPath + 'Sounds\'+'未离寓提示.wav');
end;

{class procedure TFrmNotifyNotOutRoom.NotOutRoomNotify(waitPlan: TWaitWorkPlan);
var
  FrmNotifyNotOutRoom: TFrmNotifyNotOutRoom;
begin
  FrmNotifyNotOutRoom:= TFrmNotifyNotOutRoom.Create(nil);
  try
    FrmNotifyNotOutRoom.m_WaitPlan.Clone(waitPlan);
    FrmNotifyNotOutRoom.ShowModal;
  finally
    FrmNotifyNotOutRoom.Free;
  end;
end;  }

procedure TFrmNotifyNotOutRoom.showWaitPlan;
var
  i:Integer;
begin
  edtTrainNo.Text := m_WaitPlan.strCheCi;
  edtWaitTime.Text :=  TPubFun.DateTime2Str(m_WaitPlan.dtWaitWorkTime);
  edtCallTime.Text := TPubFun.DateTime2Str(m_WaitPlan.dtCallWorkTime);
  edtRoomNum.Text := m_WaitPlan.strRoomNum;
  for i := 0 to m_WaitPlan.tmPlanList.Count - 1 do
  begin
    Grid1.Cells[0,i+1] := m_WaitPlan.tmPlanList.Items[i].strTrainmanNumber;
    Grid1.Cells[1,i+1] := m_WaitPlan.tmPlanList.Items[i].strTrainmanName;
    Grid1.Cells[2,i+1] := m_WaitPlan.tmPlanList.Items[i].strRealRoom;
  end;

end;

procedure TFrmNotifyNotOutRoom.tmrAutoCloseTimer(Sender: TObject);
begin
  Dec(m_nCloseLeftSecond);
  lbl_Nofity.Caption :=  Format('%d秒后自动重叫',[m_nCloseLeftSecond]);
  if m_nCloseLeftSecond= 0 then
  begin
    tmrAutoClose.Enabled := False;
    btnReCallClick(nil);
  end;

end;

end.
