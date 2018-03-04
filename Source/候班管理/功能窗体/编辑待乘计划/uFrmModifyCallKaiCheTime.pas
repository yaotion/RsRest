unit uFrmModifyCallKaiCheTime;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RzEdit, ComCtrls, RzDTP,uWaitWork,uGlobalDM,DateUtils,
  uWaitWorkMgr,uTFSystem, RzSpnEdt;

type
  TFrmEditCallKaiCheTime = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    dtpDay: TRzDateTimePicker;
    dtpTime: TRzDateTimePicker;
    btnOK: TButton;
    btnCancel: TButton;
    Label3: TLabel;
    dtpKaiCheDate: TRzDateTimePicker;
    dtpKaiCheTime: TRzDateTimePicker;
    edtElapse: TRzSpinEdit;
    Label4: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure dtpKaiCheDateChange(Sender: TObject);
    procedure dtpKaiCheTimeChange(Sender: TObject);
    procedure edtElapseChange(Sender: TObject);
  private
    //待乘计划
    m_plan:TWaitWorkPlan;
    //待乘管理
    m_waitWorkMgr:TWaitworkMgr;
  private
    {功能:获取新的叫班时间}
    function GetNewCallTime():TDateTime;
    {功能:校验输入数据}
    function CheckData():Boolean;
    {功能:根据开车时间和间隔计算叫班时间}
    procedure CalcCallTime();
  end;
  {功能:修改待乘计划叫班时间}
  function ModifyKaiCheCallTime(plan:TWaitWorkPlan):Boolean;


implementation
uses
  ufrmQuestionBox;

{$R *.dfm}
function ModifyKaiCheCallTime(plan:TWaitWorkPlan):Boolean;
var
  Frm: TFrmEditCallKaiCheTime;
begin
  result := False;
  frm:= TFrmEditCallKaiCheTime.Create(nil);
  try
    Frm.m_plan := plan;
    if Frm.ShowModal = mrOk then
    begin
      result := True;
    end;
  finally
    Frm.Free;
  end;
end;
procedure TFrmEditCallKaiCheTime.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmEditCallKaiCheTime.btnOKClick(Sender: TObject);
var
  strMessage:string;
begin
  if CheckData = False  then Exit;
  m_plan.dtWaitWorkTime := AssembleDateTime(dtpKaiCheDate.Date,dtpKaiCheTime.Time);
  m_plan.dtCallWorkTime := GetNewCallTime;
  m_plan.bNeedSyncCall := true;

  strMessage :=  Format('确认对房间: [%s] 修改叫班时间?',[m_plan.strRoomNum]) ;
  if not tfMessageBox(strMessage,MB_ICONQUESTION) then
    Exit;

  m_waitWorkMgr.ModifyCallTime(m_plan,GlobalDM.bEnableOnesCall);
  ModalResult := mrOk;
end;

procedure TFrmEditCallKaiCheTime.CalcCallTime;
var
  dtKaiCheTime : TDateTime ;
  dtCallTime :  TDateTime ;
  nElapse : integer ;
begin
  dtKaiCheTime  := AssembleDateTime(dtpKaiCheDate.Date,dtpKaiCheTime.Time);
  nElapse := edtElapse.IntValue;
  if nElapse <0  then
    nElapse := 30 ;
  dtCallTime := IncMinute(dtKaiCheTime,-nElapse) ;
  dtpDay.DateTime := dtCallTime ;
  dtpTime.DateTime := dtCallTime ;
end;

function TFrmEditCallKaiCheTime.CheckData: Boolean;
begin
  result := False;
  {if GetNewCallTime <= m_plan.dtWaitWorkTime then
  begin
    TtfPopBox.ShowBox('叫班时间必须大于候班时间!');
    Exit;
  end;  }
  result := True;
end;

procedure TFrmEditCallKaiCheTime.dtpKaiCheDateChange(Sender: TObject);
begin
  CalcCallTime;
end;

procedure TFrmEditCallKaiCheTime.dtpKaiCheTimeChange(Sender: TObject);
begin
  CalcCallTime;
end;

procedure TFrmEditCallKaiCheTime.edtElapseChange(Sender: TObject);
begin
  if edtElapse.Value < 0 then
    edtElapse.Value := 30 ;
  CalcCallTime ;
end;

procedure TFrmEditCallKaiCheTime.FormCreate(Sender: TObject);  
var
  str:string ;
begin
  m_waitWorkMgr:=TWaitworkMgr.GetInstance(GlobalDM.LocalADOConnection);
  dtpKaiCheDate.Format := 'yyyy-MM-dd' ;
  dtpKaiCheTime.Format := 'HH:mm:00';

  dtpDay.Format := 'yyyy-MM-dd' ;
  dtpTime.Format := 'HH:mm:00';
end;

procedure TFrmEditCallKaiCheTime.FormShow(Sender: TObject);
begin
  dtpKaiCheDate.DateTime := now ;
  dtpKaiCheTime.DateTime := now ;

  dtpDay.Date := now ;
  dtpTime.Time := now ;
end;

function TFrmEditCallKaiCheTime.GetNewCallTime: TDateTime;
begin
  dtpDay.Time:= dtpTime.Time;
  result := dtpDay.DateTime;
end;

end.
